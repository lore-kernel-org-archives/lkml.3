Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbaD2JqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:46:15 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:63650 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaD2JqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:46:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: micky_ching@realsil.com.cn
Cc: chris@printf.net, ulf.hansson@linaro.org, lee.jones@linaro.org,
        sameo@linux.intel.com, gregkh@linuxfoundation.org,
        dan.carpenter@oracle.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rogerable@realtek.com, wei_wang@realsil.com.cn
Subject: [PATCH] mmc: rtsx: usb backend needs LED support
Date: Tue, 29 Apr 2014 11:45:59 +0200
Message-ID: <7208467.nZIXMIfPji@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1398735435.git.micky_ching@realsil.com.cn>
References: <cover.1398735435.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aPgRi+NySk7AI7kRDLdfyVMWwvGIIu1pINuJOi7cUX0
 buEaIUd4NaADW6k04LWLYynHkfyablCA7iSfuATL48nI3ovY4T
 iBdU+0csRdx0JZBSWxwfRI1OVuCAzoZsVQ3kz/VHeTA8azJJu8
 P1C+NOTt4e5pBWAP/AUNezCtTauMS7GrlZ7nc3P/KVaX+kt18Q
 hsAVQcVzyl3Rr0xSUQ+35bA5vdakIfG4BrlwTjqOaJ/pf7JWQi
 khngJVR2IceC0KJS6JDf1e6Cvo0hs/L2zAMv5mbH2y3b5WiuvQ
 ty3S9PS0UQQwnM4IZiN9Wp2ka/1oMvAvNz+E6jz8AHQCW7lWrk
 ypzT92UPzDB8VUjQonkM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[hijacking the thread since it has the right Cc list already, sorry]

I stumbled over this doing randconfig builds on linux-next

8<----------

>From c11f54f1e5ea0557e076867ca31c90bcb20e3e0c Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 29 Apr 2014 11:41:40 +0200
Subject: [PATCH] mmc: rtsx: usb backend needs LED support

Building the rtsx USB driver requires the LED classdev base
support, otherwise we get this build error:

drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
:(.text+0x806480): undefined reference to `led_classdev_unregister'
drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
:(.text+0x806708): undefined reference to `led_classdev_register'

This adds an explicit dependency in Kconfig

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 92d91fe..66aedf3 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -696,6 +696,7 @@ config MMC_REALTEK_PCI
 config MMC_REALTEK_USB
 	tristate "Realtek USB SD/MMC Card Interface Driver"
 	depends on MFD_RTSX_USB
+	depends on LEDS_CLASS
 	help
 	  Say Y here to include driver code to support SD/MMC card interface
 	  of Realtek RTS5129/39 series card reader

