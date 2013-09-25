Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3IYSGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:06:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3IYSGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:06:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.8.y.z extended stable] Linux 3.8.13.10
Date: Wed, 25 Sep 2013 11:06:41 -0700
Message-Id: <1380132402-15729-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
X-Extended-Stable: 3.8
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.8.13.10 kernel.

The updated 3.8.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.8.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.8.y;a=shortlog

The diff from v3.8.13.9 is posted as a follow-up to this email.

The 3.8.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Kamal

-- 
 Documentation/DocBook/media_api.tmpl            |   4 +-
 Makefile                                        |   2 +-
 arch/arm/mach-versatile/include/mach/platform.h |   2 +
 arch/arm/mach-versatile/pci.c                   |  47 +++++----
 arch/arm64/kernel/perf_event.c                  |   7 +-
 arch/mips/ath79/clock.c                         |   2 +-
 arch/powerpc/kernel/align.c                     |  10 ++
 arch/powerpc/platforms/pseries/setup.c          |  31 ++++--
 arch/x86/ia32/ia32_signal.c                     |   2 +-
 arch/x86/include/asm/checksum_32.h              |  22 +++-
 arch/x86/kernel/signal.c                        |   6 +-
 arch/x86/lguest/boot.c                          |   3 +-
 arch/x86/lib/csum-wrappers_64.c                 |  12 ++-
 crypto/api.c                                    |   7 +-
 drivers/acpi/ec.c                               |   8 ++
 drivers/clk/clk-wm831x.c                        |   2 +
 drivers/cpuidle/coupled.c                       | 129 ++++++++++++++++++------
 drivers/gpu/drm/drm_crtc.c                      |  17 +++-
 drivers/gpu/drm/drm_edid.c                      |   3 +
 drivers/gpu/drm/i915/intel_opregion.c           |   2 +-
 drivers/gpu/drm/radeon/atombios_dp.c            |   6 +-
 drivers/gpu/drm/radeon/atombios_i2c.c           |   4 +-
 drivers/gpu/drm/radeon/evergreen.c              |  25 ++++-
 drivers/gpu/drm/radeon/evergreend.h             |   4 +
 drivers/gpu/drm/radeon/radeon_atombios.c        |  13 ++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c         |   8 +-
 drivers/gpu/drm/radeon/rs400.c                  |   9 +-
 drivers/gpu/drm/radeon/si.c                     |  23 ++++-
 drivers/gpu/drm/radeon/sid.h                    |   4 +
 drivers/hid/hid-core.c                          |  17 +++-
 drivers/hid/hid-input.c                         |  15 ++-
 drivers/hid/hid-ntrig.c                         |   3 +-
 drivers/hid/hid-picolcd_cir.c                   |   3 +-
 drivers/hid/hid-picolcd_core.c                  |   2 +-
 drivers/hid/hid-picolcd_fb.c                    |   6 +-
 drivers/hid/hid-pl.c                            |  10 +-
 drivers/hid/hid-sensor-hub.c                    |   3 +-
 drivers/hid/hidraw.c                            |  60 +++++------
 drivers/iommu/intel-iommu.c                     |  72 +++++++------
 drivers/leds/leds-wm831x-status.c               |   4 +-
 drivers/media/platform/coda.c                   |   2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c    |   9 +-
 drivers/media/platform/exynos-gsc/gsc-core.h    |   1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |   1 +
 drivers/media/platform/s5p-g2d/g2d.c            |   1 +
 drivers/media/usb/hdpvr/hdpvr-core.c            |  11 +-
 drivers/misc/hpilo.c                            |   4 +-
 drivers/mmc/host/tmio_mmc_dma.c                 |   4 +-
 drivers/mtd/nand/nand_base.c                    |   8 +-
 drivers/net/ethernet/marvell/mvneta.c           |  13 ++-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h          |   5 +-
 drivers/net/wireless/ath/ath9k/recv.c           |  17 +++-
 drivers/net/wireless/ath/ath9k/xmit.c           |   1 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  15 ++-
 drivers/of/base.c                               |   1 +
 drivers/pinctrl/pinctrl-at91.c                  |   4 +-
 drivers/scsi/sd.c                               |  11 +-
 drivers/staging/comedi/drivers/dt282x.c         |   3 +-
 drivers/staging/zram/zram_drv.c                 |   4 +-
 drivers/staging/zram/zram_drv.h                 |   5 +-
 drivers/usb/class/cdc-wdm.c                     |  13 ++-
 drivers/usb/core/config.c                       |   3 +-
 drivers/usb/core/hub.c                          |  53 +++++-----
 drivers/usb/host/ehci-mxc.c                     |   2 +-
 drivers/usb/host/ohci-pci.c                     |   2 +-
 drivers/usb/host/xhci-plat.c                    |   2 +-
 drivers/usb/host/xhci.c                         |  29 +++++-
 drivers/usb/host/xhci.h                         |   1 +
 drivers/usb/serial/mos7720.c                    |   6 +-
 drivers/xen/grant-table.c                       |  13 ++-
 fs/ceph/ioctl.c                                 |   4 +-
 fs/cifs/connect.c                               |   2 +
 fs/cifs/smb2misc.c                              |   1 +
 fs/ext4/ext4.h                                  |  24 ++++-
 fs/ext4/inode.c                                 | 119 +++++++++++-----------
 fs/fuse/dir.c                                   |   6 ++
 fs/fuse/file.c                                  |   3 +-
 fs/ocfs2/extent_map.c                           |   1 -
 fs/proc/root.c                                  |   3 +-
 include/linux/compat.h                          |   7 ++
 include/linux/hid.h                             |   4 +-
 include/linux/rculist.h                         |   5 +-
 include/linux/signal.h                          |   8 ++
 include/linux/usb/hcd.h                         |   2 +-
 include/media/v4l2-ctrls.h                      |   1 +
 kernel/fork.c                                   |   7 +-
 kernel/pid.c                                    |   1 +
 mm/huge_memory.c                                |   2 +
 mm/memcontrol.c                                 |   8 +-
 mm/swap.c                                       |  77 +++++++++-----
 net/ceph/osd_client.c                           |   2 +
 net/ceph/osdmap.c                               |   2 +-
 net/core/sock.c                                 |   6 +-
 sound/pci/hda/hda_intel.c                       |   1 +
 sound/pci/hda/patch_hdmi.c                      |  11 ++
 sound/soc/codecs/mc13783.c                      |   4 +
 sound/soc/codecs/wm8960.c                       |   6 +-
 98 files changed, 792 insertions(+), 382 deletions(-)

Al Viro (1):
      Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

Alan Stern (4):
      USB: handle LPM errors during device suspend correctly
      USB: OHCI: Allow runtime PM without system sleep
      USB: fix build error when CONFIG_PM_SLEEP isn't enabled
      [SCSI] sd: Fix potential out-of-bounds access

Alex Deucher (7):
      drm/edid: add quirk for Medion MD30217PG
      drm/radeon: fix endian bugs in hw i2c atom routines
      drm/radeon: update line buffer allocation for dce4.1/5
      drm/radeon: update line buffer allocation for dce6
      drm/radeon: fix LCD record parsing
      drm/radeon: fix resume on some rs4xx boards (v2)
      drm/radeon: fix handling of variable sized arrays for router objects

Alex Williamson (1):
      intel-iommu: Fix leaks in pagetable freeing

Alexander Shiyan (1):
      [media] media: coda: Fix DT driver data pointer for i.MX27

Alexey Khoroshilov (1):
      [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Anand Avati (1):
      fuse: invalidate inode attributes on xattr modification

Andrzej Hajda (2):
      [media] DocBook: upgrade media_api DocBook version to 4.2
      [media] v4l2: added missing mutex.h include to v4l2-ctrls.h

Anssi Hannula (1):
      ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Anton Blanchard (1):
      powerpc: Handle unaligned ldbrx/stdbrx

Arun Kumar K (1):
      [media] exynos-gsc: Register v4l2 device

Boris BREZILLON (1):
      pinctrl: at91: fix get_pullup/down function return

Brian Norris (1):
      mtd: nand: fix NAND_BUSWIDTH_AUTO for x16 devices

Bruno Prémont (1):
      HID: picolcd: Prevent NULL pointer dereference on _remove()

Colin Cross (3):
      cpuidle: coupled: abort idle if pokes are pending
      cpuidle: coupled: disable interrupts after entering safe state
      cpuidle: coupled: fix race condition between pokes and safe state

Dan Carpenter (2):
      USB: mos7720: use GFP_ATOMIC under spinlock
      staging: comedi: dt282x: dt282x_ai_insn_read() always fails

Daniel Mack (1):
      usb: ehci-mxc: check for pdata before dereferencing

David Herrmann (1):
      drm: fix DRM_IOCTL_MODE_GETFB handle-leak

Eric W. Biederman (2):
      proc: Restrict mounting the proc filesystem
      pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup

Felix Fietkau (4):
      ath9k: always clear ps filter bit on new assoc
      ath9k: fix rx descriptor related race condition
      ath9k: avoid accessing MRC registers on single-chain devices
      MIPS: ath79: Fix ar933x watchdog clock

Grant Likely (1):
      of: Fix missing memory initialization on FDT unflattening

Greg Thelen (1):
      memcg: fix multiple large threshold notifications

H. Peter Anvin (1):
      x86, smap: Handle csum_partial_copy_*_user()

Hans de Goede (1):
      usb: config->desc.bLength may not exceed amount of data returned by the device

Herbert Xu (1):
      crypto: api - Fix race condition in larval lookup

Holger Hans Peter Freyther (1):
      lguest: Point to the right directory for the lguest launcher

Jan Kara (2):
      ext4: simplify truncation code in ext4_setattr()
      ext4: fix lost truncate due to race with writeback

Jani Nikula (1):
      drm/i915: try not to lose backlight CBLV precision

Jeff Layton (1):
      cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Jie Liu (1):
      ocfs2: fix the end cluster offset of FIEMAP

Jiri Kosina (1):
      HID: battery: don't do DMA from stack

Johan Hovold (1):
      USB: mos7720: fix big-endian control requests

John W. Linville (1):
      brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()

Kamal Mostafa (3):
      Revert "net/core/sock.c: add missing VSOCK string in af_family_*_key_strings"
      Revert "zram: use zram->lock to protect zram_free_page() in swap free notify path"
      Linux 3.8.13.10

Kees Cook (6):
      HID: validate HID report id size
      HID: pantherlord: validate output report details
      HID: ntrig: validate feature report details
      HID: sensor-hub: validate feature report details
      HID: picolcd_core: validate output report details
      HID: check for NULL field when setting values

Khalid Aziz (1):
      mm: fix aio performance regression for database caused by THP

Lan Tianyu (2):
      ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
      ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT

Libin (1):
      mm/huge_memory.c: fix potential NULL pointer dereference

Manoj Chourasia (1):
      HID: hidraw: correctly deallocate memory on device disconnect

Mark Brown (2):
      leds: wm831x-status: Request a REG resource
      clk: wm831x: Initialise wm831x pointer on init

Mark Rusk (1):
      drivers/misc/hpilo: Correct panic when an AUX iLO is detected

Maxim Patlasov (1):
      fuse: postpone end_page_writeback() in fuse_writepage_locked()

Mike Dyer (1):
      ASoC: wm8960: Fix PLL register writes

Miklos Szeredi (1):
      fuse: readdir: check for slash in names

Oleg Nesterov (1):
      pidns: fix vfork() after unshare(CLONE_NEWPID)

Oliver Neukum (1):
      USB: cdc-wdm: fix race between interrupt handler and tasklet

Pavel Shilovsky (1):
      CIFS: Fix a memory leak when a lease break comes

Peter Maydell (3):
      ARM: PCI: versatile: Fix map_irq function to match hardware
      ARM: PCI: versatile: Fix PCI I/O
      ARM: PCI: versatile: Fix SMAP register offsets

Roger Pau Monne (1):
      xen-gnt: prevent adding duplicate gnt callbacks

Sachin Kamat (1):
      [media] s5p-g2d: Fix registration failure

Sage Weil (1):
      libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc

Sarah Sharp (1):
      xhci-plat: Don't enable legacy PCI interrupts.

Sergei Shtylyov (1):
      mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Sergey Senozhatsky (2):
      zram: allow request end to coincide with disksize
      radeon kms: fix uninitialised hotplug work usage in r100_irq_process()

Shawn Nematbakhsh (1):
      usb: xhci: Disable runtime PM suspend for quirky controllers

Steffen Trumtrar (1):
      ASoC: mc13783: add spi errata fix

Takashi Iwai (1):
      ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Tejun Heo (1):
      rculist: list_first_or_null_rcu() should use list_entry_rcu()

Thomas Petazzoni (1):
      net: mvneta: properly disable HW PHY polling and ensure adjust_link() works

Vaidyanathan Srinivasan (1):
      powerpc: Default arch idle could cede processor on pseries

Will Deacon (2):
      arm64: perf: fix group validation when using enable_on_exec
      arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit

majianpeng (2):
      ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.
      libceph: unregister request in __map_request failed and nofail == false

