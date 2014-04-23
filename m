Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbaDWNSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:18:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbaDWNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:18:09 -0400
Date: Wed, 23 Apr 2014 15:18:06 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] misc: Add hardware dependencies to Atmel drivers
Message-ID: <20140423151806.67836ea9@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the driver descriptions, the atmel_pwm and atmel-ssc
drivers are only useful on Atmel AT32 and AT91 systems. So add
hardware dependencies to these drivers to hide them on other systems.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-3.15-rc2.orig/drivers/misc/Kconfig	2014-04-22 14:20:30.706102072 +0200
+++ linux-3.15-rc2/drivers/misc/Kconfig	2014-04-23 15:09:52.608321256 +0200
@@ -53,7 +53,7 @@ config AD525X_DPOT_SPI
 
 config ATMEL_PWM
 	tristate "Atmel AT32/AT91 PWM support"
-	depends on HAVE_CLK
+	depends on HAVE_CLK && (AVR32 || ARCH_AT91 || COMPILE_TEST)
 	help
 	  This option enables device driver support for the PWM channels
 	  on certain Atmel processors.  Pulse Width Modulation is used for
@@ -200,7 +200,7 @@ config ICS932S401
 
 config ATMEL_SSC
 	tristate "Device driver for Atmel SSC peripheral"
-	depends on HAS_IOMEM
+	depends on HAS_IOMEM && (AVR32 || ARCH_AT91 || COMPILE_TEST)
 	---help---
 	  This option enables device driver support for Atmel Synchronized
 	  Serial Communication peripheral (SSC).


-- 
Jean Delvare
SUSE L3 Support
