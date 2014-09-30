Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaI3MKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 08:10:22 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:50197 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaI3MKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 08:10:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [PATCH] spi: bcm53xx: add BCMA dependency
Date: Tue, 30 Sep 2014 14:09:46 +0200
Message-ID: <3256402.M8e92DFkbg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3Curb5Ch3rIO6c947zUQ0lL7Dze7yEh7iV9Z7ondbjC
 VSydgvuBY5kUn5XVUk7RAjvu9+ZYjkSU6oXA5gFbB9ks41BDBC
 BEqE+XF1pa5viINQL1Rvt6jWTrawKLOjMOvr3AkUxV0Au/9msx
 hDNBpTcJuEp0lKl2+oxKtECHF8cgnEdBwb0y/HHDXAeAsxySD0
 c1wy7znUUyM7JCOn3RRIE0KQT2V4MtIMaY+MVF0nFB0Sw7OlrS
 An7r/dQXVFWQiMx3rxzbk29Cqy7ziGcJa+WUuhZ2bRywxWemxG
 RTpLSBksWSN4rCgCuiCr7INumEncovptq5NAwX+cH4yVcngVeb
 ReVX5WZIsKCQYNl6Ayxw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCMA bus framework can be disabled on bcm53xx, which leads to a link
error when building the SPI driver:

drivers/built-in.o: In function `bcm53xxspi_module_init':
:(.init.text+0x76d4): undefined reference to `__bcma_driver_register'
drivers/built-in.o: In function `bcm53xxspi_module_exit':
:(.exit.text+0x10fe): undefined reference to `bcma_driver_unregister'

To avoid that, this adds an explicit dependency on BCMA. While we're
changing the dependencies, let's also add a COMPILE_TEST option, which
will of course not have any effect unless building on another machine
that has BCMA enabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 0fc6a323e19 ("spi: bcm53xx: driver for SPI controller on Broadcom bcma SoC")

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index bb7b5ec000d9..ababd27a4211 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -115,7 +115,8 @@ config SPI_AU1550
 
 config SPI_BCM53XX
 	tristate "Broadcom BCM53xx SPI controller"
-	depends on ARCH_BCM_5301X
+	depends on ARCH_BCM_5301X || COMPILE_TEST
+	depends on BCMA
 	help
           Enable support for the SPI controller on Broadcom BCM53xx ARM SoCs.
 

