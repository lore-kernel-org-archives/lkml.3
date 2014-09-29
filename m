Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaI2Pcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:32:52 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59667 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2Pcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:32:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: broonie@kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com
Subject: [PATCH] ASoC: davinci: vcif must be a module if SND_DAVINCI_SOC is
Date: Mon, 29 Sep 2014 17:32:17 +0200
Message-ID: <2771900.ce8bYznKIN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5Hpj/4Re0OPAH28TCGrYxUh0q3dg3qax8Zw+y4S6xw0
 C4P4gbw11QT2JiZ4dXDW4K+DOT30zn3LZKy4BVrfYddKWNitRI
 Tb+OwC5xoPiDTm4PWsh6n+uX71XmtuCO69vLUAPi+0duH8LRZG
 ha25A+yqg+FpvKtITA3oYtgCUCzKfEvdn8hzwyyINtbS2NH7Sb
 YSQsK4HATB/7MjomflYGTyhUyNppuL+PPtN6aChP7mRR2j4XYY
 +/y8jcvymYhI9nRPwSb3b1b/faLcywtwFWS88AMrQJ5iq5dy4R
 OIO9DDuq1gjmbVSdTUpNoC1bkQPlPVGvGPOY1NulyB1+YF79f0
 PFmbX4//z2jwtcWKJs7o=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to configure a kernel with SND_DAVINCI_SOC=m and
SND_DM365_VOICE_CODEC=y, which results in a link error:

sound/built-in.o: In function `davinci_vcif_probe':
sound/soc/davinci/davinci-vcif.c:223: undefined reference to `davinci_soc_platform_register'

The best way to avoid this is to make SND_DM365_VOICE_CODEC
a tristate option that depends on SND_DAVINCI_SOC, so it
can only be a module or disabled when the base driver is
a loadable module

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/sound/soc/davinci/Kconfig b/sound/soc/davinci/Kconfig
index d69510c53239..8e948c63f3d9 100644
--- a/sound/soc/davinci/Kconfig
+++ b/sound/soc/davinci/Kconfig
@@ -63,7 +63,8 @@ config SND_DM365_AIC3X_CODEC
 	  Say Y if you want to add support for AIC3101 audio codec
 
 config SND_DM365_VOICE_CODEC
-	bool "Voice Codec - CQ93VC"
+	tristate "Voice Codec - CQ93VC"
+	depends on SND_DAVINCI_SOC
 	select MFD_DAVINCI_VOICECODEC
 	select SND_DAVINCI_SOC_VCIF
 	select SND_SOC_CQ0093VC

