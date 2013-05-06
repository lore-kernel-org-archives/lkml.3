Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054Ab3EGAIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:08:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3EFW4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:56:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 00/63] 3.4.44-stable review
Date: Mon,  6 May 2013 15:55:38 -0700
Message-Id: <20130506225314.802167948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.44 release.
There are 63 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed May  8 22:50:12 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.44-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.44-rc1

Lars-Peter Clausen <lars@metafoo.de>
    mfd: adp5520: Restore mode bits on resume

Terry Barnaby <terry@beam.ltd.uk>
    mmc: atmel-mci: pio hang on block errors

Philip Rakity <prakity@yahoo.com>
    mmc: core: Fix bit width test failing on old eMMC cards

Li Fei <fei.li@intel.com>
    x86: Eliminate irq_mis_count counted in arch_irq_stat

Gleb Natapov <gleb@redhat.com>
    KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions

Johan Hovold <jhovold@gmail.com>
    mmc: at91/avr32/atmel-mci: fix DMA-channel leak on module unload

Theodore Ts'o <tytso@mit.edu>
    ext4: fix Kconfig documentation for CONFIG_EXT4_DEBUG

Theodore Ts'o <tytso@mit.edu>
    ext4: fix online resizing for ext3-compat file systems

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: fix journal callback list traversal

Dmitry Monakhov <dmonakhov@openvz.org>
    jbd2: fix race between jbd2_journal_remove_checkpoint and ->j_commit_callback

Jacob Keller <jacob.e.keller@intel.com>
    ixgbe: fix EICR write in ixgbe_msix_other

Robin Holt <holt@sgi.com>
    ipc: sysv shared memory limited to 8TiB

Johannes Berg <johannes.berg@intel.com>
    wireless: regulatory: fix channel disabling race condition

Bryan Schumaker <bjschuma@netapp.com>
    nfsd: Decode and send 64bit time values

J. Bruce Fields <bfields@redhat.com>
    nfsd4: don't close read-write opens too soon

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFSv4: Handle NFS4ERR_DELAY and NFS4ERR_GRACE in nfs4_open_delegation_recall

NeilBrown <neilb@suse.de>
    md: bad block list should default to disabled.

Trond Myklebust <Trond.Myklebust@netapp.com>
    LOCKD: Ensure that nlmclnt_block resets block->b_status after a server reboot

Greg Thelen <gthelen@google.com>
    fs/dcache.c: add cond_resched() to shrink_dcache_parent()

Thomas Gleixner <tglx@linutronix.de>
    clockevents: Set dummy handler on CPU_DEAD shutdown

Li Zefan <lizefan@huawei.com>
    cgroup: fix an off-by-one bug which may trigger BUG_ON()

Derek Basehore <dbasehore@chromium.org>
    drivers/rtc/rtc-cmos.c: don't disable hpet emulation on suspend

Prarit Bhargava <prarit@redhat.com>
    hrtimer: Add expiry time overflow check in hrtimer_interrupt

David Engraf <david.engraf@sysgo.com>
    hrtimer: Fix ktime_add_ns() overflow on 32bit architectures

Dylan Reid <dgreid@chromium.org>
    ASoC: max98088: Fix logging of hardware revision.

Catalin Marinas <catalin.marinas@arm.com>
    ARM: 7702/1: Set the page table freeing ceiling to TASK_SIZE

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix autopm error during probing

Clemens Ladisch <clemens@ladisch.de>
    ALSA: usb-audio: disable autopm for MIDI devices

Daniel Mack <zonque@gmail.com>
    ALSA: snd-usb: try harder to find USB_DT_CS_ENDPOINT

Hugh Dickins <hughd@google.com>
    mm: allow arch code to control the user page table ceiling

Anurup m <anurup.m@huawei.com>
    fs/fscache/stats.c: fix memory leak

Stephan Schreiber <info@fs-driver.org>
    Wrong asm register contraints in the kvm implementation

Stephan Schreiber <info@fs-driver.org>
    Wrong asm register contraints in the futex implementation

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()

Yinghai Lu <yinghai@kernel.org>
    PCI / ACPI: Don't query OSC support with all possible controls

Tony Luck <tony.luck@intel.com>
    Fix initialization of CMCI/CMCP interrupts

Ming Lei <ming.lei@canonical.com>
    sysfs: fix use after free in case of concurrent read/write and readdir

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
    xen/time: Fix kasprintf splat when allocating timer%d IRQ line.

Heiko Carstens <heiko.carstens@de.ibm.com>
    s390/memory hotplug: prevent offline of active memory increments

Tormod Volden <debian.tormod@gmail.com>
    usb-storage: CY7C68300A chips do not support Cypress ATACB

Hans de Goede <hdegoede@redhat.com>
    usbfs: Always allow ctrl requests with USB_RECIP_ENDPOINT on the ctrl ep

Adrian Thomasset <adrian.thomasset@st.com>
    USB: ftdi_sio: correct ST Micro Connect Lite PIDs

Stefani Seibold <stefani@seibold.net>
    USB: add ftdi_sio USB ID for GDM Boost V1.x

Ben Jencks <ben@bjencks.net>
    usb/misc/appledisplay: Add 24" LED Cinema display

Yogesh Ashok Powar <yogeshp@marvell.com>
    mwifiex: Call pci_release_region after calling pci_disable_device

Yogesh Ashok Powar <yogeshp@marvell.com>
    mwifiex: Use pci_release_region() instead of a pci_release_regions()

Michael Ellerman <michael@ellerman.id.au>
    powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()

Michael Neuling <michael.neuling@au1.ibm.com>
    powerpc: Add isync to copy_and_flush

Maxime Ripard <maxime.ripard@free-electrons.com>
    ARM: at91: Fix typo in restart code panic message

Bjørn Mork <bjorn@mork.no>
    USB: option: add a D-Link DWM-156 variant

Filippo Turato <nnj7585@gmail.com>
    USB: serial: option: Added support Olivetti Olicard 145


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/arm/configs/at91sam9g45_defconfig        |  1 -
 arch/arm/include/asm/pgtable.h                | 18 +++++++
 arch/arm/mach-at91/setup.c                    |  2 +-
 arch/avr32/configs/favr-32_defconfig          |  1 -
 arch/avr32/configs/merisc_defconfig           |  1 -
 arch/ia64/include/asm/futex.h                 |  5 +-
 arch/ia64/include/asm/mca.h                   |  1 +
 arch/ia64/kernel/irq.c                        |  8 +++
 arch/ia64/kernel/mca.c                        | 37 ++++++++-----
 arch/ia64/kvm/vtlb.c                          |  2 +-
 arch/powerpc/kernel/head_64.S                 |  1 +
 arch/powerpc/platforms/cell/spufs/inode.c     |  1 +
 arch/x86/kernel/irq.c                         |  4 --
 arch/x86/kvm/emulate.c                        |  4 ++
 arch/x86/xen/enlighten.c                      |  5 +-
 arch/x86/xen/time.c                           |  6 ++-
 drivers/acpi/pci_root.c                       |  4 +-
 drivers/i2c/busses/i2c-xiic.c                 |  6 +--
 drivers/md/md.c                               |  9 ++--
 drivers/mfd/adp5520.c                         |  8 ++-
 drivers/mmc/core/mmc.c                        |  2 +-
 drivers/mmc/host/Kconfig                      | 10 ----
 drivers/mmc/host/atmel-mci.c                  | 16 +++---
 drivers/net/ethernet/freescale/gianfar_ptp.c  |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++++
 drivers/net/wireless/mwifiex/pcie.c           |  4 +-
 drivers/pci/pci.c                             | 12 ++---
 drivers/rtc/rtc-cmos.c                        |  4 +-
 drivers/s390/char/sclp_cmd.c                  |  4 +-
 drivers/tty/pty.c                             |  3 ++
 drivers/tty/serial/serial_core.c              |  4 ++
 drivers/tty/tty_io.c                          |  4 +-
 drivers/usb/core/devio.c                      |  2 +
 drivers/usb/misc/appledisplay.c               |  1 +
 drivers/usb/serial/ftdi_sio.c                 |  5 +-
 drivers/usb/serial/ftdi_sio_ids.h             |  4 +-
 drivers/usb/serial/option.c                   |  8 +++
 drivers/usb/storage/cypress_atacb.c           | 16 +++++-
 drivers/video/console/fbcon.c                 |  2 +
 fs/dcache.c                                   |  4 +-
 fs/exec.c                                     |  4 +-
 fs/ext4/Kconfig                               |  3 +-
 fs/ext4/ext4_jbd2.h                           |  6 ++-
 fs/ext4/mballoc.c                             |  8 +--
 fs/ext4/resize.c                              |  2 +
 fs/ext4/super.c                               |  7 ++-
 fs/fscache/stats.c                            |  2 +-
 fs/jbd2/commit.c                              | 50 ++++++++++--------
 fs/lockd/clntlock.c                           |  3 ++
 fs/lockd/clntproc.c                           |  3 --
 fs/nfs/nfs4proc.c                             |  6 +++
 fs/nfsd/nfs4state.c                           |  8 +--
 fs/nfsd/nfs4xdr.c                             | 19 ++-----
 fs/sysfs/dir.c                                | 15 ++++--
 include/asm-generic/pgtable.h                 | 10 ++++
 include/linux/ipc_namespace.h                 |  2 +-
 include/linux/jbd2.h                          |  1 +
 ipc/shm.c                                     |  2 +-
 kernel/cgroup.c                               |  2 +-
 kernel/hrtimer.c                              |  6 +++
 kernel/time/tick-broadcast.c                  |  4 ++
 kernel/time/tick-common.c                     |  1 +
 kernel/trace/ftrace.c                         |  5 +-
 kernel/trace/trace.c                          |  2 +
 kernel/trace/trace_stack.c                    | 76 ++++++++++++++++++++++++---
 kernel/trace/trace_stat.c                     |  2 +
 mm/mmap.c                                     |  4 +-
 net/wireless/reg.c                            |  2 +-
 sound/soc/codecs/max98088.c                   |  2 +-
 sound/usb/card.c                              |  4 +-
 sound/usb/midi.c                              | 13 +----
 sound/usb/stream.c                            |  8 +++
 73 files changed, 357 insertions(+), 171 deletions(-)


