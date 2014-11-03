Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaKCSNC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:13:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38994 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaKCSMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:12:47 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v3 4/4] regulator: tps65090: Fix gpio initialization
Date: Mon,  3 Nov 2014 19:12:07 +0100
Message-Id: <1415038327-32616-5-git-send-email-mpa@pengutronix.de>
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

The config is used for multiple regulators within a for loop. The config
field is not cleared before it is used for the next item. To avoid any
issues this patch adds a proper initialization for the config->ena_gpio
field in case no gpio is available.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/tps65090-regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 2e92aa8718cc..f1df4423d361 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -314,6 +314,9 @@ static void tps65090_configure_regulator_config(
 		config->ena_gpio = tps_pdata->gpio;
 		config->ena_gpio_initialized = true;
 		config->ena_gpio_flags = gpio_flag;
+	} else {
+		config->ena_gpio = -EINVAL;
+		config->ena_gpio_initialized = false;
 	}
 }
 
-- 
2.1.1

