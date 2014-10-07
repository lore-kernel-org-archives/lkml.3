Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484AbaJGXoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:44:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbaJGXTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3.16 02/26] ASoC: ssm2602: do not hardcode type to SSM2602
Date: Tue,  7 Oct 2014 16:19:18 -0700
Message-Id: <20141007231848.567232739@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>

commit fe2a08b3bf1a6e35c00e18843bc19aa1778432c3 upstream.

The correct type (SSM2602/SSM2603/SSM2604) is passed down
from the ssm2602_spi_probe()/ssm2602_spi_probe() functions,
so use that instead of hardcoding it to SSM2602 in
ssm2602_probe().

Fixes: c924dc68f737 ("ASoC: ssm2602: Split SPI and I2C code into different modules")
Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/ssm2602.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/ssm2602.c
+++ b/sound/soc/codecs/ssm2602.c
@@ -647,7 +647,7 @@ int ssm2602_probe(struct device *dev, en
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, ssm2602);
-	ssm2602->type = SSM2602;
+	ssm2602->type = type;
 	ssm2602->regmap = regmap;
 
 	return snd_soc_register_codec(dev, &soc_codec_dev_ssm2602,


