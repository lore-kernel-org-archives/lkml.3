Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3HRUoz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:44:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3HRUe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 21/45] ASoC: cs42l52: Reorder Min/Max and update to SX_TLV for Beep Volume
Date: Sun, 18 Aug 2013 13:36:10 -0700
Message-Id: <20130818203622.481668447@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit e2c98a8bba958045bde861fe1d66be54315c7790 upstream.

Beep Volume Min/Max was backwards.
Change to SOC_SONGLE_SX_TLV for correct volume representation

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l52.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -451,7 +451,7 @@ static const struct snd_kcontrol_new cs4
 	SOC_ENUM("Beep Pitch", beep_pitch_enum),
 	SOC_ENUM("Beep on Time", beep_ontime_enum),
 	SOC_ENUM("Beep off Time", beep_offtime_enum),
-	SOC_SINGLE_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x1f, 0x07, hl_tlv),
+	SOC_SINGLE_SX_TLV("Beep Volume", CS42L52_BEEP_VOL, 0, 0x07, 0x1f, hl_tlv),
 	SOC_SINGLE("Beep Mixer Switch", CS42L52_BEEP_TONE_CTL, 5, 1, 1),
 	SOC_ENUM("Beep Treble Corner Freq", beep_treble_enum),
 	SOC_ENUM("Beep Bass Corner Freq", beep_bass_enum),


