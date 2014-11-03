Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaKCSLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:11:50 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50097 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaKCSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:08:11 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Jim Davis <jim.epost@gmail.com>
Subject: [PATCH] ASoC: tlv320aic23: depends on SPI
Date: Mon,  3 Nov 2014 23:37:59 +0530
Message-Id: <1415038079-6490-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build errors when CONFIG_SPI is not enabled by making the
driver depend on SPI.

ERROR: "spi_setup" [sound/soc/codecs/snd-soc-tlv320aic23-spi.ko] undefined!
ERROR: "devm_regmap_init_spi" [sound/soc/codecs/snd-soc-tlv320aic23-spi.ko] undefined!
ERROR: "spi_register_driver" [sound/soc/codecs/snd-soc-tlv320aic23-spi.ko] undefined!

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

reference of mail by Jim Davis at https://lkml.org/lkml/2014/11/3/551

 sound/soc/codecs/Kconfig | 1 +

1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 6801b38..9a8ea56 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -603,6 +603,7 @@ config SND_SOC_TLV320AIC23_I2C
 
 config SND_SOC_TLV320AIC23_SPI
 	tristate "Texas Instruments TLV320AIC23 audio CODEC - SPI"
+	depends on SPI
 	select SND_SOC_TLV320AIC23
 
 config SND_SOC_TLV320AIC26
-- 
1.8.1.2

