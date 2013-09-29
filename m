Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3I2Iun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:50:43 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1193 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab3I2Its (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:48 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1782
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 7/8] ASoC: imx-wm8962: Don't use i2c_client->driver
Date: Sun, 29 Sep 2013 10:51:05 +0200
Message-Id: <1380444666-12019-8-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1380444666-12019-1-git-send-email-lars@metafoo.de>
References: <1380444666-12019-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'driver' field of the i2c_client struct is redundant and is going to be
removed. Check i2c_client->dev.driver instead to see if a driver is bound to the
device.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/fsl/imx-wm8962.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-wm8962.c b/sound/soc/fsl/imx-wm8962.c
index 6c60666..f84ecbf 100644
--- a/sound/soc/fsl/imx-wm8962.c
+++ b/sound/soc/fsl/imx-wm8962.c
@@ -215,7 +215,7 @@ static int imx_wm8962_probe(struct platform_device *pdev)
 		goto fail;
 	}
 	codec_dev = of_find_i2c_device_by_node(codec_np);
-	if (!codec_dev || !codec_dev->driver) {
+	if (!codec_dev || !codec_dev->dev.driver) {
 		dev_err(&pdev->dev, "failed to find codec platform device\n");
 		ret = -EINVAL;
 		goto fail;
-- 
1.8.0

