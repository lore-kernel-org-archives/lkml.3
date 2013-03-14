Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab3CNKgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:36:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51681 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab3CNKgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [ 3.5.y.z extended stable ] Linux 3.5.7.8 stable review
Date: Thu, 14 Mar 2013 10:34:53 +0000
Message-Id: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the review cycle for the 3.5.7.8 stable release. This new
release contains 88 patches, which are posted as a response to this
message. They are also available at the following repository:

git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y-review

If there are any problems, or if anything is missing, please answer to
this or to any of the followup patches. Note that any answer should be
made at maximum in 3 days, after that the final release of 3.5.7.8 will be
made.

For more information about the 3.5.y.z extended stable tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Included below are the diffstat and shortlog for this release.

-Luis

-- 
 Documentation/kernel-parameters.txt           |   5 +
 arch/arm/kernel/head.S                        |  26 +++-
 arch/arm/kernel/perf_event_v7.c               |   2 +-
 arch/arm/mm/alignment.c                       |  11 +-
 arch/arm/vfp/vfpmodule.c                      |   2 +-
 arch/x86/kernel/head.c                        |  53 +++++---
 arch/x86/pci/xen.c                            |   9 ++
 arch/x86/xen/enlighten.c                      |   9 ++
 block/genhd.c                                 |  15 ++-
 block/partition-generic.c                     |   2 +-
 crypto/ablkcipher.c                           |  12 +-
 crypto/aead.c                                 |   9 +-
 crypto/ahash.c                                |   2 +-
 crypto/blkcipher.c                            |   6 +-
 crypto/crypto_user.c                          |  22 ++--
 crypto/pcompress.c                            |   3 +-
 crypto/rng.c                                  |   2 +-
 crypto/shash.c                                |   3 +-
 drivers/ata/ata_piix.c                        |  50 +++++++-
 drivers/block/nbd.c                           |  10 ++
 drivers/block/xen-blkback/xenbus.c            |  49 ++++---
 drivers/char/hw_random/core.c                 |  19 ++-
 drivers/char/random.c                         |  12 +-
 drivers/cpufreq/cpufreq_stats.c               |   1 +
 drivers/firewire/core-device.c                |   4 +
 drivers/firmware/dmi_scan.c                   |   5 +-
 drivers/gpu/drm/i915/intel_display.c          |  11 +-
 drivers/gpu/drm/i915/intel_pm.c               |   2 +-
 drivers/gpu/drm/radeon/radeon_combios.c       |   9 ++
 drivers/hid/hid-core.c                        |   1 +
 drivers/hid/hid-ids.h                         |   3 +
 drivers/hid/hid-logitech-dj.c                 |  22 ++--
 drivers/hwmon/pmbus/ltc2978.c                 |  30 +++--
 drivers/hwmon/sht15.c                         |   8 +-
 drivers/iommu/amd_iommu_init.c                |  10 +-
 drivers/md/dm-snap.c                          |   2 +
 drivers/md/md.c                               |   7 +
 drivers/md/raid0.c                            |   5 +-
 drivers/media/video/omap/omap_vout.c          |  12 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |   2 +-
 drivers/net/wireless/ath/ath9k/common.h       |   2 +-
 drivers/net/wireless/ath/ath9k/htc.h          |   1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  18 ++-
 drivers/net/wireless/ath/ath9k/hw.c           |   4 +-
 drivers/net/wireless/libertas/if_sdio.c       |   6 +-
 drivers/net/wireless/mwifiex/pcie.c           |   2 +-
 drivers/platform/x86/asus-laptop.c            |  17 +--
 drivers/platform/x86/sony-laptop.c            |   2 +-
 drivers/scsi/dc395x.c                         |   2 +-
 drivers/scsi/storvsc_drv.c                    |   1 +
 drivers/staging/zram/zram_drv.c               |   4 +-
 drivers/target/iscsi/iscsi_target.c           |  11 +-
 drivers/target/target_core_fabric_configfs.c  |   8 ++
 drivers/target/target_core_pscsi.c            |   1 -
 drivers/usb/core/hub.c                        | 176 ++++++++++++++------------
 drivers/vhost/vhost.c                         |   2 +-
 drivers/xen/xen-pciback/pciback_ops.c         |   3 +-
 drivers/xen/xenbus/xenbus_client.c            |   1 +
 fs/binfmt_em86.c                              |   1 -
 fs/binfmt_misc.c                              |   8 +-
 fs/binfmt_script.c                            |   4 +-
 fs/btrfs/free-space-cache.c                   |  20 +--
 fs/btrfs/inode.c                              |   1 +
 fs/btrfs/volumes.c                            |   1 +
 fs/cachefiles/rdwr.c                          |   2 +-
 fs/cifs/cifsfs.c                              |   5 +
 fs/compat.c                                   |  15 +--
 fs/exec.c                                     |  10 +-
 fs/ext4/balloc.c                              |   2 +-
 fs/ext4/mballoc.c                             |   8 +-
 fs/ext4/resize.c                              |   6 +-
 fs/fuse/dir.c                                 |   9 +-
 fs/nfs/unlink.c                               |  20 ++-
 fs/nfsd/export.c                              |   6 +-
 fs/nfsd/nfs4state.c                           |   2 +
 fs/ocfs2/suballoc.c                           |   7 +-
 fs/ocfs2/suballoc.h                           |   2 +-
 fs/ocfs2/xattr.c                              |   2 +-
 fs/pipe.c                                     |   3 +
 fs/pstore/platform.c                          |  35 ++++-
 include/linux/auto_fs.h                       |  24 ++--
 include/linux/binfmts.h                       |   2 -
 include/linux/pstore.h                        |   6 +
 include/linux/sunrpc/cache.h                  |  16 +++
 kernel/sysctl_binary.c                        |   3 +-
 kernel/trace/Kconfig                          |  24 ++--
 kernel/workqueue.c                            |  42 ++++--
 lib/idr.c                                     |  45 ++++---
 mm/process_vm_access.c                        |   8 --
 net/sunrpc/svc_xprt.c                         |  15 +--
 net/sunrpc/xprt.c                             |   6 +-
 security/keys/compat.c                        |   4 +-
 security/keys/process_keys.c                  |   4 +-
 sound/core/vmaster.c                          |   5 +-
 sound/pci/bt87x.c                             |  19 ++-
 sound/pci/ice1712/ice1712.c                   |   2 +
 96 files changed, 713 insertions(+), 409 deletions(-)

Al Viro (2):
      omap_vout: find_vma() needs ->mmap_sem held
      vfs: fix pipe counter breakage

Alex Deucher (1):
      drm/radeon: add primary dac adj quirk for R200 board

Alexey Klimov (1):
      usb hid quirks for Masterkit MA901 usb radio

Asias He (1):
      target/pscsi: Fix page increment

Avinash Patil (1):
      mwifiex: correct sleep delay counter

Ben Hutchings (2):
      asus-laptop: Do not call HWRS on init
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Benjamin Tissoires (1):
      HID: logitech-dj: do not directly call hid_output_raw_report() during probe

Bing Zhao (1):
      libertas: fix crash for SD8688

Dan Carpenter (1):
      dc395x: uninitialized variable in device_alloc()

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

Eric W. Biederman (1):
      userns: Stop oopsing in key_change_session_keyring

Felix Fietkau (3):
      ath9k: fix RSSI dummy marker value
      ath9k_htc: fix signal strength handling issues
      ath9k_hw: improve reset reliability after errors

Guenter Roeck (2):
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported functionality

H. Peter Anvin (1):
      x86: Make sure we can boot in the case the BDA contains pure garbage

Helge Deller (1):
      unbreak automounter support on 64-bit kernel with 32-bit userspace (v2)

J. Bruce Fields (2):
      svcrpc: make svc_age_temp_xprts enqueue under sv_lock
      nfsd: add get_uint for u32's

James Ralston (2):
      ata_piix: Add Device IDs for Intel Wellsburg PCH
      ata_piix: Add Device IDs for Intel Lynx Point-LP PCH

Jan Beulich (1):
      xen-blkback: do not leak mode property

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Jeff Liu (1):
      ocfs2: fix ocfs2_init_security_and_acl() to initialize acl correctly

Joerg Roedel (1):
      iommu/amd: Initialize device table after dma_ops

Josef Bacik (2):
      Btrfs: account for orphan inodes properly during cleanup
      Btrfs: fix panic when recovering tree log

Justin Lecher (1):
      fs: cachefiles: add support for large files in filesystem caching

K. Y. Srinivasan (1):
      storvsc: Initialize the sglist

Kees Cook (1):
      exec: use -ELOOP for max recursion depth

Konrad Rzeszutek Wilk (5):
      doc, xen: Mention 'earlyprintk=xen' in the documentation.
      doc, kernel-parameters: Document 'console=hvc<n>'
      xen/pat: Disable PAT using pat_enabled value.
      xen/pci: We don't do multiple MSI's.
      xen/pciback: Don't disable a PCI device that is already disabled.

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance

Lukas Czerner (1):
      ext4: convert number of blocks to clusters properly

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

Mathias Krause (1):
      crypto: user - fix info leaks in report API

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and security keys

Mattia Dongili (1):
      sony-laptop: fully enable SNY controlled modems

Michael S. Tsirkin (1):
      vhost: fix length for cross region descriptor

Miklos Szeredi (1):
      fuse: don't WARN when nlink is zero

Mikulas Patocka (1):
      dm snapshot: add missing module aliases

Minchan Kim (1):
      zram: Fix deadlock bug in partial read/write

NeilBrown (2):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.

Nicholas Bellinger (2):
      target: Add missing mapped_lun bounds checking during make_mappedlun setup
      iscsi-target: Fix immediate queue starvation regression with DATAIN

Olaf Hering (1):
      ata_piix: reenable MS Virtual PC guests

Paolo Bonzini (1):
      nbd: fsync and kill block device on shutdown

Russell King (2):
      ARM: VFP: fix emulation of second VFP instruction
      ARM: fix scheduling while atomic warning in alignment handling code

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

Sarah Sharp (5):
      USB: Handle warm reset failure on empty port.
      USB: Don't use EHCI port sempahore for USB 3.0 hubs.
      USB: Prepare for refactoring by adding extra udev checks.
      USB: Rip out recursive call on warm port reset.
      USB: Fix connected device switch to Inactive state.

Sean Connor (1):
      ALSA: ice1712: Initialize card->private_data properly

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Seiji Aguchi (1):
      pstore: Avoid deadlock in panic and emergency-restart path

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs

Steven Noonan (1):
      xenbus: fix compile failure on ARM with Xen enabled

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Stéphane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Takashi Iwai (2):
      ALSA: bt87x: Make load_all parameter working again
      ALSA: vmaster: Fix slave change notification

Tejun Heo (5):
      idr: fix a subtle bug in idr_get_next()
      block: fix synchronization and limit check in blk_alloc_devt()
      firewire: add minor number range check to fw_device_init()
      idr: fix top layer handling
      workqueue: consider work function when searching for busy work items

Theodore Ts'o (1):
      random: fix locking dependency with the tasklist_lock

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct

Tomas Henzl (1):
      block: fix ext_devt_idr handling

Trond Myklebust (2):
      NFS: Don't allow NFS silly-renamed files to be deleted, no signal
      SUNRPC: Don't start the retransmission timer when out of socket space

Tu, Xiaobing (1):
      Fix memory leak in cpufreq stats.

Ville Syrjälä (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Will Deacon (2):
      ARM: 7657/1: head: fix swapper and idmap population with LPAE and big-endian
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit

Xi Wang (1):
      sysctl: fix null checking in bin_dn_node_address()

Xiaowei.Hu (1):
      ocfs2: ac->ac_allow_chain_relink=0 won't disable group relink

majianpeng (1):
      nfsd: Fix memleak
