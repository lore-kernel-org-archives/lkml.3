Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3DWGXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:23:14 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:34937 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3DWGXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:23:12 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        zonque@gmail.com, sebastian.hesselbarth@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH 1/2] clk: si5351: Fix clkout rate computation.
Date: Tue, 23 Apr 2013 08:22:49 +0200
Message-Id: <1366698170-31346-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rate was incorrectly computed because we read from wrong divider register.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
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

