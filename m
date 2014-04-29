Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbaD2LUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:20:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64902 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757585AbaD2LUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:20:15 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 12/15] ASoC: Atmel WM8904 codec support needs I2C
Date: Tue, 29 Apr 2014 19:18:33 +0800
Message-Id: <1398770316-19715-13-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The WM8904 codec driver needs I2C to be enabled, so the
SND_ATMEL_SOC_WM8904 option also requires this.

Found using randconfig build testing.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/atmel/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/atmel/Kconfig b/sound/soc/atmel/Kconfig
index 4789619..27e3fc4 100644
--- a/sound/soc/atmel/Kconfig
+++ b/sound/soc/atmel/Kconfig
@@ -35,7 +35,7 @@ config SND_AT91_SOC_SAM9G20_WM8731
 
 config SND_ATMEL_SOC_WM8904
 	tristate "Atmel ASoC driver for boards using WM8904 codec"
-	depends on ARCH_AT91 && ATMEL_SSC && SND_ATMEL_SOC
+	depends on ARCH_AT91 && ATMEL_SSC && SND_ATMEL_SOC && I2C
 	select SND_ATMEL_SOC_SSC
 	select SND_ATMEL_SOC_DMA
 	select SND_SOC_WM8904
-- 
1.7.9.5

