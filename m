Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3KIHTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:19:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932616Ab3KIGvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.11 00/94] 3.11.8-stable review
Date: Fri,  8 Nov 2013 22:51:06 -0800
Message-Id: <20131109065204.252462489@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.11.8 release.
There are 94 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon Nov 11 06:51:44 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.11.8-rc1

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

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    mutex: Avoid gcc version dependent __builtin_constant_p() usage

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix the PPT fdi lane bifurcate state handling on ivb

Rob Pearce <rob@flitspace.org.uk>
    drm/i915: No LVDS hardware on Intel D410PT and D425KT

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Add support for pipe_bpp readout

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Add HSW CRT output readout support

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: make missing smc ucode non-fatal (r7xx-SI)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: workaround vbios bug in transmitter table on rs780

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Pad drm_mode_get_connector to 64-bit boundary

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Prevent overwriting from userspace underallocating core ioctl structs

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Retry DP aux_ch communications with a different clock after failure

Rodrigo Vivi <rodrigo.vivi@gmail.com>
    drm/i915: split aux_clock_divider logic in a separated function for reuse.

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't kill clients on VT switch

Thomas Hellstrom <thellstrom@vmware.com>
    drm/vmwgfx: Don't put resources with invalid id's on lru list

Chen LinX <linx.z.chen@intel.com>
    mm/pagewalk.c: fix walk_page_range() access of wrong PTEs

Cyrill Gorcunov <gorcunov@gmail.com>
    mm: /proc/pid/pagemap: inspect _PAGE_SOFT_DIRTY only on present pages

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

Linus Walleij <linus.walleij@linaro.org>
    clk: nomadik: set all timers to use 2.4 MHz TIMCLK

Jonathan Austin <jonathan.austin@arm.com>
    clk: fixup argument order when setting VCO parameters

Dan Carpenter <dan.carpenter@oracle.com>
    aacraid: missing capable() check in compat ioctl

Ming Lei <ming.lei@canonical.com>
    lib/scatterlist.c: don't flush_kernel_dcache_page on slab page

Linus Torvalds <torvalds@linux-foundation.org>
    Fix a few incorrectly checked [io_]remap_pfn_range() calls

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

Roland Dreier <roland@purestorage.com>
    target: Fix assignment of LUN in tracepoints

Lukasz Dorau <lukasz.dorau@intel.com>
    md: Fix skipping recovery for read-only arrays.

Bian Yu <bianyu@kedacom.com>
    md: avoid deadlock when md_set_badblocks.

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "select: use freezable blocking call"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    Revert "epoll: use freezable blocking call"

Stanislaw Gruszka <sgruszka@redhat.com>
    Revert "rt2x00pci: Use PCI MSIs whenever possible"

Gwendal Grignou <gwendal@google.com>
    libata: make ata_eh_qc_retry() bump scmd->allowed on bogus failures

Shaohua Li <shli@kernel.org>
    raid5: avoid finding "discard" stripe

Shaohua Li <shli@kernel.org>
    raid5: set bio bi_vcnt 0 for discard request

Colin Ian King <colin.king@canonical.com>
    eCryptfs: fix 32 bit corruption issue

Geyslan G. Bem <geyslan@gmail.com>
    ecryptfs: Fix memory leakage in keystore.c

Aaron Lu <aaron.lu@intel.com>
    SCSI: sd: call blk_pm_runtime_init before add_disk

Khalid Aziz <khalid.aziz@oracle.com>
    SCSI: BusLogic: Fix an oops when intializing multimaster adapter

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

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: call ieee80211_scan_completed when needed

Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
    rtlwifi: rtl8192cu: Fix error in pointer arithmetic

Amitkumar Karwar <akarwar@marvell.com>
    mwifiex: fix SDIO interrupt lost issue

Bruno Randolf <br1@einfach.org>
    cfg80211: fix warning when using WEXT for IBSS

Luciano Coelho <luciano.coelho@intel.com>
    cfg80211: use the correct macro to check for active monitor support

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

David Herrmann <dh.herrmann@gmail.com>
    HID: wiimote: add LEGO-wiimote VID

Kent Overstreet <kmo@daterainc.com>
    bcache: Fixed incorrect order of arguments to bio_alloc_bioset()

Dirk Brandewie <dirk.j.brandewie@intel.com>
    cpufreq / intel_pstate: Fix max_perf_pct on resume

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    cpufreq: s3c64xx: Rename index to driver_data

Russ Anderson <rja@sgi.com>
    x86: Update UV3 hub revision ID

Jan Klos <honza.klos@gmail.com>
    cifs: Fix inability to write files >2GB to SMB2/3 shares

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Don't enable/disable RWE on bus suspend/resume.

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

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: start musb on the udc side, too


-------------

Diffstat:

 Makefile                                     |   4 +-
 arch/arc/mm/fault.c                          |   6 +-
 arch/parisc/kernel/head.S                    |   4 +
 arch/um/kernel/exitcode.c                    |   4 +-
 arch/x86/kernel/apic/x2apic_uv_x.c           |   2 +-
 arch/xtensa/kernel/signal.c                  |   2 +-
 drivers/ata/libata-eh.c                      |   6 +-
 drivers/clk/clk-nomadik.c                    |  21 +++
 drivers/clk/versatile/clk-icst.c             |   2 +-
 drivers/cpufreq/intel_pstate.c               |   7 +-
 drivers/cpufreq/s3c64xx-cpufreq.c            |   2 +-
 drivers/gpu/drm/drm_drv.c                    |   9 +-
 drivers/gpu/drm/i915/intel_crt.c             |  30 +++-
 drivers/gpu/drm/i915/intel_ddi.c             |  21 ++-
 drivers/gpu/drm/i915/intel_display.c         | 131 ++++++++++------
 drivers/gpu/drm/i915/intel_dp.c              | 132 +++++++++-------
 drivers/gpu/drm/i915/intel_drv.h             |   2 +
 drivers/gpu/drm/i915/intel_lvds.c            |  16 ++
 drivers/gpu/drm/radeon/atombios_encoders.c   |   2 +-
 drivers/gpu/drm/radeon/ni.c                  |   1 +
 drivers/gpu/drm/radeon/r600.c                |   1 +
 drivers/gpu/drm/radeon/si.c                  |   1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c          |  17 ++-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c     |   2 +-
 drivers/hid/hid-core.c                       |   1 +
 drivers/hid/hid-ids.h                        |   1 +
 drivers/hid/hid-wiimote-core.c               |   5 +-
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
 drivers/net/wireless/iwlwifi/mvm/scan.c      |  12 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c      |  10 ++
 drivers/net/wireless/mwifiex/main.c          |   6 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c      |   9 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |   3 +-
 drivers/ntb/ntb_hw.c                         |  41 ++++-
 drivers/ntb/ntb_hw.h                         |  16 ++
 drivers/ntb/ntb_regs.h                       |   4 +-
 drivers/ntb/ntb_transport.c                  |  17 +--
 drivers/scsi/BusLogic.c                      |  16 +-
 drivers/scsi/aacraid/linit.c                 |   2 +
 drivers/scsi/sd.c                            |   2 +-
 drivers/staging/bcm/Bcmchar.c                |   1 +
 drivers/staging/ozwpan/ozcdev.c              |   3 +
 drivers/staging/sb105x/sb_pci_mp.c           |   2 +-
 drivers/staging/wlags49_h2/wl_priv.c         |   9 +-
 drivers/target/target_core_pscsi.c           |   8 +-
 drivers/uio/uio.c                            |  41 +++--
 drivers/usb/core/quirks.c                    |   6 +
 drivers/usb/host/xhci-hub.c                  |  26 ----
 drivers/usb/musb/musb_core.c                 |  46 ++++++
 drivers/usb/musb/musb_core.h                 |   1 +
 drivers/usb/musb/musb_gadget.c               |   2 +
 drivers/usb/musb/musb_virthub.c              |  46 ------
 drivers/usb/serial/ftdi_sio.c                |   1 +
 drivers/usb/serial/ftdi_sio_ids.h            |   6 +
 drivers/usb/serial/option.c                  | 216 +++++++++++++++++++++++++++
 drivers/usb/storage/scsiglue.c               |   5 +-
 drivers/usb/storage/unusual_devs.h           |   7 +
 drivers/vhost/scsi.c                         |   2 +-
 drivers/video/au1100fb.c                     |  26 +---
 drivers/video/au1200fb.c                     |  23 +--
 fs/cifs/cifsfs.c                             |   6 +-
 fs/ecryptfs/crypto.c                         |   2 +-
 fs/ecryptfs/keystore.c                       |   3 +-
 fs/eventpoll.c                               |   4 +-
 fs/jfs/jfs_inode.c                           |   3 +-
 fs/proc/task_mmu.c                           |   4 +-
 fs/select.c                                  |   3 +-
 fs/seq_file.c                                |   2 +
 include/linux/usb_usual.h                    |   4 +-
 include/trace/events/target.h                |   4 +-
 include/uapi/drm/drm_mode.h                  |   2 +
 kernel/cgroup.c                              |   6 +-
 kernel/mutex.c                               |  32 ++--
 kernel/time/clockevents.c                    |  65 ++++++--
 lib/scatterlist.c                            |   3 +-
 mm/huge_memory.c                             |  70 ++++++---
 mm/memory.c                                  |  54 +++----
 mm/migrate.c                                 |  19 ++-
 mm/mprotect.c                                |   2 +-
 mm/pagewalk.c                                |   2 +-
 net/mac80211/cfg.c                           |   2 +-
 net/mac80211/ieee80211_i.h                   |   3 +
 net/mac80211/rx.c                            |   3 +
 net/mac80211/scan.c                          |  19 +++
 net/mac80211/status.c                        |   3 +
 net/mac80211/tx.c                            |   3 +-
 net/mac80211/util.c                          |   4 +
 net/wireless/ibss.c                          |   3 +
 net/wireless/nl80211.c                       |   4 +-
 scripts/kallsyms.c                           |  12 +-
 scripts/link-vmlinux.sh                      |   2 +
 sound/core/pcm.c                             |   4 +
 sound/pci/hda/hda_codec.c                    |   4 +-
 sound/pci/hda/hda_generic.c                  |   4 +-
 sound/pci/hda/patch_realtek.c                |   1 +
 sound/soc/codecs/wm_hubs.c                   |   1 +
 sound/soc/soc-dapm.c                         |   2 +-
 106 files changed, 1029 insertions(+), 459 deletions(-)


