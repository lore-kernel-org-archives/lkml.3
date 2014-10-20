Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaJTTHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:07:17 -0400
Received: from mail-ig0-f202.google.com ([209.85.213.202]:54241 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaJTTEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:04:11 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Ralf Baechle <ralf@linux-mips.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] MIPS: Move gic.h to include/linux/irqchip/mips-gic.h
Date: Mon, 20 Oct 2014 12:03:53 -0700
Message-Id: <1413831846-32100-7-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
References: <1413831846-32100-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the MIPS GIC irqchip lives in drivers/irqchip/, move
its header over to include/linux/irqchip/.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/mips/include/asm/mips-boards/maltaint.h                    | 2 +-
 arch/mips/include/asm/mips-boards/sead3int.h                    | 2 +-
 arch/mips/kernel/cevt-gic.c                                     | 2 +-
 arch/mips/kernel/cevt-r4k.c                                     | 2 +-
 arch/mips/kernel/csrc-gic.c                                     | 3 +--
 arch/mips/kernel/smp-cmp.c                                      | 2 +-
 arch/mips/kernel/smp-cps.c                                      | 2 +-
 arch/mips/kernel/smp-gic.c                                      | 2 +-
 arch/mips/kernel/smp-mt.c                                       | 2 +-
 arch/mips/mti-malta/malta-int.c                                 | 2 +-
 arch/mips/mti-malta/malta-time.c                                | 2 +-
 arch/mips/mti-sead3/sead3-ehci.c                                | 2 +-
 arch/mips/mti-sead3/sead3-int.c                                 | 2 +-
 arch/mips/mti-sead3/sead3-net.c                                 | 2 +-
 arch/mips/mti-sead3/sead3-platform.c                            | 2 +-
 arch/mips/mti-sead3/sead3-time.c                                | 2 +-
 drivers/irqchip/irq-mips-gic.c                                  | 2 +-
 arch/mips/include/asm/gic.h => include/linux/irqchip/mips-gic.h | 0
 18 files changed, 17 insertions(+), 18 deletions(-)
 rename arch/mips/include/asm/gic.h => include/linux/irqchip/mips-gic.h (100%)

diff --git a/arch/mips/include/asm/mips-boards/maltaint.h b/arch/mips/include/asm/mips-boards/maltaint.h
index 38b06a0..987ff58 100644
--- a/arch/mips/include/asm/mips-boards/maltaint.h
+++ b/arch/mips/include/asm/mips-boards/maltaint.h
@@ -10,7 +10,7 @@
 #ifndef _MIPS_MALTAINT_H
 #define _MIPS_MALTAINT_H
 
-#include <asm/gic.h>
+#include <linux/irqchip/mips-gic.h>
 
 /*
  * Interrupts 0..15 are used for Malta ISA compatible interrupts
diff --git a/arch/mips/include/asm/mips-boards/sead3int.h b/arch/mips/include/asm/mips-boards/sead3int.h
index 59d6c32..8932c7d 100644
--- a/arch/mips/include/asm/mips-boards/sead3int.h
+++ b/arch/mips/include/asm/mips-boards/sead3int.h
@@ -10,7 +10,7 @@
 #ifndef _MIPS_SEAD3INT_H
 #define _MIPS_SEAD3INT_H
 
-#include <asm/gic.h>
+#include <linux/irqchip/mips-gic.h>
 
 /* SEAD-3 GIC address space definitions. */
 #define GIC_BASE_ADDR		0x1b1c0000
diff --git a/arch/mips/kernel/cevt-gic.c b/arch/mips/kernel/cevt-gic.c
index 4f9262a..9caa68a 100644
--- a/arch/mips/kernel/cevt-gic.c
+++ b/arch/mips/kernel/cevt-gic.c
@@ -10,9 +10,9 @@
 #include <linux/percpu.h>
 #include <linux/smp.h>
 #include <linux/irq.h>
+#include <linux/irqchip/mips-gic.h>
 
 #include <asm/time.h>
-#include <asm/gic.h>
 #include <asm/mips-boards/maltaint.h>
 
 DEFINE_PER_CPU(struct clock_event_device, gic_clockevent_device);
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index fd0ef8d..6acaad0 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -11,10 +11,10 @@
 #include <linux/percpu.h>
 #include <linux/smp.h>
 #include <linux/irq.h>
+#include <linux/irqchip/mips-gic.h>
 
 #include <asm/time.h>
 #include <asm/cevt-r4k.h>
-#include <asm/gic.h>
 
 static int mips_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
diff --git a/arch/mips/kernel/csrc-gic.c b/arch/mips/kernel/csrc-gic.c
index ab615c6..0bf28e6 100644
--- a/arch/mips/kernel/csrc-gic.c
+++ b/arch/mips/kernel/csrc-gic.c
@@ -6,10 +6,9 @@
  * Copyright (C) 2012 MIPS Technologies, Inc.  All rights reserved.
  */
 #include <linux/init.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/time.h>
 
-#include <asm/gic.h>
-
 static cycle_t gic_hpt_read(struct clocksource *cs)
 {
 	return gic_read_count();
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index fc8a515..1e0a93c 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
 #include <linux/compiler.h>
+#include <linux/irqchip/mips-gic.h>
 
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
@@ -37,7 +38,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/mips_mt.h>
 #include <asm/amon.h>
-#include <asm/gic.h>
 
 static void cmp_init_secondary(void)
 {
diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index cd20aca..bed7590 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -9,13 +9,13 @@
  */
 
 #include <linux/io.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/types.h>
 
 #include <asm/bcache.h>
-#include <asm/gic.h>
 #include <asm/mips-cm.h>
 #include <asm/mips-cpc.h>
 #include <asm/mips_mt.h>
diff --git a/arch/mips/kernel/smp-gic.c b/arch/mips/kernel/smp-gic.c
index 3b21a96..5f0ab5b 100644
--- a/arch/mips/kernel/smp-gic.c
+++ b/arch/mips/kernel/smp-gic.c
@@ -12,9 +12,9 @@
  * option) any later version.
  */
 
+#include <linux/irqchip/mips-gic.h>
 #include <linux/printk.h>
 
-#include <asm/gic.h>
 #include <asm/mips-cpc.h>
 #include <asm/smp-ops.h>
 
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index d60475f..ad86951 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/compiler.h>
 #include <linux/smp.h>
 
@@ -34,7 +35,6 @@
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
 #include <asm/mips_mt.h>
-#include <asm/gic.h>
 
 static void __init smvp_copy_vpe_config(void)
 {
diff --git a/arch/mips/mti-malta/malta-int.c b/arch/mips/mti-malta/malta-int.c
index 864d482..6ea4033 100644
--- a/arch/mips/mti-malta/malta-int.c
+++ b/arch/mips/mti-malta/malta-int.c
@@ -18,6 +18,7 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/kernel_stat.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
@@ -33,7 +34,6 @@
 #include <asm/mips-boards/generic.h>
 #include <asm/mips-boards/msc01_pci.h>
 #include <asm/msc01_ic.h>
-#include <asm/gic.h>
 #include <asm/setup.h>
 #include <asm/rtlx.h>
 
diff --git a/arch/mips/mti-malta/malta-time.c b/arch/mips/mti-malta/malta-time.c
index 39f3902..608655f 100644
--- a/arch/mips/mti-malta/malta-time.c
+++ b/arch/mips/mti-malta/malta-time.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/timex.h>
 #include <linux/mc146818rtc.h>
 
@@ -37,7 +38,6 @@
 #include <asm/time.h>
 #include <asm/mc146818-time.h>
 #include <asm/msc01_ic.h>
-#include <asm/gic.h>
 
 #include <asm/mips-boards/generic.h>
 #include <asm/mips-boards/maltaint.h>
diff --git a/arch/mips/mti-sead3/sead3-ehci.c b/arch/mips/mti-sead3/sead3-ehci.c
index 4ddaa0f..014dd7b 100644
--- a/arch/mips/mti-sead3/sead3-ehci.c
+++ b/arch/mips/mti-sead3/sead3-ehci.c
@@ -9,8 +9,8 @@
 #include <linux/irq.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
+#include <linux/irqchip/mips-gic.h>
 
-#include <asm/gic.h>
 #include <asm/mips-boards/sead3int.h>
 
 struct resource ehci_resources[] = {
diff --git a/arch/mips/mti-sead3/sead3-int.c b/arch/mips/mti-sead3/sead3-int.c
index 995c401..5c6b949 100644
--- a/arch/mips/mti-sead3/sead3-int.c
+++ b/arch/mips/mti-sead3/sead3-int.c
@@ -7,9 +7,9 @@
  */
 #include <linux/init.h>
 #include <linux/irq.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/io.h>
 
-#include <asm/gic.h>
 #include <asm/irq_cpu.h>
 #include <asm/setup.h>
 
diff --git a/arch/mips/mti-sead3/sead3-net.c b/arch/mips/mti-sead3/sead3-net.c
index c9f728a..46176b8 100644
--- a/arch/mips/mti-sead3/sead3-net.c
+++ b/arch/mips/mti-sead3/sead3-net.c
@@ -7,10 +7,10 @@
  */
 #include <linux/module.h>
 #include <linux/irq.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/platform_device.h>
 #include <linux/smsc911x.h>
 
-#include <asm/gic.h>
 #include <asm/mips-boards/sead3int.h>
 
 static struct smsc911x_platform_config sead3_smsc911x_data = {
diff --git a/arch/mips/mti-sead3/sead3-platform.c b/arch/mips/mti-sead3/sead3-platform.c
index d9661eb..53ee6f1 100644
--- a/arch/mips/mti-sead3/sead3-platform.c
+++ b/arch/mips/mti-sead3/sead3-platform.c
@@ -7,9 +7,9 @@
  */
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/serial_8250.h>
 
-#include <asm/gic.h>
 #include <asm/mips-boards/sead3int.h>
 
 #define UART(base)							\
diff --git a/arch/mips/mti-sead3/sead3-time.c b/arch/mips/mti-sead3/sead3-time.c
index fd40de3..ec1dd24 100644
--- a/arch/mips/mti-sead3/sead3-time.c
+++ b/arch/mips/mti-sead3/sead3-time.c
@@ -6,9 +6,9 @@
  * Copyright (C) 2012 MIPS Technologies, Inc.  All rights reserved.
  */
 #include <linux/init.h>
+#include <linux/irqchip/mips-gic.h>
 
 #include <asm/cpu.h>
-#include <asm/gic.h>
 #include <asm/setup.h>
 #include <asm/time.h>
 #include <asm/irq.h>
diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index afa3663..64a9729 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -9,13 +9,13 @@
 #include <linux/bitmap.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/irqchip/mips-gic.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 
 #include <asm/io.h>
-#include <asm/gic.h>
 #include <asm/setup.h>
 #include <asm/traps.h>
 #include <linux/hardirq.h>
diff --git a/arch/mips/include/asm/gic.h b/include/linux/irqchip/mips-gic.h
similarity index 100%
rename from arch/mips/include/asm/gic.h
rename to include/linux/irqchip/mips-gic.h
-- 
2.1.0.rc2.206.gedb03e5

