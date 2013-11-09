Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab3KIHaI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:30:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3KIGu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.10 00/74] 3.10.19-stable review
Date: Fri,  8 Nov 2013 22:51:05 -0800
Message-Id: <20131109065113.502217951@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.19 release.
There are 74 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Nov 11 06:50:58 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.19-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.19-rc1

Jon Mason <jon.mason@intel.com>
    NTB: Correct debugfs to work with more than 1 NTB Device

Jon Mason <jon.mason@intel.com>
    NTB: Correct USD/DSD Identification

Jon Mason <jon.mason@intel.com>
    NTB: Correct Number of Scratch Pad Registers

Jon Mason <jon.mason@intel.com>
    NTB: Add Error Handling in ntb_device_setup

Gu Zheng <guz.fnst@cn.fujitsu.com>
    seq_file: always update file->f_pos in seq_lseek()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Pad drm_mode_get_connector to 64-bit boundary

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Prevent overwriting from userspace underallocating core ioctl structs

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't kill clients on VT switch

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't put resources with invalid id's on lru list

Zhang Yanfei <zhangyanfei.yes@gmail.com>
    mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()

Chen LinX <linx.z.chen@intel.com>
    mm/pagewalk.c: fix walk_page_range() access of wrong PTEs

Mel Gorman <mgorman@suse.de>
    mm: Account for a THP NUMA hinting update as one PTE update

Mel Gorman <mgorman@suse.de>
    mm: Close races between THP migration and PMD numa clearing

Mel Gorman <mgorman@suse.de>
    mm: numa: Sanitize task_numa_fault() callsites

Mel Gorman <mgorman@suse.de>
    mm: Prevent parallel splits during THP migration

Mel Gorman <mgorman@suse.de>
    mm: Wait for THP migrations to complete during NUMA hinting faults

Mel Gorman <mgorman@suse.de>
    mm: numa: Do not account for a hinting fault if we raced

Jonathan Austin <jonathan.austin@arm.com>
    clk: fixup argument order when setting VCO parameters

Dan Carpenter <dan.carpenter@oracle.com>
    aacraid: missing capable() check in compat ioctl

Ming Lei <ming.lei@canonical.com>
    lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Linus Torvalds <torvalds@linux-foundation.org>
    Fix a few incorrectly checked [io_]remap_pfn_range() calls

Al Viro <viro@zeniv.linux.org.uk>
    au1200fb: io_remap_pfn_range() sets VM_IO

Al Viro <viro@zeniv.linux.org.uk>
    au1100fb: VM_IO is set by io_remap_pfn_range()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    uio: provide vm access to UIO_MEM_PHYS maps

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    mm: make generic_access_phys available for modules

Baruch Siach <baruch@tkos.co.il>
    xtensa: don't use alternate signal stack on threads

Dan Carpenter <dan.carpenter@oracle.com>
    uml: check length in exitcode_proc_write()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: wlags49_h2: buffer overflow setting station name

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: sb105x: info leak in mp_get_count()

Dan Carpenter <dan.carpenter@oracle.com>
    Staging: bcm: info leak in ioctl

Dan Carpenter <dan.carpenter@oracle.com>
    staging: ozwpan: prevent overflow in oz_cdev_write()

Takashi Iwai <tiwai@suse.de>
    ASoC: dapm: Fix source list debugfs outputs

Takashi Iwai <tiwai@suse.de>
    ASoC: wm_hubs: Add missing break in hp_supply_event()

Russell King <rmk+kernel@arm.linux.org.uk>
    ALSA: fix oops in snd_pcm_info() caused by ASoC DPCM

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add a fixup for ASUS N76VZ

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing initial vmaster hook at build_controls callback

Vineet Gupta <Vineet.Gupta1@synopsys.com>
    ARC: Incorrect mm reference used in vmalloc fault handler

Ming Lei <tom.leiming@gmail.com>
    scripts/kallsyms: filter symbols not in kernel address space

Helge Deller <deller@gmx.de>
    parisc: Do not crash 64bit SMP kernels on machines with >= 4GB RAM

Thomas Gleixner <tglx@linutronix.de>
    clockevents: Sanitize ticks to nsec conversion

Nicholas Bellinger <nab@linux-iscsi.org>
    vhost/scsi: Fix incorrect usage of get_user_pages_fast write parameter

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    target/pscsi: fix return value check

Lukasz Dorau <lukasz.dorau@intel.com>
    md: Fix skipping recovery for read-only arrays.

Bian Yu <bianyu@kedacom.com>
    md: avoid deadlock when md_set_badblocks.

Gwendal Grignou <gwendal@google.com>
    libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Shaohua Li <shli@kernel.org>
    raid5: avoid finding "discard" stripe

Shaohua Li <shli@kernel.org>
    raid5: set bio bi_vcnt 0 for discard request

Geyslan G. Bem <geyslan@gmail.com>
    ecryptfs: Fix memory leakage in keystore.c

Aaron Lu <aaron.lu@intel.com>
    SCSI: sd: call blk_pm_runtime_init before add_disk

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: flexcan_chip_start: fix regression, mark one MB for TX and abort pending TX

Marc Kleine-Budde <mkl@pengutronix.de>
    can: flexcan: fix mx28 detection by rearanging OF match table

Marc Kleine-Budde <mkl@pengutronix.de>
    can: at91-can: fix device to driver data mapping for platform devices

Dave Kleikamp <dave.kleikamp@oracle.com>
    jfs: fix error path in ialloc

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: pcie: add SKUs for 6000, 6005 and 6235 series

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
    rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix SDIO interrupt lost issue

Bruno Randolf <br1@einfach.org>
    cfg80211: fix warning when using WEXT for IBSS

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix tx queue scheduling after channel changes

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix crash if bitrate calculation goes wrong

Felix Fietkau <nbd@openwrt.org>
    mac80211: update sta->last_rx on acked tx frames

Felix Fietkau <nbd@openwrt.org>
    mac80211: use sta_info_get_bss() for nl80211 tx and client probing

Felix Fietkau <nbd@openwrt.org>
    mac80211: drop spoofed packets in ad-hoc mode

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    mac80211: correctly close cancelled scans

Anjana V Kumar <anjanavk12@gmail.com>
    cgroup: fix to break the while loop in cgroup_attach_task() correctly

Kent Overstreet <kmo@daterainc.com>
    bcache: Fixed incorrect order of arguments to bio_alloc_bioset()

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: Fix max_perf_pct on resume

Russ Anderson <rja@sgi.com>
    x86: Update UV3 hub revision ID

Алексей Крамаренко <alexeyk13@yandex.ru>
    USB: serial: ftdi_sio: add id for Z3X Box device

Oliver Neukum <oneukum@suse.de>
    USB: quirks: add touchscreen that is dazzeled by remote wakeup

Oliver Neukum <oneukum@suse.de>
    USB: quirks.c: add one device that cannot deal with suspension

Fangxiaozhi (Franko) <fangxiaozhi@huawei.com>
    USB: support new huawei devices in option.c

Oliver Neukum <oneukum@suse.de>
    usb-storage: add quirk for mandatory READ_CAPACITY_16


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arc/mm/fault.c                          |   6 +-
 arch/parisc/kernel/head.S                    |   4 +
 arch/um/kernel/exitcode.c                    |   4 +-
 arch/x86/kernel/apic/x2apic_uv_x.c           |   2 +-
 arch/xtensa/kernel/signal.c                  |   2 +-
 drivers/ata/libata-eh.c                      |   6 +-
 drivers/clk/versatile/clk-icst.c             |   2 +-
 drivers/cpufreq/intel_pstate.c               |   7 +-
 drivers/gpu/drm/drm_drv.c                    |   9 +-
 drivers/gpu/drm/radeon/atombios_encoders.c   |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |  17 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |   2 +-
 drivers/md/bcache/request.c                  |   2 +-
 drivers/md/md.c                              |   5 +-
 drivers/md/raid1.c                           |   1 +
 drivers/md/raid10.c                          |   1 +
 drivers/md/raid5.c                           |  20 +++
 drivers/net/can/at91_can.c                   |   4 +-
 drivers/net/can/flexcan.c                    |  14 +-
 drivers/net/wireless/ath/ath9k/main.c        |  23 ++-
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   6 +
 drivers/net/wireless/iwlwifi/iwl-config.h    |   1 +
 drivers/net/wireless/iwlwifi/pcie/drv.c      |  10 ++
 drivers/net/wireless/mwifiex/main.c          |   6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   3 +-
 drivers/ntb/ntb_hw.c                         |  41 ++++-
 drivers/ntb/ntb_hw.h                         |  16 ++
 drivers/ntb/ntb_regs.h                       |   4 +-
 drivers/ntb/ntb_transport.c                  |  17 +--
 drivers/scsi/aacraid/linit.c                 |   2 +
 drivers/scsi/sd.c                            |   2 +-
 drivers/staging/bcm/Bcmchar.c                |   1 +
 drivers/staging/ozwpan/ozcdev.c              |   3 +
 drivers/staging/sb105x/sb_pci_mp.c           |   2 +-
 drivers/staging/wlags49_h2/wl_priv.c         |   9 +-
 drivers/target/target_core_pscsi.c           |   8 +-
 drivers/uio/uio.c                            |  41 +++--
 drivers/usb/core/quirks.c                    |   6 +
 drivers/usb/serial/ftdi_sio.c                |   1 +
 drivers/usb/serial/ftdi_sio_ids.h            |   6 +
 drivers/usb/serial/option.c                  | 216 +++++++++++++++++++++++++++
 drivers/usb/storage/scsiglue.c               |   5 +-
 drivers/usb/storage/unusual_devs.h           |   7 +
 drivers/vhost/scsi.c                         |   2 +-
 drivers/video/au1100fb.c                     |  28 +---
 drivers/video/au1200fb.c                     |  27 +---
 fs/ecryptfs/keystore.c                       |   3 +-
 fs/jfs/jfs_inode.c                           |   3 +-
 fs/seq_file.c                                |   2 +
 include/linux/usb_usual.h                    |   4 +-
 include/uapi/drm/drm_mode.h                  |   2 +
 kernel/cgroup.c                              |   6 +-
 kernel/time/clockevents.c                    |  65 ++++++--
 lib/scatterlist.c                            |   3 +-
 mm/huge_memory.c                             |  70 ++++++---
 mm/memory.c                                  |  54 +++----
 mm/migrate.c                                 |  19 ++-
 mm/mprotect.c                                |   2 +-
 mm/pagewalk.c                                |   2 +-
 mm/vmalloc.c                                 |   6 +-
 net/mac80211/cfg.c                           |   2 +-
 net/mac80211/ieee80211_i.h                   |   3 +
 net/mac80211/rx.c                            |   3 +
 net/mac80211/scan.c                          |  19 +++
 net/mac80211/status.c                        |   3 +
 net/mac80211/tx.c                            |   3 +-
 net/mac80211/util.c                          |   4 +
 net/wireless/ibss.c                          |   3 +
 scripts/kallsyms.c                           |  12 +-
 scripts/link-vmlinux.sh                      |   2 +
 sound/core/pcm.c                             |   4 +
 sound/pci/hda/hda_codec.c                    |   4 +-
 sound/pci/hda/hda_generic.c                  |   4 +-
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/soc/codecs/wm_hubs.c                   |   1 +
 sound/soc/soc-dapm.c                         |   2 +-
 77 files changed, 681 insertions(+), 237 deletions(-)


