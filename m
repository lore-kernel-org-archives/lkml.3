Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946485Ab3BHOid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:38:33 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60568 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144Ab3BHOi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:38:29 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] hid driver transport cleanup
Date: Fri,  8 Feb 2013 15:37:29 +0100
Message-Id: <1360334256-22127-1-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

so, here is the hid drivers cleanup. The aim is to remove as much as possible
direct calls to usbhid for hid drivers. Thus, other transport layers can use
the existing hid drivers (like I2C or uhid).

Henrik, patches 1 to 5 are yours. I just rebased and double-checked them. Please
add you Signed-off-by if you are happy with the rebase.

Patches applies on top of Jiri's for-next branch.

Cheers,
Benjamin

Benjamin Tissoires (7):
  HID: Extend the interface with report requests
  HID: Extend the interface with wait io request
  HID: Kconfig: Remove explicit transport layer dependencies
  hid: use hid_hw_request() instead of direct call to usbhid
  HID: use hid_hw_wait() instead of direct call to usbhid
  HID: multitouch: remove usbhid dependency
  HID: multitouch: Copyright and note on regression tests

 drivers/hid/Kconfig                 | 98 ++++++++++++++++++-------------------
 drivers/hid/hid-apple.c             |  1 -
 drivers/hid/hid-axff.c              |  6 +--
 drivers/hid/hid-dr.c                |  8 ++-
 drivers/hid/hid-emsff.c             |  6 +--
 drivers/hid/hid-gaff.c              | 10 ++--
 drivers/hid/hid-holtekff.c          |  4 +-
 drivers/hid/hid-kye.c               |  4 +-
 drivers/hid/hid-lenovo-tpkbd.c      |  4 +-
 drivers/hid/hid-lg2ff.c             |  6 +--
 drivers/hid/hid-lg3ff.c             |  6 +--
 drivers/hid/hid-lg4ff.c             | 18 +++----
 drivers/hid/hid-lgff.c              |  8 ++-
 drivers/hid/hid-logitech-dj.c       |  3 +-
 drivers/hid/hid-magicmouse.c        |  1 -
 drivers/hid/hid-multitouch.c        | 21 ++++++--
 drivers/hid/hid-ntrig.c             | 10 ++--
 drivers/hid/hid-picolcd.h           |  4 +-
 drivers/hid/hid-picolcd_backlight.c |  4 +-
 drivers/hid/hid-picolcd_cir.c       |  2 -
 drivers/hid/hid-picolcd_core.c      |  8 ++-
 drivers/hid/hid-picolcd_debugfs.c   |  2 -
 drivers/hid/hid-picolcd_fb.c        | 12 ++---
 drivers/hid/hid-picolcd_lcd.c       |  4 +-
 drivers/hid/hid-picolcd_leds.c      |  4 +-
 drivers/hid/hid-pl.c                |  6 +--
 drivers/hid/hid-prodikeys.c         |  3 +-
 drivers/hid/hid-sensor-hub.c        | 12 ++---
 drivers/hid/hid-sjoy.c              |  6 +--
 drivers/hid/hid-speedlink.c         |  2 -
 drivers/hid/hid-steelseries.c       |  3 +-
 drivers/hid/hid-tmff.c              |  6 +--
 drivers/hid/hid-zpff.c              |  6 +--
 drivers/hid/usbhid/hid-core.c       | 20 ++++++--
 drivers/hid/usbhid/hid-pidff.c      | 80 +++++++++++++++---------------
 drivers/hid/usbhid/hiddev.c         |  8 +--
 drivers/hid/usbhid/usbhid.h         |  3 --
 include/linux/hid.h                 | 34 +++++++++++++
 38 files changed, 224 insertions(+), 219 deletions(-)

-- 
1.8.1

