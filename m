Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbbA1Ea3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:30:29 -0500
Received: from mail.kernel.org ([198.145.29.136]:41310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965297AbbA1E0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:26:03 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Brown <broonie@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 164/177] ASoC: sgtl5000: Fix SMALL_POP bit definition
Date: Wed, 28 Jan 2015 12:10:22 +0800
Message-Id: <1422418236-12852-255-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/soc/codecs/sgtl5000.c | 3 +--
 sound/soc/codecs/sgtl5000.h | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index f0b8d8e..c40b7ca 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1313,8 +1313,7 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 
 	/* enable small pop, introduce 400ms delay in turning off */
 	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
-				SGTL5000_SMALL_POP,
-				SGTL5000_SMALL_POP);
+				SGTL5000_SMALL_POP, 1);
 
 	/* disable short cut detector */
 	snd_soc_write(codec, SGTL5000_CHIP_SHORT_CTRL, 0);
diff --git a/sound/soc/codecs/sgtl5000.h b/sound/soc/codecs/sgtl5000.h
index d3a68bb..0bd6e1c 100644
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

