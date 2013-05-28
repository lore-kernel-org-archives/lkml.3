Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3E1VVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:21:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59458 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab3E1VVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [ 3.8.y.z extended stable ] Linux 3.8.13.1 stable review
Date: Tue, 28 May 2013 14:19:09 -0700
Message-Id: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the Linux 3.8.13.1 stable kernel.

This version contains 78 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.1 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 arch/arm/include/asm/cmpxchg.h               |   8 +-
 arch/arm/mach-exynos/include/mach/regs-pmu.h |   1 +
 arch/arm/mach-exynos/pmu.c                   |   5 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |   4 +-
 arch/arm/mach-s5pv210/clock.c                |  36 ++++-----
 arch/arm64/kernel/debug-monitors.c           |   2 -
 arch/arm64/mm/cache.S                        |   2 +-
 arch/arm64/mm/proc.S                         |   3 +-
 arch/powerpc/include/asm/rtas.h              |   2 +
 arch/powerpc/kernel/machine_kexec_64.c       |   4 +
 arch/powerpc/kernel/rtas.c                   | 113 +++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/suspend.c     |  22 ++++++
 arch/tile/Kconfig                            |  14 +++-
 arch/tile/include/hv/hypervisor.h            |  27 ++++++-
 arch/tile/kernel/head_32.S                   |   2 +-
 arch/tile/kernel/head_64.S                   |  12 ++-
 arch/x86/kvm/vmx.c                           |   6 ++
 arch/x86/xen/enlighten.c                     |  15 ++++
 block/blk-cgroup.c                           |   4 +-
 drivers/acpi/acpica/exfldio.c                |  14 +++-
 drivers/acpi/ec.c                            |   4 +-
 drivers/char/ipmi/ipmi_bt_sm.c               |   4 +-
 drivers/char/ipmi/ipmi_devintf.c             |  14 +++-
 drivers/dma/pch_dma.c                        |   2 +-
 drivers/gpu/drm/drm_mm.c                     |  34 ++++----
 drivers/gpu/drm/i915/i915_drv.h              |   2 +
 drivers/gpu/drm/i915/intel_crt.c             |   2 +-
 drivers/gpu/drm/i915/intel_ddi.c             |   2 +-
 drivers/gpu/drm/i915/intel_display.c         |  19 +++--
 drivers/gpu/drm/i915/intel_dp.c              |   8 +-
 drivers/gpu/drm/i915/intel_hdmi.c            |  28 +------
 drivers/gpu/drm/mgag200/mgag200_mode.c       |  69 ++++++++++------
 drivers/gpu/drm/radeon/r300_cmdbuf.c         |   2 +-
 drivers/iommu/amd_iommu.c                    |  31 ++++++--
 drivers/iommu/amd_iommu_types.h              |   1 +
 drivers/md/dm-bufio.c                        |  24 +++++-
 drivers/md/dm-snap.c                         |   1 +
 drivers/md/dm-stripe.c                       |  11 +--
 drivers/md/dm-table.c                        |   2 +-
 drivers/net/ethernet/3com/3c509.c            |   2 +
 drivers/net/ethernet/3com/3c59x.c            |  27 ++++---
 drivers/net/ethernet/sfc/mcdi.c              |   2 +-
 drivers/net/ethernet/tile/tilegx.c           |   2 +-
 drivers/net/macvlan.c                        |   7 +-
 drivers/net/tun.c                            |   7 +-
 drivers/net/usb/cdc_ether.c                  |  14 ++++
 drivers/net/usb/qmi_wwan.c                   |  14 ++++
 drivers/net/wireless/ath/ath9k/main.c        |   6 +-
 drivers/net/wireless/b43/dma.c               |  19 +++++
 drivers/net/wireless/b43/dma.h               |   4 +-
 drivers/net/wireless/b43/main.c              |  43 +++++-----
 drivers/net/wireless/mwifiex/cfg80211.c      |   3 -
 drivers/net/wireless/mwifiex/cmdevt.c        |   1 +
 drivers/net/wireless/mwifiex/main.c          |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c     |  21 ++---
 drivers/platform/x86/hp_accel.c              |   3 +-
 drivers/rtc/rtc-at91rm9200.c                 |  14 +++-
 drivers/rtc/rtc-pcf2123.c                    |   1 +
 drivers/scsi/sd.c                            |  20 +++++
 drivers/scsi/sd.h                            |   1 +
 drivers/target/iscsi/iscsi_target_erl1.c     |   7 +-
 drivers/target/target_core_file.c            |   9 +--
 drivers/target/target_core_transport.c       |  11 ++-
 drivers/watchdog/watchdog_dev.c              |   3 +-
 fs/btrfs/ioctl.c                             |  10 +--
 fs/ext4/mballoc.c                            |   6 +-
 fs/namei.c                                   |   2 +-
 fs/nfs/nfs4proc.c                            |   8 +-
 fs/nfsd/nfs4recover.c                        |  12 ++-
 include/linux/audit.h                        |   2 +-
 include/linux/kref.h                         |  33 ++++++++
 include/linux/sched.h                        |  22 ++++++
 include/net/sock.h                           |  12 +++
 include/net/tcp.h                            |   1 +
 include/uapi/linux/if_cablemodem.h           |  12 +--
 include/uapi/linux/virtio_net.h              |   2 +-
 ipc/shm.c                                    |   8 +-
 kernel/kmod.c                                |   5 ++
 kernel/time/tick-sched.c                     |   2 +-
 kernel/timer.c                               |   2 +-
 kernel/trace/trace_events_filter.c           |   4 +
 mm/mmap.c                                    |   8 +-
 mm/page_alloc.c                              |   9 ++-
 mm/vmscan.c                                  |   4 +-
 net/8021q/vlan_dev.c                         |   2 +-
 net/bridge/br_stp_timer.c                    |   2 +-
 net/core/dev.c                               |   2 +-
 net/core/ethtool.c                           |   2 +-
 net/core/sock.c                              |  12 ---
 net/ipv4/tcp_minisocks.c                     |   7 +-
 net/ipv6/ip6_gre.c                           |   2 +
 net/ipv6/tcp_ipv6.c                          |  12 +++
 net/ipv6/udp.c                               |  13 ++-
 net/ipv6/udp_impl.h                          |   2 +
 net/ipv6/udplite.c                           |   2 +-
 net/ipv6/xfrm6_policy.c                      |   4 +-
 net/mac802154/mac802154.h                    |   2 +-
 net/packet/af_packet.c                       |  53 ++++++-------
 net/sched/act_ipt.c                          |  33 +++++++-
 scripts/kconfig/list.h                       |  13 +++
 scripts/kconfig/mconf.c                      |   3 +
 sound/pci/hda/hda_codec.c                    |   3 +
 sound/soc/codecs/wm8994.c                    |   1 +
 103 files changed, 812 insertions(+), 320 deletions(-)

Aaro Koskinen (1):
      ARM: OMAP: RX-51: change probe order of touchscreen and panel SPI devices

Amerigo Wang (1):
      ipv6,gre: do not leak info to user-space

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Andy Grover (1):
      target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio

Anton Blanchard (2):
      audit: Syscall rules are not applied to existing processes on non-x86
      powerpc/kexec: Fix kexec when using VMX optimised memcpy

Ben Hutchings (1):
      sfc: Fix naming of MTD partitions for FPGA bitfiles

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Benjamin Poirier (1):
      menuconfig: Fix memory leak introduced by jump keys feature

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Bjørn Mork (1):
      net: vlan,ethtool: netdev_features_t is more than 32 bit

Bob Moore (1):
      ACPICA: Fix possible buffer overflow during a field unit read operation

Chen Gang (2):
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid memory overflow
      net: mac802154: comparision issue of type cast, finding by EXTRA_CFLAGS=-W

Chris Metcalf (1):
      tile: support new Tilera hypervisor

Christopher Harvey (2):
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Fix framebuffer base address programming

Cong Wang (1):
      xfrm6: release dev before returning error

Dan Carpenter (1):
      ASoC: wm8994: missing break in wm8994_aif3_hw_params()

Dan Williams (2):
      qmi_wwan, cdc-ether: add ADU960S
      qmi_wwan/cdc_ether: add device IDs for Dell 5804 (Novatel E371) WWAN card

Daniel Borkmann (1):
      packet: tpacket_v3: do not trigger bug() on wrong header status

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Daniel Vetter (2):
      drm/i915: Revert hdmi HDP pin checks
      drm/mm: fix dump table BUG

Eric Dumazet (2):
      tcp: force a dst refcount when prequeue packet
      ipv6: do not clear pinet6 field

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Gao feng (1):
      net: tun: release the reference of tun device in tun_recvmsg

Gleb Natapov (1):
      KVM: VMX: fix halt emulation while emulating invalid guest sate

Guenter Roeck (1):
      watchdog: Fix race condition in registration code

Inderpal Singh (1):
      ARM: EXYNOS5: Fix kernel dump in AFTR idle mode

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits of the old/new value

Jamal Hadi Salim (1):
      net_sched: act_ipt forward compat with xtables

James Bottomley (1):
      [SCSI] sd: fix array cache flushing bug causing performance problems

Jeff Layton (2):
      audit: vfs: fix audit_inode call in O_CREAT case of do_last
      nfsd: fix oops when legacy_recdir_name_error is passed a -ENOENT error

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312

Joern Engel (1):
      target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

Johan Hovold (1):
      drivers/rtc/rtc-at91rm9200.c: fix missing iounmap

Josh Boyer (1):
      if_cablemodem.h: Add parenthesis around ioctl macros

Jun'ichi Nomura (1):
      blkcg: fix "scheduling while atomic" in blk_queue_bypass_start

Kees Cook (1):
      drm/radeon: check incoming cliprects pointer

Konrad Rzeszutek Wilk (1):
      xen/vcpu/pvhvm: Fix vcpu hotplugging hanging.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (1):
      ACPI / EC: Restart transaction even when the IBF flag set

Li Zefan (1):
      shm: fix null pointer deref when userspace specifies invalid hugepage size

Matthew Whitehead (1):
      3c509.c: call SET_NETDEV_DEV for all device types (ISA/ISAPnP/EISA)

Mike Snitzer (2):
      dm stripe: fix regression in stripe_width calculation
      dm table: fix write same support

Mikulas Patocka (1):
      dm bufio: avoid a possible __vmalloc deadlock

Ming Lei (1):
      mm: teach mm by current context info to not do I/O during memory allocation

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL

Patrick McHardy (1):
      net: use netdev_features_t in skb_needs_linearize()

Paulo Zanoni (2):
      drm/i915: add HAS_DDI check
      drm/i915: don't intel_crt_init on any ULT machines

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Sergei Shtylyov (2):
      3c59x: fix freeing nonexistent resource on driver unload
      3c59x: fix PCI resource management

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Sukanto Ghosh (1):
      arm64: mm: Fix operands of clz in __flush_dcache_all

Sylwester Nawrocki (1):
      ARM: S5PV210: Fix PL330 DMA controller clkdev entries

Thomas Gleixner (1):
      tick: Cleanup NOHZ per cpu data on cpu down

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tomoya MORINAGA (1):
      pch_dma: Use GFP_ATOMIC because called from interrupt context

Trond Myklebust (1):
      NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_lock_delegation_recall

Wang YanQing (1):
      ALSA: HDA: Fix Oops caused by dereference NULL pointer

Wei Yongjun (2):
      dm snapshot: fix error return code in snapshot_ctr
      drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Will Deacon (1):
      arm64: debug: clear mdscr_el1 instead of taking the OS lock

Yuchung Cheng (1):
      tcp: reset timer after any SYNACK retransmit

stephen hemminger (2):
      bridge: fix race with topology change timer
      virtio: don't expose u16 in userspace api
