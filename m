Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3LNRbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:21 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53553 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab3LNRao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:44 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 07/14] i8k: Drop driver version number and info message at startup
Date: Sat, 14 Dec 2013 09:30:14 -0800
Message-Id: <1387042221-3671-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver version number is long since obsolete, so drop it.
Also, drop the info message at driver startup to reduce boot noise.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 5b3682c..ad0acef 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -34,8 +34,6 @@
 
 #include <linux/i8k.h>
 
-#define I8K_VERSION		"1.14 21/02/2005"
-
 #define I8K_SMM_FN_STATUS	0x0025
 #define I8K_SMM_POWER_STATUS	0x0069
 #define I8K_SMM_SET_FAN		0x01a3
@@ -755,9 +753,6 @@ static int __init i8k_init(void)
 	if (err)
 		goto exit_remove_proc;
 
-	pr_info("Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n",
-		I8K_VERSION);
-
 	return 0;
 
  exit_remove_proc:
-- 
1.7.9.7

