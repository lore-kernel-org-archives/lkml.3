Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3ETUQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:16:59 -0400
Received: from mout.gmx.net ([212.227.15.19]:63807 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756771Ab3ETUQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:16:58 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+TDKIY9x2ToPYPoYKruFGqormImdU8SgOZP+VsGA
	BWP3CSQgyK1bNc
From: Peter Huewe <peterhuewe@gmx.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] arm/mach-u300/dummyspichip: Use module_spi_driver to register driver
Date: Mon, 20 May 2013 22:22:04 +0200
Message-Id: <1369081324-8062-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_spi_driver instead of calling
register and unregister in the otherwise empty init/exit functions.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/arm/mach-u300/dummyspichip.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm/mach-u300/dummyspichip.c b/arch/arm/mach-u300/dummyspichip.c
index 2785cb6..aee609d 100644
--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -272,19 +272,7 @@ static struct spi_driver pl022_dummy_driver = {
 	.remove	= pl022_dummy_remove,
 };
 
-static int __init pl022_init_dummy(void)
-{
-	return spi_register_driver(&pl022_dummy_driver);
-}
-
-static void __exit pl022_exit_dummy(void)
-{
-	spi_unregister_driver(&pl022_dummy_driver);
-}
-
-module_init(pl022_init_dummy);
-module_exit(pl022_exit_dummy);
-
+module_spi_driver(pl022_dummy_driver);
 MODULE_AUTHOR("Linus Walleij <linus.walleij@stericsson.com>");
 MODULE_DESCRIPTION("PL022 SSP/SPI DUMMY Linux driver");
 MODULE_LICENSE("GPL");
-- 
1.8.1.5

