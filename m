Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132Ab3HBKIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:08:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759003Ab3HBKIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:08:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Zhao <rizhao@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Lucas Stach <dev@lynxeye.de>, Mark Brown <broonie@linaro.org>
Subject: [ 12/99] ASoC: tegra: correct playback_dma_data setup
Date: Fri,  2 Aug 2013 18:07:25 +0800
Message-Id: <20130802100227.307930136@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhao <rizhao@nvidia.com>

commit 647ab784c507763bfda79155f125b6edd1244806 upstream.

The errors were caused by copy/paste mistake in below commit
since v3.10:
3489d50 ASoC: tegra: Use common DAI DMA data struct

It also corrects slave_id initialization in tegra20_ac97 driver.

Signed-off-by: Richard Zhao <rizhao@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Lucas Stach <dev@lynxeye.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra20_ac97.c  |    6 +++---
 sound/soc/tegra/tegra20_spdif.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/sound/soc/tegra/tegra20_ac97.c
+++ b/sound/soc/tegra/tegra20_ac97.c
@@ -399,9 +399,9 @@ static int tegra20_ac97_platform_probe(s
 	ac97->capture_dma_data.slave_id = of_dma[1];
 
 	ac97->playback_dma_data.addr = mem->start + TEGRA20_AC97_FIFO_TX1;
-	ac97->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	ac97->capture_dma_data.maxburst = 4;
-	ac97->capture_dma_data.slave_id = of_dma[0];
+	ac97->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	ac97->playback_dma_data.maxburst = 4;
+	ac97->playback_dma_data.slave_id = of_dma[1];
 
 	ret = snd_soc_register_component(&pdev->dev, &tegra20_ac97_component,
 					 &tegra20_ac97_dai, 1);
--- a/sound/soc/tegra/tegra20_spdif.c
+++ b/sound/soc/tegra/tegra20_spdif.c
@@ -323,8 +323,8 @@ static int tegra20_spdif_platform_probe(
 	}
 
 	spdif->playback_dma_data.addr = mem->start + TEGRA20_SPDIF_DATA_OUT;
-	spdif->capture_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
-	spdif->capture_dma_data.maxburst = 4;
+	spdif->playback_dma_data.addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+	spdif->playback_dma_data.maxburst = 4;
 	spdif->playback_dma_data.slave_id = dmareq->start;
 
 	pm_runtime_enable(&pdev->dev);


