Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaAZN3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 08:29:08 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:39020 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751348AbaAZN3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 08:29:06 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: gpio-regulator: warn if unknown regulator type
Date: Sun, 26 Jan 2014 13:28:59 +0000
Message-Id: <1390742939-10695-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_get_gpio_regulator_config() will error out if there is no
"regulator_type" field in the fdt node hoewver it makes no attempt
at warning if the contents of said node is not known.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/regulator/gpio-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 234960d..e32240a 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -213,6 +213,8 @@ of_get_gpio_regulator_config(struct device *dev, struct device_node *np)
 		config->type = REGULATOR_VOLTAGE;
 	else if (!strncmp("current", regtype, 7))
 		config->type = REGULATOR_CURRENT;
+	else
+		dev_warn(dev, "Unknown regulator-type '%s'\n", regtype);
 
 	return config;
 }
-- 
1.8.5.2

