Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3IWRHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:07:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab3IWRHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:07:44 -0400
Date: Mon, 23 Sep 2013 10:07:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PATCH] Staging driver fixes for 3.12-rc2
Message-ID: <20130923170742.GA4721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.12-rc2

for you to fetch changes up to 617408101362c830779b8b4c7eca9efefe0beab1:

  Merge tag 'iio-fixes-for-3.12a' of git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-linus (2013-09-21 16:45:36 -0700)

----------------------------------------------------------------

Staging fixes for 3.12-rc2

Here are a number of small staging tree and iio driver fixes.  Nothing major,
just lots of little things.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Aaro Koskinen (3):
      staging: octeon-ethernet: make dropped packets to consume NAPI budget
      staging: octeon-ethernet: remove skb alloc failure warnings
      staging: octeon-ethernet: rgmii: enable interrupts that we can handle

Andrew Morton (1):
      drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c: rename PTRS_PER_PAGE

Ben Hutchings (1):
      Staging: comedi: Fix dependencies for drivers misclassified as PCI

Dan Carpenter (1):
      staging: line6: add bounds check in snd_toneport_source_put()

Dave Jones (2):
      staging/rtl8188eu: pass channel list by reference instead of copying struct.
      staging/vt6656: Fix screwed up indentation in swGetOFDMControlRate

Derek Basehore (1):
      iio: isl29018: Fix uninitialized value

Geert Uytterhoeven (2):
      staging/lustre: Correct default for LUSTRE_TRANSLATE_ERRNOS
      staging: r8188eu: Fix uninitialized variable change_inx

Greg Kroah-Hartman (2):
      Revert "staging: zram: Add auto loading of module if user opens /dev/zram."
      Merge tag 'iio-fixes-for-3.12a' of git://git.kernel.org/.../jic23/iio into staging-linus

Guenter Roeck (1):
      staging: Disable lustre file system for MIPS, SH, and XTENSA

Jonathan Cameron (1):
      staging:iio:dummy fix kfifo_buf kconfig dependency issue if kfifo modular and buffer enabled for built in dummy driver.

Josh Wu (1):
      iio: at91: fix adc_clk overflow

Kees Cook (4):
      staging: xillybus: fix format string usage
      staging: dgap: fix overflows and format strings
      staging: lustre: clean up format string usages
      staging: dgnc: fix potential format string flaw

Larry Finger (4):
      staging: r8188eu: Fix Smatch off-by-one warning in hal/rtl8188e_hal_init.c
      staging: r8188eu: Fix smatch error in core/rtw_mlme_ext.c
      staging: r8188eu: Fix smatch warning in core/rtw_ieee80211.
      staging: r8188eu: Adjust RX gain

Lars-Peter Clausen (4):
      iio: Stop sampling when the device is removed
      iio: fix: Keep a reference to the IIO device for open file descriptors
      iio: Prevent race between IIO chardev opening and IIO device free
      iio:buffer_cb: Add missing iio_buffer_init()

Lukasz Czerwinski (1):
      iio: iio_device_add_event_sysfs() bugfix

Peter Meerwald (5):
      staging:iio:hmc5843: Fix measurement conversion
      iio: Fix tmp006 dev-to-indio_dev conversion in suspend/resume
      iio: Fix bma180 dev-to-indio_dev conversion in suspend/resume
      iio: Fix mcp4725 dev-to-indio_dev conversion in suspend/resume
      iio: Fix crash when scan_bytes is computed with active_scan_mask == NULL

Sachin Kamat (1):
      staging: iio: ade7854-spi: Fix return value

 drivers/iio/accel/bma180.c                         |  4 +--
 drivers/iio/adc/at91_adc.c                         | 11 ++++----
 drivers/iio/buffer_cb.c                            |  2 ++
 drivers/iio/dac/mcp4725.c                          | 12 ++++----
 drivers/iio/iio_core.h                             |  4 +++
 drivers/iio/industrialio-buffer.c                  | 30 ++++++++++++++++++--
 drivers/iio/industrialio-core.c                    | 31 +++++++++++++-------
 drivers/iio/industrialio-event.c                   | 20 +++++++++----
 drivers/iio/temperature/tmp006.c                   |  6 ++--
 drivers/staging/comedi/Kconfig                     | 33 +++++++++++-----------
 drivers/staging/dgap/dgap_driver.c                 | 17 ++++++-----
 drivers/staging/dgnc/dgnc_driver.c                 |  4 +--
 drivers/staging/iio/Kconfig                        |  2 +-
 drivers/staging/iio/light/isl29018.c               |  1 +
 drivers/staging/iio/magnetometer/hmc5843.c         |  2 +-
 drivers/staging/iio/meter/ade7854-spi.c            |  2 +-
 drivers/staging/line6/toneport.c                   | 10 +++++--
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |  2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |  2 +-
 drivers/staging/lustre/lustre/Kconfig              |  4 +--
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |  4 +--
 drivers/staging/lustre/lustre/libcfs/workitem.c    |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |  4 +--
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |  8 +++---
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |  4 +--
 drivers/staging/lustre/lustre/ptlrpc/service.c     |  6 ++--
 drivers/staging/octeon/ethernet-mem.c              |  7 +----
 drivers/staging/octeon/ethernet-rgmii.c            |  4 +--
 drivers/staging/octeon/ethernet-rx.c               |  5 +---
 drivers/staging/rtl8188eu/core/rtw_ieee80211.c     |  2 +-
 drivers/staging/rtl8188eu/core/rtw_mlme_ext.c      | 14 ++++-----
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |  2 +-
 drivers/staging/rtl8188eu/include/odm.h            |  2 +-
 drivers/staging/rtl8188eu/include/rtl8188e_hal.h   |  2 +-
 drivers/staging/rtl8188eu/include/rtw_mlme_ext.h   |  1 +
 drivers/staging/vt6656/card.c                      |  4 +--
 drivers/staging/xillybus/xillybus_core.c           |  2 +-
 drivers/staging/zram/zram_drv.c                    |  1 -
 38 files changed, 163 insertions(+), 110 deletions(-)
