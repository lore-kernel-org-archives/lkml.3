Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaKCSMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:12:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38990 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbaKCSMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:12:46 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v3 2/4] regulator: fixed: Use gpio_is_valid
Date: Mon,  3 Nov 2014 19:12:05 +0100
Message-Id: <1415038327-32616-3-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415038327-32616-1-git-send-email-mpa@pengutronix.de>
References: <1415038327-32616-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use gpio_is_valid instead of an explicit comparison with 0.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/fixed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 17f6a7d331f8..709fba19e596 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -157,7 +157,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 
 	drvdata->desc.fixed_uV = config->microvolts;
 
-	if (config->gpio >= 0) {
+	if (gpio_is_valid(config->gpio)) {
 		cfg.ena_gpio = config->gpio;
 		if (pdev->dev.of_node)
 			cfg.ena_gpio_initialized = true;
-- 
2.1.1

