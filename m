Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbaGOSqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932896AbaGOSpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:45:54 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 00/23] Wacom queued patches
Date: Tue, 15 Jul 2014 14:45:23 -0400
Message-Id: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

this is a resend/v2 of part of the Wacom tablet kernel work I have been
conducted during this merge window.

There are 2 fixes (01/23 and 02/23), a compatibility feature for wayland
(splitting the pad input device out of the pen/finger ones, which allows to
have a simple mapping kernel event / user event), and the conversion from a pure
usb driver to a HID one.

This conversion will allow us to make regression tests and hopefully help
including new devices in a much faster way when the report descriptors will be
fixed in the kernel or in the hardware.

I added a brand new patch (23/23) which moves wacom.ko into drivers/hid.
Jiri asked me to move the module into his subtree once the change is done, so
here it is.

I discussed with Jiri last Friday, and he was fine that you take this work
through your tree, even if it changes some files in his.
In order not to make the mess between your two trees, I removed one patch
(HID: uhid: add and set HID_TYPE_UHID for uhid devices) which is not mandatory
for the user.

Cheers,
Benjamin


Benjamin Tissoires (23):
  Revert "Input: wacom - testing result shows get_report is
    unnecessary."
  Input - wacom: assign phys field from struct wacom into input_dev
  Input - wacom: create a separate input device for pads
  Input - wacom: split out the pad device for Intuos/Cintiq
  Input - wacom: split out the pad device for Bamboos
  Input - wacom: split out the pad device for DTUS
  Input - wacom: split out the pad device for Graphire G4 and MO
  Input - wacom: split out the pad device for the wireless receiver
  Input - wacom: include and use linux/hid.h
  Input - wacom: switch from an USB driver to a HID driver
  Input - wacom: use hid communication instead of plain usb
  Input - wacom: use HID core to actually fetch the report descriptor
  Input - wacom: compute the HID report size to get the actual packet
    size
  Input - wacom: install LED/OLED sysfs files in the HID device instead
    of USB
  Input - wacom: register the input devices on top of the HID one
  Input - wacom: remove usb dependency for siblings devices
  Input - wacom: register power device at the HID level
  Input - wacom: use hid_info instead of plain dev_info
  Input - wacom: use in-kernel HID parser
  Input - wacom: use hidinput_calc_abs_res instead of duplicating its
    code
  Input - wacom: remove field pktlen declaration in the list of devices
  Input - wacom: keep wacom_ids ordered
  Input - wacom: Move the USB (now hid) Wacom driver in drivers/hid

 drivers/hid/Kconfig              |   13 +
 drivers/hid/Makefile             |    3 +
 drivers/hid/hid-core.c           |   10 +-
 drivers/hid/hid-wacom.c          |    2 +-
 drivers/hid/wacom.h              |  138 +++
 drivers/hid/wacom_sys.c          | 1257 +++++++++++++++++++
 drivers/hid/wacom_wac.c          | 2534 ++++++++++++++++++++++++++++++++++++++
 drivers/hid/wacom_wac.h          |  169 +++
 drivers/input/tablet/Kconfig     |   16 -
 drivers/input/tablet/Makefile    |    3 -
 drivers/input/tablet/wacom.h     |  139 ---
 drivers/input/tablet/wacom_sys.c | 1497 ----------------------
 drivers/input/tablet/wacom_wac.c | 2485 -------------------------------------
 drivers/input/tablet/wacom_wac.h |  165 ---
 include/linux/hid.h              |    5 +
 15 files changed, 4129 insertions(+), 4307 deletions(-)
 create mode 100644 drivers/hid/wacom.h
 create mode 100644 drivers/hid/wacom_sys.c
 create mode 100644 drivers/hid/wacom_wac.c
 create mode 100644 drivers/hid/wacom_wac.h
 delete mode 100644 drivers/input/tablet/wacom.h
 delete mode 100644 drivers/input/tablet/wacom_sys.c
 delete mode 100644 drivers/input/tablet/wacom_wac.c
 delete mode 100644 drivers/input/tablet/wacom_wac.h

-- 
2.0.0

