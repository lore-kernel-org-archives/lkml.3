Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbbAIPX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:23:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23308 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbbAIPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:24 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-1b-54aff269fcf6
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v10 00/19] LED / flash API integration
Date: Fri, 09 Jan 2015 16:22:50 +0100
Message-id: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQd3MT+tDDN4uM7LYOGM9q8XRnROZ
	LOYfOcdq0Xv1OaPF2aY37BaXd81hs9j6Zh2jRc+GrawWd08dZbPYvespq8XhN+2sFmf2r2Rz
	4PHYOesuu8fhrwtZPPbM/8Hq0bdlFaPHitXf2T0+b5ILYIvisklJzcksSy3St0vgyrh78yV7
	QbdexbtVPg2M65W7GDk5JARMJM5c2sAMYYtJXLi3nq2LkYtDSGA6o8T+T/OhnHYmidnb2sCq
	2AQMJX6+eM3UxcjBISIQLXHpWD1IDbPAC0aJe5MfsIHUCAtYSdy484YRxGYRUJV4/OkrWC+v
	gLvExpdnmEF6JQQUJOZMspnAyL2AkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnB4PZPe
	wbiqweIQowAHoxIP7wa59SFCrIllxZW5hxglOJiVRHgbNgOFeFMSK6tSi/Lji0pzUosPMUpz
	sCiJ8yrZt4UICaQnlqRmp6YWpBbBZJk4OKUaGN1aOqPuiy7/P+38SbOFDzb/NfnyyrvJ6cJ8
	6UOLz59e28ynuumXR7N8pqTC4wsyfnenvtz09tStewozPHvbnz89a9d4PbTXcn3IhGOeP02y
	Yh9tNa+YEco1sXGL1e3whx+PcCoc/7bmyFORtjqzqsMCTy3Oyvr3nTtoePQgV92S2bM1WNcI
	XLmnxFKckWioxVxUnAgA96LbdysCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a follow-up of the LED / flash API integration
series [1]. It is based on linux-next_20150108.

========================
Changes since version 9 :
========================

- switched to assigning sub-led related of_node to led_cdev->dev->of_node
  member which allowed for avoiding modifications around v4l-async
- reimplemented max77693 flash cell driver to avoid extensive use
  of macros
- added led-sources DT property and switched to using it
- switched to reporting flash faults in the LED subsystem in the form
  of human readable strings
- added available_sync_leds sysfs attribute to the LED Flash class
  and changed the semantics of flash_sync_strobe attribute
- made LED subsystem flash faults not depending on the V4L2 Flash ones
- applied various fixes and cleanups

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

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (19):
  leds: Add LED Flash class extension to the LED subsystem
  Documentation: leds: Add description of LED Flash class extension
  DT: leds: Add led-sources property
  dt-binding: mfd: max77693: Add DT binding related macros
  mfd: max77693: Modify flash cell name identifiers
  mfd: max77693: modifications around max77693_led_platform_data
  mfd: max77693: Adjust FLASH_EN_SHIFT and TORCH_EN_SHIFT macros
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693
  leds: Add driver for AAT1290 current regulator
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290
  exynos4-is: Add support for v4l2-flash subdevs
  v4l2-ctrls: Add V4L2_CID_FLASH_SYNC_STROBE control
  media: Add registration helpers for V4L2 flash sub-devices
  Documentation: leds: Add description of v4l2-flash sub-device
  DT: Add documentation for exynos4-is 'flashes' property
  leds: max77693: add support for V4L2 Flash sub-device
  leds: aat1290: add support for V4L2 Flash sub-device

 Documentation/DocBook/media/v4l/controls.xml       |    9 +
 Documentation/devicetree/bindings/leds/common.txt  |    5 +
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +
 .../devicetree/bindings/media/samsung-fimc.txt     |    7 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   69 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   70 ++
 drivers/leds/Kconfig                               |   27 +
 drivers/leds/Makefile                              |    3 +
 drivers/leds/led-class-flash.c                     |  486 ++++++++
 drivers/leds/led-class.c                           |    4 +
 drivers/leds/leds-aat1290.c                        |  460 ++++++++
 drivers/leds/leds-max77693.c                       | 1178 ++++++++++++++++++++
 drivers/media/platform/exynos4-is/media-dev.c      |   36 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   13 +-
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  581 ++++++++++
 drivers/mfd/max77693.c                             |    4 +-
 include/dt-bindings/mfd/max77693.h                 |   21 +
 include/linux/led-class-flash.h                    |  207 ++++
 include/linux/leds.h                               |    3 +
 include/linux/mfd/max77693-private.h               |    4 +-
 include/linux/mfd/max77693.h                       |    9 +-
 include/media/v4l2-flash.h                         |  139 +++
 include/uapi/linux/v4l2-controls.h                 |    1 +
 27 files changed, 3357 insertions(+), 12 deletions(-)
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

