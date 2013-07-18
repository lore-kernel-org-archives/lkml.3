Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934705Ab3GRWYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:24:25 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61848 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934586Ab3GRWVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:21:40 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net
Subject: [PATCH 05/15] MFD: ti_tscadc: ADC Clock check not required
Date: Thu, 18 Jul 2013 23:21:16 +0100
Message-Id: <1374186086-5015-6-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374186086-5015-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Patil, Rachna" <rachna@ti.com>

ADC is ideally expected to work at a frequency of 3MHz.
The present code had a check, which returned error if the frequency
went below the threshold  value. But since AM335x supports various
working frequencies, this check is not required.
Now the code just uses the internal ADC clock divider to set the ADC
frequency w.r.t the sys clock.

Signed-off-by: Patil, Rachna <rachna@ti.com>
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c       |    6 +-----
 include/linux/mfd/ti_am335x_tscadc.h |    1 -
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index 9f5c326..b8d7dfb 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -197,11 +197,7 @@ static	int ti_tscadc_probe(struct platform_device *pdev)
 	clock_rate = clk_get_rate(clk);
 	clk_put(clk);
 	clk_value = clock_rate / ADC_CLK;
-	if (clk_value < MAX_CLK_DIV) {
-		dev_err(&pdev->dev, "clock input less than min clock requirement\n");
-		err = -EINVAL;
-		goto err_disable_clk;
-	}
+
 	/* TSCADC_CLKDIV needs to be configured to the value minus 1 */
 	clk_value = clk_value - 1;
 	tscadc_writel(tscadc, REG_CLKDIV, clk_value);
diff --git a/include/linux/mfd/ti_am335x_tscadc.h b/include/linux/mfd/ti_am335x_tscadc.h
index 3058aef..136463b 100644
--- a/include/linux/mfd/ti_am335x_tscadc.h
+++ b/include/linux/mfd/ti_am335x_tscadc.h
@@ -127,7 +127,6 @@
 #define SEQ_STATUS BIT(5)
 
 #define ADC_CLK			3000000
-#define	MAX_CLK_DIV		7
 #define TOTAL_STEPS		16
 #define TOTAL_CHANNELS		8
 #define FIFO1_THRESHOLD		19
-- 
1.7.9.5

