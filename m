Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaI2AYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 20:24:14 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35356 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaI2AX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 20:23:57 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/13] clocksource: vf_pit_timer: Support shutdown mode
Date: Mon, 29 Sep 2014 02:23:39 +0200
Message-Id: <1411950226-21598-6-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
References: <5428A559.5050908@linaro.org>
 <1411950226-21598-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

In order to avoid waking up the system in a low power mode, the
clocksource should not generate interrupts anymore. Disable the PIT
timer interrupt when changing into the CLOCK_EVT_MODE_SHUTDOWN mode.

[dlezcano] : remove superfluous empty line

Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Bill Pringlemeir <bpringlemeir@nbsps.com>
---
 drivers/clocksource/vf_pit_timer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/vf_pit_timer.c b/drivers/clocksource/vf_pit_timer.c
index a918bc4..b45ac62 100644
--- a/drivers/clocksource/vf_pit_timer.c
+++ b/drivers/clocksource/vf_pit_timer.c
@@ -93,6 +93,10 @@ static void pit_set_mode(enum clock_event_mode mode,
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
1.9.1

