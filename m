Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaJWFl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:41:28 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48451 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaJWFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:41:25 -0400
Date: Wed, 22 Oct 2014 23:41:21 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-arch@vger.kernel.org,
        arnab.basu@freescale.com, Bharat.Bhushan@freescale.com, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xenproject.org, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Liviu Dudau <liviu@dudau.co.uk>
Subject: Re: [PATCH v3 10/27] PCI/MSI: Remove useless bus->msi assignment
Message-ID: <20141023054121.GE11770@google.com>
References: <1413342435-7876-1-git-send-email-wangyijing@huawei.com>
 <1413342435-7876-11-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413342435-7876-11-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 11:06:58AM +0800, Yijing Wang wrote:
> Now msi chip is saved in pci_sys_data in arm,
> we could clean the bus->msi assignment in
> pci core.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> CC: Thierry Reding <thierry.reding@gmail.com>
> CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> ---
>  drivers/pci/probe.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index efa48dc..98bf4c3 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -682,7 +682,6 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
>  
>  	child->parent = parent;
>  	child->ops = parent->ops;
> -	child->msi = parent->msi;

This needs an explanation of why ARM was the only arch to depend on this.

>  	child->sysdata = parent->sysdata;
>  	child->bus_flags = parent->bus_flags;
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
