Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3FKIvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 04:51:25 -0400
Received: from skyrme.org ([193.175.80.135]:60060 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890Ab3FKIvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 04:51:24 -0400
X-Greylist: delayed 2357 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jun 2013 04:51:24 EDT
Date: 11 Jun 2013 08:12:00 +0000
Message-Id: <1370938320-6554-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Liam Girdwood" <lgirdwood@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Zeng Zhaoming" <zengzm.kernel@gmail.com>, alsa-devel@alsa-project.org,
        "Takashi Iwai" <tiwai@suse.de>, "Jaroslav Kysela" <perex@perex.cz>,
        "Fabio Estevam" <fabio.estevam@freescale.com>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH] sound/sgtl5000: fix codec register initial values and mask
X-Mailer: git-send-email 1.6.0.3
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
---
 sound/soc/codecs/sgtl5000.c |    2 +-
 sound/soc/codecs/sgtl5000.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 92bbfec..ea47938 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -37,7 +37,7 @@
 static const u16 sgtl5000_regs[SGTL5000_MAX_REG_OFFSET] =  {
 	[SGTL5000_CHIP_CLK_CTRL] = 0x0008,
 	[SGTL5000_CHIP_I2S_CTRL] = 0x0010,
-	[SGTL5000_CHIP_SSS_CTRL] = 0x0008,
+	[SGTL5000_CHIP_SSS_CTRL] = 0x0010,
 	[SGTL5000_CHIP_DAC_VOL] = 0x3c3c,
 	[SGTL5000_CHIP_PAD_STRENGTH] = 0x015f,
 	[SGTL5000_CHIP_ANA_HP_CTRL] = 0x1818,
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 8a9f435..d3a68bb 100644
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

