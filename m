Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbbAMS2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:28:10 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36796 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751190AbbAMS2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:28:08 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: linux-pcmcia@lists.infradead.org
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] pcmcia: at91_cf: depend on !ARCH_MULTIPLATFORM
Date: Tue, 13 Jan 2015 19:28:05 +0100
Message-Id: <1421173685-21559-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Until the driver is corrected to stop including mach/at91_ramc.h and using
mach/io.h, it won't compile in a ARCH_MULTIPLATFORM configuration.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/pcmcia/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 910e90bf16c6..45f67c63d385 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -276,6 +276,7 @@ config BFIN_CFPCMCIA
 config AT91_CF
 	tristate "AT91 CompactFlash Controller"
 	depends on PCMCIA && ARCH_AT91
+	depends on !ARCH_MULTIPLATFORM
 	help
 	  Say Y here to support the CompactFlash controller on AT91 chips.
 	  Or choose M to compile the driver as a module named "at91_cf".
-- 
2.1.0

