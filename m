Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3G2Emj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 00:42:39 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:48724 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3G2Emh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 00:42:37 -0400
MIME-Version: 1.0
Date: Sun, 28 Jul 2013 21:42:36 -0700
X-Google-Sender-Auth: FB0sBzc9pPHxRHUVr57q4d028ow
Message-ID: <CA+55aFxb3NT3_04ZLKiCFrtTXSdi4bfQFf0HJviRRYPTW4ymXA@mail.gmail.com>
Subject: Linux 3.11-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc.

And please just forget about me telling you people to get back to work
last week. You got. -rc3 has about 50% more commits than -rc2 did.
Part of it is that a few people missed rc2, but part of it is that
people just sent me more. Please stop. It's summer. It's nice outside.
Take the kids to the pool or something. Send me just regression fixes.

Otherwise I'll have to start shouting at people again.

Anyway, remember how I asked people to test the backlight changes in
rc2 because things like that have really bad track records? Yup. That
all got reverted. It fixed things for some people, but regressed for
others, and we don't do that "one step forward, two steps back" thing.
But never fear, we have top people looking at it.

The crc t10 dif crypto supprt got reverted too, since there were
initrd infrastructure problems with it.

But the bulk here is some block driver updates (drbd, rsxx, xen,
bcache, libata), and the drm changes (mostly qxl, but there's changes
to the "big tree" too: radeon, intel, nouveau). And various random
other drivers - usb, scsi, pincontrol, etc.

There's also the usual arch updates (mainly alpha, arm, powerpc).

Full shortlog since rc2 appended. It's big enough that I debated doing
just a merge-window style "mergelog" overview, but hey, maybe people
enjoy this kind of detail?

                       Linus

---

Alan Stern (3):
      usb: gadget: don't fail when DMA isn't present
      USB: move the definition of USB_MAXCHILDREN
      USB: global suspend and remote wakeup don't mix

Alex Deucher (8):
      drm/radeon: wait for 3D idle before using CP DMA
      drm/radeon/vm: only align the pt base to 32k
      drm/radeon: fix endian issues with DP handling (v3)
      drm/radeon: improve dac adjust heuristics for legacy pdac
      drm/radeon/dpm: fix a typo in the rv6xx mclk setup
      drm/radeon/dpm: fix displaygap programming on rv6xx
      drm/radeon/dpm: implement force performance levels for rv6xx
      drm/radeon/dpm: fix r600_enable_sclk_control()

Alexander Shiyan (1):
      ARM: i.MX27: Typo fix

Alexander Z Lam (2):
      tracing: Fix error handling to ensure instances can always be removed
      tracing: Miscellaneous fixes for trace_array ref counting

Alexandr \"Sky\" Ivanov (1):
      USB: option: add D-Link DWM-152/C1 and DWM-156/C1

Amit Daniel Kachhap (1):
      ARM: SAMSUNG: Add SAMSUNG_PM config option to select pm

Andreas Gruenbacher (2):
      drbd: Do not sleep inside rcu
      drbd: Fix rcu_read_lock balance on error path

Andrzej Pietrasiewicz (2):
      usb: gadget: Kconfig: Fix configfs-based RNDIS function build
      usb/gadget: free opts struct on error recovery

Aneesh Kumar K.V (2):
      powerpc/mm: Fix fallthrough bug in hpte_decode
      powerpc/mm: Use the correct SLB(LLP) encoding in tlbie instruction

Anshuman Khandual (2):
      powerpc/perf: Ignore separate BHRB privilege state filter request
      powerpc/perf: BHRB filter configuration should follow the task

Anton Blanchard (1):
      powerpc/modules: Module CRC relocation fix causes perf issues

Arnd Bergmann (2):
      usb: gadget: at91_udc: call at91udc_of_init only when needed
      ARM: pxa: propagate errors from regulator_enable() to pxamci

Asias He (3):
      vhost-net: Always access vq->private_data under vq mutex
      vhost-scsi: Always access vq->private_data under vq mutex
      vhost: Remove custom vhost rcu usage

Axel Lin (1):
      of/irq: Avoid calling list_first_entry() for empty list

Barry Grussling (1):
      usb: cp210x support SEL C662 Vendor/Device

Barry Song (1):
      arm/dts: sirf: fix the pingroup name mismatch between drivers and dts

Ben Skeggs (3):
      drm/nouveau: fix locking issues in page flipping paths
      drm/nv50/kms: fix pin refcnt leaks
      drm/nouveau: use dedicated channel for async moves on GT/GF chipsets.

Bjorn Helgaas (1):
      powerpc/powernv: Mark pnv_pci_init_ioda2_phb() as __init

Bjørn Mork (1):
      usb: option: add TP-LINK MA260

Boris BREZILLON (2):
      usb: gadget: at91_udc: prepare clk before calling enable
      ASoC: atmel-ssc: remove clk_disable_unprepare call from critical section

Borislav Petkov (1):
      EDAC: Fix lockdep splat

Catalin Marinas (1):
      arm64: Fix definition of arm_pm_restart to match the declaration

Chen Gang (2):
      alpha: kernel: using memcpy() instead of strcpy()
      alpha: kernel: typo issue, using '1' instead of '11'

Chih-Chung Chang (1):
      ASoC: max98088 - fix element type of the register cache.

Chris Wilson (2):
      drm/i915: Fix dereferencing invalid connectors in is_crtc_connector_off()
      drm/i915: Serialize almost all register access

Dan Carpenter (5):
      bcache: check for allocation failures
      ASoC: core: double free in snd_soc_add_platform()
      staging: frontier: use after free in disconnect()
      staging: gdm72xx: potential use after free in send_qos_list()
      TTY: snyclinkmp: calculating wrong addresses

Dan Williams (1):
      usb: serial: option: add Olivetti Olicard 200

Daniel Vetter (7):
      drm/i915: fix up readout of the lvds dither bit on gen2/3
      drm/i915: fix pfit regression for non-autoscaled resolutions
      drm/i915: Sanitize shared dpll state
      drm/i915: correctly restore fences with objects attached
      drm/i915: fix up gt init sequence fallout
      drm/crtc-helper: explicit DPMS on after modeset
      drm/i915: fix hdmi portclock limits

Daniil Bolsun (1):
      USB: option: append Petatel NP10T device to GSM modems list

Dave Airlie (3):
      drm/qxl: add delayed fb operations
      qxl: allow creation of pre-pinned objects and use for releases.
      qxl: convert qxl driver to proper use for reservations

Dave Chinner (1):
      xfs: di_flushiter considered harmful

David Howells (1):
      Fix __wait_on_atomic_t() to call the action func if the counter != 0

Denis Kirjanov (1):
      powerpc/pseries: Fix a typo in pSeries_lpar_hpte_insert()

Dirk Brandewie (1):
      cpufreq / intel_pstate: Change to scale off of max P-state

Eldad Zack (2):
      ALSA: usb-audio: 6fire: return correct XRUN indication
      ALSA: hiface: return correct XRUN indication

Enrico Mioso (3):
      usb: serial: option: Add ONYX 3G device support
      usb: serial: option: blacklist ONDA MT689DC QMI interface
      usb: serial: option.c: remove ONDA MT825UP product ID fromdriver

Ewan D. Milne (1):
      [SCSI] sd: fix crash when UA received on DIF enabled device

Fabio Estevam (2):
      ARM: dts: imx51-babbage: Pass a real clock to the codec
      ARM: multi_v7_defconfig: Select USB chipidea driver

Felipe Balbi (1):
      usb: dwc3: gadget: don't prevent gadget from being probed if we fail

Feng Kan (1):
      arm64: Change kernel stack size to 16K

Fernando Soto (1):
      Drivers: hv: vmbus: incorrect device name is printed when child
device is unregistered

Gabor Juhos (1):
      of: add vendor prefix for Qualcomm Atheros, Inc.

Gabriel de Perthuis (4):
      bcache: Warn when a device is already registered.
      bcache: Send a uevent with a cached device's UUID
      bcache: Send label uevents
      bcache: Refresh usage docs

Gavin Shan (11):
      powerpc/eeh: Remove reference to PCI device
      powerpc/eeh: Export functions for hotplug
      powerpc/pci: Override pcibios_release_device()
      powerpc/pci/hotplug: Don't need to remove from EEH cache twice
      powerpc/eeh: Keep PE during hotplug
      powerpc/eeh: Use safe list traversal when walking EEH devices
      powerpc/pci: Partial tree hotplug support
      powerpc/eeh: Use partial hotplug for EEH unaware drivers
      powerpc/eeh: Don't use pci_dev during BAR restore
      powerpc/eeh: Fix unbalanced enable for IRQ
      powerpc/eeh: Introdce flag to protect sysfs

Geert Uytterhoeven (4):
      usb: dwc3: USB_DWC3 should depend on HAS_DMA
      usb: gadget: USB_MV_UDC should depend on HAS_DMA
      usb: gadget: USB_FOTG210_UDC should depend on HAS_DMA
      usb: gadget: USB_MV_U3D should depend on HAS_DMA

George Cherian (1):
      usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all
controllers with xhci 1.0

Grant Likely (4):
      MAINTAINERS: Remove Grant Likely
      MAINTAINERS: Change device tree mailing list
      MAINTAINERS: Refactor device tree maintainership
      MAINTAINERS: Fix incorrect status tag

Guennadi Liakhovetski (2):
      pinctrl: sh-pfc: fix SDHI0 VccQ regulator on sh73a0 with DT
      dmaengine: shdma: fix a build failure on platforms with no DMA support

H Hartley Sweeten (1):
      ASoC: ep93xx: fix build of ep93xx-ac97.c

Harshula Jayasuriya (1):
      nfsd: nfsd_open: when dentry_open returns an error do not
propagate as struct file

Henrik Nordström (1):
      tty/8250_early: Don't truncate last character of options

Herbert Xu (1):
      Revert "crypto: crct10dif - Wrap crc_t10dif function all to use
crypto transform framework"

Huang Rui (1):
      usb: dwc3: fix wrong bit mask in dwc3_event_type

Ian Abbott (2):
      staging: comedi: COMEDI_CANCEL ioctl should wake up read/write
      staging: comedi: fix a race between do_cmd_ioctl() and read/write

Ian Campbell (1):
      pinctrl: am33xx dt binding: correct include path

James Bottomley (2):
      [SCSI] mvsas: Fix kernel panic on tile due to unaligned data access
      [SCSI] isci: fix breakage caused by >16byte CDB patch

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many
requests on the ring

Jani Nikula (1):
      drm/i915: initialize gt_lock early with other spin locks

Javier Martinez Canillas (3):
      gpio/omap: don't create an IRQ mapping for every GPIO on DT
      gpio/omap: auto request GPIO as input if used as IRQ via DT
      gpio/omap: fix build error when OF_GPIO is not defined.

Jean-Francois Moine (1):
      pinctrl: pinctrl-single: fix compile warning when no CONFIG_PM

Jeff Skirvin (1):
      [SCSI] isci: Fix a race condition in the SSP task management path

Jingoo Han (2):
      libata: replace strict_strtol() with kstrtol()
      staging: tidspbridge: replace strict_strtol() with kstrtos32()

Joe Perches (1):
      alpha: Convert print_symbol to %pSR

Johan Hovold (2):
      USB: ti_usb_3410_5052: fix dynamic-id matching
      USB: mos7840: fix memory leak in open

Jóhann B. Guðmundsson (1):
      USB: misc: Add Manhattan Hi-Speed USB DVI Converter to sisusbvga

K. Y. Srinivasan (3):
      Drivers: hv: balloon: Fix a bug in the hot-add code
      Drivers: hv: balloon: Do not post pressure status if interrupted
      Tools: hv: KVP: Fix a bug in IPV6 subnet enumeration

Kamal Mostafa (1):
      drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight

Karlis Ogsts (1):
      staging: android: logger: Correct write offset reset on error

Kent Overstreet (21):
      bcache: fix a spurious gcc complaint, use scnprintf
      bcache: Convert allocator thread to kthread
      bcache: Refactor btree io
      bcache: Fix/revamp tracepoints
      bcache: Rip out pkey()/pbtree()
      bcache: Improve lazy sorting
      bcache: Initialize sectors_dirty when attaching
      bcache: Track dirty data by stripe
      bcache: Write out full stripes
      bcache: FUA fixes
      bcache: Document shrinker reserve better
      bcache: Delete fuzz tester
      bcache: Update email address
      bcache: Use standard utility code
      bcache: Fix a dumb race
      bcache: Advertise that flushes are supported
      bcache: Fix a sysfs splat on shutdown
      bcache: Shutdown fix
      bcache: Journal replay fix
      bcache: Fix GC_SECTORS_USED() calculation
      bcache: Allocation kthread fixes

Konrad Rzeszutek Wilk (4):
      xen-blkfront: Introduce a 'max' module parameter to alter the
amount of indirect segments.
      xen-blkback/sysfs: Move the parameters for the persistent grant features
      xen/blkback: Check device permissions before allowing OP_DISCARD
      xen/blkback: Check for insane amounts of request on the ring (v6).

Konstantin Khlebnikov (1):
      drm/i915: fix long-standing SNB regression in power consumption
after resume v2

Kukjin Kim (1):
      ARM: EXYNOS: skip pm support on exynos5440

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

Kuninori Morimoto (1):
      usb: renesas_usbhs: gadget: remove extra check on udc_stop

Laurent Pinchart (1):
      ARM i.MX53: mba53: Fix PWM backlight DT node

Lidza Louina (1):
      MAINTAINERS: Update the list of maintainers for staging/comedi driver.

Linus Torvalds (1):
      Linux 3.11-rc3

Linus Walleij (3):
      ARM: nomadik: update defconfig base
      ARM: nomadik: configure for NO_HZ and HRTIMERS
      pinctrl: fix a memleak when freeing maps

Liu Ying (1):
      ARM: i.MX6Q: correct emi_sel clock muxing

Luiz Angelo Daros de Luca (1):
      usb: serial: cp210x: Add USB ID for Netgear Switches embedded
serial adapter

Maarten Lankhorst (5):
      drm/nouveau: fix some error-path leaks in fbcon handling code
      drm/nouveau: do not unpin in nouveau_gem_object_del
      drm/nouveau: bump fence timeout to 15 seconds
      drm/nouveau: add falcon interrupt handler
      drm/nouveau: do not allow negative sizes for now

Mahesh Salgaonkar (1):
      powerpc: Fix the corrupt r3 error during MCE handling.

Mark Kettenis (1):
      drm/radeon: fix combios tables on older cards

Mark Rutland (1):
      arm64: virt: ensure visibility of __boot_cpu_mode

Markus Pargmann (1):
      ARM: imx27: Fix documentation for SPLL clock

Masami Hiramatsu (1):
      tracing/kprobe: Wait for disabling all running kprobe handlers

Masanari Iida (1):
      doc: Fix typo in documentation/bcache.txt

Michael Ellerman (1):
      powerpc/perf: Set PPC_FEATURE2_EBB when we register the power8 PMU

Michael Neuling (1):
      powerpc: Add second POWER8 PVR entry

Mike Frysinger (1):
      ARM: footbridge: fix overlapping PCI mappings

Miklos Szeredi (4):
      fuse: readdirplus: sanity checks
      fuse: readdirplus: fix instantiate
      fuse: readdirplus: change attributes once
      fuse: readdirplus: cleanup

NeilBrown (2):
      md/raid10: remove use-after-free bug.
      md/raid5: fix interaction of 'replace' and 'recovery'.

Niels de Vos (1):
      fuse: readdirplus: fix dentry leak

Oleg Nesterov (14):
      tracing/function: Avoid perf_trace_buf_*() if
event_function.perf_events is empty
      tracing/syscall: Avoid perf_trace_buf_*() if
sys_data->perf_events is empty
      tracing/perf: Move the PERF_MAX_TRACE_SIZE check into
perf_trace_buf_prepare()
      tracing: Simplify the iteration logic in f_start/f_next
      tracing: Do not (ab)use trace_seq in event_id_read()
      tracing: Kill trace_array->waiter
      tracing: Kill the unbalanced tr->ref++ in tracing_buffers_open()
      tracing: Introduce trace_create_cpu_file() and tracing_get_cpu()
      tracing: Change tracing_pipe_fops() to rely on tracing_get_cpu()
      tracing: Change tracing_buffers_fops to rely on tracing_get_cpu()
      tracing: Change tracing_stats_fops to rely on tracing_get_cpu()
      tracing: Change tracing_entries_fops to rely on tracing_get_cpu()
      tracing: Change tracing_fops/snapshot_fops to rely on tracing_get_cpu()
      tracing: Kill trace_cpu struct/members

Oleksij Rempel (1):
      xhci: fix null pointer dereference on ring_doorbell_for_active_rings

Olof Johansson (3):
      ARM: omap5: Only select errata 798181 if SMP
      usb: xhci: Mark two functions __maybe_unused
      mfd: max8925: fix dt code for backlight

Ondrej Zary (1):
      drm/radeon: Another card with wrong primary dac adj

Paul Bolle (2):
      staging: drm/imx: drop "select OF_VIDEOMODE"
      powerpc/pseries: Drop "select HOTPLUG"

Philip J Kelleher (11):
      rsxx: Individual workqueues for interruptible events.
      rsxx: Restructured DMA cancel scheme.
      rsxx: Fixes soft-lockup issues during DMAs.
      rsxx: Allow block size to be determined by configuration.
      rsxx: Adding in sync_start module paramenter.
      rsxx: Changing the adapter name to the official name.
      rsxx: Fixes DLPAR add kernel panic if partition still mounted.
      rsxx: Adapter address space sanity check.
      rsxx: Adding EEH check inside cregs timeout.
      rsxx: Fixes incorrect stats calculation.
      rsxx: Adding in debugfs entries.

Philipp Reisner (3):
      drbd: Ignore the exit code of a fence-peer handler if it returns too late
      drbd: Constants should be UPPERCASE
      drbd: Allow online change of al-stripes and al-stripe-size

Philipp Zabel (2):
      ARM i.MX53: Fix UART pad configuration
      ARM i.MX6Q: Fix IOMUXC GPR1 defines for ENET_CLK_SEL and IPU1/2_MUX

Qipan Li (2):
      pinctrl: sirf: fix the pin number and mux bit for usp0
      pinctrl: sirf: add usp0_uart_nostreamctrl pin group for usp-uart
without flowctrl

Rafael J. Wysocki (1):
      Revert "ACPI / video / i915: No ACPI backlight if firmware
expects Windows 8"

Randy Dunlap (1):
      usb: fix build warning in pci-quirks.h when CONFIG_PCI is not enabled

Ren Bigcren (1):
      USB: storage: Add MicroVault Flash Drive to unusual_devs

Richard Henderson (10):
      alpha: Add kcmp and finit_module syscalls
      alpha: Modernize lib/mpi/longlong.h
      alpha: Improve atomic_add_unless
      alpha: Implement atomic64_dec_if_positive
      alpha: Generate dwarf2 unwind info for various kernel entry points.
      alpha: Fix type compatibility warning for marvel_map_irq
      alpha: Use __builtin_alpha_rpcc
      alpha: Don't if-out dp264_device_interrupt.
      alpha: Force the user-visible HZ to a constant 1024.
      alpha: Use handle_percpu_irq for the timer interrupt

Richard Zhao (2):
      ASoC: tegra: correct playback_dma_data setup
      serial: tegra: correct help message in Kconfig from 'ttyHS' to 'ttyTHS'

Richard Zhu (2):
      ARM: imx6q: update the sata bits definitions of gpr13
      ahci_imx: add ahci sata support on imx platforms

Rob Herring (1):
      ARM: highbank: Only touch common coherency control register fields

Roger Pau Monne (12):
      xen-blkback: print stats about persistent grants
      xen-blkback: use balloon pages for all mappings
      xen-blkback: implement LRU mechanism for persistent grants
      xen-blkback: move pending handles list from blkbk to pending_req
      xen-blkback: make the queue of free requests per backend
      xen-blkback: expand map/unmap functions
      xen-block: implement indirect descriptors
      xen-blkback: allocate list of pending reqs in small chunks
      xen-blkfront: use a different scatterlist for each request
      xen-blkback: workaround compiler bug in gcc 4.1
      xen-blkfront: set blk_queue_max_hw_sectors correctly
      xen-blkback: check the number of iovecs before allocating a bios

Roger Quadros (2):
      ARM: OMAP2+: Provide alias to USB PHY clock
      USB: EHCI: Fix resume signalling on remote wakeup

Rohit Vaswani (1):
      drivers: gpio: msm: Fix the error condition for reading ngpio

Ruchika Kharwar (2):
      usb: dwc3: fix the error returned with usb3_phy failure
      usb: phy: omap-usb3: fix dpll clock index

Sachin Kamat (2):
      usb: phy: samsung: Fix an error message typo
      ARM: EXYNOS: Update CONFIG_ARCH_NR_GPIO for Exynos

Sami Rahman (1):
      USB: cp210x: add MMB and PI ZigBee USB Device Support

Sarah Sharp (1):
      xhci: Avoid NULL pointer deref when host dies.

Saurav Kashyap (1):
      [SCSI] qla2xxx: Properly set the tagging for commands.

Sebastian Andrzej Siewior (1):
      of/irq: init struct resource to 0 in of_irq_to_resource()

Sekhar Nori (2):
      ARM: davinci: make file local variables static
      ARM: davinci: defconfig: enable EDMA driver

Sergey Senozhatsky (1):
      staging: zram: protect zram_reset_device() call

Shawn Guo (3):
      ARM: mxs: saif0 is the clock provider to sgtl5000
      ARM: imx: fix vf610 enet module clock selection
      ASoC: sgtl5000: defer the probe if clock is not found

Srinivas Kandagatla (2):
      ARM: dts: STi: Fix pinconf setup for STiH416 serial2
      ARM: STi: Set correct ARM ERRATAs.

Srinivas Pandruvada (2):
      Thermal: x86 package temp thermal crash
      Thermal: x86_pkg_temp: Limit number of pkg temp zones

Stefan Bader (1):
      xen/blkback: Use physical sector size for setup

Steven Rostedt (1):
      Thermal: Fix lockup of cpu_down()

Steven Rostedt (Red Hat) (3):
      tracing: Add ref_data to function and fgraph tracer structs
      ftrace: Add check for NULL regs if ops has SAVE_REGS set
      tracing: Remove locking trace_types_lock from
tracing_reset_all_online_cpus()

Stéphane Marchesin (1):
      drm/i915: Preserve the DDI_A_4_LANES bit from the bios

Subash Patel (1):
      ARM: EXYNOS: change the PHYSMEM_BITS and SECTION_SIZE

Sylwester Nawrocki (1):
      ARM: S3C24XX: Add missing clkdev entries for s3c2440 UART

Takashi Iwai (2):
      ALSA: hda - Fix EAPD GPIO control for Sigmatel codecs
      ALSA: hda - Remove NO_PRESENCE bit override for Dell 1420n Laptop

Tejun Heo (4):
      cgroup: remove bcache_subsys_id which got added stealthily
      cgroup: replace task_cgroup_path_from_hierarchy() with task_cgroup_path()
      libata: make it clear that sata_inic162x is experimental
      ahci_imx: depend on CONFIG_MFD_SYSCON

Thomas Abraham (1):
      ARM: EXYNOS: Enable 64-bit DMA for EXYNOS5440 if LPAE is enabled

Tiejun Chen (1):
      powerpc: Access local paca after hard irq disabled

Tomas Winkler (4):
      mei: hbm: fix typo in error message
      mei: me: fix reset state machine
      mei: don't have to clean the state on power up
      mei: me: fix waiting for hw ready

Tony Lindgren (2):
      ARM: multi_v7: Enabled omap4430 sdp nfsroot
      ARM: dts: Add missing vmmc2 regulator for twl

Trond Myklebust (1):
      NFSv4: Fix brainfart in attribute length calculation

Tsugikazu Shibata (1):
      HOWTO ja_JP sync

Ulf Hansson (1):
      ARM: nomadik: Update MMC defconfigs

Vakul Garg (1):
      crypto: caam - Fixed the memory out of bound overwrite issue

Vincent Stehlé (2):
      ARM: keystone: fix compilation warning
      ARM: zynq: fix compilation warning

Wei Yongjun (4):
      drbd: fix error return code in drbd_init()
      Thermal: x86_pkg_temp: fix krealloc() misuse in in
pkg_temp_thermal_device_add()
      usb: gadget: mv_u3d_core: fix to pass correct device identity to
free_irq()
      ARM: edma: remove duplicated include from edma.c

Will Deacon (1):
      alpha: locks: remove unused arch_*_relax operations

William Gulland (1):
      usb: Clear both buffers when clearing a control transfer TT buffer.

Xiaotian Feng (1):
      ahci: fix Null pointer dereference in achi_host_active()

Yadwinder Singh Brar (2):
      ARM: SAMSUNG: Save/restore only selected uart's registers
      ARM: EXYNOS: Fix low level debug support

Youquan Song (1):
      ata: Fix DVD not dectected at some platform with Wellsburg PCH

Yuan-Hsin Chen (1):
      usb: gadget: fotg210-udc: remove __init and __exit

Zhangfei Gao (1):
      of: add vendor prefixes for hisilicon

zhangwei(Jovi) (3):
      tracing: Use correct config guard CONFIG_STACK_TRACER
      tracing: Use trace_seq_puts()/trace_seq_putc() where possible
      tracing: Typo fix on ring buffer comments
