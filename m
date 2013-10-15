Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757614Ab3JODuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 23:50:03 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33608 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757554Ab3JODt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 23:49:59 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sachin.kamat@linaro.org,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 6/6] mfd: palmas: Remove redundant of_match_ptr
Date: Tue, 15 Oct 2013 09:18:51 +0530
Message-Id: <1381808931-3323-6-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
References: <1381808931-3323-1-git-send-email-sachin.kamat@linaro.org>
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
index ae91478..d280d78 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -403,7 +403,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 	palmas->dev = &i2c->dev;
 	palmas->irq = i2c->irq;
 
-	match = of_match_device(of_match_ptr(of_palmas_match_tbl), &i2c->dev);
+	match = of_match_device(of_palmas_match_tbl, &i2c->dev);
 
 	if (!match)
 		return -ENODATA;
-- 
1.7.9.5

