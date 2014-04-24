Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaDXMlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:41:21 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:40765 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbaDXMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:05 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Peter Griffin <peter.griffin@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 08/13] video/backlight: LM3630A needs PWM
Date: Thu, 24 Apr 2014 13:28:24 +0100
Message-Id: <1398342509-10243-9-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LM3630A driver cannot be successfully built if we don't
enable the PWM subsystem. This patch makes that dependency
explicit in Kconfig and prevents broken randconfig builds.

Based on Arnd Bergmann patch but split out into seperate
commits per driver based on feedback.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/backlight/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 5a3eb2e..4791af7 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -370,7 +370,7 @@ config BACKLIGHT_AAT2870
 
 config BACKLIGHT_LM3630A
 	tristate "Backlight Driver for LM3630A"
-	depends on BACKLIGHT_CLASS_DEVICE && I2C
+	depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM
 	select REGMAP_I2C
 	help
 	  This supports TI LM3630A Backlight Driver
-- 
1.7.9.5

