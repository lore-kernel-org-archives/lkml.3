Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbaBRGrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 01:47:06 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50064 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaBRGrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 01:47:04 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        achew@nvidia.com, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] microblaze: Rename global function heartbeat()
Date: Mon, 17 Feb 2014 22:46:54 -0800
Message-Id: <1392706014-23332-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

microblaze:allmodconfig complains for some configurations that 'heartbeat'
is redefined as different kind of symbol. This is seen in test compiles
of watchdog drivers, which often use 'heartbeat' as ststic variable.

Since 'heartbeat' is an unfortunate name for a global function,
rename it to microblaze_heartbeat. Also rename the setup function
to microblaze_setup_heartbeat.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Use microblaze_ instead of xilinx_ as function prefix.

 arch/microblaze/include/asm/setup.h |    4 ++--
 arch/microblaze/kernel/heartbeat.c  |    4 ++--
 arch/microblaze/kernel/timer.c      |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/include/asm/setup.h b/arch/microblaze/include/asm/setup.h
index b2c08ce..be84a4d 100644
--- a/arch/microblaze/include/asm/setup.h
+++ b/arch/microblaze/include/asm/setup.h
@@ -23,8 +23,8 @@ int setup_early_printk(char *opt);
 void remap_early_printk(void);
 void disable_early_printk(void);
 
-void heartbeat(void);
-void setup_heartbeat(void);
+void microblaze_heartbeat(void);
+void microblaze_setup_heartbeat(void);
 
 #   ifdef CONFIG_MMU
 extern void mmu_reset(void);
diff --git a/arch/microblaze/kernel/heartbeat.c b/arch/microblaze/kernel/heartbeat.c
index 1879a05..4643e3a 100644
--- a/arch/microblaze/kernel/heartbeat.c
+++ b/arch/microblaze/kernel/heartbeat.c
@@ -17,7 +17,7 @@
 
 static unsigned int base_addr;
 
-void heartbeat(void)
+void microblaze_heartbeat(void)
 {
 	static unsigned int cnt, period, dist;
 
@@ -42,7 +42,7 @@ void heartbeat(void)
 	}
 }
 
-void setup_heartbeat(void)
+void microblaze_setup_heartbeat(void)
 {
 	struct device_node *gpio = NULL;
 	int *prop;
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index fb0c6144..717a3d9 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -140,7 +140,7 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 {
 	struct clock_event_device *evt = &clockevent_xilinx_timer;
 #ifdef CONFIG_HEART_BEAT
-	heartbeat();
+	microblaze_heartbeat();
 #endif
 	timer_ack();
 	evt->event_handler(evt);
@@ -274,7 +274,7 @@ static void __init xilinx_timer_init(struct device_node *timer)
 
 	setup_irq(irq, &timer_irqaction);
 #ifdef CONFIG_HEART_BEAT
-	setup_heartbeat();
+	microblaze_setup_heartbeat();
 #endif
 	xilinx_clocksource_init();
 	xilinx_clockevent_init();
-- 
1.7.9.7

