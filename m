Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3FXX2P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:28:15 -0400
Received: from mail-gh0-f170.google.com ([209.85.160.170]:59691 "EHLO
	mail-gh0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3FXX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:28:11 -0400
From: Fabio Estevam <festevam@gmail.com>
To: john.stultz@linaro.org
Cc: tglx@linutronix.de, shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] clocksource: vf_pit_timer: Use <linux/sched_clock.h>
Date: Mon, 24 Jun 2013 20:20:08 -0300
Message-Id: <1372116008-2323-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Commit 38ff87f7 (sched_clock: Make ARM's sched_clock generic for all 
architectures) changed the header to <linux/sched_clock.h>, so adapt it in order
to fix the following build error:

drivers/clocksource/vf_pit_timer.c:15:29: fatal error: asm/sched_clock.h: No such file or directory

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/clocksource/vf_pit_timer.c | 2 +-
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
1.8.1.2

