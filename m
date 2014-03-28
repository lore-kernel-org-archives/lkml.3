Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaC1Pef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:34:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40159 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaC1P3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:33 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-da-5335955ce450
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v2 3/8] Documentation: leds: Add description of flash mode
Date: Fri, 28 Mar 2014 16:29:00 +0100
Message-id: <1396020545-15727-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
References: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd2YqabBBk9mCFvcWneO1eLozolM
	FvOPAFm9V58zWpxtesNucXnXHDaLrW/WMVr0bNjKarF711NWi8Nv2lkduDx2zrrL7rFn/g9W
	j74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4+WIlW8F9uYo5h5vYGhj7JbsYOTkkBEwkjk1Z
	ywhhi0lcuLeerYuRi0NIYDqjxNN3x5khnE4miRN7N7KBVLEJGEr8fPGaCcQWESiXmDb1ERNI
	EbPAPkaJTdNAOjg5hAX8JKYdW8fexcjBwSKgKvHulQxImFfAQ+LTmrXMIGEJAQWJOZNsQMKc
	Ap4St1+0gx0hBFTyZc5J9gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfaM6kd
	jCsbLA4xCnAwKvHwCrSaBguxJpYVV+YeYpTgYFYS4c2aCBTiTUmsrEotyo8vKs1JLT7EKM3B
	oiTOe6DVOlBIID2xJDU7NbUgtQgmy8TBKdXA2GR+5X9u86/TN3rubNhTMeWbkWm9vHT1HBWW
	A5dk/1xZ/Lm2jskk3NRZbn54Is/Mt7x8jxI0p7wJEpqtWGmnfHdRCbeEIgdnWfxShoVpCyeE
	MTj3xk6a+vZv5d/V6TPXnj+SFiRSd7dBO7bp2hvLOZHt6hXbl4nO/v1H6mPLOdnKU0ee+0wu
	U2Ipzkg01GIuKk4EAIYqNXswAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class.txt |   52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
index 62261c0..ea50d27 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -8,6 +8,58 @@ LED is defined in max_brightness file. The brightness file will set the brightne
 of the LED (taking a value 0-max_brightness). Most LEDs don't have hardware
 brightness support so will just be turned on for non-zero brightness settings.
 
+Some LED devices support two modes - torch and flash. In order to enable
+support for flash LEDs the CONFIG_LEDS_CLASS_FLASH symbol must be defined
+in the kernel config. A flash LED driver must initialize the "flash" field
+of the led_classdev structure (see <linux/leds_flash.h>) to enable flash
+related features of the LED subsystem for the driver.
+
+There are seven sysfs attributes dedicated specifically to the flash LED devices:
+
+	- flash_brightness - flash LED brightness in milliampers (RW)
+	- max_flash_brightness - maximum available flash LED brightness (RO)
+	- flash_timeout - flash strobe duration in milliseconds (RW)
+	- max_flash_timeout - maximum available flash strobe duration (RO)
+	- flash_strobe - flash strobe state (RW)
+	- flash_fault - bitmask of flash faults that may have occured, possible
+			flags are:
+		* 0x01 - flash controller voltage to the flash LED has exceeded
+			 the limit specific to the flash controller
+		* 0x02 - the flash strobe was still on when the timeout set by
+			 the user has expired; not all flash controllers may set
+			 this in all such conditions
+		* 0x04 - the flash controller has overheated
+		* 0x08 - the short circuit protection of the flash controller
+			 has been triggered
+		* 0x10 - current in the LED power supply has exceeded the limit
+			 specific to the flash controller
+		* 0x40 - flash controller voltage to the flash LED has been below
+			 the minimum limit specific to the flash
+		* 0x80 - the input voltage of the flash controller is below
+			 the limit under which strobing the flash at full current
+			 will not be possible. The condition persists until this
+			 flag is no longer set
+		* 0x100 - the temperature of the LED has exceeded its allowed
+			  upper limit
+	- hw_triggered - some devices expose dedicated hardware pins for
+			 triggering a flash LED - the attribute allows to set
+			 this mode (RW)
+
+The LED subsystem driver can be controlled also from the level of
+the VideoForLinux2 subsystem. In order to enable this the CONFIG_V4L2_FLASH
+symbol has to be defined in the kernel config. The driver must
+initialize v4l2_flash_ctrl_config structure and pass it to the v4l2_flash_init
+function. On remove v4l2_flash_release has to be called (see <media/v4l2-flash.h>).
+After proper initialization V4L2 Flash sub-device is created. The sub-device
+must be registered by a V4L2 video device to become available for the user
+space. This is accomplished with use of asynchronous sub-device registration
+mechanism (see <media/v4l2-async.h>).
+A V4l2 Flash sub-device exposes a number of V4L2 controls.
+When the V4L2_CID_FLASH_LED_MODE control is set to V4L2_FLASH_LED_MODE_TORCH
+or V4L2_FLASH_LED_MODE_FLASH the LED subsystem sysfs interface becomes
+unavailable. The interface can be unlocked by setting the mode back
+to V4L2_FLASH_LED_MODE_NONE.
+
 The class also introduces the optional concept of an LED trigger. A trigger
 is a kernel based source of led events. Triggers can either be simple or
 complex. A simple trigger isn't configurable and is designed to slot into
-- 
1.7.9.5

