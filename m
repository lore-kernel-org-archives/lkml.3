Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab3GEWUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:20:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52592 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab3GEWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:18:52 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCHv4 05/10] clocksource: sun4i: Don't forget to enable the clock we use
Date: Sat,  6 Jul 2013 00:18:40 +0200
Message-Id: <1373062725-19625-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1373062725-19625-1-git-send-email-maxime.ripard@free-electrons.com>
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
index b581c93..8e9c651 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -120,6 +120,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
+	clk_prepare_enable(clk);
 
 	rate = clk_get_rate(clk);
 
-- 
1.8.3.2

