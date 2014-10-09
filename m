Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaJIRSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 13:18:04 -0400
Received: from mail-oi0-f44.google.com ([209.85.218.44]:41100 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaJIRRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 13:17:54 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Hauke Mehrtens <hauke@hauke-m.de>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2] bcma: Add dependency on OF_ADDRESS
Date: Thu,  9 Oct 2014 10:17:43 -0700
Message-Id: <1412875063-3576-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2101e533f41a ("bcma: register bcma as device tree driver")
introduces a hard dependency on OF_ADDRESS into the bcma driver.
OF_ADDRESS is specifically disabled for the sparc architecture.
This results in the following error when building sparc64:allmodconfig.

drivers/bcma/main.c: In function 'bcma_of_find_child_device':
drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'

Only build the bcma driver if OF is not configured or if both
OF and OF_ADDRESS are configured to solve the problem.

Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Limit additional dependency to '!OF || OF_ADDRESS'. 

 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 0ee48be..e240ef0 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -1,6 +1,6 @@
 config BCMA_POSSIBLE
 	bool
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM && HAS_DMA && (!OF || OF_ADDRESS)
 	default y
 
 menu "Broadcom specific AMBA"
-- 
1.9.1

