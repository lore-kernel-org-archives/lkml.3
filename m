Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaACN2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:28:32 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48575 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbaACN22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:28:28 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 11/11] ASoC: twl4030: Pass the twl4030_priv directly to twl4030_can_write_to_chip()
Date: Fri, 3 Jan 2014 15:27:56 +0200
Message-ID: <1388755676-16036-12-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
References: <1388755676-16036-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid another lookup for the twl4030_priv in there.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl4030.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index c3c15f891270..00665ada23e2 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -111,10 +111,9 @@ static unsigned int twl4030_read(struct snd_soc_codec *codec, unsigned int reg)
 	return value;
 }
 
-static bool twl4030_can_write_to_chip(struct snd_soc_codec *codec,
+static bool twl4030_can_write_to_chip(struct twl4030_priv *twl4030,
 				      unsigned int reg)
 {
-	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	bool write_to_reg = false;
 
 	/* Decide if the given register can be written */
@@ -171,7 +170,7 @@ static int twl4030_write(struct snd_soc_codec *codec, unsigned int reg,
 		break;
 	}
 
-	if (twl4030_can_write_to_chip(codec, reg))
+	if (twl4030_can_write_to_chip(twl4030, reg))
 		return twl_i2c_write_u8(TWL4030_MODULE_AUDIO_VOICE, value, reg);
 
 	return 0;
-- 
1.8.5.2

