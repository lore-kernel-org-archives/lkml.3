Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaAPKBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:01:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAPKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:01:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.11.y.z extended stable] Linux 3.11.10.3
Date: Thu, 16 Jan 2014 10:01:40 +0000
Message-Id: <1389866501-13396-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.11.10.3 kernel.

The updated 3.11.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.11.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.11.y;a=shortlog

The diff from v3.11.10.2 is posted as a follow-up to this email.

The 3.11.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Documentation/kernel-parameters.txt                |   2 +
 Documentation/networking/packet_mmap.txt           |  10 ++
 Makefile                                           |   2 +-
 arch/arm/kernel/traps.c                            |   8 +-
 arch/arm/mach-footbridge/dc21285-timer.c           |   5 +-
 arch/arm/mach-omap2/omap_hwmod.c                   |  43 +++++++-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   4 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |  19 ++--
 arch/arm/mm/flush.c                                |   6 +-
 arch/arm64/boot/dts/foundation-v8.dts              |   2 +
 arch/arm64/include/asm/pgtable.h                   |   2 +-
 arch/arm64/include/asm/syscall.h                   |   6 ++
 arch/arm64/kernel/fpsimd.c                         |   2 +
 arch/arm64/kernel/ptrace.c                         |  38 ++++---
 arch/arm64/mm/proc.S                               |   4 -
 arch/parisc/include/asm/cacheflush.h               |  12 +--
 arch/parisc/include/asm/page.h                     |   5 +-
 arch/parisc/kernel/cache.c                         |  35 ------
 arch/powerpc/include/asm/exception-64s.h           |   2 +-
 arch/powerpc/kernel/head_64.S                      |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   4 +
 arch/sh/kernel/sh_ksyms_32.c                       |   5 +
 arch/sh/lib/Makefile                               |   2 +-
 arch/sparc/include/asm/pgtable_64.h                |   4 +-
 arch/x86/include/asm/fpu-internal.h                |  13 +--
 arch/x86/include/asm/pgtable.h                     |  11 +-
 arch/x86/kernel/cpu/intel.c                        |   3 +-
 arch/x86/kernel/crash.c                            |   2 +-
 arch/x86/kernel/entry_32.S                         |   4 +-
 arch/x86/kernel/entry_64.S                         |   2 +-
 arch/x86/kernel/reboot.c                           |   8 +-
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/mm/gup.c                                  |  13 +++
 drivers/acpi/acpi_lpss.c                           |   1 +
 drivers/acpi/battery.c                             |  21 +++-
 drivers/ata/ahci.c                                 |   3 +
 drivers/ata/ahci_imx.c                             |   3 +-
 drivers/ata/libata-core.c                          |   4 +
 drivers/ata/libata-scsi.c                          |  21 ++++
 drivers/block/rbd.c                                |  95 +++++++++++-----
 drivers/char/tpm/tpm_ppi.c                         |  15 +--
 drivers/clk/clk-divider.c                          |   2 +-
 drivers/clocksource/dw_apb_timer_of.c              |   7 +-
 drivers/clocksource/em_sti.c                       |   2 +-
 drivers/cpufreq/intel_pstate.c                     |   8 +-
 drivers/dma/Kconfig                                |   1 +
 drivers/firewire/sbp2.c                            |   1 -
 drivers/gpio/gpio-msm-v2.c                         |   4 +-
 drivers/gpio/gpio-twl4030.c                        |  15 ++-
 drivers/gpu/drm/drm_edid.c                         |   8 ++
 drivers/gpu/drm/i915/i915_dma.c                    |  10 ++
 drivers/gpu/drm/i915/i915_drv.c                    |   1 +
 drivers/gpu/drm/i915/i915_gem_context.c            |  16 ++-
 drivers/gpu/drm/i915/intel_display.c               |  10 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c    |   6 +-
 drivers/gpu/drm/radeon/atombios_crtc.c             |   4 +-
 drivers/gpu/drm/radeon/cik.c                       |  12 +--
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   2 +-
 drivers/gpu/drm/radeon/ni.c                        |  20 +++-
 drivers/gpu/drm/radeon/radeon_uvd.c                |   2 +-
 drivers/gpu/drm/radeon/rs690.c                     |  10 ++
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   6 ++
 drivers/gpu/drm/radeon/si.c                        |  10 +-
 drivers/idle/intel_idle.c                          |   3 +
 drivers/iio/adc/ad7887.c                           |  16 ++-
 drivers/iio/imu/adis16400_core.c                   |   7 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c          |   6 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  16 ++-
 drivers/input/input.c                              |   4 +
 drivers/input/touchscreen/usbtouchscreen.c         |  22 +++-
 drivers/md/bcache/btree.c                          |   3 +-
 drivers/media/dvb-frontends/cxd2820r_core.c        |   4 +-
 drivers/mfd/rtsx_pcr.c                             |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   3 +
 drivers/net/ethernet/broadcom/tg3.c                |   5 +-
 drivers/net/ethernet/freescale/fec_main.c          |   4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c               |   1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   2 +-
 drivers/net/hamradio/hdlcdrv.c                     |   2 +
 drivers/net/hamradio/yam.c                         |   1 +
 drivers/net/hyperv/netvsc_drv.c                    |   1 -
 drivers/net/macvtap.c                              |  23 ++--
 drivers/net/tun.c                                  |   2 +
 drivers/net/usb/dm9601.c                           |  34 ++++--
 drivers/net/virtio_net.c                           | 119 +++++++++++++++------
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  52 +++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  25 +++--
 drivers/net/wireless/ath/ath9k/main.c              |   5 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   4 +-
 drivers/net/xen-netback/interface.c                |   7 +-
 drivers/of/address.c                               |   8 --
 drivers/pinctrl/pinctrl-baytrail.c                 |   1 +
 drivers/platform/x86/dell-wmi.c                    |   7 +-
 drivers/s390/char/tty3270.c                        |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   9 +-
 drivers/staging/comedi/drivers.c                   |   2 +-
 drivers/staging/comedi/drivers/8255_pci.c          |  15 ++-
 drivers/staging/comedi/drivers/amplc_pc263.c       |   3 +
 drivers/staging/comedi/drivers/amplc_pci263.c      |   3 +
 drivers/staging/comedi/drivers/pcmuio.c            |  11 +-
 drivers/staging/comedi/drivers/ssv_dnp.c           |   6 +-
 drivers/target/iscsi/iscsi_target.c                |  26 +++--
 drivers/target/target_core_device.c                |   5 +
 drivers/target/target_core_file.c                  |   8 +-
 drivers/target/target_core_file.h                  |   5 +-
 drivers/tty/serial/8250/8250_dw.c                  |   2 +
 drivers/tty/serial/pmac_zilog.c                    |   3 +
 drivers/usb/class/cdc-wdm.c                        |   8 +-
 drivers/usb/host/xhci-pci.c                        |  29 +++++
 drivers/usb/host/xhci.c                            |  14 ++-
 drivers/usb/host/xhci.h                            |   2 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/zte_ev.c                        |   3 +-
 drivers/watchdog/sc1200wdt.c                       |   3 +-
 fs/btrfs/acl.c                                     |   2 +-
 fs/btrfs/inode.c                                   |  47 ++++----
 fs/btrfs/tree-log.c                                |   2 +-
 fs/btrfs/volumes.c                                 |   2 +
 fs/ceph/addr.c                                     |   8 +-
 fs/ceph/file.c                                     |  47 ++++----
 fs/ceph/ioctl.c                                    |   8 +-
 fs/ceph/mds_client.c                               |  11 +-
 fs/cifs/cifsproto.h                                |   7 +-
 fs/cifs/inode.c                                    |   6 +-
 fs/cifs/link.c                                     |  26 ++---
 fs/ext2/super.c                                    |   1 +
 fs/ext4/ext4.h                                     |  10 ++
 fs/ext4/ext4_jbd2.c                                |   9 ++
 fs/ext4/extents.c                                  |  45 +++++---
 fs/ext4/inode.c                                    |  12 ---
 fs/ext4/mballoc.c                                  |  21 ++--
 fs/ext4/super.c                                    |  21 ++--
 fs/gfs2/aops.c                                     |  30 ++++++
 fs/gfs2/ops_fstype.c                               |  12 ++-
 fs/jbd2/transaction.c                              |   6 +-
 fs/xfs/xfs_qm.c                                    |  71 ++++++++----
 include/asm-generic/pgtable.h                      |   2 +-
 include/drm/drm_pciids.h                           |   2 +-
 include/linux/auxvec.h                             |   2 +-
 include/linux/ceph/osd_client.h                    |   2 +
 include/linux/migrate.h                            |  10 +-
 include/linux/mm_types.h                           |  49 +++++++++
 include/linux/net.h                                |   2 +-
 include/linux/netdevice.h                          |   9 ++
 include/linux/reboot.h                             |   1 +
 include/linux/skbuff.h                             |   5 +
 include/target/target_core_base.h                  |   1 +
 kernel/fork.c                                      |   1 +
 kernel/freezer.c                                   |   6 ++
 kernel/kexec.c                                     |   1 +
 kernel/reboot.c                                    |   2 +-
 kernel/sched/core.c                                |   9 +-
 kernel/sched/fair.c                                |  55 +++++++---
 kernel/sched/rt.c                                  |  14 +++
 kernel/sched/sched.h                               |   3 +-
 kernel/trace/ftrace.c                              |   2 +-
 mm/compaction.c                                    |   4 +
 mm/fremap.c                                        |   8 +-
 mm/huge_memory.c                                   |  49 +++++++--
 mm/memcontrol.c                                    |   2 +-
 mm/memory-failure.c                                |  24 ++++-
 mm/migrate.c                                       |  69 ++++++++++--
 mm/mprotect.c                                      |  13 ++-
 mm/pgtable-generic.c                               |   8 +-
 mm/rmap.c                                          |   4 +
 net/8021q/vlan_dev.c                               |  19 +++-
 net/bridge/br_multicast.c                          |   4 +-
 net/ceph/osd_client.c                              |  25 +++--
 net/core/drop_monitor.c                            |   1 -
 net/core/neighbour.c                               |   2 +-
 net/core/netpoll.c                                 |  11 +-
 net/core/skbuff.c                                  |   1 +
 net/core/sock.c                                    |   2 +-
 net/ipv4/inet_diag.c                               |  16 +++
 net/ipv4/ip_gre.c                                  |   1 +
 net/ipv6/route.c                                   |  34 +++---
 net/ipv6/udp_offload.c                             |   2 +-
 net/llc/af_llc.c                                   |   5 +-
 net/mac80211/tx.c                                  |  23 ++--
 net/packet/af_packet.c                             |  65 ++++++-----
 net/rds/ib.c                                       |   3 +-
 net/rds/ib_send.c                                  |   5 +-
 net/rose/af_rose.c                                 |  16 +--
 net/unix/af_unix.c                                 |  16 ++-
 net/wireless/radiotap.c                            |   4 +
 scripts/link-vmlinux.sh                            |   4 +-
 security/selinux/hooks.c                           |  73 ++++++++++---
 security/selinux/include/objsec.h                  |   5 +-
 security/selinux/include/xfrm.h                    |   9 +-
 security/selinux/xfrm.c                            |  53 +++++++--
 sound/core/pcm_lib.c                               |   2 +
 sound/pci/hda/hda_intel.c                          |   4 +
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/codecs/wm5110.c                          |   2 +-
 sound/soc/codecs/wm8904.c                          |   2 +-
 sound/soc/codecs/wm_adsp.c                         |  10 +-
 sound/soc/tegra/tegra20_i2s.c                      |   6 +-
 sound/soc/tegra/tegra20_spdif.c                    |  10 +-
 sound/soc/tegra/tegra30_i2s.c                      |   6 +-
 tools/power/cpupower/utils/cpupower-set.c          |   6 +-
 203 files changed, 1691 insertions(+), 697 deletions(-)

AKASHI Takahiro (1):
      arm64: check for number of arguments in syscall_get/set_arguments()

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alan (1):
      sc1200_wdt: Fix oops

Alex Deucher (6):
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: add missing display tiling setup for oland
      drm/radeon/dpm: disable ss on Cayman
      drm/radeon: check for 0 count in speaker allocation and SAD code
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Alex Hung (1):
      dell-wmi: Add KEY_MICMUTE to bios_to_linux_keycode

Andrey Vagin (1):
      virtio: delete napi structures from netdev before releasing memory

Anton Blanchard (1):
      powerpc: Align p_end

Ard Biesheuvel (1):
      auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Ben Segall (3):
      sched: Fix race on toggling cfs_bandwidth_used
      sched: Fix cfs_bandwidth misuse of hrtimer_expires_remaining
      sched: Fix hrtimer_cancel()/rq->lock deadlock

Bjørn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Catalin Marinas (3):
      arm64: dts: Reserve the memory used for secondary CPU release address
      arm64: Remove unused cpu_name ascii in arch/arm64/mm/proc.S
      arm64: Use Normal NonCacheable memory for writecombine

Chad Hanson (1):
      selinux: fix broken peer recv check

Changli Gao (1):
      net: drop_monitor: fix the value of maxattr

Charles Keepax (2):
      ASoC: wm5110: Correct HPOUT3 DAPM route typo
      ASoC: wm_adsp: Add small delay while polling DSP RAM start

Chris Wilson (3):
      drm/i915: Do not clobber config status after a forced restore of hw state
      drm/i915: Hold mutex across i915_gem_release
      drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Christian Engelmayer (1):
      Input: usbtouchscreen - separate report and transmit buffer size handling

Christian König (2):
      drm/radeon: fix typo in cik_copy_dma
      drm/radeon: fix UVD 256MB check

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Dan Carpenter (4):
      ceph: cleanup types in striped_read()
      libceph: fix error handling in handle_reply()
      libceph: potential NULL dereference in ceph_osdc_handle_map()
      libceph: create_singlethread_workqueue() doesn't return ERR_PTRs

Dan Williams (1):
      net_dma: mark broken

Daniel Borkmann (3):
      packet: fix send path when running with proto == 0
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg

Daniel Vetter (2):
      drm/i915: Fix use-after-free in do_switch
      drm/i915: don't update the dri1 breadcrumb with modesetting

David Henningsson (1):
      ALSA: hda - Add enable_msi=0 workaround for four HP machines

David S. Miller (2):
      vlan: Fix header ops passthru when doing TX VLAN offload.
      netpoll: Fix missing TXQ unlock and and OOPS.

Dinh Nguyen (2):
      clocksource: dw_apb_timer_of: Fix read_sched_clock
      clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"

Dirk Brandewie (1):
      intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option

Dmitry Torokhov (1):
      Input: allocate absinfo data when setting ABS capability

Eric Dumazet (2):
      net: do not pretend FRAGLIST support
      net: fec: fix potential use after free

Eric Whitney (1):
      ext4: fix bigalloc regression

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC

Filipe David Borba Manana (1):
      Btrfs: fix incorrect inode acl reset

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Geert Uytterhoeven (2):
      TTY: pmac_zilog, check existence of ports in pmz_console_init()
      sh: always link in helper functions extracted from libgcc

H Hartley Sweeten (1):
      staging: comedi: drivers: fix return value of comedi_load_firmware()

Hannes Frederic Sowa (3):
      net: clear local_df when passing skb between namespaces
      ipv6: don't count addrconf generated routes against gc limit
      ipv6: fix illegal mac_header comparison on 32bit

Hans Verkuil (1):
      [media] cxd2820r_core: fix sparse warnings

Hui Wang (1):
      ALSA: hda - Add Dell headset detection quirk for three laptop models

Ian Abbott (4):
      staging: comedi: pcmuio: fix possible NULL deref on detach
      staging: comedi: ssv_dnp: use comedi_dio_update_state()
      staging: comedi: drivers: use comedi_dio_update_state() for simple cases
      staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Ilia Mirkin (1):
      drm/nouveau/bios: make jump conditional

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Jan Kara (4):
      IB/qib: Convert qib_user_sdma_pin_pages() to use get_user_pages_fast()
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
      ext4: Do not reserve clusters when fs doesn't support extents
      ext4: fix deadlock when writing in ENOSPC conditions

Jan Kiszka (1):
      KVM: x86: Fix APIC map calculation after re-enabling

Jason Wang (3):
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu
      virtio-net: fix refill races during restore

Jiang Liu (2):
      arm64: fix possible invalid FPSIMD initialization state
      ACPI / TPM: fix memory leak when walking ACPI namespace

Jianguo Wu (2):
      mm/hugetlb: check for pte NULL pointer in __page_check_address()
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

Jie Liu (1):
      xfs: fix infinite loop by detaching the group/project hints from user dquot

Johannes Berg (1):
      radiotap: fix bitmap-end-finding buffer overrun

John David Anglin (1):
      parisc: Ensure full cache coherency for kmap/kunmap

Jonathan Cameron (2):
      iio:imu:adis16400 fix pressure channel scan type
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Joonsoo Kim (1):
      mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Josef Bacik (1):
      Btrfs: fix hole check in log_one_extent

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Josh Durgin (8):
      rbd: fix buffer size for writes to images with snapshots
      rbd: fix null dereference in dout
      libceph: add function to ensure notifies are complete
      rbd: complete notifies before cleaning up osd_client and rbd_dev
      rbd: make rbd_obj_notify_ack() synchronous
      rbd: fix use-after free of rbd_dev->disk
      rbd: ignore unmapped snapshots that no longer exist
      rbd: fix error handling from rbd_snap_name()

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kamala R (1):
      IPv6: Fixed support for blackhole and prohibit routes

Kent Overstreet (1):
      bcache: Fix dirty_data accounting

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Len Brown (1):
      x86 idle: Repair large-server 50-watt idle-power regression

Li RongQing (1):
      ipv6: always set the new created dst's from in ip6_rt_copy

Li Wang (1):
      ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Linus Torvalds (1):
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Liu Bo (2):
      Btrfs: fix memory leak of chunks' extent map
      Btrfs: do not run snapshot-aware defragment on error

Luis Henriques (1):
      Linux 3.11.10.3

Lukas Czerner (1):
      ext4: fix FITRIM in no journal mode

Magnus Damm (1):
      clocksource: em_sti: Set cpu_possible_mask to fix SMP broadcast

Marc Kleine-Budde (1):
      can: peak_usb: fix mem leak in pcan_usb_pro_init()

Marek Olšák (1):
      drm/radeon: fix render backend setup for SI and CIK

Marek Vasut (1):
      ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN

Martin Schwidefsky (1):
      s390/3270: fix allocation of tty3270_screen structure

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Mel Gorman (12):
      mm: numa: serialise parallel get_user_page against THP migration
      mm: numa: call MMU notifiers on THP migration
      mm: clear pmd_numa before invalidating
      mm: numa: do not clear PMD during PTE update scan
      mm: numa: do not clear PTE for pte_numa update
      mm: numa: ensure anon_vma is locked to prevent parallel THP splits
      mm: numa: avoid unnecessary work on the failure path
      sched: numa: skip inaccessible VMAs
      mm: numa: clear numa hinting information on mprotect
      mm: numa: avoid unnecessary disruption of NUMA hinting during migration
      mm: numa: guarantee that tlb_flush_pending updates are visible before page table updates
      mm: numa: defer TLB flush for THP migration as long as possible

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michael S. Tsirkin (3):
      virtio_net: fix error handling for mergeable buffers
      virtio-net: make all RX paths handle errors consistently
      virtio_net: don't leak memory or block when too many frags

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Mika Westerberg (1):
      serial: 8250_dw: add new ACPI IDs

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

Naoya Horiguchi (1):
      mm/memory-failure.c: transfer page count from head page to tail page after split thp

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Nathaniel Yazdani (1):
      ceph: fix null pointer dereference

Nicholas Bellinger (2):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
      target/file: Update hw_max_sectors based on current block_size

Nithin Sujir (1):
      tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Nobuhiro Iwamatsu (1):
      sh: add EXPORT_SYMBOL(min_low_pfn) and EXPORT_SYMBOL(max_low_pfn) to sh_ksyms_32.c

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Oliver Neukum (1):
      xhci: quirk for extra long delay for S4

Paul Drews (1):
      ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs

Paul Moore (2):
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

Paul Turner (1):
      sched: Guarantee new group-entities always have weight

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafael J. Wysocki (1):
      intel_pstate: Fail initialization if P-state information is missing

Rafał Miłecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rik van Riel (2):
      mm: fix use-after-free in sys_remap_file_pages
      mm: fix TLB flush race between migration, and change_protection_range

Rob Herring (1):
      Revert "of/address: Handle #address-cells > 2 specially"

Robin H. Johnson (1):
      libata: disable a disk via libata.force params

Roger Quadros (3):
      ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module
      ARM: OMAP2+: hwmod: Fix SOFTRESET logic
      gpio: twl4030: Fix regression for twl gpio LED output

Russell King (2):
      ARM: fix footbridge clockevent device
      ARM: fix "bad mode in ... handler" message for undefined instructions

Sachin Prabhu (1):
      cifs: We do not drop reference to tlink in CIFSCheckMFSymlink()

Salva Peiró (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow set_peek_off to fail
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Shivaram Upadhyayula (1):
      qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

Stefan Richter (1):
      firewire: sbp2: bring back WRITE SAME support

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Stephen Warren (1):
      ASoC: tegra: fix uninitialized variables in set_fmt

Steven Capper (1):
      ARM: 7923/1: mm: fix dcache flush logic for compound high pages

Steven Rostedt (2):
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Steven Whitehouse (2):
      GFS2: don't hold s_umount over blkdev_put
      GFS2: Fix incorrect invalidation for DIO/buffered I/O

Sujith Manoharan (1):
      ath9k: Fix interrupt handling for the AR9002 family

Suman Anna (1):
      ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Takashi Iwai (2):
      xhci: Fix spurious wakeups after S5 on Haswell
      xhci: Limit the spurious wakeup fix only to HP machines

Tejun Heo (1):
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (3):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
      ext4: add explicit casts when masking cluster sizes
      jbd2: don't BUG but return ENOSPC if a handle runs out of space

Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Timo Teräs (1):
      ip_gre: fix msg_name parsing for recvfrom/recvmsg

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Ville Syrjälä (1):
      drm/i915: Take modeset locks around intel_modeset_setup_hw_state()

Vivek Goyal (1):
      kexec: migrate to reboot cpu

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Vladimir Davydov (1):
      memcg: fix memcg_size() calculation

Wei Liu (1):
      xen-netback: fix refcnt unbalance for 3.11 and earlier versions

Wei Yongjun (1):
      iser-target: fix error return code in isert_create_device_ib_res()

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Will Deacon (1):
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Yan, Zheng (2):
      ceph: cleanup aborted requests when re-sending requests.
      ceph: wake up 'safe' waiters when unregistering request

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position

majianpeng (3):
      ceph: Add check returned value on func ceph_calc_ceph_pg.
      ceph: fix bugs about handling short-read for sync read mode.
      ceph: allow sync_read/write return partial successed size of read/write.

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene

