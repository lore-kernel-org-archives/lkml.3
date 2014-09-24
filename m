Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaIXQUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:20:24 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40445 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaIXQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:20:19 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, daniel.lezcano@linaro.org,
        tglx@linutronix.de
Cc: festevam@gmail.com, jingchang.lu@freescale.com, bpringlemeir@nbsps.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 1/3] clocksource: vf_pit_timer: Support shutdown mode
Date: Wed, 24 Sep 2014 18:20:08 +0200
Message-Id: <1411575610-20895-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411575610-20895-1-git-send-email-stefan@agner.ch>
References: <1411575610-20895-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to avoid waking up the system in a low power mode, the
clocksource should not generate interrupts anymore. Disable the PIT
timer interrupt when changing into the CLOCK_EVT_MODE_SHUTDOWN mode.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/clocksource/vf_pit_timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index a918bc4..eb354b4 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -89,10 +89,15 @@ static int pit_set_next_event(unsigned long delta,
 static void pit_set_mode(enum clock_event_mode mode,
 				struct clock_event_device *evt)
 {
+
 	switch (mode) {
 	case CLOCK_EVT_MODE_PERIODIC:
 		pit_set_next_event(cycle_per_jiffy, evt);
 		break;
+	case CLOCK_EVT_MODE_SHUTDOWN:
+	case CLOCK_EVT_MODE_UNUSED:
+		pit_timer_disable();
+		break;
 	default:
 		break;
 	}
-- 
2.1.0

