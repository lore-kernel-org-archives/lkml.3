Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3IBIzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3IBIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/58] ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
Date: Mon,  2 Sep 2013 09:53:54 +0100
Message-Id: <1378112083-9475-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit e2c98a8bba958045bde861fe1d66be54315c7790 upstream.

Beep Volume Min/Max was backwards.
Change to SOC_SONGLE_SX_TLV for correct volume representation

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 539e2f3..21b5d89 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -451,7 +451,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 	SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07, hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07, 0x1f, hl_tlv),
 	SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL, 5, 1, 1),
 	SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),
-- 
1.8.3.2

