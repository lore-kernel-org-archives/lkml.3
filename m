Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab3GKOZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab3GKOZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.17 stable review
Date: Thu, 11 Jul 2013 15:23:30 +0100
Message-Id: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.17 stable kernel.

This version contains 98 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.17 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 Documentation/i2c/busses/i2c-piix4             |   2 +-
 Documentation/kernel-parameters.txt            |   6 ++
 arch/arm/kernel/perf_event.c                   |   1 +
 arch/powerpc/kernel/setup_64.c                 |   2 +-
 arch/x86/kernel/cpu/mtrr/generic.c             |  21 ++--
 arch/x86/kernel/cpu/mtrr/main.c                |  16 +--
 arch/x86/platform/efi/efi.c                    | 105 +++++++++++++++++++
 arch/x86/xen/time.c                            |  17 +---
 block/genhd.c                                  |   2 +-
 crypto/algapi.c                                |   3 +-
 drivers/acpi/acpica/hwxfsleep.c                |   8 +-
 drivers/ata/ahci.c                             |   2 +
 drivers/ata/ata_piix.c                         |   2 +
 drivers/ata/libahci.c                          |   3 +-
 drivers/ata/libata-pmp.c                       |  33 +++---
 drivers/block/nbd.c                            |  10 +-
 drivers/cdrom/cdrom.c                          |   2 +-
 drivers/dma/pl330.c                            |   4 +-
 drivers/firmware/efivars.c                     | 125 ++++++++++++++++++-----
 drivers/gpu/drm/mgag200/mgag200_drv.h          |   3 +-
 drivers/gpu/drm/mgag200/mgag200_main.c         |   2 +-
 drivers/gpu/drm/mgag200/mgag200_mode.c         |  97 +++++++++++++++++-
 drivers/i2c/busses/Kconfig                     |   1 +
 drivers/i2c/busses/i2c-piix4.c                 |   3 +-
 drivers/iommu/amd_iommu.c                      |   6 +-
 drivers/md/raid10.c                            |   4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   8 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   2 +
 drivers/net/wireless/ath/ath9k/calib.c         |   6 +-
 drivers/net/wireless/ath/ath9k/hw.c            |   7 +-
 drivers/net/wireless/ath/ath9k/hw.h            |   2 +-
 drivers/net/wireless/ath/ath9k/main.c          |   7 --
 drivers/net/wireless/b43/Kconfig               |   4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c  |   3 +
 drivers/net/wireless/rt2x00/rt2800lib.c        |   4 +-
 drivers/net/wireless/rt2x00/rt61pci.c          |   3 +-
 drivers/net/wireless/rt2x00/rt73usb.c          |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/rf.c    |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c    |   1 +
 drivers/pci/probe.c                            |   8 +-
 drivers/pci/quirks.c                           |   2 +
 drivers/pcmcia/at91_cf.c                       |   4 +-
 drivers/power/charger-manager.c                |   2 +-
 drivers/rtc/rtc-rv3029c2.c                     |   2 +-
 drivers/s390/scsi/zfcp_aux.c                   |   5 +-
 drivers/s390/scsi/zfcp_fsf.c                   |  27 +++--
 drivers/s390/scsi/zfcp_scsi.c                  |  10 +-
 drivers/scsi/aacraid/src.c                     |   3 +
 drivers/scsi/mpt2sas/mpt2sas_base.c            |  14 +--
 drivers/scsi/mpt2sas/mpt2sas_base.h            |   3 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c           | 134 +++++++++++++++++++++++--
 drivers/scsi/osd/osd_uld.c                     |   2 +-
 drivers/scsi/sd.c                              |   2 +-
 drivers/staging/zram/zram_drv.c                |  38 ++++---
 drivers/staging/zram/zram_drv.h                |   5 +-
 drivers/staging/zram/zram_sysfs.c              |   2 +
 drivers/tty/serial/8250/8250_pci.c             |   4 -
 drivers/usb/gadget/f_mass_storage.c            |   2 +
 drivers/usb/host/xhci-mem.c                    |   4 +
 drivers/usb/host/xhci-plat.c                   |   1 +
 drivers/usb/serial/option.c                    |   4 -
 drivers/usb/serial/qcserial.c                  |   8 +-
 drivers/video/console/vgacon.c                 |  17 +++-
 fs/cifs/cifs_unicode.h                         |   8 +-
 fs/cifs/cifsencrypt.c                          |   6 +-
 fs/ext3/inode.c                                |   3 +-
 fs/ext3/namei.c                                |   7 +-
 fs/ext4/extents.c                              |   4 +-
 fs/ext4/inode.c                                |   4 +-
 fs/ext4/namei.c                                |   7 +-
 fs/hpfs/map.c                                  |   3 +-
 fs/hpfs/super.c                                |   8 +-
 fs/jbd2/journal.c                              |   3 +-
 fs/jbd2/transaction.c                          |   2 +-
 fs/ocfs2/xattr.c                               |  10 ++
 include/linux/efi.h                            |  13 +++
 include/linux/nbd.h                            |   1 +
 include/linux/netfilter_ipv6.h                 |  16 +++
 include/net/addrconf.h                         |   2 +-
 kernel/cgroup.c                                |  34 +++++--
 kernel/irq/manage.c                            |   6 +-
 kernel/printk.c                                |   2 +-
 kernel/time/tick-broadcast.c                   |  10 +-
 kernel/timer.c                                 |   8 +-
 kernel/trace/trace.c                           |  10 +-
 mm/page_alloc.c                                |   4 +
 net/ceph/auth_none.c                           |   6 ++
 net/ipv4/netfilter/ipt_ULOG.c                  |   6 +-
 net/ipv6/addrconf.c                            |   2 +-
 net/ipv6/netfilter.c                           |   7 ++
 net/netfilter/core.c                           |   2 +
 net/netfilter/ipvs/ip_vs_core.c                |   3 +-
 net/netfilter/ipvs/ip_vs_ctl.c                 |   1 +
 net/netfilter/nfnetlink_acct.c                 |   7 +-
 net/netfilter/nfnetlink_cttimeout.c            |   7 +-
 net/netfilter/xt_LOG.c                         |   2 +-
 net/netfilter/xt_TCPMSS.c                      |  23 ++++-
 net/netfilter/xt_TCPOPTSTRIP.c                 |  19 +++-
 net/netfilter/xt_addrtype.c                    |  27 +++--
 net/sunrpc/clnt.c                              |   2 +
 sound/pci/hda/patch_hdmi.c                     |   2 +-
 sound/soc/codecs/wm8962.c                      |  24 +++--
 102 files changed, 874 insertions(+), 272 deletions(-)

Al Viro (1):
      ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()

Alex Williamson (1):
      iommu/amd: Only unmap large pages from the first pte

Axel Lin (1):
      drivers/rtc/rtc-rv3029c2.c: fix disabling AIE irq

Bart Van Assche (1):
      timer: Fix jiffies wrap behavior of round_jiffies_common()

Bartlomiej Zolnierkiewicz (1):
      drivers/dma/pl330.c: fix locking in pl330_free_chan_resources()

Ben Hutchings (3):
      genirq: Fix can_request_irq() for IRQs without an action
      [SCSI] sd: Fix parsing of 'temporary ' cache mode prefix
      x86/efi: Fix dummy variable buffer allocation

Bu, Yitian (1):
      printk: Fix rq->lock vs logbuf_lock unlock lock inversion

Chen Gang (2):
      netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
      powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries

Christopher Harvey (1):
      drm/mgag200: Reject modes that are too big for VRAM

Dan Carpenter (1):
      ipvs: info leak in __ip_vs_get_dest_entries()

Dan Williams (1):
      USB: option,qcserial: move Novatel Gobi1K IDs to qcserial

Daniel Hansel (1):
      [SCSI] zfcp: fix adapter (re)open recovery while link to SAN is down

Dave Airlie (1):
      vgacon: fix missing include.

Emmanuel Grumbach (1):
      iwlwifi: pcie: wake the queue if stopped when being unmapped

Florian Westphal (1):
      netfilter: add nf_ipv6_ops hook to fix xt_addrtype with IPv6

Gabor Juhos (1):
      rt2x00: read 5GHz TX power values from the correct offset

George Cherian (1):
      usb: host: xhci-plat: release mem region while removing module

Greg Kroah-Hartman (1):
      Revert "serial: 8250_pci: add support for another kind of NetMos Technology PCI 9835 Multi-I/O Controller"

Hauke Mehrtens (1):
      b43: ensue that BCMA is "y" when B43 is "y"

Jan Kara (3):
      ext3: fix data=journal fast mount/umount hang
      ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit archs
      ext4: fix overflow when counting used blocks on 32-bit architectures

Jed Davis (1):
      ARM: 7765/1: perf: Record the user-mode PC in the call chain.

Jiang Liu (7):
      zram: avoid invalid memory access in zram_exit()
      zram: use zram->lock to protect zram_free_page() in swap free notify path
      zram: destroy all devices on error recovery path in zram_init()
      zram: avoid double free in function zram_bvec_write()
      zram: avoid access beyond the zram device
      zram: protect sysfs handler from invalid memory access
      PCI: Fix refcount issue in pci_create_root_bus() error recovery path

Joachim Eastwood (1):
      pcmcia: at91_cf: fix gpio_get_value in at91_cf_get_status

Jonathan Salwan (1):
      drivers/cdrom/cdrom.c: use kzalloc() for failing hardware

Julia Lemire (1):
      drm/mgag200: Added resolution and bandwidth limits for various G200e products.

Julian Anastasov (1):
      ipvs: SCTP ports should be writable in ICMP packets

Junxiao Bi (1):
      ocfs2: xattr: fix inlined xattr reflink

Kees Cook (3):
      block: do not pass disk names as format strings
      crypto: sanitize argument for format string
      charger-manager: Ensure event is not used as format string

Larry Finger (2):
      rtlwifi: rtl8192cu: Add new USB ID for TP-Link TL-WN8200ND
      rtlwifi: rtl8192cu: Fix duplicate if test

Laszlo Ersek (1):
      xen/time: remove blocked time accounting from xen "clockchip"

Li Zefan (2):
      cgroup: fix umount vs cgroup_event_remove() race
      cgroup: fix umount vs cgroup_cfts_commit() race

Lv Zheng (1):
      ACPICA: Do not use extended sleep registers unless HW-reduced bit is set

Mahesh Rajashekhara (1):
      aacraid: Fix for arrays are going offline in the system. System hangs

Marcelo Tosatti (1):
      vgacon.c: add cond reschedule points in vgacon_do_font_op

Mathias Nyman (1):
      xhci: check for failed dma pool allocation

Matt Fleming (1):
      x86, efivars: firmware bug workarounds should be in platform code

Matthew Garrett (2):
      efi: be more paranoid about available space when creating variables
      Modify UEFI anti-bricking code

Michal Kubeček (1):
      netfilter: xt_LOG: fix mark logging for IPv6 packets

Mikulas Patocka (1):
      hpfs: better test for errors

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

Phil Oester (3):
      netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
      netfilter: xt_TCPMSS: Fix missing fragmentation handling
      netfilter: xt_TCPMSS: Fix IPv6 default MSS too

Rajkumar Manoharan (1):
      ath9k: fill channel mode in caldata

Reddy, Sreekanth (1):
      [SCSI] mpt2sas: Fix for issue Missing delay not getting set during system bootup

Richard Weinberger (2):
      x86,efi: Check max_size only if it is non-zero.
      x86,efi: Implement efi_no_storage_paranoia parameter

Seiji Aguchi (2):
      efi_pstore: Check remaining space with QueryVariableInfo() before writing data
      efivars: Disable external interrupt while holding efivars->lock

Sergey Vlasov (1):
      efi: Export efi_query_variable_store() for efivars.ko

Seth Heasley (2):
      ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs

Shane Huang (3):
      ahci: Add AMD CZ SATA device ID
      i2c-piix4: Add AMD CZ SMBus device ID
      ahci: remove pmp link online check in FBS EH

Sreekanth Reddy (2):
      [SCSI] mpt2sas: Fix for device scan following host reset could get stuck in a infinite loop
      [SCSI] mpt2sas: fix firmware failure with wrong task attribute

Stanislav Kinsbursky (1):
      SUNRPC: PipeFS MOUNT notification optimization for dying clients

Steffen Maier (2):
      [SCSI] zfcp: block queue limits with data router
      [SCSI] zfcp: status read buffers on first adapter open with link down

Steve French (1):
      Handle big endianness in NTLM (ntlmv2) authentication

Steven Rostedt (Red Hat) (1):
      tracing: Use current_uid() for critical time tracing

Sujith Manoharan (4):
      ath9k_hw: Assign default xlna config for AR9485
      ath9k_hw: Remove CHANNEL_CW_INT
      ath9k: Fix noisefloor calibration
      ath9k: Do not assign noise for NULL caldata

Takashi Iwai (1):
      ALSA: hda - Cache the MUX selection for generic HDMI

Tejun Heo (1):
      libata: skip SRST for all SIMG [34]7x port-multipliers

Theodore Ts'o (2):
      jbd2: move superblock checksum calculation to jbd2_write_superblock()
      jbd2: fix theoretical race in jbd2__journal_restart

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

sreekanth.reddy@lsi.com (1):
      [SCSI] mpt2sas: Fix for max_sectors warning message is stating the incorrect range
