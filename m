Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaKRJZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:25:17 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:56525 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaKRJZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:25:15 -0500
Message-ID: <546B1059.3010007@huawei.com>
Date: Tue, 18 Nov 2014 17:24:41 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 00/16] genirq: Hierarchical irq domains and generic MSI
 interrupt code
References: <20141112133941.647950773@linutronix.de>
In-Reply-To: <20141112133941.647950773@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Jiang,

I finally get some time on this, hopefully not too late...
In brief, I like the part of stacked domain, and have some opinions on
the part of refactoring MSI. Please check inline comments.

Regards,
	Abel

On 2014/11/12 21:42, Thomas Gleixner wrote:

> This is an extract from Jiangs various patch series which only
> contains the generic irq and MSI parts w/o the x86 specific
> modifications.
> 
> This is roughly what I plan to merge into the generic irq core, so the
> various outstanding patches (irqchip/x86/...) can be based on this.
> 
> It's available from git as well:
> 
>     git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain
> 
> Note, that branch is not yet exposed to linux-next and subject to
> modifications including rebasing.
> 
> Can all involved parties please have a close look and retest their
> patches on top of this?
> 
> Jiang, you need to merge that into x86/apic for rebasing your series.
> 
> Thanks,
> 
> 	tglx
> ----
>  Documentation/IRQ-domain.txt           |   71 +++++
>  arch/arm/mach-iop13xx/msi.c            |    2 
>  arch/ia64/kernel/msi_ia64.c            |    4 
>  arch/ia64/sn/kernel/msi_sn.c           |    4 
>  arch/mips/pci/msi-octeon.c             |    2 
>  arch/mips/pci/msi-xlp.c                |    2 
>  arch/mips/pci/pci-xlr.c                |    2 
>  arch/powerpc/platforms/cell/axon_msi.c |    2 
>  arch/powerpc/platforms/powernv/pci.c   |    2 
>  arch/powerpc/platforms/pseries/msi.c   |    2 
>  arch/powerpc/sysdev/fsl_msi.c          |    2 
>  arch/powerpc/sysdev/mpic_pasemi_msi.c  |    2 
>  arch/powerpc/sysdev/mpic_u3msi.c       |    2 
>  arch/powerpc/sysdev/ppc4xx_hsta_msi.c  |    2 
>  arch/powerpc/sysdev/ppc4xx_msi.c       |    2 
>  arch/s390/pci/pci.c                    |    2 
>  arch/sparc/kernel/pci_msi.c            |    2 
>  arch/tile/kernel/pci_gx.c              |    2 
>  arch/x86/kernel/apic/io_apic.c         |    4 
>  arch/x86/pci/xen.c                     |    4 
>  drivers/iommu/irq_remapping.c          |    8 
>  drivers/irqchip/irq-armada-370-xp.c    |    2 
>  drivers/pci/Kconfig                    |    6 
>  drivers/pci/host/pci-tegra.c           |    2 
>  drivers/pci/host/pcie-designware.c     |    2 
>  drivers/pci/host/pcie-rcar.c           |    2 
>  drivers/pci/host/pcie-xilinx.c         |    2 
>  drivers/pci/msi.c                      |  150 ++++++-----
>  drivers/vfio/pci/vfio_pci_intrs.c      |    2 
>  include/linux/irq.h                    |   33 ++
>  include/linux/irqdomain.h              |   91 +++++++
>  include/linux/irqhandler.h             |   14 +
>  include/linux/msi.h                    |   53 +++-
>  kernel/irq/Kconfig                     |   15 +
>  kernel/irq/Makefile                    |    1 
>  kernel/irq/chip.c                      |   37 ++
>  kernel/irq/irqdomain.c                 |  418 +++++++++++++++++++++++++++++++--
>  kernel/irq/manage.c                    |    2 
>  kernel/irq/msi.c                       |  132 ++++++++++
>  39 files changed, 959 insertions(+), 130 deletions(-)
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> .
> 
> 



