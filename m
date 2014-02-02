Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaBBEv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaBBEul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/11] HID: spring cleaning
Date: Sat,  1 Feb 2014 23:50:19 -0500
Message-Id: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

This is an attempt to complete the branch for-3.15/ll-driver-new-callbacks:
- try to implement as much as possible ll_driver callbacks (some are still
  missing, but I did not had the time to complete it)
- add inliners hid_hw_* for all the ll_driver callbacks
- remove transport dependant callbacks in struct hid_device
- remove the so called "obsolete" hidinput_input_event handler which was used
  in 2/4 transport drivers

Bonus point: 14 files changed, 213 insertions(+), 272 deletions(-)
Yay!

I made sure I kept the PS3 controller working and the LEDs (on logitech-dj and
on bluetooth keyboard) working. The rest do not mostly need further testing,
the code path did not changed. But still, a review (and some tests) would be a
good idea :)

Cheers,
Benjamin

PS: obviously, this goes on top on the branch for-3.15/ll-driver-new-callbacks

Benjamin Tissoires (11):
  HID: uHID: implement .raw_request
  HID: i2c-hid: implement ll_driver transport-layer callbacks
  HID: add inliners for ll_driver transport-layer callbacks
  HID: logitech-dj: remove hidinput_input_event
  HID: HIDp: remove hidp_hidinput_event
  HID: remove hidinput_input_event handler
  HID: HIDp: remove duplicated coded
  HID: usbhid: remove duplicated code
  HID: remove hid_get_raw_report in struct hid_device
  HID: introduce helper to access hid_output_raw_report()
  HID: move hid_output_raw_report to hid_ll_driver

 drivers/hid/hid-input.c        |  12 ++---
 drivers/hid/hid-lg.c           |   6 ++-
 drivers/hid/hid-logitech-dj.c  | 101 +++++++++++++---------------------
 drivers/hid/hid-magicmouse.c   |   2 +-
 drivers/hid/hid-sony.c         |  19 +++++--
 drivers/hid/hid-thingm.c       |   4 +-
 drivers/hid/hid-wacom.c        |  16 +++---
 drivers/hid/hid-wiimote-core.c |   4 +-
 drivers/hid/hidraw.c           |  11 ++--
 drivers/hid/i2c-hid/i2c-hid.c  |  27 +++++++++-
 drivers/hid/uhid.c             |  20 ++++++-
 drivers/hid/usbhid/hid-core.c  |  67 +++++------------------
 include/linux/hid.h            |  77 ++++++++++++++++++++++----
 net/bluetooth/hidp/core.c      | 119 +++++------------------------------------
 14 files changed, 213 insertions(+), 272 deletions(-)

-- 
1.8.3.1

