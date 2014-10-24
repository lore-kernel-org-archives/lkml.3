Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaJXTPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 15:15:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34815 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJXTPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 15:15:39 -0400
From: Felipe Balbi <balbi@ti.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <airlied@linux.ie>, <robdclark@gmail.com>, <davidb@codeaurora.org>,
        <dri-devel@lists.freedesktop.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH] regulator: stub out devm_regulator_get_exclusive
Date: Fri, 24 Oct 2014 14:15:11 -0500
Message-ID: <1414178111-19525-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 2.1.0.GIT
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't stup that call out, we will have
build failures for any drivers using that function
when .config happens to have CONFIG_REGULATOR=n.

One such case below, found with randconfig

drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function ‘mdp4_kms_init’:
drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declaration \
	of function ‘devm_regulator_get_exclusive’ [-Werror=implicit-function-declaration]
  mdp4_kms->vdd = devm_regulator_get_exclusive(&pdev->dev, "vdd");
  ^
drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:16: error: assignment makes \
	pointer from integer without a cast [-Werror]
  mdp4_kms->vdd = devm_regulator_get_exclusive(&pdev->dev, "vdd");
                ^
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/regulator/consumer.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index d347c80..ff61f3b 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -291,6 +291,11 @@ regulator_get_optional(struct device *dev, const char *id)
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct regulator *__must_check
+devm_regulator_get_exclusive(struct device *dev, const char *id)
+{
+	return ERR_PTR(-ENODEV);
+}
 
 static inline struct regulator *__must_check
 devm_regulator_get_optional(struct device *dev, const char *id)
-- 
2.1.0.GIT

