Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934287Ab3CMU5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:57:38 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:51617 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab3CMU5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:57:37 -0400
Date: Wed, 13 Mar 2013 13:57:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.9-rc2
Message-ID: <20130313205733.GA17480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:

  Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.9-rc2

for you to fetch changes up to 564c526a1bed5e42b5cd52cfe1752c4296ef17a6:

  staging: comedi: dt9812: use CR_CHAN() for channel number (2013-03-11 10:21:05 -0700)

----------------------------------------------------------------
Staging tree fixes for 3.9-rc2

Here are some drivers/staging and drivers/iio fixes for 3.9 (the two are
still pretty intertwined, hence them coming both from my tree still.)
Nothing major, just a few things that have been reported by users, all
of these have been in linux-next for a while.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Denis CIOCCA (1):
      iio:common:st_sensors fixed all warning messages about uninitialized variables

Geert Uytterhoeven (1):
      staging/vt6656: Fix too large integer constant warning on 32-bit

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.9a' of git://git.kernel.org/.../jic23/iio into staging-linus

Guenter Roeck (2):
      iio/imu: inv_mpu6050 depends on IIO_BUFFER
      iio: Fix build error seen if IIO_TRIGGER is defined but IIO_BUFFER is not

Ian Abbott (1):
      staging: comedi: dt9812: use CR_CHAN() for channel number

Kumar Amit Mehta (3):
      staging: comedi: drivers: usbdux.c: fix DMA buffers on stack
      staging: comedi: drivers: usbduxfast.c: fix for DMA buffers on stack
      staging: comedi: drivers: usbduxsigma.c: fix DMA buffers on stack

Lars-Peter Clausen (3):
      iio:ad5064: Fix address of the second channel for ad5065/ad5045/ad5025
      iio:ad5064: Fix off by one in DAC value range check
      iio:ad5064: Initialize register cache correctly

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Philipp Zabel (1):
      staging: imx/drm: request irq only after adding the crtc

 drivers/iio/common/st_sensors/st_sensors_core.c |  9 ++++----
 drivers/iio/dac/ad5064.c                        | 64 +++++++++++++++++++++++++++++++---------------------
 drivers/iio/imu/inv_mpu6050/Kconfig             |  1 +
 drivers/staging/comedi/drivers/dt9812.c         | 16 ++++++++-----
 drivers/staging/comedi/drivers/usbdux.c         | 31 +++++++++++++++----------
 drivers/staging/comedi/drivers/usbduxfast.c     | 30 ++++++++++++++----------
 drivers/staging/comedi/drivers/usbduxsigma.c    | 27 ++++++++++++++--------
 drivers/staging/imx-drm/ipuv3-crtc.c            | 23 ++++++++++---------
 drivers/staging/vt6656/card.c                   |  2 +-
 drivers/staging/vt6656/main_usb.c               |  4 ----
 include/linux/iio/common/st_sensors.h           |  9 +++++---
 11 files changed, 126 insertions(+), 90 deletions(-)
