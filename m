Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaKLBXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:23:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58624 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaKLBXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:23:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 038/319] ASoC: adau1761: Fix input PGA volume
Date: Wed, 12 Nov 2014 10:12:56 +0900
Message-Id: <20141112010958.990150126@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 3b283f0893f55cb79e4507e5ec34e49c17d0a787 upstream.

For the input PGA to work correctly the ALC clock needs to be active.
Otherwise volume changes are not applied.

Fixes: dab464b60b2 ("ASoC: Add ADAU1361/ADAU1761 audio CODEC support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/adau1761.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/adau1761.c
+++ b/sound/soc/codecs/adau1761.c
@@ -405,6 +405,7 @@ static const struct snd_soc_dapm_widget
 		2, 0, NULL, 0),
 
 	SND_SOC_DAPM_SUPPLY("Slew Clock", ADAU1761_CLK_ENABLE0, 6, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("ALC Clock", ADAU1761_CLK_ENABLE0, 5, 0, NULL, 0),
 
 	SND_SOC_DAPM_SUPPLY_S("Digital Clock 0", 1, ADAU1761_CLK_ENABLE1,
 		0, 0, NULL, 0),
@@ -436,6 +437,9 @@ static const struct snd_soc_dapm_route a
 	{ "Right Playback Mixer", NULL, "Slew Clock" },
 	{ "Left Playback Mixer", NULL, "Slew Clock" },
 
+	{ "Left Input Mixer", NULL, "ALC Clock" },
+	{ "Right Input Mixer", NULL, "ALC Clock" },
+
 	{ "Digital Clock 0", NULL, "SYSCLK" },
 	{ "Digital Clock 1", NULL, "SYSCLK" },
 };


