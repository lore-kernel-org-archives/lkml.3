Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3I3KLd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:11:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3I3KL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.22 stable review
Date: Mon, 30 Sep 2013 11:09:37 +0100
Message-Id: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.22 stable kernel.

This version contains 104 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.22 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/DocBook/media_api.tmpl          |  4 +-
 arch/arm/mach-versatile/pci.c                 | 31 +++++++----
 arch/mips/ath79/clock.c                       |  2 +-
 arch/powerpc/kernel/align.c                   | 10 ++++
 arch/powerpc/platforms/pseries/setup.c        | 31 +++++++----
 crypto/api.c                                  |  7 ++-
 drivers/acpi/ec.c                             |  8 +++
 drivers/base/regmap/regmap.c                  |  2 +-
 drivers/bluetooth/ath3k.c                     |  8 +++
 drivers/bluetooth/btusb.c                     |  7 +++
 drivers/gpu/drm/drm_edid.c                    |  3 ++
 drivers/gpu/drm/i915/i915_reg.h               |  2 +-
 drivers/gpu/drm/i915/intel_opregion.c         |  2 +-
 drivers/gpu/drm/radeon/atombios_dp.c          |  6 +--
 drivers/gpu/drm/radeon/atombios_i2c.c         |  4 +-
 drivers/gpu/drm/radeon/evergreen.c            | 34 +++++++++---
 drivers/gpu/drm/radeon/evergreend.h           |  4 ++
 drivers/gpu/drm/radeon/ni.c                   |  9 ++--
 drivers/gpu/drm/radeon/r600.c                 |  9 ++--
 drivers/gpu/drm/radeon/radeon_atombios.c      | 13 +++--
 drivers/gpu/drm/radeon/radeon_irq_kms.c       |  8 +--
 drivers/gpu/drm/radeon/rs400.c                |  9 ++--
 drivers/gpu/drm/radeon/rv770.c                |  9 ++--
 drivers/gpu/drm/radeon/si.c                   | 32 ++++++++---
 drivers/gpu/drm/radeon/sid.h                  |  4 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c           | 58 +++++++++++++-------
 drivers/hid/hid-core.c                        | 17 ++++--
 drivers/hid/hid-input.c                       | 16 ++++--
 drivers/hid/hid-ntrig.c                       |  3 +-
 drivers/hid/hid-picolcd.c                     |  2 +-
 drivers/hid/hid-pl.c                          | 10 +++-
 drivers/iommu/intel-iommu.c                   | 72 ++++++++++++-------------
 drivers/media/video/hdpvr/hdpvr-core.c        |  9 ++--
 drivers/media/video/s5p-fimc/fimc-lite.c      |  4 +-
 drivers/media/video/s5p-fimc/fimc-mdevice.c   |  2 +-
 drivers/media/video/s5p-g2d/g2d.c             |  1 +
 drivers/mmc/host/tmio_mmc_dma.c               |  4 +-
 drivers/net/bonding/bond_main.c               |  8 ++-
 drivers/net/ethernet/realtek/8139cp.c         |  1 +
 drivers/net/macvtap.c                         | 62 ++++++++++++---------
 drivers/net/tun.c                             |  6 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   |  4 ++
 drivers/net/wireless/ath/ath9k/ath9k.h        |  5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 10 ++++
 drivers/net/wireless/ath/ath9k/recv.c         | 17 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c         |  1 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c | 12 +++--
 drivers/net/wireless/iwlegacy/4965-mac.c      |  2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |  2 +-
 drivers/of/base.c                             |  1 +
 drivers/scsi/sd.c                             | 11 ++--
 drivers/staging/comedi/drivers/dt282x.c       |  3 +-
 drivers/staging/zram/zram_drv.c               |  2 -
 drivers/staging/zram/zram_drv.h               |  5 +-
 drivers/target/target_core_cdb.c              |  9 ++--
 drivers/usb/class/cdc-wdm.c                   | 13 +++--
 drivers/usb/core/config.c                     |  3 +-
 drivers/usb/core/hub.c                        | 43 ++++++++-------
 drivers/usb/host/ehci-mxc.c                   |  2 +-
 drivers/usb/host/ohci-pci.c                   |  2 +-
 drivers/usb/host/xhci-plat.c                  |  2 +-
 drivers/usb/host/xhci.c                       | 29 +++++++++-
 drivers/usb/host/xhci.h                       |  1 +
 drivers/usb/serial/mos7720.c                  |  6 +--
 drivers/xen/events.c                          | 11 ++++
 drivers/xen/grant-table.c                     | 13 ++++-
 fs/bio.c                                      | 20 +++++--
 fs/cifs/connect.c                             |  2 +
 fs/cifs/readdir.c                             |  8 +++
 fs/fuse/dir.c                                 |  4 ++
 fs/fuse/file.c                                |  3 +-
 fs/ocfs2/extent_map.c                         |  1 -
 include/linux/hid.h                           |  4 +-
 include/linux/icmpv6.h                        |  2 +
 include/linux/ipv6.h                          |  1 +
 include/linux/rculist.h                       |  5 +-
 include/linux/usb/hcd.h                       |  2 +-
 include/media/v4l2-ctrls.h                    |  1 +
 mm/huge_memory.c                              |  2 +
 mm/memcontrol.c                               |  8 ++-
 mm/swap.c                                     | 77 ++++++++++++++++++---------
 net/bridge/br_multicast.c                     |  3 +-
 net/ceph/osd_client.c                         |  2 +
 net/ceph/osdmap.c                             |  2 +-
 net/core/neighbour.c                          | 10 ++--
 net/core/sysctl_net_core.c                    |  7 ++-
 net/ipv4/fib_trie.c                           |  5 +-
 net/ipv4/tcp_cubic.c                          | 12 +++--
 net/ipv6/addrconf.c                           | 10 ++--
 net/ipv6/icmp.c                               | 10 +++-
 net/ipv6/ip6_fib.c                            | 16 ++++--
 net/ipv6/ndisc.c                              | 16 +++---
 net/ipv6/reassembly.c                         |  5 ++
 net/ipv6/tcp_ipv6.c                           |  2 +-
 net/sched/sch_htb.c                           |  2 +-
 net/sunrpc/xdr.c                              |  9 ++--
 net/tipc/eth_media.c                          | 16 +++++-
 scripts/kernel-doc                            |  3 ++
 sound/i2c/other/ak4xxx-adda.c                 |  2 +-
 sound/isa/opti9xx/opti92x-ad1848.c            |  8 +--
 sound/pci/hda/hda_eld.c                       | 46 ++++++++--------
 sound/pci/hda/hda_intel.c                     |  1 +
 sound/pci/hda/hda_local.h                     | 27 ++++++----
 sound/pci/hda/patch_hdmi.c                    | 39 ++++++++++----
 sound/soc/codecs/mc13783.c                    |  4 ++
 sound/soc/codecs/wm8960.c                     |  6 +--
 106 files changed, 777 insertions(+), 368 deletions(-)

AceLan Kao (1):
      Bluetooth: Add support for Atheros [0cf3:e003]

Alan Stern (4):
      USB: handle LPM errors during device suspend correctly
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
      [SCSI] sd: Fix potential out-of-bounds access

Alex Deucher (8):
      drm/edid: add quirk for Medion MD30217PG
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: fix LCD record parsing
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects
      drm/radeon: fix init ordering for r600+

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Alexey Khoroshilov (1):
      hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Andrzej Hajda (2):
      DocBook: upgrade media_api DocBook version to 4.2
      v4l2: added missing mutex.h include to v4l2-ctrls.h

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Arun Kumar K (1):
      exynos4-is: Fix fimc-lite bayer formats

Cho, Yu-Chen (1):
      Bluetooth: Add support for Mediatek Bluetooth device [0e8d:763f]

Dan Carpenter (4):
      ALSA: ak4xx-adda: info leak in ak4xxx_capture_source_info()
      USB: mos7720: use GFP_ATOMIC under spinlock
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails
      tun: signedness bug in tun_get_user()

Daniel Borkmann (2):
      net: bridge: convert MLDv2 Query MRC into msecs_to_jiffies for max_delay
      net: ipv6: tcp: fix potential use after free in tcp_v6_do_rcv

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

Daniel Santos (1):
      kernel-doc: bugfix - multi-line macros

Dave Jones (1):
      8139cp: Fix skb leak in rx_status_loop failure path.

David Henningsson (1):
      ALSA: hda - hdmi: Refactor hdmi_eld into parsed_hdmi_eld

David Herrmann (1):
      HID: input: return ENODATA if reading battery attrs fails

David Vrabel (1):
      xen/events: mask events when changing their VCPU binding

Eric Dumazet (3):
      fib_trie: remove potential out of bound access
      tcp: cubic: fix overflow error in bictcp_update()
      tcp: cubic: fix bug in bictcp_acked()

Felix Fietkau (4):
      ath9k: always clear ps filter bit on new assoc
      ath9k: fix rx descriptor related race condition
      ath9k: avoid accessing MRC registers on single-chain devices
      MIPS: ath79: Fix ar933x watchdog clock

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

Hannes Frederic Sowa (3):
      ipv6: don't stop backtracking in fib6_lookup_1 if subtree does not match
      ipv6: remove max_addresses check from ipv6_create_tempaddr
      ipv6: drop packets with multiple fragmentation headers

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by the device

Helmut Schaa (1):
      ath9k_htc: Restore skb headroom when returning skb to mac80211

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Imre Deak (1):
      drm/i915: ivb: fix edp voltage swing reg val

Jakob Bornecrantz (1):
      drm/vmwgfx: Split GMR2_REMAP commands if they are to large

Jani Nikula (1):
      drm/i915: try not to lose backlight CBLV precision

Jason Wang (1):
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jeff Layton (2):
      cifs: don't instantiate new dentries in readdir for inodes that need to be revalidated immediately
      cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP

Jiri Bohac (1):
      ICMPv6: treat dest unreachable codes 5 and 6 as EACCES, not EPROTO

Jiri Kosina (1):
      HID: battery: don't do DMA from stack

Johan Hovold (1):
      USB: mos7720: fix big-endian control requests

Johannes Berg (1):
      iwlwifi: dvm: don't send BT_CONFIG on devices w/o Bluetooth

John W. Linville (1):
      brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()

Kees Cook (5):
      HID: validate HID report id size
      HID: pantherlord: validate output report details
      HID: ntrig: validate feature report details
      HID: picolcd_core: validate output report details
      HID: check for NULL field when setting values

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Lan Tianyu (2):
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Luis Henriques (1):
      Revert "zram: use zram->lock to protect zram_free_page() in swap free notify path"

Maxim Patlasov (1):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Nicholas Bellinger (1):
      target: Fix trailing ASCII space usage in INQUIRY vendor+model

Noguchi Kazutosi (1):
      Bluetooth: Add support for Foxconn/Hon Hai [0489:e04d]

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Paul Bolle (1):
      regmap: silence GCC warning

Peter Maydell (2):
      ARM: PCI: versatile: Fix map_irq function to match hardware
      ARM: PCI: versatile: Fix SMAP register offsets

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Roland Dreier (1):
      [SCSI] sg: Fix user memory corruption when SG_IO is interrupted by a signal

Roman Gushchin (1):
      net: check net.core.somaxconn sysctl values

Sachin Kamat (1):
      s5p-g2d: Fix registration failure

Sage Weil (1):
      libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc

Sarah Sharp (1):
      xhci-plat: Don't enable legacy PCI interrupts.

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Sergey Senozhatsky (1):
      radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Stanislaw Gruszka (1):
      iwl4965: fix rfkill set state regression

Steffen Trumtrar (1):
      ASoC: mc13783: add spi errata fix

Sujith Manoharan (1):
      Bluetooth: ath3k: Add support for ID 0x13d3/0x3402

Sylwester Nawrocki (1):
      exynos4-is: Fix entity unregistration on error path

Takashi Iwai (2):
      ALSA: opti9xx: Fix conflicting driver object name
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()

Thomas Graf (1):
      ipv6: Don't depend on per socket memory for neighbour discovery messages

Thomas Loo (1):
      Bluetooth: ath3k: Add support for Fujitsu Lifebook UH5x2 [04c5:1330]

Trond Myklebust (1):
      SUNRPC: Fix memory corruption issue on 32-bit highmem systems

Vaidyanathan Srinivasan (1):
      powerpc: Default arch idle could cede processor on pseries

Veaceslav Falico (2):
      neighbour: populate neigh_parms on alloc before calling ndo_neigh_setup
      bonding: modify only neigh_parms owned by us

Ying Xue (1):
      tipc: fix lockdep warning during bearer initialization

majianpeng (1):
      libceph: unregister request in __map_request failed and nofail == false

stephen hemminger (1):
      htb: fix sign extension bug
