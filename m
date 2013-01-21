Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3AURRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:17:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53003 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3AURRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 09/15] media: coda: don't build on multiplatform
Date: Mon, 21 Jan 2013 17:16:02 +0000
Message-Id: <1358788568-11137-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:zLrMLcB+MABPwXABHc8g/zetLPaJ279DIkSOWwFOw8/
 7tPrV6wuFGKbt7TKbVYHycgrEH2HcQfVXIkafY7NIlULkM67Dz
 +AayaGeEB4IgQJuLlxQnnEvmIRJWZCIQV7lf7AiIz7ZPEHpzVC
 X9yTqwq7QZnBOKkq02lmT+/HzEVNbYfyC6Y6rRJs90DZRxH7n+
 Al9DM6c6pjSHzSdjPK9ow5cLqrgCUC7sC4d2gdcN3DH9zpw6A/
 NtksAa+ZMGVHiMUE2VTAl4p0Q46oiEHotpGykSd+tEIb32Sm+A
 1vnsd33vTiIpaIv8zS4iCC/FTSMOmVihIctrhpdYonOLq3EPQ1
 QMoFT1u+x42IRvS6oYEAVyPUUeql41FkfXmNCmFmw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The coda video codec driver depends on a mach-imx or mach-mxs specific
header file "mach/iram.h". This is not available when building for
multiplatform, so let us disable this driver for v3.8 when building
multiplatform, and hopefully find a proper fix for v3.9.

drivers/media/platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 3dcfea6..049d2b2 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -142,7 +142,7 @@ if V4L_MEM2MEM_DRIVERS
 
 config VIDEO_CODA
 	tristate "Chips&Media Coda multi-standard codec IP"
-	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
+	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC && !ARCH_MULTIPLATFORM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
 	select IRAM_ALLOC if SOC_IMX53
-- 
1.7.10.4

