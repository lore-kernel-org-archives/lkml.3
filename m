Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3BVIst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:48:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40416 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab3BVIsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:48:47 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH] ideapad: depends on backlight subsystem and update comment
Date: Fri, 22 Feb 2013 16:48:40 +0800
Message-Id: <1361522920-10738-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a report of build failure on ideapad-laptop, which shows

drivers/built-in.o: In function `ideapad_acpi_notify':
ideapad-laptop.c:(.text+0x63876a): undefined reference to `backlight_force_update'
drivers/built-in.o: In function `ideapad_acpi_remove':
ideapad-laptop.c:(.devexit.text+0x64a7): undefined reference to `backlight_device_unregister'
drivers/built-in.o: In function `ideapad_acpi_add':
ideapad-laptop.c:(.devinit.text+0x45e28): undefined reference to `backlight_device_register'

To select backlight subsystem can prevent this error from happening.

Also update comment for this driver.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index c86bae8..c5bc068 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -291,8 +291,10 @@ config IDEAPAD_LAPTOP
 	depends on RFKILL && INPUT
 	depends on SERIO_I8042
 	select INPUT_SPARSEKMAP
+	select BACKLIGHT_CLASS_DEVICE
 	help
-	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
+	  This is a driver for Lenovo IdeaPad netbooks contains drivers for
+	  rfkill switch, hotkey, fan control and backlight control.
 
 config THINKPAD_ACPI
 	tristate "ThinkPad ACPI Laptop Extras"
-- 
1.7.9.5

