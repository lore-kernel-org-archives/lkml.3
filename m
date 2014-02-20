Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaBTT6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 14:58:22 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:55033 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbaBTT6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 14:58:20 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: lgirdwood@gmail.com, broonie@kernel.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] regulator: core: Change dummy supplies error message to a warning
Date: Thu, 20 Feb 2014 12:58:15 -0700
Message-Id: <1392926295-23735-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change "dummy supplies not allowed" error message to warning instead, as this
is a just warning message with no change to the behavior.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 16a309e..d1ac4ca 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1359,7 +1359,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
 		goto found;
 	/* Don't log an error when called from regulator_get_optional() */
 	} else if (!have_full_constraints() || exclusive) {
-		dev_err(dev, "dummy supplies not allowed\n");
+		dev_warn(dev, "dummy supplies not allowed\n");
 	}
 
 	mutex_unlock(&regulator_list_mutex);
-- 
1.7.10.4

