Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbbANIvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:51:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbbANHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:25:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.18 000/150] 3.18.3-stable review
Date: Tue, 13 Jan 2015 23:21:11 -0800
Message-Id: <20150114072055.842408181@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.18.3 release.
There are 150 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 16 07:20:24 UTC 2015.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.18.3-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.18.3-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    mm: Don't count the stack guard page towards RLIMIT_STACK

Linus Torvalds <torvalds@linux-foundation.org>
    mm: propagate error from stack expansion even for guard page

Vlastimil Babka <vbabka@suse.cz>
    mm, vmscan: prevent kswapd livelock due to pfmemalloc-throttled process being killed

Johannes Weiner <hannes@cmpxchg.org>
    mm: protect set_page_dirty() from ongoing truncation

Oleg Nesterov <oleg@redhat.com>
    exit: fix race between wait_consider_task() and wait_task_zombie()

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    mmc: sdhci: Fix sleep in atomic after inserting SD card

Krzysztof Kozlowski <k.kozlowski@samsung.com>
    regulator: s2mps11: Fix dw_mmc failure on Gear 2

Dave Airlie <airlied@redhat.com>
    nouveau: bring back legacy mmap handler

Bruno Prémont <bonbons@linux-vserver.org>
    drm/nouveau/nouveau: Do not BUG_ON(!spin_is_locked()) on UP

Hisashi Nakamura <hisashi.nakamura.ak@renesas.com>
    spi: sh-msiof: Add runtime PM lock in initializing

Jiri Olsa <jolsa@kernel.org>
    perf session: Do not fail on processing out of order event

Andi Kleen <ak@linux.intel.com>
    perf/x86/uncore/hsw-ep: Handle systems with only two SBOXes

Jiri Olsa <jolsa@kernel.org>
    perf: Fix events installation during moving group

Jiri Olsa <jolsa@kernel.org>
    perf/x86/intel/uncore: Make sure only uncore events are collected

Johannes Berg <johannes.berg@intel.com>
    Revert "mac80211: Fix accounting of the tailroom-needed counter"

Chris Mason <clm@fb.com>
    Btrfs: don't delay inode ref updates during log replay

Mathias Krause <minipli@googlemail.com>
    crypto: aesni - fix "by8" variant for 128 bit keys

Vinson Lee <vlee@twitter.com>
    crypto: sha-mb - Add avx2_supported check.

Ard Biesheuvel <ard.biesheuvel@linaro.org>
    arm64/efi: add missing call to early_ioremap_reset()

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    arm64: kernel: fix __cpu_suspend mm switch on warm-boot

Laura Abbott <lauraa@codeaurora.org>
    arm64: Move cpu_resume into the text section

Hans de Goede <hdegoede@redhat.com>
    Input: alps - v7: fix finger counting for > 2 fingers on clickpads

Hans de Goede <hdegoede@redhat.com>
    Input: alps - v7: sometimes a single touch is reported in mt[1]

Hans de Goede <hdegoede@redhat.com>
    Input: alps - v7: ignore new packets

Linus Torvalds <torvalds@linux-foundation.org>
    Revert "Input: atmel_mxt_ts - use deep sleep mode when stopped"

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / PM: Fix PM initialization for devices that are not present

Aaron Lu <aaron.lu@intel.com>
    ACPI / video: Add some Samsung models to disable_native_backlight list

J. Bruce Fields <bfields@redhat.com>
    rpc: fix xdr_truncate_encode to handle buffer ending on page boundary

Pavel Machek <pavel@ucw.cz>
    Revert "ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo"

Nishanth Menon <nm@ti.com>
    ARM: OMAP4: PM: Only do static dependency configuration in omap4_init_static_deps

Tomasz Figa <tomasz.figa@gmail.com>
    ARM: dts: Enable PWM node by default for s3c64xx

Lokesh Vutla <lokeshvutla@ti.com>
    ARM: dts: DRA7: wdt: Fix compatible property for watchdog node

Viresh Kumar <viresh.kumar@linaro.org>
    ARM: defconfigs: use CONFIG_CPUFREQ_DT

Tomi Valkeinen <tomi.valkeinen@ti.com>
    ARM: dts: am437x-sk-evm.dts: fix LCD timings

Felipe Balbi <balbi@ti.com>
    ARM: dts: am437x-sk: fix lcd enable pin mux data

Andy Lutomirski <luto@amacapital.net>
    sched: Add missing rcu protection to wake_up_all_idle_cpus

Luca Abeni <luca.abeni@unitn.it>
    sched/deadline: Avoid double-accounting in case of missed deadlines

Luca Abeni <luca.abeni@unitn.it>
    sched/deadline: Fix migration of SCHED_DEADLINE tasks

Johannes Berg <johannes.berg@intel.com>
    scripts/kernel-doc: don't eat struct members with __aligned

Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
    nilfs2: fix the nilfs_iget() vs. nilfs_new_inode() races

Roger Quadros <rogerq@ti.com>
    mtd: nand: omap: Fix NAND enumeration on 3430 LDP

Alison Chaiken <alison_chaiken@mentor.com>
    MTD: m25p80: fix inconsistency in m25p_ids compared to spi_nor_ids

Brian Norris <computersforpeace@gmail.com>
    mtd: tests: abort torturetest on erase errors

Dan Carpenter <dan.carpenter@oracle.com>
    ceph: do_sync is never initialized

Aaron Lu <aaron.lu@intel.com>
    ACPI / video: update the skip case for acpi_video_device_in_dod()

Jeff Layton <jlayton@primarydata.com>
    nfsd: fix fi_delegees leak when fi_had_conflict returns true

Benjamin Coddington <bcodding@redhat.com>
    nfsd4: fix xdr4 count of server in fs_location4

Benjamin Coddington <bcodding@redhat.com>
    nfsd4: fix xdr4 inclusion of escaped char

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    fs: nfsd: Fix signedness bug in compare_blob

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages

Vitaly Kuznetsov <vkuznets@redhat.com>
    Drivers: hv: vmbus: Fix a race condition when unregistering a device

Christian Riesch <christian.riesch@omicron.at>
    n_tty: Fix read_buf race condition, increment read_head after pushing data

Jiri Slaby <jslaby@suse.cz>
    reiserfs: destroy allocated commit workqueue

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix kmap_prot definition

Robert Baldyga <r.baldyga@samsung.com>
    serial: samsung: wait for transfer completion before clock disable

Axel Lin <axel.lin@ingics.com>
    tty: serial: men_z135_uart: Add terminating entry for men_z135_ids

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing/sched: Check preempt_count() for current when reading task->state

Tejun Heo <tj@kernel.org>
    writeback: fix a subtle race condition in I_DIRTY clearing

Philipp Reisner <philipp.reisner@linbit.com>
    drbd: Fix state change in case of connection timeout

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: merge_bvec_fn: properly remap bvm->bi_bdev

Oliver Neukum <oneukum@suse.de>
    cdc-acm: memory leak in error case

Jens Axboe <axboe@fb.com>
    genhd: check for int overflow in disk_expand_part_tbl()

Steev Klimaszewski <threeway@gmail.com>
    Add USB_EHCI_EXYNOS to multi_v7_defconfig

Martin Hauke <mardnh@gmx.de>
    USB: qcserial: Add support for HP lt4112 LTE/HSPA+ Gobi 4G Modem

Ronald Wahl <ronald.wahl@raritan.com>
    usb: gadget: at91_udc: move prepare clk into process context

Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
    usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    USB: cdc-acm: check for valid interfaces

NeilBrown <neilb@suse.de>
    md/raid5: fetch_block must fetch all the blocks handle_stripe_dirtying wants.

Aaron Plattner <aplattner@nvidia.com>
    ALSA: hda - Add new GPU codec ID 0x10de0072 to snd-hda

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix wrong gpio_dir & gpio_mask hint setups for IDT/STAC codecs

Daniel Mack <daniel@zonque.org>
    ALSA: snd-usb-caiaq: fix stream count check

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: fireworks: fix an endianness bug for transaction length

Dan Carpenter <dan.carpenter@oracle.com>
    ALSA: hda - using uninitialized data

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - Add new Dell desktop for ALC3234 headset mode

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - New codec support for ALC256

Kailang Yang <kailang@realtek.com>
    ALSA: hda/realtek - New codec support for ALC298

Jiri Jaburek <jjaburek@redhat.com>
    ALSA: usb-audio: extend KEF X300A FU 10 tweak to Arcam rPAC

Doug Anderson <dianders@chromium.org>
    i2c: designware: Fix falling time bindings doc

Pali Rohár <pali.rohar@gmail.com>
    i8k: Add support for Dell Latitude E6440

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

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: Fix ipte locking

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: flush CPU on load control

Thomas Huth <thuth@linux.vnet.ibm.com>
    KVM: s390: Fix size of monitor-class number field

Paolo Bonzini <pbonzini@redhat.com>
    kvm: x86: mask out XSAVES

Nadav Amit <nadav.amit@gmail.com>
    KVM: x86: em_ret_far overrides cpl

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: support XSAVES usage in the host

Paolo Bonzini <pbonzini@redhat.com>
    x86: export get_xsave_addr

Giedrius Statkevičius <giedrius.statkevicius@gmail.com>
    HID: Add a new id 0x501a for Genius MousePen i608X

Karl Relton <karllinuxtest.relton@ntlworld.com>
    HID: add battery quirk for USB_DEVICE_ID_APPLE_ALU_WIRELESS_2011_ISO keyboard

Mika Westerberg <mika.westerberg@linux.intel.com>
    HID: i2c-hid: Do not free buffers in i2c_hid_stop()

Dan Carpenter <dan.carpenter@oracle.com>
    HID: roccat: potential out of bounds in pyra_sysfs_write_settings()

Gwendal Grignou <gwendal@chromium.org>
    HID: i2c-hid: prevent buffer overflow in early IRQ

Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
    HID: i2c-hid: fix race condition reading reports

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: wacom: fix freeze on open when autosuspend is on

Benjamin Tissoires <benjamin.tissoires@redhat.com>
    HID: wacom: re-add accidentally dropped Lenovo PID

Oliver Neukum <oneukum@suse.de>
    HID: yet another buggy ELAN touchscreen

Takashi Iwai <tiwai@suse.de>
    blk-mq: Fix uninitialized kobject at CPU hotplugging

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Fix a race between bt_clear_tag() and bt_get()

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Avoid that __bt_get_word() wraps multiple times

Bart Van Assche <bvanassche@acm.org>
    blk-mq: Fix a use-after-free

Jens Axboe <axboe@fb.com>
    blk-mq: use 'nr_cpu_ids' as highest CPU ID count for hwq <-> cpu map

Joerg Roedel <jroedel@suse.de>
    iommu/vt-d: Fix dmar_domain leak in iommu_attach_device

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

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: Fix ifidx for rx data by msgbuf.

Myron Stowe <myron.stowe@redhat.com>
    PCI: Restore detection of read-only BARs

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix accepting connections when not using mgmt

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Fix controller configuration with HCI_QUIRK_INVALID_BDADDR

Marcel Holtmann <marcel@holtmann.org>
    Bluetooth: Clear LE white list when resetting controller

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix check for direct advertising

Johan Hedberg <johan.hedberg@intel.com>
    Bluetooth: Fix LE connection timeout deadlock

Alexander Aring <alex.aring@gmail.com>
    Bluetooth: 6lowpan: fix skb_unshare behaviour

Dmitry Tunin <hanipouspilot@gmail.com>
    Bluetooth: ath3k: Add support of MCI 13d3:3408 bt device

Richard Guy Briggs <rgb@redhat.com>
    powerpc: add little endian flag to syscall_get_arch()

sukadev@linux.vnet.ibm.com <sukadev@linux.vnet.ibm.com>
    powerpc/perf/hv-24x7: Use per-cpu page buffer

Paul Mackerras <paulus@samba.org>
    powerpc/powernv: Switch off MMU before entering nap/sleep/rvwinkle mode

Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
    powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Anton Blanchard <anton@samba.org>
    powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ktest: Fix make_min_config to handle new assign_configs call

Andrew Jackson <Andrew.Jackson@arm.com>
    ASoC: dwc: Ensure FIFOs are flushed to prevent channel swap

Peter Rosin <peda@axentia.se>
    ASoC: pcm512x: Trigger auto-increment of register addresses on i2c

Jyri Sarha <jsarha@ti.com>
    ASoC: tlv320aic31xx: Fix off by one error in the loop stucture.

Jarkko Nikula <jarkko.nikula@linux.intel.com>
    ASoC: max98090: Fix ill-defined sidetone route

Lars-Peter Clausen <lars@metafoo.de>
    ASoC: sigmadsp: Refuse to load firmware files with a non-supported version

Takashi Iwai <tiwai@suse.de>
    ASoC: eukrea-tlv320: Fix of_node_put() call with uninitialized object

Felix Fietkau <nbd@openwrt.org>
    ath5k: fix hardware queue index assignment

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: add new device IDs for 3165

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: update values for Smart Fifo

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: fix flush support for old firmware

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

Johan Hovold <johan@kernel.org>
    rtc: omap: fix missing wakealarm attribute

Johan Hovold <johan@kernel.org>
    rtc: omap: fix clock-source configuration

Guo Zeng <guo.zeng@csr.com>
    drivers/rtc/rtc-sirfsoc.c: move hardware initilization earlier in probe


-------------

Diffstat:

 .../devicetree/bindings/i2c/i2c-designware.txt     |  4 +-
 Documentation/ramoops.txt                          | 13 ++-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/am437x-sk-evm.dts                | 15 ++--
 arch/arm/boot/dts/dra7.dtsi                        |  2 +-
 arch/arm/boot/dts/s3c6410-mini6410.dts             |  4 -
 arch/arm/boot/dts/s3c64xx.dtsi                     |  1 -
 arch/arm/configs/multi_v7_defconfig                |  3 +-
 arch/arm/configs/shmobile_defconfig                |  2 +-
 arch/arm/kernel/setup.c                            |  9 ++
 arch/arm/kernel/smp.c                              | 13 ++-
 arch/arm/mach-omap2/pm44xx.c                       | 29 ++-----
 arch/arm64/kernel/efi.c                            |  2 +-
 arch/arm64/kernel/setup.c                          |  1 +
 arch/arm64/kernel/sleep.S                          | 36 ++------
 arch/arm64/kernel/suspend.c                        | 18 +++-
 arch/powerpc/include/asm/reg.h                     |  2 +
 arch/powerpc/include/asm/syscall.h                 |  6 +-
 arch/powerpc/kernel/idle_power7.S                  | 18 +++-
 arch/powerpc/kernel/mce_power.c                    |  4 +-
 arch/powerpc/kernel/udbg_16550.c                   |  6 +-
 arch/powerpc/perf/hv-24x7.c                        | 21 ++---
 arch/s390/kvm/gaccess.c                            | 20 +++--
 arch/s390/kvm/interrupt.c                          |  2 +-
 arch/s390/kvm/priv.c                               |  4 +-
 arch/x86/crypto/Makefile                           |  2 +-
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S            | 46 +++++++---
 arch/x86/include/asm/vsyscall.h                    |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_uncore.c      | 22 ++++-
 arch/x86/kernel/cpu/perf_event_intel_uncore.h      |  2 +-
 .../x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 17 ++++
 arch/x86/kernel/xsave.c                            |  1 +
 arch/x86/kvm/cpuid.c                               | 11 ++-
 arch/x86/kvm/emulate.c                             |  2 +-
 arch/x86/kvm/mmu.c                                 |  2 +-
 arch/x86/kvm/x86.c                                 | 90 ++++++++++++++++++--
 arch/x86/vdso/vma.c                                | 45 ++++++----
 arch/xtensa/include/asm/highmem.h                  |  2 +-
 block/blk-core.c                                   |  3 +
 block/blk-mq-cpumap.c                              |  2 +-
 block/blk-mq-sysfs.c                               |  9 +-
 block/blk-mq-tag.c                                 | 17 ++--
 block/blk-sysfs.c                                  | 12 +--
 block/genhd.c                                      | 11 ++-
 drivers/acpi/device_pm.c                           |  2 +-
 drivers/acpi/scan.c                                | 13 +--
 drivers/acpi/video.c                               | 27 +++++-
 drivers/base/bus.c                                 |  8 +-
 drivers/block/drbd/drbd_req.c                      |  3 +-
 drivers/bluetooth/ath3k.c                          |  2 +
 drivers/bluetooth/btusb.c                          |  1 +
 drivers/char/i8k.c                                 |  8 ++
 drivers/gpu/drm/nouveau/core/core/event.c          |  4 +-
 drivers/gpu/drm/nouveau/core/core/notify.c         |  2 +-
 drivers/gpu/drm/nouveau/nouveau_ttm.c              |  3 +-
 drivers/hid/hid-core.c                             |  1 +
 drivers/hid/hid-ids.h                              |  2 +
 drivers/hid/hid-input.c                            |  3 +
 drivers/hid/hid-kye.c                              |  4 +
 drivers/hid/hid-roccat-pyra.c                      |  8 +-
 drivers/hid/i2c-hid/i2c-hid.c                      | 19 ++---
 drivers/hid/usbhid/hid-quirks.c                    |  2 +
 drivers/hid/wacom_sys.c                            |  9 +-
 drivers/hid/wacom_wac.c                            |  1 +
 drivers/hv/channel_mgmt.c                          | 11 ++-
 drivers/input/mouse/alps.c                         | 56 +++++++++---
 drivers/input/touchscreen/atmel_mxt_ts.c           | 99 ++++++----------------
 drivers/iommu/intel-iommu.c                        | 12 +--
 drivers/md/raid5.c                                 |  7 +-
 drivers/misc/genwqe/card_utils.c                   |  2 +
 drivers/mmc/host/sdhci.c                           |  8 +-
 drivers/mtd/devices/m25p80.c                       |  6 +-
 drivers/mtd/nand/omap2.c                           |  7 --
 drivers/mtd/tests/torturetest.c                    |  4 +-
 drivers/mtd/ubi/upd.c                              | 10 ++-
 drivers/mtd/ubi/wl.c                               | 10 +--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       | 17 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  3 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |  8 +-
 drivers/net/wireless/ath/ath9k/hw.h                |  4 +-
 drivers/net/wireless/ath/ath9k/mac.c               |  9 +-
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c   |  9 ++
 drivers/net/wireless/iwlwifi/dvm/commands.h        | 31 ++++---
 drivers/net/wireless/iwlwifi/dvm/lib.c             | 47 +++++-----
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |  2 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c            |  4 +
 drivers/pci/probe.c                                |  3 +
 drivers/regulator/s2mps11.c                        | 19 +++--
 drivers/rtc/rtc-isl12057.c                         |  4 +-
 drivers/rtc/rtc-omap.c                             | 11 ++-
 drivers/rtc/rtc-sirfsoc.c                          | 16 ++--
 drivers/spi/spi-sh-msiof.c                         |  5 ++
 drivers/tty/n_tty.c                                |  3 +-
 drivers/tty/serial/men_z135_uart.c                 |  1 +
 drivers/tty/serial/samsung.c                       |  4 +
 drivers/usb/class/cdc-acm.c                        | 10 ++-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/gadget/udc/at91_udc.c                  | 44 +++++++---
 drivers/usb/renesas_usbhs/mod_gadget.c             |  3 +
 drivers/usb/serial/qcserial.c                      | 33 ++++++++
 drivers/xen/swiotlb-xen.c                          | 10 +--
 fs/btrfs/delayed-inode.c                           |  8 ++
 fs/ceph/addr.c                                     |  2 +-
 fs/fs-writeback.c                                  | 29 +++++--
 fs/nfsd/nfs4state.c                                | 17 ++--
 fs/nfsd/nfs4xdr.c                                  |  5 +-
 fs/nilfs2/inode.c                                  | 32 +++++--
 fs/nilfs2/namei.c                                  | 15 +++-
 fs/ocfs2/aops.c                                    | 16 +++-
 fs/ocfs2/namei.c                                   | 43 ++++++++--
 fs/pstore/ram.c                                    | 13 ++-
 fs/pstore/ram_core.c                               | 31 +++++--
 fs/reiserfs/super.c                                |  3 +
 include/linux/mm.h                                 |  2 +-
 include/linux/pstore_ram.h                         |  4 +-
 include/linux/writeback.h                          |  1 -
 include/net/mac80211.h                             |  7 +-
 include/trace/events/sched.h                       |  2 +-
 include/uapi/linux/audit.h                         |  2 +
 include/uapi/linux/hyperv.h                        |  1 +
 kernel/events/core.c                               |  4 +-
 kernel/exit.c                                      | 12 ++-
 kernel/sched/core.c                                |  9 +-
 kernel/sched/deadline.c                            | 25 +-----
 mm/memory.c                                        | 31 ++++---
 mm/mmap.c                                          |  7 +-
 mm/page-writeback.c                                | 43 +++-------
 mm/vmscan.c                                        | 24 +++---
 net/bluetooth/6lowpan.c                            |  8 +-
 net/bluetooth/hci_conn.c                           |  4 +-
 net/bluetooth/hci_event.c                          | 18 +++-
 net/mac80211/key.c                                 | 12 ++-
 net/sunrpc/xdr.c                                   |  6 +-
 scripts/kernel-doc                                 |  2 +-
 sound/firewire/fireworks/fireworks_transaction.c   |  2 +-
 sound/pci/hda/hda_codec.c                          |  4 +-
 sound/pci/hda/patch_hdmi.c                         |  2 +
 sound/pci/hda/patch_realtek.c                      | 15 ++++
 sound/pci/hda/patch_sigmatel.c                     |  4 +-
 sound/soc/codecs/max98090.c                        |  4 +-
 sound/soc/codecs/pcm512x-i2c.c                     |  7 +-
 sound/soc/codecs/sigmadsp.c                        |  7 ++
 sound/soc/codecs/tlv320aic31xx.c                   | 13 +--
 sound/soc/dwc/designware_i2s.c                     | 14 +++
 sound/soc/fsl/eukrea-tlv320.c                      |  2 +-
 sound/usb/caiaq/audio.c                            |  2 +-
 sound/usb/mixer_maps.c                             | 15 +++-
 tools/perf/util/event.h                            |  1 +
 tools/perf/util/session.c                          | 11 ++-
 tools/testing/ktest/ktest.pl                       |  4 +-
 150 files changed, 1121 insertions(+), 618 deletions(-)


