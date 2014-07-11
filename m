Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaGKOFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:05:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59406 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaGKOFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:05 -0400
X-AuditID: cbfee61b-f79f86d00000144c-0f-53bfef0e6501
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v4 09/21] Documentation: leds: Add description of LED Flash
 Class extension
Date: Fri, 11 Jul 2014 16:04:12 +0200
Message-id: <1405087464-13762-10-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2+9/uDDRYt1LPYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWu3c9ZXXg9Ng56y67x575P1g9+ras
	YvT4vEkugCWKyyYlNSezLLVI3y6BK2PFttKCGVYV/bd+sTYwtup3MXJySAiYSPxp6mCGsMUk
	Ltxbz9bFyMUhJDCdUeLi05NMEE47k8TPk8tYQarYBAwlfr54zQRiiwiUS/S8fwbWwSywmlHi
	ztavYEXCAokSl37fBrNZBFQlHjfdAVvBK+ApsXrlZiCbA2idgsScSTYgYU6g8MH+m2wgtpCA
	h8TDtSfYJzDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHF7PpHcwrmqwOMQowMGo
	xMN7Ys2+YCHWxLLiytxDjBIczEoivFff7A8W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQ
	SCA9sSQ1OzW1ILUIJsvEwSnVwMguPnMO44K1l59VJS9b4nOu0Ln63/sN7NnSDg48zdqGh919
	1Se89vP7rOR59pP466699/XrjK+lXJ+1vEB+4k+m2ku69QcXces1d2noZBX29qkFHH5SmDlF
	dwbHg7lVTsflH7Rc4C/+/PGdRcNtJVl/WRmtBZ+qXnuf+rguyyQ7634He2LOYyWW4oxEQy3m
	ouJEAK/raicrAgAA
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
 Documentation/leds/leds-class-flash.txt |  126 +++++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..0927804
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,126 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. In order to enable
+support for flash LEDs the CONFIG_LEDS_CLASS_FLASH symbol must be defined
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
+The LED subsystem driver can be controlled also from the level of VideoForLinux2
+subsystem. In order to enable this the CONFIG_V4L2_FLASH_LED_CLASS symbol has to
+be defined in the kernel config. The driver must call v4l2_flash_init function
+to get registered in the V4L2 subsystem. On remove v4l2_flash_release function
+has to be called (see <media/v4l2-flash.h>).
+
+After proper initialization V4L2 Flash sub-device is created. The sub-device
+exposes a number of V4L2 controls. When the V4L2_CID_FLASH_LED_MODE control
+is set to V4L2_FLASH_LED_MODE_TORCH or V4L2_FLASH_LED_MODE_FLASH the
+LED subsystem sysfs interface becomes unavailable. The interface can be unlocked
+by setting the mode back to V4L2_FLASH_LED_MODE_NONE.
+
+
+Flash Manager
+=============
+
+Flash LED devices often provide two ways of strobing the flash: software
+(e.g. by setting a bit in a register) and hardware, by asserting dedicated pin,
+which is usually connected to a camera sensor device. There are also flash led
+devices which support only hardware strobing - in such cases a multiplexer
+device is employed to route the flash strobe signal either from the SoC GPIO or
+from the external strobe signal provider, e.g. camera sensor.
+Use of multiplexers allows also to change the flash-sensor connection
+dynamically if there is more than one flash or external strobe signal provider
+available on the board.
+
+In order to address the aforementioned cases the Flash Manager functionality
+has been introduced. Flash Manager is a part of LED Flash Class. It maintains
+information about flashes, software and external strobe signal providers and
+multiplexers that route strobe signals among them.
+
+To register a LED Flash Class device in the flash manager the device_node
+of a flash device has to be passed as the third argument to the
+led_classdev_flash_register function. The device_node is expected to include one
+gate-software-strobe subnode and at least one gate-external-strobeN subnode.
+Besides that there must defined a flash_muxes node aggregating all the
+multiplexers that can be referenced to by the flash led devices.
+(for mote details see Documentation/devicetree/bindings/leds/
+leds-flash-manager.txt).
+
+Flash manager adds following sysfs attributes to the LED Flash Clash
+device sysfs interface:
+
+	- strobe_provider - id of the external strobe signal provider associated
+                            with the flash led device. It is created only if
+			    there is more than one external strobe signal
+			    provider defined (RW).
+	- strobe_providerN - names of the strobe signal providers available
+			     for the flash led device, where N is the
+			     identifier of a strobe signal provider (RO)
+	- blocking_strobe - informs if enabling either software or external
+			    strobe will block the caller for the expected
+			    time of strobing (1 - true, 0 - false). The call
+			    needs to be blocking if the multiplexers involved
+			    in the strobe signal routing are connected to more
+			    than one flash led device. In such a case flash
+			    manager becomes locked for the expected time of
+			    strobing to prevent reconfigurarion of multiplexers
+			    by the other flash led devices willing to strobe
+			    in the same time (RO).
+
+
+LED Flash Class multiplexers
+============================
+
+Multiplexers are an indispensable part of the Flash Manager. Flash Manager has
+its own led_flash_gpio_mux* helpers for creating, releasing and operating on
+the simple gpio driven multiplexers (the ones whose lines are selected by
+changing the state of its selector pins) and the user doesn't have to bother
+with it.
+
+It is however possible that a more advanced device will be used for routing
+strobe signals. This kind of devices are known to the Flash Manager as
+"asynchronous muxes" and can be registered in runtime with use of
+led_flash_manager_bind_async_mux API and unregistered with
+led_flash_manager_unbind_async_mux. (see Documentation/leds/leds-async-mux.c
+for the exemplary implementation of the async mux driver).
+
+If a LED Flash Class device declares dependency on an async mux, then strobing
+the flash, or setting external strobe, will succeed only wnen the async mux
+has been bound to the Flash Manager. Async mux module, once bound, can be
+removed only after all LED Flash Class devices depending on it are unregistered
+from the Flash Manager.
-- 
1.7.9.5

