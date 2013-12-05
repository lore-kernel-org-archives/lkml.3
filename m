Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3LETMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:12:55 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48639 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3LETM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:12:29 -0500
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Thu,  5 Dec 2013 19:12:02 +0000
Message-Id: <1386270722-13962-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386270722-13962-1-git-send-email-broonie@kernel.org>
References: <1386270722-13962-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] regulator: gpio: Warn if an invalid regulator-type is supplied
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/gpio-regulator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 13ec94d984ca..c0a1d00b78c9 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -210,6 +210,9 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 			config->type = REGULATOR_VOLTAGE;
 		else if (!strncmp("current", regtype, 7))
 			config->type = REGULATOR_CURRENT;
+		else
+			dev_warn(dev, "Unknown regulator-type '%s'\n",
+				 regtype);
 	}
 
 	return config;
-- 
1.8.5.1

