Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab3ICQii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:38:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46421 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3ICQYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 06/58] ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
Date: Tue,  3 Sep 2013 09:23:10 -0700
Message-Id: <1378225442-20654-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit e2c98a8bba958045bde861fe1d66be54315c7790 upstream.

Beep Volume Min/Max was backwards.
Change to SOC_SONGLE_SX_TLV for correct volume representation

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index bbd8c11..391fee2 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -449,7 +449,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 	SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07, hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07, 0x1f, hl_tlv),
 	SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL, 5, 1, 1),
 	SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),
-- 
1.8.1.2

