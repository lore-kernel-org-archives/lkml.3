Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaJFUSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:18:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaJFUSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:18:32 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 3/5] regulator: Fix ena_gpio check
Date: Mon,  6 Oct 2014 22:17:13 +0200
Message-Id: <1412626635-7404-4-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the introduced ena_gpio_valid field to check if ena_gpio stores a
valid gpio.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a3c3785901f5..fd683d26786c 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3560,7 +3560,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 
 	dev_set_drvdata(&rdev->dev, rdev);
 
-	if (config->ena_gpio && gpio_is_valid(config->ena_gpio)) {
+	if (config->ena_gpio_valid && gpio_is_valid(config->ena_gpio)) {
 		ret = regulator_ena_gpio_request(rdev, config);
 		if (ret != 0) {
 			rdev_err(rdev, "Failed to request enable GPIO%d: %d\n",
-- 
2.1.0

