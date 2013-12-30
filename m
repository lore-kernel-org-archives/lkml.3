Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3L3KWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 05:22:36 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:59493 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3L3KUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 05:20:03 -0500
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: mingo@kernel.org, tglx@linutronix.de
Cc: axel.lin@ingics.com, ezequiel.garcia@free-electrons.com,
        jg1.han@samsung.com, laurent.pinchart+renesas@ideasonboard.com,
        linus.walleij@linaro.org, maxime.ripard@free-electrons.com,
        michael.opdenacker@free-electrons.com, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/20] clocksource: clksrc-of: Warn if no clock sources are found
Date: Mon, 30 Dec 2013 11:19:31 +0100
Message-Id: <1388398779-11222-12-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
References: <52C1479E.80808@linaro.org>
 <1388398779-11222-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Many platforms rely on clocksource_of_init() being implicitly
called for registering clock sources and will get zero warnings
if no working clock source is available. Let's print a critical
error message if no clock source is found.

Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/clocksource/clksrc-of.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clocksource/clksrc-of.c b/drivers/clocksource/clksrc-of.c
index 35639cf4..a30b42c 100644
--- a/drivers/clocksource/clksrc-of.c
+++ b/drivers/clocksource/clksrc-of.c
@@ -28,6 +28,7 @@ void __init clocksource_of_init(void)
 	struct device_node *np;
 	const struct of_device_id *match;
 	clocksource_of_init_fn init_func;
+	unsigned clocksources = 0;
 
 	for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
 		if (!of_device_is_available(np))
@@ -36,5 +37,8 @@ void __init clocksource_of_init(void)
 		init_func = match->data;
 		init_func(np);
 		of_node_put(np);
+		clocksources++;
 	}
+	if (!clocksources)
+		pr_crit("%s: no matching clocksources found\n", __func__);
 }
-- 
1.7.9.5

