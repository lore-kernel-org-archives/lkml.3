Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3LEAcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:32:23 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36653 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3LEAcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:32:18 -0500
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Thu,  5 Dec 2013 00:31:55 +0000
Message-Id: <1386203515-6815-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: gpio: Don't require a regulator-type property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Since essentially all GPIO controlled regulators are voltage regulators
make the regulator-type property optional, defaulting to voltage.

Signed-off-by: Mark Brown <broonie@linaro.org>
---

Compile tested only.

 drivers/regulator/gpio-regulator.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 234960dc9607..13ec94d984ca 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -203,17 +203,15 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 	}
 	config->nr_states = i;
 
+	config->type = REGULATOR_VOLTAGE;
 	ret = of_property_read_string(np, "regulator-type", &regtype);
-	if (ret < 0) {
-		dev_err(dev, "Missing 'regulator-type' property\n");
-		return ERR_PTR(-EINVAL);
+	if (ret >= 0) {
+		if (!strncmp("voltage", regtype, 7))
+			config->type = REGULATOR_VOLTAGE;
+		else if (!strncmp("current", regtype, 7))
+			config->type = REGULATOR_CURRENT;
 	}
 
-	if (!strncmp("voltage", regtype, 7))
-		config->type = REGULATOR_VOLTAGE;
-	else if (!strncmp("current", regtype, 7))
-		config->type = REGULATOR_CURRENT;
-
 	return config;
 }
 
-- 
1.8.5.1

