Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaIQIsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:48:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55586 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaIQIsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:48:36 -0400
Message-ID: <1410943712.10971.0.camel@phoenix>
Subject: [RESEND][PATCH v2] regulator: Add stub for
 devm_regulator_get_exclusive
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Sep 2014 16:48:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also makes regulator_get_exclusive and devm_regulator_get_exclusive stub
functions return error pointer.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Now drivers/gpu/drm/msm/hdmi/hdmi.c is using devm_regulator_get
instead of devm_regulator_get_exclusive.
commit 3e87599b68e7929a84a32ab65ad17b79a3f271f6
"drm/msm/mdp4: add LVDS panel support"
So I remove the build error message in commit log.

 include/linux/regulator/consumer.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f8a8733..66473e3 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -262,7 +262,13 @@ devm_regulator_get(struct device *dev, const char *id)
 static inline struct regulator *__must_check
 regulator_get_exclusive(struct device *dev, const char *id)
 {
-	return NULL;
+	return ERR_PTR(-ENODEV);
+}
+
+static inline struct regulator *__must_check
+devm_regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENODEV);
 }
 
 static inline struct regulator *__must_check
-- 
1.9.1



