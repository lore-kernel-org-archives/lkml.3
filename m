Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaFEVY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:24:29 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:57375 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaFEVYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:24:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/3] mfd: STw481x: allow modular build
Date: Thu,  5 Jun 2014 23:24:14 +0200
Message-Id: <1402003454-1989084-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
References: <1402003454-1989084-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:6c3uZBat8cT0OsrkCw+xkNB5hmc6i3BRBwi0sDtDky1
 cU3HtGTkxwsRSW7093SpN8PT4+hwbDI2IDetNzyTPEZstMekfI
 BMfh49ix+GLPSlcxf30A9lx6r4zzCAh3+P1AKCaY6p3mLTHLiG
 eLl05Nz590A9BlhTW83vhw6SsJFA2KZJJA4etgQUXWxG5m3Chy
 QgFtizgwsmWEsLOqALV/D9JzK27zECbjKo5nZ+8L4EOd4m1B0K
 FYvUbChO7o9mS6mPuF7wqs5mj0DR4onigIgdt7dZ7FZeXVRv1n
 kXZHEFG4SabVJpKVumgflixSmFdOTAZy4xPs6LVBY9iEizE/Dm
 S9I3oVEt62b2Xa6i6ZhBI5sgFi2XAHj+aPrP4uMc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver depends on I2C, which may be a loadable module.
While you'd probably want both to be built-in in practice,
allowing a modular build avoids possible randconfig link
errors.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/mfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2dd838f..6cc4b6a 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1226,7 +1226,7 @@ config MFD_WM8994
 	  functionaltiy of the device other drivers must be enabled.
 
 config MFD_STW481X
-	bool "Support for ST Microelectronics STw481x"
+	tristate "Support for ST Microelectronics STw481x"
 	depends on I2C && ARCH_NOMADIK
 	select REGMAP_I2C
 	select MFD_CORE
-- 
1.8.3.2

