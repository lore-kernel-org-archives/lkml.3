Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3HKSAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:00:47 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:42994 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab3HKSA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 14:00:26 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Dan Williams <djbw@fb.com>, Jaroslav Kysela <perex@perex.cz>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 18/18] ASoC: Samsung: Always select S3C64XX_PL080 when ARCH_S3C64XX is enabled
Date: Sun, 11 Aug 2013 19:59:30 +0200
Message-Id: <1376243970-6489-19-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy S3C64xx DMA driver has been removed, DMA support on
S3C64xx is provided only by the generic PL08x driver.

This patch modifies the Kconfig entry of Samsung ASoC subsystem, which
relies on availability of DMA, to always select the S3C64XX_PL080
symbol.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 sound/soc/samsung/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/Kconfig b/sound/soc/samsung/Kconfig
index 55b514d..5b5be90 100644
--- a/sound/soc/samsung/Kconfig
+++ b/sound/soc/samsung/Kconfig
@@ -1,7 +1,7 @@
 config SND_SOC_SAMSUNG
 	tristate "ASoC support for Samsung"
 	depends on PLAT_SAMSUNG
-	select S3C64XX_DMA if ARCH_S3C64XX && !S3C64XX_PL080
+	select S3C64XX_PL080 if ARCH_S3C64XX
 	select S3C2410_DMA if ARCH_S3C24XX
 	help
 	  Say Y or M if you want to add support for codecs attached to
-- 
1.8.3.2

