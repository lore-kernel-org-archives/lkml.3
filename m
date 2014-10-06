Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaJFUST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:18:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59261 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaJFUSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:18:16 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH 1/5] regulator: Add ena_gpio_valid config
Date: Mon,  6 Oct 2014 22:17:11 +0200
Message-Id: <1412626635-7404-2-git-send-email-mpa@pengutronix.de>
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

Most drivers do not set the ena_gpio field of struct regulator_config
before passing it to the regulator core. This is fine as long as the
gpio identifier that is passed is a positive integer. But the gpio
identifier 0 is also valid. So we are not able to decide wether we got a
real gpio identifier or not.

To be able to decide if it is a valid gpio that got passed, this patch
adds a ena_gpio_valid field that should be set if ena_gpio is a valid
gpio and should be used. It is a preperation patch for multiple patches
that adapt the drivers and fix the regulator core checks for this field.

Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
---
 include/linux/regulator/driver.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index bbe03a1924c0..c561f0faaf61 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -292,6 +292,8 @@ struct regulator_desc {
  *           NULL).
  * @regmap: regmap to use for core regmap helpers if dev_get_regulator() is
  *          insufficient.
+ * @ena_gpio_valid: GPIO controlling regulator enable is valid and should be
+ *                  used.
  * @ena_gpio: GPIO controlling regulator enable.
  * @ena_gpio_invert: Sense for GPIO enable control.
  * @ena_gpio_flags: Flags to use when calling gpio_request_one()
@@ -303,6 +305,7 @@ struct regulator_config {
 	struct device_node *of_node;
 	struct regmap *regmap;
 
+	bool ena_gpio_valid;
 	int ena_gpio;
 	unsigned int ena_gpio_invert:1;
 	unsigned int ena_gpio_flags;
-- 
2.1.0

