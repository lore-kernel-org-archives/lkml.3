Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab3LERgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:36:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab3LERgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:36:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Luis Henriques <luis.henriques@canonical.com>
Subject: [3.5.y.z extended stable] Linux 3.5.7.27 stable review
Date: Thu,  5 Dec 2013 17:34:42 +0000
Message-Id: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the review cycle for the Linux 3.5.7.27 stable kernel.

This version contains 90 new patches, summarized below.  The new patches are
posted as replies to this message and also available in this git branch:

http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=linux-3.5.y-review;a=shortlog

git://kernel.ubuntu.com/ubuntu/linux.git  linux-3.5.y-review

The review period for version 3.5.7.27 will be open for the next three days.
To report a problem, please reply to the relevant follow-up patch message.

For more information about the Linux 3.5.y.z extended stable kernel version,
see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable .

 -Luis

--
 arch/arm/mach-imx/clk-imx6q.c                 |   2 +-
 arch/arm/mach-integrator/integrator_cp.c      |   3 +-
 arch/arm/mach-sa1100/assabet.c                |   3 +
 arch/arm/plat-omap/omap_device.c              |  13 +-
 arch/avr32/boot/u-boot/head.S                 |  35 +++++-
 arch/avr32/kernel/entry-avr32b.S              |   3 +-
 arch/avr32/kernel/head.S                      |  20 ---
 arch/ia64/include/asm/processor.h             |   2 +-
 arch/powerpc/kernel/signal_32.c               |   6 +
 arch/powerpc/kernel/signal_64.c               |   6 +
 arch/powerpc/kernel/time.c                    |   4 +-
 arch/s390/crypto/aes_s390.c                   |  19 +--
 arch/x86/kernel/microcode_amd.c               |   2 +-
 block/blk-core.c                              |   5 +-
 block/blk-settings.c                          |   1 +
 block/blk-timeout.c                           |   3 +-
 drivers/acpi/acpica/exoparg1.c                |  48 ++++++-
 drivers/acpi/acpica/exstore.c                 | 151 +++++++++++++++-------
 drivers/ata/ahci.c                            |   2 +
 drivers/block/brd.c                           |   2 +-
 drivers/block/loop.c                          |  21 ++--
 drivers/block/xen-blkback/blkback.c           |   3 +-
 drivers/gpu/drm/i915/intel_display.c          |   4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |   3 +-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |  28 +++++
 drivers/gpu/drm/radeon/radeon_semaphore.c     |   6 +-
 drivers/gpu/drm/radeon/radeon_trace.h         |  36 ++++++
 drivers/gpu/drm/radeon/sid.h                  |   2 +-
 drivers/gpu/drm/ttm/ttm_bo.c                  |  32 +++--
 drivers/gpu/drm/ttm/ttm_bo_util.c             |  19 ++-
 drivers/hwmon/lm90.c                          |  11 +-
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |   7 +-
 drivers/input/serio/i8042-x86ia64io.h         |   2 +
 drivers/md/dm-table.c                         |  18 ++-
 drivers/md/md.c                               |   1 +
 drivers/misc/atmel_pwm.c                      |   6 +-
 drivers/mtd/devices/m25p80.c                  |  19 ++-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |   4 +-
 drivers/mtd/nand/nand_base.c                  |  15 ++-
 drivers/net/wireless/libertas/debugfs.c       |   6 +-
 drivers/net/wireless/mwifiex/sdio.c           |   3 +
 drivers/net/wireless/prism54/islpci_dev.c     |   7 +-
 drivers/net/wireless/rtlwifi/base.c           |  89 ++++++-------
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |   9 +-
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |   3 +-
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |   2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |   3 +-
 drivers/net/wireless/rtlwifi/wifi.h           |   6 +-
 drivers/pci/pcie/portdrv_pci.c                |   1 -
 drivers/scsi/aacraid/commctrl.c               |   3 +-
 drivers/staging/iio/accel/kxsd9.c             |   7 +-
 drivers/staging/tidspbridge/Kconfig           |   2 +-
 drivers/staging/vt6656/baseband.c             |  11 ++
 drivers/staging/vt6656/rndis.h                |   1 +
 drivers/staging/zsmalloc/zsmalloc-main.c      |  17 ++-
 drivers/target/iscsi/iscsi_target_auth.c      |   5 +-
 drivers/target/iscsi/iscsi_target_nego.c      |   2 +-
 drivers/target/target_core_transport.c        |   2 +
 fs/cifs/cifssmb.c                             |   8 +-
 fs/configfs/dir.c                             |  16 ++-
 fs/exec.c                                     |   6 +
 fs/ext4/xattr.c                               |   1 +
 fs/nfsd/nfs4xdr.c                             |   2 +-
 fs/nfsd/vfs.c                                 | 173 +++++++++++++++-----------
 include/linux/binfmts.h                       |   3 -
 include/linux/mtd/map.h                       |   4 +-
 include/linux/pci_ids.h                       |   1 +
 include/linux/sched.h                         |   4 +
 include/trace/ftrace.h                        |   5 +-
 kernel/audit.c                                |   7 +-
 kernel/cpuset.c                               |   8 +-
 kernel/power/snapshot.c                       |   6 +-
 kernel/ptrace.c                               |   3 +-
 kernel/trace/ftrace.c                         |  68 +++++-----
 net/sunrpc/clnt.c                             |  31 +++--
 net/sunrpc/xprtsock.c                         |  28 +++--
 security/integrity/ima/ima_policy.c           |   1 -
 security/selinux/netlabel.c                   |   6 +-
 sound/drivers/pcsp/pcsp.c                     |   2 +-
 sound/isa/msnd/msnd_pinnacle.c                |   4 +-
 sound/pci/hda/hda_codec.c                     |   3 -
 sound/pci/hda/patch_realtek.c                 |   2 +
 sound/soc/blackfin/bf5xx-i2s.c                |   1 +
 sound/soc/codecs/cs42l52.h                    |   2 +-
 sound/soc/codecs/wm8962.c                     |   2 +
 sound/soc/fsl/imx-pcm-fiq.c                   |  29 +++--
 virt/kvm/kvm_main.c                           |  25 ++--
 88 files changed, 782 insertions(+), 421 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Alex Deucher (1):
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL

Alex Williamson (1):
      KVM: Fix iommu map/unmap to handle memory slot moves

Andreas Bießmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Andy Adamson (1):
      SUNRPC: don't map EKEYEXPIRED to EACCES in call_refreshresult

Anton Blanchard (1):
      powerpc/pseries: Duplicate dtl entries sometimes sent to userspace

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previous fence

Bob Moore (4):
      ACPICA: Interpreter: Fix Store() when implicit conversion is not possible.
      ACPICA: DeRefOf operator: Update to fully resolve FieldUnit and BufferField refs.
      ACPICA: Return error if DerefOf resolves to a null package element.
      ACPICA: Fix for a Store->ArgX when ArgX contains a reference to a field.

Brian Austin (1):
      ASoC: cs42l52: Correct MIC CTL mask

Brian Norris (2):
      mtd: nand: hack ONFI for non-power-of-2 dimensions
      mtd: m25p80: fix allocation size

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

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Frank Zago (1):
      iio:accel:kxsd9 fix missing mutex unlock

Greg Kroah-Hartman (1):
      Staging: tidspbridge: disable driver

Guenter Roeck (1):
      hwmon: (lm90) Fix max6696 alarm handling

Herbert Xu (1):
      crypto: s390 - Fix aes-cbc IV corruption

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations

J. Bruce Fields (1):
      nfsd4: fix xdr decoding of large non-write compounds

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

Jan Kara (1):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_fast()

Jeff Moyer (1):
      block: fix race between request completion and timeout handling

Jerome Glisse (1):
      radeon: workaround pinning failure on low ram gpu

Jiada Wang (1):
      ARM: i.MX6q: fix the wrong parent of can_root clock

Johan Hovold (1):
      misc: atmel_pwm: add deferred-probing support

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

Junxiao Bi (1):
      configfs: fix race between dentry put and lookup

Kailang Yang (2):
      ALSA: hda/realtek - Add support of ALC231 codec
      ALSA: hda/realtek - Set pcbeep amp for ALC668

Kees Cook (1):
      exec/ptrace: fix get_dumpable() incorrect tests

Larry Finger (4):
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors

Mahesh Rajashekhara (1):
      aacraid: prevent invalid pointer dereference

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Marcelo Tosatti (1):
      KVM: perform an invalid memslot step for gpa base change

Mark Cave-Ayland (1):
      rtlwifi: Fix endian error in extracting packet type

Mathias Krause (2):
      audit: fix info leak in AUDIT_GET requests
      audit: use nlmsg_len() to get message payload length

Michael Neuling (2):
      powerpc/signals: Mark VSX not saved with small contexts
      powerpc/signals: Improved mark VSX not saved with small contexts fix

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

Olav Haugan (1):
      staging: zsmalloc: Ensure handle is never 0 on success

Oskar Schirmer (1):
      ASoC: fsl: imx-pcm-fiq: omit fiq counter to avoid harm in unbalanced situations

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Russell King (1):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Steve French (1):
      setfacl removes part of ACL when setting POSIX ACLs to Samba

Steven Rostedt (Red Hat) (2):
      tracing: Allow events to have NULL strings
      ftrace: Fix function graph with loading of modules

Takashi Iwai (4):
      ALSA: msnd: Avoid duplicated driver name
      ALSA: hda - Don't clear the power state at snd_hda_codec_reset()
      ASoC: blackfin: Fix missing break
      ALSA: pcsp: Fix the order of input device unregistration

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Thomas Hellstrom (2):
      drm/ttm: Fix ttm_bo_move_memcpy
      drm/ttm: Fix memory type compatibility check

Thomas Renninger (1):
      x86/microcode/amd: Tone down printk(), don't treat a missing firmware file as an error

Tom Gundersen (1):
      Input: i8042 - add PNP modaliases

Trond Myklebust (2):
      SUNRPC: Fix a data corruption issue when retransmitting RPC calls
      SUNRPC: Avoid deep recursion in rpc_release_client

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Vegard Nossum (1):
      xen/blkback: fix reference counting

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Xiangliang Yu (1):
      PCI: Define macro for Marvell vendor ID

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()
