Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3J2NhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:37:23 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36997 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3J2NhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:37:21 -0400
Date: Tue, 29 Oct 2013 16:35:20 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] mmc: MMC requires GPIOLIB to build
Message-ID: <20131029133520.GB2180@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC should select GPIOLIB to build:

ERROR: "devm_gpio_request_one" [drivers/mmc/core/mmc_core.ko] undefined!
linux-next/scripts/Makefile.modpost:90: recipe for target '__modpost' failed
make[1]: *** [__modpost] Error 1
Makefile:955: recipe for target 'modules' failed

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/mmc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
index f2eeb38..bf44002 100644
--- a/drivers/mmc/Kconfig
+++ b/drivers/mmc/Kconfig
@@ -5,6 +5,7 @@
 menuconfig MMC
 	tristate "MMC/SD/SDIO card support"
 	depends on HAS_IOMEM
+	select GPIOLIB
 	help
 	  This selects MultiMediaCard, Secure Digital and Secure
 	  Digital I/O support.

