Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755Ab3EWQQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:16:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3EWQQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:16:43 -0400
Date: Thu, 23 May 2013 09:16:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.10-rc3
Message-ID: <20130523161642.GA14573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.10-rc2

for you to fetch changes up to 0797c3a3e9660682b5df80911f35b523995a40bd:

  staging: dwc2: remove compile warning for USB_DWC2_TRACK_MISSED_SOFS (2013-05-22 15:19:18 -0700)

----------------------------------------------------------------
Staging driver fixes for 3.10-rc2

Here are some staging tree driver fixes for 3.10-rc2

The drivers/iio/ changes are here as they are still tied into
drivers/staging/iio/.

Nothing major, just a number of small bugfixes, and a larger documentation
update for the ramster code.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Arnd Bergmann (2):
      staging/drm: imx: add missing dependencies
      staging/solo6x10: depend on CONFIG_FONTS

Axel Lin (1):
      iio: dac: Fix build error when CONFIG_SPI_MASTER=y && CONFIG_I2C=m

Dan Magenheimer (1):
      staging: ramster: add how-to document

Denis CIOCCA (1):
      iio:common:st: added disable function after read info raw data

Denis Efremov (1):
      staging: nvec: remove inline marking of EXPORT_SYMBOL functions

Fabio Estevam (1):
      staging: imx-drm: imx-tve: Check the return value of 'regulator_enable()'

Geert Uytterhoeven (1):
      staging: zcache: Fix incorrect module_param_array types

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.10a' of git://git.kernel.org/.../jic23/iio into staging-linus

H Hartley Sweeten (1):
      staging: comedi: ni_labpc: fix build when VIRT_TO_BUS is not defined

Hema Prathaban (1):
      staging: vt6656: use free_netdev instead of kfree

Ian Abbott (4):
      staging: comedi: allow buffer resize if previous resize failed
      staging: comedi: work without HAS_DMA
      staging: comedi: ni_mio_common: only do counter commands for ni_pcimio
      staging: comedi: complain if dma buffer allocation not supported

Jean Delvare (1):
      staging: Swap zram and zsmalloc in Kconfig

Lee Jones (1):
      staging: ste_rmi4: Suppress 'ignoring return value of ‘regulator_enable()' warning

Malcolm Priestley (1):
      staging: vt6656: [bug] Fix missing spin lock in iwctl_siwpower.

Marc Dietrich (3):
      staging: nvec: add missing module aliases
      staging: nvec: implement unregistering of notifiers
      staging: nvec: cleanup childs on remove

Marek Vasut (1):
      staging: video: imx: Select VIDEOMODE_HELPERS for parallel display

Matthijs Kooijman (1):
      staging: dwc2: Fix dma-enabled platform devices using a default dma_mask

Michał Mirosław (1):
      staging/iio/mxs-lradc: fix preenable for multiple buffers

Naveen Krishna Chatradhi (1):
      iio: exynos_adc: fix wrong structure extration in suspend and resume

Paul Zimmerman (1):
      staging: dwc2: remove compile warning for USB_DWC2_TRACK_MISSED_SOFS

Randy Dunlap (1):
      staging: sep: fix driver build and kconfig

Wei Yongjun (1):
      staging:iio:light:tsl2x7x: fix the error handling in tsl2x7x_probe()

Xiong Zhou (1):
      staging: android: logger: use kuid_t instead of uid_t

 drivers/iio/adc/exynos_adc.c                     |   8 +-
 drivers/iio/common/st_sensors/st_sensors_core.c  |   2 +
 drivers/iio/dac/Kconfig                          |   6 +-
 drivers/staging/Kconfig                          |   4 +-
 drivers/staging/android/logger.c                 |   4 +-
 drivers/staging/android/logger.h                 |   2 +-
 drivers/staging/comedi/Kconfig                   |   9 +
 drivers/staging/comedi/comedi_buf.c              |  12 +
 drivers/staging/comedi/comedi_fops.c             |   3 -
 drivers/staging/comedi/drivers/ni_labpc.c        |   8 +-
 drivers/staging/comedi/drivers/ni_labpc.h        |   1 +
 drivers/staging/comedi/drivers/ni_mio_common.c   |  20 +-
 drivers/staging/dwc2/Kconfig                     |   1 +
 drivers/staging/dwc2/hcd_intr.c                  |   2 -
 drivers/staging/dwc2/platform.c                  |   8 +
 drivers/staging/iio/adc/mxs-lradc.c              |   5 +-
 drivers/staging/iio/light/tsl2x7x_core.c         |   9 +-
 drivers/staging/imx-drm/Kconfig                  |   5 +
 drivers/staging/imx-drm/imx-tve.c                |   4 +-
 drivers/staging/media/solo6x10/Kconfig           |   1 +
 drivers/staging/nvec/nvec.c                      |  21 +-
 drivers/staging/nvec/nvec.h                      |   5 +-
 drivers/staging/nvec/nvec_kbd.c                  |  10 +-
 drivers/staging/nvec/nvec_power.c                |   1 +
 drivers/staging/nvec/nvec_ps2.c                  |   8 +-
 drivers/staging/sep/Kconfig                      |   2 +-
 drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c    |   6 +-
 drivers/staging/vt6656/hostap.c                  |   2 +-
 drivers/staging/vt6656/iwctl.c                   |   6 +
 drivers/staging/zcache/ramster/ramster-howto.txt | 366 +++++++++++++++++++++++
 drivers/staging/zcache/zcache-main.c             |   8 +-
 drivers/video/console/Makefile                   |   2 +
 32 files changed, 499 insertions(+), 52 deletions(-)
 create mode 100644 drivers/staging/zcache/ramster/ramster-howto.txt
