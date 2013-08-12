Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3HLCKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:10:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HLCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:10:33 -0400
Date: Sun, 11 Aug 2013 19:11:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.6
Message-ID: <20130812021156.GA15104@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.6 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                           |    4=20
 arch/arm/Kconfig                                   |    4=20
 arch/arm/include/asm/a.out-core.h                  |   45 ------
 arch/arm/include/asm/elf.h                         |    6=20
 arch/arm/include/asm/mmu.h                         |    3=20
 arch/arm/include/asm/mmu_context.h                 |   20 ++
 arch/arm/include/asm/page.h                        |    2=20
 arch/arm/include/asm/processor.h                   |    4=20
 arch/arm/include/asm/thread_info.h                 |    1=20
 arch/arm/include/uapi/asm/Kbuild                   |    1=20
 arch/arm/include/uapi/asm/a.out.h                  |   34 ----
 arch/arm/kernel/entry-armv.S                       |  103 +++++++-------
 arch/arm/kernel/fiq.c                              |   19 +-
 arch/arm/kernel/process.c                          |   46 ++++++
 arch/arm/kernel/signal.c                           |   52 ++++++-
 arch/arm/kernel/signal.h                           |   12 -
 arch/arm/kernel/traps.c                            |   46 +++---
 arch/arm/kernel/vmlinux.lds.S                      |   17 ++
 arch/arm/mm/Kconfig                                |   34 ++++
 arch/arm/mm/mmu.c                                  |   14 +
 arch/arm/mm/proc-v7-2level.S                       |    2=20
 arch/arm/mm/proc-v7-3level.S                       |    2=20
 arch/arm/mm/proc-v7.S                              |   11 -
 arch/parisc/include/asm/parisc-device.h            |    3=20
 arch/parisc/kernel/cache.c                         |  135 +++++++++-------=
--
 arch/parisc/kernel/inventory.c                     |    1=20
 arch/powerpc/include/asm/smp.h                     |    4=20
 arch/powerpc/mm/numa.c                             |   59 ++++++--
 arch/s390/Kconfig                                  |    7=20
 arch/s390/include/asm/bitops.h                     |    2=20
 arch/s390/kernel/setup.c                           |    1=20
 arch/s390/mm/init.c                                |    1=20
 arch/s390/oprofile/init.c                          |    2=20
 arch/x86/kernel/early-quirks.c                     |   14 +
 arch/x86/kernel/i387.c                             |    2=20
 drivers/acpi/battery.c                             |    2=20
 drivers/block/xen-blkfront.c                       |   36 ++---
 drivers/bluetooth/ath3k.c                          |   46 +++++-
 drivers/bluetooth/btusb.c                          |   21 +-
 drivers/char/agp/parisc-agp.c                      |    6=20
 drivers/char/hw_random/bcm2835-rng.c               |    2=20
 drivers/cpufreq/cpufreq.c                          |   19 +-
 drivers/cpuidle/governors/menu.c                   |  106 --------------
 drivers/dma/pl330.c                                |   93 +++++++++----
 drivers/gpu/drm/i915/intel_ddi.c                   |   10 -
 drivers/gpu/drm/i915/intel_display.c               |    8 -
 drivers/gpu/drm/i915/intel_drv.h                   |    2=20
 drivers/gpu/drm/radeon/radeon.h                    |    3=20
 drivers/gpu/drm/radeon/radeon_asic.c               |    8 -
 drivers/gpu/drm/radeon/radeon_fence.c              |    2=20
 drivers/gpu/drm/radeon/radeon_uvd.c                |  100 ++++++--------
 drivers/gpu/drm/radeon/rv770.c                     |    2=20
 drivers/hwmon/max6697.c                            |    4=20
 drivers/macintosh/windfarm_rm31.c                  |   18 +-
 drivers/net/arcnet/arcnet.c                        |    2=20
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    3=20
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   40 +++++
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_82598.c |    3=20
 drivers/net/ethernet/mellanox/mlx4/fw.c            |   11 -
 drivers/net/ethernet/mellanox/mlx4/main.c          |    2=20
 drivers/net/ethernet/realtek/8139cp.c              |   48 ++++++
 drivers/net/ethernet/sfc/filter.c                  |    4=20
 drivers/net/usb/ax88179_178a.c                     |    9 -
 drivers/net/usb/smsc75xx.c                         |   12 -
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    4=20
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    1=20
 drivers/net/wireless/ath/wil6210/debugfs.c         |    4=20
 drivers/net/wireless/iwlwifi/dvm/main.c            |    2=20
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h     |    1=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        |   16 ++
 drivers/net/wireless/iwlwifi/mvm/scan.c            |   15 --
 drivers/net/wireless/iwlwifi/mvm/sta.c             |   19 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |    1=20
 drivers/net/wireless/mwifiex/cfg80211.c            |    4=20
 drivers/net/wireless/mwifiex/cfp.c                 |    3=20
 drivers/net/wireless/mwifiex/join.c                |    6=20
 drivers/net/wireless/mwifiex/sdio.c                |    4=20
 drivers/net/wireless/rt2x00/rt2x00queue.c          |   18 +-
 drivers/parisc/iosapic.c                           |   38 +++--
 drivers/pci/hotplug/pciehp_pci.c                   |    9 +
 drivers/pci/setup-bus.c                            |   69 +++++++++
 drivers/spi/spi-davinci.c                          |    2=20
 drivers/staging/zram/zram_drv.c                    |   38 +++--
 drivers/staging/zram/zram_drv.h                    |    5=20
 drivers/staging/zram/zram_sysfs.c                  |    2=20
 drivers/tty/serial/8250/8250_gsc.c                 |    3=20
 drivers/tty/serial/arc_uart.c                      |    2=20
 drivers/tty/serial/mxs-auart.c                     |   38 +++--
 drivers/usb/serial/mos7840.c                       |  150 ++++++++++++----=
-----
 fs/btrfs/ulist.c                                   |   15 ++
 fs/notify/fanotify/fanotify_user.c                 |    1=20
 include/linux/tick.h                               |    6=20
 include/linux/user_namespace.h                     |    1=20
 include/net/ndisc.h                                |    2=20
 kernel/cgroup.c                                    |    9 +
 kernel/time/tick-sched.c                           |    9 -
 kernel/user_namespace.c                            |   17 +-
 kernel/workqueue.c                                 |   12 +
 net/ipv4/sysctl_net_ipv4.c                         |    6=20
 net/ipv6/ip6mr.c                                   |    5=20
 net/key/af_key.c                                   |    4=20
 net/mac80211/cfg.c                                 |    2=20
 net/mac80211/pm.c                                  |    7=20
 net/mac80211/rc80211_minstrel.c                    |    3=20
 net/mac80211/rc80211_minstrel_ht.c                 |   10 +
 net/mac80211/rx.c                                  |   10 +
 net/netlink/genetlink.c                            |    2=20
 net/sched/sch_atm.c                                |    1=20
 net/sched/sch_cbq.c                                |    1=20
 net/sunrpc/auth_gss/gss_rpc_upcall.c               |    3=20
 net/sunrpc/auth_gss/gss_rpc_xdr.c                  |    9 -
 net/wireless/nl80211.c                             |    7=20
 sound/core/compress_offload.c                      |    2=20
 sound/pci/hda/hda_auto_parser.c                    |    2=20
 sound/pci/hda/patch_sigmatel.c                     |    1=20
 115 files changed, 1183 insertions(+), 753 deletions(-)

Aaro Koskinen (1):
      powerpc/windfarm: Fix noisy slots-fan on Xserve (rm31)

AceLan Kao (2):
      Bluetooth: Add support for Atheros [0cf3:3121]
      Bluetooth: Add support for Atheros [0cf3:e003]

Adam Lee (1):
      Bluetooth: fix wrong use of PTR_ERR() in btusb

Alex Deucher (1):
      drm/radeon: Disable dma rings for bo moves on r6xx

Alex Ivanov (1):
      parisc: agp/parisc-agp: allow binding of user memory to the AGP GART

Arnd Bergmann (1):
      hwrng: bcm2835: fix MODULE_LICENSE tag

Avinash Patil (2):
      mwifiex: check for bss_role instead of bss_mode for STA operations
      mwifiex: fix wrong data rates in P2P client

Axel Lin (1):
      serial: arc_uart: Fix module alias

Ben Hutchings (1):
      sfc: Enable RX scatter for flows steered by RFS

Catalin Marinas (1):
      ARM: 7790/1: Fix deferred mm switch on VIVT processors

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Christian Eggers (1):
      spi: spi-davinci: Fix direction in dma_map_single()

Christian K=C3=B6nig (1):
      drm/radeon: never unpin UVD bo v3

Dan Carpenter (4):
      fanotify: info leak in copy_event_to_user()
      arcnet: cleanup sizeof parameter
      af_key: more info leaks in pfkey messages
      net_sched: info leak in atm_tc_dump_class()

Daniel Vetter (1):
      drm/i915: make SDVO TV-out work for multifunction devices

David S. Miller (1):
      net_sched: Fix stack info leak in cbq_dump_wrr().

David Spinadel (2):
      iwlwifi: mvm: fix bug in scan ssid
      iwlwifi: mvm: set SSID bits for passive channels

Emmanuel Grumbach (2):
      iwlwifi: mvm: fix L2P BA ressources leak
      iwlwifi: add DELL SKU for 5150 HMC

Eric Dumazet (2):
      usbnet: do not pretend to support SG/TSO
      atl1c: use custom skb allocator

Felix Fietkau (2):
      mac80211/minstrel: fix NULL pointer dereference issue
      mac80211/minstrel_ht: fix cck rate sampling

Greg Kroah-Hartman (1):
      Linux 3.10.6

H.J. Lu (1):
      x86, fpu: correct the asm constraints for fxsave, unbreak mxcsr.daz

Hannes Frederic Sowa (1):
      ipv6: take rtnl_lock and mark mrt6 table as freed on namespace cleanup

Heiko Carstens (1):
      s390: add support for IBM zBC12 machine

J. Bruce Fields (3):
      svcrpc: fix gss-proxy xdr decoding oops
      svcrpc: fix gss_rpc_upcall create error
      svcrpc: fix kfree oops in gss-proxy code

Jack Morgenstein (1):
      net/mlx4_core: VFs must ignore the enable_64b_cqe_eqe module param

Jacob Keller (1):
      ixgbe: Fix Tx Hang issue with lldpad on 82598EB

Jiang Liu (6):
      zram: avoid invalid memory access in zram_exit()
      zram: use zram->lock to protect zram_free_page() in swap free notify =
path
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid double free in function zram_bvec_write()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access

Joe Perches (1):
      ndisc: Add missing inline to ndisc_addr_option_pad

Johan Hovold (4):
      USB: mos7840: fix race in register handling
      USB: mos7840: fix device-type detection
      USB: mos7840: fix race in led handling
      USB: mos7840: fix pointer casts

Johannes Berg (5):
      iwlwifi: mvm: refuse connection to APs with BI < 16
      iwlwifi: mvm: fix flushing not started aggregation sessions
      mac80211: fix duplicate retransmission detection
      mac80211: fix ethtool stats for non-station interfaces
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

John David Anglin (1):
      parisc: Fix cache routines to ignore vma's with an invalid pfn

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Larry Finger (1):
      ath: wil6210: Fix build error

Lars-Peter Clausen (1):
      dma: pl330: Fix cyclic transfers

Li Zefan (1):
      cgroup: fix umount vs cgroup_cfts_commit() race

Liu Bo (1):
      Btrfs: fix crash regarding to ulist_add_merge

Martin Schwidefsky (1):
      s390/bitops: fix find_next_bit_left

Michal Kazior (1):
      nl80211: fix mgmt tx status and testmode reporting for netns

Michal Tesar (1):
      sysctl net: Keep tcp_syn_retries inside the boundary

Neil Horman (2):
      x86/iommu/vt-d: Expand interrupt remapping quirk to cover x58 chipset
      8139cp: Add dma_mapping_error checking

Oleg Nesterov (2):
      userns: unshare_userns(&cred) should not populate cred on failure
      userns: limit the maximum depth of user_namespace->parent chain

Oleksij Rempel (2):
      ath9k_htc: do some initial hardware configuration
      ath9k_htc: reboot firmware if it was loaded

Or Gerlitz (1):
      net/mlx4_core: Don't give VFs MAC addresses which are derived from th=
e PF MAC

Rafael J. Wysocki (3):
      Revert "cpuidle: Quickly notice prediction failure in general case"
      cpufreq: Fix cpufreq driver module refcount balance after suspend/res=
ume
      Revert "cpuidle: Quickly notice prediction failure for repeat mode"

Robert Jennings (1):
      powerpc: VPHN topology change updates all siblings

Roger Pau Monne (1):
      xen-blkfront: use a different scatterlist for each request

Russell King (10):
      ARM: poison the vectors page
      ARM: poison memory between kuser helpers
      ARM: move vector stubs
      ARM: use linker magic for vectors and vector stubs
      ARM: update FIQ support for relocation of vectors
      ARM: allow kuser helpers to be removed from the vector page
      ARM: move signal handlers into a vdso-like page
      ARM: make vectors page inaccessible from userspace
      ARM: fix a cockup in 48be69a02 (ARM: move signal handlers into a vdso=
-like page)
      ARM: fix nommu builds with 48be69a02 (ARM: move signal handlers into =
a vdso-like page)

Shaohua Li (1):
      workqueue: copy workqueue_attrs with all fields

Stanislaw Gruszka (4):
      mac80211: fix monitor interface suspend crash regression
      Bluetooth: ath3k: don't use stack memory for DMA
      rt2x00: fix stop queue
      genetlink: release cb_lock before requesting additional module

St=C3=A9phane Marchesin (1):
      drm/i915: Preserve the DDI_A_4_LANES bit from the bios

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Takashi Iwai (1):
      ALSA: hda - Fix missing fixup for Mac Mini with STAC9221

Thomas Bogendoerfer (1):
      parisc: Fix interrupt routing for C8000 serial ports

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Tomasz Mo=C5=84 (1):
      mwifiex: Add missing endian conversion.

Uwe Kleine-K=C3=B6nig (2):
      serial/mxs-auart: fix race condition in interrupt handler
      serial/mxs-auart: increase time to wait for transmitter to become idle

Vinod Koul (1):
      ALSA: compress: fix the return value for SNDRV_COMPRESS_VERSION

Vivien Didelot (1):
      hwmon: (max6697) fix MAX6581 ideality

Will Deacon (2):
      ARM: 7784/1: mm: ensure SMP alternates assemble to exactly 4 bytes wi=
th Thumb-2
      ARM: 7791/1: a.out: remove partial a.out support

Yinghai Lu (2):
      PCI: pciehp: Fix null pointer deref when hot-removing SR-IOV device
      PCI: Retry allocation of only the resource type that failed


--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCERsAAoJEDjbvchgkmk+PGMP/326OG7SvZ4fG1MgV43ug2z3
nTgA2xG33GqiQq3hduyhTyDa/J4vSZ3JxYcGg8BO39lNt87llgn39/AbaVYJqZBm
rsp8BQD+Es8hsBLrcWMFqT9Hd8JVQAnfuasGRVBtbxdU/+PIpxBJZOonymRtZX7I
cj2r7aGkcoiHfCGvTiaukk3EQ/f8IBtUFAqHP2sxHVLEBEv6VpMvCGk5XWYZ6GKs
hLOQHhM58oGmTWj1ZOHnghseDo3TXCnvihzjIBFswvRuJail5PFEv+Hc+Y3P+zu4
+C0XhtG5bGeXMT9A5/Hnc1pBRnrzO8jeBiZSG/IbCoOYeBQRCYPwmeAhYO5WdgXA
NA57vHzv77X4DUahhzDzRnClSMpEtQCv1iUgWeL2MaJocLCr+ddblEWGcrZF1LsI
8NkpganPQpUeOADEh+j8OAk0mfE8G6HUCzbuR5eolF0Qq9WHqWGwQeLJrWVvRsyl
r8Menz8j3ni4VBNeB5Icft46HAmkTfIzmhgRYsDDVai39faQmbmPUjjwAFxL4c0x
5WK5ZhIWhes4cOIfCvtcxvm3PwLr+mR/h+MP/+KDdwMXlnmNZWpvsWMVX2V4TqlV
GG/bMv7EXP9QWkfFc2bKkyTMc6dCxa280o9+HYlwpepKFbvXjoIQ0918RMkHETO7
LyH50ekICxmFS5W9vEvO
=w0hA
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
