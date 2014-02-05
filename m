Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaBEVdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753686AbaBEVdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:33:35 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] HID: spring cleanup v2
Date: Wed,  5 Feb 2014 16:33:15 -0500
Message-Id: <1391636004-29354-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

well, here comes the promised v2 of the ll_transport cleanup.

As I said, I removed patches which need some more work, and kept only the
trivial ones. I also added David's documentation, which gives us a net
difference of +210 lines of code :(
Let's say that we still have a net worth of -106 lines of actual code :)

Cheers,
Benjamin

Changes since v1:
- removed uhid, i2c-hid patches
- removed the previous 11/11 (move hid_output_raw_report to hid_ll_driver)
- hid-logitech-dj: use hid_hw_raw_request instead of hid_output_report (2/9)
- add documentation - I removed the hid_input_event() doc (9/9)

Benjamin Tissoires (9):
  HID: add inliners for ll_driver transport-layer callbacks
  HID: logitech-dj: remove hidinput_input_event
  HID: HIDp: remove hidp_hidinput_event
  HID: remove hidinput_input_event handler
  HID: HIDp: remove duplicated coded
  HID: usbhid: remove duplicated code
  HID: remove hid_get_raw_report in struct hid_device
  HID: introduce helper to access hid_output_raw_report()
  HID: Add HID transport driver documentation

 Documentation/hid/hid-transport.txt | 316 ++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-input.c             |  12 +-
 drivers/hid/hid-lg.c                |   6 +-
 drivers/hid/hid-logitech-dj.c       | 106 +++++-------
 drivers/hid/hid-magicmouse.c        |   2 +-
 drivers/hid/hid-sony.c              |   9 +-
 drivers/hid/hid-thingm.c            |   4 +-
 drivers/hid/hid-wacom.c             |  16 +-
 drivers/hid/hid-wiimote-core.c      |   2 +-
 drivers/hid/hidraw.c                |   9 +-
 drivers/hid/i2c-hid/i2c-hid.c       |   1 -
 drivers/hid/uhid.c                  |   1 -
 drivers/hid/usbhid/hid-core.c       |  65 ++------
 include/linux/hid.h                 |  68 +++++++-
 net/bluetooth/hidp/core.c           | 115 ++-----------
 15 files changed, 471 insertions(+), 261 deletions(-)
 create mode 100644 Documentation/hid/hid-transport.txt

-- 
1.8.3.1

