Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaKKLfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:35:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaKKLKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 110/170] ASoC: adau1761: Fix input PGA volume
Date: Tue, 11 Nov 2014 11:07:49 +0000
Message-Id: <1415704129-12709-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 3b283f0893f55cb79e4507e5ec34e49c17d0a787 upstream.

For the input PGA to work correctly the ALC clock needs to be active.
Otherwise volume changes are not applied.

Fixes: dab464b60b2 ("ASoC: Add ADAU1361/ADAU1761 audio CODEC support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/adau1761.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/soc/codecs/adau1761.c b/sound/soc/codecs/adau1761.c
index 848cab839553..2e9e90dbeecf 100644
--- a/sound/soc/codecs/adau1761.c
+++ b/sound/soc/codecs/adau1761.c
@@ -405,6 +405,7 @@ static const struct snd_soc_dapm_widget adau1761_dapm_widgets[] = {
 		2, 0, NULL, 0),
 
 	SND_SOC_DAPM_SUPPLY("Slew Clock", ADAU1761_CLK_ENABLE0, 6, 0, NULL, 0),
+	SND_SOC_DAPM_SUPPLY("ALC Clock", ADAU1761_CLK_ENABLE0, 5, 0, NULL, 0),
 
 	SND_SOC_DAPM_SUPPLY_S("Digital Clock 0", 1, ADAU1761_CLK_ENABLE1,
 		0, 0, NULL, 0),
@@ -436,6 +437,9 @@ static const struct snd_soc_dapm_route adau1761_dapm_routes[] = {
 	{ "Right Playback Mixer", NULL, "Slew Clock" },
 	{ "Left Playback Mixer", NULL, "Slew Clock" },
 
+	{ "Left Input Mixer", NULL, "ALC Clock" },
+	{ "Right Input Mixer", NULL, "ALC Clock" },
+
 	{ "Digital Clock 0", NULL, "SYSCLK" },
 	{ "Digital Clock 1", NULL, "SYSCLK" },
 };
-- 
2.1.0

