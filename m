Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916AbaLLKmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 05:42:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932345AbaLLKmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 05:42:11 -0500
Date: Fri, 12 Dec 2014 11:42:09 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] HID
Message-ID: <alpine.LNX.2.00.1412121117360.6575@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID updates for 3.19:

=====
- i2c-hid race condition fix from Jean-Baptiste Maneyrol
- Logitech driver now supports vendor-specific HID++ protocol, allowing us
  to deliver a full multitouch support on wider range of Logitech 
  touchpads. Written by Benjamin Tissoires
- MS Surface Pro 3 Type Cover support added by Alan Wu
- RMI touchpad support improvements from Andrew Duggan
- a lot of updates to Wacom driver from Jason Gerecke and Ping Cheng
- various small fixes all over the place
=====

Thanks.

----------------------------------------------------------------

Alan Wu (1):
      HID: add support for MS Surface Pro 3 Type Cover

Andrew Duggan (2):
      HID: rmi: Check for additional ACM registers appended to F11 data report
      HID: rmi: The address of query8 must be calculated based on which query registers are present

Benjamin Tissoires (18):
      HID: fix merge from wacom into the HID tree
      HID: core: do not scan reports if the group is already set
      HID: logitech-dj: rely on hid groups to separate receivers from dj devices
      HID: logitech-dj: merge header file into the source
      HID: Introduce hidpp, a module to handle Logitech hid++ devices
      HID: logitech: move dj devices to the HID++ module
      HID: logitech-dj: allow transfer of HID++ reports from/to the correct dj device
      HID: logitech: allow the DJ device to request the unifying name
      HID: logitech-dj: enable notifications on connect/disconnect
      HID: logitech-hidpp: late bind the input device on wireless connection
      HID: logitech-hidpp: Add Wireless Touchpad T650 support
      HID: logitech-hidpp: add support of the first Logitech Wireless Touchpad
      HID: logitech-hidpp: support combo keyboard touchpad TK820
      HID: usbhid: prevent unwanted events to be sent when re-opening the device
      HID: logitech-hidpp: fix negated returns
      HID: logitech-hidpp: 2 fixes in hidpp_root_get_protocol_version()
      HID: wacom: re-add accidentally dropped Lenovo PID
      HID: wacom: fix freeze on open when autosuspend is on

Dan Carpenter (1):
      HID: logitech-hidpp: leaks and NULL dereferences

Frank Praznik (2):
      HID: sony: Use kernel allocated buffers for HID reports
      HID: sony: Add support for the third-party SMK PS3 Bluetooth Remote

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Hans Duedal (1):
      HID: roccat: Fix code style issues

Hans de Goede (1):
      HID: input: Map unknown consumer page codes to KEY_UNKNOWN

JD Cole (2):
      HID: plantronics: fix errant mouse events
      HID: added missing HID Consumer Page identifiers

Jamie Lentin (2):
      HID: lenovo: Move USB KEY_FILE to 0x00f9 to prevent scancode clash
      HID: lenovo: Don't set EV_REP to avoid repeating mice buttons

Jason Gerecke (5):
      HID: wacom: Report ABS_TILT_{X,Y} as signed values
      HID: wacom: Add angular resolution data to some ABS axes
      HID: wacom: Consult the application usage when determining field type
      HID: wacom: Initialize MT slots for generic devices at post_parse_hid
      HID: wacom: Report input events for each finger on generic devices

Jean-Baptiste Maneyrol (2):
      HID: i2c-hid: print the correct data in dbg msg
      HID: i2c-hid: fix race condition reading reports

Jiri Kosina (1):
      HID: plantronics: remove superfluous .probe()

Mathieu Magnaudet (2):
      HID: multitouch: Add quirk for VTL touch panels
      HID: make hid_report_len as a static inline function in hid.h

Oliver Neukum (1):
      HID: yet another buggy ELAN touchscreen

Peter Wu (4):
      HID: logitech-hidpp: do not return the name length
      HID: logitech-hidpp: check name retrieval return code
      HID: logitech-hidpp: add boundary check for name retrieval
      HID: logitech-hidpp: disable io in probe error path

Ping Cheng (9):
      HID: wacom - make sure touch_input is valid before using it
      HID: wacom: Add support for Intuos Pen Medium
      HID: wacom - return ENODEV for failed wacom_setup_pad_input_capabilities
      HID: wacom - Cleanup input_capabilities for Graphire 4 and Bamboo Fun
      HID: wacom - Bamboo pen-only tablet does not support PAD
      HID: wacom: PAD is independent with pen/touch
      HID: wacom: add defines for new Cintiq and DTU outbound tracking
      HID: wacom: Add support for DTU-1031X
      HID: wacom: Update maximum X/Y accounding to outbound offset

Ville Aakko (1):
      HID: saitek: quirk for Saitek R.A.T.7 works with R.A.T.9 too

 drivers/hid/Kconfig              |   22 +-
 drivers/hid/Makefile             |    2 +
 drivers/hid/hid-core.c           |   36 +-
 drivers/hid/hid-ids.h            |   12 +
 drivers/hid/hid-input.c          |    4 +-
 drivers/hid/hid-lenovo.c         |   13 +-
 drivers/hid/hid-logitech-dj.c    |  397 +++++++++---
 drivers/hid/hid-logitech-dj.h    |  125 ----
 drivers/hid/hid-logitech-hidpp.c | 1241 ++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-microsoft.c      |    2 +
 drivers/hid/hid-multitouch.c     |   27 +
 drivers/hid/hid-plantronics.c    |   55 ++
 drivers/hid/hid-rmi.c            |   83 ++-
 drivers/hid/hid-roccat-kone.c    |    9 +-
 drivers/hid/hid-saitek.c         |    4 +-
 drivers/hid/hid-sony.c           |  150 +++--
 drivers/hid/i2c-hid/i2c-hid.c    |   16 +-
 drivers/hid/usbhid/hid-core.c    |   39 +-
 drivers/hid/usbhid/hid-quirks.c  |    2 +
 drivers/hid/usbhid/usbhid.h      |    1 +
 drivers/hid/wacom.h              |    2 +-
 drivers/hid/wacom_sys.c          |   68 ++-
 drivers/hid/wacom_wac.c          |  216 ++++---
 drivers/hid/wacom_wac.h          |    3 +
 drivers/usb/core/quirks.c        |    3 +
 include/linux/hid.h              |   43 +-
 26 files changed, 2141 insertions(+), 434 deletions(-)
 delete mode 100644 drivers/hid/hid-logitech-dj.h
 create mode 100644 drivers/hid/hid-logitech-hidpp.c
 create mode 100644 drivers/hid/hid-plantronics.c

-- 
Jiri Kosina
SUSE Labs
