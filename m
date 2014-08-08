Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbaHHGgO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:36:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46092 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHHGgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:36:10 -0400
Date: Thu, 7 Aug 2014 23:36:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: [git pull] Input updates for 3.17-rc0
Message-ID: <20140808063605.GA8103@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get a bit update to
Wacom driver by Benjamin Tissoires, converting it to HID infrastructure
and unifying USB and Bluetooth models. You will also get a large update
to ALPS driver by Hans de Goede, which adds support for newer touchpad
models as well as cleans up and restructures the code, more changes to
Atmel MXT driver, including device tree support, a new driver for iPaq
x3xxx touchscreen, a driver for serial Wacom tablets, a driver for
Microchip's CAP1106, and assorted cleanups and improvements to existing
drover and input core.

Thanks!

Changelog:
---------

Benjamin Tissoires (35):
      Input: Revert "wacom - testing result shows get_report is unnecessary=
=2E"
      Input: wacom - assign phys field from struct wacom into input_dev
      Input: wacom - create a separate input device for pads
      Input: wacom - split out the pad device for Intuos/Cintiq
      Input: wacom - split out the pad device for Bamboos
      Input: wacom - split out the pad device for DTUS
      Input: wacom - split out the pad device for Graphire G4 and MO
      Input: wacom - split out the pad device for the wireless receiver
      Input: wacom - include and use linux/hid.h
      Input: wacom - switch from an USB driver to a HID driver
      Input: wacom - use hid communication instead of plain usb
      Input: wacom - use HID core to actually fetch the report descriptor
      Input: wacom - compute the HID report size to get the actual packet s=
ize
      Input: wacom - install LED/OLED sysfs files in the HID device instead=
 of USB
      Input: wacom - register the input devices on top of the HID one
      Input: wacom - remove usb dependency for siblings devices
      Input: wacom - register power device at the HID level
      Input: wacom - use hid_info instead of plain dev_info
      Input: wacom - use in-kernel HID parser
      Input: wacom - use hidinput_calc_abs_res instead of duplicating its c=
ode
      Input: wacom - remove field pktlen declaration in the list of devices
      Input: wacom - keep wacom_ids ordered
      Input: wacom - move the USB (now hid) Wacom driver in drivers/hid
      Input: wacom - put a flag when the led are initialized
      Input: wacom - enhance Wireless Receiver battery reporting
      Input: wacom - use a uniq name for the battery device
      Input: wacom - register an ac power supply for wireless devices
      Input: wacom - prepare the driver to include BT devices
      Input: wacom - handle Graphire BT tablets in wacom.ko
      Input: wacom - handle Intuos 4 BT in wacom.ko
      Input: wacom - check for bluetooth protocol while setting OLEDs
      Input: wacom - add copyright note and bump version to 2.0
      Input: HID - remove hid-wacom Bluetooth driver
      Input: wacom - only register once the MODULE_* macros
      Input: wacom - update the ABI doc according to latest changes

Benson Leung (1):
      Input: atmel_mxt_ts - set pointer emulation on touchpads

Daniel Mack (1):
      Input: add driver for Microchip's CAP1106

David Herrmann (2):
      Input: uinput - uinput_validate_absbits() cleanup
      Input: uinput - add UI_GET_VERSION ioctl

Dexuan Cui (1):
      Input: hyperv-keyboard - register as a wakeup source

Dmitry Artamonow (1):
      Input: driver for touchscreen on iPaq h3xxx

Dmitry Torokhov (2):
      Input: ipaq-micro-ts - introduce open/close
      Input: wacom_serial4 - prepare for wacom USB moving to HID

Fabian Frederick (2):
      Input: keyspan_remote - remove unnecessary break after goto
      Input: edt-ft5x06 - remove unnecessary null test

Fabio Estevam (3):
      Input: mcs5000_ts - protect PM functions with CONFIG_PM_SLEEP
      Input: mcs5000_ts - remove ifdef around power management methods
      Input: imx_keypad - remove ifdef round PM methods

Hans de Goede (14):
      Input: add support for Wacom protocol 4 serial tablets
      Input: alps - improve 2-finger reporting on v3 models
      Input: alps - process_bitmap: don't invert the Y-axis on Rushmore
      Input: alps - process_bitmap: add alps_get_bitmap_points() helper fun=
ction
      Input: alps - process_bitmap: fix counting of high point bits
      Input: alps - process_bitmap: round down when spreading adjescent fin=
gers over 2 points
      Input: alps - use struct input_mt_pos to track coordinates
      Input: alps - use standard contact tracking instead of DIY
      Input: alps - use single touch data when v3 mt data contains only one=
 finger
      Input: alps - add an alps_report_semi_mt_data function
      Input: alps - report 2 touches when we've > 2 fingers
      Input: alps - change decode function prototype to return an int
      Input: alps - cache firmware version
      Input: alps - Rushmore and v7 resolution support

Heiko Stuebner (1):
      Input: zforce - add regulator handling

Himangi Saraogi (1):
      Input: max7359 - introduce the use of managed interfaces

Jason Gerecke (2):
      Input: wacom - support up to 2048 pressure levels with ISDv4
      Input: wacom - add support for 0x12C ISDv4 sensor

Nick Dyer (13):
      Input: atmel_mxt_ts - initialise IRQ before probing
      Input: atmel_mxt_ts - move input device init into separate function
      Input: atmel_mxt_ts - download device config using firmware loader
      Input: atmel_mxt_ts - calculate and check CRC in config file
      Input: atmel_mxt_ts - handle APP_CRC_FAIL on startup
      Input: atmel_mxt_ts - handle bootloader previously unlocked
      Input: atmel_mxt_ts - add bootloader addresses for new chips
      Input: atmel_mxt_ts - recover from bootloader on probe
      Input: atmel_mxt_ts - add support for dynamic message size
      Input: atmel_mxt_ts - decode T6 status messages
      Input: atmel_mxt_ts - split message handler into separate functions
      Input: atmel_mxt_ts - implement T44 message handling
      Input: atmel_mxt_ts - use deep sleep mode when stopped

Pramod Gurav (4):
      Input: soc_button_array - add missing memory allocation check
      Input: ads7846 - release resources on failure for clean exit
      Input: jornada720_ts - switch to using managed resources
      Input: jornada720_ts - get rid of space indentation and use tab

Przemo Firszt (1):
      Input: wacom - remove passing id for wacom_set_report

Roger Quadros (5):
      Input: pixcir_i2c_ts - use Type-B Multi-Touch protocol
      Input: pixcir_i2c_ts - support up to 5 fingers and hardware tracking =
IDs
      Input: pixcir_i2c_ts - add device tree support
      ARM: dts: am43x-epos-evm: Update binding for touchscreen size
      ARM: dts: am437x-gp-evm: Update binding for touchscreen size

Stephen Warren (1):
      Input: atmel_mxt_ts - implement device tree support

Vasily Khoruzhick (1):
      Input: s3c2410_ts - fix preparing/enabling clock

Yunkang Tang (2):
      Input: alps - fix rushmore packet decoding
      Input: alps - add support for v7 devices


Diffstat:
--------

 Documentation/ABI/testing/sysfs-driver-wacom       |   70 +-
 .../devicetree/bindings/input/atmel,maxtouch.txt   |   25 +
 .../devicetree/bindings/input/cap1106.txt          |   53 +
 .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |   26 +
 .../bindings/input/touchscreen/zforce_ts.txt       |    4 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 MAINTAINERS                                        |    7 +
 arch/arm/boot/dts/am437x-gp-evm.dts                |    4 +-
 arch/arm/boot/dts/am43x-epos-evm.dts               |    4 +-
 drivers/hid/Kconfig                                |   13 +-
 drivers/hid/Makefile                               |    4 +-
 drivers/hid/hid-core.c                             |   12 +-
 drivers/hid/hid-wacom.c                            |  973 ---------------
 drivers/{input/tablet =3D> hid}/wacom.h              |   27 +-
 drivers/{input/tablet =3D> hid}/wacom_sys.c          | 1229 +++++++++-----=
----
 drivers/{input/tablet =3D> hid}/wacom_wac.c          | 1176 ++++++++++----=
---
 drivers/{input/tablet =3D> hid}/wacom_wac.h          |   22 +-
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/cap1106.c                   |  335 +++++
 drivers/input/keyboard/imx_keypad.c                |    6 +-
 drivers/input/keyboard/max7359_keypad.c            |   45 +-
 drivers/input/misc/keyspan_remote.c                |    1 -
 drivers/input/misc/soc_button_array.c              |    3 +
 drivers/input/misc/uinput.c                        |   47 +-
 drivers/input/mouse/alps.c                         |  691 ++++++----
 drivers/input/mouse/alps.h                         |   60 +-
 drivers/input/serio/hyperv-keyboard.c              |   13 +
 drivers/input/tablet/Kconfig                       |   18 +-
 drivers/input/tablet/Makefile                      |    4 +-
 drivers/input/tablet/wacom_serial4.c               |  620 +++++++++
 drivers/input/touchscreen/Kconfig                  |   12 +
 drivers/input/touchscreen/Makefile                 |    1 +
 drivers/input/touchscreen/ads7846.c                |    6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c           | 1315 +++++++++++++++-=
----
 drivers/input/touchscreen/edt-ft5x06.c             |    3 +-
 drivers/input/touchscreen/ipaq-micro-ts.c          |  166 +++
 drivers/input/touchscreen/jornada720_ts.c          |   70 +-
 drivers/input/touchscreen/mcs5000_ts.c             |    6 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c          |  250 +++-
 drivers/input/touchscreen/s3c2410_ts.c             |    4 +-
 drivers/input/touchscreen/zforce_ts.c              |   31 +
 drivers/platform/chrome/chromeos_laptop.c          |    4 -
 include/linux/hid.h                                |    5 +
 include/linux/i2c/atmel_mxt_ts.h                   |    3 -
 include/linux/input/pixcir_ts.h                    |   12 +
 include/uapi/linux/serio.h                         |    1 +
 include/uapi/linux/uinput.h                        |    9 +
 48 files changed, 4516 insertions(+), 2886 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/atmel,maxtouch.=
txt
 create mode 100644 Documentation/devicetree/bindings/input/cap1106.txt
 create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pix=
cir_i2c_ts.txt
 delete mode 100644 drivers/hid/hid-wacom.c
 rename drivers/{input/tablet =3D> hid}/wacom.h (89%)
 rename drivers/{input/tablet =3D> hid}/wacom_sys.c (51%)
 rename drivers/{input/tablet =3D> hid}/wacom_wac.c (74%)
 rename drivers/{input/tablet =3D> hid}/wacom_wac.h (88%)
 create mode 100644 drivers/input/keyboard/cap1106.c
 create mode 100644 drivers/input/tablet/wacom_serial4.c
 create mode 100644 drivers/input/touchscreen/ipaq-micro-ts.c


--=20
Dmitry


--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5G/VAAoJEH70+W8r6ZYqN9sP/1SzZ2C7yvrXcm/YkSkfZ2jG
p8qxakk5O16Hbrm+ZNZTRyFG+HP7es9WyeZorKEm7TT04icQmMNR451W9LWxr00f
s5zKUZ+2puZBUUt91lKgdGPz44tKBunfh9XCqhZ+skdPcx5UZ2pTtMq8kvn5jNf9
qs8R8+23DiprJ3cBKLrsKdCqW3cOBK2ba6Lpk0WBV2V0dNbYtXlAx/1cKI+Y2l7N
OT2gYHm+tVF92ZWPsmQb5AeZLDGMg3lYJnCZQ0nvKcQIQBzxBIfUzufPzYXi1F6n
Eiw3RLzxEKu8ZrA/O6PVsUasrXne/aesHfNrAEPeO6xG+kBT2vQ28NOK9b5xI7gN
d67S2cve0mHEVraHcHKIC8VA0+s8zY0o6PWQW0ApinPo7tYZhHSurBC+0cx0otzY
HkxybwDbh1XH9+ognzFt1V5nwnL6PsJEA57iSIHNItnMqAO7c+zEbKNBa5wV0nMd
h9ouH7hWPl+vbKSWJdUVnGX9t1oWHhyfWg7OmRCKMaKn+Kti3zsAzHRsTbp0QzoH
DzSg23hqBDdrFgALG+Pu3bxKHt61p2lmxq9kH4vX8tLfiMj4Cln9nZso//FpNNLD
s1ZFY7HV4C/CBedg4XDDbeZqYwhqtafKpw2aoyHGGTNmyjSqPl0WU7b6kvyEaIVU
l7kxl2cjroiE1XBh1na8
=hvux
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
