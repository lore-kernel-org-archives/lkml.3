Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab3ALKB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:01:56 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58310 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab3ALKBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:01:54 -0500
Message-ID: <1357984906.6460.2.camel@phoenix>
Subject: [PATCH v2] clk: max77686: Remove unnecessary NULL checking for
 container_of()
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 12 Jan 2013 18:01:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

container_of() never returns NULL, thus remove the NULL checking for it.
Also rename get_max77686_clk() to to_max77686_clk() for better readability.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2: remove unrelated change for ~max77686->mask 
 drivers/clk/clk-max77686.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/clk/clk-max77686.c b/drivers/clk/clk-max77686.c
index 8944214..90bf59c 100644
--- a/drivers/clk/clk-max77686.c
+++ b/drivers/clk/clk-max77686.c
@@ -44,33 +44,23 @@ struct max77686_clk {
 	struct clk_lookup *lookup;
 };
 
-static struct max77686_clk *get_max77686_clk(struct clk_hw *hw)
+static struct max77686_clk *to_max77686_clk(struct clk_hw *hw)
 {
 	return container_of(hw, struct max77686_clk, hw);
 }
 
 static int max77686_clk_prepare(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
-	int ret;
-
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return -ENOMEM;
-
-	ret = regmap_update_bits(max77686->iodev->regmap,
-		MAX77686_REG_32KHZ, max77686->mask, max77686->mask);
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 
-	return ret;
+	return regmap_update_bits(max77686->iodev->regmap,
+				  MAX77686_REG_32KHZ, max77686->mask,
+				  max77686->mask);
 }
 
 static void max77686_clk_unprepare(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
-
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return;
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 
 	regmap_update_bits(max77686->iodev->regmap,
 		MAX77686_REG_32KHZ, max77686->mask, ~max77686->mask);
@@ -78,14 +68,10 @@ static void max77686_clk_unprepare(struct clk_hw *hw)
 
 static int max77686_clk_is_enabled(struct clk_hw *hw)
 {
-	struct max77686_clk *max77686;
+	struct max77686_clk *max77686 = to_max77686_clk(hw);
 	int ret;
 	u32 val;
 
-	max77686 = get_max77686_clk(hw);
-	if (!max77686)
-		return -ENOMEM;
-
 	ret = regmap_read(max77686->iodev->regmap,
 				MAX77686_REG_32KHZ, &val);
 
-- 
1.7.9.5



