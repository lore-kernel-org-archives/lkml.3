Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3K0Ws4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:48:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3K0Wsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:48:55 -0500
Date: Wed, 27 Nov 2013 14:48:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.13-rc2
Message-ID: <20131127224854.GA2899@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.13-rc2

for you to fetch changes up to 930ba4a374b96560ef9fde2145cdc454a164ddcc:

  Staging: tidspbridge: disable driver (2013-11-27 09:32:49 -0800)

----------------------------------------------------------------
Staging fixes for 3.13-rc2

Here are a number of staging, and IIO driver, fixes for 3.13-rc2 that
resolve issues that have been reported for 3.13-rc1.  All of these have
been in linux-next for a bit this week.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dan Carpenter (3):
      Staging: comedi: pcl730: fix some bitwise vs logical AND bugs
      Staging: vt6655-6: potential NULL dereference in hostap_disable_hostapd()
      staging: nvec: potential NULL dereference on error path

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Geert Uytterhoeven (1):
      Staging: btmtk_usb: Add hdev parameter to hdev->send driver callback

Greg Kroah-Hartman (4):
      Revert "staging:media: Use dev_dbg() instead of pr_debug()"
      Staging: go7007: fix up some remaining go->dev issues
      Merge tag 'fixes-for-3.13a' of git://git.kernel.org/.../jic23/iio into staging-linus
      Staging: tidspbridge: disable driver

Ian Abbott (1):
      staging: comedi: s626: fix value written by s626_set_dac()

Josh Boyer (1):
      staging: imx-drm: Fix modular build of DRM_IMX_IPUV3

Larry Finger (1):
      staging: r8188eu: Fix AP mode

Lars-Peter Clausen (1):
      iio: adc: ti_am335x_adc: avoid double free of buffer.

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Michal Nazarewicz (2):
      staging: comedi: fix potentially uninitialised variable
      staging: ft1000: fix use of potentially uninitialized variable

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Peng Tao (1):
      staging/lustre/ptlrpc: fix ptlrpc_stop_pinger logic

Peter Meerwald (5):
      iio: Fix sign extension table in mcp3422 driver
      iio: Fix mag3110 scan_type
      iio: Fix mag3110 Kconfig dependencies
      iio: Fix tcs3472 Kconfig dependencies
      staging:iio: Fix hmc5843 Kconfig dependencies

Rashika Kheria (1):
      Staging: zram: Fix memory leak by refcount mismatch

Srinivas Pandruvada (1):
      iio: hid_Sensors: fix crash during trigger unregister

Wei Yongjun (1):
      iio: at91: fix error return code in at91_adc_probe()

 drivers/iio/accel/hid-sensor-accel-3d.c            |  5 ++--
 drivers/iio/accel/kxsd9.c                          |  7 +++---
 drivers/iio/adc/at91_adc.c                         |  1 +
 drivers/iio/adc/mcp3422.c                          |  8 +++----
 drivers/iio/adc/ti_am335x_adc.c                    |  7 ++++--
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |  9 ++++---
 .../iio/common/hid-sensors/hid-sensor-trigger.h    |  2 +-
 drivers/iio/gyro/hid-sensor-gyro-3d.c              |  5 ++--
 drivers/iio/light/Kconfig                          |  2 ++
 drivers/iio/light/hid-sensor-als.c                 |  5 ++--
 drivers/iio/magnetometer/Kconfig                   |  2 ++
 drivers/iio/magnetometer/hid-sensor-magn-3d.c      |  5 ++--
 drivers/iio/magnetometer/mag3110.c                 |  7 +++++-
 drivers/staging/btmtk_usb/btmtk_usb.c              |  3 +--
 drivers/staging/comedi/drivers/pcl730.c            |  6 ++---
 drivers/staging/comedi/drivers/s626.c              |  2 +-
 drivers/staging/comedi/drivers/vmk80xx.c           |  2 +-
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |  3 +--
 drivers/staging/iio/magnetometer/Kconfig           |  2 ++
 drivers/staging/imx-drm/Makefile                   |  4 +++-
 drivers/staging/imx-drm/imx-drm-core.c             |  1 +
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  4 ++--
 drivers/staging/media/go7007/go7007-usb.c          | 28 ++++++++++++----------
 drivers/staging/nvec/nvec.c                        |  3 ++-
 drivers/staging/rtl8188eu/core/rtw_ap.c            |  3 +++
 drivers/staging/tidspbridge/Kconfig                |  2 +-
 drivers/staging/vt6655/hostap.c                    |  3 ++-
 drivers/staging/vt6656/baseband.c                  | 11 +++++++++
 drivers/staging/vt6656/hostap.c                    |  3 ++-
 drivers/staging/vt6656/rndis.h                     |  2 ++
 drivers/staging/zram/zram_drv.c                    | 19 +++++++++++----
 drivers/staging/zsmalloc/zsmalloc-main.c           | 17 +++++++++----
 include/linux/hid-sensor-hub.h                     |  3 +++
 33 files changed, 124 insertions(+), 62 deletions(-)
