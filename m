Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481AbaLBTY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:24:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbaLBTYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:24:54 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 102/121] ASoC: sgtl5000: Fix SMALL_POP bit definition
Date: Tue,  2 Dec 2014 11:19:41 -0800
Message-Id: <1417548000-1794-103-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/sgtl5000.c | 3 +--
 sound/soc/codecs/sgtl5000.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 1f4093f..b76c6b6 100644
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
index 2f8c889..bd7a344 100644
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
1.9.1

