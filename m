Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab3HKSAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 14:00:12 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:34897 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851Ab3HKSAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 14:00:07 -0400
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
Subject: [PATCH 10/18] spi: s3c64xx: Do not require legacy DMA API in case of S3C64XX
Date: Sun, 11 Aug 2013 19:59:22 +0200
Message-Id: <1376243970-6489-11-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With support for amba-pl08x driver, on S3C64xx the generic DMA engine
API can be used instead of the private s3c-dma interface.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 89cbbab..241a049 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -366,7 +366,7 @@ config SPI_S3C24XX_FIQ
 config SPI_S3C64XX
 	tristate "Samsung S3C64XX series type SPI"
 	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5P64X0 || ARCH_EXYNOS)
-	select S3C64XX_DMA if ARCH_S3C64XX
+	select S3C64XX_DMA if ARCH_S3C64XX && !S3C64XX_PL080
 	help
 	  SPI driver for Samsung S3C64XX and newer SoCs.
 
-- 
1.8.3.2

