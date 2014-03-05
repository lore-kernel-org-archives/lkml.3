Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbaCEOiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932374AbaCEOiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:15 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 44/62] ASoC: sta32x: Fix array access overflow
Date: Wed,  5 Mar 2014 14:36:48 +0000
Message-Id: <1394030226-26652-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 025c3fa9256d4c54506b7a29dc3befac54f5c68d upstream.

Preset EQ enum of sta32x codec driver declares too many number of
items and it may lead to the access over the actual array size.

Use SOC_ENUM_SINGLE_DECL() helper and it's automatically fixed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/sta32x.c | 72 +++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 36 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 8d717f4..cf5a63a 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -147,42 +147,42 @@ static const unsigned int sta32x_limiter_drc_release_tlv[] = {
 	13, 16, TLV_DB_SCALE_ITEM(-1500, 300, 0),
 };
 
-static const struct soc_enum sta32x_drc_ac_enum =
-	SOC_ENUM_SINGLE(STA32X_CONFD, STA32X_CONFD_DRC_SHIFT,
-			2, sta32x_drc_ac);
-static const struct soc_enum sta32x_auto_eq_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO1, STA32X_AUTO1_AMEQ_SHIFT,
-			3, sta32x_auto_eq_mode);
-static const struct soc_enum sta32x_auto_gc_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO1, STA32X_AUTO1_AMGC_SHIFT,
-			4, sta32x_auto_gc_mode);
-static const struct soc_enum sta32x_auto_xo_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO2, STA32X_AUTO2_XO_SHIFT,
-			16, sta32x_auto_xo_mode);
-static const struct soc_enum sta32x_preset_eq_enum =
-	SOC_ENUM_SINGLE(STA32X_AUTO3, STA32X_AUTO3_PEQ_SHIFT,
-			32, sta32x_preset_eq_mode);
-static const struct soc_enum sta32x_limiter_ch1_enum =
-	SOC_ENUM_SINGLE(STA32X_C1CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter_ch2_enum =
-	SOC_ENUM_SINGLE(STA32X_C2CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter_ch3_enum =
-	SOC_ENUM_SINGLE(STA32X_C3CFG, STA32X_CxCFG_LS_SHIFT,
-			3, sta32x_limiter_select);
-static const struct soc_enum sta32x_limiter1_attack_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L1AR, STA32X_LxA_SHIFT,
-			16, sta32x_limiter_attack_rate);
-static const struct soc_enum sta32x_limiter2_attack_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L2AR, STA32X_LxA_SHIFT,
-			16, sta32x_limiter_attack_rate);
-static const struct soc_enum sta32x_limiter1_release_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L1AR, STA32X_LxR_SHIFT,
-			16, sta32x_limiter_release_rate);
-static const struct soc_enum sta32x_limiter2_release_rate_enum =
-	SOC_ENUM_SINGLE(STA32X_L2AR, STA32X_LxR_SHIFT,
-			16, sta32x_limiter_release_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_drc_ac_enum,
+			    STA32X_CONFD, STA32X_CONFD_DRC_SHIFT,
+			    sta32x_drc_ac);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_eq_enum,
+			    STA32X_AUTO1, STA32X_AUTO1_AMEQ_SHIFT,
+			    sta32x_auto_eq_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_gc_enum,
+			    STA32X_AUTO1, STA32X_AUTO1_AMGC_SHIFT,
+			    sta32x_auto_gc_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_auto_xo_enum,
+			    STA32X_AUTO2, STA32X_AUTO2_XO_SHIFT,
+			    sta32x_auto_xo_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_preset_eq_enum,
+			    STA32X_AUTO3, STA32X_AUTO3_PEQ_SHIFT,
+			    sta32x_preset_eq_mode);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch1_enum,
+			    STA32X_C1CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch2_enum,
+			    STA32X_C2CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter_ch3_enum,
+			    STA32X_C3CFG, STA32X_CxCFG_LS_SHIFT,
+			    sta32x_limiter_select);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter1_attack_rate_enum,
+			    STA32X_L1AR, STA32X_LxA_SHIFT,
+			    sta32x_limiter_attack_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_attack_rate_enum,
+			    STA32X_L2AR, STA32X_LxA_SHIFT,
+			    sta32x_limiter_attack_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter1_release_rate_enum,
+			    STA32X_L1AR, STA32X_LxR_SHIFT,
+			    sta32x_limiter_release_rate);
+static SOC_ENUM_SINGLE_DECL(sta32x_limiter2_release_rate_enum,
+			    STA32X_L2AR, STA32X_LxR_SHIFT,
+			    sta32x_limiter_release_rate);
 
 /* byte array controls for setting biquad, mixer, scaling coefficients;
  * for biquads all five coefficients need to be set in one go,
-- 
1.9.0

