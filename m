Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969AbaHSWIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:08:21 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51596 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaHSWIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:08:15 -0400
From: =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        =?utf-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>
Subject: [PATCH 1/3] ARM: at91/tclib: prefer using of devm_* functions
Date: Wed, 20 Aug 2014 00:07:50 +0200
Message-Id: <1408486072-19268-2-git-send-email-gael.portay@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
References: <1408486072-19268-1-git-send-email-gael.portay@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gaël PORTAY <gael.portay@gmail.com>
---
 drivers/misc/atmel_tclib.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
index c8d8e38..b514a2d 100644
--- a/drivers/misc/atmel_tclib.c
+++ b/drivers/misc/atmel_tclib.c
@@ -150,17 +150,15 @@ static int __init tc_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return -EINVAL;
 
-	tc = kzalloc(sizeof(struct atmel_tc), GFP_KERNEL);
+	tc = devm_kzalloc(&pdev->dev, sizeof(struct atmel_tc), GFP_KERNEL);
 	if (!tc)
 		return -ENOMEM;
 
 	tc->pdev = pdev;
 
-	clk = clk_get(&pdev->dev, "t0_clk");
-	if (IS_ERR(clk)) {
-		kfree(tc);
-		return -EINVAL;
-	}
+	clk = devm_clk_get(&pdev->dev, "t0_clk");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
 
 	/* Now take SoC information if available */
 	if (pdev->dev.of_node) {
@@ -171,10 +169,10 @@ static int __init tc_probe(struct platform_device *pdev)
 	}
 
 	tc->clk[0] = clk;
-	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
+	tc->clk[1] = devm_clk_get(&pdev->dev, "t1_clk");
 	if (IS_ERR(tc->clk[1]))
 		tc->clk[1] = clk;
-	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
+	tc->clk[2] = devm_clk_get(&pdev->dev, "t2_clk");
 	if (IS_ERR(tc->clk[2]))
 		tc->clk[2] = clk;
 
-- 
1.9.3

