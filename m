Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3FZVRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:17:09 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51819 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3FZVRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:17:05 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/8] clocksource: sun4i: Don't forget to enable the clock we use
Date: Wed, 26 Jun 2013 23:16:56 +0200
Message-Id: <1372281421-2099-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1372281421-2099-1-git-send-email-maxime.ripard@free-electrons.com>
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
index 1d2eaa0..8bd66df 100644
--- a/drivers/clocksource/sun4i_timer.c
+++ b/drivers/clocksource/sun4i_timer.c
@@ -135,6 +135,7 @@ static void __init sun4i_timer_init(struct device_node *node)
 	clk = of_clk_get(node, 0);
 	if (IS_ERR(clk))
 		panic("Can't get timer clock");
+	clk_prepare_enable(clk);
 
 	rate = clk_get_rate(clk);
 
-- 
1.8.3.1

