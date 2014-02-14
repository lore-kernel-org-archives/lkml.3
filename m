Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaBNVYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:24:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaBNVYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:24:36 -0500
Date: Fri, 14 Feb 2014 13:25:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Subject: [GIT PULL] Staging driver fixes for 3.14-rc3
Message-ID: <20140214212555.GA19423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git/ tags/staging-3.14-rc3

for you to fetch changes up to ddf5eb564d97c94e114b45e84c89ce0e7024a9ac:

  staging/rtl8821ae: fix build, depends on MAC80211 (2014-02-11 15:57:40 -0800)

----------------------------------------------------------------
Staging driver fixes for 3.14-rc3

Here are a number (lots, I know) of fixes for staging drivers to resolve
a bunch of reported issues.

The largest patches here is one revert of a patch that is in 3.14-rc1 to
fix reported problems, and a sync of a usb host driver that required
some ARM patches to go in before it could be accepted (which is why it
missed -rc1).

All of these have been in linux-next for a while with no reported issues.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Cox (1):
      xlr_net: Fix missing trivial allocation check

Alexandre Belloni (2):
      iio: mxs-lradc: fix buffer overflow
      iio: mxs-lradc: remove useless scale_available files

Alexey Khoroshilov (1):
      staging: gdm72xx: fix leaks at failure path in gdm_usb_probe()

Alistair Strachan (1):
      staging: sync: Fix a race condition between release_obj and print_obj

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss unit

Chen Gang (1):
      drivers: staging: android: ion: ion_dummy_driver: include "linux/io.h"

Colin Cross (1):
      staging: ion: Fix overflow and list bugs in system heap

Craig Markwardt (1):
      iio: Fix a buffer overflow in iio_utils.h example code

Cédric Dufour - Idiap Research Institute (1):
      staging: lustre: fix quotactl permission denied (LU-4530)

Dan Carpenter (5):
      staging: r8188eu: memory corruption handling long ssids
      staging: android: ion: dummy: fix an error code
      gpu: ion: dereferencing an ERR_PTR
      staging: r8188eu: array overflow in rtw_mp_ioctl_hdl()
      staging: r8188eu: overflow in rtw_p2p_get_go_device_address()

David Daney (1):
      staging: octeon-usb: Probe via device tree populated platform device.

Greg Hackmann (1):
      staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC

Greg Kroah-Hartman (3):
      Merge tag 'iio-fixes-for-3.14a' of git://git.kernel.org/.../jic23/iio into staging-linus
      Revert "Staging: dgrp: Refactor the function dgrp_receive() in drrp_net_ops.c"
      Merge tag 'iio-fixes-for-3.14b' of git://git.kernel.org/.../jic23/iio into staging-linus

Guenter Roeck (1):
      iio: max1363: Use devm_regulator_get_optional for optional regulator

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

Hartmut Knaack (2):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that may not have been requested
      staging:iio:ad799x fix typo in ad799x_events[]

Heinrich Schuchardt (1):
      usbip/userspace/libsrc/names.c: memory leak

Ian Abbott (2):
      staging: comedi: fix too early cleanup in comedi_auto_config()
      staging: comedi: usbduxsigma: fix unaligned dereferences

Ivaylo Dimitrov (1):
      iio: tsl2563: Use the correct channel2 member

John Stultz (1):
      staging: ion: Fix build warning

Jonathan Cameron (1):
      staging:iio:ad799x fix incorrect endianness specification for buffer elements

Julia Lawall (1):
      staging:iio:impedance:ad5933: correct error check

Larry Finger (1):
      staging: r8188eu: Fix typo in USB_DEVICE list

Laura Abbott (1):
      staging: ion: Fix ION_IOC_FREE compat ioctl

Marcus Folkesson (1):
      iio: adis16400: Set timestamp as the last element in chan_spec

Marek Szyprowski (1):
      staging: lustre: fix GFP_ATOMIC macro usage

Maurizio Lombardi (1):
      wlags49_h2: Fix overflow in wireless_set_essid()

Oleg Drokin (5):
      staging/lustre: fix compile warning with is_vmalloc_addr
      staging/lustre/lnet: Fix use after free in ksocknal_send
      lustre: Account for changelog_ext_rec in CR_MAXSIZE
      lustre: Correct KUC code max changelog msg size
      lustre: add myself to list of people to CC on lustre patches

Paul Gortmaker (1):
      staging: don't use module_init in non-modular ion_dummy_driver.c

Peter Meerwald (3):
      iio:magnetometer:mag3110: Report busy in _read_raw() / write_raw() when buffer is enabled
      iio:magnetometer:mag3110: Fix output of decimal digits in show_int_plus_micros()
      iio:accel:bma180: Use modifier instead of index in channel specification

Prakash Kamliya (1):
      staging: android: sync: Signal pt before sync_timeline object gets destroyed

Randy Dunlap (1):
      staging/rtl8821ae: fix build, depends on MAC80211

Richard Weinberger (2):
      staging:iio:spear_adc: Add dependency on HAS_IOMEM
      staging:iio:lpc32xx_adc: Add dependency on HAS_IOMEM

Russell King (3):
      imx-drm: imx-drm-core: use the crtc drm device for vblank
      imx-drm: imx-drm-core: avoid going the long route round for drm_device
      imx-drm: imx-drm-core: merge imx_drm_crtc_register() into imx_drm_add_crtc()

Sachin Kamat (1):
      staging: imx-drm: Fix build error

Salym Senyonga (1):
      Staging: ozwpan: Fix null dereference

Shuah Khan (1):
      staging/usbip: Fix vhci_hcd attach failure error message to be informative

Surendra Patil (1):
      staging: rtl8821ae: Fixed the size of array to macro as discussed by Linus

Todd Poynor (1):
      staging: ashmem: Avoid deadlock between read and mmap calls

Tomas Winkler (1):
      ion: dummy driver: use ARRAY_SIZE for nr of heaps

 drivers/iio/accel/bma180.c                         |  16 +-
 drivers/iio/adc/max1363.c                          |   2 +-
 drivers/iio/imu/adis16400.h                        |   1 +
 drivers/iio/imu/adis16400_core.c                   |  10 +-
 drivers/iio/light/tsl2563.c                        |  16 +-
 drivers/iio/magnetometer/ak8975.c                  |  16 +-
 drivers/iio/magnetometer/mag3110.c                 |   8 +-
 drivers/staging/android/ashmem.c                   |  45 +--
 drivers/staging/android/ion/compat_ion.c           |  26 +-
 drivers/staging/android/ion/ion_dummy_driver.c     |  12 +-
 drivers/staging/android/ion/ion_heap.c             |   2 +-
 drivers/staging/android/ion/ion_priv.h             |   1 +
 drivers/staging/android/ion/ion_system_heap.c      |   6 +-
 drivers/staging/android/sw_sync.h                  |  17 ++
 drivers/staging/android/sync.c                     |  14 +-
 drivers/staging/comedi/drivers.c                   |   2 -
 drivers/staging/comedi/drivers/adv_pci1710.c       |  17 +-
 drivers/staging/comedi/drivers/usbduxsigma.c       |   6 +-
 drivers/staging/dgrp/dgrp_net_ops.c                | 330 ++++++++++-----------
 drivers/staging/gdm72xx/gdm_usb.c                  |   3 +
 drivers/staging/iio/Documentation/iio_utils.h      |   6 +-
 drivers/staging/iio/adc/ad799x_core.c              |  13 +-
 drivers/staging/iio/adc/mxs-lradc.c                |   6 +-
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   2 +-
 drivers/staging/imx-drm/imx-drm-core.c             |  55 ++--
 drivers/staging/imx-drm/imx-hdmi.c                 |  22 +-
 drivers/staging/lustre/TODO                        |   5 +-
 .../include/linux/libcfs/libcfs_kernelcomm.h       |   2 +
 .../lustre/include/linux/libcfs/libcfs_private.h   |   2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |   2 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   5 +-
 .../lustre/lustre/include/lustre/lustre_user.h     |   3 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   2 +-
 drivers/staging/lustre/lustre/mdc/mdc_request.c    |   6 +-
 drivers/staging/netlogic/xlr_net.c                 |   5 +
 drivers/staging/octeon-usb/octeon-hcd.c            | 273 ++++++++---------
 drivers/staging/ozwpan/ozproto.c                   |   3 +-
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c     |  22 +-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c     |  12 +-
 drivers/staging/rtl8188eu/os_dep/usb_intf.c        |   2 +-
 drivers/staging/rtl8821ae/Kconfig                  |   2 +-
 drivers/staging/rtl8821ae/wifi.h                   |   2 +-
 drivers/staging/usbip/userspace/libsrc/names.c     |   8 +-
 drivers/staging/usbip/vhci_sysfs.c                 |   3 +-
 drivers/staging/wlags49_h2/wl_wext.c               |   2 +-
 45 files changed, 506 insertions(+), 509 deletions(-)
