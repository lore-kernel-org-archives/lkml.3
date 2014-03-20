Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbaCTOvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:51:46 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54066 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546AbaCTOvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:41 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-f0-532b007cc849
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC 3/8] Documentation: leds: Add description of flash mode
Date: Thu, 20 Mar 2014 15:51:05 +0100
Message-id: <1395327070-20215-4-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t9jQd0aBu1gg4kTrSxurTvHanF050Qm
	i/lHgKzeq88ZLc42vWG3uLxrDpvF1jfrGC16Nmxltdi96ymrxeE37awOXB47Z91l99gz/wer
	R9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGV8nP+fqeCIUMWc5QYNjG38XYycHBICJhILjjxl
	hrDFJC7cW8/WxcjFISQwnVHiYdd3RpCEkEAnk0TXX1EQm03AUOLni9dMILaIQLnEtKmPmEAa
	mAX2MUpsmnYcbJKwgLfEgteL2UBsFgFVibdzZ4E18Ap4SEz6spK9i5EDaJuCxJxJNiBhTgFP
	iaVLu5hBwkJAJWcnRkxg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjInknvYFzV
	YHGIUYCDUYmHd8UezWAh1sSy4srcQ4wSHMxKIrx2z7WChXhTEiurUovy44tKc1KLDzFKc7Ao
	ifMebLUOFBJITyxJzU5NLUgtgskycXBKNTD677FKn5W7V/fdPJcl/z+URro96q1dydfhtPPg
	TW2hLxmPJt465nbP+sOzazt7lX6wXPjqeCOtXfeLtN3ah1tjZR17UjRyK8/ufBlf6cbQdXEp
	u80Z28nOu7de2ZbCvnO/VZFoZXU6+zfLzdb5c953z7kVmnhHZlM/v1OjSeyJGOX/HtItl6uU
	WIozEg21mIuKEwEXGuKtLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/Documentation/leds/leds-class.txt b/Documentation/leds/leds-class.txt
index 62261c0..d34d990 100644
--- a/Documentation/leds/leds-class.txt
+++ b/Documentation/leds/leds-class.txt
@@ -8,6 +8,31 @@ LED is defined in max_brightness file. The brightness file will set the brightne
 of the LED (taking a value 0-max_brightness). Most LEDs don't have hardware
 brightness support so will just be turned on for non-zero brightness settings.
 
+Some LED devices support two modes - torch and flash. A LED subsystem device
+driver can declare this by calling led_classdev_init_flash function and
+initializing flash field of the led_classdev structure (see <linux/leds.h>).
+There are five sysfs attributes dedicated specifically to the flash LED devices:
+
+	- flash_mode - sets/unsets the flash mode
+	- flash_timeout - determines duration of the flash blink in milliseconds
+	- max_flash_timeout - maximum flash blink duration that can be set (RO)
+	- flash_fault - bitmask of flash faults that may have occured, possible
+			flags are:
+		* 0x01 - Flash controller voltage to the flash LED has exceeded
+			 the limit specific to the flash controller.
+		* 0x02 - The flash strobe was still on when the timeout set by
+			 the user has expired. Not all flash controllers may set
+			 this in all such conditions.
+		* 0x04 - The flash controller has overheated.
+		* 0x08 - The short circuit protection of the flash controller
+			 has been triggered.
+		* 0x10 - Current in the LED power supply has exceeded the limit
+			 specific to the flash controller.
+	- hw_triggered - Some devices expose dedicated hardware pins for
+			 triggering a flash LED. The attribute allows to set
+			 this mode. After writting 1 the brightness has to be set
+			 to the desired value to arm a led.
+
 The class also introduces the optional concept of an LED trigger. A trigger
 is a kernel based source of led events. Triggers can either be simple or
 complex. A simple trigger isn't configurable and is designed to slot into
-- 
1.7.9.5

