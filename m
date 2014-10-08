Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbaJHNri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:47:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60134 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaJHNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:47:36 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v2 4/4] regulator: gpio: Use gpio_is_valid
Date: Wed,  8 Oct 2014 15:47:08 +0200
Message-Id: <1412776028-15655-5-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
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
 drivers/regulator/gpio-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 5da0125fac6a..86546c1c32c4 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -322,7 +322,7 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = np;
 
-	if (config->enable_gpio >= 0) {
+	if (gpio_is_valid(config->enable_gpio)) {
 		cfg.ena_gpio = config->enable_gpio;
 		cfg.ena_gpio_initialized = true;
 	}
-- 
2.1.0

