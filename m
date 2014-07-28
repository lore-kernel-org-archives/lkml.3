Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaG1NHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:07:06 -0400
Received: from smtp.citrix.com ([66.165.176.89]:47253 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbaG1NHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:07:01 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156359550"
Message-ID: <53D64AF3.4080202@citrix.com>
Date: Mon, 28 Jul 2014 14:06:59 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <gregkh@linuxfoundation.org>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>, <boris.ostrovsky@oracle.com>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH v5 2/6] xen/pciback: Don't deadlock when unbinding.
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com> <1405354736-7358-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1405354736-7358-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/07/14 17:18, Konrad Rzeszutek Wilk wrote:
> As commit 0a9fd0152929db372ff61b0d6c280fdd34ae8bdb
> 'xen/pciback: Document the entry points for 'pcistub_put_pci_dev''
> explained there are four entry points in this function.
> Two of them are when the user fiddles in the SysFS to
> unbind a device which might be in use by a guest or not.
> 
> Both 'unbind' states will cause a deadlock as the the PCI lock has
> already been taken, which then pci_device_reset tries to take.
> 
> We can simplify this by requiring that all callers of
> pcistub_put_pci_dev MUST hold the device lock. And then
> we can just call the lockless version of pci_device_reset.
> 
> To make it even simpler we will modify xen_pcibk_release_pci_dev
> to quality whether it should take a lock or not - as it ends
> up calling xen_pcibk_release_pci_dev and needs to hold the lock.
> 
> CC: stable@vger.kernel.org

This deadlock is for a rather specific and uncommon use case (manually
unbinding a PCI while it is passed-through). Is this critical enough to
warrant a stable backport?

> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
