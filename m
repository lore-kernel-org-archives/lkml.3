Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaDVUYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:24:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36595 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757661AbaDVUY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 077/133] ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
Date: Tue, 22 Apr 2014 13:13:35 -0700
Message-Id: <1398197671-12786-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit d31a33dd7792c7d6c11fda226a3b9e4fb7f86f95 upstream.

The mask bits values were wrong for the SOC_VALUE_ENUM_SINGLE for the PCM/ADC Swap controls

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/cs42l52.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 391fee2..75b5f94 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -348,7 +348,7 @@ static const char * const right_swap_text[] = {
 static const unsigned int swap_values[] = { 0, 1, 3 };
 
 static const struct soc_enum adca_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 2, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 2, 3,
 			      ARRAY_SIZE(left_swap_text),
 			      left_swap_text,
 			      swap_values);
@@ -357,7 +357,7 @@ static const struct snd_kcontrol_new adca_mixer =
 	SOC_DAPM_ENUM("Route", adca_swap_enum);
 
 static const struct soc_enum pcma_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 6, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 6, 3,
 			      ARRAY_SIZE(left_swap_text),
 			      left_swap_text,
 			      swap_values);
@@ -366,7 +366,7 @@ static const struct snd_kcontrol_new pcma_mixer =
 	SOC_DAPM_ENUM("Route", pcma_swap_enum);
 
 static const struct soc_enum adcb_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 0, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 0, 3,
 			      ARRAY_SIZE(right_swap_text),
 			      right_swap_text,
 			      swap_values);
@@ -375,7 +375,7 @@ static const struct snd_kcontrol_new adcb_mixer =
 	SOC_DAPM_ENUM("Route", adcb_swap_enum);
 
 static const struct soc_enum pcmb_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 4, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 4, 3,
 			      ARRAY_SIZE(right_swap_text),
 			      right_swap_text,
 			      swap_values);
-- 
1.9.1

