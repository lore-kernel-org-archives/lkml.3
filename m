Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaKMJdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:33:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:46643 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbaKMJdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:33:11 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <pebolle@tiscali.nl>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: remove unused CONFIG_ARCH_AT91SAM9G45 option
Date: Thu, 13 Nov 2014 10:33:10 +0100
Message-ID: <1415871190-32244-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1415617517.4862.44.camel@x220>
References: <1415617517.4862.44.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_ARCH_AT91SAM9G45 config option was removed by ("ARM: at91: remove
at91sam9g45/9m10 legacy board support") so cleanup the use of it.

Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/Makefile.boot | 6 ------
 arch/arm/mach-at91/board.h       | 4 ----
 2 files changed, 10 deletions(-)

diff --git a/arch/arm/mach-at91/Makefile.boot b/arch/arm/mach-at91/Makefile.boot
index 5309f9b6aabc..29ed0fa374ca 100644
--- a/arch/arm/mach-at91/Makefile.boot
+++ b/arch/arm/mach-at91/Makefile.boot
@@ -3,12 +3,6 @@
 #   PARAMS_PHYS must be within 4MB of ZRELADDR
 #   INITRD_PHYS must be in RAM
 
-ifeq ($(CONFIG_ARCH_AT91SAM9G45),y)
-   zreladdr-y	+= 0x70008000
-params_phys-y	:= 0x70000100
-initrd_phys-y	:= 0x70410000
-else
    zreladdr-y	+= 0x20008000
 params_phys-y	:= 0x20000100
 initrd_phys-y	:= 0x20410000
-endif
diff --git a/arch/arm/mach-at91/board.h b/arch/arm/mach-at91/board.h
index 836e9a537e0c..d268ec3781dd 100644
--- a/arch/arm/mach-at91/board.h
+++ b/arch/arm/mach-at91/board.h
@@ -56,11 +56,7 @@ extern void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data);
 extern void __init at91_add_device_nand(struct atmel_nand_data *data);
 
  /* I2C*/
-#if defined(CONFIG_ARCH_AT91SAM9G45)
-extern void __init at91_add_device_i2c(short i2c_id, struct i2c_board_info *devices, int nr_devices);
-#else
 extern void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices);
-#endif
 
  /* SPI */
 extern void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices);
-- 
1.8.2.2

