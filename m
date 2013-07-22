Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3GVSgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:36:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43517 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3GVSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:36:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.5
Date: Mon, 22 Jul 2013 11:36:33 -0700
Message-Id: <1374518194-8969-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.5 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.4 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/i2c/busses/i2c-piix4                 |   2 +-
 Documentation/kernel-parameters.txt                |   6 +
 Makefile                                           |   2 +-
 arch/arm/kernel/perf_event.c                       |   1 +
 arch/arm/kernel/smp_twd.c                          |   2 +-
 arch/arm/mach-shmobile/setup-emev2.c               |   8 +-
 arch/mips/cavium-octeon/setup.c                    |   2 +-
 arch/parisc/lib/memcpy.c                           |  79 +++++++-----
 arch/powerpc/kernel/ptrace.c                       |   4 +-
 arch/powerpc/kernel/setup_64.c                     |   2 +-
 arch/powerpc/platforms/pseries/eeh_pe.c            |   3 +-
 arch/x86/boot/compressed/eboot.c                   |  20 ++-
 arch/x86/include/asm/efi.h                         |   9 +-
 arch/x86/include/asm/irq_remapping.h               |  10 ++
 arch/x86/kernel/cpu/mtrr/generic.c                 |  21 ++--
 arch/x86/kernel/cpu/mtrr/main.c                    |  16 +--
 arch/x86/kernel/early-quirks.c                     |  20 +++
 arch/x86/kernel/setup.c                            |   3 +-
 arch/x86/platform/efi/efi.c                        | 110 ++++++++++++++++-
 arch/x86/xen/time.c                                |  17 +--
 block/genhd.c                                      |   2 +-
 crypto/algapi.c                                    |   3 +-
 crypto/algboss.c                                   |  15 +--
 crypto/api.c                                       |   6 -
 crypto/internal.h                                  |   6 +
 drivers/acpi/acpica/hwxfsleep.c                    |   8 +-
 drivers/acpi/power.c                               |   4 +-
 drivers/ata/ahci.c                                 |   2 +
 drivers/ata/ata_piix.c                             |   2 +
 drivers/ata/libahci.c                              |   3 +-
 drivers/ata/libata-pmp.c                           |  33 ++---
 drivers/ata/sata_highbank.c                        |  20 ++-
 drivers/block/nbd.c                                |  10 +-
 drivers/cdrom/cdrom.c                              |   2 +-
 drivers/clocksource/dw_apb_timer_of.c              |   2 +-
 drivers/dma/pl330.c                                |   4 +-
 drivers/dma/tegra20-apb-dma.c                      |   1 +
 drivers/firmware/efivars.c                         |  18 +--
 drivers/gpu/drm/i915/i915_gem.c                    |   3 +-
 drivers/gpu/drm/i915/i915_gem_context.c            |   2 +-
 drivers/gpu/drm/i915/i915_reg.h                    |  15 ++-
 .../gpu/drm/nouveau/core/engine/disp/hdminva3.c    |   4 +
 drivers/gpu/drm/nouveau/core/subdev/vm/base.c      |   6 +-
 drivers/gpu/drm/radeon/atombios_encoders.c         |   7 ++
 drivers/hid/hid-apple.c                            |   6 +
 drivers/hid/hid-core.c                             |   6 +
 drivers/hid/hid-ids.h                              |   3 +
 drivers/hv/hv_util.c                               |  12 +-
 drivers/i2c/busses/Kconfig                         |   1 +
 drivers/i2c/busses/i2c-piix4.c                     |   3 +-
 drivers/input/mouse/bcm5974.c                      |  36 +++++-
 drivers/iommu/amd_iommu.c                          |   6 +-
 drivers/iommu/intel_irq_remapping.c                |  10 ++
 drivers/iommu/irq_remapping.c                      |   6 +
 drivers/iommu/irq_remapping.h                      |   2 +
 drivers/md/dm-ioctl.c                              |   3 +
 drivers/md/dm-mpath.c                              |   8 +-
 drivers/md/dm-verity.c                             |   5 +-
 drivers/md/dm.c                                    |   9 +-
 drivers/md/raid10.c                                |   4 +-
 drivers/media/dvb-core/dmxdev.c                    |   8 +-
 drivers/mfd/rtsx_pcr.c                             |   6 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +
 drivers/net/wireless/ath/ath9k/calib.c             |   1 -
 drivers/net/wireless/b43/Kconfig                   |   4 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |  13 ++
 drivers/net/wireless/rt2x00/rt2800lib.c            |   4 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |   3 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c        |   1 +
 drivers/net/wireless/rtlwifi/rtl8723ae/sw.c        |   6 +-
 drivers/pci/probe.c                                |   8 +-
 drivers/pci/quirks.c                               |   2 +
 drivers/pci/xen-pcifront.c                         |   7 +-
 drivers/pcmcia/at91_cf.c                           |   4 +-
 drivers/power/charger-manager.c                    |   2 +-
 drivers/rtc/rtc-rv3029c2.c                         |   2 +-
 drivers/s390/scsi/zfcp_aux.c                       |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                       |  27 ++--
 drivers/s390/scsi/zfcp_scsi.c                      |  10 +-
 drivers/scsi/aacraid/src.c                         |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |  10 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c                |  14 +--
 drivers/scsi/mpt2sas/mpt2sas_base.h                |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c               | 136 +++++++++++++++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c               |  30 +++--
 drivers/scsi/osd/osd_uld.c                         |   2 +-
 drivers/scsi/scsi.c                                |   8 +-
 drivers/scsi/sd.c                                  |  48 +++++---
 drivers/scsi/sd.h                                  |   1 +
 drivers/staging/zram/zram_drv.c                    |  36 ++++--
 drivers/staging/zram/zram_drv.h                    |   5 +-
 drivers/staging/zram/zram_sysfs.c                  |   2 +
 drivers/target/iscsi/iscsi_target_configfs.c       |   2 +-
 drivers/tty/serial/8250/8250_pci.c                 |   4 -
 drivers/tty/serial/pch_uart.c                      |   5 +
 drivers/usb/gadget/f_mass_storage.c                |   2 +
 drivers/usb/host/xhci-mem.c                        |   4 +
 drivers/usb/host/xhci-plat.c                       |   1 +
 drivers/usb/serial/option.c                        |   4 -
 drivers/usb/serial/qcserial.c                      |   8 +-
 fs/block_dev.c                                     |   9 +-
 fs/btrfs/ctree.c                                   |  31 +++--
 fs/cifs/cifs_unicode.h                             |   8 +-
 fs/cifs/cifsencrypt.c                              |   6 +-
 fs/cifs/file.c                                     |   9 +-
 fs/cifs/inode.c                                    |   5 +
 fs/exec.c                                          |  16 +--
 fs/ext3/inode.c                                    |   3 +-
 fs/ext3/namei.c                                    |   7 +-
 fs/ext4/extents.c                                  |   4 +-
 fs/ext4/file.c                                     |  14 +--
 fs/ext4/inline.c                                   |   2 +-
 fs/ext4/inode.c                                    |   4 +-
 fs/ext4/mballoc.c                                  |  11 +-
 fs/ext4/namei.c                                    |   7 +-
 fs/ext4/resize.c                                   |   4 +-
 fs/ext4/super.c                                    |   6 -
 fs/hpfs/map.c                                      |   3 +-
 fs/hpfs/super.c                                    |   8 +-
 fs/jbd2/journal.c                                  |   3 +-
 fs/jbd2/transaction.c                              |   2 +-
 fs/lockd/svclock.c                                 |   4 +
 fs/nfsd/nfs4xdr.c                                  |   2 +-
 fs/ocfs2/xattr.c                                   |  10 ++
 fs/ubifs/dir.c                                     |  54 +++++---
 fs/ubifs/super.c                                   |   2 +-
 include/linux/efi.h                                |   9 +-
 include/linux/hugetlb.h                            |  16 +++
 include/linux/nbd.h                                |   1 +
 include/linux/netfilter_ipv6.h                     |  16 +++
 include/net/addrconf.h                             |   2 +-
 kernel/cgroup.c                                    |  34 ++++--
 kernel/events/core.c                               |  28 ++++-
 kernel/futex.c                                     |   3 +-
 kernel/irq/manage.c                                |   6 +-
 kernel/module.c                                    |  34 +++---
 kernel/printk.c                                    |   2 +-
 kernel/time/tick-broadcast.c                       |  10 +-
 kernel/timer.c                                     |   8 +-
 kernel/trace/trace.c                               |  10 +-
 kernel/trace/trace_uprobe.c                        |   4 +-
 mm/hugetlb.c                                       |  17 +++
 mm/page_alloc.c                                    |   4 +
 net/ceph/auth_none.c                               |   6 +
 net/ipv4/netfilter/ipt_ULOG.c                      |   6 +-
 net/ipv6/addrconf.c                                |   2 +-
 net/ipv6/netfilter.c                               |   7 ++
 net/netfilter/core.c                               |   2 +
 net/netfilter/ipvs/ip_vs_core.c                    |  38 +++++-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   1 +
 net/netfilter/nfnetlink_acct.c                     |   7 +-
 net/netfilter/nfnetlink_cttimeout.c                |   7 +-
 net/netfilter/xt_LOG.c                             |   2 +-
 net/netfilter/xt_TCPMSS.c                          |  23 +++-
 net/netfilter/xt_TCPOPTSTRIP.c                     |  19 ++-
 net/netfilter/xt_addrtype.c                        |  27 ++--
 net/sunrpc/svcsock.c                               |   9 +-
 net/sunrpc/xprtrdma/svc_rdma_marshal.c             |  20 ++-
 sound/pci/hda/patch_hdmi.c                         |   2 +-
 sound/soc/codecs/wm8962.c                          |  24 ++--
 162 files changed, 1258 insertions(+), 471 deletions(-)

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Alex Deucher (1):
      drm/radeon: add backlight quirk for hybrid mac

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Artem Bityutskiy (2):
      UBIFS: prepare to fix a horrid bug
      UBIFS: fix a horrid bug

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Baruch Siach (1):
      clocksource: dw_apb: Fix error check

Ben Hutchings (3):
      [SCSI] sd: Fix parsing of 'temporary ' cache mode prefix
      genirq: Fix can_request_irq() for IRQs without an action
      x86/efi: Fix dummy variable buffer allocation

Ben Widawsky (1):
      drm/i915: Fix context sizes on HSW

Bjørn Mork (1):
      [SCSI] megaraid_sas: fix memory leak if SGL has zero length entries

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Chen Gang (2):
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
      netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path

Chris Wilson (1):
      drm/i915: Only clear write-domains after a successful wait-seqno

Dan Carpenter (2):
      ipvs: info leak in __ip_vs_get_dest_entries()
      svcrdma: underflow issue in decode_write_list()

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Daniel Hansel (1):
      [SCSI] zfcp: fix adapter (re)open recovery while link to SAN is down

Darren Hart (1):
      pch_uart: Add uart_clk selection for the MinnowBoard

David Daney (1):
      MIPS: Octeon: Don't clobber bootloader data structures.

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

Dmitry Osipenko (1):
      dma: tegra: avoid channel lock up after free

Emmanuel Grumbach (2):
      iwlwifi: pcie: fix race in queue unmapping
      iwlwifi: pcie: wake the queue if stopped when being unmapped

Florian Westphal (1):
      netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6

Gabor Juhos (1):
      rt2x00: read 5GHz TX power values from the correct offset

Gavin Shan (1):
      powerpc/eeh: Fix fetching bus for single-dev-PE

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (1):
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"

Grzegorz Lyczba (1):
      ipvs: Fix reuse connection if real server is dead

Hannes Reinecke (1):
      dm mpath: fix ioctl deadlock when no paths

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

Helge Deller (1):
      parisc: Fix gcc miscompilation in pa_memcpy()

Henrik Rydberg (2):
      HID: apple: Add support for the 2013 Macbook Air
      Input: bcm5974 - add support for the 2013 MacBook Air

Herbert Xu (1):
      crypto: algboss - Hold ref count on larval

Ilia Mirkin (1):
      drm/nva3/disp: Fix HDMI audio regression

J. Bruce Fields (3):
      nfsd4: fix decoding of compounds across page boundaries
      svcrpc: fix handling of too-short rpc's
      svcrpc: don't error out on small tcp fragment

Jan Kara (6):
      ext3: fix data=journal fast mount/umount hang
      ext4: fix overflow when counting used blocks on 32-bit architectures
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
      ext4: fix data offset overflow on 32-bit archs in ext4_inline_data_fiemap()
      writeback: Fix periodic writeback after fs mount

Jan Schmidt (1):
      Btrfs: fix unlock after free on rewinded tree blocks

Jason Liu (1):
      ARM: 7778/1: smp_twd: twd_update_frequency need be run on all online CPUs

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Jiang Liu (6):
      zram: avoid invalid memory access in zram_exit()
      zram: use zram->lock to protect zram_free_page() in swap free notify path
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Jiri Olsa (2):
      perf: Clone child context from parent context pmu
      perf: Remove WARN_ON_ONCE() check in __perf_event_enable() for valid scenario

Jiri Slaby (1):
      MFD: rtsx_pcr: Fix probe fail path

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Joerg Roedel (1):
      iommu: Fix compile warnings with forward declarations

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Josef Bacik (2):
      Btrfs: hold the tree mod lock in __tree_mod_log_rewind
      Btrfs: only do the tree_mod_log_free_eb if this is our last ref

Julian Anastasov (1):
      ipvs: SCTP ports should be writable in ICMP packets

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Jörn Engel (1):
      iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow

K. Y. Srinivasan (1):
      Drivers: hv: Execute shutdown in a thread context

Kamal Mostafa (1):
      Linux 3.8.13.5

Kees Cook (3):
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string
      charger-manager: Ensure event is not used as format string

Konrad Rzeszutek Wilk (1):
      xen/pcifront: Deal with toolstack missing 'XenbusStateClosing' state.

Larry Finger (2):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8723ae: Fix typo in firmware names

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan (2):
      cgroup: fix umount vs cgroup_cfts_commit() race
      cgroup: fix umount vs cgroup_event_remove() race

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is set

Maarten ter Huurne (1):
      ext4: fix corruption when online resizing a fs with 1K block size

Magnus Damm (1):
      ARM: shmobile: emev2 GIO3 resource fix

Mahesh Rajashekhara (1):
      [SCSI] aacraid: Fix for arrays are going offline in the system. System hangs

Marcin Slusarz (1):
      drm/nouveau: use vmalloc for pgt allocation

Mark Langsdorf (1):
      sata_highbank: increase retry count but shorten duration for Calxeda controller

Martin K. Petersen (1):
      [SCSI] sd: Update WRITE SAME heuristics

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Michael Neuling (1):
      powerpc/hw_brk: Fix setting of length for exact mode breakpoints

Michal Kubeček (1):
      netfilter: xt_LOG: fix mark logging for IPv6 packets

Mika Westerberg (1):
      ACPI / power: add missing newline to debug messages

Mikulas Patocka (3):
      hpfs: better test for errors
      dm ioctl: set noio flag to avoid __vmalloc deadlock
      dm verity: fix inability to use a few specific devices sizes

Neil Horman (1):
      iommu/vt-d: add quirk for broken interrupt remapping on 55XX chipsets

NeilBrown (1):
      md/raid10: fix two bugs affecting RAID10 reshape.

Nicolin Chen (1):
      ASoC: wm8962: Remove remaining direct register cache accesses

Pablo Neira Ayuso (4):
      netfilter: xt_TCPOPTSTRIP: fix possible mangling beyond packet boundary
      netfilter: nfnetlink_cttimeout: fix incomplete dumping of objects
      netfilter: nfnetlink_acct: fix incomplete dumping of objects
      netfilter: xt_TCPOPTSTRIP: don't use tcp_hdr()

Paul Clements (1):
      nbd: correct disconnect behavior

Pavel Shilovsky (1):
      CIFS: Fix a deadlock when a file is reopened

Peter Zijlstra (1):
      perf: Fix perf_lock_task_context() vs RCU

Phil Oester (3):
      netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
      netfilter: xt_TCPMSS: Fix missing fragmentation handling
      netfilter: xt_TCPMSS: Fix IPv6 default MSS too

Reddy, Sreekanth (1):
      [SCSI] mpt2sas: Fix for issue Missing delay not getting set during system bootup

Richard Genoud (1):
      UBIFS: correct mount message

Richard Weinberger (2):
      x86,efi: Implement efi_no_storage_paranoia parameter
      Modify UEFI anti-bricking code

Rusty Russell (1):
      module: do percpu allocation after uniqueness check.  No, really!

Satoru Takeuchi (1):
      x86, efi: remove duplicate code in setup_arch() by using, efi_is_native()

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (3):
      ahci: Add AMD CZ SATA device ID
      i2c-piix4: Add AMD CZ SMBus device ID
      ahci: remove pmp link online check in FBS EH

Soeren Moch (1):
      [media] media: dmxdev: remove dvb_ringbuffer_flush() on writer side

Sreekanth Reddy (4):
      [SCSI] mpt2sas: Fix for device scan following host reset could get stuck in a infinite loop
      [SCSI] mpt2sas: fix firmware failure with wrong task attribute
      [SCSI] mpt3sas: fix for kernel panic when driver loads with HBA conected to non LUN 0 configured expander
      [SCSI] mpt3sas: Infinite loops can occur if MPI2_IOCSTATUS_CONFIG_INVALID_PAGE is not returned

Steffen Maier (2):
      [SCSI] zfcp: block queue limits with data router
      [SCSI] zfcp: status read buffers on first adapter open with link down

Stephane Eranian (1):
      perf: Disable monitoring on setuid processes for regular users

Steve French (2):
      Handle big endianness in NTLM (ntlmv2) authentication
      [CIFS] use sensible file nlink values if unprovided

Steven Rostedt (Red Hat) (1):
      tracing: Use current_uid() for critical time tracing

Sujith Manoharan (2):
      ath9k_hw: Assign default xlna config for AR9485
      ath9k: Do not assign noise for NULL caldata

Takashi Iwai (1):
      ALSA: hda - Cache the MUX selection for generic HDMI

Tejun Heo (1):
      libata: skip SRST for all SIMG [34]7x port-multipliers

Theodore Ts'o (4):
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      jbd2: fix theoretical race in jbd2__journal_restart
      ext4: don't show usrquota/grpquota twice in /proc/mounts
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM

Thomas Gleixner (1):
      tick: Prevent uncontrolled switch to oneshot mode

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

UCHINO Satoshi (1):
      usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed

Wanpeng Li (1):
      mm/memory-hotplug: fix lowmem count overflow when offline pages

Yinghai Lu (1):
      x86: Fix /proc/mtrr with base/size more than 44bits

Zach Bobroff (1):
      x86, efi: retry ExitBootServices() on failure

Zhang Yi (1):
      futex: Take hugepages into account when generating futex_key

zhangwei(Jovi) (1):
      uprobes: Fix return value in error handling path

