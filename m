Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3KIAlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 19:41:17 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62822 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3KIAlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 19:41:16 -0500
MIME-Version: 1.0
Date: Sat, 9 Nov 2013 08:41:14 +0800
Message-ID: <CAPgLHd8kfDJJg045WbRrrd06rKSsUZkYha2nFPuXkbkAKRvpTw@mail.gmail.com>
Subject: [PATCH] ASoC: fsl: set correct platform drvdata in pcm030_fabric_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, rob.herring@calxeda.com, wfp5p@virginia.edu,
        mpa@pengutronix.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

platform_set_drvdata(op, pdata) in pcm030_fabric_probe()
will be overwrited when calling snd_soc_register_card(card),
but cm030_fabric_remove() use drvdata as a type of struct
pcm030_audio_data, so we should move platform_set_drvdata()
below snd_soc_register_card() call.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/fsl/pcm030-audio-fabric.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/pcm030-audio-fabric.c b/sound/soc/fsl/pcm030-audio-fabric.c
index eb43738..3665f61 100644
--- a/sound/soc/fsl/pcm030-audio-fabric.c
+++ b/sound/soc/fsl/pcm030-audio-fabric.c
@@ -69,7 +69,6 @@ static int pcm030_fabric_probe(struct platform_device *op)
 		return -ENOMEM;
 
 	card->dev = &op->dev;
-	platform_set_drvdata(op, pdata);
 
 	pdata->card = card;
 
@@ -98,6 +97,8 @@ static int pcm030_fabric_probe(struct platform_device *op)
 	if (ret)
 		dev_err(&op->dev, "snd_soc_register_card() failed: %d\n", ret);
 
+	platform_set_drvdata(op, pdata);
+
 	return ret;
 }
 

