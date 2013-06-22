Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3FVVEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:04:30 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:41604 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3FVVE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:04:28 -0400
MIME-Version: 1.0
Date: Sat, 22 Jun 2013 11:04:27 -1000
X-Google-Sender-Auth: 7Y-11tVzSFgUnRNfvFWv0D1IgD4
Message-ID: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
Subject: Linux 3.10-rc7
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this is hopefully the last -rc in the series, and things have
indeed be calming down finally, so assuming that trend continues,
we're all good.

Which means that we still want more testing and people hollering if
there are any regressions etc.

rc7 contains a fairly mixed collection of fixes all over, with (as
usual) drivers and some arch updates being most noticeable.  This time
we had media updates in particular.

But there's also core fixes for things like fallout from the common
cpu-idle routines and some timer accounting for the new full-NOHZ
modes etc. So we have stuff all over, most of it happily fairly small.

Go test,

                Linus

---

Al Viro (4):
      lseek(fd, n, SEEK_END) does *not* go to eof - n
      mconsole: we'd better initialize pos before passing it to vfs_read()...
      splice: don't pass the address of ->f_pos to methods
      aout32 coredump compat fix

Alex Deucher (1):
      drm/radeon: fix UVD on big endian

Anders Hammarquist (1):
      USB: serial: ti_usb_3410_5052: new device id for Abbot strip port cable

Andreas Larsson (2):
      sparc32, leon: Remove separate "ticker" timer for SMP
      sparc32, leon: Enable interrupts before going idle to avoid getting stuck

Andrew Jones (1):
      sched/x86: Construct all sibling maps if smt

Andrzej Hajda (3):
      [media] s5p-mfc: separate encoder parameters for h264 and mpeg4
      [media] s5p-mfc: v4l2 controls setup routine moved to initialization code
      [media] s5p-mfc: added missing end-of-lines in debug messages

Andy Grover (1):
      target/iscsi: Fix op=disable + error handling cases in np_store_iser

Aneesh Kumar K.V (1):
      powerpc: Fix bad pmd error with book3E config

Arnd Bergmann (2):
      [media] radio-si476x: depend on SND_SOC
      clk: spear: fix build error for spear3xx

Arun Kumar K (2):
      [media] s5p-mfc: Update v6 encoder buffer alloc
      [media] s5p-mfc: Remove special clock usage in driver

Axel Lin (2):
      [media] s5c73m3: Fix off-by-one valid range checking for fie->index
      [media] exynos4-is: Fix off-by-one valid range checking for
is->config_index

Ben Hutchings (1):
      x86/efi: Fix dummy variable buffer allocation

Chen Gang (1):
      arch: sparc: prom: looping issue, need additional length check
in the outside looping

Chris Metcalf (1):
      tilepro: work around module link error with gcc 4.7

Clemens Ladisch (1):
      ALSA: usb-audio: work around Android accessory firmware bug

Dave Kleikamp (1):
      sparc: tsb must be flushed before tlb

David Daney (2):
      [IA64] Fix include dependency in asm/irqflags.h
      mn10300: Fix include dependency in irqflags.h et al.

David Henningsson (2):
      ALSA: hda - Headset mic support for three more machines
      ALSA: hda - Add models for Dell headset jacks

Denis Efremov (1):
      sparc: remove inline marking of EXPORT_SYMBOL functions

Doug Anderson (1):
      clk: samsung: Fix pll36xx_recalc_rate to handle kdiv properly

Frederic Weisbecker (2):
      vtime: Use consistent clocks among nohz accounting
      kvm: Move guest entry/exit APIs to context_tracking

Geert Uytterhoeven (2):
      [media] v4l2: SI476X MFD - Do not use binary constants
      sparc: Switch to asm-generic/linkage.h

George Spelvin (1):
      usb: phy: Improve Kconfig help for CONFIG_USB_PHY

Gianluca Gennari (1):
      [media] rtl28xxu: fix buffer overflow when probing Rafael Micro
r820t tuner

Gregory CLEMENT (1):
      ARM: 7754/1: Fix the CPU ID and the mask associated to the PJ4B

Hans Verkuil (6):
      [media] DocBook: media: update codec section, drop obsolete
'suspended' state
      [media] vpfe-capture.c: remove unused label probe_free_lock
      [media] DocBook/media/v4l: update version number
      [media] cx88: fix NULL pointer dereference
      [media] v4l2-ctrls: V4L2_CTRL_CLASS_FM_RX controls are also
valid radio controls
      [media] v4l2-ioctl: don't print the clips list

Hans de Goede (2):
      [media] pwc: Fix comment wrt lock ordering
      [media] gspca-sonixb: Adjust hstart on sn9c103 + pas202

Helge Deller (1):
      parisc: fix kernel BUG at arch/parisc/include/asm/mmzone.h:50 (part 2)

Igor Mammedov (1):
      x86: kvmclock: zero initialize pvclock shared memory area

James Bottomley (1):
      idle: Enable interrupts in the weak arch_cpu_idle() implementation

James Hogan (1):
      metag: fix mm/hugetlb.c build breakage

Jay Agarwal (1):
      ARM: tegra30: clocks: Fix pciex clock registration

Jed Davis (1):
      perf: arm64: Record the user-mode PC in the call chain.

Jerome Glisse (3):
      drm/radeon: do not try to uselessly update virtual memory pagetable
      drm/radeon: fix write back suspend regression with uvd v2
      drm/radeon: update lockup tracking when scheduling in empty ring

Jiri Bohac (1):
      tick: Remove useless timekeeping duty attribution to broadcast source

John David Anglin (1):
      parisc: Use unshadowed index register for flush instructions in
flush_dcache_page_asm and flush_icache_page_asm

John Sheu (1):
      [media] v4l2: mem2mem: save irq flags correctly

Jon Medhurst (1):
      ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect

Josh Durgin (1):
      rbd: use the correct length for format 2 object names

Jussi Kivilinna (1):
      crypto: aesni_intel - fix accessing of unaligned memory

Jörn Engel (1):
      target/iscsi: don't corrupt bh_count in iscsit_stop_time2retain_timer()

Katsuya Matsubara (3):
      [media] sh_veu: invoke v4l2_m2m_job_finish() even if a job has
been aborted
      [media] sh_veu: keep power supply until the m2m context is released
      [media] sh_veu: fix the buffer size calculation

Lad, Prabhakar (3):
      [media] media: davinci: vpbe: fix layer availability for NV12 format
      [media] davinci: vpfe: fix error path in probe
      [media] drivers/staging: davinci: vpfe: fix dependency for
building the driver

Lai Jiangshan (1):
      clk: remove notifier from list before freeing it

Laurent Pinchart (1):
      drm/prime: Honor requested file flags when exporting a buffer

Li Zhong (1):
      nohz: Fix notifier return val that enforce timekeeping

Linus Torvalds (1):
      Linux 3.10-rc7

Magnus Damm (1):
      ARM: 7756/1: zImage/virt: remove hyp-stub.S during distclean

Masami Hiramatsu (1):
      kprobes: Fix to free gone and unused optprobes

Mauro Carvalho Chehab (2):
      [media] s5p makefiles: don't override other selections on obj-[ym]
      [media] Fix build when drivers are builtin and frontend modules

Michel Lespinasse (1):
      x86: Fix trigger_all_cpu_backtrace() implementation

Mika Westerberg (1):
      ACPI / resources: call acpi_get_override_irq() only for legacy
IRQ resources

Ming Lei (1):
      firmware loader: fix use-after-free by double abort

Nicholas Bellinger (1):
      iscsi-target: Remove left over v3.10-rc debug printks

Padmavathi Venna (1):
      ARM: dts: Correct the base address of pinctrl_3 on Exynos5250

Paul Gortmaker (1):
      x86: Fix section mismatch on load_ucode_ap

Peter Hurley (1):
      tty: Fix transient pty write() EIO

Peter Zijlstra (2):
      perf: Fix perf mmap bugs
      perf: Fix mmap() accounting hole

Philipp Zabel (2):
      [media] v4l2-mem2mem: add v4l2_m2m_create_bufs helper
      [media] coda: v4l2-compliance fix: add VIDIOC_CREATE_BUFS support

Po-Yu Chuang (1):
      ARM: 7753/1: map_init_section flushes incorrect pmd

Rafael J. Wysocki (3):
      ACPI / dock: Take ACPI scan lock in write_undock()
      ACPI / PM: Fix error code path for power resources initialization
      ACPI / LPSS: Power up LPSS devices during enumeration

Randy Dunlap (1):
      x86: fix build error and kconfig for ia32_emulation and binfmt

Roland Dreier (1):
      tcm_qla2xxx: Fix residual for underrun commands that fail

Ross Lagerwall (1):
      tty/vt: Return EBUSY if deallocating VT1 and it is busy

Sachin Kamat (3):
      [media] exynos4-is: Fix potential null pointer dereference in mipi-csis.c
      [media] s3c-camif: Fix incorrect variable type
      [media] s5p-mfc: Add NULL check for allocated buffer

Sasha Levin (1):
      slab: prevent warnings when allocating with __GFP_NOWARN

Scott Wood (1):
      kvm/ppc/booke: Delay kvmppc_lazy_ee_enable

Seung-Woo Kim (2):
      [media] media: vb2: return for polling if a buffer is available
      [media] media: v4l2-mem2mem: return for polling if a buffer is available

Shawn Guo (1):
      irqchip: gic: call gic_cpu_init() as well in CPU_STARTING_FROZEN case

Simon Baatz (1):
      ARM: 7755/1: handle user space mapped pages in flush_kernel_dcache_page

Stephane Eranian (1):
      perf/x86: Fix broken PEBS-LL support on SNB-EP/IVB-EP

Stephen Warren (1):
      ARM: 7759/1: decouple CPU offlining from reboot/shutdown

Steven Rostedt (1):
      tracing/context-tracking: Add preempt_schedule_context() for tracing

Sylwester Nawrocki (7):
      [media] exynos4-is: Correct fimc-lite compatible property description
      [media] s5p-mfc: Remove unused s5p_mfc_get_decoded_status_v6() function
      [media] exynos4-is: Prevent NULL pointer dereference when
firmware isn't loaded
      [media] exynos4-is: Ensure fimc-is clocks are not enabled until
properly configured
      [media] exynos4-is: Fix reported colorspace at FIMC-IS-ISP subdev
      [media] exynos4-is: Remove "sysreg" clock handling
      [media] exynos4-is: Fix FIMC-IS clocks initialization

Takashi Iwai (2):
      ALSA: hda - Fix pin configurations for MacBook Air 4,2
      ALSA: usb-audio: Fix invalid volume resolution for Logitech HD Webcam c310

Thomas Bogendoerfer (2):
      parisc: fix serial ports on C8000 workstation
      parisc: provide pci_mmap_page_range() for parisc

Thomas Gleixner (1):
      idle: Add the stack canary init to cpu_startup_entry()

Tushar Behera (4):
      clk: exynos5250: Update cpufreq related clocks for EXYNOS5250
      clk: exynos5250: Add sclk_mpll to the parent list of mout_cpu clock
      clk: exynos5250: Add CLK_IGNORE_UNUSED flag for pmu clock
      sparc,leon: Convert to use devm_ioremap_resource

Vincent Guittot (1):
      sched: Fix clear NOHZ_BALANCE_KICK

Wei Yongjun (1):
      [media] davinci: vpfe: fix error return code in vpfe_probe()

Wenbing Wang (1):
      [media] soc_camera: error dev remove and v4l2 call

Xiong Zhou (1):
      [media] staging/solo6x10: select the desired font

Yinghai Lu (2):
      x86, mtrr: Fix original mtrr range get for mtrr_cleanup
      range: Do not add new blank slot with add_range_with_merge

Zhanghaoyu (A) (1):
      KVM: x86: remove vcpu's CPL check in host-invoked XCR set

Zhao Hongjiang (1):
      sparc: kernel: using strlcpy() instead of strcpy()

bob picco (1):
      sparc64 address-congruence property
