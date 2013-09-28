Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3I1SPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:15:25 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:49098 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3I1SPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:15:22 -0400
From: elad.wexler@gmail.com
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Elad Wexler <elad.wexler@gmail.com>
Subject: [PATCH] misc: cs5535-mfgpt: Replace 'module_init' with 'module_platform_driver'
Date: Sat, 28 Sep 2013 21:14:42 +0300
Message-Id: <1380392082-23572-1-git-send-email-elad.wexler@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elad Wexler <elad.wexler@gmail.com>

Driver doesn't do anything special in 'module_init'.

'module_platform_init' makes the code more readable.

Signed-off-by: Elad Wexler <elad.wexler@gmail.com>
---
 drivers/misc/cs5535-mfgpt.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index effd8c6..abf1a3c 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -370,13 +370,7 @@ static struct platform_driver cs5535_mfgpt_driver = {
 	.probe = cs5535_mfgpt_probe,
 };
 
-
-static int __init cs5535_mfgpt_init(void)
-{
-	return platform_driver_register(&cs5535_mfgpt_driver);
-}
-
-module_init(cs5535_mfgpt_init);
+module_platform_driver(cs5535_mfgpt_driver);
 
 MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
-- 
1.7.9.5

