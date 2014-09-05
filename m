Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaIERah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:30:37 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47412 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaIERaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:30:30 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/16] MIPS: GIC device-tree support
Date: Fri,  5 Sep 2014 10:30:02 -0700
Message-Id: <1409938218-9026-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add support for mapping and routing GIC interrupts through
the device-tree, which will be used on the upcoming interAptiv-based
Danube SoC.

- Patches 1 and 2 provide improvements to the CPU interrupt controller
  when used with DT.
- Patch 3 exports the MIPS CPU IRQ domain so that the GIC driver can
  use it.
- Patch 4 is a fix for secondary CPU bringup with CPS.
- Patches 5 through 9 are misc. GIC cleanups, including moving the GIC
  driver to drivers/irqchip/.
- Patches 10 through 13 add device-tree support for the GIC.
- Patches 14 through 16 cleanup/fix GIC local interrupt support.

Based on 3.17-rc3 and boot tested on Danube (+ out of tree patches) and
Malta.  Build tested for SEAD-3.  Paul Burton has also tested v1 of this
series with his WIP Malta DT support [0].

Changes from v1:
 - updated bindings to drop third interrupt cell and remove CPU interrupt
   controller as the parent of the GIC
 - moved GIC to drivers/irqchip/
 - other minor fixes/cleanups

[0] https://github.com/paulburton/linux/commits/wip-malta-dt

Andrew Bresticker (16):
  MIPS: Provide a generic plat_irq_dispatch
  MIPS: Set vint handler when mapping CPU interrupts
  MIPS: Export CPU IRQ domain
  MIPS: smp-cps: Enable all hardware interrupts on secondary CPUs
  MIPS: Move GIC to drivers/irqchip/
  MIPS: Move MIPS_GIC_IRQ_BASE into platform irq.h
  irqchip: mips-gic: Implement irq_set_type callback
  irqchip: mips-gic: Implement generic irq_ack/irq_eoi callbacks
  irqchip: mips-gic: Fix gic_set_affinity() return value
  of: Add vendor prefix for MIPS Technologies, Inc.
  of: Add binding document for MIPS GIC
  irqchip: mips-gic: Add device-tree support
  irqchip: mips-gic: Add generic IPI support when using DT
  irqchip: mips-gic: Support local interrupts
  MIPS: GIC: Use local interrupts for timer
  MIPS: Malta: Map GIC local interrupts

 .../bindings/interrupt-controller/mips-gic.txt     |  39 ++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/mips/Kconfig                                  |  10 +-
 arch/mips/include/asm/gic.h                        |  36 ++
 arch/mips/include/asm/irq_cpu.h                    |   2 +
 arch/mips/include/asm/mach-generic/irq.h           |   7 +
 arch/mips/include/asm/mach-sead3/irq.h             |   1 +
 arch/mips/include/asm/mips-boards/maltaint.h       |   2 -
 arch/mips/include/asm/mips-boards/sead3int.h       |   2 -
 arch/mips/kernel/Makefile                          |   1 -
 arch/mips/kernel/cevt-gic.c                        |  16 +-
 arch/mips/kernel/cevt-r4k.c                        |   2 +-
 arch/mips/kernel/irq_cpu.c                         |  32 +-
 arch/mips/kernel/smp-cps.c                         |   4 +-
 arch/mips/kernel/smp-mt.c                          |   4 +-
 arch/mips/mti-malta/malta-int.c                    |  44 ++-
 arch/mips/mti-malta/malta-time.c                   |  10 +-
 drivers/irqchip/Kconfig                            |   4 +
 drivers/irqchip/Makefile                           |   1 +
 .../irq-gic.c => drivers/irqchip/irq-mips-gic.c    | 406 ++++++++++++++++++++-
 20 files changed, 567 insertions(+), 57 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/mips-gic.txt
 rename arch/mips/kernel/irq-gic.c => drivers/irqchip/irq-mips-gic.c (50%)

-- 
2.1.0.rc2.206.gedb03e5

