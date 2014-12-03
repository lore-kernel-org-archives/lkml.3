Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaLCQHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:07:41 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:65336 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaLCQHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:07:38 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-f9-547f352af30a
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v9 00/19] LED / flash API integration
Date: Wed, 03 Dec 2014 17:06:35 +0100
Message-id: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQV0t0/oQg0OnrCw2zljPanF050Qm
	i/43C1ktzr1ayWjRe/U5o8XZpjfsFpd3zWGz2PpmHaNFz4atrBZLr19ksrh76iibxYTpa1ks
	WvceYbfYvespq8XhN+2sFmf2r2RzEPBYM28No8flvl4mj52z7rJ7rFz+hc3j8NeFLB6bVnWy
	eeyZ/4PVo2/LKkaPFau/s3t83iQXwBXFZZOSmpNZllqkb5fAlXHi113mgv/qFYcun2JtYJwh
	18XIySEhYCJx7u9HFghbTOLCvfVsXYxcHEIC0xklJm+awQ7htDNJnLr/hhmkik3AUOLni9dM
	XYwcHCIC0RKXjtWDhJkFDjJJ3HpcDmILC1hKfNz2iQ3EZhFQlTjfdwqslVfAQ+LWrQZ2kFYJ
	AQWJOZNsJjByL2BkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHK7PpHcwrmqwOMQowMGo
	xMNrEVcXIsSaWFZcmXuIUYKDWUmE99k3oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeGzdzQ4QE
	0hNLUrNTUwtSi2CyTBycUg2Ma5OP7ztz+uShI2K9TG/Lgi53rH3Tlf5g4c4oHtdtwW8vs+V8
	O952M1P14D1tqQQ+fYk5q/tZ9yT/9tkavdU1JqnrlrzogfbywtyrX76+P1tQX+Z/rMX8OT/3
	KYNAcwsduQMCGzYd5E1/tvSlYuWVaXel+UVW9XwI/ff6uvz/xEP9GX9uKri3KrEUZyQaajEX
	FScCAIEN6EdTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a follow-up of the LED / flash API integration
series [1].

========================
Changes since version 8:
========================

- added a new way of registering async sub-device
- switched to matching flash leds by DT phandles
- improved Device Tree bindings documentation
- split the drivers patches to LED Flash class
  and V4L2 Flash part
- fixed indicator leds handling in v4l2-flash
- applied various fixes an cleanups

========================
Changes since version 7:
========================

- removed explicit support for indicator leds from
  LED Flash class - indicator leds will be registered
  as a separate LED Flash class devices
- added flash_sync_strobe sysfs attribute and related
  V4L2_CID_FLASH_SYNC_STROBE control
- changed the way of matching V4L2 Flash sub-devices
  in a media device, which entailed modification in
  v4l2-async driver
- modified max77693 DT bindings documentation
- applied various fixes an cleanups

========================
Changes since version 6:
========================

- removed addition of public LED subsystem API for setting
  torch brightness in favour of internal API for
  synchronous and asynchronous led brightness level setting
- fixed possible race condition upon creating LED Flash class
  related sysfs attributes

========================
Changes since version 5:
========================

- removed flash manager framework - its implementation needs
  further thorough discussion.
- removed external strobe facilities from the LED Flash Class
  and provided external_strobe_set op in v4l2-flash. LED subsystem
  should be strobe provider agnostic.

Thanks,
Jacek Anaszewski

Jacek Anaszewski (19):
  leds: Add LED Flash class extension to the LED subsystem
  Documentation: leds: Add description of LED Flash class extension
  mfd: max77693: Modify flash cell name identifiers
  mfd: max77693: adjust max77693_led_platform_data
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693
  dt-binding: mfd: max77693: Add DT binding related macros
  leds: Add driver for AAT1290 current regulator
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290
  v4l2-async: change custom.match callback argument type
  v4l2-async: add V4L2_ASYNC_MATCH_CUSTOM_OF matching type
  v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE control
  media: Add registration helpers for V4L2 flash sub-devices
  Documentation: leds: Add description of v4l2-flash sub-device
  exynos4-is: Add support for v4l2-flash subdevs
  DT: Add documentation for exynos4-is 'flashes' property
  leds: max77693: add support for V4L2 Flash sub-device
  leds: aat1290: add support for V4L2 Flash sub-device

 Documentation/DocBook/media/v4l/controls.xml       |   11 +
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   89 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   63 ++
 drivers/leds/Kconfig                               |   27 +
 drivers/leds/Makefile                              |    3 +
 drivers/leds/led-class-flash.c                     |  446 ++++++++
 drivers/leds/led-class.c                           |    4 +
 drivers/leds/leds-aat1290.c                        |  474 ++++++++
 drivers/leds/leds-max77693.c                       | 1154 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.c      |   42 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-async.c               |  122 ++-
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  546 +++++++++
 drivers/mfd/max77693.c                             |    4 +-
 include/dt-bindings/mfd/max77693.h                 |   38 +
 include/linux/led-class-flash.h                    |  186 ++++
 include/linux/leds.h                               |    3 +
 include/linux/mfd/max77693.h                       |    4 +-
 include/media/v4l2-async.h                         |    6 +-
 include/media/v4l2-flash.h                         |  139 +++
 include/uapi/linux/v4l2-controls.h                 |    1 +
 27 files changed, 3388 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/leds/leds-class-flash.txt
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/dt-bindings/mfd/max77693.h
 create mode 100644 include/linux/led-class-flash.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

