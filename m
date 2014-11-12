Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaKLNmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:42:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:41593 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaKLNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:42:53 -0500
Message-Id: <20141112133941.647950773@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 12 Nov 2014 13:42:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [patch 00/16] genirq: Hierarchical irq domains and generic MSI
 interrupt code
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an extract from Jiangs various patch series which only
contains the generic irq and MSI parts w/o the x86 specific
modifications.

This is roughly what I plan to merge into the generic irq core, so the
various outstanding patches (irqchip/x86/...) can be based on this.

It's available from git as well:

    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/irqdomain

Note, that branch is not yet exposed to linux-next and subject to
modifications including rebasing.

Can all involved parties please have a close look and retest their
patches on top of this?

Jiang, you need to merge that into x86/apic for rebasing your series.

Thanks,

	tglx
----
 Documentation/IRQ-domain.txt           |   71 +++++
 arch/arm/mach-iop13xx/msi.c            |    2 
 arch/ia64/kernel/msi_ia64.c            |    4 
 arch/ia64/sn/kernel/msi_sn.c           |    4 
 arch/mips/pci/msi-octeon.c             |    2 
 arch/mips/pci/msi-xlp.c                |    2 
 arch/mips/pci/pci-xlr.c                |    2 
 arch/powerpc/platforms/cell/axon_msi.c |    2 
 arch/powerpc/platforms/powernv/pci.c   |    2 
 arch/powerpc/platforms/pseries/msi.c   |    2 
 arch/powerpc/sysdev/fsl_msi.c          |    2 
 arch/powerpc/sysdev/mpic_pasemi_msi.c  |    2 
 arch/powerpc/sysdev/mpic_u3msi.c       |    2 
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  |    2 
 arch/powerpc/sysdev/ppc4xx_msi.c       |    2 
 arch/s390/pci/pci.c                    |    2 
 arch/sparc/kernel/pci_msi.c            |    2 
 arch/tile/kernel/pci_gx.c              |    2 
 arch/x86/kernel/apic/io_apic.c         |    4 
 arch/x86/pci/xen.c                     |    4 
 drivers/iommu/irq_remapping.c          |    8 
 drivers/irqchip/irq-armada-370-xp.c    |    2 
 drivers/pci/Kconfig                    |    6 
 drivers/pci/host/pci-tegra.c           |    2 
 drivers/pci/host/pcie-designware.c     |    2 
 drivers/pci/host/pcie-rcar.c           |    2 
 drivers/pci/host/pcie-xilinx.c         |    2 
 drivers/pci/msi.c                      |  150 ++++++-----
 drivers/vfio/pci/vfio_pci_intrs.c      |    2 
 include/linux/irq.h                    |   33 ++
 include/linux/irqdomain.h              |   91 +++++++
 include/linux/irqhandler.h             |   14 +
 include/linux/msi.h                    |   53 +++-
 kernel/irq/Kconfig                     |   15 +
 kernel/irq/Makefile                    |    1 
 kernel/irq/chip.c                      |   37 ++
 kernel/irq/irqdomain.c                 |  418 +++++++++++++++++++++++++++++++--
 kernel/irq/manage.c                    |    2 
 kernel/irq/msi.c                       |  132 ++++++++++
 39 files changed, 959 insertions(+), 130 deletions(-)




