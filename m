Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab3IYAPz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:15:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38838 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3IYAPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:15:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/110] 3.10.13-stable review
Date: Tue, 24 Sep 2013 17:13:58 -0700
Message-Id: <20130925001323.387158698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.10.13 release.
There are 110 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Sep 27 00:12:23 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.13-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.10.13-rc1

Miklos Szeredi <mszeredi@suse.cz>
    fuse: readdir: check for slash in names

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: hotfix truncate_pagecache() issue

Anand Avati <avati@redhat.com>
    fuse: invalidate inode attributes on xattr modification

Maxim Patlasov <MPatlasov@parallels.com>
    fuse: postpone end_page_writeback() in fuse_writepage_locked()

Mark Brown <broonie@linaro.org>
    clk: wm831x: Initialise wm831x pointer on init

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: fix NAND_BUSWIDTH_AUTO for x16 devices

Grant Likely <grant.likely@linaro.org>
    of: Fix missing memory initialization on FDT unflattening

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
    mmc: tmio_mmc_dma: fix PIO fallback on SDHI

Josh Durgin <josh.durgin@inktank.com>
    rbd: fix I/O error propagation for reads

majianpeng <majianpeng@gmail.com>
    ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.

Sage Weil <sage@inktank.com>
    libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc

majianpeng <majianpeng@gmail.com>
    libceph: unregister request in __map_request failed and nofail == false

Richard Weinberger <richard@nod.at>
    um: Implement probe_kernel_read()

Alex Deucher <alexander.deucher@amd.com>
    drm/edid: add quirk for Medion MD30217PG

Borislav Petkov <bp@suse.de>
    amd64_edac: Fix single-channel setups

Jan Kara <jack@suse.cz>
    isofs: Refuse RW mount of the filesystem instead of making it RO

Eric W. Biederman <ebiederm@xmission.com>
    proc: Restrict mounting the proc filesystem

Libin <huawei.libin@huawei.com>
    mm/huge_memory.c: fix potential NULL pointer dereference

Greg Thelen <gthelen@google.com>
    memcg: fix multiple large threshold notifications

Jie Liu <jeff.liu@oracle.com>
    ocfs2: fix the end cluster offset of FIEMAP

Oleg Nesterov <oleg@redhat.com>
    pidns: fix vfork() after unshare(CLONE_NEWPID)

Eric W. Biederman <ebiederm@xmission.com>
    pidns: Fix hang in zap_pid_ns_processes by sending a potentially extra wakeup

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Fix leaks in pagetable freeing

Gera Kazakov <gkazakov@msn.com>
    target: Fix >= v3.9+ regression in PR APTPL + ALUA metadata write-out

Felix Fietkau <nbd@openwrt.org>
    MIPS: ath79: Fix ar933x watchdog clock

Mark Brown <broonie@linaro.org>
    leds: wm831x-status: Request a REG resource

Oleg Nesterov <oleg@redhat.com>
    uprobes: Fix utask->depth accounting in handle_trampoline()

Stefan Behrens <sbehrens@giantdisaster.de>
    Btrfs: don't allow the replace procedure on read only filesystems

Bjørn Mork <bjorn@mork.no>
    media: siano: fix divide error on 0 counters

Mauro Carvalho Chehab <m.chehab@samsung.com>
    media: mb86a20s: Fix TS parallel mode

Alexander Shiyan <shc_work@mail.ru>
    media: media: coda: Fix DT driver data pointer for i.MX27

Andrzej Hajda <a.hajda@samsung.com>
    media: v4l2: added missing mutex.h include to v4l2-ctrls.h

Alexey Khoroshilov <khoroshilov@ispras.ru>
    media: hdpvr: fix iteration over uninitialized lists in hdpvr_probe()

Andrzej Hajda <a.hajda@samsung.com>
    media: DocBook: upgrade media_api DocBook version to 4.2

Sachin Kamat <sachin.kamat@linaro.org>
    media: s5p-g2d: Fix registration failure

Sylwester Nawrocki <s.nawrocki@samsung.com>
    media: exynos4-is: Fix entity unregistration on error path

Arun Kumar K <arun.kk@samsung.com>
    media: exynos-gsc: Register v4l2 device

Vasily Titskiy <qehgt0@gmail.com>
    HID: usbhid: quirk for N-Trig DuoSense Touch Screen

Kees Cook <keescook@chromium.org>
    HID: check for NULL field when setting values

Manoj Chourasia <mchourasia@nvidia.com>
    HID: hidraw: correctly deallocate memory on device disconnect

Jiri Kosina <jkosina@suse.cz>
    HID: battery: don't do DMA from stack

Bruno Prémont <bonbons@linux-vserver.org>
    HID: picolcd: Prevent NULL pointer dereference on _remove()

Kees Cook <keescook@chromium.org>
    HID: ntrig: validate feature report details

Kees Cook <keescook@chromium.org>
    HID: picolcd_core: validate output report details

Kees Cook <keescook@chromium.org>
    HID: validate HID report id size

Kees Cook <keescook@chromium.org>
    HID: sensor-hub: validate feature report details

Stefan Kriwanek <dev@stefankriwanek.de>
    HID: Fix Speedlink VAD Cezanne support for some devices

Kees Cook <keescook@chromium.org>
    HID: pantherlord: validate output report details

Henrik Rydberg <rydberg@euromail.se>
    HID: Correct the USB IDs for the new Macbook Air 6

Felix Fietkau <nbd@openwrt.org>
    ath9k: avoid accessing MRC registers on single-chain devices

Felix Fietkau <nbd@openwrt.org>
    ath9k: fix rx descriptor related race condition

Felix Fietkau <nbd@openwrt.org>
    ath9k: always clear ps filter bit on new assoc

John W. Linville <linville@tuxdriver.com>
    brcmsmac: Fix WARNING caused by lack of calls to dma_mapping_error()

Jan Kara <jack@suse.cz>
    ext4: simplify truncation code in ext4_setattr()

Boris BREZILLON <b.brezillon@overkiz.com>
    pinctrl: at91: fix get_pullup/down function return

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add Toshiba Satellite C870 to MSI blacklist

Anssi Hannula <anssi.hannula@iki.fi>
    ALSA: hda - hdmi: Fallback to ALSA allocation when selecting CA

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Re-setup HDMI pin and audio infoframe on stream switches

Rik van Riel <riel@redhat.com>
    sched/x86: Optimize switch_mm() for multi-threaded workloads

Tony Luck <tony.luck@intel.com>
    x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors

Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
    x86, amd_nb: Clarify F15h, model 30h GART and L3 support

Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
    pci_ids: Add PCI device ID functions 3 and 4 for newer F15h models.

Al Viro <viro@ZenIV.linux.org.uk>
    Introduce [compat_]save_altstack_ex() to unbreak x86 SMAP

H. Peter Anvin <hpa@linux.intel.com>
    x86, smap: Handle csum_partial_copy_*_user()

Steffen Trumtrar <s.trumtrar@pengutronix.de>
    ASoC: mc13783: add spi errata fix

Mike Dyer <mike.dyer@md-soft.co.uk>
    ASoC: wm8960: Fix PLL register writes

Tejun Heo <tj@kernel.org>
    rculist: list_first_or_null_rcu() should use list_entry_rcu()

Lan Tianyu <tianyu.lan@intel.com>
    usb: don't check pm qos NO_POWER_OFF flag in usb_port_suspend()

Alan Stern <stern@rowland.harvard.edu>
    USB: handle LPM errors during device suspend correctly

Hans de Goede <hdegoede@redhat.com>
    usb: config->desc.bLength may not exceed amount of data returned by the device

Alan Stern <stern@rowland.harvard.edu>
    USB: fix build error when CONFIG_PM_SLEEP isn't enabled

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    usb: Don't fail port power resume on device disconnect.

Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    usb: gadget: uvc: Fix error handling in uvc_queue_buffer()

Oliver Neukum <oneukum@suse.de>
    USB: cdc-wdm: fix race between interrupt handler and tasklet

Daniel Mack <zonque@gmail.com>
    usb: ehci-mxc: check for pdata before dereferencing

Johan Hovold <jhovold@gmail.com>
    USB: mos7720: fix big-endian control requests

Dan Carpenter <dan.carpenter@oracle.com>
    USB: mos7720: use GFP_ATOMIC under spinlock

Mika Westerberg <mika.westerberg@linux.intel.com>
    ACPI / LPSS: don't crash if a device has no MMIO resources

Marek Vasut <marex@denx.de>
    iio: mxs-lradc: Remove useless check in read_raw

Marek Vasut <marex@denx.de>
    iio: mxs-lradc: Fix misuse of iio->trig

Dan Carpenter <dan.carpenter@oracle.com>
    staging: comedi: dt282x: dt282x_ai_insn_read() always fails

Andy Lutomirski <luto@amacapital.net>
    net: Check the correct namespace when spoofing pid over SCM_RIGHTS

Alan Stern <stern@rowland.harvard.edu>
    USB: OHCI: Allow runtime PM without system sleep

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix missing lease break

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix a memory leak when a lease break comes

Jeff Layton <jlayton@redhat.com>
    cifs: ensure that srv_mutex is held when dealing with ssocket pointer

Oleg Nesterov <oleg@redhat.com>
    tty: disassociate_ctty() sends the extra SIGCONT

Felipe Balbi <balbi@ti.com>
    usb: dwc3: gadget: don't request IRQs in atomic

Shawn Nematbakhsh <shawnn@chromium.org>
    usb: xhci: Disable runtime PM suspend for quirky controllers

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci-plat: Don't enable legacy PCI interrupts.

Paul Mackerras <paulus@samba.org>
    KVM: PPC: Book3S: Fix compile error in XICS emulation

Peter Maydell <peter.maydell@linaro.org>
    ARM: PCI: versatile: Fix SMAP register offsets

Peter Maydell <peter.maydell@linaro.org>
    ARM: PCI: versatile: Fix PCI I/O

Peter Maydell <peter.maydell@linaro.org>
    ARM: PCI: versatile: Fix map_irq function to match hardware

Will Deacon <will.deacon@arm.com>
    arm64: perf: fix ARMv8 EVTYPE_MASK to include NSH bit

Will Deacon <will.deacon@arm.com>
    arm64: perf: fix group validation when using enable_on_exec

Christoffer Dall <christoffer.dall@linaro.org>
    ARM: KVM: Fix 64-bit coprocessor handling

Arnd Bergmann <arnd@arndb.de>
    ARM: dts: add missing cpu #address-cell values

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ARM: dts: sunxi: cpus/cpu nodes dts updates

Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
    ARM: dts: at91: cpus/cpu node dts updates

Colin Cross <ccross@android.com>
    cpuidle: coupled: fix race condition between pokes and safe state

Colin Cross <ccross@android.com>
    cpuidle: coupled: abort idle if pokes are pending

Rob Herring <rob.herring@calxeda.com>
    ARM: xen: only set pm function ptrs for Xen guests

Roger Pau Monne <roger.pau@citrix.com>
    xen-gnt: prevent adding duplicate gnt callbacks

Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    powerpc: Default arch idle could cede processor on pseries

Anton Blanchard <anton@samba.org>
    powerpc: Handle unaligned ldbrx/stdbrx

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: api - Fix race condition in larval lookup

Alan Stern <stern@rowland.harvard.edu>
    SCSI: sd: Fix potential out-of-bounds access

Richard Weinberger <richard@nod.at>
    UBI: Fix PEB leak in wear_leveling_worker()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    SCSI: Allow MPT Fusion SAS 3.0 driver to be built into the kernel


-------------

Diffstat:

 Documentation/DocBook/media_api.tmpl            |   4 +-
 Makefile                                        |   4 +-
 arch/arm/boot/dts/at91rm9200.dtsi               |   6 +-
 arch/arm/boot/dts/at91sam9260.dtsi              |   8 +-
 arch/arm/boot/dts/at91sam9263.dtsi              |   8 +-
 arch/arm/boot/dts/at91sam9g45.dtsi              |   8 +-
 arch/arm/boot/dts/at91sam9n12.dtsi              |   8 +-
 arch/arm/boot/dts/at91sam9x5.dtsi               |   8 +-
 arch/arm/boot/dts/sama5d3.dtsi                  |   4 +
 arch/arm/boot/dts/sun4i-a10.dtsi                |   4 +
 arch/arm/boot/dts/sun5i-a13.dtsi                |   4 +
 arch/arm/kvm/coproc.c                           |  26 +++--
 arch/arm/kvm/coproc.h                           |   3 +
 arch/arm/kvm/coproc_a15.c                       |   6 +-
 arch/arm/mach-versatile/include/mach/platform.h |   2 +
 arch/arm/mach-versatile/pci.c                   |  47 +++++---
 arch/arm/xen/enlighten.c                        |   5 +-
 arch/arm64/kernel/perf_event.c                  |   7 +-
 arch/mips/ath79/clock.c                         |   2 +-
 arch/powerpc/kernel/align.c                     |  10 ++
 arch/powerpc/kvm/book3s_xics.c                  |   1 +
 arch/powerpc/platforms/pseries/setup.c          |  31 +++--
 arch/um/include/shared/os.h                     |   1 +
 arch/um/kernel/Makefile                         |   2 +-
 arch/um/kernel/maccess.c                        |  24 ++++
 arch/um/os-Linux/process.c                      |  52 +++++++++
 arch/x86/ia32/ia32_signal.c                     |   2 +-
 arch/x86/include/asm/checksum_32.h              |  22 +++-
 arch/x86/include/asm/mce.h                      |  13 ++-
 arch/x86/include/asm/mmu_context.h              |  20 ++--
 arch/x86/kernel/amd_nb.c                        |  13 ++-
 arch/x86/kernel/signal.c                        |   6 +-
 arch/x86/lib/csum-wrappers_64.c                 |  12 +-
 crypto/api.c                                    |   7 +-
 drivers/acpi/acpi_lpss.c                        |   3 +-
 drivers/block/rbd.c                             |  14 +--
 drivers/clk/clk-wm831x.c                        |   2 +
 drivers/cpuidle/coupled.c                       | 127 +++++++++++++++-----
 drivers/edac/amd64_edac.c                       |   9 +-
 drivers/gpu/drm/drm_edid.c                      |   3 +
 drivers/hid/hid-core.c                          |  17 ++-
 drivers/hid/hid-ids.h                           |   7 +-
 drivers/hid/hid-input.c                         |  12 +-
 drivers/hid/hid-ntrig.c                         |   3 +-
 drivers/hid/hid-picolcd_cir.c                   |   3 +-
 drivers/hid/hid-picolcd_core.c                  |   2 +-
 drivers/hid/hid-picolcd_fb.c                    |   6 +-
 drivers/hid/hid-pl.c                            |  10 +-
 drivers/hid/hid-sensor-hub.c                    |   3 +-
 drivers/hid/hid-speedlink.c                     |  11 +-
 drivers/hid/hidraw.c                            |  60 ++++------
 drivers/hid/usbhid/hid-quirks.c                 |   2 +
 drivers/input/mouse/bcm5974.c                   |   6 +-
 drivers/iommu/intel-iommu.c                     |  72 ++++++------
 drivers/leds/leds-wm831x-status.c               |   4 +-
 drivers/media/common/siano/smsdvb-main.c        |   3 +-
 drivers/media/dvb-frontends/mb86a20s.c          |  16 ++-
 drivers/media/platform/coda.c                   |   2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c    |   9 +-
 drivers/media/platform/exynos-gsc/gsc-core.h    |   1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c     |   1 +
 drivers/media/platform/exynos4-is/media-dev.c   |   2 +-
 drivers/media/platform/s5p-g2d/g2d.c            |   1 +
 drivers/media/usb/hdpvr/hdpvr-core.c            |  11 +-
 drivers/mmc/host/tmio_mmc_dma.c                 |   4 +-
 drivers/mtd/nand/nand_base.c                    |   8 +-
 drivers/mtd/ubi/wl.c                            |   3 +
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |   4 +
 drivers/net/wireless/ath/ath9k/ath9k.h          |   5 +-
 drivers/net/wireless/ath/ath9k/recv.c           |  17 ++-
 drivers/net/wireless/ath/ath9k/xmit.c           |   1 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c   |  15 ++-
 drivers/of/base.c                               |   1 +
 drivers/pinctrl/pinctrl-at91.c                  |   4 +-
 drivers/scsi/mpt3sas/Makefile                   |   2 +-
 drivers/scsi/sd.c                               |  11 +-
 drivers/staging/comedi/drivers/dt282x.c         |   3 +-
 drivers/staging/iio/adc/mxs-lradc.c             |  18 ++-
 drivers/target/target_core_alua.c               |   2 +-
 drivers/target/target_core_pr.c                 |   2 +-
 drivers/tty/tty_io.c                            |   3 +-
 drivers/usb/class/cdc-wdm.c                     |  13 ++-
 drivers/usb/core/config.c                       |   3 +-
 drivers/usb/core/hub.c                          |  65 +++++------
 drivers/usb/core/port.c                         |  13 +--
 drivers/usb/dwc3/gadget.c                       |  39 ++++---
 drivers/usb/gadget/uvc_queue.c                  |   6 +-
 drivers/usb/host/ehci-mxc.c                     |   2 +-
 drivers/usb/host/ohci-pci.c                     |   2 +-
 drivers/usb/host/xhci-plat.c                    |   2 +-
 drivers/usb/host/xhci.c                         |  29 ++++-
 drivers/usb/host/xhci.h                         |   1 +
 drivers/usb/serial/mos7720.c                    |   6 +-
 drivers/xen/grant-table.c                       |  13 ++-
 fs/btrfs/ioctl.c                                |   3 +
 fs/ceph/ioctl.c                                 |   4 +-
 fs/cifs/connect.c                               |   2 +
 fs/cifs/smb2misc.c                              | 148 +++++++++++++-----------
 fs/ext4/inode.c                                 | 109 ++++++++---------
 fs/fuse/dir.c                                   |  15 ++-
 fs/fuse/file.c                                  |  11 +-
 fs/fuse/fuse_i.h                                |   2 +
 fs/fuse/inode.c                                 |   3 +-
 fs/isofs/inode.c                                |  16 +--
 fs/ocfs2/extent_map.c                           |   1 -
 fs/proc/root.c                                  |   3 +-
 include/linux/compat.h                          |   7 ++
 include/linux/hid.h                             |   4 +-
 include/linux/pci_ids.h                         |   2 +
 include/linux/rculist.h                         |   5 +-
 include/linux/signal.h                          |   8 ++
 include/linux/usb/hcd.h                         |   2 +-
 include/media/v4l2-ctrls.h                      |   1 +
 kernel/events/uprobes.c                         |   4 +-
 kernel/fork.c                                   |   7 +-
 kernel/pid.c                                    |   1 +
 mm/huge_memory.c                                |   2 +
 mm/memcontrol.c                                 |   8 +-
 net/ceph/osd_client.c                           |   2 +
 net/ceph/osdmap.c                               |   2 +-
 net/core/scm.c                                  |   2 +-
 sound/pci/hda/hda_intel.c                       |   1 +
 sound/pci/hda/patch_hdmi.c                      |  52 +++++++--
 sound/soc/codecs/mc13783.c                      |   4 +
 sound/soc/codecs/wm8960.c                       |   6 +-
 125 files changed, 1014 insertions(+), 522 deletions(-)


