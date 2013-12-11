Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab3LKQjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:39:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3LKQj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:39:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.14
Date: Wed, 11 Dec 2013 08:39:22 -0800
Message-Id: <1386779963-29812-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.14 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.13 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/sysctl/kernel.txt               |  25 ++--
 Makefile                                      |   2 +-
 arch/arm/kernel/entry-armv.S                  |  46 +------
 arch/arm/kernel/entry-header.S                |  38 +++++-
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-omap2/irq.c                     |   2 +-
 arch/arm/mach-omap2/omap_device.c             |  19 ++-
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/arm/mm/extable.c                         |   7 +-
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ---
 arch/cris/include/asm/io.h                    |   1 +
 arch/ia64/include/asm/processor.h             |   2 +-
 arch/powerpc/kernel/signal_32.c               |  10 +-
 arch/powerpc/kernel/time.c                    |   4 +-
 arch/powerpc/kernel/vio.c                     |   4 +-
 arch/powerpc/platforms/powernv/pci-ioda.c     |  12 +-
 arch/s390/kernel/smp.c                        |   4 +-
 arch/s390/kernel/vtime.c                      |   2 +-
 arch/x86/include/asm/apic.h                   |   2 +
 arch/x86/kernel/apic/io_apic.c                |   5 +
 arch/x86/kernel/crash.c                       |   6 +-
 arch/x86/kernel/ftrace.c                      |  14 ++-
 arch/x86/kernel/microcode_amd.c               |   2 +-
 arch/x86/kernel/reboot.c                      |   8 +-
 arch/x86/kvm/emulate.c                        |   5 +-
 block/blk-core.c                              |   5 +-
 block/blk-settings.c                          |   1 +
 block/blk-timeout.c                           |   3 +-
 crypto/asymmetric_keys/x509_public_key.c      |  38 ------
 drivers/acpi/ec.c                             |   3 +-
 drivers/ata/ahci.c                            |   4 +
 drivers/ata/libahci.c                         |  16 +++
 drivers/ata/libata-core.c                     |   1 +
 drivers/ata/libata-transport.c                |  16 +--
 drivers/block/brd.c                           |   2 +-
 drivers/block/loop.c                          |  21 ++--
 drivers/block/xen-blkback/blkback.c           |   3 +-
 drivers/edac/highbank_l2_edac.c               |  18 +--
 drivers/edac/highbank_mc_edac.c               |  18 +--
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/radeon/atombios_crtc.c        |   2 +-
 drivers/gpu/drm/radeon/atombios_i2c.c         |   5 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/radeon/radeon_semaphore.c     |   6 +-
 drivers/gpu/drm/radeon/radeon_trace.h         |  36 ++++++
 drivers/gpu/drm/radeon/sid.h                  |   2 +-
 drivers/gpu/drm/shmobile/Kconfig              |   1 +
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  30 +++--
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c      |  41 +++++-
 drivers/hwmon/lm90.c                          |  11 +-
 drivers/i2c/muxes/i2c-mux-gpio.c              |   8 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |  11 +-
 drivers/infiniband/ulp/srp/ib_srp.c           |  20 +--
 drivers/md/dm-mpath.c                         |  18 ++-
 drivers/md/dm-table.c                         |  18 ++-
 drivers/md/md.c                               |   1 +
 drivers/mtd/devices/m25p80.c                  |  20 ++-
 drivers/mtd/nand/nand_base.c                  |  15 ++-
 drivers/net/can/c_can/c_can.c                 |   6 +-
 drivers/net/can/usb/kvaser_usb.c              |  20 +--
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |   3 +-
 drivers/net/virtio_net.c                      |  13 +-
 drivers/net/wireless/libertas/debugfs.c       |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/mwifiex/uap_txrx.c       |  29 ++++-
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |   2 +-
 drivers/net/wireless/rt2x00/rt2800usb.c       |  12 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c       |   3 +-
 drivers/net/wireless/rt2x00/rt2x00lib.h       |   2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c       |   7 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c     |   4 +-
 drivers/net/wireless/rtlwifi/base.c           |  89 ++++++-------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   8 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/net/xen-netback/common.h              |   1 +
 drivers/net/xen-netback/interface.c           |   3 +-
 drivers/net/xen-netback/netback.c             |  10 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/pinctrl/mvebu/pinctrl-dove.c          |   2 +-
 drivers/s390/net/qeth_core_main.c             |   6 +-
 drivers/scsi/sd.c                             |   5 +-
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/target/target_core_transport.c        |   2 +
 drivers/usb/core/hub.c                        |  11 ++
 drivers/usb/musb/musb_core.c                  |   1 +
 drivers/usb/serial/mos7840.c                  |   4 +
 drivers/usb/serial/option.c                   |  17 +++
 drivers/usb/wusbcore/wa-rpipe.c               |   5 +-
 drivers/usb/wusbcore/wa-xfer.c                |   5 +-
 drivers/video/backlight/atmel-pwm-bl.c        |  10 +-
 drivers/video/console/sticore.c               | 166 ++++++++++++++----------
 drivers/video/sticore.h                       |  62 +++++++--
 drivers/video/stifb.c                         |  10 +-
 fs/cifs/cifssmb.c                             |   8 +-
 fs/configfs/dir.c                             |  16 ++-
 fs/coredump.c                                 |   2 +-
 fs/devpts/inode.c                             |   1 +
 fs/exec.c                                     |  16 ++-
 fs/ext4/xattr.c                               |   1 +
 fs/nfs/nfs4proc.c                             |   4 +-
 fs/nfsd/nfs4xdr.c                             |   3 +-
 fs/nfsd/vfs.c                                 | 173 +++++++++++++++-----------
 fs/proc/internal.h                            |   3 +-
 include/linux/binfmts.h                       |   3 -
 include/linux/msg.h                           |   6 +-
 include/linux/mtd/map.h                       |   4 +-
 include/linux/sched.h                         |   7 +-
 include/linux/vm_event_item.h                 |   1 +
 include/net/ip6_fib.h                         |   1 +
 ipc/msgutil.c                                 | 116 +++++++++--------
 ipc/util.h                                    |   4 +-
 kernel/audit.c                                |  17 +--
 kernel/power/snapshot.c                       |   6 +-
 kernel/ptrace.c                               |   3 +-
 kernel/sysctl.c                               |   2 +-
 kernel/trace/trace_event_perf.c               |   2 +-
 lib/vsprintf.c                                |  33 ++++-
 mm/huge_memory.c                              |  19 ++-
 mm/mmap.c                                     |  10 +-
 mm/mprotect.c                                 |  18 ++-
 mm/vmstat.c                                   |   1 +
 net/core/flow_dissector.c                     |   2 +-
 net/ipv6/route.c                              |   9 +-
 net/sunrpc/clnt.c                             |  34 ++---
 net/sunrpc/rpc_pipe.c                         |   2 +-
 net/sunrpc/xprtsock.c                         |  28 +++--
 net/wireless/scan.c                           |   4 +-
 security/integrity/ima/ima_policy.c           |   1 -
 security/selinux/netlabel.c                   |   6 +-
 sound/drivers/pcsp/pcsp.c                     |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                |   4 +-
 sound/pci/hda/hda_codec.c                     |   7 +-
 sound/pci/hda/hda_intel.c                     |  10 +-
 sound/pci/hda/patch_conexant.c                |   3 +
 sound/pci/hda/patch_realtek.c                 |  60 +++++++++
 sound/soc/blackfin/bf5xx-i2s.c                |   1 +
 sound/soc/codecs/ak4642.c                     |   2 +-
 sound/soc/codecs/cs42l52.h                    |   2 +-
 sound/soc/codecs/wm5110.c                     |  43 ++++++-
 sound/soc/codecs/wm8962.c                     |   2 +
 sound/soc/fsl/imx-pcm-fiq.c                   |  29 +++--
 sound/usb/6fire/chip.c                        |   2 +-
 virt/kvm/iommu.c                              |   4 +
 virt/kvm/kvm_main.c                           |  19 +--
 154 files changed, 1344 insertions(+), 722 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Akira Takeuchi (1):
      mm: ensure get_unmapped_area() returns higher address than mmap_min_addr

Alex Deucher (2):
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL
      drm/radeon: don't share PPLLs on DCE4.1

Alex Williamson (1):
      KVM: Fix iommu map/unmap to handle memory slot moves

Andreas Bießmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Anton Blanchard (1):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Bart Van Assche (2):
      IB/srp: Avoid offlining operational SCSI devices
      IB/srp: Report receive errors correctly

Ben Hutchings (1):
      cxgb3: Fix length calculation in write_ofld_wr() on 32-bit architectures

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence

Bernd Schubert (1):
      [SCSI] sd: Reduce buffer size for vpd request

Brian Austin (1):
      ASoC: cs42l52: Correct MIC CTL mask

Brian Norris (2):
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size

Charles Keepax (1):
      ASoC: wm5110: Add post SYSCLK register patch for rev D chip

Christian König (1):
      drm/radeon: add semaphore trace point

Christoph Hellwig (2):
      nfsd: split up nfsd_setattr
      nfsd: make sure to balance get/put_write_access

Dan Carpenter (1):
      libertas: potential oops in debugfs

Dan Williams (1):
      prism54: set netdev type to "wlan"

Daniel Vetter (1):
      drm/i915: flush cursors harder

David Howells (1):
      X.509: Remove certificate date checks

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Felix Fietkau (1):
      rt2x00: fix a crash bug in the HT descriptor handling fix

Fenghua Yu (1):
      x86/apic: Disable I/O APIC before shutdown of the local APIC

Gavin Shan (1):
      powerpc/powernv: Add PE to its own PELTV

Greg Edwards (1):
      KVM: IOMMU: hva align mapping page size

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Gwendal Grignou (1):
      libata: Fix display of sata speed

Hannes Frederic Sowa (2):
      ipv6: ip6_dst_check needs to check for expired dst_entries
      ipv6: reset dst.expires value when clearing expire flag

Helge Deller (1):
      parisc: sticon - unbreak on 64bit kernel

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Ionut Nicu (2):
      i2c: mux: gpio: use gpio_set_value_cansleep()
      i2c: mux: gpio: use reg value for i2c_add_mux_adapter

J. Bruce Fields (1):
      nfsd4: fix xdr decoding of large non-write compounds

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

James Ralston (1):
      ahci: Add Device IDs for Intel Wildcat Point-LP

Jan Kara (1):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()

Jason Wang (2):
      virtio-net: correctly handle cpu hotplug notifier during resuming
      net: flow_dissector: fail on evil iph->ihl

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jerome Glisse (2):
      radeon/i2c: do not count reg index in number of i2c byte we are writing.
      radeon: workaround pinning failure on low ram gpu

Johan Hovold (3):
      USB: mos7840: fix tiocmget error handling
      backlight: atmel-pwm-bl: fix reported brightness
      backlight: atmel-pwm-bl: fix gpio polarity in remove

Johannes Berg (1):
      cfg80211: fix scheduled scan pointer access

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Julius Werner (1):
      usb: hub: Clear Port Reset Change during init/resume

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

Kailang Yang (2):
      ALSA: hda - Add support of new codec ALC233
      ALSA: hda - Add support of ALC255 codecs

Kamal Mostafa (1):
      Linux 3.8.13.14

Kees Cook (2):
      coredump: remove redundant defines for dumpable states
      exec/ptrace: fix get_dumpable() incorrect tests

Kevin Hao (1):
      ftrace/x86: skip over the breakpoint for ftrace caller

Larry Finger (3):
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors

Laurent Pinchart (1):
      drm: shmobile: Add dependency on BACKLIGHT_CLASS_DEVICE

Marc Zyngier (1):
      ARM: 7876/1: clear Thumb-2 IT state on exception handling

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Markus Pargmann (2):
      ARM: OMAP2+: irq, AM33XX add missing register check
      can: c_can: Fix RX message handling, handle lost message before EOB

Martin Schwidefsky (1):
      s390/vtime: correct idle time calculation

Mathias Krause (3):
      audit: fix info leak in AUDIT_GET requests
      audit: use nlmsg_len() to get message payload length
      ipc, msg: fix message length check for negative values

Mauro Carvalho Chehab (1):
      cris: media platform drivers: fix build

Mel Gorman (2):
      mm: Only flush TLBs if a transhuge PMD is modified for NUMA pte scanning
      mm: numa: return the number of base pages altered by protection changes

Michael Neuling (1):
      powerpc/signals: Mark VSX not saved with small contexts

Mike Marciniszyn (1):
      IB/qib: Fix txselect regression

Mike Snitzer (1):
      block: properly stack underlying max_segment_size to DM device

Mikulas Patocka (5):
      dm: allocate buffer for messages with small number of arguments using GFP_NOIO
      blk-core: Fix memory corruption if blkcg_init_queue fails
      loop: fix crash if blk_alloc_queue fails
      block: fix a probe argument to blk_register_region
      loop: fix crash when using unassigned loop device

Mimi Zohar (1):
      Revert "ima: policy for RAMFS"

NeilBrown (1):
      md: fix calculation of stacking limits on level change.

Nicholas Bellinger (1):
      target: Fix delayed Task Aborted Status (TAS) handling bug

Nicolin Chen (1):
      ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Nishanth Menon (1):
      ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume

Olivier Sobrie (1):
      can: kvaser_usb: fix usb endpoints detection

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced situations

Paolo Bonzini (1):
      KVM: x86: fix emulation of "movzbl %bpl, %eax"

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Hurley (4):
      ipc: clamp with min()
      ipc: separate msg allocation from userspace copy
      ipc: tighten msg copy loops
      ipc: set EFAULT as default error in load_msg()

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Prarit Bhargava (1):
      powerpc/vio: use strcpy in modalias_show

Puneet Kumar (1):
      ACPI / EC: Ensure lock is acquired before accessing ec struct members

Robert Richter (1):
      edac, highbank: Fix interrupt setup of mem and l2 controller

Roel Kluin (1):
      pinctrl: dove: unset twsi option3 for gconfig as well

Rui li (1):
      USB：add new zte 3g-dongle's pid to option.c

Russell King (3):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately
      ARM: entry: move IRQ tracing exit into svc_exit
      ARM: entry: move disable_irq_notrace into svc_exit

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Sarah Sharp (1):
      usb: Disable USB 2.0 Link PM before device reset.

Sebastian Andrzej Siewior (1):
      usb: musb: cancel work on removal

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH drive

Shiva Krishna Merla (1):
      dm mpath: fix race condition between multipath_dtr and pg_init_done

Stanislav Kinsbursky (1):
      SUNRPC: fix races on PipeFS UMOUNT notifications

Stanislaw Gruszka (4):
      rt2400pci: fix RSSI read
      rt2x00: check if device is still available on rt2x00mac_flush()
      rt2800usb: slow down TX status polling
      rt2x00: fix HT TX descriptor settings regression

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (1):
      perf/ftrace: Fix paranoid level for enabling function tracer

Takashi Iwai (12):
      ALSA: 6fire: Fix probe of multiple cards
      ALSA: hda - Enable SPDIF for Acer TravelMate 6293
      ALSA: hda - Force buffer alignment for Haswell HDMI controllers
      ALSA: hda - Add support for CX20952
      ALSA: hda - Add pincfg fixup for ASUS W5A
      ALSA: msnd: Avoid duplicated driver name
      ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
      ASoC: blackfin: Fix missing break
      ALSA: pcsp: Fix the order of input device unregistration
      ALSA: hda - Fix unbalanced runtime PM notification at resume
      ALSA: hda - Fix the headphone jack detection on Sony VAIO TX
      ALSA: hda - Provide missing pin configs for VAIO with ALC260

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (3):
      drm/ttm: Fix ttm_bo_move_memcpy
      drm/ttm: Fix memory type compatibility check
      drm/vmwgfx: Resource evict fixes

Thomas Pugliese (2):
      usb: wusbcore: set the RPIPE wMaxPacketSize value correctly
      usb: wusbcore: change WA_SEGS_MAX to a legal value

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Trond Myklebust (3):
      NFSv4: Fix a use-after-free situation in _nfs4_proc_getlk()
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
      SUNRPC: Avoid deep recursion in rpc_release_client

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Ujjal Roy (1):
      mwifiex: fix wrong eth_hdr usage for bridged packets in AP mode

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Vegard Nossum (1):
      xen/blkback: fix reference counting

Vu Pham (1):
      IB/srp: Remove target from list before freeing Scsi_Host structure

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Wang Xingchao (1):
      ALSA - HDA: New PCI ID for Haswell ULT

Wei Liu (1):
      xen-netback: use jiffies_64 value to calculate credit timeout

Weston Andros Adamson (1):
      NFSv4: fix NULL dereference in open recover

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

Yoshihiro YUNOMAE (1):
      x86/ioapic/kcrash: Prevent crash_kexec() from deadlocking on ioapic_lock

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset

