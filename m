Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbaEDQSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:18:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaEDPmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 05/86] ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
Date: Sun,  4 May 2014 11:40:40 -0400
Message-Id: <20140504154141.147167772@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit 1555b652970e541fa1cb80c61ffc696bbfb92bb7 upstream.

The mask bits values were wrong for the SOC_VALUE_ENUM_SINGLE for the mono mix controls.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l73.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -325,7 +325,7 @@ static const char * const cs42l73_mono_m
 static const unsigned int cs42l73_mono_mix_values[] = { 0, 1, 2 };
 
 static const struct soc_enum spk_asp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 6, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 6, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);
@@ -343,7 +343,7 @@ static const struct snd_kcontrol_new spk
 	SOC_DAPM_ENUM("Route", spk_xsp_enum);
 
 static const struct soc_enum esl_asp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 2, 5,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 2, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);
@@ -352,7 +352,7 @@ static const struct snd_kcontrol_new esl
 	SOC_DAPM_ENUM("Route", esl_asp_enum);
 
 static const struct soc_enum esl_xsp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 0, 7,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 0, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);


