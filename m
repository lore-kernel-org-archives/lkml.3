Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaDWGGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:06:18 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34814 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaDWGGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:06:15 -0400
Date: Tue, 22 Apr 2014 23:06:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.15-rc2
Message-ID: <20140423060611.GD24854@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

The main change is that we now publish "firmware ID" for the serio
devices to help userspace figure out the kind of touchpads it is dealing
with: i8042 will export PS/2 port's PNP IDs as firmware IDs.

You will also get more quirks for Synaptics touchpads in various Lenovo
laptops, a change to elantech driver to recognize even more models, and
fixups to wacom and couple other drivers.

Changelog:
---------

Adam Thomson (1):
      Input: da9055_onkey - remove use of regmap_irq_get_virq()

Alexander Stein (1):
      Input: ads7846 - fix device usage within attribute show

Hans de Goede (5):
      Input: serio - add firmware_id sysfs attribute
      Input: i8042 - add firmware_id support
      Input: Add INPUT_PROP_TOPBUTTONPAD device property
      Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
      Input: synaptics - add min/max quirk for ThinkPad T431s, L440, L540, =
S1 Yoga and X1

Jason Gerecke (4):
      Input: wacom - use full 32-bit HID Usage value in switch statement
      Input: wacom - override 'pressure_max' with value from HID_USAGE_PRES=
SURE
      Input: wacom - references to 'wacom->data' should use 'unsigned char*'
      Input: wacom - handle 1024 pressure levels in wacom_tpc_pen

Jordan Rife (1):
      Input: elantech - add support for newer elantech touchpads

Lejun Zhu (1):
      Input: soc_button_array - fix a crash during rmmod

Ping Cheng (1):
      Input: wacom - missed the last bit of expresskey for DTU-1031


Diffstat:
--------

 drivers/input/misc/da9055_onkey.c     |   1 -
 drivers/input/misc/soc_button_array.c |   1 +
 drivers/input/mouse/elantech.c        |   1 +
 drivers/input/mouse/synaptics.c       |  97 +++++++++++++-
 drivers/input/serio/i8042-x86ia64io.h |  15 +++
 drivers/input/serio/i8042.c           |   6 +
 drivers/input/serio/serio.c           |  14 ++
 drivers/input/tablet/wacom_sys.c      | 246 ++++++++++++++++--------------=
----
 drivers/input/tablet/wacom_wac.c      |  29 ++--
 drivers/input/touchscreen/ads7846.c   |   2 +-
 include/linux/serio.h                 |   1 +
 include/uapi/linux/input.h            |   1 +
 12 files changed, 263 insertions(+), 151 deletions(-)

--=20
Dmitry


--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTV1hTAAoJEH70+W8r6ZYqccUP/Rl2GomjJ2MNIh2rOLlEtXBG
2j1W4Rrg1eiu6NMNMEwKQFibXA97sBmq04MPXvSDzcUlv7WCW/6HpXFrMKFlhPQo
79Oku+66WnJjVB//G1fONr9WmGCWSIxpQaLyHj3JIrPb4MNoRbxEBncZLTMmSmoE
VyBj5eckkiGZvIpyX4httmFZTI3kWveNWPc2NhNb65HY9+CAkcXL1oBM3hRNbFBR
YiNwGcVZr21J1+0CZsbqRsCJv6h9qkrSWv9AUL16f5jQbRC2VPV4pvwCA9OZ1/kO
X5MQ30qCQiQzqEr/lDBT+KiN3o0DpgWVpQzEho0y2ZwFzFwKGn0v2SO9NNBJnvwP
uoDh0u0gRIVMlRn8J7ly3JmCjJgwW16Nb/lmSri3w6ZA1Kkd5nCF9zTZ1tV49s8M
JXBvkCEJFNnuP1WxNZv42Mi25KH1pT2gp17/yt9QeLQ7adEBwgJNoFWy8pLHmhYP
KOgDzKJQwISQdIYDtj4CWpaMhB3xfF6MtNrEM5Gx49E8+Jk3o6kCJQ8lxCvr6a9j
pfdjEUJwSa2UY0zye+kSY65wMFhS8KpU1y8BbC4p2Abxeeb+jNk3N2RKcK+t00G7
MgZq11a5t+mnYUdNBy2qzEDbq95vklt+LT8kVjQqYgM2m6YGcOCIjj4N3bfL5lEL
yXzojWGh18Aqw9L7weWd
=jN3u
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
