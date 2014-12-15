Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaLORAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:00:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:40649 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaLORAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:00:17 -0500
Message-ID: <548F139D.4090901@infradead.org>
Date: Mon, 15 Dec 2014 09:00:13 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Platform Driver <platform-driver-x86@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Feuerer <peter@piie.net>
Subject: [PATCH -next] platform/x86/acerhdf: still depends on THERMAL
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

acerhdf uses thermal interfaces so it should depend on THERMAL.
It also should not select a thermal driver without checking that
THERMAL is enabled.

This fixes the following build errors when THERMAL=m and
ACERHDF=y.

drivers/built-in.o: In function `acerhdf_set_mode':
acerhdf.c:(.text+0x3e02e1): undefined reference to `thermal_zone_device_update'
drivers/built-in.o: In function `acerhdf_unbind':
acerhdf.c:(.text+0x3e052d): undefined reference to `thermal_zone_unbind_cooling_device'
drivers/built-in.o: In function `acerhdf_bind':
acerhdf.c:(.text+0x3e0593): undefined reference to `thermal_zone_bind_cooling_device'
drivers/built-in.o: In function `acerhdf_init':
acerhdf.c:(.init.text+0x1c2f5): undefined reference to `thermal_cooling_device_register'
acerhdf.c:(.init.text+0x1c360): undefined reference to `thermal_zone_device_register'
drivers/built-in.o: In function `acerhdf_unregister_thermal':
acerhdf.c:(.text.unlikely+0x3c67): undefined reference to `thermal_cooling_device_unregister'
acerhdf.c:(.text.unlikely+0x3c91): undefined reference to `thermal_zone_device_unregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Feuerer <peter@piie.net>
Cc: Darren Hart <dvhart@infradead.org>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20141215.orig/drivers/platform/x86/Kconfig
+++ linux-next-20141215/drivers/platform/x86/Kconfig
@@ -38,8 +38,8 @@ config ACER_WMI
 
 config ACERHDF
 	tristate "Acer Aspire One temperature and fan driver"
+	depends on ACPI && THERMAL
 	select THERMAL_GOV_BANG_BANG
-	depends on ACPI
 	---help---
 	  This is a driver for Acer Aspire One netbooks. It allows to access
 	  the temperature sensor and to control the fan.
