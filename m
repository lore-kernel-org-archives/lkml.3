Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071AbaHIEPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:15:15 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34626 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaHIEPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:15:12 -0400
Message-ID: <1407557707.21696.1.camel@phoenix>
Subject: [PATCH] regulator: Add stub function for
 devm_regulator_get_exclusive
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 09 Aug 2014 12:15:07 +0800
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

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/consumer.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index f8a8733..150d2f0 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -266,6 +266,12 @@ regulator_get_exclusive(struct device *dev, const char *id)
 }
 
 static inline struct regulator *__must_check
+devm_regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return NULL;
+}
+
+static inline struct regulator *__must_check
 regulator_get_optional(struct device *dev, const char *id)
 {
 	return ERR_PTR(-ENODEV);
-- 
1.9.1



