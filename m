Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaJFWW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:22:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJFWWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:22:25 -0400
Date: Tue, 7 Oct 2014 00:22:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID for 3.18 merge window
Message-ID: <alpine.LNX.2.00.1410062358470.31343@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive


- quirk for devices that need to be pulled in much more aggresive way 
  than mandated, by Johan Hovold
- robustification of sanity checking of incoming reports in RMI driver,
  by Benjamin Tissoires
- fixes, updates, and new HW support to SONY driver, by Frank Praznik
- port of uHID to the new transport layer layout, by David Herrmann
- robustification of Clear-Halt/reset in USB HID, by Alan Stern
- native support for hopefully any future HID compliant wacom
  tablet. Those found on the various laptops (ISDv4/5) already are HID 
  compliant and they should work in the future without any modification of 
  the kernel. Written by Benjamin Tissoires.
- a lot more simple fixes and device ID additions all over the place



----------------------------------------------------------------

Alan Stern (1):
      HID: usbhid: improve handling of Clear-Halt and reset

Benjamin Tissoires (13):
      HID: input: force generic axis to be mapped to their user space axis
      HID: logitech-dj: break out testing of validity of dj_device
      HID: wacom: Add support for the Cintiq Companion
      HID: thingm: set the proper error code before leaving
      HID: wacom: make the WL connection friendly for the desktop
      HID: rmi: check sanity of the incoming report
      HID: wacom: fix timeout on probe for some wacoms
      HID: wacom: rename failN with some meaningful information
      HID: wacom: split out input allocation and registration
      HID: wacom: move allocation of inputs earlier
      HID: wacom: implement generic HID handling for pen generic devices
      HID: wacom: implement the finger part of the HID generic handling
      HID: uHID: fix excepted report type

Christian Gmeiner (1):
      HID: add support for PenMount HID TouchScreen Driver

David Herrmann (12):
      HID: uhid: simplify report-cb shutdown
      HID: uhid: forward create_req to create2_req
      HID: uhid: avoid dangling pointers in uhid context
      HID: uhid: avoid magic-numbers when setting strings
      HID: uhid: turn report_id into u32
      HID: uhid: invert report_done and make non-atomic
      HID: uhid: add ABI compatible UHID_GET_REPORT replacing UHID_FEATURE
      HID: uhid: keep legacy definitions at the bottom of uhid.h
      HID: uhid: rename uhid_raw_request to uhid_hid_raw_request
      HID: uhid: implement SET_REPORT
      HID: uhid: report to user-space whether reports are numbered
      HID: uhid: update documentation

Frank Praznik (5):
      HID: sony: Set the Sixaxis cable state correctly
      HID: sony: Corrections for the DualShock 4 HID descriptor
      HID: sony: Update file header and correct comments
      HID: sony: Set touchpad bits in the input_configured callback
      HID: sony: Update the DualShock 4 touchpad resolution

Hans Petter Selasky (1):
      HID: fix ignore_special_drivers modparam description

Jiri Kosina (3):
      HID: picolcd: be more verbose when reporting report size error
      HID: thingm: fix workqueue race on remove
      Merge branches 'for-3.18/always-poll-quirk', 'for-3.18/logitech', 'for-3.18/picolcd', 'for-3.18/rmi', 'for-3.18/sony', 'for-3.18/uhid', 'for-3.18/upstream' and 'for-3.18/wacom' into for-linus

Johan Hovold (2):
      HID: usbhid: add always-poll quirk
      HID: usbhid: enable always-poll quirk for Elan Touchscreen

John DeSilva (1):
      HID: Add Holtek USB ID 04d9:a0c2 ETEKCITY Scroll

Oliver Neukum (2):
      HID: usbhid: fix PIXART optical mouse
      HID: usbhid: add another mouse that needs QUIRK_ALWAYS_POLL

Ping Cheng (4):
      HID: wacom - Add default permission defines for sysfs attributes
      HID: wacom - Clean up of sysfs
      HID: wacom - remove report_id from wacom_get_report interface
      HID: wacom - enable LED support for Wireless Intuos5/Pro

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: re-add mistakenly removed USB_DEVICE_ID_STM_HID_SENSOR id

 Documentation/hid/uhid.txt      | 179 +++++++++---------
 drivers/hid/Kconfig             |  11 ++
 drivers/hid/Makefile            |   1 +
 drivers/hid/hid-core.c          |   7 +-
 drivers/hid/hid-holtek-mouse.c  |   4 +
 drivers/hid/hid-ids.h           |   7 +
 drivers/hid/hid-input.c         |   6 +
 drivers/hid/hid-logitech-dj.c   |  35 ++--
 drivers/hid/hid-penmount.c      |  49 +++++
 drivers/hid/hid-picolcd_core.c  |   4 +-
 drivers/hid/hid-rmi.c           |  44 ++++-
 drivers/hid/hid-sensor-hub.c    |   3 +
 drivers/hid/hid-sony.c          | 100 +++++-----
 drivers/hid/hid-thingm.c        |   7 +-
 drivers/hid/uhid.c              | 394 ++++++++++++++++++++++------------------
 drivers/hid/usbhid/hid-core.c   |  60 +++---
 drivers/hid/usbhid/hid-quirks.c |   3 +
 drivers/hid/wacom.h             |   6 +
 drivers/hid/wacom_sys.c         | 271 +++++++++++++++++++--------
 drivers/hid/wacom_wac.c         | 312 +++++++++++++++++++++++++++++++
 drivers/hid/wacom_wac.h         |  17 ++
 include/linux/hid.h             |   3 +
 include/uapi/linux/uhid.h       | 120 +++++++++---
 23 files changed, 1177 insertions(+), 466 deletions(-)
 create mode 100644 drivers/hid/hid-penmount.c

-- 
Jiri Kosina
SUSE Labs
