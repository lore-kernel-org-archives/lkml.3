Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaLFPUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:20:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47728 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752153AbaLFPII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:08 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/66] ASoC: sgtl5000: Fix SMALL_POP bit definition
Date: Sat,  6 Dec 2014 16:07:17 +0100
Message-Id: <d1c6c007710cb9b487e79e1e4e34d4efd8e4f2d2.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c251ea7bd7a04f1f2575467e0de76e803cf59149 upstream.

On a mx28evk with a sgtl5000 codec we notice a loud 'click' sound  to happen
5 seconds after the end of a playback.

The SMALL_POP bit should fix this, but its definition is incorrect:
according to the sgtl5000 manual it is bit 0 of CHIP_REF_CTRL register, not
bit 1.

Fix the definition accordingly and enable the bit as intended per the code
comment.

After applying this change, no loud 'click' sound is heard after playback

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/sgtl5000.c | 3 +--
 sound/soc/codecs/sgtl5000.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 1f4093f3f3a1..b76c6b619227 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1398,8 +1398,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 
 	/* enable small pop, introduce 400ms delay in turning off */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
-				SGTL5000_SMALL_POP,
-				SGTL5000_SMALL_POP);
+				SGTL5000_SMALL_POP, 1);
 
 	/* disable short cut detector */
 	snd_soc_write(codec, SGTL5000_CHIP_SHORT_CTRL, 0);
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index 2f8c88931f69..bd7a344bf8c5 100644
--- a/sound/soc/codecs/sgtl5000.h
+++ b/sound/soc/codecs/sgtl5000.h
@@ -275,7 +275,7 @@
 #define SGTL5000_BIAS_CTRL_MASK			0x000e
 #define SGTL5000_BIAS_CTRL_SHIFT		1
 #define SGTL5000_BIAS_CTRL_WIDTH		3
-#define SGTL5000_SMALL_POP			0x0001
+#define SGTL5000_SMALL_POP			0
 
 /*
  * SGTL5000_CHIP_MIC_CTRL
-- 
2.1.3

