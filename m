Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870AbaEMKn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:43:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60746 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760019AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 008/182] ASoC: cs42l51: Fix SOC_DOUBLE_R_SX_TLV shift values for ADC, PCM, and Analog kcontrols
Date: Tue, 13 May 2014 11:26:00 +0200
Message-Id: <1d82fbd14064105af9ad50c5c6ab5a1a2db3a980.1399973152.git.jslaby@suse.cz>
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

commit 7272e051157ccd5871b5d939548d0ba5a94a2965 upstream.

The shift values for the ADC,PCM, and Analog kcontrols were wrong causing wrong values for the SOC_DOUBLE_R_SX_TLV macros
Fixed the TLV for aout_tlv to show -102dB correctly

Fixes: 1d99f2436d (ASoC: core: Rework SOC_DOUBLE_R_SX_TLV add SOC_SINGLE_SX_TLV)
Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/cs42l51.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 1e0fa3b5f79a..e1dfebbea650 100644
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
1.9.3

