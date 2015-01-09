Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbbAIPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24512 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902AbbAIPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:35 -0500
X-AuditID: cbfee61a-f79c06d000004e71-86-54aff274a236
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v10 02/19] Documentation: leds: Add description of LED
 Flash class extension
Date: Fri, 09 Jan 2015 16:22:52 +0100
Message-id: <1420816989-1808-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd2ST+tDDBpumFhsnLGe1eLozolM
	FvOPnGO16L36nNHibNMbdovLu+awWWx9s47RomfDVlaLu6eOslns3vWU1eLwm3ZWizP7V7I5
	8HjsnHWX3ePw14UsHnvm/2D16NuyitFjxerv7B6fN8kFsEVx2aSk5mSWpRbp2yVwZbS3fGUp
	eCBTMe1MH3MD4zrxLkZODgkBE4kbaxrZIWwxiQv31rN1MXJxCAlMZ5Q41nmUGcJpZ5LYcX8z
	E0gVm4ChxM8Xr4FsDg4RgWiJS8fqQWqYBV4wStyb/IANpEZYIEni48ujrCA2i4CqRPOFu2A2
	r4C7xP0LR5hBeiUEFCTmTLIBMTkFPCRafjuBmEJAFW+uGk5g5F3AyLCKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIzgYn0ntYFzZYHGIUYCDUYmHd4Pc+hAh1sSy4srcQ4wSHMxKIrwNm4FC
	vCmJlVWpRfnxRaU5qcWHGKU5WJTEeZXs20KEBNITS1KzU1MLUotgskwcnFINjLsObV2j+vnn
	QQWPvR0745PMmQ9vuPGw8ZG53ba8wmUr084c4f6QHxuv5rk5KX5upsybW4yiF/6seK1w3Ln9
	1se0KTfs3mlxS7wWZdn35MPKHXO49Vo7X157LVfpse37/Bfm7wpri4pYD9eujXFQ6tL++mJz
	zJq93AZqC6N9ZrEfXPLW996cKUFKLMUZiYZazEXFiQC9xwrIQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation being added contains overall description of the
LED Flash Class and the related sysfs attributes.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   57 +++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..d80096b
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,57 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. In the LED subsystem
+those modes are supported by LED class (see Documentation/leds/leds-class.txt)
+and LED Flash class respectively. The torch mode related features are enabled
+by default and the flash ones only if a driver declares it by setting
+LED_DEV_CAP_FLASH flag.
+
+In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
+must be defined in the kernel config. A flash LED driver must register
+in the LED subsystem with led_classdev_flash_register function to gain flash
+related capabilities.
+
+There are flash LED devices which can control more than one LED and allow for
+strobing the sub-leds synchronously. A LED will be strobed synchronously with
+the one whose identifier is written to the flash_sync_strobe sysfs attribute.
+The list of available sub-led identifiers can be read from the available_sync_leds
+sysfs attribute. In order to enable the related settings the driver must set
+LED_DEV_CAP_SYNC_STROBE flag.
+
+Following sysfs attributes are exposed for controlling flash led devices:
+
+	- flash_brightness - flash LED brightness in microamperes (RW)
+	- max_flash_brightness - maximum available flash LED brightness (RO)
+	- flash_timeout - flash strobe duration in microseconds (RW)
+	- max_flash_timeout - maximum available flash strobe duration (RO)
+	- flash_strobe - flash strobe state (RW)
+	- available_sync_leds - list of sub-leds available for flash strobe
+				synchronization (RO)
+	- flash_sync_strobe - identifier of the sub-led to synchronize the flash
+			      strobe with; 0 stands for no synchronization (RW)
+	- flash_fault - bitmask of flash faults that may have occurred
+			possible flags are:
+		* 0x01 - flash controller voltage to the flash LED has exceeded
+			 the limit specific to the flash controller
+		* 0x02 - the flash strobe was still on when the timeout set by
+			 the user has expired; not all flash controllers may
+			 set this in all such conditions
+		* 0x04 - the flash controller has overheated
+		* 0x08 - the short circuit protection of the flash controller
+			 has been triggered
+		* 0x10 - current in the LED power supply has exceeded the limit
+			 specific to the flash controller
+		* 0x20 - the flash controller has detected a short or open
+			 circuit condition on the indicator LED
+		* 0x40 - flash controller voltage to the flash LED has been
+			 below the minimum limit specific to the flash
+		* 0x80 - the input voltage of the flash controller is below
+			 the limit under which strobing the flash at full
+			 current will not be possible. The condition persists
+			 until this flag is no longer set
+		* 0x100 - the temperature of the LED has exceeded its allowed
+			  upper limit
+
+		Flash faults are cleared, if possible, by reading the attribute.
-- 
1.7.9.5

