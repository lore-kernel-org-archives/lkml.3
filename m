Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3FVUoN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 16:44:13 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:45890 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3FVUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 16:43:35 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Padmavathi Venna <padma.v@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [RFC PATCH v2 09/12] clk: samsung: s3c64xx: Add aliases for DMA clocks
Date: Sat, 22 Jun 2013 22:42:41 +0200
Message-Id: <1371933764-24875-10-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
References: <1371933764-24875-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new amba-pl08x driver requires another set of clock aliases, so this
patch adds them.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/clk/samsung/clk-s3c64xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/samsung/clk-s3c64xx.c b/drivers/clk/samsung/clk-s3c64xx.c
index 253a972..9fb750c 100644
--- a/drivers/clk/samsung/clk-s3c64xx.c
+++ b/drivers/clk/samsung/clk-s3c64xx.c
@@ -315,6 +315,8 @@ static struct samsung_clock_alias s3c64xx_clock_aliases[] = {
 	ALIAS(HCLK_HSMMC0, "s3c-sdhci.0", "mmc_busclk.0"),
 	ALIAS(HCLK_DMA1, NULL, "dma1"),
 	ALIAS(HCLK_DMA0, NULL, "dma0"),
+	ALIAS(HCLK_DMA1, "dma-pl080s.1", "apb_pclk"),
+	ALIAS(HCLK_DMA0, "dma-pl080s.0", "apb_pclk"),
 	ALIAS(HCLK_CAMIF, "s3c-camif", "camif"),
 	ALIAS(HCLK_LCD, "s3c-fb", "lcd"),
 	ALIAS(PCLK_SPI1, "s3c6410-spi.1", "spi"),
-- 
1.8.2.1

