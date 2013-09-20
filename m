Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3ITLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:25:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34829 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195Ab3ITLZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:25:25 -0400
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <treding@nvidia.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Fri, 20 Sep 2013 12:24:49 +0100
Message-Id: <1379676289-18882-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: core: Fix default return value for _get()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Now that we are defaulting to providing dummy regulators fix the logic
for substituting a dummy by making the default return code -EPROBE_DEFER.

Reported-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---

Not tested at all.

 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 4eefcc3..353779b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1231,7 +1231,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 	struct regulator_dev *rdev;
 	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
 	const char *devname = NULL;
-	int ret = 0;
+	int ret = -EPROBE_DEFER;
 
 	if (id == NULL) {
 		pr_err("get() with no identifier\n");
-- 
1.8.4.rc3

