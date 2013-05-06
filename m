Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3EFUp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:45:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab3EFUpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:45:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 000/115] 3.9.1-stable review
Date: Mon,  6 May 2013 13:43:56 -0700
Message-Id: <20130506203055.537199268@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE: I have NOT applied all of the submitted -stable patches to this
release, specifically I've skipped all of the drm patches for now.  This
release was big enough that I didn't want to double the size of it.  I
should be all caught up after a release or two, so if you have sent me
stable patches that are not in here, please be patient.

This is the start of the stable review cycle for the 3.9.1 release.
There are 115 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May  8 20:28:24 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.9.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.9.1-rc1

Lars-Peter Clausen <lars@metafoo.de>
    mfd: adp5520: Restore mode bits on resume

Al Viro <viro@zeniv.linux.org.uk>
    rcutrace: single_open() leaks

Terry Barnaby <terry@beam.ltd.uk>
    mmc: atmel-mci: pio hang on block errors

Philip Rakity <prakity@yahoo.com>
    mmc: core: Fix bit width test failing on old eMMC cards

Li Fei <fei.li@intel.com>
    x86: Eliminate irq_mis_count counted in arch_irq_stat

Gleb Natapov <gleb@redhat.com>
    KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions

David Howells <dhowells@redhat.com>
    Give the OID registry file module info to avoid kernel tainting

Johan Hovold <jhovold@gmail.com>
    mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Al Viro <viro@zeniv.linux.org.uk>
    do_mount(): fix a leak introduced in 3.9 ("mount: consolidate permission checks")

Theodore Ts'o <tytso@mit.edu>
    ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resizing for ext3-compat file systems

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: fix big-endian bug in metadata checksum calculations

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: unregister es_shrinker if mount failed

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: fix journal callback list traversal

Dmitry Monakhov <dmonakhov@openvz.org>
    jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback

Theodore Ts'o <tytso@mit.edu>
    ext4/jbd2: don't wait (forever) for stale tid caused by wraparound

H. Peter Anvin <hpa@linux.intel.com>
    x86-64, init: Do not set NX bits on non-NX capable hardware

Richard Cochran <richardcochran@gmail.com>
    e1000e: fix numeric overflow in phc settime method

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: fix EICR write in ixgbe_msix_other

Robin Holt <holt@sgi.com>
    ipc: sysv shared memory limited to 8TiB

Johannes Berg <johannes.berg@intel.com>
    wireless: regulatory: fix channel disabling race condition

Bryan Schumaker <bjschuma@netapp.com>
    nfsd: Decode and send 64bit time values

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    nfsd: use kmem_cache_free() instead of kfree()

fanchaoting <fanchaoting@cn.fujitsu.com>
    nfsd: don't run get_file if nfs4_preprocess_stateid_op return error

J. Bruce Fields <bfields@redhat.com>
    nfsd4: don't close read-write opens too soon

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_lock_delegation_recall

Shaohua Li <shli@kernel.org>
    MD: ignore discard request for hard disks of hybid raid1/raid10 array

NeilBrown <neilb@suse.de>
    md: bad block list should default to disabled.

Trond Myklebust <Trond.Myklebust@netapp.com>
    LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot

Oleg Nesterov <oleg@redhat.com>
    exec: do not abuse ->cred_guard_mutex in threadgroup_lock()

Greg Thelen <gthelen@google.com>
    fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Zhao Hongjiang <zhaohongjiang@huawei.com>
    inotify: invalid mask should return a error number but not set it

Robert Richter <robert.richter@calxeda.com>
    sata_highbank: Rename proc_name to the module name

Thomas Gleixner <tglx@linutronix.de>
    clockevents: Set dummy handler on CPU_DEAD shutdown

Steven Rostedt <rostedt@goodmis.org>
    localmodconfig: Process source kconfig files as they are found

Li Zefan <lizefan@huawei.com>
    cgroup: fix broken file xattrs

Li Zefan <lizefan@huawei.com>
    cgroup: fix an off-by-one bug which may trigger BUG_ON()

Zhang Rui <rui.zhang@intel.com>
    ACPI / thermal: do not always return THERMAL_TREND_RAISING for active trip points

Wang YanQing <udknight@gmail.com>
    ACPI: Fix wrong parameter passed to memblock_reserve

Aaron Lu <aaron.lu@intel.com>
    libata: acpi: make ata_ap_acpi_handle not block

Johan Hovold <jhovold@gmail.com>
    drivers/rtc/rtc-at91rm9200.c: fix missing iounmap

Derek Basehore <dbasehore@chromium.org>
    drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Mel Gorman <mgorman@suse.de>
    mm: swap: mark swap pages writeback before queueing for direct IO

Jerome Marchand <jmarchan@redhat.com>
    swap: redirty page if page write fails on swap file

Prarit Bhargava <prarit@redhat.com>
    hrtimer: Add expiry time overflow check in hrtimer_interrupt

David Engraf <david.engraf@sysgo.com>
    hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

Dylan Reid <dgreid@chromium.org>
    ASoC: max98088: Fix logging of hardware revision.

Catalin Marinas <catalin.marinas@arm.com>
    ARM: 7702/1: Set the page table freeing ceiling to TASK_SIZE

Kailang Yang <kailang@realtek.com>
    ALSA: hda - Add the support for ALC286 codec

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix aamix activation with loopback control on VIA codecs

Clemens Ladisch <clemens@ladisch.de>
    ALSA: USB: adjust for changed 3.8 USB API

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix autopm error during probing

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: disable autopm for MIDI devices

Calvin Owens <jcalvinowens@gmail.com>
    ALSA: usb: Add quirk for 192KHz recording on E-Mu devices

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

Takashi Iwai <tiwai@suse.de>
    ALSA: emu10k1: Fix dock firmware loading

Duncan Laurie <dlaurie@chromium.org>
    TPM: Retry SaveState command in suspend path

Hugh Dickins <hughd@google.com>
    mm: allow arch code to control the user page table ceiling

Anurup m <anurup.m@huawei.com>
    fs/fscache/stats.c: fix memory leak

Stephan Schreiber <info@fs-driver.org>
    Wrong asm register contraints in the kvm implementation

Stephan Schreiber <info@fs-driver.org>
    Wrong asm register contraints in the futex implementation

Alex A. Mihaylov <minimumlaw@rambler.ru>
    rt2x00: Fix transmit power troubles on some Ralink RT30xx cards

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Yinghai Lu <yinghai@kernel.org>
    PCI / ACPI: Don't query OSC support with all possible controls

Tony Luck <tony.luck@intel.com>
    Fix initialization of CMCI/CMCP interrupts

Ming Lei <ming.lei@canonical.com>
    sysfs: fix use after free in case of concurrent read/write and readdir

K. Y. Srinivasan <kys@microsoft.com>
    Drivers: hv: vmbus: Fix a bug in hv_need_to_signal()

Sandy Wu <sandyw@twitter.com>
    crypto: crc32-pclmul - Use gas macro for pclmulqdq

Steven A. Falco <sfalco@harris.com>
    i2c: xiic: must always write 16-bit words to TX_FIFO

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Reset ftrace_graph_filter_enabled if count is zero

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Check return value of tracing_init_dentry()

Namhyung Kim <namhyung.kim@lge.com>
    tracing: Fix off-by-one on allocating stat->pages

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Remove most or all of stack tracer stack size from stack_max_size

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Fix stack tracer with fentry use

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    tracing: Use stack of calling function for stack tracer

Mika Kuoppala <mika.kuoppala@linux.intel.com>
    fbcon: when font is freed, clear also vc_font.data

Linus Torvalds <torvalds@linux-foundation.org>
    tty: fix up atime/mtime mess, take three

Richard Cochran <richardcochran@gmail.com>
    gianfar: do not advertise any alarm capability.

Catalin Marinas <catalin.marinas@arm.com>
    arm: set the page table freeing ceiling to TASK_SIZE

Federico Vaga <federico.vaga@gmail.com>
    serial_core.c: add put_device() after device_find_child()

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/smp/spinlock: Fix leakage of the spinlock interrupt line for every CPU online/offline

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/smp: Fix leakage of timer interrupt line for every CPU online/offline.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/time: Fix kasprintf splat when allocating timer%d IRQ line.

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/memory hotplug: prevent offline of active memory increments

Tormod Volden <debian.tormod@gmail.com>
    usb-storage: CY7C68300A chips do not support Cypress ATACB

Shengzhou Liu <Shengzhou.Liu@freescale.com>
    usb: remove redundant tdi_reset

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: chipidea: udc: fix memory leak in _ep_nuke

Michael Grzeschik <m.grzeschik@pengutronix.de>
    usb: chipidea: udc: fix memory access of shared memory on armv5 machines

Hans de Goede <hdegoede@redhat.com>
    usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep

Johan Hovold <jhovold@gmail.com>
    USB: io_ti: fix TIOCGSERIAL

Adrian Thomasset <adrian.thomasset@st.com>
    USB: ftdi_sio: enable two UART ports on ST Microconnect Lite

Adrian Thomasset <adrian.thomasset@st.com>
    USB: ftdi_sio: correct ST Micro Connect Lite PIDs

Stefani Seibold <stefani@seibold.net>
    USB: add ftdi_sio USB ID for GDM Boost V1.x

Ben Jencks <ben@bjencks.net>
    usb/misc/appledisplay: Add 24" LED Cinema display

Bob Copeland <me@bobcopeland.com>
    mac80211: use synchronize_rcu() with rcu_barrier()

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix station entry leak/warning while suspending

Yogesh Ashok Powar <yogeshp@marvell.com>
    mwifiex: Call pci_release_region after calling pci_disable_device

Yogesh Ashok Powar <yogeshp@marvell.com>
    mwifiex: Use pci_release_region() instead of a pci_release_regions()

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: dvm: don't send zeroed LQ cmd

Stanislaw Gruszka <sgruszka@redhat.com>
    iwlwifi: fix freeing uninitialized pointer

Michael Ellerman <michael@ellerman.id.au>
    powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling <mikey@neuling.org>
    powerpc/power8: Fix secondary CPUs hanging on boot for HV=0

Michael Neuling <mikey@neuling.org>
    powerpc: Fix hardware IRQs with MMU on exceptions when HV=0

Michael Neuling <michael.neuling@au1.ibm.com>
    powerpc: Add isync to copy_and_flush

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91/trivial: typos in compatible property

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91/trivial: fix model name for SAM9G15-EK

Maxime Ripard <maxime.ripard@free-electrons.com>
    ARM: at91: Fix typo in restart code panic message

Nicolas Ferre <nicolas.ferre@atmel.com>
    ARM: at91: remove partial parameter in bootargs for at91sam9x5ek.dtsi

Douglas Gilbert <dgilbert@interlog.com>
    ARM: at91/at91sam9260.dtsi: fix u(s)art pinctrl encoding

Linus Walleij <linus.walleij@linaro.org>
    ARM: u300: fix ages old copy/paste bug

Daniel Lezcano <daniel.lezcano@linaro.org>
    ARM: omap3: cpuidle: enable time keeping

Joerg Roedel <joro@8bytes.org>
    staging: zsmalloc: Fix link error on ARM

Bjørn Mork <bjorn@mork.no>
    USB: option: add a D-Link DWM-156 variant

Filippo Turato <nnj7585@gmail.com>
    USB: serial: option: Added support Olivetti Olicard 145


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/arm/boot/dts/at91sam9260.dtsi            | 16 +++---
 arch/arm/boot/dts/at91sam9g15.dtsi            |  2 +-
 arch/arm/boot/dts/at91sam9g15ek.dts           |  2 +-
 arch/arm/boot/dts/at91sam9g25.dtsi            |  2 +-
 arch/arm/boot/dts/at91sam9g35.dtsi            |  2 +-
 arch/arm/boot/dts/at91sam9x25.dtsi            |  2 +-
 arch/arm/boot/dts/at91sam9x35.dtsi            |  2 +-
 arch/arm/boot/dts/at91sam9x5ek.dtsi           |  2 +-
 arch/arm/configs/at91sam9g45_defconfig        |  1 -
 arch/arm/include/asm/pgtable.h                | 18 +++++++
 arch/arm/mach-at91/setup.c                    |  2 +-
 arch/arm/mach-omap2/cpuidle34xx.c             |  5 +-
 arch/arm/mach-u300/include/mach/u300-regs.h   |  2 +-
 arch/avr32/configs/favr-32_defconfig          |  1 -
 arch/avr32/configs/merisc_defconfig           |  1 -
 arch/ia64/include/asm/futex.h                 |  5 +-
 arch/ia64/include/asm/mca.h                   |  1 +
 arch/ia64/kernel/irq.c                        |  8 +++
 arch/ia64/kernel/mca.c                        | 37 ++++++++-----
 arch/ia64/kvm/vtlb.c                          |  2 +-
 arch/powerpc/kernel/cpu_setup_power.S         |  1 +
 arch/powerpc/kernel/exceptions-64s.S          |  2 +-
 arch/powerpc/kernel/head_64.S                 |  1 +
 arch/powerpc/platforms/cell/spufs/inode.c     |  1 +
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S     |  5 +-
 arch/x86/kernel/head64.c                      |  3 +-
 arch/x86/kernel/head_64.S                     |  1 +
 arch/x86/kernel/irq.c                         |  4 --
 arch/x86/kvm/emulate.c                        |  4 ++
 arch/x86/xen/enlighten.c                      |  5 +-
 arch/x86/xen/smp.c                            |  2 +
 arch/x86/xen/time.c                           |  6 ++-
 drivers/acpi/osl.c                            |  2 +-
 drivers/acpi/pci_root.c                       |  4 +-
 drivers/acpi/thermal.c                        | 16 ++++--
 drivers/ata/libata-acpi.c                     | 45 +++++++++-------
 drivers/ata/sata_highbank.c                   |  2 +-
 drivers/char/tpm/tpm.c                        | 31 +++++++++--
 drivers/char/tpm/tpm.h                        |  3 ++
 drivers/hv/ring_buffer.c                      |  1 +
 drivers/i2c/busses/i2c-xiic.c                 |  6 +--
 drivers/md/md.c                               |  9 ++--
 drivers/md/raid1.c                            |  7 ++-
 drivers/md/raid10.c                           |  7 ++-
 drivers/mfd/adp5520.c                         |  8 ++-
 drivers/mmc/core/mmc.c                        |  2 +-
 drivers/mmc/host/Kconfig                      | 10 ----
 drivers/mmc/host/atmel-mci.c                  | 16 +++---
 drivers/net/ethernet/freescale/gianfar_ptp.c  |  3 +-
 drivers/net/ethernet/intel/e1000e/ptp.c       |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++
 drivers/net/wireless/iwlwifi/dvm/debugfs.c    | 16 +++---
 drivers/net/wireless/iwlwifi/dvm/sta.c        |  5 +-
 drivers/net/wireless/mwifiex/pcie.c           |  4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c       |  8 ++-
 drivers/pci/pci.c                             | 12 ++---
 drivers/rtc/rtc-at91rm9200.c                  | 14 +++--
 drivers/rtc/rtc-cmos.c                        |  4 +-
 drivers/s390/char/sclp_cmd.c                  |  4 +-
 drivers/staging/zsmalloc/Kconfig              |  2 +-
 drivers/staging/zsmalloc/zsmalloc-main.c      |  5 +-
 drivers/tty/pty.c                             |  3 ++
 drivers/tty/serial/serial_core.c              |  4 ++
 drivers/tty/tty_io.c                          |  4 +-
 drivers/usb/chipidea/udc.c                    |  8 +++
 drivers/usb/chipidea/udc.h                    |  4 +-
 drivers/usb/core/devio.c                      |  2 +
 drivers/usb/host/ehci-hcd.c                   |  3 --
 drivers/usb/misc/appledisplay.c               |  1 +
 drivers/usb/serial/ftdi_sio.c                 | 23 +++++---
 drivers/usb/serial/ftdi_sio_ids.h             |  4 +-
 drivers/usb/serial/io_ti.c                    |  2 +-
 drivers/usb/serial/option.c                   |  8 +++
 drivers/usb/storage/cypress_atacb.c           | 16 +++++-
 drivers/video/console/fbcon.c                 |  2 +
 fs/dcache.c                                   |  4 +-
 fs/exec.c                                     |  7 ++-
 fs/ext4/Kconfig                               |  3 +-
 fs/ext4/ext4_jbd2.h                           |  6 ++-
 fs/ext4/fsync.c                               |  3 +-
 fs/ext4/inode.c                               | 11 ++--
 fs/ext4/mballoc.c                             |  8 +--
 fs/ext4/mmp.c                                 |  2 +-
 fs/ext4/resize.c                              |  2 +
 fs/ext4/super.c                               | 14 +++--
 fs/fscache/stats.c                            |  2 +-
 fs/jbd2/commit.c                              | 50 ++++++++++--------
 fs/jbd2/journal.c                             | 31 +++++++++++
 fs/lockd/clntlock.c                           |  3 ++
 fs/lockd/clntproc.c                           |  3 --
 fs/namespace.c                                |  5 +-
 fs/nfs/nfs4proc.c                             | 12 +++++
 fs/nfsd/nfs4proc.c                            |  8 +--
 fs/nfsd/nfs4state.c                           | 10 +---
 fs/nfsd/nfs4xdr.c                             | 19 ++-----
 fs/notify/inotify/inotify_user.c              |  6 ++-
 fs/sysfs/dir.c                                | 15 ++++--
 include/asm-generic/pgtable.h                 | 10 ++++
 include/linux/cgroup.h                        |  3 --
 include/linux/ipc_namespace.h                 |  2 +-
 include/linux/jbd2.h                          |  2 +
 include/linux/sched.h                         | 18 ++-----
 include/sound/emu10k1.h                       |  1 +
 ipc/shm.c                                     |  2 +-
 kernel/cgroup.c                               | 13 ++---
 kernel/hrtimer.c                              |  6 +++
 kernel/rcutree_trace.c                        |  8 +--
 kernel/time/tick-broadcast.c                  |  4 ++
 kernel/time/tick-common.c                     |  1 +
 kernel/trace/ftrace.c                         |  5 +-
 kernel/trace/trace.c                          |  2 +
 kernel/trace/trace_stack.c                    | 76 ++++++++++++++++++++++++---
 kernel/trace/trace_stat.c                     |  2 +
 lib/oid_registry.c                            |  5 ++
 mm/mmap.c                                     |  4 +-
 mm/page_io.c                                  | 17 ++++++
 net/mac80211/cfg.c                            |  1 +
 net/mac80211/iface.c                          |  5 +-
 net/mac80211/pm.c                             |  3 +-
 net/wireless/reg.c                            |  2 +-
 scripts/kconfig/streamline_config.pl          | 17 +++---
 sound/pci/emu10k1/emu10k1_main.c              | 39 +++++++++++---
 sound/pci/hda/hda_generic.c                   | 22 +++++---
 sound/pci/hda/patch_realtek.c                 |  6 +++
 sound/soc/codecs/max98088.c                   |  2 +-
 sound/usb/6fire/pcm.c                         |  1 -
 sound/usb/caiaq/audio.c                       |  3 --
 sound/usb/card.c                              |  4 +-
 sound/usb/card.h                              |  1 +
 sound/usb/endpoint.c                          |  5 +-
 sound/usb/midi.c                              | 13 +----
 sound/usb/misc/ua101.c                        |  3 +-
 sound/usb/pcm.c                               |  2 +-
 sound/usb/quirks.c                            |  1 +
 sound/usb/stream.c                            |  9 ++++
 sound/usb/usx2y/usb_stream.c                  |  1 -
 sound/usb/usx2y/usbusx2yaudio.c               |  1 -
 sound/usb/usx2y/usx2yhwdeppcm.c               |  1 -
 139 files changed, 700 insertions(+), 342 deletions(-)


