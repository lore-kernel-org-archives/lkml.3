Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932977Ab3LDXfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:35:53 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61845 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab3LDXfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:35:44 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 7/7] clk: highbank: add DT match for calxeda,ecx-3000-sregs
Date: Wed,  4 Dec 2013 17:35:27 -0600
Message-Id: <1386200127-23143-8-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
References: <1386200127-23143-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The system registers are a bit different overall and need a different
compatible string, but the clock registers are similar. So for the clock
code, we just need to match with the new compatible string.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Mike Turquette <mturquette@linaro.org>
---
 drivers/clk/clk-highbank.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
index 89efcbc..8023146 100644
--- a/drivers/clk/clk-highbank.c
+++ b/drivers/clk/clk-highbank.c
@@ -278,6 +278,12 @@ static const struct clk_ops periclk_ops = {
 	.set_rate = clk_periclk_set_rate,
 };
 
+static struct of_device_id sregs_match[] = {
+	{ .compatible = "calxeda,ecx-3000-sregs" },
+	{ .compatible = "calxeda,hb-sregs" },
+	{}
+};
+
 static __init struct clk *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
 {
 	u32 reg;
@@ -298,7 +304,7 @@ static __init struct clk *hb_clk_init(struct device_node *node, const struct clk
 		return NULL;
 
 	/* Map system registers */
-	srnp = of_find_compatible_node(NULL, NULL, "calxeda,hb-sregs");
+	srnp = of_find_matching_node(NULL, sregs_match);
 	hb_clk->reg = of_iomap(srnp, 0);
 	BUG_ON(!hb_clk->reg);
 	hb_clk->reg += reg;
-- 
1.8.3.2

