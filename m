Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab3ANFDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 00:03:13 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:42116 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab3ANFDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 00:03:11 -0500
Date: Sun, 13 Jan 2013 21:04:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver patches for 3.8-rc3
Message-ID: <20130114050400.GA8587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:

  Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.8-rc3

for you to fetch changes up to 397c60668aa5ae7130b5ad4e73870d7b8a787085:

  staging: zram: fix invalid memory references during disk write (2013-01-13 19:40:02 -0800)

----------------------------------------------------------------
Staging fixes for 3.8-rc3

Here are a number of small fixes to staging drivers for your 3.8-rc3
tree.

Well, the omapdrm fixes aren't really "small" but they were waiting on a
number of other drm patches to go in through the drm tree, and got
delayed by my vacation over the holidays.  They are totally
self-contained, everyone involved have acked them, and they fix issues
that people have been having with the driver.

Other than that one, it's a bunch of tiny bugfixes for a number of
reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alexander Holler (1):
      iio: hid-sensors: respect CONFIG_IIO_TRIGGER

Axel Lin (7):
      iio: adc: ad7266: Don't set error code to st->vref_uv
      iio: dac: ad5380: Don't set error code to st->vref
      iio: dac: ad5791: Don't set error code to [pos|neg]_voltage_uv
      iio: dac: ad5504: Don't set error code to voltage_uv
      iio: dac: ad5624r_spi: Don't set error code to voltage_uv
      iio: dac: ad5686: Don't set error code to voltage_uv
      iio: dac: ad5446: Don't set error code to voltage_uv

Emil Goode (1):
      Staging: wlan-ng: Add missing argument

Enric Balletbo i Serra (1):
      staging: tidspbridge: Fix build breakage due to splitting CM functions.

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.8a' of git://git.kernel.org/.../jic23/iio into staging-linus

Guenter Roeck (1):
      iio: (max1363) Fix probe error path

Ian Abbott (3):
      staging: comedi: prevent auto-unconfig of manually configured devices
      staging: comedi: Kconfig: COMEDI_NI_AT_A2150 should select COMEDI_FC
      staging: comedi: comedi_test: fix race when cancelling command

Jean-Christophe PLAGNIOL-VILLARD (1):
      iio: at91: fix dev var name in at91_adc_trigger_handler

Konstantin Khlebnikov (1):
      staging: vme_pio2: fix oops on module unloading

Larry Finger (3):
      staging: r8712u: Add new device ID
      staging: rtl8187se: Fix failure to check pci_map_single()
      staging: rtl8192e: Fix failure to check pci_map_single()

Lars-Peter Clausen (1):
      staging:iio:adis16260: Select adislib

Lothar Waﬂmann (3):
      staging: drm/imx: check return value of ipu_reset()
      staging: drm/imx: several bug fixes
      staging: drm/imx: fix double free bug in error path

Michael Hennerich (1):
      iio:adf4350: Fix typo

Nickolai Zeldovich (1):
      staging: speakup: avoid out-of-range access in synth_init()

Nitin Gupta (1):
      staging: zram: fix invalid memory references during disk write

Omar Ramirez Luna (1):
      staging: tidspbridge: use prepare/unprepare on dsp clocks

Peter Hurley (3):
      staging/fwserial: Refine Kconfig help text
      staging/fwserial: Limit tx/rx to 1394-2008 spec maximum
      staging/fwserial: Update TODO file per reviewer comments

Rob Clark (2):
      staging: drm/omap: use omapdss low level API
      staging: drm/omap: fix flags in dma buf exporting

Samuel Thibault (1):
      staging: speakup: avoid out-of-range access in synth_add()

Steven Rostedt (2):
      staging: Make SystemBase PCI Multiport UART only for x86
      staging: Enable parport sb105x drivers if parport is configured

…ric Piel (1):
      staging: comedi: fix minimum AO period for NI 625x and NI 628x

 drivers/iio/accel/Kconfig                      |   1 +
 drivers/iio/adc/ad7266.c                       |   6 +-
 drivers/iio/adc/at91_adc.c                     |   2 +-
 drivers/iio/adc/max1363.c                      |  13 +-
 drivers/iio/common/hid-sensors/Kconfig         |  13 +-
 drivers/iio/common/hid-sensors/Makefile        |   3 +-
 drivers/iio/dac/ad5380.c                       |   6 +-
 drivers/iio/dac/ad5446.c                       |   6 +-
 drivers/iio/dac/ad5504.c                       |   6 +-
 drivers/iio/dac/ad5624r_spi.c                  |   6 +-
 drivers/iio/dac/ad5686.c                       |   6 +-
 drivers/iio/dac/ad5791.c                       |  13 +-
 drivers/iio/frequency/adf4350.c                |   2 +-
 drivers/iio/gyro/Kconfig                       |   1 +
 drivers/iio/light/Kconfig                      |   1 +
 drivers/iio/magnetometer/Kconfig               |   1 +
 drivers/staging/comedi/Kconfig                 |   1 +
 drivers/staging/comedi/comedi_fops.c           |   3 +
 drivers/staging/comedi/drivers/comedi_test.c   |   2 +-
 drivers/staging/comedi/drivers/ni_pcimio.c     |  16 +-
 drivers/staging/fwserial/Kconfig               |   4 +-
 drivers/staging/fwserial/TODO                  |  14 +-
 drivers/staging/fwserial/fwserial.c            |   2 +-
 drivers/staging/fwserial/fwserial.h            |   6 +-
 drivers/staging/iio/gyro/Kconfig               |   4 +-
 drivers/staging/imx-drm/imx-drm-core.c         |   1 -
 drivers/staging/imx-drm/ipu-v3/ipu-common.c    |   5 +-
 drivers/staging/imx-drm/ipuv3-crtc.c           |   6 +-
 drivers/staging/omapdrm/Makefile               |   1 +
 drivers/staging/omapdrm/TODO                   |   3 -
 drivers/staging/omapdrm/omap_connector.c       | 111 +-----
 drivers/staging/omapdrm/omap_crtc.c            | 507 ++++++++++++++++++++++---
 drivers/staging/omapdrm/omap_drv.c             | 439 ++++-----------------
 drivers/staging/omapdrm/omap_drv.h             | 140 +++++--
 drivers/staging/omapdrm/omap_encoder.c         | 132 +++----
 drivers/staging/omapdrm/omap_gem_dmabuf.c      |   2 +-
 drivers/staging/omapdrm/omap_irq.c             | 322 ++++++++++++++++
 drivers/staging/omapdrm/omap_plane.c           | 452 +++++++++-------------
 drivers/staging/rtl8187se/r8180_core.c         |   3 +-
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c |   4 +
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c   |  11 +-
 drivers/staging/rtl8712/usb_intf.c             |   2 +
 drivers/staging/sb105x/Kconfig                 |   1 +
 drivers/staging/sb105x/sb_pci_mp.c             |   2 +
 drivers/staging/speakup/synth.c                |   4 +-
 drivers/staging/tidspbridge/core/_tiomap.h     |   2 +-
 drivers/staging/tidspbridge/core/dsp-clock.c   |  13 +-
 drivers/staging/tidspbridge/core/wdt.c         |  12 +-
 drivers/staging/vme/devices/vme_pio2_core.c    |  14 +-
 drivers/staging/wlan-ng/cfg80211.c             |   7 +-
 drivers/staging/zram/zram_drv.c                |  39 +-
 51 files changed, 1390 insertions(+), 983 deletions(-)
 create mode 100644 drivers/staging/omapdrm/omap_irq.c
