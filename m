Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaFBChY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 22:37:24 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:43657 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaFBChW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 22:37:22 -0400
MIME-Version: 1.0
Date: Sun, 1 Jun 2014 19:37:20 -0700
X-Google-Sender-Auth: agb1CTHSOUhy_puOtwXLEGIeLT4
Message-ID: <CA+55aFwSLmJ1kLO-zNm944Q-=oYYH2Lo0W14Dn0mbj91V5MNFA@mail.gmail.com>
Subject: Linux 3.15-rc8 ... and merge window for 3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was really hoping that rc7 would be the last rc, but it appears that
reality is once against conspiring against my well-laid plans, and is
forcing me to do an rc8. It's not like there were a lot of changes,
but the last-minute dcache fixes in particular made it not really sane
to just make a final release without another week of testing.

Now, normally, an rc8 isn't really a big deal - 3.15 is one of the
biggest (if not _the_ biggest) releases in a long time, and we do
rc8's with some regularity. It may not be every release, but I think
it's about a fifty-fifty chance whether any particular release goes to
rc8. So I shouldn't be upset, and I'm certainly not surprised.

No, the real reason I was hoping that we wouldn't need to do an rc8
for 3.15 is that school is out in two weeks, and we're doing our
family vacation immediately after that. And I'd hate to have yet
another "Linus is traveling during the merge window" thing. Normally I
have been luckier with my trips than that.

Now, I'll have internet, and I *could* do the merge window while on
vacation with the family. I'd just prefer not to.

SO... Let's try something new. I suspect most people are ready to
start the merge window, and we could try how it would be to overlap
the first week of the merge window with the last week of the previous
release.  Most of the submaintainers already use git branches
actively, so I doubt anybody will find it too confusing if I end up
having a "next" branch for a week that contains the stuff I pull for
3.16.

So let's try to see how well that works - the last weeks of the
release tends to be me just waiting around to make sure nothing bad is
happening, so doing this kind of overlapping development *should* work
fine. Maybe it works so well that we'll end up doing it in the future
even if there *isn't* some kind of scheduling conflict that makes me
want to start the merge window before I'm 100% comfortable doing the
release for the previous version.

And it's not like I think rc8 is in any way broken. I just don't feel
comfortable doing a real 3.15 release without a _bit_ more time for
people to use the fixed dentry code.

Anyway, apart from the dcache changes, there's a lot of random smaller
stuff. One one-liner in particular is interesting: Minchan Kim had a
load that basically ate up all the kernel stack on x86-64, and so this
finally does something I've been trying to delay for a long time - it
expands the stack to 16kB. I think all other 64-bit architectures have
done that a long time ago already, so it's not exactly shocking, but
it's a somewhat fundamental change on one of the main architectures.

               Linus

---

Aaron Lu (1):
      ACPI / thermal: fix workqueue destroy order

Al Viro (6):
      lift the "already marked killed" case into shrink_dentry_list()
      split dentry_kill()
      expand dentry_kill(dentry, 0) in shrink_dentry_list()
      shrink_dentry_list(): take parent's ->d_lock earlier
      dealing with the rest of shrink_dentry_list() livelock
      dentry_kill() doesn't need the second argument now

Alex Smith (1):
      MIPS: ptrace: Avoid smp_processor_id() in preemptible code

Alexander Graf (2):
      KVM: PPC: Book3S: ifdef on CONFIG_KVM_BOOK3S_32_HANDLER for 32bit
      KVM guest: Make pv trampoline code executable

Alexandre Belloni (2):
      ARM: at91/dt: sam9260: correct external trigger value
      ARM: at91: sam9260: fix compilation issues

Alexandre Courbot (1):
      ARM: trusted_foundations: fix compile error on non-SMP

Alexey Charkov (1):
      pinctrl: vt8500: Ensure value reg is updated when setting direction

Andrey Ryabinin (1):
      ARM: 8051/1: put_user: fix possible data corruption in put_user

Andy Shevchenko (1):
      dmaengine: dw: went back to plain {request,free}_irq() calls

Arnd Bergmann (4):
      Input: fix ps2/serio module dependency
      Input: atmel-wm97xx - only build for AVR32
      dmaengine: omap: hide filter_fn for built-in drivers
      dmaengine: sa11x0: remove broken #ifdef

Arun Kumar K (1):
      ARM: dts: Remove g2d_pd node for exynos5420

Benjamin Herrenschmidt (1):
      powerpc: Wire renameat2() syscall

Beomho Seo (1):
      ARM: dts: fix incorrect ak8975 compatible for exynos4412-trats2 board

Bibek Basu (1):
      cpufreq: remove race while accessing cur_policy

Chao Xie (1):
      Input: pxa27x-keypad - fix generating scancode

Chris Wilson (3):
      drm/i915: Fix dynamic allocation of physical handles
      drm/i915: Only copy back the modified fields to userspace from execbuffer
      drm/i915: Prevent negative relocation deltas from wrapping

Christian König (3):
      drm/radeon: lower the ref * post PLL maximum once more
      drm/radeon: avoid crash if VM command submission isn't available
      drm/radeon: only allocate necessary size for vm bo list

Cornelia Huck (1):
      KVM: s390: announce irqfd capability

Daniel Vetter (1):
      drm/radeon: Resume fbcon last

David Jander (1):
      clocksource: tcb_clksrc: Make tc_mode interrupt safe

Emil Goode (1):
      ARM: imx: fix error handling in ipu device registration

Gabor Juhos (1):
      MIPS: RC32434: fix broken PCI resource initialization

Guenter Roeck (1):
      powerpc: Fix 64 bit builds with binutils 2.24

Hannes Reinecke (1):
      dm mpath: really fix lockdep warning

Hans de Goede (4):
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models
      Input: synaptics - add a matches_pnp_id helper function
      Input: synaptics - change min/max quirk table to pnp-id matching

Heinz Mauelshagen (1):
      dm cache: always split discards on cache block boundaries

Huacai Chen (2):
      MIPS: Fix a typo error in AUDIT_ARCH definition
      MIPS: Fix inconsistancy of __NR_Linux_syscalls value

Juri Lelli (1):
      sched/deadline: Restrict user params max value to 2^63 ns

Kyungmin Park (1):
      ARM: EXYNOS: fix the secondary CPU boot of exynos4212

Lai Jiangshan (1):
      sched: Fix hotplug vs. set_cpus_allowed_ptr()

Laurent Pinchart (1):
      ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to
dpll4_m5 on all OMAP3 platforms

Linus Torvalds (2):
      dcache: add missing lockdep annotation
      Linux 3.15-rc8

Liviu Dudau (1):
      Input: ambakmi - request a shared interrupt for AMBA KMI devices

Lucas Stach (1):
      cpufreq: cpu0: drop wrong devm usage

Marcelo Tosatti (1):
      KVM: x86: disable master clock if TSC is reset during suspend

Marek Olšák (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Markos Chandras (2):
      MIPS: Fix typo when reporting cache and ftlb errors for ImgTec cores
      MIPS: malta: memory.c: Initialize the 'memsize' variable

Maxime COQUELIN (1):
      clk: divider: Fix table round up function

Michael Kerrisk (1):
      sched: Make sched_setattr() correctly return -EFBIG

Mike Snitzer (1):
      dm thin: add 'no_space_timeout' dm-thin-pool module param

Miklos Szeredi (1):
      vfs: fix vmplice_to_user()

Minchan Kim (1):
      x86_64: expand kernel stack to 16K

Ming Lei (1):
      virtio_blk: fix race between start and stop queue

Nicolas Pitre (1):
      ARM: 8063/1: bL_switcher: fix individual online status reporting
of removed CPUs

Nikolay Borisov (1):
      ARM: 8052/1: unwind: Fix handling of "Pop r4-r[4+nnn],r14" opcode

Paolo Bonzini (1):
      KVM: vmx: disable APIC virtualization in nested guests

Paul Mackerras (1):
      KVM: PPC: Book3S HV: Add missing code for transaction reclaim on
guest exit

Peter Ujfalusi (1):
      ARM: omap5: hwmod_data: Correct IDLEMODE for McPDM

Peter Zijlstra (4):
      sched: Disallow sched_attr::sched_policy < 0
      sched/deadline: Change sched_getparam() behaviour vs SCHED_DEADLINE
      sched/deadline: Replace NR_CPUS arrays
      sched/cpupri: Replace NR_CPUS arrays

Philipp Zabel (1):
      MAINTAINERS: Add reset controller framework entry

Rabin Vincent (2):
      ARM: 8048/1: fix v7-M setup stack location
      ARM: 8064/1: fix v7-M signal return

Ralf Baechle (3):
      MIPS: Change type of asid_cache to unsigned long
      MIPS: Fix branch emulation of branch likely instructions.
      MIPS: SB1: Fix excessive kernel warnings.

Roger Quadros (1):
      ARM: OMAP2+: nand: Fix NAND on OMAP2 and OMAP3 boards

Sachin Kamat (3):
      ARM: exynos_defconfig: enable HS-I2C to fix for mmc partition mount
      ARM: dts: Fix SPI interrupt numbers for exynos5420
      ARM: dts: Keep LDO4 always ON for exynos5250-arndale board

Santosh Shilimkar (1):
      ARM: OMAP4: Fix the boot regression with CPU_IDLE enabled

Sebastian Andrzej Siewior (1):
      MIPS: Lemote 2F: cs5536: mfgpt: use raw locks

Seungwon Jeon (1):
      ARM: dts: disable MDMA1 node for exynos5420

Srivatsa S. Bhat (1):
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode

Stefan Richter (1):
      firewire: revert to 4 GB RDMA, fix protocols using Memory Space

Takashi Iwai (1):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets

Thierry Reding (3):
      clk: tegra: Fix PLLE programming
      clk: tegra: Introduce divider mask and shift helpers
      clk: tegra: Fix enabling of PLLE

Thomas Bogendoerfer (1):
      MIPS: R46000: Fix Micro-assembler field overflow for R4600 V2

Thomas Gleixner (3):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      rtmutex: Fix deadlock detector for real

Thomas Petazzoni (3):
      ARM: mvebu: mvebu-soc-id: add missing clk_put() call
      ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled
      ARM: mvebu: fix definitions of PCIe interfaces on Armada 38x

Tony Lindgren (1):
      ARM: OMAP2+: Fix DMA hang after off-idle

Tushar Behera (2):
      ARM: dts: Remove mau_pd node for exynos5420
      ALSA: pcm_dmaengine: Add check during device suspend

Valentin Ilie (1):
      clk: st: Fix memory leak

Will Deacon (1):
      arm64: mm: fix pmd_write CoW brokenness

Zhiwu Song (1):
      clocksource: marco: Fix the affinity set for local timer of CPU1

pingfank@linux.vnet.ibm.com (1):
      KVM: PPC: Book3S: HV: make _PAGE_NUMA take effect

srinik (1):
      ARM: 8057/1: amba: Add Qualcomm vendor ID.
