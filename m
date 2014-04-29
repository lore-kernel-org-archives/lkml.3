Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbaD2LVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:21:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60991 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933713AbaD2LU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:20:29 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 14/15] ASoC: Amstrad E3 needs TTY support for codec
Date: Tue, 29 Apr 2014 19:18:35 +0800
Message-Id: <1398770316-19715-15-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The cx20442 codec driver used here requires the TTY layer to
be enabled, or we get a link error:

sound/built-in.o: In function `cx20442_codec_remove':
cx20442.c:398: undefined reference to `tty_hangup'
sound/built-in.o: In function `ams_delta_remove':
ams-delta.c:613: undefined reference to `tty_unregister_ldisc'
sound/built-in.o: In function `ams_delta_cx20442_init':
ams-delta.c:559: undefined reference to `tty_register_ldisc'

This adds the missing dependency in the E3 configuration, there
was already one for the codec.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: linux-omap@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
 sound/soc/omap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/omap/Kconfig b/sound/soc/omap/Kconfig
index 2796af9..d44463a 100644
--- a/sound/soc/omap/Kconfig
+++ b/sound/soc/omap/Kconfig
@@ -37,7 +37,7 @@ config SND_OMAP_SOC_RX51
 
 config SND_OMAP_SOC_AMS_DELTA
 	tristate "SoC Audio support for Amstrad E3 (Delta) videophone"
-	depends on SND_OMAP_SOC && MACH_AMS_DELTA
+	depends on SND_OMAP_SOC && MACH_AMS_DELTA && TTY
 	select SND_OMAP_SOC_MCBSP
 	select SND_SOC_CX20442
 	help
-- 
1.7.9.5

