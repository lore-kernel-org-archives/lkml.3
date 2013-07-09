Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3GIU0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 16:26:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3GIU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 16:26:50 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=VwQbUJbxAAAA:8 a=--NxetOjMx6_H9S_jZoA:9 a=QEXdDO2ut3YA:10 a=735174HVZ2jRtmeh:21 a=rSE1ZDUXuchOISGr:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373401608.7458.36.camel@gandalf.local.home>
Subject: Linux 3.6.11.6
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Date: Tue, 09 Jul 2013 16:26:48 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm announcing the release of the 3.6.11.6 kernel.

The updated 3.6.11.y git tree can be found at:

        git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git v3.6-stable

The patch can be downloaded at:
	https://www.kernel.org/pub/linux/kernel/projects/rt/3.6/stable/patch-3.6.11.6.xz

thanks,

-- Steve

 Makefile                                           |    2 +-
 arch/arm/boot/compressed/Makefile                  |    2 +-
 arch/arm/boot/compressed/head-sa1100.S             |    1 +
 arch/arm/boot/compressed/head-shark.S              |    1 +
 arch/arm/boot/compressed/head.S                    |    1 +
 arch/arm/kernel/topology.c                         |    2 +
 arch/arm/mach-kirkwood/ts219-setup.c               |    2 +-
 arch/arm/plat-orion/common.c                       |   12 +-
 arch/avr32/kernel/module.c                         |    2 +-
 arch/m68k/kernel/head.S                            |   29 +-
 arch/powerpc/include/asm/exception-64s.h           |    2 +-
 arch/powerpc/include/asm/machdep.h                 |    3 +
 arch/powerpc/include/asm/pci-bridge.h              |    2 +
 arch/powerpc/kernel/exceptions-64s.S               |    2 +-
 arch/powerpc/kernel/irq.c                          |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   21 ++
 arch/powerpc/kernel/process.c                      |    4 +-
 arch/powerpc/kernel/traps.c                        |   10 +
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   12 +-
 arch/powerpc/platforms/pseries/msi.c               |   21 +-
 arch/powerpc/platforms/pseries/pci.c               |   53 ++++
 arch/powerpc/platforms/pseries/pseries.h           |    4 +
 arch/powerpc/platforms/pseries/setup.c             |    3 +
 arch/x86/kernel/relocate_kernel_64.S               |    2 +-
 arch/x86/xen/smp.c                                 |    8 +
 drivers/acpi/video.c                               |   16 +
 drivers/acpi/video_detect.c                        |    8 +
 drivers/ata/ata_piix.c                             |   15 +
 drivers/ata/libata-core.c                          |    6 +
 drivers/block/brd.c                                |    4 +-
 drivers/block/cciss.c                              |   32 +-
 drivers/char/random.c                              |   24 +-
 drivers/dma/ste_dma40.c                            |    8 +-
 drivers/gpu/drm/drm_irq.c                          |    6 +-
 drivers/gpu/drm/gma500/cdv_intel_display.c         |   14 +
 drivers/gpu/drm/gma500/framebuffer.c               |    4 +-
 drivers/gpu/drm/gma500/psb_intel_display.c         |   14 +
 drivers/gpu/drm/i915/intel_lvds.c                  |    4 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |   12 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c             |    9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   11 +-
 drivers/gpu/drm/radeon/evergreen.c                 |   20 +-
 drivers/gpu/drm/radeon/ni.c                        |   10 +-
 drivers/gpu/drm/radeon/r100.c                      |    9 +-
 drivers/gpu/drm/radeon/r300.c                      |    9 +-
 drivers/gpu/drm/radeon/r420.c                      |   10 +-
 drivers/gpu/drm/radeon/r520.c                      |    9 +-
 drivers/gpu/drm/radeon/r600.c                      |   19 +-
 drivers/gpu/drm/radeon/radeon_device.c             |   19 +-
 drivers/gpu/drm/radeon/rs400.c                     |    9 +-
 drivers/gpu/drm/radeon/rs600.c                     |    9 +-
 drivers/gpu/drm/radeon/rs690.c                     |    9 +-
 drivers/gpu/drm/radeon/rv515.c                     |    9 +-
 drivers/gpu/drm/radeon/rv770.c                     |   19 +-
 drivers/gpu/drm/radeon/si.c                        |   12 +-
 drivers/hwmon/adm1021.c                            |   58 +++-
 drivers/iio/frequency/adf4350.c                    |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   32 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    1 +
 drivers/input/touchscreen/egalax_ts.c              |    2 +-
 drivers/iommu/amd_iommu.c                          |   31 +-
 drivers/iommu/amd_iommu_types.h                    |    1 +
 drivers/leds/leds-ot200.c                          |   14 +-
 drivers/md/raid1.c                                 |   34 ++-
 drivers/md/raid10.c                                |   26 +-
 drivers/net/ethernet/broadcom/tg3.c                |   70 ++++-
 drivers/net/ethernet/broadcom/tg3.h                |    6 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   10 +-
 drivers/net/wireless/ath/ath9k/Makefile            |    2 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   10 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |    9 +-
 drivers/net/wireless/ath/ath9k/init.c              |    7 +-
 drivers/net/wireless/ath/ath9k/rc.h                |    2 +-
 drivers/net/wireless/b43/main.c                    |    2 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |    2 +-
 drivers/net/xen-netback/netback.c                  |  311 ++++++++++++++++----
 drivers/net/xen-netfront.c                         |   17 +-
 drivers/rapidio/devices/tsi721.c                   |   12 +
 drivers/regulator/palmas-regulator.c               |    2 +-
 drivers/rtc/rtc-twl.c                              |    1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |    8 +-
 drivers/target/iscsi/iscsi_target_parameters.h     |    4 +-
 drivers/target/target_core_transport.c             |   18 +-
 drivers/tty/n_tty.c                                |    8 +
 drivers/usb/atm/cxacru.c                           |    3 +-
 drivers/usb/core/quirks.c                          |    3 +
 drivers/usb/dwc3/gadget.c                          |   17 +-
 drivers/usb/host/uhci-hub.c                        |    3 +-
 drivers/usb/host/xhci-mem.c                        |   27 +-
 drivers/usb/host/xhci-pci.c                        |   10 +
 drivers/usb/host/xhci.c                            |   16 +-
 drivers/usb/host/xhci.h                            |    3 +
 drivers/usb/serial/ark3116.c                       |    2 +-
 drivers/usb/serial/cypress_m8.c                    |   18 +-
 drivers/usb/serial/cypress_m8.h                    |    4 +
 drivers/usb/serial/ftdi_sio.c                      |    2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |    2 +
 drivers/usb/serial/generic.c                       |   31 ++
 drivers/usb/serial/io_ti.c                         |   14 +
 drivers/usb/serial/iuu_phoenix.c                   |    4 +-
 drivers/usb/serial/keyspan.c                       |    2 +-
 drivers/usb/serial/mos7720.c                       |   25 +-
 drivers/usb/serial/mos7840.c                       |   35 ++-
 drivers/usb/serial/option.c                        |   11 +
 drivers/usb/serial/pl2303.c                        |   10 +-
 drivers/usb/serial/qcserial.c                      |    1 +
 drivers/usb/serial/spcp8x5.c                       |   10 +-
 drivers/usb/serial/usb-serial.c                    |   19 ++
 drivers/usb/serial/visor.c                         |    9 +
 drivers/usb/serial/whiteheat.c                     |    2 +-
 fs/ceph/locks.c                                    |   73 +++--
 fs/ceph/mds_client.c                               |   90 +++---
 fs/ceph/super.h                                    |    9 +-
 fs/cifs/cifs_dfs_ref.c                             |    4 +-
 fs/cifs/inode.c                                    |    3 +-
 fs/ecryptfs/file.c                                 |    6 +
 fs/fat/inode.c                                     |   15 +-
 fs/jfs/inode.c                                     |    2 +-
 fs/jfs/jfs_logmgr.c                                |    3 +-
 fs/nfs/nfs4proc.c                                  |    2 +-
 fs/nilfs2/inode.c                                  |   27 +-
 fs/ocfs2/extent_map.c                              |    2 +-
 fs/proc/kmsg.c                                     |   10 +-
 fs/reiserfs/dir.c                                  |    2 +
 fs/reiserfs/inode.c                                |    9 +-
 fs/reiserfs/xattr.c                                |   14 +-
 fs/reiserfs/xattr_acl.c                            |    3 +
 fs/xfs/xfs_iops.c                                  |   47 ++-
 include/linux/ceph/auth.h                          |   18 ++
 include/linux/cpu.h                                |    4 +
 include/linux/swapops.h                            |    3 +
 include/linux/syslog.h                             |    4 +-
 include/linux/usb/serial.h                         |    4 +
 include/linux/wait.h                               |   16 +-
 include/net/bluetooth/hci_core.h                   |    1 +
 include/net/bluetooth/mgmt.h                       |    1 +
 include/target/target_core_base.h                  |    1 +
 include/xen/interface/io/netif.h                   |   19 ++
 kernel/cpu.c                                       |   55 ++--
 kernel/printk.c                                    |   91 +++---
 kernel/sys.c                                       |   29 +-
 kernel/trace/trace.c                               |   10 +-
 mm/huge_memory.c                                   |    7 +-
 mm/hugetlb.c                                       |    2 +-
 mm/memcontrol.c                                    |   14 +-
 mm/migrate.c                                       |   25 +-
 mm/pagewalk.c                                      |   70 ++---
 mm/swap_state.c                                    |   18 +-
 net/bluetooth/hci_core.c                           |    6 +-
 net/bluetooth/mgmt.c                               |   21 ++
 net/ceph/auth.c                                    |  117 ++++++--
 net/ceph/auth_x.c                                  |   24 +-
 net/ceph/auth_x.h                                  |    1 +
 net/ceph/messenger.c                               |    3 +-
 net/ceph/mon_client.c                              |    7 +-
 net/ceph/osd_client.c                              |   27 +-
 net/mac80211/iface.c                               |    9 +
 net/mac80211/rx.c                                  |    3 +
 net/sunrpc/sched.c                                 |    8 +-
 net/wireless/core.c                                |   16 +-
 net/wireless/sme.c                                 |    3 +
 sound/soc/codecs/cs42l52.c                         |    2 +-
 sound/usb/mixer.c                                  |    1 +
 sound/usb/quirks-table.h                           |   14 +-
 tools/perf/scripts/python/net_dropmonitor.py       |    8 +-
 165 files changed, 1880 insertions(+), 650 deletions(-)
---------------------------
Adis Hamzić (1):
      radeon: Fix system hang issue when using KMS with older cards

Alan Stern (2):
      USB: xHCI: override bogus bulk wMaxPacketSize values
      USB: UHCI: fix for suspend of virtual HP controller

Alex Deucher (3):
      drm/radeon: fix typo in cu_per_sh on verde
      drm/radeon: fix card_posted check for newer asics
      drm/radeon: don't allow audio on DCE6

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Alex Lyakas (1):
      md/raid1: consider WRITE as successful only if at least one non-Faulty and non-rebuilding drive completed it.

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in MSI interrupt handling

Aneesh Kumar K.V (1):
      mm/THP: use pmd_populate() to update the pmd with pgtable_t pointer

Arnd Bergmann (2):
      ARM: 7742/1: topology: export cpu_topology
      ARM: 7743/1: compressed/head.S: work around new binutils warning

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Bastian Triller (1):
      ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist

Ben Hutchings (2):
      perf: net_dropmonitor: Fix trace parameter order
      perf: net_dropmonitor: Fix symbol-relative addresses

Ben Mesman (1):
      drm/i915: no lvds quirk for hp t5740

Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Bjørn Mork (1):
      USB: option: blacklist network interface on Huawei E1820

Brian Behlendorf (1):
      drivers/block/brd.c: fix brd_lookup_page() race

Brian King (2):
      powerpc: Set default VGA device
      powerpc/pseries: Force 32 bit MSIs for devices that require it

Chew, Chiau Ee (1):
      ata_piix: add PCI IDs for Intel BayTail

Christian Gmeiner (1):
      drivers/leds/leds-ot200.c: fix error caused by shifted mask

Christopher Harvey (1):
      drm/mgag200: Add missing write to index before accessing data register

Clemens Ladisch (1):
      ALSA: usb-audio: fix Roland/Cakewalk UM-3G support

Cliff Wickman (1):
      mm/pagewalk.c: walk_page_range should avoid VM_PFNMAP areas

Dan Carpenter (1):
      USB: cxacru: potential underflow in cxacru_cm_get_array()

Dan Williams (1):
      USB: option: add device IDs for Dell 5804 (Novatel E371) WWAN card

Daniel Vetter (1):
      drm/i915: prefer VBT modes for SVDO-LVDS over EDID

Dave Chinner (1):
      xfs: kill suid/sgid through the truncate path.

Dave Kleikamp (1):
      jfs: fix a couple races

Egbert Eich (1):
      drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.

Emmanuel Grumbach (1):
      iwlwifi: dvm: fix zero LQ CMD sending avoidance

Felix Fietkau (1):
      Revert "ath9k_hw: Update rx gain initval to improve rx sensitivity"

Finn Thain (1):
      m68k/mac: Fix unexpected interrupt with CONFIG_EARLY_PRINTK

Gabor Juhos (1):
      ath9k: use correct OTP register offsets for AR9550

Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

George Cherian (1):
      usb: dwc3: gadget: free trb pool only from epnum 2

Gomella, Andrew (NIH/NHLBI) [F] (1):
      USB: ftdi_sio: Add support for Newport CONEX motor drivers

Gregory CLEMENT (1):
      ARM: plat-orion: Fix num_resources and id for ge10 and ge11

Guenter Roeck (1):
      hwmon: (adm1021) Strengthen chip detection for ADM1021, LM84 and MAX1617

Hans-Christian Egtvedt (1):
      avr32: fix relocation check for signed 18-bit offset

Heiko Abraham (1):
      Input: egalax_ts - ABS_MT_POSITION_Y not reported well

Huacai Chen (1):
      drm: fix a use-after-free when GPU acceleration disabled

Imre Deak (1):
      wait: fix false timeouts when using wait_event_timeout()

Jeff Layton (2):
      cifs: only set ops for inodes in I_NEW state
      cifs: fix potential buffer overrun when composing a new options string

Jeff Mahoney (3):
      reiserfs: fix deadlock with nfs racing on create/lookup
      reiserfs: fix problems with chowning setuid file w/ xattrs
      reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry

Jim Schutt (2):
      ceph: add cpu_to_le32() calls when encoding a reconnect capability
      ceph: ceph_pagelist_append might sleep while atomic

Jiri Kosina (1):
      random: fix accounting race condition with lockless irq entropy_count update

Joerg Roedel (1):
      iommu/amd: Workaround for ERBT1312

Johan Hedberg (1):
      Bluetooth: Fix mgmt handling of power on failures

Johan Hovold (15):
      USB: iuu_phoenix: fix bulk-message timeout
      USB: keyspan: fix bogus array index
      USB: ark3116: fix control-message timeout
      USB: visor: fix initialisation of Treo/Kyocera devices
      USB: whiteheat: fix broken port configuration
      USB: serial: fix Treo/Kyocera interrrupt-in urb context
      USB: mos7840: fix DMA to stack
      USB: mos7720: fix DMA to stack
      USB: mos7720: fix message timeouts
      USB: mos7720: fix hardware flow control
      USB: serial: add wait_until_sent operation
      USB: serial: add generic wait_until_sent implementation
      USB: io_ti: fix chars_in_buffer overhead
      USB: pl2303: fix device initialisation at open
      USB: spcp8x5: fix device initialisation at open

Johannes Berg (4):
      cfg80211: fix wiphy_register error path
      mac80211: fix AP-mode frame matching
      mac80211: close AP_VLAN interfaces before unregistering all
      cfg80211: check wdev->netdev in connection work

Johannes Weiner (1):
      mm: memcg: remove incorrect VM_BUG_ON for swap cache pages in uncharge

Joseph Qi (1):
      ocfs2: goto out_unlock if ocfs2_get_clusters_nocache() failed in ocfs2_fiemap()

Kees Cook (4):
      iscsi-target: fix heap buffer overflow on error
      b43: stop format string leaking into error msgs
      kmsg: honor dmesg_restrict sysctl on /dev/kmsg
      x86: Fix typo in kexec register clearing

Kishon Vijay Abraham I (1):
      regulator: palmas: Fix "enable_reg" to point to the correct reg for SMPS10

Kleber Sacilotto de Souza (2):
      powerpc/pseries: Perform proper max_bus_speed detection
      radeon: use max_bus_speed to activate gen2 speeds

Konrad Rzeszutek Wilk (1):
      xen/smp: Fixup NOHZ per cpu data when onlining an offline CPU.

Leonid Yegoshin (1):
      mm compaction: fix of improper cache flush in migration code

Martin Michlmayr (1):
      Kirkwood: Enable PCIe port 1 on QNAP TS-11x/TS-21x

Michael Chan (1):
      tg3: Fix data corruption on 5725 with TSO

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Michael Hennerich (1):
      iio: frequency: ad4350: Fix bug / typo in mask

Naoya Horiguchi (1):
      mm: migration: add migrate_entry_wait_huge()

NeilBrown (1):
      md/raid1,raid10: use freeze_array in place of raise_barrier in various places.

Nicholas Bellinger (2):
      ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
      target: Re-instate sess_wait_list for target_wait_for_sess_cmds

Nicolas Schichan (1):
      ASoC: cs42l52: fix default value for MASTERA_VOL.

Nithin Sujir (2):
      tg3: Skip powering down function 0 on certain serdes devices
      tg3: Add read dma workaround for 5720

OGAWA Hirofumi (1):
      fat: fix possible overflow for fat_clusters

Oliver Neukum (1):
      USB: reset resume quirk needed by a hub

Patrik Jakobsson (3):
      drm/gma500: Increase max resolution for mode setting
      drm/gma500/psb: Unpin framebuffer on crtc disable
      drm/gma500/cdv: Unpin framebuffer on crtc disable

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

Paul Taysom (1):
      ecryptfs: fixed msync to flush data

Rabin Vincent (1):
      dmaengine: ste_dma40: fix pm runtime ref counting

Rafael Aquini (1):
      swap: avoid read_swap_cache_async() race to deadlock while waiting on discard I/O completion

Richard Weinberger (1):
      USB: serial: Add Option GTM681W to qcserial device table.

Robert Butora (1):
      USB: Serial: cypress_M8: Enable FRWD Dongle hidcom device

Robin Holt (1):
      reboot: rigrate shutdown/reboot to boot cpu

Ryusuke Konishi (1):
      nilfs2: fix issue of nilfs_set_page_dirty() for page at EOF boundary

Sage Weil (5):
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex

Sarah Sharp (1):
      xhci: Disable D3cold for buggy TI redrivers.

Schemmel Hans-Christoph (1):
      USB: Blacklisted Cinterion's PLxx WWAN Interface

Sergio Aguirre (1):
      xhci-mem: init list heads at the beginning of init

Srivatsa S. Bhat (1):
      CPU hotplug: provide a generic helper to disable/enable CPU hotplug

Stephen M. Cameron (1):
      cciss: fix broken mutex usage in ioctl

Steven Rostedt (Red Hat) (2):
      tracing: Use current_uid() for critical time tracing
      Linux 3.6.11.6

Sujith Manoharan (2):
      ath9k: Disable PowerSave by default
      ath9k: Use minstrel rate control by default

Suravee Suthikulpanit (1):
      iommu/amd: Re-enable IOMMU event log interrupt after handling.

Takashi Iwai (2):
      ALSA: usb-audio - Apply Logitech QuickCam Pro 9000 quirk only to audio iface
      ALSA: usb-audio - Fix invalid volume resolution on Logitech HD webcam c270

Teppo Kotilainen (1):
      usb: option: Add Telewell TW-LTE 4G

Tony Camuso (1):
      xhci - correct comp_mode_recovery_timer on return from hibernate

Tony Lindgren (1):
      drivers/rtc/rtc-twl.c: fix missing device_init_wakeup() when booted with device tree

Trond Myklebust (2):
      SUNRPC: Prevent an rpc_task wakeup race
      NFSv4: Fix a thinko in nfs4_try_open_cached

Tyler Hicks (1):
      eCryptfs: Check return of filemap_write_and_wait during fsync

Vincent Pelletier (1):
      libata: make ata_exec_internal_sg honor DMADIR

Vladimir Murzin (1):
      xhci: fix list access before init

Wang YanQing (1):
      TTY: Fix tty miss restart after we turn off flow-control

Wei Liu (7):
      xen-netback: remove skb in xen_netbk_alloc_page
      xen-netback: coalesce slots in TX path and fix regressions
      xen-netback: don't disconnect frontend when seeing oversize packet
      xen-netback: remove redundent parameter in netbk_count_requests
      xen-netback: avoid allocating variable size array on stack
      xen-netfront: reduce gso_max_size to account for max TCP header
      xen-netback: better names for thresholds

----


