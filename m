Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967210Ab3HIB6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966961Ab3HIB6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/102] 3.10.6-stable review
Date: Thu,  8 Aug 2013 18:56:36 -0700
Message-Id: <20130809015010.208118575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.6 release.
There are 102 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Aug 11 01:46:31 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.6-rc1

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

David Spinadel <david.spinadel@intel.com>
    iwlwifi: mvm: set SSID bits for passive channels

Jack Morgenstein <jackm@dev.mellanox.co.il>
    net/mlx4_core: VFs must ignore the enable_64b_cqe_eqe module param

Or Gerlitz <ogerlitz@mellanox.com>
    net/mlx4_core: Don't give VFs MAC addresses which are derived from the PF MAC

Neil Horman <nhorman@tuxdriver.com>
    8139cp: Add dma_mapping_error checking

Joe Perches <joe@perches.com>
    ndisc: Add missing inline to ndisc_addr_option_pad

Dan Carpenter <dan.carpenter@oracle.com>
    net_sched: info leak in atm_tc_dump_class()

Eric Dumazet <edumazet@google.com>
    atl1c: use custom skb allocator

Dan Carpenter <dan.carpenter@oracle.com>
    af_key: more info leaks in pfkey messages

David S. Miller <davem@davemloft.net>
    net_sched: Fix stack info leak in cbq_dump_wrr().

Stanislaw Gruszka <sgruszka@redhat.com>
    genetlink: release cb_lock before requesting additional module

Eric Dumazet <edumazet@google.com>
    usbnet: do not pretend to support SG/TSO

Hannes Frederic Sowa <hannes@stressinduktion.org>
    ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Enable RX scatter for flows steered by RFS

Michal Tesar <mtesar@redhat.com>
    sysctl net: Keep tcp_syn_retries inside the boundary

Dan Carpenter <dan.carpenter@oracle.com>
    arcnet: cleanup sizeof parameter

Christian Eggers <ceggers@gmx.de>
    spi: spi-davinci: Fix direction in dma_map_single()

Neil Horman <nhorman@tuxdriver.com>
    x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset

Oleg Nesterov <oleg@redhat.com>
    userns: unshare_userns(&cred) should not populate cred on failure

Shaohua Li <shli@kernel.org>
    workqueue: copy workqueue_attrs with all fields

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/bitops: fix find_next_bit_left

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390: add support for IBM zBC12 machine

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: make SDVO TV-out work for multifunction devices

Liu Bo <bo.li.liu@oracle.com>
    Btrfs: fix crash regarding to ulist_add_merge

H.J. Lu <hjl.tools@gmail.com>
    x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Christian König <christian.koenig@amd.com>
    drm/radeon: never unpin UVD bo v3

Li Zefan <lizefan@huawei.com>
    cgroup: fix umount vs cgroup_cfts_commit() race

Dan Carpenter <dan.carpenter@oracle.com>
    fanotify: info leak in copy_event_to_user()

Stéphane Marchesin <marcheu@chromium.org>
    drm/i915: Preserve the DDI_A_4_LANES bit from the bios

Roger Pau Monne <roger.pau@citrix.com>
    xen-blkfront: use a different scatterlist for each request

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Disable dma rings for bo moves on r6xx

Yinghai Lu <yinghai@kernel.org>
    PCI: Retry allocation of only the resource type that failed

Yinghai Lu <yinghai@kernel.org>
    PCI: pciehp: Fix null pointer deref when hot-removing SR-IOV device

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: Quickly notice prediction failure for repeat mode"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    cpufreq: Fix cpufreq driver module refcount balance after suspend/resume

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "cpuidle: Quickly notice prediction failure in general case"

Lan Tianyu <tianyu.lan@intel.com>
    ACPI / battery: Fix parsing _BIX return value

Jiang Liu <liuj97@gmail.com>
    zram: protect sysfs handler from invalid memory access

Jiang Liu <liuj97@gmail.com>
    zram: avoid access beyond the zram device

Jiang Liu <liuj97@gmail.com>
    zram: avoid double free in function zram_bvec_write()

Jiang Liu <liuj97@gmail.com>
    zram: destroy all devices on error recovery path in zram_init()

Jiang Liu <liuj97@gmail.com>
    zram: use zram->lock to protect zram_free_page() in swap free notify path

Jiang Liu <liuj97@gmail.com>
    zram: avoid invalid memory access in zram_exit()

Avinash Patil <patila@marvell.com>
    mwifiex: fix wrong data rates in P2P client

Avinash Patil <patila@marvell.com>
    mwifiex: check for bss_role instead of bss_mode for STA operations

Tomasz Moń <desowin@gmail.com>
    mwifiex: Add missing endian conversion.

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: fix stop queue

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix kfree oops in gss-proxy code

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix gss_rpc_upcall create error

J. Bruce Fields <bfields@redhat.com>
    svcrpc: fix gss-proxy xdr decoding oops

Adam Lee <adam8157@gmail.com>
    Bluetooth: fix wrong use of PTR_ERR() in btusb

Cho, Yu-Chen <acho@suse.com>
    Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Atheros [0cf3:e003]

AceLan Kao <acelan.kao@canonical.com>
    Bluetooth: Add support for Atheros [0cf3:3121]

Sujith Manoharan <sujith@msujith.org>
    Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Stanislaw Gruszka <sgruszka@redhat.com>
    Bluetooth: ath3k: don't use stack memory for DMA

Thomas Loo <tloo@saltstorm.net>
    Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Jaganath Kanakkassery <jaganath.k@samsung.com>
    Bluetooth: Fix invalid length check in l2cap_information_rsp()

Larry Finger <Larry.Finger@lwfinger.net>
    ath: wil6210: Fix build error

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Stanislaw Gruszka <sgruszka@redhat.com>
    mac80211: fix monitor interface suspend crash regression

Johannes Berg <johannes@sipsolutions.net>
    mac80211: fix ethtool stats for non-station interfaces

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix duplicate retransmission detection

Felix Fietkau <nbd@openwrt.org>
    mac80211/minstrel_ht: fix cck rate sampling

Felix Fietkau <nbd@openwrt.org>
    mac80211/minstrel: fix NULL pointer dereference issue

Michal Kazior <michal.kazior@tieto.com>
    nl80211: fix mgmt tx status and testmode reporting for netns

Oleksij Rempel <linux@rempel-privat.de>
    ath9k_htc: reboot firmware if it was loaded

Oleksij Rempel <linux@rempel-privat.de>
    ath9k_htc: do some initial hardware configuration

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: fix flushing not started aggregation sessions

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: add DELL SKU for 5150 HMC

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: mvm: refuse connection to APs with BI < 16

David Spinadel <david.spinadel@intel.com>
    iwlwifi: mvm: fix bug in scan ssid

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix L2P BA ressources leak

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix pointer casts

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix race in led handling

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix device-type detection

Johan Hovold <jhovold@gmail.com>
    USB: mos7840: fix race in register handling

Lars-Peter Clausen <lars@metafoo.de>
    dma: pl330: Fix cyclic transfers

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial/mxs-auart: increase time to wait for transmitter to become idle

Axel Lin <axel.lin@ingics.com>
    serial: arc_uart: Fix module alias

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    serial/mxs-auart: fix race condition in interrupt handler

Vinod Koul <vinod.koul@intel.com>
    ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix missing fixup for Mac Mini with STAC9221

Vivien Didelot <vivien.didelot@savoirfairelinux.com>
    hwmon: (max6697) fix MAX6581 ideality

Thomas Bogendoerfer <tsbogend@alpha.franken.de>
    parisc: Fix interrupt routing for C8000 serial ports

John David Anglin <dave.anglin@bell.net>
    parisc: Fix cache routines to ignore vma's with an invalid pfn

Alex Ivanov <gnidorah@p0n4ik.tk>
    parisc: agp/parisc-agp: allow binding of user memory to the AGP GART

Robert Jennings <rcj@linux.vnet.ibm.com>
    powerpc: VPHN topology change updates all siblings

Will Deacon <will.deacon@arm.com>
    ARM: 7791/1: a.out: remove partial a.out support

Catalin Marinas <catalin.marinas@arm.com>
    ARM: 7790/1: Fix deferred mm switch on VIVT processors

Will Deacon <will.deacon@arm.com>
    ARM: 7784/1: mm: ensure SMP alternates assemble to exactly 4 bytes with Thumb-2

Aaro Koskinen <aaro.koskinen@iki.fi>
    powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix nommu builds with 48be69a02 (ARM: move signal handlers into a vdso-like page)

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: fix a cockup in 48be69a02 (ARM: move signal handlers into a vdso-like page)

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: make vectors page inaccessible from userspace

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: move signal handlers into a vdso-like page

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: allow kuser helpers to be removed from the vector page

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: update FIQ support for relocation of vectors

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: use linker magic for vectors and vector stubs

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: move vector stubs

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: poison memory between kuser helpers

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: poison the vectors page


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm/Kconfig                                   |   4 +-
 arch/arm/include/asm/a.out-core.h                  |  45 -------
 arch/arm/include/asm/elf.h                         |   6 +
 arch/arm/include/asm/mmu.h                         |   3 +
 arch/arm/include/asm/mmu_context.h                 |  20 ++-
 arch/arm/include/asm/page.h                        |   2 +
 arch/arm/include/asm/processor.h                   |   4 -
 arch/arm/include/asm/thread_info.h                 |   1 -
 arch/arm/include/uapi/asm/Kbuild                   |   1 -
 arch/arm/include/uapi/asm/a.out.h                  |  34 -----
 arch/arm/kernel/entry-armv.S                       | 103 +++++++-------
 arch/arm/kernel/fiq.c                              |  19 ++-
 arch/arm/kernel/process.c                          |  46 ++++++-
 arch/arm/kernel/signal.c                           |  52 ++++++-
 arch/arm/kernel/signal.h                           |  12 --
 arch/arm/kernel/traps.c                            |  46 ++++---
 arch/arm/kernel/vmlinux.lds.S                      |  17 +++
 arch/arm/mm/Kconfig                                |  34 +++++
 arch/arm/mm/mmu.c                                  |  14 +-
 arch/arm/mm/proc-v7-2level.S                       |   2 +-
 arch/arm/mm/proc-v7-3level.S                       |   2 +-
 arch/arm/mm/proc-v7.S                              |  11 +-
 arch/parisc/include/asm/parisc-device.h            |   3 +
 arch/parisc/kernel/cache.c                         | 135 ++++++++++---------
 arch/parisc/kernel/inventory.c                     |   1 +
 arch/powerpc/include/asm/smp.h                     |   4 +
 arch/powerpc/mm/numa.c                             |  59 +++++---
 arch/s390/Kconfig                                  |   7 +-
 arch/s390/include/asm/bitops.h                     |   2 +-
 arch/s390/kernel/setup.c                           |   1 +
 arch/s390/mm/init.c                                |   1 +
 arch/s390/oprofile/init.c                          |   2 +-
 arch/x86/kernel/early-quirks.c                     |  14 +-
 arch/x86/kernel/i387.c                             |   2 +-
 drivers/acpi/battery.c                             |   2 +
 drivers/block/xen-blkfront.c                       |  36 +++--
 drivers/bluetooth/ath3k.c                          |  46 +++++--
 drivers/bluetooth/btusb.c                          |  21 ++-
 drivers/char/agp/parisc-agp.c                      |   6 +-
 drivers/cpufreq/cpufreq.c                          |  19 +--
 drivers/cpuidle/governors/menu.c                   | 106 +--------------
 drivers/dma/pl330.c                                |  93 +++++++++----
 drivers/gpu/drm/i915/intel_ddi.c                   |  10 +-
 drivers/gpu/drm/i915/intel_display.c               |   8 +-
 drivers/gpu/drm/i915/intel_drv.h                   |   2 +-
 drivers/gpu/drm/radeon/radeon.h                    |   3 +-
 drivers/gpu/drm/radeon/radeon_asic.c               |   8 +-
 drivers/gpu/drm/radeon/radeon_fence.c              |   2 +-
 drivers/gpu/drm/radeon/radeon_uvd.c                | 100 +++++++-------
 drivers/gpu/drm/radeon/rv770.c                     |   2 +-
 drivers/hwmon/max6697.c                            |   4 +-
 drivers/macintosh/windfarm_rm31.c                  |  18 +--
 drivers/net/arcnet/arcnet.c                        |   2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |   3 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  40 +++++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |   3 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |  11 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   2 +-
 drivers/net/ethernet/realtek/8139cp.c              |  48 ++++++-
 drivers/net/ethernet/sfc/filter.c                  |   4 +-
 drivers/net/usb/ax88179_178a.c                     |   9 +-
 drivers/net/usb/smsc75xx.c                         |  12 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   1 +
 drivers/net/wireless/ath/wil6210/debugfs.c         |   4 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h     |   1 -
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |  16 +++
 drivers/net/wireless/iwlwifi/mvm/scan.c            |  15 +--
 drivers/net/wireless/iwlwifi/mvm/sta.c             |  19 ++-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |   1 +
 drivers/net/wireless/mwifiex/cfg80211.c            |   4 +-
 drivers/net/wireless/mwifiex/cfp.c                 |   3 +-
 drivers/net/wireless/mwifiex/join.c                |   6 +-
 drivers/net/wireless/mwifiex/sdio.c                |   4 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |  18 ++-
 drivers/parisc/iosapic.c                           |  38 ++++--
 drivers/pci/hotplug/pciehp_pci.c                   |   9 +-
 drivers/pci/setup-bus.c                            |  69 +++++++++-
 drivers/spi/spi-davinci.c                          |   2 +-
 drivers/staging/zram/zram_drv.c                    |  38 ++++--
 drivers/staging/zram/zram_drv.h                    |   5 +-
 drivers/staging/zram/zram_sysfs.c                  |   2 +
 drivers/tty/serial/8250/8250_gsc.c                 |   3 +-
 drivers/tty/serial/arc_uart.c                      |   2 +-
 drivers/tty/serial/mxs-auart.c                     |  38 +++---
 drivers/usb/serial/mos7840.c                       | 150 ++++++++++++---------
 fs/btrfs/ulist.c                                   |  15 +++
 fs/notify/fanotify/fanotify_user.c                 |   1 +
 include/linux/tick.h                               |   6 -
 include/net/ndisc.h                                |   2 +-
 kernel/cgroup.c                                    |   9 +-
 kernel/time/tick-sched.c                           |   9 +-
 kernel/user_namespace.c                            |  13 +-
 kernel/workqueue.c                                 |  12 ++
 net/bluetooth/l2cap_core.c                         |   2 +-
 net/ipv4/sysctl_net_ipv4.c                         |   6 +-
 net/ipv6/ip6mr.c                                   |   5 +
 net/key/af_key.c                                   |   4 +
 net/mac80211/cfg.c                                 |   2 +
 net/mac80211/pm.c                                  |   7 +-
 net/mac80211/rc80211_minstrel.c                    |   3 +-
 net/mac80211/rc80211_minstrel_ht.c                 |  10 +-
 net/mac80211/rx.c                                  |  10 +-
 net/netlink/genetlink.c                            |   2 +
 net/sched/sch_atm.c                                |   1 +
 net/sched/sch_cbq.c                                |   1 +
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |   3 +-
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |   9 +-
 net/wireless/nl80211.c                             |   7 +-
 sound/core/compress_offload.c                      |   2 +-
 sound/pci/hda/hda_auto_parser.c                    |   2 +-
 sound/pci/hda/patch_sigmatel.c                     |   1 +
 114 files changed, 1178 insertions(+), 753 deletions(-)


