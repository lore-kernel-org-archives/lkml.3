Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbbAGL3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:29:07 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53050 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbAGL3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:29:05 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: olof@lixom.net, magnus.damm@gmail.com, tjakobi@math.uni-bielefeld.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Wed,  7 Jan 2015 12:28:58 +0100
Message-Id: <1420630138-31443-3-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420630138-31443-1-git-send-email-daniel.lezcano@linaro.org>
References: <54AD17F1.4010002@linaro.org>
 <1420630138-31443-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

Update the TMU driver to use cpu_possible_mask as cpumask to make
r8a7779 SMP work as expected with or without the ARM TWD timer.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/sh_tmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 0f665b8..f150ca82 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(struct sh_tmu_channel *ch,
 	ced->features = CLOCK_EVT_FEAT_PERIODIC;
 	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
 	ced->rating = 200;
-	ced->cpumask = cpumask_of(0);
+	ced->cpumask = cpu_possible_mask;
 	ced->set_next_event = sh_tmu_clock_event_next;
 	ced->set_mode = sh_tmu_clock_event_mode;
 	ced->suspend = sh_tmu_clock_event_suspend;
-- 
1.9.1

