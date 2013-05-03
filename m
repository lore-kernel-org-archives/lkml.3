Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3ECFxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:53:39 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40408 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762084Ab3ECFxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:53:38 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: zonque@gmail.com, vladimir.koutny@streamunlimited.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH v2 1/2] clk: si5351: Fix clkout rate computation.
Date: Fri,  3 May 2013 07:53:22 +0200
Message-Id: <1367560403-21685-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rate was incorrectly computed because we read from wrong divider register.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
 drivers/clk/clk-si5351.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index 8927284..cf39e53 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -932,7 +932,7 @@ static unsigned long si5351_clkout_recalc_rate(struct clk_hw *hw,
 	unsigned char reg;
 	unsigned char rdiv;
 
-	if (hwdata->num > 5)
+	if (hwdata->num <= 5)
 		reg = si5351_msynth_params_address(hwdata->num) + 2;
 	else
 		reg = SI5351_CLK6_7_OUTPUT_DIVIDER;
-- 
1.7.9.5

