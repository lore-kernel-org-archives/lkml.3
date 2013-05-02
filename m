Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab3EBPQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60463 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3EBPQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Philippe LANGLAIS <philippe.langlais@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH, RFC 10/22] mfd: ab8500: debugfs code depends on gpadc
Date: Thu,  2 May 2013 17:16:14 +0200
Message-Id: <1367507786-505303-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:LZxSlQsTifDxI+skECVKiDR20JP8K1xCdzcPQ+L94Am
 cQ7gnWn8lcPAUWdsDzku5r+j7IhiBKOJm2M2rfbPqgOQQSuZBS
 KJDFOT3WoVFsuTYVL0ZyLOJKNEhyoYb5o/YH62aZhqXrIPC9Z8
 vOP4KkIBNNO5sTFv4VkwMYh3obl7hRW33Gpl2MnAvdWCr7RwEO
 4ywZBdQe9qy71PG+/THOv/zx4x4Duw7gK8Kuwacd+7taUOBDRi
 /v0aQAEvhmXOjhZYynd5XAtEvBMRSJ0+1QkVkHtr31BjsOY2Lw
 jt/1UKbx6COzUM4uJ5RbE4+WIY5hTcLLKv0GaS20an6wABXC0g
 chySiFCcwa6dMUwHspxxo+S9jpQUGuELtUm0jgEbq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500_DEBUG code specifically requires access to the gpadc code,
not just the common ab8500 driver.

drivers/built-in.o: In function `ab8500_gpadc_bat_ctrl_print':
 mfd/ab8500-debugfs.c:1733: undefined reference to `ab8500_gpadc_get'
 mfd/ab8500-debugfs.c:1734: undefined reference to `ab8500_gpadc_read_raw'
 mfd/ab8500-debugfs.c:1736: undefined reference to `ab8500_gpadc_ad_to_voltage'

Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9b4703e..bf785db 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -580,7 +580,7 @@ config AB8500_CORE
 
 config AB8500_DEBUG
        bool "Enable debug info via debugfs"
-       depends on AB8500_CORE && DEBUG_FS
+       depends on AB8500_GPADC && DEBUG_FS
        default y if DEBUG_FS
        help
          Select this option if you want debug information using the debug
-- 
1.8.1.2

