Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaEEC3G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 22:29:06 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35964 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaEEC3D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 22:29:03 -0400
MIME-Version: 1.0
Date: Sun, 4 May 2014 19:29:01 -0700
X-Google-Sender-Auth: HzPI-9rGZZTae3gVxCQUH11FPRc
Message-ID: <CA+55aFz6Sxjy9jdai=TkeB2Rbpu0ydL4-YW4j-S-9oixDu5oZw@mail.gmail.com>
Subject: Linux 3.15-rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing particularly unusual going on. 45% drivers (drm, sound, md,
pin-control, acpi etc), 40% arch (mainly powerpc/powernv, but x86 and
arm too), 15% misc (perf tooling, documentation updates, core code).
The appended shortlog gives some kind of overview of the details
without being _too_ big.

There's a few known things pending still (pending fix for some
interesting dentry list corruption, for example - not that any
remotely normal use will likely ever hit it), but on the whole things
are fairly calm and nothing horribly scary. We're in the middle of the
calming-down period, so that's just how I like it.

But the more testing we get, the better, so please do give this a whirl,

                  Linus

---

Alexander Gordeev (1):
      kvm: Use pci_enable_msix_exact() instead of pci_enable_msix()

Alexander Shiyan (1):
      clocksource: nspire: Fix compiler warning

Alexandre Belloni (1):
      ASoC: tlv320aic31xx: document that the regulators are mandatory

Alistair Popple (1):
      powerpc/4xx: Fix section mismatch in ppc4xx_pci.c

Anatol Pomozov (1):
      aio: block io_destroy() until all context requests are completed

Andre Przywara (1):
      KVM: arm/arm64: vgic: fix GICD_ICFGR register accesses

Andrew Bresticker (1):
      pinctrl: as3722: fix handling of GPIO invert bit

Andrew Lunn (1):
      ASoC: alc5623: Fix regmap endianness

Andrzej Hajda (1):
      drm/exynos: balance framebuffer refcount

Aneesh Kumar K.V (1):
      powerpc/mm: Fix tlbie to add AVAL fields for 64K pages

Anton Blanchard (11):
      powerpc/powernv: Fix little endian issues in OPAL flash code
      powerpc/powernv: Use uint64_t instead of size_t in OPAL APIs
      powerpc/powernv: Remove some OPAL function declaration duplication
      powerpc/powernv: Fix little endian issues with opal_do_notifier calls
      powerpc/powernv: Fix little endian issues in OPAL error log code
      powerpc/powernv: Create OPAL sglist helper functions and fix endian issues
      powerpc/powernv: Fix little endian issues in OPAL dump code
      powerpc: Rename duplicate COMMAND_LINE_SIZE define
      powerpc: Bump COMMAND_LINE_SIZE to 2048
      powerpc: Bump BOOT_COMMAND_LINE_SIZE to 2048
      powerpc: Fix error return in rtas_flash module init

Axel Lin (2):
      ASoC: cs42l52: Convert to use devm_gpio_request_one
      ASoC: cs42l73: Convert to use devm_gpio_request_one

Bandan Das (1):
      KVM: x86: Check for host supported fields in shadow vmcs

Behan Webster (1):
      x86: LLVMLinux: Wrap -mno-80387 with cc-option

Ben Dooks (1):
      ASoC: rsnd: fix clock prepare/unprepare

Ben Widawsky (1):
      drm/i915: Allow full PPGTT with param override

Benjamin Herrenschmidt (1):
      powerpc/powernv: Fix kexec races going back to OPAL

Bjorn Helgaas (1):
      PNP: Fix compile error in quirks.c

Catalin Marinas (3):
      arm64: Use bus notifiers to set per-device coherent DMA ops
      arm64: Mark the Applied Micro X-Gene SATA controller as DMA coherent
      vexpress: Initialise the sysregs before setting up the clocks

Chris Wilson (2):
      drm/i915: Discard BIOS framebuffers too small to accommodate chosen mode
      drm/i915: Move all ring resets before setting the HWS page

Christian Engelmayer (1):
      ASoC: Intel: Fix incorrect sizeof() in sst_hsw_stream_get_volume()

Christian Ruppert (1):
      pinctrl/TB10x: Fix signedness bug

Cody P Schafer (6):
      powerpc/perf/hv_24x7: Probe errors changed to pr_debug(), padding fixed
      powerpc/perf/hv_gpci: Probe failures use pr_debug(), and padding reduced
      powerpc/perf/hv-gpci: Make device attr static
      powerpc/perf/hv-24x7: Use (unsigned long) not (u32) values when
calling plpar_hcall_norets()
      powerpc/perf/hv-24x7: Remove [static 4096], sparse chokes on it
      powerpc/perf/hv-24x7: Catalog version number is be64, not be32

Dan Carpenter (2):
      ASoC: Intel: some incorrect sizeof() usages
      irqchip: irq-crossbar: Not allocating enough memory

Daniel Vetter (3):
      drm/i915: Don't check gmch state on inherited configs
      drm/tegra: restrict plane loops to legacy planes
      drm/i915: Don't WARN nor handle unexpected hpd interrupts on
gmch platforms

Dave Anderson (1):
      arm64: Fix for the arm64 kern_addr_valid() function

Fam Zheng (1):
      [SCSI] virtio-scsi: Skip setting affinity on uninitialized vq

Geert Uytterhoeven (1):
      dt: Fix binding typos in clock-names and interrupt-names

Grant Likely (1):
      drivercore: deferral race condition fix

Guenter Roeck (1):
      Revert "hwmon: (coretemp) Refine TjMax detection"

Guido Piasenza (1):
      sh-pfc: r8a7790: Fix definition of IPSR5

H. Peter Anvin (1):
      word-at-a-time: simplify big-endian zero_bytemask macro

Haibin Wang (2):
      KVM: ARM: vgic: Fix sgi dispatch problem
      KVM: ARM: vgic: Fix the overlap check action about setting the
GICD & GICC base address.

Hariprasad S (1):
      RDMA/cxgb4: Update Kconfig to include Chelsio T5 adapter

Helge Deller (1):
      parisc: Use generic uapi/asm/resource.h file

Hui Wang (1):
      ALSA: hda - add headset mic detect quirk for a Dell laptop

Jarkko Nikula (1):
      ASoC: dapm: Fix widget double free with auto-disable DAPM kcontrol

Jeff Layton (1):
      MAINTAINERS: email address change for Jeff Layton

Jeff Mahoney (1):
      powerpc: Export flush_icache_range

Jingoo Han (3):
      MAINTAINERS: update maintainer entry for Exynos DP driver
      drm/exynos: dsi: use IS_ERR() to check devm_ioremap_resource() results
      drm/exynos: use %pad for dma_addr_t

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Jiri Olsa (5):
      perf tools: Disable libdw unwind for all but x86 arch
      perf tools: Use LDFLAGS instead of ALL_LDFLAGS
      perf tools: Fix bfd dependency libraries detection
      perf tests: Add static build make test
      perf tests x86: Fix stack map lookup in dwarf unwind test

Joe Thornber (2):
      dm thin: irqsave must always be used with the pool->lock spinlock
      dm thin: fix rcu_read_lock being held in code that can sleep

Joel Stanley (5):
      powerpc/powernv: Fix sysparam sysfs error handling
      powerpc/powernv: Use ssize_t for sysparam return values
      powerpc/powernv: Check sysfs size before copying
      powerpc/powernv: Fix typos in sysparam code
      powerpc/powernv: Check sysparam size before creation

John David Anglin (1):
      parisc: remove _STK_LIM_MAX override

Kieran Clancy (1):
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Lan Tianyu (1):
      ACPI / processor: Fix failure of loading acpi-cpufreq driver

Lars-Peter Clausen (1):
      ASoC: jz4740: Remove Makefile entry for removed file

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Leon Yu (1):
      aio: fix potential leak in aio_run_iocb().

Li Zhong (2):
      powerpc: Fix Oops in rtas_stop_self()
      powerpc/pseries: Protect remove_memory() with device hotplug lock

Linus Torvalds (2):
      mm: don't pointlessly use BUG_ON() for sanity check
      Linux 3.15-rc4

Lorenzo Pieralisi (1):
      clocksource: arch_arm_timer: Fix age-old arch timer C3STOP detection issue

Marc Zyngier (2):
      MAINTAINERS: co-maintainance of KVM/{arm,arm64}
      arm64: fixmap: fix missing sub-page offset for earlyprintk

Mark Salter (1):
      arm: KVM: fix possible misalignment of PGDs and bounce page

Martin Schwidefsky (1):
      s390/bpf,jit: initialize A register if 1st insn is BPF_S_LDX_B_MSH

Masanari Iida (1):
      perf tests x86: Fix memory leak in sample_ustack()

Mathias Krause (1):
      perf x86: Fix perf to use non-executable stack, again

Mathieu Desnoyers (1):
      Fix: tracing: use 'E' instead of 'X' for unsigned module tain flag

Micah Richert (1):
      drm/msm: fix memory leak

Mike Snitzer (2):
      dm thin: use INIT_WORK_ONSTACK in noflush_work to avoid ODEBUG warning
      dm cache: fix writethrough mode quiescing in cache_map

Milan Broz (1):
      dm verity: fix biovecs hash calculation regression

Neil Greatorex (1):
      irqchip: armada-370-xp: Fix releasing of MSIs

Nicolin Chen (1):
      ASoC: fsl_spdif: Fix wrong OFFSET of STC_SYSCLK_DIV

Oleg Nesterov (1):
      KVM: async_pf: mm->mm_users can not pin apf->mm

Oren Twaig (1):
      x86/vsmp: Fix irq routing

Paulo Zanoni (1):
      drm/i915: get power domain in case the BIOS enabled eDP VDD

Phil Edworthy (1):
      sh-pfc: r8a7791: Fix definition of MOD_SEL3

Preeti U Murthy (3):
      ppc/powernv: Set the runlatch bits correctly for offline cpus
      ppc/kvm: Set the runlatch bit of a CPU just before starting guest
      ppc/kvm: Clear the runlatch bit of a vcpu before napping

Rafael J. Wysocki (1):
      PNP / ACPI: Do not return errors if _DIS or _SRS are not present

Randy Dunlap (1):
      linux/interrupt.h: fix new kernel-doc warnings

Richard Yao (1):
      perf machine: Search for modules in %s/lib/modules/%s

Ritesh Harjani (1):
      arm64: Make default dma_ops to be noncoherent

Rob Clark (2):
      drm/msm: default to XR24 rather than AR24
      drm/msm/mdp4: cure for the cursor blues (v2)

Rob Herring (2):
      of: selftest: add deferred probe interrupt test
      of/irq: do irq resolution in platform_get_irq

Rusty Russell (1):
      module: remove warning about waiting module removal.

Sebastian Ott (1):
      s390/chsc: fix SEI usage on old FW levels

Sebastian Reichel (1):
      ASoC: tlv320aic3x: fix shared reset pin for DT

Srivatsa S. Bhat (4):
      cpufreq: longhaul: Fix double invocation of
cpufreq_freq_transition_begin/end
      cpufreq: powernow-k6: Fix incorrect comparison with max_multipler
      cpufreq: powernow-k6: Fix double invocation of
cpufreq_freq_transition_begin/end
      cpufreq: powernow-k7: Fix double invocation of
cpufreq_freq_transition_begin/end

Stephane Eranian (1):
      perf/x86: Fix RAPL rdmsrl_safe() usage

Steve Wise (3):
      RDMA/cxgb4: Fix endpoint mutex deadlocks
      RDMA/cxgb4: Force T5 connections to use TAHOE congestion control
      RDMA/cxgb4: Only allow kernel db ringing for T4 devs

Steven Rostedt (2):
      tools lib traceevent: Fix backward compatibility macros for
pevent filter enums
      tools lib traceevent: Fix memory leak in pretty_print()

Steven Rostedt (Red Hat) (2):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()
      tracing: Use rcu_dereference_sched() for trace event triggers

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Takashi Iwai (1):
      ALSA: hda - Suppress CORBRP clear on Nvidia controller chips

Thomas Gleixner (2):
      genirq: x86: Ensure that dynamic irq allocation does not conflict
      irqchip: armanda: Sanitize set_irq_affinity()

Thomas Hellstrom (1):
      drm/vmwgfx: Make sure user-space can't DMA across buffer object
boundaries v2

Thomas Petazzoni (2):
      irqchip: armada-370-xp: fix invalid cast of signed value into
unsigned variable
      irqchip: armada-370-xp: implement the ->check_device() msi_chip operation

Tim Gardner (1):
      cpufreq: ppc-corenet-cpufreq: Fix __udivdi3 modpost error

Tony Lindgren (1):
      pinctrl: single: Clear pin interrupts enabled by bootloader

Tyler Stachecki (1):
      [SCSI] mpt2sas: Don't disable device twice at suspend.

Ville Syrjälä (1):
      drm/i915: Allow user modes to exceed DVI 165MHz limit

Vineet Gupta (2):
      ARC: !PREEMPT: Ensure Return to kernel mode is IRQ safe
      Hexagon: Delete stale barrier.h

Wei Yang (2):
      powerpc/powernv: Reduce multi-hit of iommu_add_device()
      powerpc/powernv: Release the refcount for pci_dev

Wenkai Du (1):
      ASoC: Intel: Fix audio crash due to negative address offset

Will Deacon (1):
      ARM: KVM: disable KVM in Kconfig on big-endian systems

Xia Kaixu (1):
      perf tools: Remove extra '/' character in events file path
