Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbaLOPNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:13:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38280 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaLOO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 025/168] ASoC: sgtl5000: Fix SMALL_POP bit definition
Date: Mon, 15 Dec 2014 14:24:39 +0000
Message-Id: <1418653622-21105-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/sgtl5000.c | 3 +--
 sound/soc/codecs/sgtl5000.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 3d39f0b5b4a8..f039d668266e 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1315,8 +1315,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 
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

