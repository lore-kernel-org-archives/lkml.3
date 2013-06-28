Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3F1T4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:56:34 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:33708 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab3F1T4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:56:30 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv2 3/8] clocksource: sun4i: Don't forget to enable the clock we use
Date: Fri, 28 Jun 2013 21:56:21 +0200
Message-Id: <1372449386-1334-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372449386-1334-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if in our case, this clock was non-gatable, used as a parent clock
for several IPs, it still is a good idea to enable it.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/clocksource/sun4i_timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/sun4i_timer.c
index 050e94f..84ace76 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -118,6 +118,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
+	clk_prepare_enable(clk);
 
 	rate = clk_get_rate(clk);
 
-- 
1.8.3.1

