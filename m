Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaBHVBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 16:01:50 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:54303 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbaBHVBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 16:01:24 -0500
Message-ID: <1391893281.19595.3.camel@x220>
Subject: [PATCH] spi: omap2: use SUPERH, not SH
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 08 Feb 2014 22:01:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2014 21:01:22.0211 (UTC) FILETIME=[EBC22F30:01CF2510]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0079aae0f1e6 ("spi: omap2: Add build dependencies for
writel_relaxed()") added an optional Kconfig dependency on SH. That
Kconfig symbol doesn't exist. Apparently SUPERH was intended. Use that.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Basically untested.

 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index ba9310b..205dbfe 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -307,7 +307,7 @@ config SPI_OMAP_UWIRE
 
 config SPI_OMAP24XX
 	tristate "McSPI driver for OMAP"
-	depends on ARM || ARM64 || AVR32 || HEXAGON || MIPS || SH
+	depends on ARM || ARM64 || AVR32 || HEXAGON || MIPS || SUPERH
 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
 	help
 	  SPI master controller for OMAP24XX and later Multichannel SPI
-- 
1.8.5.3

