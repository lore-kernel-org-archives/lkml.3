Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab3JHKok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:44:40 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39309 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3JHKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:40:47 -0400
From: Majunath Goudar <csmanjuvijay@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nataraja.km@lge.com, Majunath Goudar <csmanjuvijay@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] SOUND/SPI: Fix "clk_round_rate" undefined reference error.
Date: Tue,  8 Oct 2013 16:10:33 +0530
Message-Id: <1381228833-24082-1-git-send-email-csmanjuvijay@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a COMMON_CLK dependency to configure the
SND_AT73C213 for Atmel AT73C213 DAC driver. Without this patch,
build system can lead to build failure. This was observed during
randconfig testing, in which SND_AT73C213 was enabled w/o COMMON_CLK
being enabled. leading to the following error:

sound/built-in.o: In function `snd_at73c213_probe':
:(.text+0x328c4): undefined reference to `clk_round_rate'
make: *** [vmlinux] Error 1

Signed-off-by: Manjunath Goudar <csmanjuvijay@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 sound/spi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/spi/Kconfig b/sound/spi/Kconfig
index e6485be..798d1ee 100644
--- a/sound/spi/Kconfig
+++ b/sound/spi/Kconfig
@@ -11,7 +11,7 @@ if SND_SPI
 
 config SND_AT73C213
 	tristate "Atmel AT73C213 DAC driver"
-	depends on ATMEL_SSC
+	depends on ATMEL_SSC && COMMON_CLK
 	select SND_PCM
 	help
 	  Say Y here if you want to use the Atmel AT73C213 external DAC. This
-- 
1.7.9.5

