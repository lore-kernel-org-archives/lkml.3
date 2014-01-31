Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbaAaPas (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:30:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:55106 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbaAaPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:30:46 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] leds: trigger: disable CPU trigger on -RT
Date: Fri, 31 Jan 2014 16:30:42 +0100
Message-Id: <1391182242-15970-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as it triggers:
|CPU: 0 PID: 0 Comm: swapper Not tainted 3.12.8-rt10 #141
|[<c0014aa4>] (unwind_backtrace+0x0/0xf8) from [<c0012788>] (show_stack+0x1c/0x20)
|[<c0012788>] (show_stack+0x1c/0x20) from [<c043c8dc>] (dump_stack+0x20/0x2c)
|[<c043c8dc>] (dump_stack+0x20/0x2c) from [<c004c5e8>] (__might_sleep+0x13c/0x170)
|[<c004c5e8>] (__might_sleep+0x13c/0x170) from [<c043f270>] (__rt_spin_lock+0x28/0x38)
|[<c043f270>] (__rt_spin_lock+0x28/0x38) from [<c043fa00>] (rt_read_lock+0x68/0x7c)
|[<c043fa00>] (rt_read_lock+0x68/0x7c) from [<c036cf74>] (led_trigger_event+0x2c/0x5c)
|[<c036cf74>] (led_trigger_event+0x2c/0x5c) from [<c036e0bc>] (ledtrig_cpu+0x54/0x5c)
|[<c036e0bc>] (ledtrig_cpu+0x54/0x5c) from [<c000ffd8>] (arch_cpu_idle_exit+0x18/0x1c)
|[<c000ffd8>] (arch_cpu_idle_exit+0x18/0x1c) from [<c00590b8>] (cpu_startup_entry+0xa8/0x234)
|[<c00590b8>] (cpu_startup_entry+0xa8/0x234) from [<c043b2cc>] (rest_init+0xb8/0xe0)
|[<c043b2cc>] (rest_init+0xb8/0xe0) from [<c061ebe0>] (start_kernel+0x2c4/0x380)

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/leds/trigger/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/Kconfig b/drivers/leds/trigger/Kconfig
index 49794b4..3d7245d 100644
--- a/drivers/leds/trigger/Kconfig
+++ b/drivers/leds/trigger/Kconfig
@@ -61,7 +61,7 @@ config LEDS_TRIGGER_BACKLIGHT
 
 config LEDS_TRIGGER_CPU
 	bool "LED CPU Trigger"
-	depends on LEDS_TRIGGERS
+	depends on LEDS_TRIGGERS && !PREEMPT_RT_BASE
 	help
 	  This allows LEDs to be controlled by active CPUs. This shows
 	  the active CPUs across an array of LEDs so you can see which
-- 
1.8.5.3

