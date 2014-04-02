Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaDBOTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:19:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40808 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbaDBOT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:19:28 -0400
Date: Wed, 2 Apr 2014 16:19:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1404021513280.32122@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following updates for HID layer:



- substantial cleanup of the generic and transport layers, in the 
  direction of an ultimate goal of making struct hid_device completely 
  transport independent, by Benjamin Tissoires
- cp2112 driver from David Barksdale
- a lot of fixes and new hardware support (Dualshock 4) to hid-sony 
  driver, by Frank Praznik
- support for Win 8.1 multitouch protocol by Andrew Duggan
- other smaller fixes / device ID additions



Andrew Duggan (1):
      HID: multitouch: add support for Win 8.1 multitouch touchpads

Benjamin Tissoires (29):
      HID: add inliners for ll_driver transport-layer callbacks
      HID: logitech-dj: remove hidinput_input_event
      HID: HIDp: remove hidp_hidinput_event
      HID: remove hidinput_input_event handler
      HID: HIDp: remove duplicated coded
      HID: usbhid: remove duplicated code
      HID: remove hid_get_raw_report in struct hid_device
      HID: introduce helper to access hid_output_raw_report()
      HID: Add HID transport driver documentation
      HID: uHID: remove duplicated code
      HID: uHID: implement .raw_request
      HID: core: implement generic .request()
      HID: i2c-hid: implement ll_driver transport-layer callbacks
      HID: i2c-hid: use generic .request() implementation
      HID: usbhid: change return error of usbhid_output_report
      HID: logitech-dj: remove hid_output_raw_report call
      HID: replace hid_output_raw_report with hid_hw_raw_request for feature requests
      HID: wiimote: replace hid_output_raw_report with hid_hw_output_report for output requests
      HID: core: check parameters when sending/receiving data from the device
      HID: input: hid-input remove hid_output_raw_report call
      HID: make .raw_request mandatory
      HID: hidraw: replace hid_output_raw_report() calls by appropriates ones
      HID: multitouch: remove registered devices with default behavior
      HID: multitouch: remove pen special handling
      HID: multitouch: add support of other generic collections in hid-mt
      HID: cp2112: remove various hid_out_raw_report calls
      HID: cp2112: remove the last hid_output_raw_report() call
      HID: sony: do not rely on hid_output_raw_report
      HID: remove hid_output_raw_report transport implementations

David Barksdale (1):
      HID: add hid-cp2112 driver

Frank Praznik (22):
      HID: sony: add battery status reporting for the Sixaxis and Dualshock 4
      HID: sony: add output events for the multi-touch pad on the Dualshock 4
      HID: Add transport-driver callbacks to the hid_ll_driver struct
      HID: Add transport-driver functions to the USB HID interface.
      HID: Add the transport-driver function to the uhid driver
      HID: Add the transport-driver functions to the HIDP driver.
      HID: Kconfig updates for the Sony module
      HID: sony: Use low-level transport driver functions
      HID: sony: Add modified Dualshock 4 Bluetooth HID descriptor
      HID: sony: Add Dualshock 4 Bluetooth output report formatting
      HID: sony: Add Dualshock 4 Bluetooth battery and touchpad parsing
      HID: sony: Set initial battery level to 100% to avoid false low battery warnings
      HID: sony: Add conditionals to enable all features in Bluetooth mode
      HID: sony: Correct Sixaxis battery reporting
      HID: sony: Enable LED controls and rumble for the Sixaxis on Bluetooth.
      HID: sony: Fix multi-line comment styling
      HID: sony: Fix work queue issues
      HID: sony: Perform a boundry check on the sixaxis battery level index.
      HID: sony: Prevent duplicate controller connections.
      HID: hidp: Add a comment that some devices depend on the current behavior of uniq
      HID: sony: Fix Sixaxis cable state detection
      HID: sony: Set the quriks flag for Bluetooth controllers

Hans de Goede (4):
      HID: Add some missing HUT mappings
      HID: hid-microsoft: Do the check for the ms usage page per device
      HID: hid-microsoft: Add support for scrollwheel and special keypad keys
      HID: hid-microsoft: Add support for 2 reserved usage ids used on ms office kb

Jiri Kosina (10):
      HID: sony: fix build wrt. power_supply
      HID: uhid: remove uhid_hid_get_raw()
      HID: uhid: reintroduce uhid_hid_get_raw()
      HID: cp2112: make sysfs attributes static
      HID: cp2112: use proper specifier for size_t
      HID: cp2112: convert to use hid_hw_raw_request()
      HID: cp2112: can't be used without gpio support
      HID: cp2112: fix incorrect error propagation in cp2112_xfer()
      HID: hyperv: fix _raw_request() prototype
      HID: sony: fix force feedback mismerge

K. Y. Srinivasan (1):
      HID: hyperv: Implement a stub raw_request() entry point

Mika Westerberg (1):
      HID: i2c-hid: add runtime PM support

Petri Gynther (1):
      HID: uhid: Add UHID_CREATE2 + UHID_INPUT2

Simon Wood (1):
      HID: hid-sony: report actual brightness value when reading LED

Srinivas Pandruvada (4):
      HID: hid-sensor-hub: Add selector api
      iio: hid-sensor-hub: Remove hard coded indexes
      HID: hid-sensor-hub: Processing for duplicate physical ids
      HID: hid-sensor-hub: fix sleeping function called from invalid context

 Documentation/hid/hid-transport.txt                |  317 ++++++
 Documentation/hid/uhid.txt                         |   11 +
 drivers/hid/Kconfig                                |   19 +-
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-core.c                             |   52 +-
 drivers/hid/hid-cp2112.c                           | 1073 ++++++++++++++++++++
 drivers/hid/hid-hyperv.c                           |   10 +
 drivers/hid/hid-ids.h                              |    5 +
 drivers/hid/hid-input.c                            |   21 +-
 drivers/hid/hid-lg.c                               |    6 +-
 drivers/hid/hid-logitech-dj.c                      |  111 +--
 drivers/hid/hid-magicmouse.c                       |    4 +-
 drivers/hid/hid-microsoft.c                        |   74 ++-
 drivers/hid/hid-multitouch.c                       |  281 ++----
 drivers/hid/hid-sensor-hub.c                       |  217 +++--
 drivers/hid/hid-sony.c                             |  808 +++++++++++++--
 drivers/hid/hid-thingm.c                           |    4 +-
 drivers/hid/hid-wacom.c                            |   28 +-
 drivers/hid/hid-wiimote-core.c                     |    4 +-
 drivers/hid/hidraw.c                               |   27 +-
 drivers/hid/i2c-hid/i2c-hid.c                      |  139 ++-
 drivers/hid/uhid.c                                 |  103 ++-
 drivers/hid/usbhid/hid-core.c                      |  102 ++-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |   39 +-
 include/linux/hid-sensor-hub.h                     |    9 +-
 include/linux/hid-sensor-ids.h                     |   16 +-
 include/linux/hid.h                                |   76 ++-
 include/uapi/linux/uhid.h                          |   23 +
 net/bluetooth/hidp/core.c                          |  100 +-
 29 files changed, 3022 insertions(+), 658 deletions(-)
 create mode 100644 Documentation/hid/hid-transport.txt
 create mode 100644 drivers/hid/hid-cp2112.c

-- 
Jiri Kosina
SUSE Labs
