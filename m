Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3HRUoh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:44:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab3HRUe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [ 22/45] ASoC: tegra: fix Tegra30 I2S capture parameter setup
Date: Sun, 18 Aug 2013 13:36:11 -0700
Message-Id: <20130818203622.549250218@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra30_i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/tegra/tegra30_i2s.c
+++ b/sound/soc/tegra/tegra30_i2s.c
@@ -228,7 +228,7 @@ static int tegra30_i2s_hw_params(struct
 		reg = TEGRA30_I2S_CIF_RX_CTRL;
 	} else {
 		val |= TEGRA30_AUDIOCIF_CTRL_DIRECTION_TX;
-		reg = TEGRA30_I2S_CIF_RX_CTRL;
+		reg = TEGRA30_I2S_CIF_TX_CTRL;
 	}
 
 	regmap_write(i2s->regmap, reg, val);


