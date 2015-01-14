Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbbANHeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:34:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455AbbANHeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:34:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/77] 3.14.29-stable review
Date: Tue, 13 Jan 2015 23:22:40 -0800
Message-Id: <20150114072224.182299947@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.29 release.
There are 77 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 16 07:22:07 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.29-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.29-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    mm: Don't count the stack guard page towards RLIMIT_STACK

Linus Torvalds <torvalds@linux-foundation.org>
    mm: propagate error from stack expansion even for guard page

Vlastimil Babka <vbabka@suse.cz>
    mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled process being killed

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mmc: sdhci: Fix sleep in atomic after inserting SD card

Stefan Roese <sr@denx.de>
    spi: fsl: Fix problem with multi message transfers

Jiri Olsa <jolsa@kernel.org>
    perf session: Do not fail on processing out of order event

Jiri Olsa <jolsa@kernel.org>
    perf: Fix events installation during moving group

Jiri Olsa <jolsa@kernel.org>
    perf/x86/intel/uncore: Make sure only uncore events are collected

Chris Mason <clm@fb.com>
    Btrfs: don't delay inode ref updates during log replay

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Laura Abbott <lauraa@codeaurora.org>
    arm64: Move cpu_resume into the text section

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    arm64: kernel: refactor the CPU suspend API for retention states

Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>
    arm64: kernel: add missing __init section marker to cpu_suspend_init

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Fix PM initialization for devices that are not present

Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    ARM: mvebu: disable I/O coherency on non-SMP situations on Armada 370/375/38x/XP

Pavel Machek <pavel@ucw.cz>
    Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo"

Nishanth Menon <nm@ti.com>
    ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps

Tomasz Figa <tomasz.figa@gmail.com>
    ARM: dts: Enable PWM node by default for s3c64xx

Lokesh Vutla <lokeshvutla@ti.com>
    ARM: dts: DRA7: wdt: Fix compatible property for watchdog node

Luca Abeni <luca.abeni@unitn.it>
    sched/deadline: Avoid double-accounting in case of missed deadlines

Luca Abeni <luca.abeni@unitn.it>
    sched/deadline: Fix migration of SCHED_DEADLINE tasks

Johannes Berg <johannes.berg@intel.com>
    scripts/kernel-doc: don't eat struct members with __aligned

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Brian Norris <computersforpeace@gmail.com>
    mtd: tests: abort torturetest on erase errors

Yan, Zheng <zheng.z.yan@intel.com>
    ceph: fix null pointer dereference in discard_cap_releases()

Dan Carpenter <dan.carpenter@oracle.com>
    ceph: do_sync is never initialized

Benjamin Coddington <bcodding@redhat.com>
    nfsd4: fix xdr4 inclusion of escaped char

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    fs: nfsd: Fix signedness bug in compare_blob

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: vmbus: Fix a race condition when unregistering a device

Christian Riesch <christian.riesch@omicron.at>
    n_tty: Fix read_buf race condition, increment read_head after pushing data

Robert Baldyga <r.baldyga@samsung.com>
    serial: samsung: wait for transfer completion before clock disable

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing/sched: Check preempt_count() for current when reading task->state

Tejun Heo <tj@kernel.org>
    writeback: fix a subtle race condition in I_DIRTY clearing

Oliver Neukum <oneukum@suse.de>
    cdc-acm: memory leak in error case

Jens Axboe <axboe@fb.com>
    genhd: check for int overflow in disk_expand_part_tbl()

Steev Klimaszewski <threeway@gmail.com>
    Add USB_EHCI_EXYNOS to multi_v7_defconfig

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: cdc-acm: check for valid interfaces

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda - using uninitialized data

Jiri Jaburek <jjaburek@redhat.com>
    ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Ian Abbott <abbotti@mev.co.uk>
    misc: genwqe: check for error from get_user_pages_fast()

Alex Williamson <alex.williamson@redhat.com>
    driver core: Fix unbalanced device reference in drivers_probe

Andy Lutomirski <luto@amacapital.net>
    x86, vdso: Use asm volatile in __getcpu

Andy Lutomirski <luto@amacapital.net>
    x86_64, vdso: Fix the vdso address randomization algorithm

Paolo Bonzini <pbonzini@redhat.com>
    kvm: x86: drop severity of "generation wraparound" message

Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
    HID: Add a new id 0x501a for Genius MousePen i608X

Karl Relton <karllinuxtest.relton@ntlworld.com>
    HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: potential out of bounds in pyra_sysfs_write_settings()

Gwendal Grignou <gwendal@chromium.org>
    HID: i2c-hid: prevent buffer overflow in early IRQ

Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
    HID: i2c-hid: fix race condition reading reports

Jens Axboe <axboe@fb.com>
    blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map

Jiang Liu <jiang.liu@linux.intel.com>
    iommu/vt-d: Fix an off-by-one bug in __domain_mapping()

Richard Weinberger <richard@nod.at>
    UBI: Fix double free after do_sync_erase()

Richard Weinberger <richard@nod.at>
    UBI: Fix invalid vfree()

Tony Lindgren <tony@atomide.com>
    pstore-ram: Allow optional mapping with pgprot_noncached

Rob Herring <robherring2@gmail.com>
    pstore-ram: Fix hangs by using write-combine mappings

Myron Stowe <myron.stowe@redhat.com>
    PCI: Restore detection of read-only BARs

Paul Mackerras <paulus@samba.org>
    powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mode

Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
    powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Anton Blanchard <anton@samba.org>
    powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Andrew Jackson <Andrew.Jackson@arm.com>
    ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: max98090: Fix ill-defined sidetone route

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sigmadsp: Refuse to load firmware files with a non-supported version

Felix Fietkau <nbd@openwrt.org>
    ath5k: fix hardware queue index assignment

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: update values for Smart Fifo

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    swiotlb-xen: pass dev_addr to swiotlb_tbl_unmap_single

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    swiotlb-xen: call xen_dma_sync_single_for_device when appropriate

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    swiotlb-xen: remove BUG_ON in xen_bus_to_phys

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    swiotlb-xen: pass dev_addr to xen_dma_unmap_page and xen_dma_sync_single_for_cpu

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix memset() usage

Stephane Grosjean <s.grosjean@peak-system.com>
    can: peak_usb: fix cleanup sequence order in case of error during init

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix BE/BK queue order

Felix Fietkau <nbd@openwrt.org>
    ath9k_hw: fix hardware queue allocation

Xue jiufei <xuejiufei@huawei.com>
    ocfs2: fix the wrong directory passed to ocfs2_lookup_ino_from_name() when link file

Junxiao Bi <junxiao.bi@oracle.com>
    ocfs2: fix journal commit deadlock

Arnaud Ebalard <arno@natisbad.org>
    drivers/rtc/rtc-isl12057.c: fix masking of register values

Guo Zeng <guo.zeng@csr.com>
    drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe


-------------

Diffstat:

 Documentation/ramoops.txt                     | 13 ++++-
 Makefile                                      |  4 +-
 arch/arm/boot/dts/dra7.dtsi                   |  2 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts        |  4 --
 arch/arm/boot/dts/s3c64xx.dtsi                |  1 -
 arch/arm/configs/multi_v7_defconfig           |  1 +
 arch/arm/kernel/setup.c                       |  9 +++
 arch/arm/kernel/smp.c                         | 13 ++++-
 arch/arm/mach-mvebu/coherency.c               | 26 +++++++++
 arch/arm/mach-omap2/pm44xx.c                  | 29 +++-------
 arch/arm64/include/asm/suspend.h              |  1 +
 arch/arm64/kernel/sleep.S                     | 83 +++++++++++++--------------
 arch/arm64/kernel/suspend.c                   | 68 ++++++++++++++--------
 arch/powerpc/include/asm/reg.h                |  2 +
 arch/powerpc/kernel/idle_power7.S             | 18 +++++-
 arch/powerpc/kernel/mce_power.c               |  4 +-
 arch/powerpc/kernel/udbg_16550.c              |  6 +-
 arch/x86/include/asm/vsyscall.h               |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 22 ++++++-
 arch/x86/kvm/mmu.c                            |  2 +-
 arch/x86/vdso/vma.c                           | 43 +++++++++-----
 block/blk-mq-cpumap.c                         |  2 +-
 block/genhd.c                                 | 11 +++-
 drivers/acpi/device_pm.c                      |  2 +-
 drivers/acpi/scan.c                           | 13 +++--
 drivers/base/bus.c                            |  8 ++-
 drivers/hid/hid-core.c                        |  1 +
 drivers/hid/hid-ids.h                         |  1 +
 drivers/hid/hid-input.c                       |  3 +
 drivers/hid/hid-kye.c                         |  4 ++
 drivers/hid/hid-roccat-pyra.c                 |  8 ++-
 drivers/hid/i2c-hid/i2c-hid.c                 | 14 +++--
 drivers/hid/usbhid/hid-quirks.c               |  1 +
 drivers/hv/channel_mgmt.c                     | 11 +++-
 drivers/iommu/intel-iommu.c                   |  8 +--
 drivers/misc/genwqe/card_utils.c              |  2 +
 drivers/mmc/host/sdhci.c                      |  8 ++-
 drivers/mtd/tests/torturetest.c               |  4 +-
 drivers/mtd/ubi/upd.c                         | 10 ++--
 drivers/mtd/ubi/wl.c                          | 10 +---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c  | 17 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c   |  3 +-
 drivers/net/wireless/ath/ath5k/qcu.c          |  8 +--
 drivers/net/wireless/ath/ath9k/hw.h           |  4 +-
 drivers/net/wireless/ath/ath9k/mac.c          |  9 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |  2 +-
 drivers/pci/probe.c                           |  3 +
 drivers/rtc/rtc-isl12057.c                    |  4 +-
 drivers/rtc/rtc-sirfsoc.c                     | 16 +++---
 drivers/spi/spi-fsl-spi.c                     | 20 +++++--
 drivers/tty/n_tty.c                           |  3 +-
 drivers/tty/serial/samsung.c                  |  4 ++
 drivers/usb/class/cdc-acm.c                   | 10 ++--
 drivers/xen/swiotlb-xen.c                     | 10 ++--
 fs/btrfs/delayed-inode.c                      |  8 +++
 fs/ceph/addr.c                                |  2 +-
 fs/ceph/mds_client.c                          | 21 ++++---
 fs/fs-writeback.c                             | 29 +++++++---
 fs/nfsd/nfs4state.c                           | 15 +++--
 fs/nfsd/nfs4xdr.c                             |  3 +
 fs/nilfs2/inode.c                             | 32 ++++++++---
 fs/nilfs2/namei.c                             | 15 ++++-
 fs/ocfs2/aops.c                               | 16 +++++-
 fs/ocfs2/namei.c                              | 43 +++++++++++---
 fs/pstore/ram.c                               | 13 ++++-
 fs/pstore/ram_core.c                          | 31 +++++++---
 include/linux/mm.h                            |  2 +-
 include/linux/pstore_ram.h                    |  4 +-
 include/trace/events/sched.h                  |  2 +-
 kernel/events/core.c                          |  4 +-
 kernel/sched/deadline.c                       | 25 ++------
 mm/memory.c                                   |  4 +-
 mm/mmap.c                                     |  7 ++-
 mm/vmscan.c                                   | 24 ++++----
 scripts/kernel-doc                            |  2 +-
 sound/pci/hda/hda_codec.c                     |  4 +-
 sound/pci/hda/patch_sigmatel.c                |  4 +-
 sound/soc/codecs/max98090.c                   |  4 +-
 sound/soc/codecs/sigmadsp.c                   |  7 +++
 sound/soc/dwc/designware_i2s.c                | 14 +++++
 sound/usb/mixer_maps.c                        | 15 ++++-
 tools/perf/util/hist.h                        |  1 +
 tools/perf/util/session.c                     |  5 +-
 83 files changed, 620 insertions(+), 323 deletions(-)


