Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3IKE6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3IKE5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:00 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ouHq7Rf_Cp4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=8L6VfvvzdzwA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=s1kcb3gBdgdgGEtdbUwA:9 a=B7-YBXcGuVcA:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042925.759498780@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephen Warren <swarren@nvidia.com>, Mark Brown <broonie@linaro.org>
Subject: [202/251] ASoC: tegra: fix Tegra30 I2S capture parameter setup
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0202-ASoC-tegra-fix-Tegra30-I2S-capture-parameter-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

[ Upstream commit c90c0d7a96e634a73ef1580f1d20993606545647 ]

The Tegra30 I2S driver was writing the AHUB interface parameters to the
playback path register rather than the capture path register. This
caused the capture parameters not to be configured at all, so if
capturing using non-HW-default parameters (e.g. 16-bit stereo rather
than 8-bit mono) the audio would be corrupted.

With this fixed, audio capture from an analog microphone works correctly
on the Cardhu board.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/soc/tegra/tegra30_i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/tegra/tegra30_i2s.c b/sound/soc/tegra/tegra30_i2s.c
index 4418422..b56721a8 100644
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
1.7.10.4


