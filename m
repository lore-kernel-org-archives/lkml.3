Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab3IFMAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:00:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3IFMAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:00:39 -0400
Date: Fri, 6 Sep 2013 14:00:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID for 3.12 merge window
Message-ID: <alpine.LNX.2.00.1309061202050.26934@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID updates for 3.12 merge window. Highlights:

- conversion of HID subsystem to use devm-based resource management, from 
  Benjamin Tissoires

- i2c-hid support for DT bindings, from Benjamin Tissoires

- much improved support for Win8-multitouch devices, from Benjamin 
  Tissoires

- cleanup of core code using common hidinput_input_event(), from David 
  Herrmann

- fix for bug in implement() access to the bit stream (causing oops) that 
  has been present in the code for ages, but devices that are able to 
  trigger it have started to appear only now, from Jiri Kosina

- fixes for CVE-2013-2899, CVE-2013-2898, CVE-2013-2896, CVE-2013-2892, 
  CVE-2013-2888 (all triggerable only by specially crafted malicious HW 
  devices plugged into the system), from Kees Cook

- hidraw oops fix, from Manoj Chourasia

- various smaller fixes here and there, support for a bunch of new devices 
  by various contributors

Thanks.

Andy Shevchenko (7):
      HID: i2c-hid: don't push static constants on stack for %*ph
      HID: hid-holtekff: don't push static constants on stack for %*ph
      HID: hid-sensor-hub: fix style of comments
      HID: hid-wiimote: print small buffers via %*phC
      HID: hid-sensor-hub: fix indentation accross the code
      HID: hid-sensor-hub: move to devm_kzalloc
      HID: hid-sensor-hub: change kmalloc + memcpy by kmemdup

Benjamin Tissoires (8):
      HID: logitech-dj: use inlined helpers hid_hw_open/close
      HID: kye: Add report fixup for Genius Gx Imperator Keyboard
      HID: trivial devm conversion for special hid drivers
      HID: multitouch: devm conversion
      HID: i2c-hid: add DT bindings
      HID: Use hid_parser for pre-scanning the report descriptors
      HID: detect Win 8 multitouch devices in core
      HID: do not init input reports for Win 8 multitouch devices

Bruno Prémont (1):
      HID: picolcd: Prevent NULL pointer dereference on _remove()

David Herrmann (12):
      HID: usbhid: make usbhid_set_leds() static
      HID: usbhid: update LED fields unlocked
      HID: usbhid: use generic hidinput_input_event()
      HID: i2c: use generic hidinput_input_event()
      HID: uhid: use generic hidinput_input_event()
      HID: input: generic hidinput_input_event handler
      HID: wiimote: work around broken DRM_KAI on GEN10
      input: document gamepad API and add extra keycodes
      Input: introduce BTN/ABS bits for drums and guitars
      HID: wiimote: add support for Guitar-Hero drums
      HID: uhid: improve uhid example client
      HID: move HID_REPORT_TYPES closer to the report-definitions

Henrik Rydberg (1):
      HID: Correct the USB IDs for the new Macbook Air 6

Jingoo Han (1):
      HID: replace strict_strtoul() with kstrtoul()

Jiri Kosina (3):
      HID: fix data access in implement()
      HID: fix unused rsize usage
      HID: battery: don't do DMA from stack

Kees Cook (6):
      HID: validate HID report id size
      HID: pantherlord: validate output report details
      HID: ntrig: validate feature report details
      HID: sensor-hub: validate feature report details
      HID: picolcd_core: validate output report details
      HID: check for NULL field when setting values

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Marcel Holtmann (1):
      HID: uhid: add devname module alias

Mika Westerberg (1):
      HID: i2c-hid: use correct type for ACPI _DSM parameter

Nicolas Adenis-Lamarre (1):
      HID: wiimote: add support for Guitar-Hero guitars

Olivier Scherler (1):
      HID: Add new driver for non-compliant Xin-Mo devices.

Paul Chavent (1):
      HID: core: fix hid delimiter local tag parsing.

Paul Gortmaker (1):
      HID: samples/hidraw: add .gitignore file

Peter Hurley (1):
      HID: logitech-dj: Fix non-atomic kmalloc in logi_dj_ll_input_event()

Stefan Achatz (2):
      HID: roccat: add support for KonePureOptical v2
      HID: MAINTAINERS: add roccat drivers

Stefan Kriwanek (1):
      HID: Fix Speedlink VAD Cezanne support for some devices

Vasily Titskiy (1):
      HID: usbhid: quirk for N-Trig DuoSense Touch Screen

Wei Yongjun (1):
      HID: use module_hid_driver() to simplify the code

Yonghua Zheng (1):
      HID: hidraw: Add spinlock in struct hidraw to protect list

 .../devicetree/bindings/hid/hid-over-i2c.txt       |   28 ++
 Documentation/hid/uhid.txt                         |    4 +-
 Documentation/input/gamepad.txt                    |  156 ++++++++
 MAINTAINERS                                        |    8 +
 drivers/hid/Kconfig                                |    8 +
 drivers/hid/Makefile                               |    1 +
 drivers/hid/hid-a4tech.c                           |   21 +-
 drivers/hid/hid-apple.c                            |   16 +-
 drivers/hid/hid-core.c                             |  159 ++++++---
 drivers/hid/hid-holtekff.c                         |    2 +-
 drivers/hid/hid-ids.h                              |   12 +-
 drivers/hid/hid-input.c                            |   92 +++++-
 drivers/hid/hid-kye.c                              |   45 ++-
 drivers/hid/hid-logitech-dj.c                      |   22 +-
 drivers/hid/hid-magicmouse.c                       |   19 +-
 drivers/hid/hid-multitouch.c                       |  107 +++---
 drivers/hid/hid-ntrig.c                            |   15 +-
 drivers/hid/hid-picolcd_cir.c                      |    3 +-
 drivers/hid/hid-picolcd_core.c                     |    2 +-
 drivers/hid/hid-picolcd_debugfs.c                  |   23 +-
 drivers/hid/hid-picolcd_fb.c                       |    6 +-
 drivers/hid/hid-pl.c                               |   10 +-
 drivers/hid/hid-roccat-arvo.c                      |    6 +-
 drivers/hid/hid-roccat-isku.c                      |    2 +-
 drivers/hid/hid-roccat-kone.c                      |    4 +-
 drivers/hid/hid-roccat-koneplus.c                  |    2 +-
 drivers/hid/hid-roccat-konepure.c                  |    3 +-
 drivers/hid/hid-roccat-kovaplus.c                  |    2 +-
 drivers/hid/hid-sensor-hub.c                       |   58 ++--
 drivers/hid/hid-sony.c                             |    9 +-
 drivers/hid/hid-speedlink.c                        |   11 +-
 drivers/hid/hid-wiimote-core.c                     |   41 ++-
 drivers/hid/hid-wiimote-modules.c                  |  392 ++++++++++++++++++++
 drivers/hid/hid-wiimote.h                          |    3 +
 drivers/hid/hid-xinmo.c                            |   61 +++
 drivers/hid/hid-zydacron.c                         |   19 +-
 drivers/hid/hidraw.c                               |   80 ++--
 drivers/hid/i2c-hid/i2c-hid.c                      |   77 +++--
 drivers/hid/uhid.c                                 |   26 +--
 drivers/hid/usbhid/hid-core.c                      |   83 +----
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/hid/usbhid/usbhid.h                        |    3 -
 drivers/input/mouse/bcm5974.c                      |    6 +-
 include/linux/hid-sensor-hub.h                     |    2 +-
 include/linux/hid-sensor-ids.h                     |    2 +-
 include/linux/hid.h                                |   16 +-
 include/linux/hidraw.h                             |    1 +
 include/linux/i2c/i2c-hid.h                        |    3 +-
 include/linux/mod_devicetable.h                    |    2 +-
 include/uapi/linux/input.h                         |   25 ++-
 include/uapi/linux/uhid.h                          |    4 +-
 net/bluetooth/hidp/core.c                          |   15 +-
 samples/hidraw/.gitignore                          |    1 +
 samples/uhid/uhid-example.c                        |  123 +++++-
 54 files changed, 1351 insertions(+), 492 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hid/hid-over-i2c.txt
 create mode 100644 Documentation/input/gamepad.txt
 create mode 100644 drivers/hid/hid-xinmo.c
 create mode 100644 samples/hidraw/.gitignore

-- 
Jiri Kosina
SUSE Labs
