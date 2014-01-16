Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaAPPNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:13:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57232 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaAPPNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:13:06 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] clk: turn rate change failed warning into pr_debug
Date: Thu, 16 Jan 2014 16:12:55 +0100
Message-Id: <1389885175-14174-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.5.2
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a rate change failed it's the opportunity of the caller to handle
this. Do not spam the log with a message.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 2cf2ea6..f0124d4 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1460,7 +1460,7 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	/* notify that we are about to change rates */
 	fail_clk = clk_propagate_rate_change(top, PRE_RATE_CHANGE);
 	if (fail_clk) {
-		pr_warn("%s: failed to set %s rate\n", __func__,
+		pr_debug("%s: failed to set %s rate\n", __func__,
 				fail_clk->name);
 		clk_propagate_rate_change(top, ABORT_RATE_CHANGE);
 		ret = -EBUSY;
-- 
1.8.5.2

