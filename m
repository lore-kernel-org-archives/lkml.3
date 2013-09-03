Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3ICQ3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:29:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3ICQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:29:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 22/58] ASoC: tegra: fix Tegra30 I2S capture parameter setup
Date: Tue,  3 Sep 2013 09:23:26 -0700
Message-Id: <1378225442-20654-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit c90c0d7a96e634a73ef1580f1d20993606545647 upstream.

The Tegra30 I2S driver was writing the AHUB interface parameters to the
playback path register rather than the capture path register. This
caused the capture parameters not to be configured at all, so if
capturing using non-HW-default parameters (e.g. 16-bit stereo rather
than 8-bit mono) the audio would be corrupted.

With this fixed, audio capture from an analog microphone works correctly
on the Cardhu board.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/tegra/tegra30_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 27e91dd..6b64f5b 100644
--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -227,7 +227,7 @@ static int tegra30_i2s_hw_params(struct snd_pcm_substream *substream,
 		reg = TEGRA30_I2S_CIF_RX_CTRL;
 	} else {
 		val |= TEGRA30_AUDIOCIF_CTRL_DIRECTION_TX;
-		reg = TEGRA30_I2S_CIF_RX_CTRL;
+		reg = TEGRA30_I2S_CIF_TX_CTRL;
 	}
 
 	regmap_write(i2s->regmap, reg, val);
-- 
1.8.1.2

