Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3BPTxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 14:53:50 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:39787 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab3BPTxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 14:53:49 -0500
From: Johannes Thumshirn <morbidrsa@gmail.com>
To: thierry.reding@avionic-design.de, morbidrsa@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pwm: twl: Use to_twl() instead of container_of()
Date: Sat, 16 Feb 2013 20:54:32 +0100
Message-Id: <1361044472-6439-1-git-send-email-morbidrsa@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
References: <1361038851-4994-1-git-send-email-morbidrsa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always use to_twl() for converting into private data instead of container_of()

Signed-off-by: Johannes Thumshirn <morbidrsa@gmail.com>
---
 drivers/pwm/pwm-twl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pwm/pwm-twl.c b/drivers/pwm/pwm-twl.c
index a34c235..9cd2c9a 100644
--- a/drivers/pwm/pwm-twl.c
+++ b/drivers/pwm/pwm-twl.c
@@ -200,8 +200,7 @@ out:
 
 static void twl4030_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
-						chip);
+	struct twl_pwm_chip *twl = to_twl(chip);
 	int ret;
 	u8 val, mask;
 
@@ -231,8 +230,7 @@ out:
 
 static int twl6030_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	struct twl_pwm_chip *twl = container_of(chip, struct twl_pwm_chip,
-						chip);
+	struct twm_pwm_chip *twl = to_twl(chip);
 	int ret;
 	u8 val;
 
-- 
1.8.1.3

