Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab3BPSUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 13:20:04 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:35135 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3BPSUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 13:20:03 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: thierry.reding@avionic-design.de, morbidrsa@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: twl: Use to_twl() instead of container_of()
Date: Sat, 16 Feb 2013 19:20:51 +0100
Message-Id: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In twl6030_pwm_disable() use to_twl() instead of container_of() like in the
rest of the driver.

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/pwm/pwm-twl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index f783efc..a34c235 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -255,8 +255,7 @@ out:
 
 static void twl6030_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
-						chip);
+	struct twl_pwm_chip *twl = to_twl(chip);
 	int ret;
 	u8 val;
 
-- 
1.8.1.3

