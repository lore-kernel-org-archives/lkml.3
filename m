Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3FYMB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 08:01:28 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:65178 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3FYMBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 08:01:25 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, sachin.kamat@linaro.org,
        Jingchang Lu <b35083@freescale.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/1] clocksource: vf_pit_timer: Fix build breakage
Date: Tue, 25 Jun 2013 17:16:20 +0530
Message-Id: <1372160780-26172-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/sched_clock.h does not exist. Use linux/sched_clock.h instead.
Without this patch we get the following build error (introduced by commit
c1967249 ("clocksource: Add Freescale Vybrid pit timer support")):

drivers/clocksource/vf_pit_timer.c:15:29: fatal error: asm/sched_clock.h:
No such file or directory

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
Compile tested only.
---
 drivers/clocksource/vf_pit_timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index 598399d..587e020 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -12,7 +12,7 @@
 #include <linux/clk.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
-#include <asm/sched_clock.h>
+#include <linux/sched_clock.h>
 
 /*
  * Each pit takes 0x10 Bytes register space
-- 
1.7.9.5

