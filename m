Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3CLNg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:36:27 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:64422 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab3CLNg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:36:26 -0400
MIME-Version: 1.0
Date: Tue, 12 Mar 2013 21:36:24 +0800
Message-ID: <CAPgLHd_J+xdx6UdSFahEGmPJX-SXEkQBL7xHA7MEGKf21=32Uw@mail.gmail.com>
Subject: [PATCH -next] ASoC: tas5086: use module_i2c_driver to simplify the code
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lgirdwood@gmail.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        zonque@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Use the module_i2c_driver() macro to make the code smaller
and a bit simpler.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/tas5086.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/sound/soc/codecs/tas5086.c b/sound/soc/codecs/tas5086.c
index 008bea4..40cee84 100644
--- a/sound/soc/codecs/tas5086.c
+++ b/sound/soc/codecs/tas5086.c
@@ -584,17 +584,7 @@ static struct i2c_driver tas5086_i2c_driver = {
 	.remove		= tas5086_i2c_remove,
 };
 
-static int __init tas5086_modinit(void)
-{
-	return i2c_add_driver(&tas5086_i2c_driver);
-}
-module_init(tas5086_modinit);
-
-static void __exit tas5086_modexit(void)
-{
-	i2c_del_driver(&tas5086_i2c_driver);
-}
-module_exit(tas5086_modexit);
+module_i2c_driver(tas5086_i2c_driver);
 
 MODULE_AUTHOR("Daniel Mack <zonque@gmail.com>");
 MODULE_DESCRIPTION("Texas Instruments TAS5086 ALSA SoC Codec Driver");


