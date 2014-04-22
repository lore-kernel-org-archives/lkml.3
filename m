Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbaDVUid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:38:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaDVUYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 076/133] ASoC: cs42l73: Fix mask bits for SOC_VALUE_ENUM_SINGLE
Date: Tue, 22 Apr 2014 13:13:34 -0700
Message-Id: <1398197671-12786-77-git-send-email-kamal@canonical.com>
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

commit 1555b652970e541fa1cb80c61ffc696bbfb92bb7 upstream.

The mask bits values were wrong for the SOC_VALUE_ENUM_SINGLE for the mono mix controls.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/cs42l73.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs42l73.c b/sound/soc/codecs/cs42l73.c
index 6361dab..042540b 100644
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
1.9.1

