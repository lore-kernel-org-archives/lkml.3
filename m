Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3GPMFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:05:12 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53134 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3GPMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:05:08 -0400
MIME-Version: 1.0
Date: Tue, 16 Jul 2013 20:05:07 +0800
Message-ID: <CAPgLHd-cXmWwMq8DMhXbOhykZvnMzxb4HHZ-5ayNnkPU1fqfQQ@mail.gmail.com>
Subject: [PATCH] ASoC: imx-sgtl5000: fix error return code in imx_sgtl5000_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, shawn.guo@linaro.org,
        fabio.estevam@freescale.com, wfp5p@virginia.edu,
        LW@KARO-electronics.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/fsl/imx-sgtl5000.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-sgtl5000.c b/sound/soc/fsl/imx-sgtl5000.c
index 7a8bc12..25f310d 100644
--- a/sound/soc/fsl/imx-sgtl5000.c
+++ b/sound/soc/fsl/imx-sgtl5000.c
@@ -129,8 +129,10 @@ static int imx_sgtl5000_probe(struct platform_device *pdev)
 	}
 
 	data->codec_clk = devm_clk_get(&codec_dev->dev, NULL);
-	if (IS_ERR(data->codec_clk))
+	if (IS_ERR(data->codec_clk)) {
+		ret = PTR_ERR(data->codec_clk);
 		goto fail;
+	}
 
 	data->clk_frequency = clk_get_rate(data->codec_clk);
 

