Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaAPJzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:55:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaAPJzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:55:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.29
Date: Thu, 16 Jan 2014 09:55:03 +0000
Message-Id: <1389866104-12234-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.29 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.28 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/kernel-parameters.txt               |  3 +
 Makefile                                          |  2 +-
 arch/arm/kernel/traps.c                           |  8 ++-
 arch/arm/mach-omap2/omap_hwmod.c                  | 43 ++++++++++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c        | 13 +---
 arch/arm/mach-pxa/reset.c                         |  8 ++-
 arch/powerpc/include/asm/exception-64s.h          |  2 +-
 arch/powerpc/kernel/head_64.S                     |  1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c               |  6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c               |  4 ++
 arch/sh/lib/Makefile                              |  2 +-
 arch/x86/include/asm/fpu-internal.h               | 13 ++--
 drivers/ata/libata-core.c                         |  4 ++
 drivers/ata/libata-scsi.c                         | 21 +++++++
 drivers/dma/Kconfig                               |  1 +
 drivers/gpio/gpio-msm-v2.c                        |  4 +-
 drivers/gpu/drm/drm_edid.c                        |  8 +++
 drivers/gpu/drm/i915/i915_dma.c                   |  8 +++
 drivers/gpu/drm/radeon/ni.c                       | 20 +++++--
 drivers/gpu/drm/radeon/rs690.c                    | 11 ++++
 drivers/hid/hid-core.c                            |  2 +-
 drivers/idle/intel_idle.c                         | 38 ++++++++++++
 drivers/infiniband/hw/qib/qib_user_sdma.c         |  6 +-
 drivers/input/input.c                             |  4 ++
 drivers/input/touchscreen/usbtouchscreen.c        | 22 +++++--
 drivers/md/dm-mpath.c                             | 18 +++++-
 drivers/media/dvb/frontends/cxd2820r_core.c       |  4 +-
 drivers/net/ethernet/broadcom/tg3.c               |  3 +
 drivers/net/ethernet/calxeda/xgmac.c              |  2 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |  2 +-
 drivers/net/ethernet/tehuti/tehuti.c              |  1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       |  2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  2 +-
 drivers/net/hamradio/hdlcdrv.c                    |  2 +
 drivers/net/hamradio/yam.c                        |  1 +
 drivers/net/hyperv/netvsc_drv.c                   |  1 -
 drivers/net/macvtap.c                             | 20 +++----
 drivers/net/tun.c                                 |  2 +
 drivers/net/usb/dm9601.c                          | 34 ++++++++---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c       | 52 +++++++++++++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c     | 25 +++++---
 drivers/net/wireless/ath/ath9k/main.c             |  5 +-
 drivers/net/wireless/rtlwifi/pci.c                |  4 +-
 drivers/staging/comedi/drivers/pcmuio.c           | 11 ++--
 drivers/staging/comedi/drivers/ssv_dnp.c          |  6 +-
 drivers/staging/iio/adc/ad7887_core.c             | 16 ++++-
 drivers/staging/zram/zram_sysfs.c                 | 25 +++++---
 drivers/target/iscsi/iscsi_target.c               | 26 ++++----
 drivers/tty/serial/pmac_zilog.c                   |  3 +
 drivers/usb/class/cdc-wdm.c                       |  8 +--
 drivers/usb/host/xhci-pci.c                       |  7 ++-
 drivers/watchdog/sc1200wdt.c                      |  3 +-
 fs/ceph/addr.c                                    |  8 ++-
 fs/ceph/mds_client.c                              |  8 ++-
 fs/ext2/super.c                                   |  1 +
 fs/ext4/ext4.h                                    | 10 ++++
 fs/ext4/extents.c                                 | 43 ++++++++-----
 fs/ext4/mballoc.c                                 | 17 ++++--
 fs/ext4/super.c                                   |  4 +-
 fs/gfs2/aops.c                                    | 30 ++++++++++
 fs/gfs2/ops_fstype.c                              | 12 +++-
 fs/jbd2/transaction.c                             |  6 +-
 include/drm/drm_pciids.h                          |  2 +-
 include/linux/net.h                               |  2 +-
 include/linux/netdevice.h                         |  9 +++
 kernel/freezer.c                                  |  6 ++
 kernel/sched/core.c                               |  9 ++-
 kernel/sched/fair.c                               | 48 ++++++++++-----
 kernel/sched/rt.c                                 | 14 +++++
 kernel/sched/sched.h                              |  3 +-
 kernel/trace/ftrace.c                             | 73 +++++++++++++++++++----
 mm/mmap.c                                         |  5 +-
 mm/rmap.c                                         |  4 ++
 net/8021q/vlan_dev.c                              | 19 +++++-
 net/bridge/br_multicast.c                         |  4 +-
 net/core/drop_monitor.c                           |  1 -
 net/core/sock.c                                   |  2 +-
 net/ipv4/inet_diag.c                              | 16 +++++
 net/ipv6/route.c                                  |  6 +-
 net/llc/af_llc.c                                  |  5 +-
 net/mac80211/tx.c                                 | 23 +++----
 net/rds/ib.c                                      |  3 +-
 net/rds/ib_send.c                                 |  5 +-
 net/rose/af_rose.c                                | 16 ++---
 net/unix/af_unix.c                                | 16 +++--
 net/wireless/radiotap.c                           |  4 ++
 scripts/link-vmlinux.sh                           |  4 +-
 security/selinux/hooks.c                          | 73 +++++++++++++++++++----
 security/selinux/include/objsec.h                 |  5 +-
 security/selinux/include/xfrm.h                   |  9 +--
 security/selinux/xfrm.c                           | 53 ++++++++++++----
 sound/core/pcm_lib.c                              |  2 +
 sound/pci/hda/hda_intel.c                         |  4 ++
 sound/soc/codecs/wm8904.c                         |  2 +-
 tools/power/cpupower/utils/cpupower-set.c         |  6 +-
 virt/kvm/iommu.c                                  |  4 ++
 96 files changed, 871 insertions(+), 264 deletions(-)

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alan (1):
      sc1200_wdt: Fix oops

Alex Deucher (3):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Anton Blanchard (1):
      powerpc: Align p_end

Ben Segall (3):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel()/rq->lock deadlock

Bjørn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Chad Hanson (1):
      selinux: fix broken peer recv check

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size handling

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Dan Williams (1):
      net_dma: mark broken

Daniel Borkmann (2):
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg

Daniel Vetter (1):
      drm/i915: don't update the dri1 breadcrumb with modesetting

David Henningsson (1):
      ALSA: hda - Add enable_msi=0 workaround for four HP machines

David S. Miller (1):
      vlan: Fix header ops passthru when doing TX VLAN offload.

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Eric Dumazet (1):
      net: do not pretend FRAGLIST support

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      sh: always link in helper functions extracted from libgcc

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Hannes Frederic Sowa (1):
      ipv6: don't count addrconf generated routes against gc limit

Hans Verkuil (1):
      [media] cxd2820r_core: fix sparse warnings

Ian Abbott (2):
      staging: comedi: ssv_dnp: use comedi_dio_update_state()
      staging: comedi: pcmuio: fix possible NULL deref on detach

Jan Kara (2):
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Jason Wang (2):
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu

Jianguo Wu (1):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

Jonathan Cameron (1):
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Len Brown (2):
      intel_idle: initial IVB support
      intel_idle: enable IVB Xeon support

Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Luis Henriques (2):
      Revert "mm: ensure get_unmapped_area() returns higher address than mmap_min_addr"
      Linux 3.5.7.29

Marek Vasut (1):
      HID: Bump maximum global item tag report size to 128 bytes

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Nicholas Bellinger (1):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Moore (2):
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafał Miłecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rashika Kheria (2):
      Staging: zram: Fix access of NULL pointer
      Staging: zram: Fix memory leak by refcount mismatch

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Roger Quadros (2):
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic

Russell King (1):
      ARM: fix "bad mode in ... handler" message for undefined instructions

Salva Peiró (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow set_peek_off to fail
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Steven Rostedt (Red Hat) (1):
      ftrace: Check module functions being traced on reload

Steven Whitehouse (2):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Takashi Iwai (1):
      xhci: Limit the spurious wakeup fix only to HP machines

Tejun Heo (1):
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (2):
      ext4: add explicit casts when masking cluster sizes
      jbd2: don't BUG but return ENOSPC if a handle runs out of space

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Yan, Zheng (2):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene

