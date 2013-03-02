Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3CBKKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 05:10:48 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54410 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab3CBKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 05:10:20 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: john.stultz@linaro.org, tglx@linutronix.de
Cc: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org,
        linus.walleij@stericsson.com
Subject: [PATCH 4/4][V2] ARM: timer-sp: Set dynamic irq affinity
Date: Sat,  2 Mar 2013 11:10:13 +0100
Message-Id: <1362219013-18173-5-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

When a cpu goes to a deep idle state where its local timer is shutdown, it
notifies the time frame work to use the broadcast timer instead.

Unfortunately, the broadcast device could wake up any CPU, including an idle one
which is not concerned by the wake up at all.

This implies, in the worst case, an idle CPU will wake up to send an IPI to
another idle cpu.

This patch fixes this for ARM platforms using timer-sp, by setting
CLOCK_EVT_FEAT_DYNIRQ feature.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/arm/common/timer-sp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index 9d2d3ba..ae3c0f9 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -158,7 +158,8 @@ static int sp804_set_next_event(unsigned long next,
 }
 
 static struct clock_event_device sp804_clockevent = {
-	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
+	.features       = CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT |
+		CLOCK_EVT_FEAT_DYNIRQ,
 	.set_mode	= sp804_set_mode,
 	.set_next_event	= sp804_set_next_event,
 	.rating		= 300,
-- 
1.7.9.5

