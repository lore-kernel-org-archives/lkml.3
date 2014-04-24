Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbaDXM3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:29:07 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:36859 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbaDXM27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:28:59 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Anatolij Gustschin <agust@denx.de>
Subject: [PATCH 03/13] video: clarify I2C dependencies
Date: Thu, 24 Apr 2014 13:28:19 +0100
Message-Id: <1398342509-10243-4-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

We can only use I2C support in frame buffer drivers if
Either I2C is built-in, or both I2C and the driver itself
are loadable modules.

Fix this dependency for MB862XX and CyberPro frame buffers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Anatolij Gustschin <agust@denx.de>
---
 drivers/video/fbdev/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index a4116bf..5577a94 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -360,6 +360,7 @@ config FB_CYBER2000_DDC
 config FB_CYBER2000_I2C
 	bool "CyberPro 2000/2010/5000 I2C support"
 	depends on FB_CYBER2000 && I2C && ARCH_NETWINDER
+	depends on I2C=y || FB_CYBER2000=m
 	select I2C_ALGOBIT
 	help
 	  Enable support for the I2C video decoder interface on the
@@ -2296,6 +2297,7 @@ endchoice
 config FB_MB862XX_I2C
 	bool "Support I2C bus on MB862XX GDC"
 	depends on FB_MB862XX && I2C
+	depends on FB_MB862XX=m || I2C=y
 	default y
 	help
 	  Selecting this option adds Coral-P(A)/Lime GDC I2C bus adapter
-- 
1.7.9.5

