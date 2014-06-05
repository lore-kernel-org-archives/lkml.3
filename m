Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaFEUt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:49:27 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49482 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaFEUtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:49:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH 3/5] staging: sn9c102 depends on USB
Date: Thu,  5 Jun 2014 22:48:13 +0200
Message-Id: <1402001295-1980118-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
References: <1402001295-1980118-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/guZi+gpUFkZGGvbW+OQELeQ0q68jXCrfGVBCtFVXDP
 DTr0heTRiBnclL2QMYGVlDdlVeBl+MF4Alq3nqwcbJIOitkYrd
 c14ywa0wWOBWk86g+qqBFU2SBtQyB7FalMRkFkMhRFN8wx7Owq
 7iR1Q85jgIU/vnskHhNddwG3fambCu+S6bFiL6eg3Y4bkdmfHy
 Kc5dKMIHUdUU4NUB2Vo8ZoWhfH3btfisBRIblY/px7Tt9MbIpS
 FxM+80RMUpdQhbtAwaZjg/6CsboWvV9fD6eiGFNeoCLeMLW6Mf
 tQGMjrHYdAtgThjeT9+3ehIUK66+22n9SNhaNguwDnFKw9Zzat
 +gLTfFdxqy2IEhq0wT0BVdQaplOcI2dbSvuByDHX4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the USB code is a loadable module, this driver cannot
be built-in. This adds an explicit dependency on CONFIG_USB
so that Kconfig can force sn9c102 to be a module in this case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org
---
 drivers/staging/media/sn9c102/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/sn9c102/Kconfig b/drivers/staging/media/sn9c102/Kconfig
index c9aba59..10f586b 100644
--- a/drivers/staging/media/sn9c102/Kconfig
+++ b/drivers/staging/media/sn9c102/Kconfig
@@ -1,6 +1,6 @@
 config USB_SN9C102
 	tristate "USB SN9C1xx PC Camera Controller support (DEPRECATED)"
-	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT
+	depends on VIDEO_V4L2 && MEDIA_USB_SUPPORT && USB
 	---help---
 	  This driver is DEPRECATED, please use the gspca sonixb and
 	  sonixj modules instead.
-- 
1.8.3.2

