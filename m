Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaAFWiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaAFWiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [PATCH 3.12 000/144] 3.12.7-stable review
Date: Mon,  6 Jan 2014 14:36:01 -0800
Message-Id: <20140106223745.326293132@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.7 release.
There are 144 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed Jan  8 22:37:25 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.7-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.12.7-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug

Zhang Rui <rui.zhang@intel.com>
    nouveau_acpi: convert acpi_get_handle() to acpi_has_method()

Benjamin LaHaise <bcrl@kvack.org>
    aio/migratepages: make aio migrate pages sane

Linus Torvalds <torvalds@linux-foundation.org>
    aio: clean up and fix aio_setup_ring page mapping

Dinh Nguyen <dinguyen@altera.com>
    clocksource: dw_apb_timer_of: Fix support for dts binding "snps,dw-apb-timer"

Dinh Nguyen <dinguyen@altera.com>
    clocksource: dw_apb_timer_of: Fix read_sched_clock

Paul Moore <pmoore@redhat.com>
    selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()

Paul Moore <pmoore@redhat.com>
    selinux: look for IPsec labels on both inbound and outbound packets

Geert Uytterhoeven <geert@linux-m68k.org>
    sh: always link in helper functions extracted from libgcc

Stephen Boyd <sboyd@codeaurora.org>
    gpio: msm: Fix irq mask/unmask by writing bits instead of numbers

Roger Quadros <rogerq@ti.com>
    gpio: twl4030: Fix regression for twl gpio LED output

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    sh-pfc: Fix PINMUX_GPIO macro

Theodore Ts'o <tytso@mit.edu>
    jbd2: don't BUG but return ENOSPC if a handle runs out of space

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/3270: fix allocation of tty3270_screen structure

Maxime Ripard <maxime.ripard@free-electrons.com>
    ARM: sun7i: dt: Fix interrupt trigger types

Vladimir Davydov <vdavydov@parallels.com>
    memcg: fix memcg_size() calculation

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: Fix incorrect invalidation for DIO/buffered I/O

Bob Peterson <rpeterso@redhat.com>
    GFS2: Fix slab memory leak in gfs2_bufdata

Bob Peterson <rpeterso@redhat.com>
    GFS2: Fix use-after-free race when calling gfs2_remove_from_ail

Steven Whitehouse <swhiteho@redhat.com>
    GFS2: don't hold s_umount over blkdev_put

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: allocate absinfo data when setting ABS capability

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm/memory-failure.c: transfer page count from head page to tail page after split thp

Rik van Riel <riel@redhat.com>
    mm: fix use-after-free in sys_remap_file_pages

Vlastimil Babka <vbabka@suse.cz>
    mm: munlock: fix deadlock in __munlock_pagevec()

Vlastimil Babka <vbabka@suse.cz>
    mm: munlock: fix a bug where THP tail page is encountered

Johannes Weiner <hannes@cmpxchg.org>
    mm: page_alloc: revert NUMA aspect of fair allocation policy

Jianguo Wu <wujianguo@huawei.com>
    mm/hugetlb: check for pte NULL pointer in __page_check_address()

Jianguo Wu <wujianguo@huawei.com>
    mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate successfully

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: respect ignore_skip_hint in update_pageblock_skip

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/mempolicy: correct putback method for isolate pages if failed

Mel Gorman <mgorman@suse.de>
    mm: numa: guarantee that tlb_flush_pending updates are visible before page table updates

Rik van Riel <riel@redhat.com>
    mm: fix TLB flush race between migration, and change_protection_range

Mel Gorman <mgorman@suse.de>
    mm: numa: avoid unnecessary work on the failure path

Mel Gorman <mgorman@suse.de>
    mm: numa: ensure anon_vma is locked to prevent parallel THP splits

Mel Gorman <mgorman@suse.de>
    mm: clear pmd_numa before invalidating

Rob Herring <robh@kernel.org>
    Revert "of/address: Handle #address-cells > 2 specially"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    intel_pstate: Fail initialization if P-state information is missing

Toshi Kani <toshi.kani@hp.com>
    ACPI / PCI / hotplug: Avoid warning when _ADR not present

Jan Kara <jack@suse.cz>
    ext2: Fix oops in ext2_get_block() called from ext2_quota_write()

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: pci: Fix oops on driver unload

Johannes Berg <johannes.berg@intel.com>
    radiotap: fix bitmap-end-finding buffer overrun

Shirish Pargaonkar <shirishpargaonkar@gmail.com>
    cifs: set FILE_CREATED

Sachin Prabhu <sprabhu@redhat.com>
    cifs: We do not drop reference to tlink in CIFSCheckMFSymlink()

Tejun Heo <tj@kernel.org>
    libata, freezer: avoid block device removal while system is frozen

Marc Carino <marc.ceeeee@gmail.com>
    libata: implement ATA_HORKAGE_NO_NCQ_TRIM and apply it to Micro M500 SSDs

Robin H. Johnson <robbat2@gentoo.org>
    libata: disable a disk via libata.force params

Michele Baldessari <michele@acksyn.org>
    libata: add ATA_HORKAGE_BROKEN_FPDMA_AA quirk for Seagate Momentus SpinPoint M8

Marek Vasut <marex@denx.de>
    ahci: imx: Explicitly clear IMX6Q_GPR13_SATA_MPLL_CLK_EN

Ilia Mirkin <imirkin@alum.mit.edu>
    drm/nouveau: only runtime suspend by default in optimus configuration

Shuah Khan <shuah.kh@samsung.com>
    power_supply: Fix Oops from NULL pointer dereference from wakeup_source_activate

Josh Boyer <jwboyer@redhat.com>
    cpupower: Fix segfault due to incorrect getopt_long arugments

Anton Blanchard <anton@samba.org>
    powerpc: Align p_end

Michael Neuling <mikey@neuling.org>
    powerpc: Fix bad stack check in exception entry

Jan Kiszka <jan.kiszka@siemens.com>
    KVM: x86: Fix APIC map calculation after re-enabling

Jan Kiszka <jan.kiszka@web.de>
    KVM: nVMX: Unconditionally uninit the MMU on nested vmexit

Mathy Vanhoef <vanhoefm@gmail.com>
    ath9k_htc: properly set MAC address and BSSID mask

Sujith Manoharan <c_manoha@qca.qualcomm.com>
    ath9k: Fix interrupt handling for the AR9002 family

Peter Korsgaard <peter@korsgaard.com>
    dm9601: work around tx fifo sync issue on dm962x

Peter Korsgaard <peter@korsgaard.com>
    dm9601: fix reception of full size ethernet frames on dm9620/dm9621a

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE

Tejun Heo <tj@kernel.org>
    cgroup: fix cgroup_create() error handling path

Nithin Sujir <nsujir@broadcom.com>
    tg3: Expand 4g_overflow_test workaround to skb fragments of any size.

Li Wang <liwang@ubuntukylin.com>
    ceph: Avoid data inconsistency due to d-cache aliasing in readpage()

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: set correct pipe config for Hawaii in DCE

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: 0x9649 is SUMO2 not SUMO

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: expose render backend mask to the userspace

Marek Olšák <marek.olsak@amd.com>
    drm/radeon: fix render backend setup for SI and CIK

Christian König <christian.koenig@amd.com>
    drm/radeon: fix UVD 256MB check

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Use the correct GMCH_CTRL register for Sandybridge+

Paulo Zanoni <paulo.r.zanoni@intel.com>
    drm/i915: change CRTC assertion on LCPLL disable

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Fix erroneous dereference of batch_obj inside reset_status

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix asic gfx values for scrapper asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: check for 0 count in speaker allocation and SAD code

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/dpm: disable ss on Cayman

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: don't update the dri1 breadcrumb with modesetting

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/i915: Fix use-after-free in do_switch

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Hold mutex across i915_gem_release

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/i915: Take modeset locks around intel_modeset_setup_hw_state()

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: add missing display tiling setup for oland

Christian König <christian.koenig@amd.com>
    drm/radeon: fix typo in cik_copy_dma

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Fix sideport problems on certain RS690 boards

Thomas Hellstrom <thellstrom@vmware.com>
    drm/ttm: Fix accesses through vmas with only partial coverage

Rafał Miłecki <zajec5@gmail.com>
    drm/edid: add quirk for BPC in Samsung NP700G7A-S01PL notebook

Dan Williams <dan.j.williams@intel.com>
    net_dma: mark broken

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: sbp2: bring back WRITE SAME support

Kirill Tkhai <tkhai@yandex.ru>
    sched/rt: Fix rq's cpupri leak while enqueue/dequeue child RT entities

Mel Gorman <mgorman@suse.de>
    sched: numa: skip inaccessible VMAs

Lukas Czerner <lczerner@redhat.com>
    ext4: fix FITRIM in no journal mode

Theodore Ts'o <tytso@mit.edu>
    ext4: add explicit casts when masking cluster sizes

Jan Kara <jack@suse.cz>
    ext4: fix deadlock when writing in ENOSPC conditions

Jan Kara <jack@suse.cz>
    ext4: Do not reserve clusters when fs doesn't support extents

Al Viro <viro@ZenIV.linux.org.uk>
    ext4: fix del_timer() misuse for ->s_err_report

Eryu Guan <guaneryu@gmail.com>
    ext4: check for overlapping extents in ext4_valid_extent_entries()

Junho Ryu <jayr@google.com>
    ext4: fix use-after-free in ext4_mb_new_blocks

Theodore Ts'o <tytso@mit.edu>
    ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails

Paul Drews <paul.drews@intel.com>
    ACPI: Add BayTrail SoC GPIO and LPSS ACPI IDs

Len Brown <len.brown@intel.com>
    x86 idle: Repair large-server 50-watt idle-power regression

Tony Lindgren <tony@atomide.com>
    ARM: OMAP2+: Fix LCD panel backlight regression for LDP legacy booting

Suman Anna <s-anna@ti.com>
    ARM: OMAP2+: hwmod_data: fix missing OMAP_INTC_START in irq data

Rajendra Nayak <rnayak@ti.com>
    ARM: DRA7: hwmod: Fix boot crash with DEBUG_LL

Ben Dooks <ben.dooks@codethink.co.uk>
    ARM: shmobile: r8a7790: fix shdi resource sizes

Will Deacon <will.deacon@arm.com>
    arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

Ming Lei <tom.leiming@gmail.com>
    scripts/link-vmlinux.sh: only filter kernel symbols for arm

Miao Xie <miaox@cn.fujitsu.com>
    ftrace: Initialize the ftrace profiler for each possible cpu

Jie Liu <jeff.liu@oracle.com>
    xfs: fix infinite loop by detaching the group/project hints from user dquot

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Update hw_max_sectors based on current block_size

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Move INIT_WORK setup into isert_create_device_ib_res

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix incorrect np->np_thread NULL assignment

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Fix-up all zero data-length CDBs with R/W_BIT set

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    iser-target: fix error return code in isert_create_device_ib_res()

Shivaram Upadhyayula <shivaram.u@quadstor.com>
    qla2xxx: Fix schedule_delayed_work() for target timeout calculations

Benjamin LaHaise <bcrl@kvack.org>
    aio: fix kioctx leak introduced by "aio: Fix a trinity splat"

Oleg Nesterov <oleg@redhat.com>
    selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Chad Hanson <chanson@trustedcs.com>
    selinux: fix broken peer recv check

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: only cancel work if it is initialized

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: musb: core: Call dma_controller_destroy() in error path only once.

Peter Chen <peter.chen@freescale.com>
    usb: chipidea: fix nobody cared IRQ when booting with host role

Fabio Estevam <fabio.estevam@freescale.com>
    usb: chipidea: host: Only disable the vbus regulator if it is not NULL

Bjørn Mork <bjorn@mork.no>
    usb: cdc-wdm: manage_power should always set needs_remote_wakeup

Marc Kleine-Budde <mkl@pengutronix.de>
    can: peak_usb: fix mem leak in pcan_usb_pro_init()

Takashi Iwai <tiwai@suse.de>
    xhci: Limit the spurious wakeup fix only to HP machines

Dmitry Kunilov <dmitry.kunilov@gmail.com>
    usb: serial: zte_ev: move support for ZTE AC2726 from zte_ev back to option

Mika Westerberg <mika.westerberg@linux.intel.com>
    serial: 8250_dw: add new ACPI IDs

Jonathan Cameron <jic23@kernel.org>
    iio:adc:ad7887 Fix channel reported endianness from cpu to big endian

Jonathan Cameron <jic23@kernel.org>
    iio:imu:adis16400 fix pressure channel scan type

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - Add Dell headset detection quirk for three laptop models

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Add enable_msi=0 workaround for four HP machines

JongHo Kim <furmuwon@gmail.com>
    ALSA: Add SNDRV_PCM_STATE_PAUSED case in wait_for_avail function

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm5110: Correct HPOUT3 DAPM route typo

Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
    ASoC: wm_adsp: Add small delay while polling DSP RAM start

Bo Shen <voice.shen@atmel.com>
    ASoC: wm8904: fix DSP mode B configuration

Stephen Warren <swarren@nvidia.com>
    ASoC: tegra: fix uninitialized variables in set_fmt

Vivek Goyal <vgoyal@redhat.com>
    kexec: migrate to reboot cpu

H Hartley Sweeten <hsweeten@visionengravers.com>
    staging: comedi: drivers: fix return value of comedi_load_firmware()

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: 8255_pci: fix for newer PCI-DIO48H

Geert Uytterhoeven <geert@linux-m68k.org>
    TTY: pmac_zilog, check existence of ports in pmz_console_init()

Peter Hurley <peter@hurleysoftware.com>
    n_tty: Fix apparent order of echoed output

Peter Hurley <peter@hurleysoftware.com>
    tty: Fix hang at ldsem_down_read()

pingfan liu <qemulist@gmail.com>
    powerpc: kvm: fix rare but potential deadlock scene

Li Wang <liwang@ubuntukylin.com>
    ceph: allocate non-zero page to fscache in readpage()

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: wake up 'safe' waiters when unregistering request

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: cleanup aborted requests when re-sending requests.

Milosz Tanski <milosz@adfin.com>
    ceph: hung on ceph fscache invalidate in some cases

Johan Hovold <jhovold@gmail.com>
    USB: serial: fix race in generic write


-------------

Diffstat:

 Documentation/kernel-parameters.txt                |   2 +
 Makefile                                           |   4 +-
 arch/arm/boot/dts/r8a7790.dtsi                     |   4 +-
 arch/arm/boot/dts/sun7i-a20.dtsi                   |  32 +++---
 arch/arm/mach-omap2/board-ldp.c                    |   7 +-
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   4 +-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   6 +-
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c          |   2 +-
 arch/arm64/kernel/ptrace.c                         |  38 ++++---
 arch/powerpc/include/asm/exception-64s.h           |   2 +-
 arch/powerpc/kernel/head_64.S                      |   1 +
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |   6 +-
 arch/powerpc/kvm/book3s_hv_rm_mmu.c                |   4 +
 arch/sh/lib/Makefile                               |   2 +-
 arch/sparc/include/asm/pgtable_64.h                |   4 +-
 arch/x86/include/asm/pgtable.h                     |  11 +-
 arch/x86/kernel/cpu/intel.c                        |   3 +-
 arch/x86/kvm/lapic.c                               |   8 +-
 arch/x86/kvm/vmx.c                                 |   3 +-
 drivers/acpi/acpi_lpss.c                           |   1 +
 drivers/acpi/bus.c                                 |  10 ++
 drivers/ata/ahci_imx.c                             |   3 +-
 drivers/ata/libata-core.c                          |  19 +++-
 drivers/ata/libata-scsi.c                          |  21 ++++
 drivers/clocksource/dw_apb_timer_of.c              |   7 +-
 drivers/cpufreq/intel_pstate.c                     |   5 +
 drivers/dma/Kconfig                                |   1 +
 drivers/firewire/sbp2.c                            |   1 -
 drivers/gpio/gpio-msm-v2.c                         |   4 +-
 drivers/gpio/gpio-twl4030.c                        |  15 ++-
 drivers/gpu/drm/drm_edid.c                         |   8 ++
 drivers/gpu/drm/i915/i915_dma.c                    |  10 ++
 drivers/gpu/drm/i915/i915_gem.c                    |  34 +++++--
 drivers/gpu/drm/i915/i915_gem_context.c            |  16 ++-
 drivers/gpu/drm/i915/intel_display.c               |   9 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c             |  19 +++-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |   6 ++
 drivers/gpu/drm/radeon/atombios_crtc.c             |  23 ++---
 drivers/gpu/drm/radeon/cik.c                       |  12 ++-
 drivers/gpu/drm/radeon/cik_sdma.c                  |   2 +-
 drivers/gpu/drm/radeon/dce6_afmt.c                 |   4 +-
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |   4 +-
 drivers/gpu/drm/radeon/ni.c                        |  20 +++-
 drivers/gpu/drm/radeon/radeon.h                    |   4 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c       |  16 ++-
 drivers/gpu/drm/radeon/radeon_kms.c                |   9 ++
 drivers/gpu/drm/radeon/radeon_uvd.c                |   2 +-
 drivers/gpu/drm/radeon/rs690.c                     |  10 ++
 drivers/gpu/drm/radeon/rv770_dpm.c                 |   6 ++
 drivers/gpu/drm/radeon/si.c                        |  12 ++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                    |   6 +-
 drivers/idle/intel_idle.c                          |   3 +
 drivers/iio/adc/ad7887.c                           |  16 ++-
 drivers/iio/imu/adis16400_core.c                   |   7 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  22 ++--
 drivers/input/input.c                              |   4 +
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   3 +
 drivers/net/ethernet/broadcom/tg3.c                |   2 +-
 drivers/net/usb/dm9601.c                           |  34 +++++--
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |  52 ++++++++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |  25 +++--
 drivers/net/wireless/ath/ath9k/main.c              |   5 +-
 drivers/net/wireless/rtlwifi/pci.c                 |   4 +-
 drivers/of/address.c                               |   8 --
 drivers/pci/hotplug/acpiphp_glue.c                 |  30 +++++-
 drivers/pinctrl/pinctrl-baytrail.c                 |   1 +
 drivers/pinctrl/sh-pfc/sh_pfc.h                    |   2 +-
 drivers/power/power_supply_core.c                  |  12 +--
 drivers/s390/char/tty3270.c                        |   2 +-
 drivers/scsi/qla2xxx/qla_target.c                  |   9 +-
 drivers/staging/comedi/drivers.c                   |   2 +-
 drivers/staging/comedi/drivers/8255_pci.c          |  15 ++-
 drivers/target/iscsi/iscsi_target.c                |  27 +++--
 drivers/target/iscsi/iscsi_target_login.c          |   6 --
 drivers/target/target_core_device.c                |   5 +
 drivers/target/target_core_file.c                  |   8 +-
 drivers/target/target_core_file.h                  |   5 +-
 drivers/tty/n_tty.c                                |   7 +-
 drivers/tty/serial/8250/8250_dw.c                  |   2 +
 drivers/tty/serial/pmac_zilog.c                    |   3 +
 drivers/tty/tty_ldsem.c                            |  16 ++-
 drivers/usb/chipidea/core.c                        |   4 +
 drivers/usb/chipidea/host.c                        |   3 +-
 drivers/usb/chipidea/udc.c                         |   3 -
 drivers/usb/class/cdc-wdm.c                        |   8 +-
 drivers/usb/host/xhci-pci.c                        |   7 +-
 drivers/usb/musb/musb_core.c                       |  14 +--
 drivers/usb/serial/generic.c                       |   9 +-
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/serial/zte_ev.c                        |   3 +-
 fs/aio.c                                           | 113 +++++++++++++--------
 fs/ceph/addr.c                                     |  10 +-
 fs/ceph/cache.c                                    |   3 +
 fs/ceph/mds_client.c                               |   8 +-
 fs/cifs/cifsproto.h                                |   7 +-
 fs/cifs/dir.c                                      |  11 +-
 fs/cifs/inode.c                                    |   6 +-
 fs/cifs/link.c                                     |  26 ++---
 fs/ext2/super.c                                    |   1 +
 fs/ext4/ext4.h                                     |  10 ++
 fs/ext4/ext4_jbd2.c                                |   9 ++
 fs/ext4/extents.c                                  |  45 +++++---
 fs/ext4/inode.c                                    |  12 ---
 fs/ext4/mballoc.c                                  |  21 ++--
 fs/ext4/super.c                                    |  21 ++--
 fs/gfs2/aops.c                                     |  30 ++++++
 fs/gfs2/log.c                                      |   4 +-
 fs/gfs2/meta_io.c                                  |   5 +
 fs/gfs2/ops_fstype.c                               |  12 ++-
 fs/jbd2/transaction.c                              |   6 +-
 fs/xfs/xfs_qm.c                                    |  71 +++++++++----
 include/acpi/acpi_bus.h                            |   4 +-
 include/asm-generic/pgtable.h                      |   2 +-
 include/drm/drm_pciids.h                           |   2 +-
 include/linux/auxvec.h                             |   2 +-
 include/linux/libata.h                             |   1 +
 include/linux/migrate.h                            |   3 +-
 include/linux/mm_types.h                           |  49 +++++++++
 include/linux/reboot.h                             |   1 +
 include/target/target_core_base.h                  |   1 +
 include/uapi/drm/radeon_drm.h                      |   2 +
 kernel/cgroup.c                                    |  31 ++++--
 kernel/fork.c                                      |   1 +
 kernel/freezer.c                                   |   6 ++
 kernel/kexec.c                                     |   1 +
 kernel/reboot.c                                    |   2 +-
 kernel/sched/fair.c                                |   7 ++
 kernel/sched/rt.c                                  |  14 +++
 kernel/trace/ftrace.c                              |   2 +-
 mm/compaction.c                                    |   4 +
 mm/fremap.c                                        |   8 +-
 mm/huge_memory.c                                   |  14 +++
 mm/memcontrol.c                                    |   2 +-
 mm/memory-failure.c                                |  24 ++++-
 mm/mempolicy.c                                     |   2 +-
 mm/migrate.c                                       |  17 ++--
 mm/mlock.c                                         |  44 +++++---
 mm/mprotect.c                                      |   2 +
 mm/page_alloc.c                                    |  19 ++--
 mm/pgtable-generic.c                               |   8 +-
 mm/rmap.c                                          |   4 +
 net/wireless/radiotap.c                            |   4 +
 scripts/link-vmlinux.sh                            |   4 +-
 security/selinux/hooks.c                           |  53 ++++++++--
 security/selinux/include/xfrm.h                    |   9 +-
 security/selinux/xfrm.c                            |  53 ++++++++--
 sound/core/pcm_lib.c                               |   2 +
 sound/pci/hda/hda_intel.c                          |   4 +
 sound/pci/hda/patch_realtek.c                      |   3 +
 sound/soc/codecs/wm5110.c                          |   2 +-
 sound/soc/codecs/wm8904.c                          |   2 +-
 sound/soc/codecs/wm_adsp.c                         |  10 +-
 sound/soc/tegra/tegra20_i2s.c                      |   6 +-
 sound/soc/tegra/tegra20_spdif.c                    |  10 +-
 sound/soc/tegra/tegra30_i2s.c                      |   6 +-
 tools/power/cpupower/utils/cpupower-set.c          |   6 +-
 156 files changed, 1234 insertions(+), 502 deletions(-)


