Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab3APQAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:00:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757468Ab3APQAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 053/222] ASoC: wm8994: Use the same DCS codes for all WM1811 variants
Date: Wed, 16 Jan 2013 13:54:13 -0200
Message-Id: <1358351822-7675-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 72222be39afbd39c16eb180646b0ac44bb1ba460 upstream.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[ herton: rediff with different switch options in 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/wm8994.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index fc9afc8..7b9b4ef 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3783,17 +3783,8 @@ static int wm8994_codec_probe(struct snd_soc_codec *codec)
 		wm8994->hubs.no_cache_dac_hp_direct = true;
 		wm8994->fll_byp = true;
 
-		switch (wm8994->revision) {
-		case 0:
-		case 1:
-		case 2:
-		case 3:
-			wm8994->hubs.dcs_codes_l = -9;
-			wm8994->hubs.dcs_codes_r = -7;
-			break;
-		default:
-			break;
-		}
+		wm8994->hubs.dcs_codes_l = -9;
+		wm8994->hubs.dcs_codes_r = -7;
 
 		snd_soc_update_bits(codec, WM8994_ANALOGUE_HP_1,
 				    WM1811_HPOUT1_ATTN, WM1811_HPOUT1_ATTN);
-- 
1.7.9.5

