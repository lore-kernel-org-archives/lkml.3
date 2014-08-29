Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaH2WOu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:14:50 -0400
Received: from mail-qg0-f73.google.com ([209.85.192.73]:42279 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaH2WOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:14:46 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] MIPS: GIC device-tree support
Date: Fri, 29 Aug 2014 15:14:27 -0700
Message-Id: <1409350479-19108-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series add support for mapping and routing GIC interrupts through
the device-tree, which will be used on the upcoming interAptiv-based
Danube SoC.

- Patches 1 and 2 provide improvements to the CPU interrupt controller
  when used with DT.
- Patches 3 through 7 add device-tree support for the GIC.
- Patches 8 and 9 are misc. GIC irqchip cleanups.
- Patches 10 through 12 cleanup/fix GIC local interrupt support.

Based on 3.17-rc2 and boot tested on Danube (+ out of tree patches) and
Malta.  Build tested for SEAD-3.  Paul Burton has also tested this series
with his WIP Malta DT support [0].

[0] https://github.com/paulburton/linux/commits/wip-malta-dt

Andrew Bresticker (12):
  MIPS: Provide a generic plat_irq_dispatch
  MIPS: Set vint handler when mapping CPU interrupts
  of: Add binding document for MIPS GIC
  MIPS: GIC: Move MIPS_GIC_IRQ_BASE into platform irq.h
  MIPS: GIC: Add device-tree support
  MIPS: GIC: Add generic IPI support when using DT
  MIPS: GIC: Implement irq_set_type callback
  MIPS: GIC: Implement generic irq_ack/irq_eoi callbacks
  MIPS: GIC: Fix gic_set_affinity() return value
  MIPS: GIC: Support local interrupts
  MIPS: GIC: Use local interrupts for timer
  MIPS: Malta: Map GIC local interrupts

 Documentation/devicetree/bindings/mips/gic.txt |  50 +++
 arch/mips/include/asm/gic.h                    |  36 ++
 arch/mips/include/asm/mach-generic/irq.h       |   8 +
 arch/mips/include/asm/mach-sead3/irq.h         |   1 +
 arch/mips/include/asm/mips-boards/maltaint.h   |   2 -
 arch/mips/include/asm/mips-boards/sead3int.h   |   2 -
 arch/mips/kernel/cevt-gic.c                    |  16 +-
 arch/mips/kernel/irq-gic.c                     | 434 ++++++++++++++++++++++++-
 arch/mips/kernel/irq_cpu.c                     |  32 +-
 arch/mips/mti-malta/malta-int.c                |  44 ++-
 10 files changed, 585 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mips/gic.txt

-- 
2.1.0.rc2.206.gedb03e5

