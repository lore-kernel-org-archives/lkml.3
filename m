Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbaIOWKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:10:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50389 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaIOWKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [3.13.y.z extended stable] Linux 3.13.11.7 stable review
Date: Mon, 15 Sep 2014 15:06:50 -0700
Message-Id: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
X-Extended-Stable: 3.13
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.13.11.7 stable kernel.

This version contains 187 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.13.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.13.y-review

The review period for version 3.13.11.7 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.13.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Kamal

--
 Documentation/sound/alsa/ALSA-Configuration.txt    |   4 +-
 Documentation/stable_kernel_rules.txt              |   3 +
 Documentation/x86/x86_64/mm.txt                    |   2 +
 arch/arm/mach-omap2/control.c                      |   3 +-
 arch/ia64/pci/fixup.c                              |  22 ++
 arch/mips/include/asm/ptrace.h                     |   2 +-
 arch/mips/include/asm/reg.h                        | 260 +++++++++++-------
 arch/mips/kernel/binfmt_elfo32.c                   |  32 +--
 arch/mips/kernel/irq-gic.c                         |   6 +-
 arch/mips/kernel/ptrace.c                          | 192 ++++++++++---
 arch/mips/kernel/unaligned.c                       |   1 -
 arch/mips/mm/tlbex.c                               |   1 +
 arch/powerpc/include/asm/machdep.h                 |   6 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |   2 +-
 arch/powerpc/include/asm/pte-hash64-64k.h          |  30 ++-
 arch/powerpc/kvm/book3s_pr_papr.c                  |   9 +-
 arch/powerpc/mm/hash_native_64.c                   |  40 +--
 arch/powerpc/mm/hugepage-hash64.c                  |  88 +++++-
 arch/powerpc/mm/numa.c                             |   2 +-
 arch/powerpc/mm/pgtable_64.c                       |  38 +--
 arch/powerpc/mm/tlb_hash64.c                       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |   2 +-
 arch/powerpc/platforms/pseries/lpar.c              |  20 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +-
 arch/s390/Kconfig                                  |   1 +
 arch/sparc/include/asm/pgtable_64.h                |  89 +++---
 arch/sparc/include/asm/tlbflush_64.h               |  12 +-
 arch/sparc/include/asm/tsb.h                       |   3 +-
 arch/sparc/kernel/head_64.S                        |   4 +-
 arch/sparc/kernel/ktlb.S                           |   2 +-
 arch/sparc/kernel/ldc.c                            |   2 +-
 arch/sparc/kernel/smp_64.c                         |   6 +-
 arch/sparc/kernel/sys32.S                          |   2 +-
 arch/sparc/kernel/unaligned_64.c                   |  12 +-
 arch/sparc/lib/NG2memcpy.S                         |   1 +
 arch/sparc/math-emu/math_32.c                      |   2 +-
 arch/sparc/mm/fault_64.c                           |  98 +++----
 arch/sparc/mm/gup.c                                |   2 +-
 arch/sparc/mm/init_64.c                            |  43 ++-
 arch/sparc/mm/tlb.c                                |  26 +-
 arch/sparc/mm/tsb.c                                |  14 +-
 arch/x86/Kconfig                                   |  26 +-
 arch/x86/include/asm/espfix.h                      |  16 ++
 arch/x86/include/asm/irqflags.h                    |   2 +-
 arch/x86/include/asm/pgtable_64_types.h            |   2 +
 arch/x86/include/asm/setup.h                       |   2 +
 arch/x86/include/asm/vga.h                         |   6 -
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/entry_32.S                         |  12 +
 arch/x86/kernel/entry_64.S                         |  77 +++++-
 arch/x86/kernel/espfix_64.c                        | 209 ++++++++++++++
 arch/x86/kernel/ldt.c                              |  10 +-
 arch/x86/kernel/paravirt_patch_64.c                |   2 -
 arch/x86/kernel/resource.c                         |   8 +-
 arch/x86/kernel/smpboot.c                          |   7 +
 arch/x86/kernel/vsyscall_64.c                      |   8 +-
 arch/x86/kvm/emulate.c                             |   4 +
 arch/x86/kvm/irq.c                                 |   2 +-
 arch/x86/kvm/lapic.c                               |  52 +++-
 arch/x86/mm/dump_pagetables.c                      |  40 ++-
 arch/x86/pci/fixup.c                               |  21 ++
 arch/x86/pci/i386.c                                |   4 +
 arch/x86/vdso/vdso32-setup.c                       |   8 -
 arch/x86/xen/time.c                                |   2 +-
 block/blk-mq.c                                     |   2 +
 drivers/acpi/acpica/utcopy.c                       |   6 +
 drivers/bluetooth/btmrvl_drv.h                     |   1 +
 drivers/bluetooth/btmrvl_main.c                    |  25 +-
 drivers/char/tpm/tpm-interface.c                   |   7 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   1 +
 drivers/crypto/ux500/cryp/cryp_core.c              |  25 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |   3 +
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   4 +-
 drivers/gpu/drm/radeon/ci_dpm.c                    |  13 +-
 drivers/gpu/drm/radeon/cik.c                       |  18 +-
 drivers/gpu/drm/radeon/radeon.h                    |   3 +
 drivers/gpu/drm/radeon/radeon_atombios.c           |  39 ++-
 drivers/gpu/drm/radeon/radeon_kms.c                |   9 +-
 drivers/gpu/drm/radeon/radeon_pm.c                 |   8 +-
 drivers/gpu/drm/radeon/si.c                        |   2 +-
 drivers/gpu/drm/tegra/dc.c                         |   1 +
 drivers/gpu/drm/tegra/gr2d.c                       |   1 +
 drivers/gpu/drm/tegra/gr3d.c                       |   1 +
 drivers/gpu/drm/tegra/hdmi.c                       |   1 +
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   7 +-
 drivers/gpu/drm/tilcdc/tilcdc_panel.c              |   5 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c              |   1 +
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c             |   1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |  29 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |  34 +--
 drivers/hwmon/ads1015.c                            |   4 +-
 drivers/hwmon/amc6821.c                            |  17 +-
 drivers/hwmon/dme1737.c                            |  33 +--
 drivers/hwmon/gpio-fan.c                           |   2 +-
 drivers/hwmon/lm78.c                               |   2 +-
 drivers/hwmon/lm85.c                               |   9 +-
 drivers/hwmon/sis5595.c                            |   2 +-
 drivers/i2c/busses/i2c-at91.c                      |   4 +-
 drivers/infiniband/core/iwcm.c                     |  27 ++
 drivers/infiniband/ulp/srp/ib_srp.c                |  38 ++-
 drivers/md/raid1.c                                 |   8 +-
 drivers/md/raid10.c                                |  11 +-
 drivers/media/media-device.c                       |   2 -
 drivers/media/platform/vsp1/vsp1_video.c           |   2 -
 drivers/media/platform/vsp1/vsp1_video.h           |   1 -
 drivers/media/tuners/xc4000.c                      |  20 +-
 drivers/media/tuners/xc5000.c                      |  22 +-
 drivers/media/usb/au0828/au0828-video.c            |  34 +--
 drivers/mfd/omap-usb-host.c                        |   2 +-
 drivers/misc/mei/client.c                          |  17 +-
 drivers/mtd/ftl.c                                  |   1 -
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |   1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  21 ++
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   4 +-
 drivers/net/macvlan.c                              |   1 +
 drivers/net/ppp/pptp.c                             |   2 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |   1 +
 drivers/net/wireless/ath/carl9170/usb.c            |  31 ++-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |  25 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h             |   1 +
 drivers/pci/pci.c                                  |  12 +-
 drivers/regulator/arizona-ldo1.c                   |   2 -
 drivers/sbus/char/bbc_envctrl.c                    |   6 +
 drivers/sbus/char/bbc_i2c.c                        |  11 +-
 drivers/scsi/bfa/bfa_ioc.h                         |   2 +-
 drivers/scsi/hpsa.c                                |   2 +-
 drivers/scsi/scsi_devinfo.c                        |   1 +
 drivers/scsi/scsi_scan.c                           |  10 +-
 drivers/scsi/sd.c                                  |   5 +
 drivers/scsi/storvsc_drv.c                         | 113 +++++---
 drivers/spi/spi-orion.c                            |  10 +-
 drivers/tty/serial/serial_core.c                   |   3 +
 drivers/tty/serial/sunsab.c                        |   9 +
 drivers/usb/core/devio.c                           |   2 +-
 drivers/usb/core/hub.c                             |  41 +++
 drivers/usb/host/ehci-pci.c                        |  25 ++
 drivers/usb/host/ohci-dbg.c                        |   9 +-
 drivers/usb/host/ohci-hcd.c                        |  10 +-
 drivers/usb/host/ohci-q.c                          |  46 ++--
 drivers/usb/serial/ftdi_sio.c                      |   2 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  13 +-
 drivers/video/efifb.c                              |  39 ---
 fs/btrfs/backref.c                                 |  11 +-
 fs/btrfs/file-item.c                               |   2 +-
 fs/btrfs/ulist.h                                   |  15 ++
 fs/cifs/file.c                                     |   4 +-
 fs/cifs/smb2maperror.c                             |   2 +-
 fs/debugfs/inode.c                                 |  33 ++-
 fs/ext4/ext4.h                                     |   4 +-
 fs/ext4/indirect.c                                 | 281 +++++++++++++------
 fs/ext4/inode.c                                    |   2 +-
 fs/ext4/mballoc.c                                  |  21 +-
 fs/nfs/client.c                                    |  95 ++++---
 fs/nfs/inode.c                                     |   3 +-
 fs/nfs/internal.h                                  |   9 +
 fs/nfs/netns.h                                     |   3 +
 fs/nfs/nfs4client.c                                |   7 +-
 fs/nfsd/nfssvc.c                                   |   5 +-
 fs/proc/array.c                                    |  11 +-
 fs/xfs/xfs_log_recover.c                           |  51 ++--
 include/linux/capability.h                         |   5 +-
 include/linux/sunrpc/rpc_pipe_fs.h                 |   5 +-
 include/net/inetpeer.h                             |  16 +-
 include/net/ip.h                                   |  31 +--
 include/net/ipv6.h                                 |   2 -
 include/net/netlabel.h                             |  34 ++-
 include/net/secure_seq.h                           |   2 -
 include/scsi/scsi_device.h                         |   1 +
 include/scsi/scsi_devinfo.h                        |   3 +
 init/main.c                                        |   4 +
 kernel/audit.c                                     |   2 +-
 kernel/capability.c                                |   4 +
 kernel/smp.c                                       |   2 +-
 kernel/trace/ring_buffer.c                         |  31 +--
 mm/util.c                                          |   9 +-
 net/batman-adv/fragmentation.c                     |  10 +-
 net/bluetooth/l2cap_sock.c                         |   3 +-
 net/bluetooth/rfcomm/core.c                        |   7 +-
 net/bluetooth/rfcomm/sock.c                        |   3 +-
 net/bluetooth/sco.c                                |   6 +-
 net/ceph/messenger.c                               |   2 +-
 net/core/iovec.c                                   |   4 +
 net/core/secure_seq.c                              |  25 --
 net/core/skbuff.c                                  |   2 +-
 net/ipv4/cipso_ipv4.c                              |  21 +-
 net/ipv4/igmp.c                                    |   4 +-
 net/ipv4/inetpeer.c                                |  18 --
 net/ipv4/ip_output.c                               |   7 +-
 net/ipv4/ip_tunnel_core.c                          |   2 +-
 net/ipv4/ipmr.c                                    |   2 +-
 net/ipv4/raw.c                                     |   2 +-
 net/ipv4/route.c                                   |  67 +++--
 net/ipv4/tcp_vegas.c                               |   3 +-
 net/ipv4/tcp_veno.c                                |   2 +-
 net/ipv4/xfrm4_mode_tunnel.c                       |   2 +-
 net/ipv6/ip6_output.c                              |  14 +
 net/ipv6/output_core.c                             |  23 --
 net/netfilter/ipvs/ip_vs_xmit.c                    |   2 +-
 net/netlabel/netlabel_kapi.c                       | 300 +++++++++++++++------
 net/sctp/associola.c                               |   1 +
 net/sctp/output.c                                  |   2 +-
 net/sunrpc/auth_gss/auth_gss.c                     |  17 +-
 net/sunrpc/netns.h                                 |   3 +-
 net/sunrpc/rpc_pipe.c                              | 107 +++++++-
 net/sunrpc/sunrpc_syms.c                           |   8 +-
 security/commoncap.c                               |   3 +
 security/selinux/ss/ebitmap.c                      | 127 ++++-----
 security/smack/smack_access.c                      |   7 +-
 sound/pci/Kconfig                                  |   4 +-
 sound/pci/hda/patch_ca0132.c                       |   7 +-
 sound/pci/hda/patch_sigmatel.c                     |  12 +
 sound/pci/oxygen/virtuoso.c                        |   1 +
 sound/pci/oxygen/xonar_pcm179x.c                   |  12 +-
 sound/soc/blackfin/bf5xx-i2s-pcm.c                 |   8 +-
 sound/soc/codecs/adau1701.c                        |   6 +-
 sound/soc/codecs/max98090.c                        |   2 +-
 sound/soc/codecs/wm8994.c                          |   9 +-
 sound/soc/codecs/wm_adsp.c                         |   2 +
 sound/soc/samsung/i2s.c                            |  16 +-
 sound/soc/soc-pcm.c                                |   1 +
 sound/usb/quirks-table.h                           |  58 ++++
 tools/testing/selftests/Makefile                   |   1 +
 tools/testing/selftests/mount/Makefile             |  17 ++
 .../selftests/mount/unprivileged-remount-test.c    | 242 +++++++++++++++++
 virt/kvm/ioapic.c                                  |   7 +-
 virt/kvm/iommu.c                                   |  19 +-
 227 files changed, 3190 insertions(+), 1332 deletions(-)

Alan Stern (2):
      USB: OHCI: fix bugs in debug routines
      USB: OHCI: don't lose track of EDs when a controller dies

Alex Deucher (7):
      drm/radeon: load the lm63 driver for an lm64 thermal chip.
      drm/radeon/atom: add new voltage fetch function for hawaii
      drm/radeon/dpm: handle voltage info fetching on hawaii
      drm/radeon: re-enable dpm by default on cayman
      drm/radeon: re-enable dpm by default on BTC
      drm/radeon: use packet2 for nop on hawaii with old firmware
      drm/radeon: tweak ACCEL_WORKING2 query for hawaii

Alex Smith (4):
      MIPS: ptrace: Test correct task's flags in task_user_regset_view()
      MIPS: asm/reg.h: Make 32- and 64-bit definitions available at the same time
      MIPS: ptrace: Change GP regset to use correct core dump register layout
      MIPS: O32/32-bit: Fix bug which can cause incorrect system call restarts

Alexander Usyskin (2):
      mei: start disconnect request timer consistently
      mei: fix return value on disconnect timeout

Andrey Utkin (2):
      arch/sparc/math-emu/math_32.c: drop stray break operator
      powerpc/mm/numa: Fix break placement

Andy Lutomirski (2):
      x86_64/entry/xen: Do not invoke espfix64 on Xen
      x86_64/vsyscall: Fix warn_bad_vsyscall log output

Aneesh Kumar K.V (7):
      powerpc/thp: Add write barrier after updating the valid bit
      powerpc/thp: Don't recompute vsid and ssize in loop on invalidate
      powerpc/thp: Invalidate old 64K based hash page mapping before insert of 4k pte
      powerpc/thp: Handle combo pages in invalidate
      powerpc/thp: Invalidate with vpn in loop
      powerpc/thp: Use ACCESS_ONCE when loading pmdp
      powerpc/mm: Use read barrier when creating real_pte

Arnd Bergmann (1):
      crypto: ux500 - make interrupt mode plausible

Axel Lin (6):
      hwmon: (ads1015) Fix off-by-one for valid channel index checking
      hwmon: (amc6821) Fix possible race condition bug
      hwmon: (gpio-fan) Prevent overflow problem when writing large limits
      hwmon: (sis5595) Prevent overflow problem when writing large limits
      hwmon: (ads1015) Fix out-of-bounds array access
      hwmon: (dme1737) Prevent overflow problem when writing large limits

Bart Van Assche (1):
      IB/srp: Fix deadlock between host removal and multipathd

Ben Hutchings (1):
      bfa: Fix undefined bit shift on big-endian architectures with 32-bit DMA address

Bryan O'Donoghue (1):
      USB: ehci-pci: USB host controller support for Intel Quark X1000

Charles Keepax (1):
      ASoC: wm8994: Prevent double lock of accdet_lock mutex on wm1811

Chin-Ran Lo (1):
      Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend

Christian Borntraeger (1):
      s390/locking: Reenable optimistic spinning

Christian König (1):
      drm/radeon: set VM base addr using the PFP v2

Christoph Paasch (2):
      tcp: Fix integer-overflows in TCP veno
      tcp: Fix integer-overflow in TCP vegas

Christoph Schulz (1):
      x86: don't exclude low BIOS area when allocating address space for non-PCI cards

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

Clemens Ladisch (3):
      ALSA: usb-audio: fix BOSS ME-25 MIDI regression
      ALSA: virtuoso: add Xonar Essence STX II support
      ALSA: usb-audio: fix BOSS ME-25 MIDI regression

Daniel Borkmann (1):
      net: sctp: inherit auth_capable on INIT collisions

Daniel Mack (1):
      ASoC: adau1701: fix adau1701_reg_read()

Dave Chiluk (1):
      stable_kernel_rules: Add pointer to netdev-FAQ for network patches

Dave Chinner (1):
      xfs: ensure verifiers are attached to recovered buffers

David E. Box (1):
      ACPICA: Utilities: Fix memory leak in acpi_ut_copy_iobject_to_iobject

David S. Miller (17):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Fix executable bit testing in set_pmd_at() paths.
      sparc64: Fix huge PMD invalidation.
      sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
      sparc64: Fix hex values in comment above pte_modify().
      sparc64: Don't use _PAGE_PRESENT in pte_modify() mask.
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Fix range check in kern_addr_valid().
      sparc64: Use 'ILOG2_4MB' instead of constant '22'.
      sparc64: Add basic validations to {pud,pmd}_bad().
      sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR().
      sparc64: Don't bark so loudly about 32-bit tasks generating 64-bit fault addresses.
      sparc64: Fix huge TSB mapping on pre-UltraSPARC-III cpus.
      sparc64: Add membar to Niagara2 memcpy code.
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.

David Vrabel (1):
      x86/xen: resume timer irqs early

Dmitry Kravkov (1):
      bnx2x: fix crash during TSO tunneling

Eric Dumazet (3):
      inetpeer: get rid of ip_id_count
      ip: make IP identifiers less predictable
      sctp: fix possible seqlock seadlock in sctp_packet_transmit()

Eric Paris (1):
      CAPABILITIES: remove undefined caps from all processes

Eric W. Biederman (2):
      mnt: Add tests for unprivileged remount cases that have found to be faulty
      NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes

Filipe Manana (1):
      Btrfs: fix csum tree corruption, duplicate and outdated checksums

Gavin Shan (1):
      powerpc/pseries: Failure on removing device node

Guenter Roeck (2):
      hwmon: (lm85) Fix various errors on attribute writes
      hwmon: (lm78) Fix overflow problems seen when writing large temperature limits

Guido Martínez (6):
      drm/tilcdc: panel: fix dangling sysfs connector node
      drm/tilcdc: slave: fix dangling sysfs connector node
      drm/tilcdc: tfp410: fix dangling sysfs connector node
      drm/tilcdc: panel: fix leak when unloading the module
      drm/tilcdc: fix release order on exit
      drm/tilcdc: fix double kfree

H. Peter Anvin (6):
      Revert "x86-64, modify_ldt: Make support for 16-bit segments a runtime option"
      x86-64, espfix: Don't leak bits 31:16 of %esp returning to 16-bit stack
      x86, espfix: Move espfix definitions into a separate header file
      x86, espfix: Fix broken header guard
      x86, espfix: Make espfix64 a Kconfig option, fix UML
      x86, espfix: Make it possible to disable 16-bit support

Huacai Chen (2):
      MIPS: tlbex: Fix a missing statement for HUGETLB
      MIPS: Remove BUG_ON(!is_fpu_owner()) in do_ade()

Hui Wang (1):
      ALSA: hda - fix an external mic jack problem on a HP machine

Ilan Peer (1):
      iwlwifi: mvm: Add a missed beacons threshold

Ilya Dryomov (1):
      libceph: set last_piece in ceph_msg_data_pages_cursor_init() correctly

Jan Kara (1):
      ext4: Fix block zeroing when punching holes in indirect block files

Janusz Dziemidowicz (1):
      scsi: do not issue SCSI RSOC command to Promise Vtrak E610f

Jarkko Nikula (1):
      ASoC: max98090: Fix missing free_irq

Jarkko Sakkinen (1):
      tpm: missing tpm_chip_put in tpm_get_random()

Jason Gunthorpe (1):
      tpm: Add missing tpm_do_selftest to ST33 I2C driver

Jeff Layton (3):
      sunrpc: create a new dummy pipe for gssd to hold open
      sunrpc: replace sunrpc_net->gssd_running flag with a more reliable check
      nfs: check if gssd is running before attempting to use krb5i auth in SETCLIENTID call

Jeffrey Deans (1):
      MIPS: GIC: Prevent array overrun

Jeremy Vial (1):
      ARM: OMAP3: Fix choice of omap3_restore_es function in OMAP34XX rev3.1.2 case.

Jiri Kosina (1):
      drm/i915: read HEAD register back in init_ring_common() to enforce ordering

K. Y. Srinivasan (7):
      Drivers: scsi: storvsc: Change the limits to reflect the values on the host
      Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by the Host
      Drivers: scsi: storvsc: Filter commands based on the storage protocol version
      Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
      Drivers: scsi: storvsc: Implement a eh_timed_out handler
      drivers: scsi: storvsc: Set srb_flags in all cases
      drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY failure

Kamal Mostafa (1):
      x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga_fixup()

Kevin Hao (1):
      mtd/ftl: fix the double free of the buffers allocated in build_maps()

Kinglong Mee (1):
      NFSD: Decrease nfsd_users in nfsd_startup_generic fail

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

Laurent Pinchart (1):
      [media] v4l: vsp1: Remove the unneeded vsp1_video_buffer video field

Lukas Czerner (1):
      ext4: fix punch hole on files with indirect mapping

Marc Zyngier (1):
      net: sun4i-emac: fix memory leak on bad packet

Mario Kleiner (1):
      drm/nouveau: Bump version from 1.1.1 to 1.1.2

Martin K. Petersen (1):
      scsi: add a blacklist flag which enables VPD page inquiries

Matt Fleming (1):
      x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub

Mauro Carvalho Chehab (3):
      [media] au0828: Only alt setting logic when needed
      [media] xc5000: Fix get_frequency()
      [media] xc4000: Fix get_frequency()

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

Michael Welling (1):
      mfd: omap-usb-host: Fix improper mask use.

Ming Lei (1):
      blk-mq: fix initializing request's start time

Nadav Amit (1):
      KVM: x86: Inter-privilege level ret emulation is not implemeneted

NeilBrown (1):
      md/raid1,raid10: always abort recover on write error.

Nikesh Oswal (1):
      regulator: arizona-ldo1: remove bypass functionality

Oleg Nesterov (1):
      vm_is_stack: use for_each_thread() rather then buggy while_each_thread()

Oliver Neukum (1):
      USB: devio: fix issue with log flooding

Paolo Bonzini (1):
      KVM: x86: always exit on EOIs for interrupts listed in the IOAPIC redir table

Patrick Riphagen (2):
      USB: serial: ftdi_sio: Annotate the current Xsens PID assignments
      USB: serial: ftdi_sio: Add support for new Xsens devices

Paul Burton (1):
      MIPS: Prevent user from setting FCSR cause bits

Paul Mackerras (1):
      KVM: PPC: Book3S PR: Take SRCU read lock around RTAS kvm_read_guest() call

Paul Moore (5):
      selinux: fix the default socket labeling in sock_graft()
      Revert "selinux: fix the default socket labeling in sock_graft()"
      netlabel: fix a problem when setting bits below the previously lowest bit
      netlabel: fix the horribly broken catmap functions
      netlabel: fix the catmap walking functions

Pavel Shilovsky (2):
      CIFS: Fix async reading on reconnects
      CIFS: Fix STATUS_CANNOT_DELETE error mapping for SMB2

Peter Hurley (1):
      serial: core: Preserve termios c_cflag for console resume

Pratyush Anand (1):
      USB: Fix persist resume of some SS USB devices

Praveen Diwakar (1):
      ASoC: wm_adsp: Add missing MODULE_LICENSE

Qiao Zhou (1):
      ASoC: pcm: fix dpcm_path_put in dpcm runtime update

Ronald Wahl (1):
      carl9170: fix sending URBs with wrong type when using full-speed

Salva Peiró (1):
      [media] media-device: Remove duplicated memset() in media_enum_entities()

Sasha Levin (2):
      iovec: make sure the caller actually wants anything in memcpy_fromiovecend
      kernel/smp.c:on_each_cpu_cond(): fix warning in fallback path

Scott Jiang (1):
      ASoC: blackfin: use samples to set silence

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in progress.

Stephen M. Cameron (1):
      hpsa: fix bad -ENOMEM return value in hpsa_big_passthru_ioctl

Stephen Warren (1):
      drm/tegra: add MODULE_DEVICE_TABLEs

Steve Wise (1):
      RDMA/iwcm: Use a default listen backlog if needed

Steven Rostedt (1):
      debugfs: Fix corrupted loop in debugfs_remove_recursive

Steven Rostedt (Red Hat) (2):
      ring-buffer: Up rb_iter_peek() loop count to 3
      ring-buffer: Always reset iterator to reader page

Sven Eckelmann (1):
      batman-adv: Fix out-of-order fragmentation support

Sylwester Nawrocki (1):
      ASoC: samsung: Correct I2S DAI suspend/resume ops

Takashi Iwai (2):
      ALSA: hda/ca0132 - Don't try loading firmware at resume when already failed
      Btrfs: Fix memory corruption by ulist_add_merge() on 32bit arch

Tetsuo Handa (5):
      drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
      drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_scan().
      drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functions.
      drm/ttm: Fix possible stack overflow by recursive shrinker calls.
      drm/ttm: Pass GFP flags in order to avoid deadlock.

Theodore Ts'o (1):
      ext4: fix ext4_discard_allocated_blocks() if we can't allocate the pa struct

Thomas Petazzoni (1):
      spi: orion: fix incorrect handling of cell-index DT property

Tyrel Datwyler (1):
      powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal

Vidya Sagar (1):
      PCI: Configure ASPM when enabling device

Vignesh Raman (1):
      Bluetooth: Avoid use of session socket after the session gets freed

Vlad Yasevich (2):
      macvlan: Initialize vlan_features to turn on offload support.
      net: Correctly set segment mac_len in skb_segment().

Vladimir Davydov (1):
      Bluetooth: never linger on process exit

Wanpeng Li (1):
      KVM: nVMX: fix "acknowledge interrupt on exit" when APICv is in use

Wolfram Sang (1):
      drivers/i2c/busses: use correct type for dma_map/unmap

wenxiong@linux.vnet.ibm.com (2):
      bnx2x: Fix kernel crash and data miscompare after EEH recovery
      bnx2x: Adapter not recovery from EEH error injection
