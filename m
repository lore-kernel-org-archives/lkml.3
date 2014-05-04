Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaEDRCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:02:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaEDPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 005/158] ASoC: cs42l52: Fix mask bits for SOC_VALUE_ENUM_SINGLE
Date: Sun,  4 May 2014 11:38:34 -0400
Message-Id: <20140504154030.749708634@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit d31a33dd7792c7d6c11fda226a3b9e4fb7f86f95 upstream.

The mask bits values were wrong for the SOC_VALUE_ENUM_SINGLE for the PCM/ADC Swap controls

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l52.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -347,7 +347,7 @@ static const char * const right_swap_tex
 static const unsigned int swap_values[] = { 0, 1, 3 };
 
 static const struct soc_enum adca_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 2, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 2, 3,
 			      ARRAY_SIZE(left_swap_text),
 			      left_swap_text,
 			      swap_values);
@@ -356,7 +356,7 @@ static const struct snd_kcontrol_new adc
 	SOC_DAPM_ENUM("Route", adca_swap_enum);
 
 static const struct soc_enum pcma_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 6, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 6, 3,
 			      ARRAY_SIZE(left_swap_text),
 			      left_swap_text,
 			      swap_values);
@@ -365,7 +365,7 @@ static const struct snd_kcontrol_new pcm
 	SOC_DAPM_ENUM("Route", pcma_swap_enum);
 
 static const struct soc_enum adcb_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 0, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 0, 3,
 			      ARRAY_SIZE(right_swap_text),
 			      right_swap_text,
 			      swap_values);
@@ -374,7 +374,7 @@ static const struct snd_kcontrol_new adc
 	SOC_DAPM_ENUM("Route", adcb_swap_enum);
 
 static const struct soc_enum pcmb_swap_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 4, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L52_ADC_PCM_MIXER, 4, 3,
 			      ARRAY_SIZE(right_swap_text),
 			      right_swap_text,
 			      swap_values);


