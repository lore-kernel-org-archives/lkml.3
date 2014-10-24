Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaJXU6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:58:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46902 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaJXU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:58:30 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Date: Fri, 24 Oct 2014 21:58:15 +0100
Message-Id: <1414184295-14260-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: Return an error from stubbed regulator_get_exclusive()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user hasn't got a regulator and shouldn't be mislead into thinking
they have one; really we should probably remove this stub entirely (and
may well before the next merge window).

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 include/linux/regulator/consumer.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f540b14..3c4fad5 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -284,7 +284,7 @@ devm_regulator_get(struct device *dev, const char *id)
 static inline struct regulator *__must_check
 regulator_get_exclusive(struct device *dev, const char *id)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
 }
 
 static inline struct regulator *__must_check
-- 
2.1.1

