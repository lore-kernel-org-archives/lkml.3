Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376AbaEMKoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:44:02 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60742 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760018AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 010/182] ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
Date: Tue, 13 May 2014 11:26:02 +0200
Message-Id: <c370ebfcb68a26c139bbe27a4eed2bae58e54688.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Austin <brian.austin@cirrus.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1555b652970e541fa1cb80c61ffc696bbfb92bb7 upstream.

The mask bits values were wrong for the SOC_VALUE_ENUM_SINGLE for the mono mix controls.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/cs42l73.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 3b20c86cdb01..eade6e2d883d 100644
--- a/sound/soc/codecs/cs42l73.c
+++ b/sound/soc/codecs/cs42l73.c
@@ -325,7 +325,7 @@ static const char * const cs42l73_mono_mix_texts[] = {
 static const unsigned int cs42l73_mono_mix_values[] = { 0, 1, 2 };
 
 static const struct soc_enum spk_asp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 6, 1,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 6, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);
@@ -343,7 +343,7 @@ static const struct snd_kcontrol_new spk_xsp_mixer =
 	SOC_DAPM_ENUM("Route", spk_xsp_enum);
 
 static const struct soc_enum esl_asp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 2, 5,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 2, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);
@@ -352,7 +352,7 @@ static const struct snd_kcontrol_new esl_asp_mixer =
 	SOC_DAPM_ENUM("Route", esl_asp_enum);
 
 static const struct soc_enum esl_xsp_enum =
-	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 0, 7,
+	SOC_VALUE_ENUM_SINGLE(CS42L73_MMIXCTL, 0, 3,
 			      ARRAY_SIZE(cs42l73_mono_mix_texts),
 			      cs42l73_mono_mix_texts,
 			      cs42l73_mono_mix_values);
-- 
1.9.3

