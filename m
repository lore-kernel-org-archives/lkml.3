Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab3AUMEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:04:51 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:45769 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344Ab3AUMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:04:48 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, anton.vorontsov@linaro.org,
        cbou@mail.ru, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 10/24] ab8500-chargalg: Only root should have write permission on sysfs file
Date: Mon, 21 Jan 2013 12:03:46 +0000
Message-Id: <1358769840-4763-11-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only root should have write permission on sysfs file ab8500_chargalg/chargalg.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/abx500_chargalg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 2463fa0..f59bc02 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1711,7 +1711,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
 static struct attribute abx500_chargalg_en_charger = \
 {
 	.name = "chargalg",
-	.mode = S_IWUGO,
+	.mode = S_IWUSR,
 };
 
 static struct attribute *abx500_chargalg_chg[] = {
-- 
1.7.9.5

