Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaAZXvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 18:51:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59817 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaAZXvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 18:51:10 -0500
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Sun, 26 Jan 2014 23:51:03 +0000
Message-Id: <1390780263-6789-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] mfd: sec: Only build suspend() and resume if they will be used
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Not doing so causes warnings as the functions are static but end up not
being referenced, the macros aren't smart enough to generate fake
references.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/sec-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index a139798b8065..456ce491b733 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -315,6 +315,7 @@ static int sec_pmic_remove(struct i2c_client *i2c)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int sec_pmic_suspend(struct device *dev)
 {
 	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
@@ -349,6 +350,7 @@ static int sec_pmic_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(sec_pmic_pm_ops, sec_pmic_suspend, sec_pmic_resume);
 
-- 
1.8.5.3

