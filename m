Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaLCQH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:07:26 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26257 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaLCQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:21 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-04-547f3536afe9
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v9 02/19] Documentation: leds: Add description of LED Flash
 class extension
Date: Wed, 03 Dec 2014 17:06:37 +0100
Message-id: <1417622814-10845-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQV0z0/oQg3V/DC02zljPanF050Qm
	i/43C1ktzr1ayWjRe/U5o8XZpjfsFpd3zWGz2PpmHaNFz4atrBZLr19ksrh76iibxYTpa1ks
	WvceYbfYvespq8XhN+2sFmf2r2RzEPBYM28No8flvl4mj52z7rJ7rFz+hc3j8NeFLB6bVnWy
	eeyZ/4PVo2/LKkaPFau/s3t83iQXwBXFZZOSmpNZllqkb5fAlfHn+wn2gv0SFXePKjQw7hfu
	YuTkkBAwkVj6cwI7hC0mceHeerYuRi4OIYHpjBLL9j5khnDamSS61r5nAaliEzCU+PniNVMX
	IweHiEC0xKVj9SBhZoGDTBK3HpeD2MICiRIbJ+5mBbFZBFQllh9YDNbKK+Ah8XXhMnaQVgkB
	BYk5k2xAwpwCnhJPf9wHCwsBlRyc6D+BkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxN
	jODQfia9g3FVg8UhRgEORiUeXou4uhAh1sSy4srcQ4wSHMxKIrzPvgGFeFMSK6tSi/Lji0pz
	UosPMUpzsCiJ8964mRsiJJCeWJKanZpakFoEk2Xi4JRqYIwzu3XvlcLB7mbuFVpd7tw6Ruyu
	591sak2V5ionrZgt9ZXnDK+7uUfi7PDKfcYMohd+8kRqu3fy91jGMPa8VFJj+LJprvb811UM
	007nltoyaKpv6ZHNm2e3L/tz41fWXAeZ54nbH9hdLApqu83g7PGq/nyM7iGl3u1PbLZWbQ6b
	aXqV+8pnJZbijERDLeai4kQAbfvud2kCAAA=
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
 Documentation/leds/leds-class-flash.txt |   50 +++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/leds/leds-class-flash.txt

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
new file mode 100644
index 0000000..82e58b1
--- /dev/null
+++ b/Documentation/leds/leds-class-flash.txt
@@ -0,0 +1,50 @@
+
+Flash LED handling under Linux
+==============================
+
+Some LED devices support two modes - torch and flash. The modes are
+supported by the LED class (see Documentation/leds/leds-class.txt)
+and LED Flash class respectively.
+
+In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
+must be defined in the kernel config. A flash LED driver must register
+in the LED subsystem with led_classdev_flash_register to gain flash
+capabilities.
+
+Following sysfs attributes are exposed for controlling flash led devices:
+
+	- flash_brightness - flash LED brightness in microamperes (RW)
+	- max_flash_brightness - maximum available flash LED brightness (RO)
+	- flash_timeout - flash strobe duration in microseconds (RW)
+	- max_flash_timeout - maximum available flash strobe duration (RO)
+	- flash_strobe - flash strobe state (RW)
+	- flash_sync_strobe - one flash device can control more than one
+			      sub-led; when this atrribute is set to 1
+			      the flash led will be strobed synchronously
+			      with the other one controlled by the same
+			      device; flash timeout setting is inherited
+			      from the led being strobed explicitly and
+			      flash brightness setting of a sub-led's
+			      being synchronized is used (RW)
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
+		* 0x40 - flash controller voltage to the flash LED has been
+			 below the minimum limit specific to the flash
+		* 0x80 - the input voltage of the flash controller is below
+			 the limit under which strobing the flash at full
+			 current will not be possible. The condition persists
+			 until this flag is no longer set
+		* 0x100 - the temperature of the LED has exceeded its allowed
+			  upper limit
+
+		Flash faults are cleared by reading the attribute.
-- 
1.7.9.5

