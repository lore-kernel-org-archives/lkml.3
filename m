Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab3I1SWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:22:19 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:63246 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3I1SWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:22:14 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 3/5] [media] s3c-camif: Use CONFIG_ARCH_S3C64XX to check for S3C64xx support
Date: Sat, 28 Sep 2013 20:21:35 +0200
Message-Id: <1380392497-27406-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since CONFIG_PLAT_S3C64XX is going to be removed, this patch modifies
the Kconfig entry of s3c-camif driver to use the proper way of checking
for S3C64xx support - CONFIG_ARCH_S3C64XX.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/media/platform/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index c7caf94..eb70dda 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -112,7 +112,7 @@ config VIDEO_OMAP3_DEBUG
 config VIDEO_S3C_CAMIF
 	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
-	depends on (PLAT_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
+	depends on (ARCH_S3C64XX || PLAT_S3C24XX) && PM_RUNTIME
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  This is a v4l2 driver for s3c24xx and s3c64xx SoC series camera
-- 
1.8.3.2

