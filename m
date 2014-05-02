Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbaEBPpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44144 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758AbaEBPo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:44:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 078/151] ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols
Date: Fri,  2 May 2014 08:37:46 -0700
Message-Id: <1399045139-4531-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit 7272e051157ccd5871b5d939548d0ba5a94a2965 upstream.

The shift values for the ADC,PCM, and Analog kcontrols were wrong causing wrong values for the SOC_DOUBLE_R_SX_TLV macros
Fixed the TLV for aout_tlv to show -102dB correctly

Fixes: 1d99f2436d (ASoC: core: Rework SOC_DOUBLE_R_SX_TLV add SOC_SINGLE_SX_TLV)
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/cs42l51.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 1e0fa3b..e1dfebb 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -124,9 +124,8 @@ static int cs42l51_set_chan_mix(struct snd_kcontrol *kcontrol,
 
 static const DECLARE_TLV_DB_SCALE(adc_pcm_tlv, -5150, 50, 0);
 static const DECLARE_TLV_DB_SCALE(tone_tlv, -1050, 150, 0);
-/* This is a lie. after -102 db, it stays at -102 */
-/* maybe a range would be better */
-static const DECLARE_TLV_DB_SCALE(aout_tlv, -11550, 50, 0);
+
+static const DECLARE_TLV_DB_SCALE(aout_tlv, -10200, 50, 0);
 
 static const DECLARE_TLV_DB_SCALE(boost_tlv, 1600, 1600, 0);
 static const char *chan_mix[] = {
@@ -141,7 +140,7 @@ static const struct soc_enum cs42l51_chan_mix =
 static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 	SOC_DOUBLE_R_SX_TLV("PCM Playback Volume",
 			CS42L51_PCMA_VOL, CS42L51_PCMB_VOL,
-			6, 0x19, 0x7F, adc_pcm_tlv),
+			0, 0x19, 0x7F, adc_pcm_tlv),
 	SOC_DOUBLE_R("PCM Playback Switch",
 			CS42L51_PCMA_VOL, CS42L51_PCMB_VOL, 7, 1, 1),
 	SOC_DOUBLE_R_SX_TLV("Analog Playback Volume",
@@ -149,7 +148,7 @@ static const struct snd_kcontrol_new cs42l51_snd_controls[] = {
 			0, 0x34, 0xE4, aout_tlv),
 	SOC_DOUBLE_R_SX_TLV("ADC Mixer Volume",
 			CS42L51_ADCA_VOL, CS42L51_ADCB_VOL,
-			6, 0x19, 0x7F, adc_pcm_tlv),
+			0, 0x19, 0x7F, adc_pcm_tlv),
 	SOC_DOUBLE_R("ADC Mixer Switch",
 			CS42L51_ADCA_VOL, CS42L51_ADCB_VOL, 7, 1, 1),
 	SOC_SINGLE("Playback Deemphasis Switch", CS42L51_DAC_CTL, 3, 1, 0),
-- 
1.9.1

