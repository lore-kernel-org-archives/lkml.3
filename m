Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaJILO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:14:28 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34719 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaJILOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:14:24 -0400
Message-ID: <1412853258.21384.0.camel@phoenix>
Subject: [PATCH RESEND] regulator: Add stub for devm_regulator_get_exclusive
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 09 Oct 2014 19:14:18 +0800
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
Hi Mark,
I hit below build error and then found this patch is still not yet upstream.
So here is a resend.

  CC [M]  drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.o
drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function 'mdp4_kms_init':
drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declaration of function 'devm_regulator_get_exclusive' [-Werror=implicit-function-declaration]
drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:16: error: assignment makes pointer from integer without a cast [-Werror]
cc1: all warnings being treated as errors
make[4]: *** [drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.o] Error 1
make[3]: *** [drivers/gpu/drm/msm] Error 2
make[2]: *** [drivers/gpu/drm] Error 2
make[1]: *** [drivers/gpu] Error 2
make: *** [drivers] Error 2

 include/linux/regulator/consumer.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index d347c80..f124c08 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -282,7 +282,13 @@ devm_regulator_get(struct device *dev, const char *id)
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



