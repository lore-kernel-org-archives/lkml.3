Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab3KOXXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:23:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937Ab3KOXWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:22:54 -0500
Date: Sat, 16 Nov 2013 00:22:51 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.1311160014150.6919@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive

- i2c-hid is not querying init reports any more, as it's not mandated by 
  the spec, and annoys quite a few devices during enumeration, by Bibek 
  Basu
- a lot of fixes for Logitech devices, by Simon Wood
- hid-apple now has an option to switch between Option and Command mode, 
  by Nanno Langstraat
- Some more workarounds for severely broken ELO devices, by Oliver Neukum
- more devm conversions, by Benjamin Tissoires
- wiimote correctness fixes, by David Herrmann
- a lot of added support for various new device IDs and random small fixes 
  here and there

Thanks.


Anders F. U. Kiær (1):
      HID: add support for LEETGION Hellion Gaming Mouse

Benjamin Tissoires (3):
      HID: lenovo-tpkbd: devm conversion
      HID: lenovo-tpkbd: remove usb dependency
      HID: sony: use hid_get_raw_report() instead of a direct call to usb

Bibek Basu (1):
      HID: i2c-hid: Stop querying for init reports

Dan Carpenter (1):
      HID: logitech-dj: small cleanup in rdcat()

David Herrmann (2):
      HID: wiimote: fix inverted pro-controller axes
      HID: wiimote: add pro-controller analog stick calibration

Elias Vanderstuyft (1):
      HID: logitech - lg2ff: Add IDs for Formula Vibration Feedback Wheel

Felix Rueegg (1):
      HID: remove self-assignment from hid_input_report

Forest Bond (3):
      HID: hid-multitouch: add support for SiS panels
      HID: don't ignore eGalax/D-Wav/EETI HIDs
      Input: usbtouchscreen: ignore eGalax/D-Wav/EETI HIDs

Jan Matějka (1):
      HID: multitouch: add manufacturer to Kconfig help text

Jiri Kosina (2):
      HID: apple: swap_opt_cmd is already zero-initialized
      Merge branches 'for-3.12/upstream-fixes', 'for-3.13/holtek', 'for-3.13/i2c-hid', 'for-3.13/logitech', 'for-3.13/multitouch', 'for-3.13/roccat', 'for-3.13/upstream' and 'for-3.13/wiimote' into for-linus

Luosong (1):
      HID: multitouch: Fix GeneralTouch products and add more PIDs

Nanno Langstraat (1):
      HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag") keys.

Oliver Neukum (1):
      HID: hid-elo: some systems cannot stomach work around

Simon Wood (8):
      HID: lg: fix ReportDescriptor for Logitech Formula Vibration
      HID: lg: fix Report Descriptor for Logitech MOMO Force (Black)
      HID: Correct Kconfig MOMO description
      HID:hid-lg4ff: Scale autocentering force properly on Logitech wheel
      HID:hid-lg4ff: Switch autocentering off when strength is set to zero.
      HID:hid-lg4ff: ensure ConstantForce is disabled when set to 0
      HID:hid-lg4ff: Initialize device properties before we touch autocentering.
      HID:hid-lg4ff: Correct Auto-center strength for wheels other than MOMO and MOMO2

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: fix report size

Stefan Achatz (5):
      HID: roccat: add new device return value
      HID: roccat: generalize some common code
      HID: roccat: add support for Ryos MK keyboards
      HID: roccat: fix Coverity CID 141438
      HID: roccat: add missing special driver declarations

Sven Eckelmann (1):
      HID: sony: Add force feedback support for Dualshock3 USB

Tristan Rice (1):
      HID: enable Mayflash USB Gamecube Adapter

 .../ABI/testing/sysfs-driver-hid-roccat-ryos       |  178 +++++++++++++++
 Documentation/ABI/testing/sysfs-driver-hid-wiimote |   18 ++
 drivers/hid/Kconfig                                |   22 ++-
 drivers/hid/Makefile                               |    2 +-
 drivers/hid/hid-apple.c                            |   22 ++
 drivers/hid/hid-axff.c                             |    3 +-
 drivers/hid/hid-core.c                             |   25 +-
 drivers/hid/hid-elo.c                              |   35 +++-
 drivers/hid/hid-holtek-mouse.c                     |    4 +
 drivers/hid/hid-ids.h                              |   16 ++-
 drivers/hid/hid-lenovo-tpkbd.c                     |   50 ++---
 drivers/hid/hid-lg.c                               |  138 +++++++++++
 drivers/hid/hid-lg2ff.c                            |    2 +-
 drivers/hid/hid-lg4ff.c                            |  101 +++++++--
 drivers/hid/hid-logitech-dj.c                      |   14 +-
 drivers/hid/hid-multitouch.c                       |   27 ++-
 drivers/hid/hid-roccat-common.c                    |   65 +++++-
 drivers/hid/hid-roccat-common.h                    |   62 +++++
 drivers/hid/hid-roccat-konepure.c                  |  158 +++----------
 drivers/hid/hid-roccat-konepure.h                  |   72 ------
 drivers/hid/hid-roccat-kovaplus.c                  |    4 +
 drivers/hid/hid-roccat-ryos.c                      |  241 ++++++++++++++++++++
 drivers/hid/hid-roccat-savu.c                      |  123 ++---------
 drivers/hid/hid-roccat-savu.h                      |   32 ---
 drivers/hid/hid-sensor-hub.c                       |   13 +-
 drivers/hid/hid-sony.c                             |   63 +++++-
 drivers/hid/hid-wiimote-modules.c                  |  117 +++++++++-
 drivers/hid/hid-wiimote.h                          |    2 +
 drivers/hid/i2c-hid/i2c-hid.c                      |    4 -
 drivers/hid/usbhid/hid-quirks.c                    |    2 +
 drivers/input/touchscreen/usbtouchscreen.c         |    4 +-
 31 files changed, 1168 insertions(+), 451 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-roccat-ryos
 delete mode 100644 drivers/hid/hid-roccat-konepure.h
 create mode 100644 drivers/hid/hid-roccat-ryos.c

-- 
Jiri Kosina
SUSE Labs
