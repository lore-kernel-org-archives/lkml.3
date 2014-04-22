Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbaDVNq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:46:28 -0400
Received: from transparentnimenzy.cz ([31.31.77.140]:49375 "EHLO
	smtp.devoid-pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088AbaDVNqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:46:20 -0400
From: =?UTF-8?q?Michal=20Mal=C3=BD?= <madcatxster@devoid-pointer.net>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: [PATCH v2 00/24] input: Introduce ff-memless-next as an improved replacement for ff-memless
Date: Tue, 22 Apr 2014 15:45:50 +0200
Message-Id: <1398174374-9501-1-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: git-send-email 1.9.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ff-memless-next (MLNX) is a largely improved version of the current ff-memless
(FFML) driver. MLNX supports all force feedback effects currently available in
the Linux force feedback userspace API. All effects are handled in accordance
with Microsoft's DirectInput/XInput. Most notable changes include support for
conditional effects, proper handling of all periodic waveforms and improved
emulation of rumble effects through periodic effects. MLNX also uses its own
kernel API to pass processed effects to hardware-specific drivers instead of
abusing "ff_effect" struct. The API is documented in the respective header
file.

MLNX has been expanded to be a direct replacement for FFML.

Support for FF_PERIODIC and FF_RAMP has been added to all devices that
support FF_CONSTANT as a part of the port to the new API.

This patch series:
1) Adds "ff-memless-next" module [1]
2) Ports all hardware-specific drivers to MLNX's API [2-23]
3) Removes FFML and replaces it with MLNX [24]

Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>

v2:
 - Add missing msecs to jiffies conversion in ff-memless-next
 - lgff: Properly convert force on Y axis from MLNX to device range
         Support periodic effects for "joystick_ac" device class
 - lg3ff: Properly convert forces from MLNX to device range
 - Very minor coding style issues fixed

Michal Malý (24):
  Add ff-memless-next module
  Port arizona-haptics to ff-memless-next
  Port twl4030-vibra to ff-memless-next
  Port twl6040-vibra to ff-memless-next
  Port max8997_haptic to ff-memless-next
  Port pm8xxx-vibrator to ff-memless-next
  Port hid-axff to ff-memless-next
  Port hid-emsff to ff-memless-next
  Port hid-dr to ff-memless-next
  Port hid-gaff to ff-memless-next
  Port hid-holtekff to ff-memless-next
  Port hid-lgff to ff-memless-next
  Port hid-lg3ff to ff-memless-next
  Port hid-pl to ff-memless-next
  Port hid-sjoy to ff-memless-next
  Port hid-sony to ff-memless-next
  Port hid-tmff to ff-memless-next
  Port hid-wiimote-modules to ff-memless-next
  Port hid-zpff to ff-memless-next
  Port gamecon to ff-memless-next
  Port xpad to ff-memless-next
  Port hid-lg4ff to ff-memless-next
  Replace ff-memless with ff-memless-next

 drivers/hid/Kconfig                   |   30 +-
 drivers/hid/hid-axff.c                |   32 +-
 drivers/hid/hid-dr.c                  |   59 +-
 drivers/hid/hid-emsff.c               |   38 +-
 drivers/hid/hid-gaff.c                |   32 +-
 drivers/hid/hid-holtekff.c            |   47 +-
 drivers/hid/hid-lg2ff.c               |   65 ++-
 drivers/hid/hid-lg3ff.c               |   60 +-
 drivers/hid/hid-lg4ff.c               |   93 +--
 drivers/hid/hid-lgff.c                |   70 ++-
 drivers/hid/hid-pl.c                  |   38 +-
 drivers/hid/hid-sjoy.c                |   35 +-
 drivers/hid/hid-sony.c                |   24 +-
 drivers/hid/hid-tmff.c                |   83 +--
 drivers/hid/hid-wiimote-modules.c     |   74 ++-
 drivers/hid/hid-zpff.c                |   30 +-
 drivers/input/Kconfig                 |    4 +-
 drivers/input/Makefile                |    2 +-
 drivers/input/ff-memless-next.c       | 1037 +++++++++++++++++++++++++++++++++
 drivers/input/ff-memless.c            |  547 -----------------
 drivers/input/joystick/Kconfig        |    4 +-
 drivers/input/joystick/gamecon.c      |   57 +-
 drivers/input/joystick/xpad.c         |  125 ++--
 drivers/input/misc/Kconfig            |   10 +-
 drivers/input/misc/arizona-haptics.c  |   39 +-
 drivers/input/misc/max8997_haptic.c   |   25 +-
 drivers/input/misc/pm8xxx-vibrator.c  |   28 +-
 drivers/input/misc/twl4030-vibra.c    |   31 +-
 drivers/input/misc/twl6040-vibra.c    |   27 +-
 include/linux/input.h                 |    3 -
 include/linux/input/ff-memless-next.h |  149 +++++
 31 files changed, 1939 insertions(+), 959 deletions(-)
 create mode 100644 drivers/input/ff-memless-next.c
 delete mode 100644 drivers/input/ff-memless.c
 create mode 100644 include/linux/input/ff-memless-next.h

-- 
1.9.2

