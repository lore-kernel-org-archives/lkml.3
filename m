Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3FKPWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:22:37 -0400
Received: from skyrme.org ([193.175.80.135]:42821 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3FKPWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:22:36 -0400
Date: 11 Jun 2013 15:22:31 +0000
Message-Id: <1370964151-6728-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Liam Girdwood" <lgirdwood@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Zeng Zhaoming" <zengzm.kernel@gmail.com>, alsa-devel@alsa-project.org,
        "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@perex.cz>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH v2] sound/sgtl5000: fix codec register initial values and mask
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <51B71608.3000302@freescale.com>
References: <51B71608.3000302@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to documentation bit 3:2 in register SSS_CTRL are
reserved and zero, so initially setting the register to 0x0008
does not make much sense. Instead, bit 4 should be marked set,
as this is the power up default.

Further, mask computation in declarative part is obviously wrong:
Fix FRAC DIVISOR to provide an 11 bit mask correctly.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Tested-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 sound/soc/codecs/sgtl5000.c |    2 +-
 sound/soc/codecs/sgtl5000.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index d441559..10092ba 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -38,7 +38,7 @@
 static const struct reg_default sgtl5000_reg_defaults[] = {
 	{ SGTL5000_CHIP_CLK_CTRL,		0x0008 },
 	{ SGTL5000_CHIP_I2S_CTRL,		0x0010 },
-	{ SGTL5000_CHIP_SSS_CTRL,		0x0008 },
+	{ SGTL5000_CHIP_SSS_CTRL,		0x0010 },
 	{ SGTL5000_CHIP_DAC_VOL,		0x3c3c },
 	{ SGTL5000_CHIP_PAD_STRENGTH,		0x015f },
 	{ SGTL5000_CHIP_ANA_HP_CTRL,		0x1818 },
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 4b69229..52bd843 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -347,7 +347,7 @@
 #define SGTL5000_PLL_INT_DIV_MASK		0xf800
 #define SGTL5000_PLL_INT_DIV_SHIFT		11
 #define SGTL5000_PLL_INT_DIV_WIDTH		5
-#define SGTL5000_PLL_FRAC_DIV_MASK		0x0700
+#define SGTL5000_PLL_FRAC_DIV_MASK		0x07ff
 #define SGTL5000_PLL_FRAC_DIV_SHIFT		0
 #define SGTL5000_PLL_FRAC_DIV_WIDTH		11
 
-- 
1.7.9.5

