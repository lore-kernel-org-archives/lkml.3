Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaB1Rq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:46:28 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26030 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbaB1Rq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:46:26 -0500
X-IronPort-AV: E=Sophos;i="4.97,563,1389744000"; 
   d="scan'208";a="106694369"
Message-ID: <5310CB6F.1070706@citrix.com>
Date: Fri, 28 Feb 2014 18:46:23 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] xen: add support for MSI message groups
References: <530F68BE.2070505@oracle.com> <1393524935-4216-1-git-send-email-roger.pau@citrix.com> <530F87CC.8090000@oracle.com> <5310C54A.1080906@oracle.com>
In-Reply-To: <5310C54A.1080906@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/14 18:20, Boris Ostrovsky wrote:
> On 02/27/2014 01:45 PM, Boris Ostrovsky wrote:
>> On 02/27/2014 01:15 PM, Roger Pau Monne wrote:
>>> Add support for MSI message groups for Xen Dom0 using the
>>> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
>>>
>>> In order to keep track of which pirq is the first one in the group all
>>> pirqs in the MSI group except for the first one have the newly
>>> introduced PIRQ_MSI_GROUP flag set. This prevents calling
>>> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
>>> first pirq in the group.
>>
>> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>>
>>
> 
> 
> I was just looking at xen_setup_msi_irqs() (for a different reason) and
> I am no longer sure this patch does anything:
> 
> static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> {
>         int irq, ret, i;
>         struct msi_desc *msidesc;
>         int *v;
> 
>         if (type == PCI_CAP_ID_MSI && nvec > 1)
>                 return 1;
> ....
> 
> Same thing for xen_hvm_setup_msi_irqs().

As said in the commit message this is only for Dom0, so the function
modified is xen_initdom_setup_msi_irqs (were this check is removed).

Roger.

