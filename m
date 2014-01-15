Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaAOVxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:53:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaAOVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:53:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.8.y.z extended stable] Linux 3.8.13.16 stable review
Date: Wed, 15 Jan 2014 13:50:14 -0800
Message-Id: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.8.13.16 stable kernel.

This version contains 166 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.8.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.8.y-review

The review period for version 3.8.13.16 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.8.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/networking/packet_mmap.txt          |  10 ++
 arch/arm/kernel/process.c                         |   7 +-
 arch/arm/kernel/stacktrace.c                      |   2 +-
 arch/arm/kernel/traps.c                           |   8 +-
 arch/arm/mach-footbridge/dc21285-timer.c          |   9 +-
 arch/arm/mach-pxa/reset.c                         |   8 +-
 arch/arm/mach-pxa/tosa.c                          | 102 ++++++-------
 arch/arm64/kernel/ptrace.c                        |  38 +++--
 arch/powerpc/include/asm/exception-64s.h          |   2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c               |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c               |   4 +
 arch/sparc/include/asm/pgtable_64.h               |   4 +-
 arch/x86/Makefile                                 |   8 +-
 arch/x86/boot/Makefile                            |   6 +-
 arch/x86/boot/compressed/Makefile                 |   1 +
 arch/x86/include/asm/fpu-internal.h               |  13 +-
 arch/x86/include/asm/pgtable.h                    |  11 +-
 arch/x86/kvm/lapic.c                              |  43 +++---
 arch/x86/kvm/lapic.h                              |   4 +-
 arch/x86/kvm/x86.c                                |  40 +-----
 arch/x86/mm/gup.c                                 |  13 ++
 arch/x86/platform/efi/efi.c                       |   7 -
 arch/x86/realmode/rm/Makefile                     |   3 +-
 drivers/acpi/battery.c                            |  23 ++-
 drivers/ata/ahci.c                                |   3 +
 drivers/ata/libata-core.c                         |   3 +
 drivers/ata/libata-scsi.c                         |  21 +++
 drivers/char/i8k.c                                |   7 +
 drivers/char/tpm/tpm_ppi.c                        |  15 +-
 drivers/clk/clk-divider.c                         |   2 +-
 drivers/dma/Kconfig                               |   1 +
 drivers/firewire/sbp2.c                           |   1 -
 drivers/gpio/gpio-msm-v2.c                        |   4 +-
 drivers/gpu/drm/drm_edid.c                        |   8 ++
 drivers/gpu/drm/i915/i915_dma.c                   |  10 ++
 drivers/gpu/drm/i915/i915_drv.c                   |   1 +
 drivers/gpu/drm/i915/i915_gem_context.c           |   2 -
 drivers/gpu/drm/i915/intel_display.c              |   8 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c   |   6 +-
 drivers/gpu/drm/radeon/atombios_i2c.c             |  14 +-
 drivers/gpu/drm/radeon/ni.c                       |  20 ++-
 drivers/gpu/drm/radeon/radeon.h                   |   2 +-
 drivers/gpu/drm/radeon/radeon_kms.c               |   7 +
 drivers/gpu/drm/radeon/rs690.c                    |  11 ++
 drivers/gpu/drm/radeon/si.c                       |  23 ++-
 drivers/hwmon/lm78.c                              |   2 +
 drivers/hwmon/sis5595.c                           |   2 +
 drivers/hwmon/vt8231.c                            |   2 +-
 drivers/hwmon/w83l786ng.c                         |  13 +-
 drivers/iio/adc/ad7887.c                          |  16 ++-
 drivers/md/dm-bufio.c                             |   5 +
 drivers/md/dm-delay.c                             |  23 ++-
 drivers/md/dm-snap.c                              |  71 ++++++++-
 drivers/md/dm-table.c                             |   5 +
 drivers/md/dm-thin-metadata.c                     |   9 ++
 drivers/md/dm-thin-metadata.h                     |   1 +
 drivers/md/dm-thin.c                              |  66 +++++----
 drivers/md/persistent-data/dm-block-manager.c     |   6 +
 drivers/md/persistent-data/dm-block-manager.h     |   1 +
 drivers/media/pci/saa7164/saa7164-core.c          |   4 +-
 drivers/media/usb/dvb-usb-v2/af9035.c             |  46 +++++-
 drivers/mfd/rtsx_pcr.c                            |  10 +-
 drivers/net/ethernet/broadcom/tg3.c               |   5 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c         |   2 +-
 drivers/net/ethernet/tehuti/tehuti.c              |   1 -
 drivers/net/ethernet/xilinx/ll_temac_main.c       |   2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |   2 +-
 drivers/net/hamradio/hdlcdrv.c                    |   2 +
 drivers/net/hamradio/yam.c                        |   1 +
 drivers/net/hyperv/netvsc_drv.c                   |   1 -
 drivers/net/macvtap.c                             |  20 ++-
 drivers/net/tun.c                                 |   2 +
 drivers/net/usb/dm9601.c                          |  34 +++--
 drivers/net/virtio_net.c                          | 119 +++++++++++-----
 drivers/net/wireless/ath/ath9k/ar9002_mac.c       |  52 +++++--
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c    |  22 +--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c     |  25 ++--
 drivers/net/wireless/ath/ath9k/main.c             |   5 +-
 drivers/net/wireless/rtlwifi/pci.c                |   4 +-
 drivers/of/address.c                              |   8 --
 drivers/pci/pci-driver.c                          |  13 +-
 drivers/power/power_supply_core.c                 |  10 +-
 drivers/rtc/rtc-at91rm9200.c                      |   2 +
 drivers/scsi/aacraid/commctrl.c                   |   3 +-
 drivers/scsi/qla2xxx/qla_target.c                 |   9 +-
 drivers/target/iscsi/iscsi_target.c               |  26 ++--
 drivers/target/target_core_device.c               |   5 +
 drivers/target/target_core_file.c                 |   8 +-
 drivers/target/target_core_file.h                 |   5 +-
 drivers/usb/class/cdc-acm.c                       |   2 +
 drivers/usb/class/cdc-wdm.c                       |   8 +-
 drivers/usb/core/hub.c                            |   4 +-
 drivers/usb/dwc3/ep0.c                            |   2 +
 drivers/usb/dwc3/gadget.c                         |   5 +-
 drivers/usb/gadget/composite.c                    |   1 +
 drivers/usb/host/xhci-pci.c                       |   7 +-
 drivers/usb/musb/musb_core.c                      |   9 +-
 drivers/usb/serial/ftdi_sio.c                     |  37 +++--
 drivers/usb/serial/mos7840.c                      |  32 ++---
 drivers/usb/serial/option.c                       |  29 ++++
 drivers/usb/serial/pl2303.c                       |  31 ++--
 drivers/usb/serial/spcp8x5.c                      |  30 ++--
 drivers/usb/serial/zte_ev.c                       |   3 +-
 fs/btrfs/send.c                                   |   4 +-
 fs/ext2/super.c                                   |   1 +
 fs/ext4/ext4_jbd2.c                               |   5 +
 fs/ext4/extents.c                                 |  19 ++-
 fs/ext4/inode.c                                   |   6 -
 fs/ext4/mballoc.c                                 |  11 +-
 fs/ext4/super.c                                   |   4 +-
 fs/xfs/xfs_qm.c                                   |  58 ++++++--
 include/asm-generic/pgtable.h                     |   2 +-
 include/drm/drm_pciids.h                          |   2 +-
 include/linux/auxvec.h                            |   2 +-
 include/linux/compiler-intel.h                    |   2 -
 include/linux/kexec.h                             |   3 +
 include/linux/migrate.h                           |   9 ++
 include/linux/mm_types.h                          |  44 ++++++
 include/linux/net.h                               |   2 +-
 include/linux/netdevice.h                         |   9 ++
 include/sound/memalloc.h                          |   2 +-
 include/target/target_core_base.h                 |   1 +
 include/uapi/drm/radeon_drm.h                     |   2 +
 include/uapi/sound/compress_offload.h             |   6 +-
 kernel/fork.c                                     |   1 +
 kernel/freezer.c                                  |   6 +
 kernel/futex.c                                    |   2 +-
 kernel/kexec.c                                    |   4 +
 kernel/sched/fair.c                               |   7 +
 kernel/sched/rt.c                                 |  14 ++
 kernel/trace/ftrace.c                             |   2 +-
 mm/compaction.c                                   |   4 +
 mm/huge_memory.c                                  |  45 ++++--
 mm/memcontrol.c                                   |  36 +++++
 mm/migrate.c                                      |  69 +++++++--
 mm/mprotect.c                                     |  13 +-
 mm/pgtable-generic.c                              |   8 +-
 net/8021q/vlan_dev.c                              |  19 ++-
 net/bridge/br_multicast.c                         |   4 +-
 net/core/drop_monitor.c                           |   1 -
 net/core/neighbour.c                              |   2 +-
 net/core/netpoll.c                                |  11 +-
 net/core/sock.c                                   |   2 +-
 net/ipv4/inet_diag.c                              |  16 +++
 net/ipv6/route.c                                  |  33 ++---
 net/llc/af_llc.c                                  |   5 +-
 net/mac80211/main.c                               |   1 +
 net/mac80211/rx.c                                 |   3 +-
 net/mac80211/scan.c                               |   2 +-
 net/mac80211/tx.c                                 |  23 +--
 net/packet/af_packet.c                            |  65 +++++----
 net/rds/ib.c                                      |   3 +-
 net/rds/ib_send.c                                 |   5 +-
 net/rose/af_rose.c                                |  16 +--
 net/unix/af_unix.c                                |  16 ++-
 net/wireless/radiotap.c                           |   4 +
 scripts/link-vmlinux.sh                           |   4 +-
 security/selinux/hooks.c                          | 166 ++++++++++++++++++----
 security/selinux/include/objsec.h                 |   5 +-
 security/selinux/include/xfrm.h                   |   9 +-
 security/selinux/xfrm.c                           |  53 +++++--
 sound/core/pcm_lib.c                              |   2 +
 sound/pci/hda/hda_intel.c                         |   4 +
 sound/pci/hda/patch_hdmi.c                        |   6 +-
 sound/soc/codecs/wm5110.c                         |   2 +-
 sound/soc/codecs/wm8904.c                         |   2 +-
 sound/soc/codecs/wm_adsp.c                        |  10 +-
 sound/soc/tegra/tegra20_i2s.c                     |   6 +-
 sound/soc/tegra/tegra20_spdif.c                   |  10 +-
 sound/soc/tegra/tegra30_i2s.c                     |   6 +-
 tools/power/cpupower/utils/cpupower-set.c         |   6 +-
 virt/kvm/kvm_main.c                               |   3 +
 172 files changed, 1651 insertions(+), 690 deletions(-)

Al Viro (1):
      ext4: fix del_timer() misuse for ->s_err_report

Alan Cox (1):
      drivers/char/i8k.c: add Dell XPLS L421X

Alan Stern (1):
      usb: dwc3: fix implementation of endpoint wedge

Alex Deucher (5):
      drm/radeon: fixup bad vram size on SI
      drm/radeon/atom: fix bus probes when hw_i2c is set (v2)
      drm/radeon: Fix sideport problems on certain RS690 boards
      drm/radeon: fix asic gfx values for scrapper asics
      drm/radeon: 0x9649 is SUMO2 not SUMO

Andrey Vagin (1):
      virtio: delete napi structures from netdev before releasing memory

Andy Honig (3):
      KVM: Improve create VCPU parameter (CVE-2013-4587)
      KVM: x86: Fix potential divide by 0 in lapic (CVE-2013-6367)
      KVM: x86: Convert vapic synchronization to _cached functions (CVE-2013-6368)

Anssi Hannula (1):
      ALSA: hda - hdmi: Fix IEC958 ctl indexes for some simple HDMI devices

Antti Palosaari (2):
      [media] af9035: [0ccd:0099] TerraTec Cinergy T Stick Dual RC (rev. 2)
      [media] af9035: add [0413:6a05] Leadtek WinFast DTV Dongle Dual

Ard Biesheuvel (1):
      auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Bjørn Mork (1):
      usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Bo Shen (1):
      ASoC: wm8904: fix DSP mode B configuration

Brian Carnes (1):
      hwmon: (w83l786ng) Fix fan speed control mode setting and reporting

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

Colin Leitner (4):
      USB: spcp8x5: correct handling of CS5 setting
      USB: mos7840: correct handling of CS5 setting
      USB: ftdi_sio: fixed handling of unsupported CSIZE setting
      USB: pl2303: fixed handling of CS5 setting

Curt Brune (1):
      bridge: use spin_lock_bh() in br_multicast_set_hash_max

Dan Carpenter (2):
      hwmon: Prevent some divide by zeros in FAN_TO_REG()
      Btrfs: fix access_ok() check in btrfs_ioctl_send()

Dan Williams (1):
      net_dma: mark broken

Daniel Borkmann (3):
      packet: fix send path when running with proto == 0
      net: inet_diag: zero out uninitialized idiag_{src,dst} fields
      net: llc: fix use after free in llc_ui_recvmsg

Daniel Vetter (1):
      drm/i915: don't update the dri1 breadcrumb with modesetting

David Cluytens (1):
      USB: cdc-acm: Added support for the Lenovo RD02-D400 USB Modem

David Henningsson (1):
      ALSA: hda - Add enable_msi=0 workaround for four HP machines

David S. Miller (2):
      vlan: Fix header ops passthru when doing TX VLAN offload.
      netpoll: Fix missing TXQ unlock and and OOPS.

Dmitry Eremin-Solenikov (1):
      ARM: pxa: tosa: fix keys mapping

Dmitry Kunilov (1):
      usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option

Eric Dumazet (1):
      net: do not pretend FRAGLIST support

Eryu Guan (1):
      ext4: check for overlapping extents in ext4_valid_extent_entries()

Fabrizio Gazzato (1):
      [media] af9035: add ID [0ccd:00aa] TerraTec Cinergy T Stick (rev. 2)

Fangxiaozhi (Franko) (1):
      USB: option: support new huawei devices

Felix Fietkau (1):
      mac80211: move "bufferable MMPDU" check to fix AP mode scan

Florian Westphal (1):
      net: rose: restore old recvmsg behavior

Gleb Natapov (1):
      KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)

Gustavo Zacarias (1):
      USB: serial: option: blacklist interface 1 for Huawei E173s-6

H. Peter Anvin (2):
      x86, build: Pass in additional -mno-mmx, -mno-sse options
      x86, build, icc: Remove uninitialized_var() from compiler-intel.h

Hannes Frederic Sowa (1):
      ipv6: don't count addrconf generated routes against gc limit

Ilia Mirkin (1):
      drm/nouveau/bios: make jump conditional

James Hogan (1):
      clk: clk-divider: fix divisor > 255 bug

Jan Kara (2):
      ext2: Fix oops in ext2_get_block() called from ext2_quota_write()
      ext4: fix deadlock when writing in ENOSPC conditions

Jan Kiszka (1):
      KVM: x86: Fix APIC map calculation after re-enabling

Jason Wang (3):
      macvtap: signal truncated packets
      netvsc: don't flush peers notifying work during setting mtu
      virtio-net: fix refill races during restore

Jean Delvare (1):
      hwmon: (w83l768ng) Fix fan speed control range

Jiang Liu (1):
      ACPI / TPM: fix memory leak when walking ACPI namespace

Jie Liu (1):
      xfs: fix infinite loop by detaching the group/project hints from user dquot

Joe Thornber (4):
      dm thin: switch to read only mode if a mapping insert fails
      dm thin: always fallback the pool mode if commit fails
      dm thin: re-establish read-only state when switching to fail mode
      dm thin: allow pool in read-only mode to transition to read-write mode

Johannes Berg (3):
      mac80211: fix scheduled scan rtnl deadlock
      mac80211: don't attempt to reorder multicast frames
      radiotap: fix bitmap-end-finding buffer overrun

Johannes Weiner (1):
      mm: memcg: fix race condition between memcg teardown and swapin

Jonathan Cameron (1):
      iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

JongHo Kim (1):
      ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Joonsoo Kim (1):
      mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Josh Boyer (1):
      cpupower: Fix segfault due to incorrect getopt_long arugments

Julius Werner (1):
      usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED

Junho Ryu (1):
      ext4: fix use-after-free in ext4_mb_new_blocks

Kamala R (1):
      IPv6: Fixed support for blackhole and prohibit routes

Khalid Aziz (1):
      PCI: Disable Bus Master only on kexec reboot

Kirill Tkhai (1):
      sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Konstantin Khlebnikov (2):
      ARM: 7912/1: check stack pointer in get_wchan
      ARM: 7913/1: fix framepointer check in unwind_frame

Lan Tianyu (1):
      ACPI / Battery: Add a _BIX quirk for NEC LZ750/LS

Larry Finger (1):
      rtlwifi: pci: Fix oops on driver unload

Li RongQing (1):
      ipv6: always set the new created dst's from in ip6_rt_copy

Linus Pizunski (1):
      drivers/rtc/rtc-at91rm9200.c: correct alarm over day/month wrap

Linus Torvalds (2):
      futex: fix handling of read-only-mapped hugepages
      x86, fpu, amd: Clear exceptions in AMD FXSAVE workaround

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Marek Olšák (2):
      drm/radeon: fix render backend setup for SI and CIK
      drm/radeon: expose render backend mask to the userspace

Mathy Vanhoef (1):
      ath9k_htc: properly set MAC address and BSSID mask

Matthew Garrett (1):
      x86, efi: Don't use (U)EFI time services on 32 bit

Mel Gorman (11):
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
      mm: numa: defer TLB flush for THP migration as long as possible

Miao Xie (1):
      ftrace: Initialize the ftrace profiler for each possible cpu

Michael Grzeschik (1):
      usb: gadget: composite: reset delayed_status on reset_config

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Michael S. Tsirkin (3):
      virtio_net: fix error handling for mergeable buffers
      virtio-net: make all RX paths handle errors consistently
      virtio_net: don't leak memory or block when too many frags

Michele Baldessari (1):
      libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Mike Snitzer (1):
      dm thin: switch to read-only mode if metadata space is exhausted

Mikulas Patocka (4):
      dm delay: fix a possible deadlock due to shared workqueue
      dm snapshot: avoid snapshot space leak on crash
      dm table: fail dm_table_create on dm_round_up overflow
      dm bufio: initialize read-only module parameters

Ming Lei (1):
      scripts/link-vmlinux.sh: only filter kernel symbols for arm

Nat Gurumoorthy (1):
      tg3: Initialize REG_BASE_ADDR at PCI config offset 120 to 0

Nicholas Bellinger (2):
      iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set
      target/file: Update hw_max_sectors based on current block_size

Nithin Sujir (1):
      tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Moore (4):
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()

Peter Korsgaard (2):
      dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
      dm9601: work around tx fifo sync issue on dm962x

Rafał Miłecki (1):
      drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Rik van Riel (1):
      mm: fix TLB flush race between migration, and change_protection_range

Rob Herring (1):
      Revert "of/address: Handle #address-cells > 2 specially"

Russell King (2):
      ARM: fix footbridge clockevent device
      ARM: fix "bad mode in ... handler" message for undefined instructions

Salva Peiró (1):
      hamradio/yam: fix info leak in ioctl

Sasha Levin (3):
      net: unix: allow set_peek_off to fail
      net: unix: allow bind to fail on mutex lock
      rds: prevent dereference of a NULL device

Sebastian Andrzej Siewior (1):
      usb: musb: only cancel work if it is initialized

Sergei Ianovich (1):
      ARM: pxa: prevent PXA270 occasional reboot freezes

Shivaram Upadhyayula (1):
      qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Shuah Khan (1):
      power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate

Simon Guinot (1):
      ahci: add PCI ID for Marvell 88SE9170 SATA controller

Stefan Richter (1):
      firewire: sbp2: bring back WRITE SAME support

Stefano Panella (1):
      ALSA: memalloc.h - fix wrong truncation of dma_addr_t

Stephen Boyd (1):
      gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Stephen Warren (1):
      ASoC: tegra: fix uninitialized variables in set_fmt

Steven Rostedt (1):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permission()

Sujith Manoharan (3):
      ath9k: Fix QuickDrop usage
      ath9k: Fix XLNA bias strength
      ath9k: Fix interrupt handling for the AR9002 family

Takashi Iwai (2):
      ALSA: compress: Fix 64bit ABI incompatibility
      xhci: Limit the spurious wakeup fix only to HP machines

Tejun Heo (1):
      libata, freezer: avoid block device removal while system is frozen

Theodore Ts'o (1):
      ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails

Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

Venkat Venkatsubra (1):
      rds: prevent BUG_ON triggered on congestion update to loopback

Vlad Yasevich (1):
      macvtap: Do not double-count received packets

Wei Yongjun (1):
      [media] saa7164: fix return value check in saa7164_initdev()

Wenliang Fan (1):
      drivers/net/hamradio: Integer overflow in hdlcdrv_ioctl()

Will Deacon (1):
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Zhi Yong Wu (2):
      macvtap: update file current position
      tun: update file current position

pingfan liu (1):
      powerpc: kvm: fix rare but potential deadlock scene
