Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaHTNog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:44:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36219 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaHTNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:44:33 -0400
X-AuditID: cbfee61b-f79f86d00000144c-9e-53f4a63fc7eb
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 01/10] Documentation: leds: Add description of LED Flash
 Class extension
Date: Wed, 20 Aug 2014 15:44:10 +0200
Message-id: <1408542259-415-2-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542259-415-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAV37ZV+CDc63SVhsnLGe1eLozolM
	FvOPnGO16L36nNHibNMbdovLu+awWWx9s47RomfDVlaL3buesjpweuycdZfdY8/8H6wefVtW
	MXp83iQXwBLFZZOSmpNZllqkb5fAlXGx6xlLwRWZipN/lrA3MG4S72Lk5JAQMJGY2/yXBcIW
	k7hwbz1bFyMXh5DAIkaJIxOWMEI47UwSl/9eZgWpYhMwlPj54jUTiC0iUC7R8/4ZWAezwGpG
	iTtbv4IVCQskSlz6cYAZxGYRUJU4f2M7O4jNK+Amce7UMaBmDqB1ChJzJtmAmJwC7hJb3quA
	VAgBVZx+N5tlAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB4fVMegfjqgaLQ4wC
	HIxKPLw3Fn0JFmJNLCuuzD3EKMHBrCTC294JFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEpBQweVZbUQ+3bpVbEGi//dzDuwewAjRj5Kq4nkRPl79yzN96x
	qEYqKGN/8suatodmnvKyGscl+dWD7dZeunXY4oXwJiuZM78cz6xeaijyPil4ocO05uSErROP
	Xg9+ZOEc/XNpiHL8hUt31CznNLzc/IO3su5rVlDjynVaJ3xnbuXauyGu2mKj8EslluKMREMt
	5qLiRAAFHViPKwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation being added contains overall description of the
LED Flash Class and the related sysfs attributes. There are also
chapters devoted specifically to the Flash Manager feature.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   54 +++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..8a9c17e
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,54 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. In order to enable
+support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol must be defined
+in the kernel config. A flash LED driver must register in the LED subsystem
+with led_classdev_flash_register to gain flash capabilities.
+
+Following sysfs attributes are exposed for controlling flash led devices:
+
+	- flash_brightness - flash LED brightness in microamperes (RW)
+	- max_flash_brightness - maximum available flash LED brightness (RO)
+	- indicator_brightness - privacy LED brightness in microamperes (RW)
+	- max_indicator_brightness - maximum privacy LED brightness in
+				     microamperes (RO)
+	- flash_timeout - flash strobe duration in microseconds (RW)
+	- max_flash_timeout - maximum available flash strobe duration (RO)
+	- flash_strobe - flash strobe state (RW)
+	- external_strobe - some devices expose dedicated hardware pins for
+			    triggering a flash LED - this attribute allows to
+			    set this mode (RW)
+	- flash_fault - bitmask of flash faults that may have occurred,
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
+		* 0x40 - flash controller voltage to the flash LED has been
+			 below the minimum limit specific to the flash
+		* 0x80 - the input voltage of the flash controller is below
+			 the limit under which strobing the flash at full
+			 current will not be possible. The condition persists
+			 until this flag is no longer set
+		* 0x100 - the temperature of the LED has exceeded its allowed
+			  upper limit
+
+A LED subsystem driver can be controlled also from the level of VideoForLinux2
+subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
+be defined in the kernel config. The driver must call v4l2_flash_init function
+to get registered in the V4L2 subsystem. On remove v4l2_flash_release function
+has to be called (see <media/v4l2-flash.h>).
+
+After proper initialization V4L2 Flash sub-device is created. The sub-device
+exposes a number of V4L2 controls. When the V4L2_CID_FLASH_LED_MODE control
+is set to V4L2_FLASH_LED_MODE_TORCH or V4L2_FLASH_LED_MODE_FLASH the
+LED subsystem sysfs interface becomes unavailable. The interface can be
+unlocked by setting the mode back to V4L2_FLASH_LED_MODE_NONE.
-- 
1.7.9.5

