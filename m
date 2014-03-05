Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbaCEV35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:29:57 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:56447 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757796AbaCEV3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:29:51 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lgirdwood@gmail.com, broonie@kernel.org, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13] regulator: core: Change dummy supplies error message to a warning
Date: Wed,  5 Mar 2014 14:29:47 -0700
Message-Id: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "dummy supplies not allowed" error message to warning instead,
as this is a just warning message with no change to the behavior.

upstream commit acc3d5cec84f82ebea535fa0bd9500ac3df2aee9

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
---

Back porting as the original patch tagged for stable failed to apply.
Included Mark Brown's Signed-off from the original commit. This change
is not applicable to 3.12 and earlier.

 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 0186c1b..804521a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1359,7 +1359,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 		rdev = dummy_regulator_rdev;
 		goto found;
 	} else {
-		dev_err(dev, "dummy supplies not allowed\n");
+		dev_warn(dev, "dummy supplies not allowed\n");
 	}
 
 	mutex_unlock(&regulator_list_mutex);
-- 
1.7.10.4

