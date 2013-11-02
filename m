Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3KBPko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 11:40:44 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36976 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3KBPkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 11:40:11 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-gpio@vger.kernel.org, Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v4 2/6] gpio: davinci: remove unnecessary printk
Date: Sat,  2 Nov 2013 21:09:31 +0530
Message-Id: <1383406775-14902-3-git-send-email-prabhakar.csenng@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

the devm_*() helper prints error messages in case of
errors no need to do the same in the driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/gpio/gpio-davinci.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 6c90cfb..95c6df1 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -389,11 +389,9 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	}
 
 	clk = devm_clk_get(dev, "gpio");
-	if (IS_ERR(clk)) {
-		printk(KERN_ERR "Error %ld getting gpio clock?\n",
-		       PTR_ERR(clk));
+	if (IS_ERR(clk))
 		return PTR_ERR(clk);
-	}
+
 	clk_prepare_enable(clk);
 
 	/*
-- 
1.7.9.5

