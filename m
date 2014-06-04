Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaFDTep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:34:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:40922 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFDTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:34:44 -0400
Date: Wed, 4 Jun 2014 21:34:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] irq core changes for 3.16
Message-ID: <alpine.DEB.2.10.1406042048420.18296@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-core-for-linus

The irq department delivers:

 - Another tree wide update to get rid of the horrible create_irq
   interface along with its even more horrible variants. That also
   gets rid of the last leftovers of the initial sparse irq hackery.
   arch/driver specific changes have been either acked or ignored.

 - A fix for the spurious interrupt detection logic with threaded
   interrupts.

 - A new ARM SoC interrupt controller

 - The usual pile of fixes and improvements all over the place  

Sorry you don't get a diff this time.

BRANCH=irq-core-for-linus
BASE=`git merge-base $BRANCH linus`
git diff -M $BASE..irq-core-for-linus

Is what my script uses for years now, but this time it created a diff
with random extra content from all over the tree.

$BASE is 2ed9fd28c2884e9f41c133f86a7e377d7c0a96bf

Thanks,

	tglx

------------------>
Arnd Bergmann (1):
      ARM: iop13xx: fix msi support with sparse IRQ

Eyal Perry (1):
      genirq: Provide !SMP stub for irq_set_affinity_notifier()

Ezequiel Garcia (1):
      irqchip: armada-370-xp: Move the devicetree binding documentation

Florian Fainelli (2):
      irqchip: brcmstb-l2: Add Broadcom Set Top Box Level-2 interrupt controller
      Documentation: brcmstb-l2: Add Broadcom STB Level-2 interrupt controller binding

Haojian Zhuang (1):
      irqchip: gic: Use mask field in GICC_IAR

Jiang Liu (1):
      genirq: Improve documentation to match current implementation

Sebastian Hesselbarth (1):
      irqchip: orion: Reverse irq handling priority

Thomas Gleixner (33):
      genirq: Sanitize spurious interrupt detection of threaded irqs
      arm: iop13xx: Use sparse irqs for MSI
      mips: Kill pointless destroy_irq()
      genirq: Provide generic hwirq allocation facility
      x86: Implement arch_setup/teardown_hwirq()
      x86: irq_remapping: Use irq_alloc/free_hwirq()
      x86: hpet: Use irq_alloc/free_hwirq()
      x86: uv: Use irq_alloc/free_hwirq()
      x86: htirq: Use irq_alloc/free_irq()
      x86: ioapic: Use irq_alloc/free_hwirq()
      x86: Get rid of get_nr_irqs_gsi()
      iommu: smar: Fix return value check of create_irq()
      iommu: dmar: Provide arch specific irq allocation
      ia64: Remove unused check_irq_used()
      x86: Remove create/destroy_irq()
      tile: Implement irq_alloc/free_hwirq() for migration
      tile: usb: Use irq_alloc/free_hwirq
      tile: net: Use irq_alloc/free_hwirq
      tile: serial: Use irq_alloc/free_hwirq
      tile: hvc: Use irq_alloc/free_hwirq
      tile: pci: Use irq_alloc/free_hwirq()
      tile: Use SPARSE_IRQ
      genirq: Make create/destroy_irq() ia64 private
      x86, irq: Remove pointless irq_reserve_irqs() call
      sh: intc: Remove pointless irq_reserve_irqs() invocation
      s390: pci: Check return value of alloc_irq_desc() proper
      s390: Remove pointless arch_show_interrupts()
      s390: Avoid call to irq_reserve_irqs()
      genirq: Replace reserve_irqs in core code
      genirq: Remove irq_reserve_irq[s]
      genirq: Replace dynamic_irq_init/cleanup
      ia64: Use irq_init_desc
      genirq: Remove dynamic_irq mess

Thomas Petazzoni (2):
      irqchip: irq-armada-370-xp: Do the set_smp_cross_call() in the driver
      irqchip: irq-armada-370-xp: Use cpu notifier to initialize secondary CPUs

