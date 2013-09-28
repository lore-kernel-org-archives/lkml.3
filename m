Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3I1Kpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:45:55 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37167 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3I1Kpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:45:53 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sachin.kamat@linaro.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 1/1] mfd: palmas: Remove redundant of_match_ptr
Date: Sat, 28 Sep 2013 16:15:43 +0530
Message-Id: <1380365143-11804-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'of_palmas_match_tbl' is always compiled in. Hence of_match_ptr() is
not needed.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/mfd/palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 135afab..e6c8aa0 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -402,7 +402,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	palmas->dev = &i2c->dev;
 	palmas->irq = i2c->irq;
 
-	match = of_match_device(of_match_ptr(of_palmas_match_tbl), &i2c->dev);
+	match = of_match_device(of_palmas_match_tbl, &i2c->dev);
 
 	if (!match)
 		return -ENODATA;
-- 
1.7.9.5

