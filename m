Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbaBRKrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:08 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56041 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037AbaBRKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:47:03 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, lgirdwood@gmail.com, sachin.kamat@linaro.org
Subject: [PATCH 07/15] regulator: lp3971: Do not hardcode return value
Date: Tue, 18 Feb 2014 16:11:03 +0530
Message-Id: <1392720071-13503-7-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the error value returned by the function instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/regulator/lp3971.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 3b1102b75071..66fd2330dca0 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -327,7 +327,7 @@ static int lp3971_i2c_read(struct i2c_client *i2c, char reg, int count,
 		return -EIO;
 	ret = i2c_smbus_read_byte_data(i2c, reg);
 	if (ret < 0)
-		return -EIO;
+		return ret;
 
 	*dest = ret;
 	return 0;
-- 
1.7.9.5

