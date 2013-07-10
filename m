Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3GJPek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:34:40 -0400
Received: from sauhun.de ([89.238.76.85]:54461 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab3GJPeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:34:12 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 0/2] replace INIT_COMPLETION with reinit_completion
Date: Wed, 10 Jul 2013 16:33:55 +0100
Message-Id: <1373470437-16908-1-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had this on my mind for a bit of time now... Never liked INIT_COMPLETION
because of inconsistencies. See patch 1 to see why I think a replacement is
proper. I wonder what to do about the old INIT_COMPLETION, though. We could

a) remove it right away (bad luck for out-of-tree users, still my favourite)
b) keep it, but discourage its use (then we have cruft)
c) convert it to an inline function and mark that deprecated and remove it later

This series is based on linus-master as of today and I was able to compile test
60 out of 76 files, for the others I didn't have configs/compilers. Tested on
an AT91 board. More testing welcome.

Looking forward to opinions. If accepted, I'd think it is probably best if this
gets in in one go via Linus directly?

Thanks,

   Wolfram


Wolfram Sang (2):
  sched: replace INIT_COMPLETION with reinit_completion
  tree-wide: use reinit_completion instead of INIT_COMPLETION

 arch/arm/mach-tegra/apbio.c                      |    2 +-
 arch/powerpc/platforms/powermac/low_i2c.c        |    6 +++---
 arch/powerpc/platforms/pseries/suspend.c         |    2 +-
 crypto/af_alg.c                                  |    2 +-
 crypto/tcrypt.c                                  |    4 ++--
 crypto/testmgr.c                                 |   12 ++++++------
 drivers/ata/libata-eh.c                          |    2 +-
 drivers/base/power/main.c                        |    4 ++--
 drivers/block/amiflop.c                          |    2 +-
 drivers/block/cciss.c                            |    4 ++--
 drivers/char/hw_random/timeriomem-rng.c          |    2 +-
 drivers/crypto/tegra-aes.c                       |    2 +-
 drivers/firewire/core-transaction.c              |    2 +-
 drivers/gpu/drm/gma500/oaktrail_hdmi_i2c.c       |    2 +-
 drivers/hwmon/jz4740-hwmon.c                     |    2 +-
 drivers/i2c/busses/i2c-at91.c                    |    2 +-
 drivers/i2c/busses/i2c-bcm2835.c                 |    2 +-
 drivers/i2c/busses/i2c-davinci.c                 |    2 +-
 drivers/i2c/busses/i2c-designware-core.c         |    2 +-
 drivers/i2c/busses/i2c-ismt.c                    |    2 +-
 drivers/i2c/busses/i2c-mxs.c                     |    2 +-
 drivers/i2c/busses/i2c-omap.c                    |    2 +-
 drivers/i2c/busses/i2c-tegra.c                   |    2 +-
 drivers/i2c/busses/i2c-wmt.c                     |    4 ++--
 drivers/iio/adc/ad_sigma_delta.c                 |    6 +++---
 drivers/input/touchscreen/cyttsp_core.c          |    2 +-
 drivers/md/dm-crypt.c                            |    2 +-
 drivers/media/platform/blackfin/bfin_capture.c   |    2 +-
 drivers/media/platform/coda.c                    |    2 +-
 drivers/media/radio/radio-wl1273.c               |   10 +++++-----
 drivers/media/radio/si470x/radio-si470x-common.c |    4 ++--
 drivers/media/rc/iguanair.c                      |    2 +-
 drivers/memstick/core/memstick.c                 |    2 +-
 drivers/memstick/host/r592.c                     |    2 +-
 drivers/misc/ti-st/st_kim.c                      |   12 ++++++------
 drivers/mtd/nand/mxc_nand.c                      |    2 +-
 drivers/mtd/nand/r852.c                          |    2 +-
 drivers/mtd/onenand/omap2.c                      |   10 +++++-----
 drivers/net/ieee802154/at86rf230.c               |    2 +-
 drivers/net/ieee802154/mrf24j40.c                |    2 +-
 drivers/net/wireless/ath/carl9170/usb.c          |    2 +-
 drivers/net/wireless/ath/wil6210/main.c          |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c    |    4 ++--
 drivers/net/wireless/zd1211rw/zd_usb.c           |    2 +-
 drivers/parport/parport_ip32.c                   |    4 ++--
 drivers/platform/x86/apple-gmux.c                |    2 +-
 drivers/power/ab8500_fg.c                        |    4 ++--
 drivers/power/jz4740-battery.c                   |    2 +-
 drivers/rtc/rtc-hid-sensor-time.c                |    2 +-
 drivers/spi/spi-bcm2835.c                        |    2 +-
 drivers/spi/spi-clps711x.c                       |    2 +-
 drivers/spi/spi-davinci.c                        |    2 +-
 drivers/spi/spi-fsl-espi.c                       |    2 +-
 drivers/spi/spi-fsl-spi.c                        |    2 +-
 drivers/spi/spi-mpc512x-psc.c                    |    2 +-
 drivers/spi/spi-mxs.c                            |    2 +-
 drivers/spi/spi-s3c64xx.c                        |    2 +-
 drivers/spi/spi-sh-msiof.c                       |    2 +-
 drivers/spi/spi-sirf.c                           |    2 +-
 drivers/spi/spi-tegra114.c                       |    6 +++---
 drivers/spi/spi-tegra20-sflash.c                 |    2 +-
 drivers/spi/spi-tegra20-slink.c                  |    6 +++---
 drivers/spi/spi-xilinx.c                         |    2 +-
 drivers/staging/iio/adc/mxs-lradc.c              |    2 +-
 drivers/staging/media/solo6x10/solo6x10-p2m.c    |    2 +-
 drivers/staging/tidspbridge/core/sync.c          |    4 ++--
 drivers/staging/tidspbridge/rmgr/drv_interface.c |    6 +++---
 drivers/tty/metag_da.c                           |    2 +-
 drivers/usb/c67x00/c67x00-sched.c                |    2 +-
 drivers/usb/gadget/f_fs.c                        |    2 +-
 drivers/usb/serial/mos7720.c                     |    2 +-
 drivers/video/exynos/exynos_mipi_dsi_common.c    |    4 ++--
 fs/ecryptfs/crypto.c                             |    4 ++--
 fs/nfs/nfs4state.c                               |    2 +-
 fs/ocfs2/dlmglue.c                               |    4 ++--
 include/linux/completion.h                       |   14 +++++++++++++-
 sound/soc/samsung/ac97.c                         |    6 +++---
 77 files changed, 131 insertions(+), 119 deletions(-)

-- 
1.7.10.4

