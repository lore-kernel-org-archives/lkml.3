Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaCJK5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:57:52 -0400
Received: from fallback1.mail.ru ([94.100.176.18]:45503 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaCJK5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:57:51 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] mfd: syscon: Simplify syscon_match_pdevname()
Date: Mon, 10 Mar 2014 14:57:33 +0400
Message-Id: <1394449053-27818-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do not want to add new platform IDs for the syscon driver,
there is no reason to iterate over IDs. This patch simplifies
syscon_match_pdevname() function to remove such iteration.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/mfd/syscon.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 2620056..dbea55d 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -69,13 +69,6 @@ EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_compatible);
 
 static int syscon_match_pdevname(struct device *dev, void *data)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	const struct platform_device_id *id = platform_get_device_id(pdev);
-
-	if (id)
-		if (!strcmp(id->name, (const char *)data))
-			return 1;
-
 	return !strcmp(dev_name(dev), (const char *)data);
 }
 
-- 
1.8.3.2

