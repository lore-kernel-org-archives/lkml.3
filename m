Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3K2OEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 09:04:55 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756073Ab3K2OD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 09:03:58 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: [PATCH 1/5] ASoC: twl6040: Rename twl6040_is_path_unmuted -> twl6040_can_write_to_chip
Date: Fri, 29 Nov 2013 16:03:43 +0200
Message-ID: <1385733827-19831-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
References: <1385733827-19831-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matches more precisely of the functionality.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 sound/soc/codecs/twl6040.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index f2f4bcb..ef13a50 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -219,8 +219,8 @@ static int twl6040_read_reg_volatile(struct snd_soc_codec *codec,
 	return value;
 }
 
-static bool twl6040_is_path_unmuted(struct snd_soc_codec *codec,
-				    unsigned int reg)
+static bool twl6040_can_write_to_chip(struct snd_soc_codec *codec,
+				  unsigned int reg)
 {
 	struct twl6040_data *priv = snd_soc_codec_get_drvdata(codec);
 
@@ -250,7 +250,7 @@ static int twl6040_write(struct snd_soc_codec *codec,
 		return -EIO;
 
 	twl6040_write_reg_cache(codec, reg, value);
-	if (twl6040_is_path_unmuted(codec, reg))
+	if (twl6040_can_write_to_chip(codec, reg))
 		return twl6040_reg_write(twl6040, reg, value);
 	else
 		return 0;
-- 
1.8.4.2

