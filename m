Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168Ab3IDBp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 21:45:26 -0400
Received: from ozlabs.org ([203.10.76.45]:33935 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761639Ab3IDBpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 21:45:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: <torvalds@linux-foundation.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PULL] PTR_RET -> PTR_ERR_OR_ZERO
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 04 Sep 2013 11:12:54 +0930
Message-ID: <87bo498iqp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux.git tags/PTR_RET-for-linus

for you to fetch changes up to ad151d544475df40ee0d18be7d5c945e29c1b545:

  GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO (2013-07-22 11:11:46 +0930)

----------------------------------------------------------------
PTR_RET() is a weird name, and led to some confusing usage.  We ended
up with PTR_ERR_OR_ZERO(), and replacing or fixing all the usages.

This has been sitting in linux-next for a whole cycle.

Thanks,
Rusty.

----------------------------------------------------------------
Rusty Russell (8):
      PTR_RET is now PTR_ERR_OR_ZERO
      PTR_RET is now PTR_ERR_OR_ZERO(): Replace most.
      s390: Replace weird use of PTR_RET.
      acpi: Replace weird use of PTR_RET.
      pinctrl: don't use PTR_RET().
      remoteproc: don't use PTR_RET().
      staging/zcache: don't use PTR_RET().
      mm/oom_kill: remove weird use of ERR_PTR()/PTR_ERR().

Sachin Kamat (5):
      drivers/rtc: Replace PTR_RET with PTR_ERR_OR_ZERO
      dma-buf: Replace PTR_RET with PTR_ERR_OR_ZERO
      sh_veu: Replace PTR_RET with PTR_ERR_OR_ZERO
      drm/cma: Replace PTR_RET with PTR_ERR_OR_ZERO
      Btrfs: volume: Replace PTR_RET with PTR_ERR_OR_ZERO

Steven Whitehouse (1):
      GFS2: Replace PTR_RET with PTR_ERR_OR_ZERO

 arch/arm/mach-omap2/i2c.c                         |  2 +-
 arch/m68k/amiga/platform.c                        |  2 +-
 arch/m68k/kernel/time.c                           |  2 +-
 arch/m68k/q40/config.c                            |  2 +-
 arch/powerpc/kernel/iommu.c                       |  2 +-
 arch/powerpc/kernel/time.c                        |  2 +-
 arch/powerpc/platforms/ps3/time.c                 |  2 +-
 arch/powerpc/sysdev/rtc_cmos_setup.c              |  2 +-
 arch/s390/hypfs/hypfs_dbfs.c                      |  2 +-
 arch/s390/kvm/gaccess.h                           | 12 ++++++++----
 drivers/acpi/acpi_pad.c                           | 13 ++++++++-----
 drivers/base/dma-buf.c                            |  2 +-
 drivers/char/tile-srom.c                          |  2 +-
 drivers/gpu/drm/drm_gem_cma_helper.c              |  2 +-
 drivers/infiniband/core/cma.c                     |  2 +-
 drivers/media/platform/sh_veu.c                   |  2 +-
 drivers/net/appletalk/cops.c                      |  2 +-
 drivers/net/appletalk/ltpc.c                      |  2 +-
 drivers/net/ethernet/amd/atarilance.c             |  2 +-
 drivers/net/ethernet/amd/mvme147.c                |  2 +-
 drivers/net/ethernet/amd/ni65.c                   |  2 +-
 drivers/net/ethernet/amd/sun3lance.c              |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c   |  2 +-
 drivers/pinctrl/mvebu/pinctrl-dove.c              |  2 +-
 drivers/platform/x86/samsung-q10.c                |  2 +-
 drivers/regulator/fan53555.c                      |  2 +-
 drivers/remoteproc/da8xx_remoteproc.c             |  2 +-
 drivers/rtc/rtc-da9052.c                          |  2 +-
 drivers/rtc/rtc-isl12022.c                        |  2 +-
 drivers/rtc/rtc-m48t35.c                          |  2 +-
 drivers/rtc/rtc-pcf8563.c                         |  2 +-
 drivers/rtc/rtc-pcf8583.c                         |  2 +-
 drivers/spi/spi-fsl-spi.c                         |  2 +-
 drivers/spi/spidev.c                              |  2 +-
 drivers/staging/zcache/zcache-main.c              |  2 +-
 drivers/video/omap2/dss/core.c                    |  2 +-
 fs/btrfs/dev-replace.c                            |  2 +-
 fs/btrfs/inode.c                                  |  2 +-
 fs/btrfs/volumes.c                                |  2 +-
 fs/gfs2/inode.c                                   |  2 +-
 include/linux/err.h                               |  5 ++++-
 mm/oom_kill.c                                     |  6 +++---
 net/bluetooth/hci_sysfs.c                         |  2 +-
 net/bridge/netfilter/ebtable_broute.c             |  2 +-
 net/bridge/netfilter/ebtable_filter.c             |  2 +-
 net/bridge/netfilter/ebtable_nat.c                |  2 +-
 net/ipv4/netfilter/arptable_filter.c              |  2 +-
 net/ipv4/netfilter/iptable_filter.c               |  2 +-
 net/ipv4/netfilter/iptable_mangle.c               |  2 +-
 net/ipv4/netfilter/iptable_nat.c                  |  2 +-
 net/ipv4/netfilter/iptable_raw.c                  |  2 +-
 net/ipv4/netfilter/iptable_security.c             |  2 +-
 net/ipv6/netfilter/ip6table_filter.c              |  2 +-
 net/ipv6/netfilter/ip6table_mangle.c              |  2 +-
 net/ipv6/netfilter/ip6table_nat.c                 |  2 +-
 net/ipv6/netfilter/ip6table_raw.c                 |  2 +-
 net/ipv6/netfilter/ip6table_security.c            |  2 +-
 scripts/coccinelle/api/ptr_ret.cocci              | 10 +++++-----
 sound/soc/soc-io.c                                |  2 +-
 60 files changed, 83 insertions(+), 73 deletions(-)
