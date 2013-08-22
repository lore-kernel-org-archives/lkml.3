Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3HVQGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:06:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3HVQGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:06:38 -0400
Message-ID: <521636FF.7090008@infradead.org>
Date: Thu, 22 Aug 2013 09:06:23 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>
CC: Corentin Chary <corentin.chary@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] samsung-laptop: fix config build error
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build failure when ACPI_VIDEO=m and SAMSUNG_LAPTOP=y.
The patch prevents that specific config combination.

drivers/built-in.o: In function `samsung_init':
samsung-laptop.c:(.init.text+0x128ff): undefined reference to `acpi_video_unregister'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Corentin Chary <corentin.chary@gmail.com>

build testing:
ACPI_VIDEO=m, SAMSUNG_LAPTOP=m: OK
ACPI_VIDEO=y, SAMSUNG_LAPTOP=m: OK
ACPI_VIDEO=y, SAMSUNG_LAPTOP=y: OK
ACPI=n, SAMSUNG_LAPTOP=y: OK
ACPI=n, SAMSUNG_LAPTOP=m: OK
---
 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20130820.orig/drivers/platform/x86/Kconfig
+++ linux-next-20130820/drivers/platform/x86/Kconfig
@@ -732,6 +732,7 @@ config SAMSUNG_LAPTOP
 	tristate "Samsung Laptop driver"
 	depends on X86
 	depends on RFKILL || RFKILL = n
+	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	depends on BACKLIGHT_CLASS_DEVICE
 	select LEDS_CLASS
 	select NEW_LEDS
