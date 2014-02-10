Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBJDdo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 22:33:44 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:47431 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaBJDdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 22:33:41 -0500
MIME-Version: 1.0
Date: Sun, 9 Feb 2014 19:33:40 -0800
X-Google-Sender-Auth: KUgyceKHFj_HdVwusv3-owmlKzw
Message-ID: <CA+55aFwCWi5Ao7jSD-8anyLW=GP9t1H5J8YrQ4quES-ZY=z1RQ@mail.gmail.com>
Subject: Linux 3.14-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been pretty quiet, actually, which should make me happy. But I
have a suspicious nature, and I'm going to wait to see if the other
shoe drops, and people are just lulling me into a false sense of
security. Because I know kernel developers, and they are sneaky.  I
suspect Davem (to pick somebody not at random) is giggling to himself,
waiting for this release message, planning to send me some big-ass
pull request tomorrow.

Because that's the kind of people you guys are.

Anyway, what little there was looks normal: roughly two thirds drivers
(gpu, block, media, misc), with almost half the remaining patches
being architecture updates (x86, s390 and arm64). With the rest being
filesystems (vfs, nfs, ocfs, btrfs and some kernfs fixes), some mm
noise, and tooling (perf).

Shortlog appended, which doesn't always happen for rc2.

                     Linus

---

Aaro Koskinen (1):
      MIPS: fpu.h: Fix build when CONFIG_BUG is not set

Adam Thomson (1):
      hwmon: (da9055) Remove use of regmap_irq_get_virq()

Adrian Hunter (9):
      perf symbols: Fix symbol annotation for relocated kernel
      perf tools: Add kallsyms__get_function_start()
      perf machine: Add machine__get_kallsyms_filename()
      perf machine: Set up ref_reloc_sym in machine__create_kernel_maps()
      perf record: Get ref_reloc_sym from kernel map
      perf symbols: Prevent the use of kcore if the kernel has moved
      perf tests: No need to set up ref_reloc_sym
      perf tools: Adjust kallsyms for relocated kernel
      perf buildid-cache: Check relocation when checking for existing kcore

Al Viro (2):
      fix O_SYNC|O_APPEND syncing the wrong range on write()
      fix a kmap leak in virtio_console

Alan (1):
      x86, doc, kconfig: Fix dud URL for Microcode data

Alexey Khoroshilov (1):
      [media] go7007-loader: fix usb_dev leak

Andi Shyti (2):
      [media] cx24117: remove dead code in always 'false' if statement
      [media] cx24117: use a valid dev pointer for dev_err printout

Andrzej Hajda (1):
      [media] s5k5baf: allow to handle arbitrary long i2c sequences

Antti Palosaari (1):
      [media] af9035: add ID [2040:f900] Hauppauge WinTV-MiniStick 2

Aravind Gopalakrishnan (1):
      x86/quirks: Add workaround for AMD F16h Erratum792

Avi Kivity (1):
      perf tools: Demangle kernel and kernel module symbols too

Baruch Siach (1):
      perf/doc: Remove mention of non-existent
set_perf_event_pending() from design.txt

Borislav Petkov (1):
      x86, microcode, AMD: Unify valid container checks

Catalin Marinas (2):
      arm64: Invalidate the TLB when replacing pmd entries during boot
      arm64: compat: Wire up new AArch32 syscalls

Chris Ruehl (2):
      pinctrl: imx27: fix wrong offset to ICONFB
      pinctrl: imx27: fix offset calculation in imx_read_2bit

Colin Cross (1):
      security: select correct default LSM_MMAP_MIN_ADDR on arm on arm64

Dan Carpenter (3):
      x86/AMD/NB: Fix amd_set_subcaches() parameter type
      ACPI / utils: remove a pointless NULL check
      ACPI / proc: remove unneeded NULL check

Daniel Tang (1):
      irqchip: Add support for TI-NSPIRE irqchip

Dave Airlie (3):
      drm/mgag200: fix typo causing bw limits to be ignored on some chips
      drm/mgag200,ast,cirrus: fix regression with drm_can_sleep conversion
      drm/radeon: allow geom rings to be setup on r600/r700 (v2)

Dave Jones (3):
      [media] mxl111sf: Fix unintentional garbage stack read
      [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset
      vmwgfx: Fix unitialized stack read in vmw_setup_otable_base

Dave Kleikamp (1):
      jfs: fix generic posix ACL regression

David Cohen (1):
      x86/intel/mid: Fix X86_INTEL_MID dependencies

David Sterba (1):
      btrfs: reserve no transaction units in btrfs_ioctl_set_features

Dirk Brandewie (1):
      intel_pstate: Take core C0 time into account for core busy calculation

Filipe David Borba Manana (3):
      Btrfs: use btrfs_crc32c everywhere instead of libcrc32c
      Btrfs: use late_initcall instead of module_init
      Btrfs: fix data corruption when reading/updating compressed extents

Florian Vaussard (1):
      pinctrl: do not init debugfs entries for unimplemented functionalities

Francesco Fusco (1):
      perf tools: Fix include for non x86 architectures

Guenter Roeck (1):
      hwmon: (pmbus) Support per-page exponent in linear mode

Haiyan Hu (1):
      NVMe: Avoid shift operation when writing cq head doorbell

Hans Verkuil (1):
      [media] Revert "[media] videobuf_vm_{open,close} race fixes"

Harald Freudenberger (3):
      crypto: s390 - fix concurrency issue in aes-ctr mode
      crypto: s390 - fix des and des3_ede cbc concurrency issue
      crypto: s390 - fix des and des3_ede ctr concurrency issue

Ilya Dryomov (4):
      libceph: fix error handling in ceph_osdc_init()
      libceph: factor out logic from ceph_osdc_start_request()
      libceph: take map_sem for read in handle_reply()
      libceph: do not dereference a NULL bio pointer

Ingo Molnar (1):
      x86: Disable CONFIG_X86_DECODER_SELFTEST in allmod/allyesconfigs

Jacek Anaszewski (1):
      [media] s5p-jpeg: Fix wrong NV12 format parameters

James Hogan (1):
      MIPS: Wire up sched_setattr/sched_getattr syscalls

Jeff Mahoney (1):
      btrfs: commit transaction after setting label and features

Josef Bacik (3):
      Btrfs: disable snapshot aware defrag for now
      Btrfs: fix assert screwup for the pending move stuff
      Btrfs: don't loop forever if we can't run because of the tree mod log

KOSAKI Motohiro (2):
      mm: __set_page_dirty_nobuffers() uses spin_lock_irqsave()
instead of spin_lock_irq()
      mm: __set_page_dirty uses spin_lock_irqsave instead of spin_lock_irq

Keith Busch (9):
      NVMe: compat SG_IO ioctl
      NVMe: Device resume error handling
      NVMe: Schedule reset for failed controllers
      NVMe: Abort timed out commands
      NVMe: Surprise removal handling
      NVMe: Async IO queue deletion
      NVMe: Disable admin queue on init failure
      NVMe: Add a pci_driver shutdown method
      NVMe: Namespace use after free on surprise removal

Konrad Rzeszutek Wilk (1):
      Revert "xen/grant-table: Avoid m2p_override during mapping"

Krzysztof Kozlowski (1):
      regulator: s2mps11: Fix NULL pointer of_node value when using
platform data

Laura Abbott (1):
      arm64: Align CMA sizes to PAGE_SIZE

Laxman Dewangan (1):
      pinctrl: tegra: return correct error type

Levente Kurusa (1):
      [media] media: bt8xx: add missing put_device call

Linus Torvalds (3):
      kbuild: don't enable DEBUG_INFO when building for COMPILE_TEST
      execve: use 'struct filename *' for executable name passing
      Linux 3.14-rc2

Linus Walleij (1):
      regulator: ab3100: cast fix

Lior Amsalem (2):
      irqchip: armada-370-xp: fix IPI race condition
      irqchip: armada-370-xp: fix MSI race condition

Luis G.F (1):
      ACPI / battery: Fix incorrect sscanf() string in acpi_battery_init_alarm()

Magnus Damm (2):
      irqchip: renesas-irqc: Use lazy disable
      irqchip: renesas-irqc: Enable mask on suspend

Manuel Lauss (1):
      MIPS: Alchemy: Fix DB1100 GPIO registration

Mark Brown (1):
      regulator: core: Correct default return value for full constraints

Mark Rutland (3):
      arm64: fix typo: s/SERRROR/SERROR/
      arm64: simplify pgd_alloc
      arm64: defconfig: Expand default enabled features

Martin Bugge (2):
      [media] v4l2-dv-timings: fix GTF calculation
      [media] adv7842: Composite free-run platfrom-data fix

Masanari Iida (1):
      [media] hdpvr: Fix memory leak in debug

Matt Fleming (1):
      x86/efi: Allow mapping BGRT on x86-32

Matthew Wilcox (5):
      NVMe: Fix lockdep warnings
      NVMe: Cache dev->pci_dev in a local pointer
      NVMe: Dynamically allocate partition numbers
      NVMe: Include device and queue numbers in interrupt name
      NVMe: Correct uses of INIT_WORK

Mel Gorman (5):
      mm, x86: Account for TLB flushes only when debugging
      x86/mm: Clean up inconsistencies when flushing TLB ranges
      x86/mm: Eliminate redundant page table walk during TLB range flushing
      x86: mm: change tlb_flushall_shift for IvyBridge
      mm, x86: Revisit tlb_flushall_shift tuning for page flushes
except on IvyBridge

Michael Krufky (1):
      [media] update Michael Krufky's email address

Michael Opdenacker (1):
      NVMe: remove deprecated IRQF_DISABLED

Mika Westerberg (1):
      ACPI / video: Add HP EliteBook Revolve 810 to the blacklist

Mukesh Rathor (1):
      xen/pvh: set CR4 flags for APs

Nathan Lynch (2):
      arm64: vdso: fix coarse clock handling
      arm64: vdso: update wtm fields for CLOCK_MONOTONIC_COARSE

Nicolas Ferre (1):
      pinctrl: at91: use locked variant of irq_set_handler

Nitin A Kamble (1):
      genirq: Generic irq chip requires IRQ_DOMAIN

Noah Massey (1):
      nfs: fix setting of ACLs on file creation.

Paul Moore (1):
      selinux: add SOCK_DIAG_BY_FAMILY to the list of netlink message types

Peter Oberparleiter (1):
      x86, hweight: Fix BUG when booting with CONFIG_GCOV_PROFILE_ALL=y

Peter Zijlstra (1):
      perf tools: Fix AAAAARGH64 memory barriers

Petr Tesarik (1):
      x86: Fix the initialization of physnode_map

Prarit Bhargava (1):
      x86, cpu hotplug: Fix stack frame warning in
check_irq_vectors_for_cpu_disable()

Qipan Li (1):
      pinctrl: sirf: correct the pin index of ac97_pins group

Rafael J. Wysocki (5):
      ACPI / hotplug / PCI: Remove entries from bus->devices in reverse order
      ACPI / hotplug / PCI: Move PCI rescan-remove locking to hotplug_event()
      ACPI / hotplug / PCI: Scan root bus under the PCI rescan-remove lock
      ACPI / hotplug / PCI: Fix bridge removal race in handle_hotplug_event()
      ACPI / hotplug / PCI: Fix bridge removal race vs dock events

Randy Dunlap (1):
      Documentation/kernel-parameters.txt: fix memmap= language

Ricardo Ribalda (1):
      [media] vb2: Check if there are buffers before streamon

Richard Weinberger (1):
      watchdog: dw_wdt: Add dependency on HAS_IOMEM

Shaohua Li (1):
      swap: add a simple detector for inappropriate swapin readahead

Stanislaw Gruszka (1):
      pinctrl: protect pinctrl_list add

Stephen Smalley (1):
      SELinux:  Fix kernel BUG on empty security contexts.

Sylwester Nawrocki (3):
      [media] exynos4-is: Fix error paths in probe() for !pm_runtime_enabled()
      [media] exynos4-is: Compile in fimc runtime PM callbacks conditionally
      [media] exynos4-is: Compile in fimc-lite runtime PM callbacks
conditionally

Takashi Iwai (6):
      ALSA: usb-audio: Add missing kconfig dependecy
      ALSA: hda - Fix silent output on Toshiba Satellite L40
      ALSA: hda/realtek - Avoid invalid COEFs for ALC271X
      ALSA: hda - Add missing mixer widget for AD1983
      ALSA: hda - Fix missing VREF setup for Mac Pro 1,1
      ALSA: hda - Improve loopback path lookups for AD1983

Tang Chen (2):
      arch/x86/mm/numa.c: initialize numa_kernel_nodes in
numa_clear_kernel_node_hotplug()
      arch/x86/mm/numa.c: fix array index overflow when synchronizing
nid to memblock.reserved.

Tejun Heo (1):
      kernfs: make kernfs_deactivate() honor KERNFS_LOCKDEP flag

Thomas Hellstrom (9):
      drm/vmwgfx: Don't commit staged bindings if execbuf fails
      drm/vmwgfx: Fix regression caused by "drm/ttm: make ttm
reservation calls behave like reservation calls"
      drm/vmwgfx: Fix SET_SHADER_CONST emulation on guest-backed devices
      drm/vmwgfx: Fix legacy surface reference size copyback
      drm/vmwgfx: Emulate legacy shaders on guest-backed devices v2
      drm/vmwgfx: Detect old user-space drivers and set up legacy emulation v2
      drm/vmwgfx: Reemit context bindings when necessary v2
      drm/ttm: Fix TTM object open regression
      drm/ttm: Don't clear page metadata of imported sg pages

Tony Luck (1):
      [IA64] Wire up new sched_setattr and sched_getattr syscalls

Tony Prisk (1):
      pinctrl: vt8500: Change devicetree data parsing

Toshi Kani (2):
      arch/x86/mm/srat: Skip NUMA_NO_NODE while parsing SLIT
      ACPI / hotplug: Fix panic on eject to ejected device

Trond Myklebust (5):
      NFSv4: Fix memory corruption in nfs4_proc_open_confirm
      NFSv4.1: nfs4_destroy_session must call rpc_destroy_waitqueue
      NFSv3: Remove unused function nfs3_proc_set_default_acl
      NFSv3: Fix return value of nfs3_proc_setacls
      fs: get_acl() must be allowed to return EOPNOTSUPP

Vinayak Kale (1):
      arm64: add DSB after icache flush in __flush_icache_all()

Weijie Yang (1):
      mm/swap: fix race on swap_info reuse between swapoff and swapon

Will Deacon (4):
      arm64: vdso: prevent ld from aligning PT_LOAD segments to 64k
      arm64: barriers: allow dsb macro to take option parameter
      arm64: atomics: fix use of acquire + release for full barrier semantics
      arm64: asm: remove redundant "cc" clobbers

Zongxun Wang (1):
      ocfs2: free allocated clusters if error occurs after ocfs2_claim_clusters
