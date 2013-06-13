Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3FMMWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:22:42 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31965 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561Ab3FMMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:29 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        John Stultz <john.stultz@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 00/10] metag: various patches for v3.11
Date: Thu, 13 Jun 2013 13:19:31 +0100
Message-ID: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset consists of various miscellaneous arch/metag patches I
intend to apply for v3.11.

The first two improve clock setup, allowing the core clock frequency to
optionally be determined from device tree clock nodes, and to print out
the core and timer clock frequencies during boot. These are followed by
various fixes from Markos (mostly sparse related).

James Hogan (2):
  metag: init common clk and use "core" clk
  metag: log core and timer frequencies from arch code

Markos Chandras (8):
  metag/kernel/irq.c: Declare root_domain as static
  metag/asm/irq.h: Declare init_IRQ
  metag/mm/cache: Restrict scope for metag_lnkget_probe
  metag/setup: Restrict scope for the capabilities variable
  metag/processor.h: Add missing cpuinfo_op declaration.
  metag/traps: Mark die() as __noreturn to match the declaration.
  metag/traps: include setup.h for the per_cpu_trap_init declaration
  metag/.gitignore: Extend the *.dtb pattern to match the dtb.S files

 Documentation/devicetree/bindings/metag/meta.txt | 30 ++++++++++++
 arch/metag/boot/.gitignore                       |  2 +-
 arch/metag/include/asm/bug.h                     |  4 +-
 arch/metag/include/asm/clock.h                   |  8 ++++
 arch/metag/include/asm/irq.h                     |  1 +
 arch/metag/include/asm/processor.h               |  2 +
 arch/metag/kernel/clock.c                        | 59 +++++++++++++++++++++++-
 arch/metag/kernel/irq.c                          |  2 +-
 arch/metag/kernel/setup.c                        | 12 ++---
 arch/metag/kernel/time.c                         | 14 +++++-
 arch/metag/kernel/traps.c                        |  5 +-
 arch/metag/mm/cache.c                            |  2 +-
 drivers/clocksource/metag_generic.c              |  2 +
 13 files changed, 127 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/metag/meta.txt

Cc: Markos Chandras <markos.chandras@imgtec.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org

-- 
1.8.1.2


