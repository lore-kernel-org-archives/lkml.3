Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaHLJJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:09:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58216 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbaHLJJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:09:55 -0400
X-IronPort-AV: E=Sophos;i="5.01,847,1400025600"; 
   d="scan'208";a="160864610"
Message-ID: <53E9D9DD.3060901@citrix.com>
Date: Tue, 12 Aug 2014 10:09:49 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-mips@linux-mips.org>, <linux-ia64@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <sparclinux@vger.kernel.org>,
        <linux-s390@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Joerg Roedel <joro@8bytes.org>, <x86@kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <xen-devel@lists.xenproject.org>, <arnab.basu@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Tony Luck <tony.luck@intel.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, Wuyun <wuyun.wu@huawei.com>,
        <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Xen-devel] [RFC PATCH 01/20] x86/xen/MSI: Eliminate arch_msix_mask_irq()
 and arch_msi_mask_irq()
References: <1407828373-24322-1-git-send-email-wangyijing@huawei.com> <1407828373-24322-2-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1407828373-24322-2-git-send-email-wangyijing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/14 08:25, Yijing Wang wrote:
> Commit 0e4ccb150 added two __weak arch functions arch_msix_mask_irq()
> and arch_msi_mask_irq() to fix a bug found when running xen in x86.
> Introduced these two funcntions make MSI code complex. This patch
> reverted commit 0e4ccb150 and add #ifdef for x86 msi_chip to fix this
> bug for simplicity. Also this is preparation for using struct
> msi_chip instead of weak arch MSI functions in all platforms.
[...]
>  static struct irq_chip msi_chip = {
>  	.name			= "PCI-MSI",
> +#ifdef CONFIG_XEN
> +	.irq_unmask		= nop_unmask_msi_irq,
> +	.irq_mask		= nop_mask_msi_irq,
> +#else
>  	.irq_unmask		= unmask_msi_irq,
>  	.irq_mask		= mask_msi_irq,
> +#endif

No.  CONFIG_XEN kernels can run on Xen and bare metal so this must be a
runtime option.

David
