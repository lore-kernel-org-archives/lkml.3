Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaHLBhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 21:37:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36596 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaHLBhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 21:37:14 -0400
Message-ID: <1407807429.8958.1.camel@phoenix>
Subject: [PATCH v2] regulator: Add stub for devm_regulator_get_exclusive
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 12 Aug 2014 09:37:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error when !CONFIG_REGULATOR.

  CC      drivers/gpu/drm/msm/hdmi/hdmi.o
drivers/gpu/drm/msm/hdmi/hdmi.c: In function 'hdmi_init':
drivers/gpu/drm/msm/hdmi/hdmi.c:126:3: error: implicit declaration of function 'devm_regulator_get_exclusive' [-Werror=implicit-function-declaration]

Also makes regulator_get_exclusive and devm_regulator_get_exclusive stub
functions return error pointer.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
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



