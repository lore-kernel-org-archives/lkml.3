Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933673AbaJHWK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:10:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41378 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990AbaJHWKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:10:24 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com,
        Mark Brown <broonie@kernel.org>
Date: Wed,  8 Oct 2014 23:09:59 +0100
Message-Id: <1412806199-5363-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: of: Lower the severity of the error with no container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description of regulators should generally be optional so if there is no
DT node for the regulators container then we shouldn't print an error
message. Lower the severity of the message to debug level (it might help
someone work out what went wrong) and while we're at it say what we were
looking for.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/of_regulator.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 7a51814abdc5..5a1d4afa4776 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -211,7 +211,8 @@ struct regulator_init_data *regulator_of_get_init_data(struct device *dev,
 		search = dev->of_node;
 
 	if (!search) {
-		dev_err(dev, "Failed to find regulator container node\n");
+		dev_dbg(dev, "Failed to find regulator container node '%s'\n",
+			desc->regulators_node);
 		return NULL;
 	}
 
-- 
2.1.1

