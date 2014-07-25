Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748AbaGYSDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:03:03 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55039 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbaGYSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:03:01 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Fri, 25 Jul 2014 19:02:47 +0100
Message-Id: <1406311367-606-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.0.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Fix return code for stub regmap_get_device()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

We return a pointer, not an int.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 include/linux/regmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index cd480fd59795..c5ed83f49c4e 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -733,7 +733,7 @@ static inline struct regmap *dev_get_regmap(struct device *dev,
 static inline struct device *regmap_get_device(struct regmap *map)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-	return -EINVAL;
+	return NULL;
 }
 
 #endif
-- 
2.0.1

