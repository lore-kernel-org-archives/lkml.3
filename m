Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaB1RSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:18:25 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42324 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaB1RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:18:22 -0500
Message-ID: <5310C54A.1080906@oracle.com>
Date: Fri, 28 Feb 2014 12:20:10 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH v2] xen: add support for MSI message groups
References: <530F68BE.2070505@oracle.com> <1393524935-4216-1-git-send-email-roger.pau@citrix.com> <530F87CC.8090000@oracle.com>
In-Reply-To: <530F87CC.8090000@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 01:45 PM, Boris Ostrovsky wrote:
> On 02/27/2014 01:15 PM, Roger Pau Monne wrote:
>> Add support for MSI message groups for Xen Dom0 using the
>> MAP_PIRQ_TYPE_MULTI_MSI pirq map type.
>>
>> In order to keep track of which pirq is the first one in the group all
>> pirqs in the MSI group except for the first one have the newly
>> introduced PIRQ_MSI_GROUP flag set. This prevents calling
>> PHYSDEVOP_unmap_pirq on them, since the unmap must be done with the
>> first pirq in the group.
>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
>
>


I was just looking at xen_setup_msi_irqs() (for a different reason) and 
I am no longer sure this patch does anything:

static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
{
         int irq, ret, i;
         struct msi_desc *msidesc;
         int *v;

         if (type == PCI_CAP_ID_MSI && nvec > 1)
                 return 1;
....

Same thing for xen_hvm_setup_msi_irqs().

Take a look at commit 884ac2978a295b7df3c4a686d3bff6932bbbb460.


-boris
