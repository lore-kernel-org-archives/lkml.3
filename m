Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3IKE6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab3IKE5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:01 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=csMbrbFfz1oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=lDtrDCPKWOoA:10 a=w1d2syhTAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=_inCW7atr90A:10 a=WwgC8nHKvroA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042925.616512026@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        <stable@kernel.org>
Subject: [201/251] ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0201-ASoC-cs42l52-Reorder-Min-Max-and-update-to-SX_TLV-fo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

[ Upstream commit e2c98a8bba958045bde861fe1d66be54315c7790 ]

Beep Volume Min/Max was backwards.
Change to SOC_SONGLE_SX_TLV for correct volume representation

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/codecs/cs42l52.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index d34aa42..c05e6b2 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -450,7 +450,7 @@ static const struct snd_kcontrol_new cs42l52_snd_controls[] = {
 	SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07, hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07, 0x1f, hl_tlv),
 	SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL, 5, 1, 1),
 	SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),
-- 
1.7.10.4


