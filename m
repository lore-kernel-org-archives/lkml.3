Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab3LRRmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 12:42:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3LRRmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 12:42:00 -0500
Date: Wed, 18 Dec 2013 09:42:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.13-rc5
Message-ID: <20131218174202.GA32599@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.13-rc5

for you to fetch changes up to fd6040ed57d8f200ab0cc2abf706c54995a48370:

  imx-drm: imx-drm-core: improve safety of imx_drm_add_crtc() (2013-12-17 17:12:55 -0800)

----------------------------------------------------------------
Staging driver fixes for 3.13-rc5

Here are a number of staging, and iio, fixes for 3.13-rc5 that resolve
some reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Beomho Seo (1):
      iio: cm36651: Changed return value of read function

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-for-3.13c' of git://git.kernel.org/.../jic23/iio into staging-linus

H Hartley Sweeten (1):
      staging: comedi: drivers: fix return value of comedi_load_firmware()

Ian Abbott (1):
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Jonathan Cameron (3):
      staging:iio:mag:hmc5843 fix incorrect endianness of channel as a result of missuse of the IIO_ST macro.
      iio:imu:adis16400 fix pressure channel scan type
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

Russell King (7):
      imx-drm: imx-drm-core: fix error cleanup path for imx_drm_add_crtc()
      imx-drm: imx-drm-core: fix DRM cleanup paths
      imx-drm: ipu-v3: fix potential CRTC device registration race
      imx-drm: imx-tve: don't call sleeping functions beneath enable_lock spinlock
      imx-drm: imx-drm-core: use defined constant for number of CRTCs.
      imx-drm: imx-drm-core: make imx_drm_crtc_register() safer
      imx-drm: imx-drm-core: improve safety of imx_drm_add_crtc()

 drivers/iio/adc/ad7887.c                    | 16 ++++++++++--
 drivers/iio/imu/adis16400_core.c            |  7 +++++-
 drivers/iio/light/cm36651.c                 |  2 +-
 drivers/staging/comedi/drivers.c            |  2 +-
 drivers/staging/comedi/drivers/8255_pci.c   | 15 ++++++++---
 drivers/staging/iio/magnetometer/hmc5843.c  |  7 +++++-
 drivers/staging/imx-drm/imx-drm-core.c      | 39 +++++++++++++++++++++--------
 drivers/staging/imx-drm/imx-tve.c           |  9 -------
 drivers/staging/imx-drm/ipu-v3/ipu-common.c | 32 +++++++++++------------
 9 files changed, 85 insertions(+), 44 deletions(-)
