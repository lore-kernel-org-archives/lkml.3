Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaITRfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbaITRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:34:57 -0400
Date: Sat, 20 Sep 2014 10:34:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.17-rc6
Message-ID: <20140920173409.GA29921@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.17-rc6

for you to fetch changes up to ed87c2b2e7dd34016017af183b8f3fbe28179bc1:

  staging: vt6655: buffer overflow in ioctl (2014-09-19 15:32:20 -0700)

----------------------------------------------------------------
Staging / IIO fixes for 3.17-rc6

Here are some IIO and Staging driver fixes for 3.17-rc6.  They are all
pretty simple, and resolve reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Dan Carpenter (1):
      staging: vt6655: buffer overflow in ioctl

Denis CIOCCA (1):
      iio:magnetometer: bugfix magnetometers gain values

Greg Kroah-Hartman (1):
      Merge tag 'iio-fixes-3.17a' of git://git.kernel.org/.../jic23/iio into staging-linus

Johannes Pointner (1):
      iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name

Ludovic Desroches (1):
      iio: adc: at91: don't use the last converted data register

Srinivas Pandruvada (8):
      iio:trigger: modify return value for iio_trigger_get
      iio: accel: bma180: Fix indio_dev->trig assignment
      iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment
      iio: hid_sensor_hub: Fix indio_dev->trig assignment
      iio: st_sensors: Fix indio_dev->trig assignment
      iio: gyro: itg3200: Fix indio_dev->trig assignment
      iio: inv_mpu6050: Fix indio_dev->trig assignment
      iio: meter: ade7758: Fix indio_dev->trig assignment

Subbaraya Sundeep Bhatta (1):
      iio: adc: xilinx-xadc: assign auxiliary channels address correctly

 drivers/iio/accel/bma180.c                         |  2 +-
 drivers/iio/adc/ad_sigma_delta.c                   |  2 +-
 drivers/iio/adc/at91_adc.c                         | 12 ++---
 drivers/iio/adc/xilinx-xadc-core.c                 |  2 +-
 .../iio/common/hid-sensors/hid-sensor-trigger.c    |  3 +-
 drivers/iio/common/st_sensors/st_sensors_trigger.c |  2 +-
 drivers/iio/gyro/itg3200_buffer.c                  |  2 +-
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c      |  2 +-
 drivers/iio/inkern.c                               |  2 +-
 drivers/iio/magnetometer/st_magn_core.c            | 52 +++++++++++++---------
 drivers/staging/iio/meter/ade7758_trigger.c        |  2 +-
 drivers/staging/vt6655/hostap.c                    |  3 ++
 include/linux/iio/trigger.h                        |  4 +-
 13 files changed, 53 insertions(+), 37 deletions(-)
