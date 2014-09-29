Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaI2Tl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:41:57 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:55908 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbaI2Tlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:41:55 -0400
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, lgirdwood@gmail.com, broonie@kernel.org,
        lars@metafoo.de,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH v2 1/3] ASoC: ssm2602: do not hardcode type to SSM2602
Date: Mon, 29 Sep 2014 22:39:13 +0300
Message-Id: <1412019553-19342-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct type (SSM2602/SSM2603/SSM2604) is passed down
from the ssm2602_spi_probe()/ssm2602_spi_probe() functions,
so use that instead of hardcoding it to SSM2602 in
ssm2602_probe().

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
Changes in v2:
 - None, new in series.
---
 sound/soc/codecs/ssm2602.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/ssm2602.c b/sound/soc/codecs/ssm2602.c
index 484b3bb..4021cd4 100644
--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -647,7 +647,7 @@ int ssm2602_probe(struct device *dev, enum ssm2602_type type,
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, ssm2602);
-	ssm2602->type = SSM2602;
+	ssm2602->type = type;
 	ssm2602->regmap = regmap;
 
 	return snd_soc_register_codec(dev, &soc_codec_dev_ssm2602,
-- 
1.9.1

