Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567Ab3BYKcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:32:46 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42995 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759078Ab3BYKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:32:44 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] hid driver transport cleanup
Date: Mon, 25 Feb 2013 11:31:42 +0100
Message-Id: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

this is the v2 of the hid transport cleanup.

Changes since v1:
- gathered reviewed/acked/etc..
- changed commit messages of patches 4-6
- add newcomer into account (thingm)
- incorporated the i2c-hid driver change into the series

I still did not implemented the final usb cleanup for hid-multitouch as it may
required few comments.

Cheers,
Benjamin

Benjamin Tissoires (8):
  HID: Extend the interface with report requests
  HID: Extend the interface with wait io request
  HID: Kconfig: Remove explicit transport layer dependencies
  HID: use hid_hw_request() instead of direct call to usbhid
  HID: use hid_hw_wait() instead of direct call to usbhid
  HID: multitouch: remove explicit usbhid dependency
  HID: multitouch: Copyright and note on regression tests
  HID: i2c-hid: implement request() callback

 drivers/hid/Kconfig                 | 100 ++++++++++++++++++------------------
 drivers/hid/hid-apple.c             |   1 -
 drivers/hid/hid-axff.c              |   6 +--
 drivers/hid/hid-dr.c                |   8 ++-
 drivers/hid/hid-emsff.c             |   6 +--
 drivers/hid/hid-gaff.c              |  10 ++--
 drivers/hid/hid-holtekff.c          |   4 +-
 drivers/hid/hid-kye.c               |   4 +-
 drivers/hid/hid-lenovo-tpkbd.c      |   4 +-
 drivers/hid/hid-lg2ff.c             |   6 +--
 drivers/hid/hid-lg3ff.c             |   6 +--
 drivers/hid/hid-lg4ff.c             |  18 +++----
 drivers/hid/hid-lgff.c              |   8 ++-
 drivers/hid/hid-logitech-dj.c       |   3 +-
 drivers/hid/hid-magicmouse.c        |   1 -
 drivers/hid/hid-multitouch.c        |  21 ++++++--
 drivers/hid/hid-ntrig.c             |  10 ++--
 drivers/hid/hid-picolcd.h           |   4 +-
 drivers/hid/hid-picolcd_backlight.c |   4 +-
 drivers/hid/hid-picolcd_cir.c       |   2 -
 drivers/hid/hid-picolcd_core.c      |   8 ++-
 drivers/hid/hid-picolcd_debugfs.c   |   2 -
 drivers/hid/hid-picolcd_fb.c        |  12 ++---
 drivers/hid/hid-picolcd_lcd.c       |   4 +-
 drivers/hid/hid-picolcd_leds.c      |   4 +-
 drivers/hid/hid-pl.c                |   6 +--
 drivers/hid/hid-prodikeys.c         |   3 +-
 drivers/hid/hid-sensor-hub.c        |  12 ++---
 drivers/hid/hid-sjoy.c              |   6 +--
 drivers/hid/hid-speedlink.c         |   2 -
 drivers/hid/hid-steelseries.c       |   3 +-
 drivers/hid/hid-thingm.c            |   1 -
 drivers/hid/hid-tmff.c              |   6 +--
 drivers/hid/hid-zpff.c              |   6 +--
 drivers/hid/i2c-hid/i2c-hid.c       |  32 ++++++++++++
 drivers/hid/usbhid/hid-core.c       |  20 ++++++--
 drivers/hid/usbhid/hid-pidff.c      |  80 ++++++++++++++---------------
 drivers/hid/usbhid/hiddev.c         |   8 +--
 drivers/hid/usbhid/usbhid.h         |   3 --
 include/linux/hid.h                 |  34 ++++++++++++
 40 files changed, 257 insertions(+), 221 deletions(-)

-- 
1.8.1.2

