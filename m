Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbbA2DIC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:08:02 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154AbbA2ChJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:09 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y-ckt stable] Linux 3.13.11-ckt15 stable review
Date: Wed, 28 Jan 2015 14:19:03 -0800
Message-Id: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11-ckt15 stable kernel.

This version contains 139 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11-ckt15 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y-ckt extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/ramoops.txt                          |  13 +-
 arch/arc/boot/dts/nsimosci.dts                     |  18 +-
 arch/arm/include/asm/arch_timer.h                  |   9 +
 arch/arm/mach-tegra/reset-handler.S                |   1 +
 arch/arm64/include/asm/arch_timer.h                |   9 +
 arch/arm64/include/asm/hwcap.h                     |   1 +
 arch/arm64/kernel/setup.c                          |   3 +-
 arch/powerpc/include/asm/reg.h                     |   2 +
 arch/powerpc/kernel/idle_power7.S                  |  17 +
 arch/powerpc/kernel/smp.c                          |   9 +-
 arch/s390/kvm/priv.c                               |   4 +-
 arch/x86/include/uapi/asm/ldt.h                    |   7 +
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      |  22 +-
 arch/x86/kernel/entry_64.S                         |  37 +++
 arch/x86/kernel/kvm.c                              |   9 +-
 arch/x86/kernel/kvmclock.c                         |   1 -
 arch/x86/kernel/tls.c                              |  16 +
 arch/x86/kernel/traps.c                            |   4 +-
 arch/x86/kvm/vmx.c                                 |   4 +-
 block/blk-core.c                                   |   3 +
 block/blk-mq-cpumap.c                              |   2 +-
 block/blk-sysfs.c                                  |  11 +-
 block/genhd.c                                      |  11 +-
 drivers/base/bus.c                                 |   8 +-
 drivers/bluetooth/ath3k.c                          |   2 +
 drivers/bluetooth/btusb.c                          |   1 +
 drivers/clocksource/arm_arch_timer.c               |  10 +-
 drivers/gpu/drm/i915/i915_drv.h                    |   1 +
 drivers/gpu/drm/i915/i915_gem.c                    |   6 +
 drivers/gpu/drm/i915/i915_gem_stolen.c             |   6 +-
 drivers/gpu/drm/i915/i915_reg.h                    |   1 +
 drivers/gpu/drm/i915/i915_suspend.c                |   8 +
 drivers/gpu/drm/radeon/ci_dpm.c                    |   2 +-
 drivers/gpu/drm/radeon/cik.c                       |   3 +-
 drivers/gpu/drm/radeon/radeon_ttm.c                |   2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  26 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  25 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c              |  38 +--
 drivers/hid/i2c-hid/i2c-hid.c                      |  14 +-
 drivers/hv/channel_mgmt.c                          |  11 +-
 drivers/infiniband/ulp/isert/ib_isert.c            | 344 +++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h            |   7 +-
 drivers/iommu/intel-iommu.c                        |   8 +-
 drivers/md/dm-bufio.c                              |  20 +-
 drivers/md/dm-cache-target.c                       |  13 +-
 drivers/md/dm-crypt.c                              |   2 +-
 drivers/md/raid5.c                                 |  33 +-
 drivers/media/i2c/smiapp-pll.c                     |   4 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |   2 +
 drivers/media/usb/au0828/au0828-cards.c            |   5 +
 drivers/media/usb/dvb-usb/af9005.c                 |   3 +
 drivers/media/usb/uvc/uvc_driver.c                 |   6 +-
 drivers/mfd/tc6393xb.c                             |  13 +-
 drivers/mmc/host/dw_mmc.c                          |   7 +
 drivers/mtd/tests/torturetest.c                    |   4 +-
 drivers/mtd/ubi/upd.c                              |  10 +-
 drivers/mtd/ubi/wl.c                               |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  17 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   3 +-
 drivers/net/ethernet/atheros/alx/main.c            |  24 +-
 drivers/net/ethernet/broadcom/tg3.c                |  34 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  12 +-
 drivers/net/macvlan.c                              |   5 +-
 drivers/net/team/team.c                            |  16 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   8 +-
 drivers/net/wireless/ath/ath9k/hw.h                |   4 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   9 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h        |  31 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |  48 +--
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c        |   2 +
 drivers/net/xen-netfront.c                         |  10 +-
 drivers/pci/probe.c                                |   3 +
 drivers/platform/x86/hp_accel.c                    |   1 +
 drivers/rtc/rtc-omap.c                             |   5 +-
 drivers/rtc/rtc-sirfsoc.c                          |  16 +-
 drivers/scsi/NCR5380.c                             |  12 +-
 drivers/scsi/aha1740.c                             |   2 +-
 drivers/scsi/atari_NCR5380.c                       |   2 +-
 drivers/scsi/esas2r/esas2r_main.c                  |   2 +-
 drivers/scsi/megaraid.c                            |   8 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   2 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c           |   5 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |   5 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/storvsc_drv.c                         |   7 +-
 drivers/scsi/sun3_NCR5380.c                        |  10 +-
 drivers/target/iscsi/iscsi_target_login.c          |   3 +
 drivers/target/iscsi/iscsi_target_util.c           |  26 +-
 drivers/target/loopback/tcm_loop.c                 |  66 ++--
 drivers/target/loopback/tcm_loop.h                 |   7 +-
 drivers/thermal/intel_powerclamp.c                 |   2 -
 drivers/thermal/thermal_core.c                     |   4 +-
 drivers/tty/n_tty.c                                |   3 +-
 drivers/tty/serial/samsung.c                       |   4 +
 drivers/usb/class/cdc-acm.c                        |  10 +-
 drivers/usb/renesas_usbhs/mod_gadget.c             |   4 +
 drivers/xen/swiotlb-xen.c                          |   8 +-
 fs/btrfs/disk-io.c                                 |   6 -
 fs/btrfs/extent-tree.c                             |  10 +-
 fs/btrfs/extent_map.c                              |   2 -
 fs/btrfs/tree-log.c                                |   2 +-
 fs/ceph/addr.c                                     |   2 +-
 fs/ecryptfs/crypto.c                               |   1 -
 fs/ecryptfs/file.c                                 |  12 -
 fs/ecryptfs/main.c                                 |  16 +-
 fs/fs-writeback.c                                  |  29 +-
 fs/namespace.c                                     |  13 +-
 fs/ncpfs/ioctl.c                                   |   1 -
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfsd/nfs4state.c                                |  15 +-
 fs/nfsd/nfs4xdr.c                                  |   3 +
 fs/ocfs2/aops.c                                    |  16 +-
 fs/proc/base.c                                     |  53 ++++
 fs/proc/stat.c                                     |   2 +-
 fs/pstore/ram.c                                    |  13 +-
 fs/pstore/ram_core.c                               |  31 +-
 include/linux/kernel_stat.h                        |   1 +
 include/linux/pstore_ram.h                         |   4 +-
 include/linux/user_namespace.h                     |   7 +
 include/trace/events/sched.h                       |   2 +-
 include/uapi/linux/in6.h                           |   3 +-
 include/uapi/linux/libc-compat.h                   |   3 +
 kernel/events/core.c                               |   4 +-
 kernel/irq/internals.h                             |   8 +
 kernel/irq/irqdesc.c                               |  52 ++++
 kernel/irq/proc.c                                  |  22 +-
 kernel/pid.c                                       |   2 +
 kernel/time/tick-sched.c                           |   2 -
 kernel/user.c                                      |   1 +
 kernel/user_namespace.c                            | 104 ++++++-
 net/batman-adv/fragmentation.c                     |   2 +-
 net/batman-adv/gateway_client.c                    |   2 +-
 net/core/dev.c                                     |  14 +-
 net/core/skbuff.c                                  |   1 +
 net/ipv4/ip_gre.c                                  |   9 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/mac80211/key.c                                 |   2 +-
 net/mac80211/rx.c                                  |  11 +-
 net/netfilter/nf_conntrack_proto_generic.c         |  26 +-
 net/netlink/af_netlink.c                           |  54 +---
 net/wireless/reg.c                                 |   4 +-
 security/keys/encrypted-keys/encrypted.c           |   5 +-
 sound/pci/hda/patch_analog.c                       |   1 +
 sound/pci/hda/patch_realtek.c                      |   1 +
 sound/soc/codecs/max98090.c                        |   4 +-
 sound/soc/codecs/sigmadsp.c                        |   7 +
 sound/usb/midi.c                                   |   2 +
 sound/usb/mixer_maps.c                             |  15 +-
 sound/usb/quirks-table.h                           | 166 +++-------
 .../selftests/mount/unprivileged-remount-test.c    | 204 +++++++++---
 150 files changed, 1514 insertions(+), 777 deletions(-)

Alex Deucher (3):
      drm/radeon: fix typo in CI dpm disable
      drm/radeon: work around a hw bug in MGCG on CIK
      drm/radeon: check the right ring in radeon_evict_flags()

Alex Williamson (1):
      driver core: Fix unbalanced device reference in drivers_probe

Andreas Müller (1):
      mac80211: fix multicast LED blinking and counter

Andy Lutomirski (4):
      x86/asm/traps: Disable tracing and kprobes in fixup_bad_iret and sync_regs
      x86, kvm: Clear paravirt_enabled on KVM guests for espfix32's benefit
      x86/tls: Disallow unusual TLS segments
      x86/tls: Don't validate lm in set_thread_area() after all

Anton Blanchard (1):
      powerpc: Secondary CPUs must set cpu_callin_map after setting active and online

Antonio Quartulli (1):
      batman-adv: avoid NULL dereferences and fix if check

Arik Nemtsov (1):
      cfg80211: avoid mem leak on driver hint set

Bandan Das (1):
      KVM: nVMX: Disable unrestricted mode if ept=0

Bart Van Assche (1):
      blk-mq: Fix a use-after-free

Benjamin Coddington (1):
      nfsd4: fix xdr4 inclusion of escaped char

Brian Norris (1):
      mtd: tests: abort torturetest on erase errors

Catalin Marinas (1):
      arm64: Add COMPAT_HWCAP_LPAE

Christian Borntraeger (1):
      KVM: s390: flush CPU on load control

Christian Riesch (1):
      n_tty: Fix read_buf race condition, increment read_head after pushing data

Cong Wang (1):
      macvlan: unregister net device when netdev_upper_dev_link() fails

Dan Carpenter (1):
      ceph: do_sync is never initialized

Daniel Vetter (2):
      drm/i915: Disallow pin ioctl completely for kms drivers
      drm/i915: Don't complain about stolen conflicts on gen3

Darrick J. Wong (1):
      dm bufio: fix memleak when using a dm_buffer's inline bio

David Miller (1):
      netlink: Always copy on mmap TX.

David Vrabel (1):
      xen-netfront: use correct linear area after linearizing an skb

Dmitry Eremin-Solenikov (1):
      mfd: tc6393xb: Fail ohci suspend if full state restore is required

Dmitry Osipenko (1):
      ARM: tegra: Re-add removed SoC id macro to tegra_resume()

Dmitry Tunin (1):
      Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Dominique Leuenberger (1):
      hp_accel: Add support for HP ZBook 15

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix flush support for old firmware

Eric Dumazet (1):
      alx: fix alx_poll()

Eric W. Biederman (8):
      mnt: Implicitly add MNT_NODEV on remount when it was implicitly added by mount
      mnt: Update unprivileged remount test
      umount: Disallow unprivileged mount force
      userns: Rename id_map_mutex to userns_state_mutex
      userns: Add a knob to disable setgroups on a per user namespace basis
      userns: Allow setting gid_maps without privilege when setgroups is disabled
      userns: Unbreak the unprivileged remount tests
      mnt: Fix a memory stomp in umount

Felix Fietkau (3):
      ath9k_hw: fix hardware queue allocation
      ath9k: fix BE/BK queue order
      ath5k: fix hardware queue index assignment

Filipe Manana (1):
      Btrfs: fix fs corruption on transaction abort if device supports discard

Florian Westphal (1):
      netfilter: conntrack: disable generic tracking for known protocols

Frank Schaefer (1):
      [media] af9005: fix kernel panic on init if compiled without IR

Govindarajulu Varadarajan (1):
      enic: fix rx skb checksum

Greg Kroah-Hartman (1):
      USB: cdc-acm: check for valid interfaces

Guo Zeng (1):
      drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe

Gwendal Grignou (1):
      HID: i2c-hid: prevent buffer overflow in early IRQ

Hannes Reinecke (2):
      scsi: correct return values for .eh_abort_handler implementations
      tcm_loop: Fix wrong I_T nexus association

Herbert Xu (1):
      tcp: Do not apply TSO segment limit to non-TSO packets

James Hogan (1):
      mmc: dw_mmc: avoid write to CDTHRCTL on older versions

Jan Kara (1):
      ncpfs: return proper error from NCP_IOC_SETROOT ioctl

Jarkko Nikula (1):
      ASoC: max98090: Fix ill-defined sidetone route

Jay Vosburgh (1):
      net/core: Handle csum for CHECKSUM_COMPLETE VXLAN forwarding

Jean-Baptiste Maneyrol (1):
      HID: i2c-hid: fix race condition reading reports

Jens Axboe (2):
      genhd: check for int overflow in disk_expand_part_tbl()
      blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map

Jesse Barnes (1):
      drm/i915: save/restore GMBUS freq across suspend/resume on gen4

Jiang Liu (1):
      iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Jiri Jaburek (1):
      ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Jiri Olsa (2):
      perf/x86/intel/uncore: Make sure only uncore events are collected
      perf: Fix events installation during moving group

Jiri Pirko (1):
      team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin

Joe Thornber (2):
      dm cache: only use overwrite optimisation for promotion when in writeback mode
      dm cache: dirty flag was mistakenly being cleared when promoting via overwrite

Johan Hovold (1):
      rtc: omap: fix missing wakealarm attribute

Johannes Berg (1):
      mac80211: free management frame keys when removing station

Josef Bacik (2):
      Btrfs: make sure we wait on logged extents when fsycning two subvols
      Btrfs: do not move em to modified list when unpinning

Junxiao Bi (1):
      ocfs2: fix journal commit deadlock

Kazuya Mizuguchi (1):
      usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()

Larry Finger (1):
      rtlwifi: rtl8192ce: Set fw_ready flag

Lars-Peter Clausen (1):
      ASoC: sigmadsp: Refuse to load firmware files with a non-supported version

Long Li (1):
      storvsc: ring buffer failures may result in I/O freeze

Luis Henriques (1):
      thermal: Fix error path in thermal_init()

Martin K. Petersen (1):
      scsi: blacklist RSOC for Microsoft iSCSI target devices

Mauro Carvalho Chehab (2):
      [media] sound: simplify au0828 quirk table
      [media] sound: Update au0828 quirks table

Michael Halcrow (1):
      eCryptfs: Remove buggy and unnecessary write in file name decode routine

Milan Broz (1):
      dm crypt: use memzero_explicit for on-stack buffer

Myron Stowe (1):
      PCI: Restore detection of read-only BARs

NeilBrown (3):
      md/raid56: Don't perform reads to support writes until stripe is ready.
      md/raid5: avoid livelock caused by non-aligned writes.
      md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.

Nicholas Bellinger (1):
      iscsi-target: Fail connection on short sendmsg writes

Oleg Nesterov (1):
      exit: pidns: alloc_pid() leaks pid_namespace if child_reaper is exiting

Oliver Neukum (1):
      cdc-acm: memory leak in error case

Paul Mackerras (1):
      powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mode

Peng Tao (1):
      nfs41: fix nfs4_proc_layoutget error handling

Prashant Sreedharan (1):
      tg3: tg3_disable_ints using uninitialized mailbox value to disable interrupts

Rasmus Villemoes (1):
      fs: nfsd: Fix signedness bug in compare_blob

Richard Weinberger (2):
      UBI: Fix double free after do_sync_erase()
      UBI: Fix invalid vfree()

Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Robert Baldyga (1):
      serial: samsung: wait for transfer completion before clock disable

Sagi Grimberg (6):
      iscsi,iser-target: Initiate termination only once
      iser-target: Fix flush + disconnect completion handling
      iser-target: Parallelize CM connection establishment
      iser-target: Fix connected_handler + teardown flow race
      iser-target: Handle ADDR_CHANGE event for listener cm_id
      iser-target: Fix implicit termination of connections

Sakari Ailus (2):
      [media] smiapp: Take mutex during PLL update in sensor initialisation
      [media] smiapp-pll: Correct clock debug prints

Sonny Rao (1):
      clocksource: arch_timer: Fix code to use physical timers when requested

Sreekanth Reddy (2):
      Revert "[SCSI] mpt2sas: Remove phys on topology change."
      Revert "[SCSI] mpt3sas: Remove phys on topology change"

Stefano Stabellini (3):
      swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu
      swiotlb-xen: call xen_dma_sync_single_for_device when appropriate
      swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stephane Grosjean (2):
      can: peak_usb: fix memset() usage
      can: peak_usb: fix cleanup sequence order in case of error during init

Steven Rostedt (Red Hat) (2):
      ftrace/x86: Add frames pointers to trampoline as necessary
      tracing/sched: Check preempt_count() for current when reading task->state

Sumit.Saxena@avagotech.com (1):
      megaraid_sas: corrected return of wait_event from abort frame path

Sven Eckelmann (1):
      batman-adv: Unify fragment size calculation

Takashi Iwai (5):
      [media] uvcvideo: Fix destruction order in uvc_delete()
      ALSA: hda - Fix built-in mic at resume on Lenovo Ideapad S210
      ALSA: usb-audio: Don't resubmit pending URBs at MIDI error recovery
      KEYS: Fix stale key registration at error path
      ALSA: hda - Add EAPD fixup for ASUS Z99He laptop

Tejun Heo (1):
      writeback: fix a subtle race condition in I_DIRTY clearing

Tetsuo Handa (1):
      drm/ttm: Avoid memory allocation from shrinker functions.

Thomas Gleixner (2):
      genirq: Prevent proc race against freeing of irq descriptors
      tick/powerclamp: Remove tick_nohz_idle abuse

Thomas Graf (2):
      netlink: Don't reorder loads/stores before marking mmap netlink frame as available
      net: Reset secmark when scrubbing packet

Thomas Hellstrom (2):
      drm/vmwgfx: Don't use memory accounting for kernel-side fence objects
      drm/vmwgfx: Fix fence event code

Timo Teräs (1):
      gre: fix the inner mac header in nbma tunnel xmit path

Tony Lindgren (1):
      pstore-ram: Allow optional mapping with pgprot_noncached

Toshiaki Makita (1):
      net: Fix stacked vlan offload features computation

Tyler Hicks (1):
      eCryptfs: Force RO mount when encrypted view is enabled

Vineet Gupta (1):
      ARC: [nsimosci] move peripherals to match model to FPGA

Vitaly Kuznetsov (1):
      Drivers: hv: vmbus: Fix a race condition when unregistering a device

Zoltan Kiss (1):
      xen-netfront: Fix handling packets on compound pages with skb_linearize

stephen hemminger (1):
      in6: fix conflict with glibc
