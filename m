Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaKZNI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 08:08:26 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63989 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaKZNIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:08:22 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ezequiel.garcia@free-electrons.com, yl22@csr.com
Subject: [PATCH 2/4] clocksource: armada-370-xp: Add missing clock enable
Date: Wed, 26 Nov 2014 14:08:12 +0100
Message-Id: <1417007294-19869-2-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417007294-19869-1-git-send-email-daniel.lezcano@linaro.org>
References: <5475D044.5060607@linaro.org>
 <1417007294-19869-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

This commit makes sure the timer clock is prepared and enabled
before retrieving its rate.

Acked-by: Jason Cooper <jason@lakedaemon.net>
Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Wim Van Sebroeck <wim@iguana.be>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/time-armada-370-xp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 0451e62..d8555f9 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -293,6 +293,7 @@ static void __init armada_xp_timer_init(struct device_node *np)
 
 	/* The 25Mhz fixed clock is mandatory, and must always be available */
 	BUG_ON(IS_ERR(clk));
+	clk_prepare_enable(clk);
 	timer_clk = clk_get_rate(clk);
 
 	armada_370_xp_timer_common_init(np);
@@ -305,6 +306,7 @@ static void __init armada_370_timer_init(struct device_node *np)
 	struct clk *clk = of_clk_get(np, 0);
 
 	BUG_ON(IS_ERR(clk));
+	clk_prepare_enable(clk);
 	timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
 	timer25Mhz = false;
 
-- 
1.9.1

