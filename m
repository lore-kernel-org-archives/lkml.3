Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaDXMhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:37:22 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36256 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254AbaDXMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:09 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 11/13] video/nuc900: allow modular build
Date: Thu, 24 Apr 2014 13:28:27 +0100
Message-Id: <1398342509-10243-12-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The frame buffer core may be a loadable module, and in this
case, the nuc900 driver cannot be built-in. Turning it into
a tristate option lets Kconfig work out the dependency and
avoid broken builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/video/fbdev/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig
index e593365..95396de 100644
--- a/drivers/video/fbdev/Kconfig
+++ b/drivers/video/fbdev/Kconfig
@@ -2065,7 +2065,7 @@ config FB_S3C2410_DEBUG
 	  through sysfs
 
 config FB_NUC900
-        bool "NUC900 LCD framebuffer support"
+        tristate "NUC900 LCD framebuffer support"
         depends on FB && ARCH_W90X900
         select FB_CFB_FILLRECT
         select FB_CFB_COPYAREA
-- 
1.7.9.5

