Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaCEOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:38:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459AbaCEOiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:38:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 45/62] ASoC: wm8770: Fix wrong number of enum items
Date: Wed,  5 Mar 2014 14:36:49 +0000
Message-Id: <1394030226-26652-46-git-send-email-luis.henriques@canonical.com>
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

commit 7a6c0a58dc824523966f212c76322d47c5b0e6fe upstream.

wm8770 codec driver defines ain_enum with a wrong number of items.

Use SOC_ENUM_DOUBLE_DECL() macro and it's automatically fixed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Acked-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/wm8770.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8770.c b/sound/soc/codecs/wm8770.c
index a5127b4..9e82674 100644
--- a/sound/soc/codecs/wm8770.c
+++ b/sound/soc/codecs/wm8770.c
@@ -162,8 +162,8 @@ static const char *ain_text[] = {
 	"AIN5", "AIN6", "AIN7", "AIN8"
 };
 
-static const struct soc_enum ain_enum =
-	SOC_ENUM_DOUBLE(WM8770_ADCMUX, 0, 4, 8, ain_text);
+static SOC_ENUM_DOUBLE_DECL(ain_enum,
+			    WM8770_ADCMUX, 0, 4, ain_text);
 
 static const struct snd_kcontrol_new ain_mux =
 	SOC_DAPM_ENUM("Capture Mux", ain_enum);
-- 
1.9.0

