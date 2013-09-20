Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3ITLeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:34:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47453 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3ITLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:34:14 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Fri, 20 Sep 2013 12:33:44 +0100
Message-Id: <1379676824-19094-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Fix return code for invalid parameters
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

We should be returning an error, a repeated call will never succeed.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 353779b..dfdec27 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1235,7 +1235,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 
 	if (id == NULL) {
 		pr_err("get() with no identifier\n");
-		return regulator;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (dev)
-- 
1.8.4.rc3

