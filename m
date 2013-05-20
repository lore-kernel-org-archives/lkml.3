Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab3ETVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 17:54:57 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35894 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3ETVyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 17:54:55 -0400
MIME-Version: 1.0
Date: Mon, 20 May 2013 14:54:53 -0700
X-Google-Sender-Auth: lzz2LLdjjJengNHV7XOYvdvn4g8
Message-ID: <CA+55aFy7yAEwx1tQo2Ni0VZvAx2Q2d06zWantv1OAmnd=vUhaw@mail.gmail.com>
Subject: Linux 3.10-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been just over a week, and -rc2 is out.

For being an -rc2, it's not unreasonably sized, but I did take a few
pulls that I wouldn't have taken later in the rc series. So it's not
exactly small either. We've got arch updates (PPC, MIPS, PA-RISC),
we've got driver fixes (net, gpu, target, xen), and we've got
filesystem updates (btrfs, ext4 and cepth - rbd).

And various random small fixes. Shortlog appended, it should get
smaller and more readable going forward.

             Linus

---

Alasdair G Kergon (1):
      dm thin: fix metadata dev resize detection

Alex Elder (33):
      rbd: fix leak of format 2 snapshot context
      rbd: revalidate only for mapping size changes
      rbd: update capacity in rbd_dev_refresh()
      rbd: kill rbd_update_mapping_size()
      rbd: don't print warning if not mapping a parent
      rbd: don't look up snapshot id in rbd_dev_mapping_set()
      rbd: kill rbd_dev_clear_mapping()
      rbd: always set read-only flag in rbd_add()
      rbd: set the mapping size and features later
      rbd: zero format 1 header structure earlier
      rbd: refactor rbd_header_from_disk()
      rbd: update in-core header directly
      rbd: simplify rbd_dev_v1_probe()
      rbd: get rid of trivial v1 header wrappers
      rbd: define rbd_dev_v2_header_info()
      rbd: fix an incorrect assertion condition
      rbd: support reading parent page data
      rbd: set mapping read-only flag in rbd_add()
      rbd: only set up watch for mapped images
      rbd: kill rbd_img_request_get()
      libceph: init sent and completed when starting
      rbd: fix parent request size assumption
      rbd: support reading parent page data for writes
      rbd: ignore zero-overlap parent
      rbd: get parent info on refresh
      rbd: don't release write request until necessary
      rbd: define rbd_dev_unparent()
      rbd: define parent image request routines
      rbd: reference count parent requests
      rbd: detect when clone image is flattened
      rbd: re-submit read request for flattened clone
      rbd: re-submit write request for flattened clone
      rbd: re-submit flattened write request (part 2)

Alex Hung (1):
      ACPI video: ignore BIOS initial backlight value for HP 1000

Alexander Gordeev (1):
      powerpc: Fix irq_set_affinity() return values

Alexander Shiyan (1):
      cpufreq: Fix incorrect dependecies for ARM SA11xx drivers

Alexandre Oliva (1):
      btrfs: do away with non-whole_page extent I/O

Alexandru Gheorghiu (1):
      drivers: char: ipmi: Replaced kmalloc and strcpy with kstrdup

Alistair Popple (1):
      powerpc: Add an in memory udbg console

Amerigo Wang (2):
      virtio_net: use default napi weight by default
      ipv6,gre: do not leak info to user-space

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Andreas Larsson (2):
      spi: Initialize cs_gpio and cs_gpios with -ENOENT
      spi: Return error from of_spi_register_master on bad "cs-gpios" property

Andreas Philipp (1):
      Correct allowed raid levels on balance.

Andy Grover (3):
      target: Remove unused struct members in se_dev_entry
      target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio
      target: Have dev/enable show if TCM device is configured

Aneesh Kumar K.V (2):
      powerpc/mm: Use the correct mask value when looking at pgtable address
      powerpc: Fix build errors STRICT_MM_TYPECHECKS

Anton Blanchard (1):
      powerpc/kexec: Fix kexec when using VMX optimised memcpy

Antonio Quartulli (2):
      batman-adv: make DAT drop ARP requests targeting local clients
      batman-adv: reorder clean up routine in order to avoid race conditions

Axel Lin (3):
      ASoC: da7213: Fix setting dmic_samplephase and dmic_clk_rate
      hwmon: (iio_hwmon) Fix missing iio_channel_release_all call if
devm_kzalloc fail
      hwmon: (iio_hwmon) Fix null pointer dereference

Ben Widawsky (1):
      Revert "drm/i915: Calculate correct stolen size for GEN7+"

Benjamin Herrenschmidt (5):
      powerpc/powernv: Properly drop characters if console is closed
      powerpc/powernv: Improve kexec reliability
      powerpc/powernv: Detect OPAL v3 API version
      powerpc/powernv: Fix starting of secondary CPUs on OPALv2 and v3
      powerpc: Set show_unhandled_signals to 1 by default

Benjamin LaHaise (1):
      ipmi: ipmi_devintf: compat_ioctl method fails to take ipmi_mutex

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Borislav Petkov (2):
      cpufreq, ondemand: Remove leftover debug line
      PM / hibernate: Correct documentation

Catalin Marinas (3):
      arm64: Invoke the of_platform_populate() at arch_initcall() level
      arm64: Do not source kernel/time/Kconfig explicitly
      ACPI / scan: Fix memory leak on acpi_scan_init_hotplug() error path

Chen Gang (2):
      arm64: Fix duplicate definition of early_console
      drivers/char/ipmi: memcpy, need additional 2 bytes to avoid
memory overflow

Chris Cummins (1):
      drm: Use names of ioctls in debug traces

Chris Mason (1):
      Btrfs: use a btrfs bioset instead of abusing bio internals

Chris Wilson (1):
      drm/i915: Always normalize return timeout for wait_timeout_ioctl

Christopher Harvey (4):
      drm/mgag200: Don't change unrelated registers during modeset
      drm/mgag200: Fix writes into MGA1064_PIX_CLK_CTL register
      drm/mgag200: Convert counter delays to jiffies
      drm/mgag200: Fix framebuffer base address programming

Cong Wang (1):
      xfrm6: release dev before returning error

Corey Minyard (1):
      ipmi: Improve error messages on failed irq enable

Damien Lespiau (2):
      drm: Add missing break in the command line mode parsing code
      drm: Don't prune modes loudly when a connector is disconnected

Dan Carpenter (3):
      xen/privcmd: fix condition in privcmd_close()
      ntb: off by one sanity checks
      NTB: fix pointer math issues

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

Daniel Tang (1):
      ARM: 7712/1: Remove trailing whitespace in arch/arm/Makefile

Daniel Vetter (3):
      drm/mm: fix dump table BUG
      drm: don't check modeset locks in panic handler
      Revert "drm/i915: revert eDP bpp clamping code changes"

Dave Airlie (6):
      drm: remove unused wrapper macros
      drm/qxl: fix ioport interactions for kernel submitted commands.
      qxl: drop unused variable.
      drm/qxl: drop active_user_framebuffer as its unneeded
      qxl: fix bug with object eviction and update area
      drm/radeon: restore nomodeset operation (v2)

Dave Jones (1):
      Add missing module license tag to vring helpers.

David Daney (3):
      Revert "MIPS: microMIPS: Support dynamic ASID sizing."
      Revert "MIPS: Allow ASID size to be determined at boot time."
      MIPS: Make virt_to_phys() work for all unmapped addresses.

David Henningsson (1):
      ALSA: hda - Add headset mic support for another Dell machine

David Sterba (1):
      btrfs: annotate quota tree for lockdep

David Woodhouse (1):
      powerpc: Provide __bswapdi2

Denis Efremov (2):
      ipv4: ip_output: remove inline marking of EXPORT_SYMBOL functions
      MIPS: MSP71xx: remove inline marking of EXPORT_SYMBOL functions

Dirk Brandewie (5):
      cpufreq / intel_pstate: remove idle time and duration from
sample and calculations
      cpufreq / intel_pstate: use lowest requested max performance
      cpufreq / intel_pstate: fix ffmpeg regression
      cpufreq / intel_pstate: Remove idle mode PID
      cpufreq / intel_pstate: remove #ifdef MODULE compile fence

Eric Dumazet (1):
      ipv6: do not clear pinet6 field

EunBong Song (1):
      MIPS: Fix build error for crash_dump.c in 3.10-rc1

Fabio Baltieri (1):
      ASoC: ux500: Swap even/odd AD slot definitions

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Gabriel de Perthuis (1):
      btrfs: don't stop searching after encountering the wrong item

Geert Uytterhoeven (7):
      iscsi-target: Make buf param of iscsit_do_crypto_hash_buf() const void *
      net/ethernet: NET_CALXEDA_XGMAC should depend on HAS_DMA
      net/ethernet: STMMAC_ETH should depend on HAS_DMA
      net/wireless: ATH9K should depend on HAS_DMA
      net/ethernet: ARM_AT91_ETHER should depend on HAS_DMA
      net/ethernet: MACB should depend on HAS_DMA
      caif: CAIF_VIRTIO should depend on HAS_DMA

Guenter Roeck (2):
      hwmon: (nct6775) Do not create non-existing attributes
      MAINTAINERS: Add myself as maintainer for LM95234 and TMP401 drivers

Helge Deller (2):
      parisc: implement irq stacks - part 2 (v2)
      parisc: make default cross compiler search more robust (v3)

Himanshu Madhani (2):
      qlcnic: Fix missing bracket in module parameter.
      qlcnic: Fix ethtool supported port status for 83xx

Imre Deak (1):
      drm/i915: hsw: fix link training for eDP on port-A

Jaccon Bastiaansen (1):
      ARM: 7720/1: ARM v6/v7 cmpxchg64 shouldn't clear upper 32 bits
of the old/new value

Jan Kara (1):
      jbd,jbd2: fix oops in jbd2_journal_put_journal_head()

Jan-Simon Möller (1):
      ACPI: Fix section to __init. Align with usage in acpixf.h

Jani Nikula (1):
      drm/i915: clear the stolen fb before resuming

Jean Delvare (1):
      hwmon: (tmp401) Drop redundant safety on cache lifetime

Jiri Olsa (2):
      perf: Fix EXIT event notification
      perf: Factor out auxiliary events notification

Jiri Pirko (1):
      macvlan: fix passthru mode race between dev removal and rx path

Joachim Eastwood (1):
      spi/atmel: fix speed_hz check in atmel_spi_transfer()

Joern Engel (2):
      target: removed unused transport_state flag
      target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

John David Anglin (1):
      parisc: fix SMP races when updating PTE and TLB entries in entry.S

John Stultz (1):
      time: Revert ALWAYS_USE_PERSISTENT_CLOCK compile time optimizaitons

Jon Mason (8):
      NTB: variable dereferenced before check
      NTB: Handle 64bit BAR sizes
      NTB: Link toggle memory leak
      NTB: reset tx_index on link toggle
      NTB: Correctly handle receive buffers of the minimal size
      NTB: memcpy lockup workaround
      ntb_netdev: remove from list on exit
      NTB: Multiple NTB client fix

Joonsoo Kim (1):
      workqueue: correct handling of the pool spin_lock

Josef Bacik (4):
      Btrfs: don't null pointer deref on abort
      Btrfs: remove warn on in free space cache writeout
      Btrfs: handle running extent ops with skinny metadata
      Btrfs: make sure roots are assigned before freeing their nodes

Kees Cook (2):
      drm: refactor call to request_module
      drm/radeon: check incoming cliprects pointer

Kevin Hilman (1):
      idle: Fix hlt/nohlt command-line handling in new generic idle

Konrad Rzeszutek Wilk (10):
      x86/microcode: Add local mutex to fix physical CPU hot-add deadlock
      xen/tmem: Cleanup. Remove the parts that say temporary.
      xen/tmem: Move all of the boot and module parameters to the top
of the file.
      xen/tmem: Split out the different module/boot options.
      xen/tmem: Fix compile warning.
      xen/tmem: s/disable_// and change the logic.
      xen/tmem: Remove the boot options and fold them in the tmem.X parameters.
      xen/tmem: Remove the usage of 'noselfshrink' and use
'tmem.selfshrink' bool instead.
      xen/tmem: Remove the usage of '[no|]selfballoon' and use
'tmem.selfballooning' bool instead.
      xen/tmem: Don't use self[ballooning|shrinking] if frontswap is off.

Lachlan McIlroy (1):
      ext4: limit group search loop for non-extent files

Lan Tianyu (2):
      ACPI / EC: Restart transaction even when the IBF flag set
      ACPI / AC: Add sleep quirk for Thinkpad e530

Laurent Pinchart (2):
      pinctrl: generic: Fix typos and clarify comments
      pinctrl/lantiq: Free mapping configs for both pin and groups

Lee Jones (3):
      ARM: 7714/1: mmc: mmci: Ensure return value of
regulator_enable() is checked
      pinctrl: abx500: Specify failed sub-driver by ID instead of driver_data
      pinctrl: abx500: Rejiggle platform data and DT initialisation

Lespiau, Damien (2):
      drm: Make the HPD status updates debug logs more readable
      drm: Only print a debug message when the polled connector has changed

Li Zhong (6):
      powerpc: Fix MAX_STACK_TRACE_ENTRIES too low warning again
      powerpc: Syscall hooks for context tracking subsystem
      powerpc: Exception hooks for context tracking subsystem
      powerpc: Exit user context on notify resume
      powerpc: Use the new schedule_user API on userspace preemption
      powerpc: select HAVE_CONTEXT_TRACKING for pSeries

Libo Chen (1):
      MIPS: Xway: Fix clk leak

Linus Torvalds (2):
      x86: Fix bit corruption at CPU resume time
      Linux 3.10-rc2

Lisa Nguyen (3):
      xen/xenbus: Fixed indentation error in switch case
      xen/xenbus: Fixed over 80 character limit issue
      xen: Fixed assignment error in if statement

Liu Bo (2):
      Btrfs: fix off-by-one in fiemap
      Btrfs: return errno if possible when we fail to allocate memory

Luiz Capitulino (1):
      package: Makefile: unbreak binrpm-pkg target

Manish Chopra (2):
      qlcnic: Fix setting MAC address
      qlcnic: Fix bug in diagnostics test reset recovery path

Manjunathappa, Prakash (1):
      spi/davinci: fix module build error

Marc Dionne (1):
      workqueue: Make schedule_work() available again to non GPL modules

Marek Lindner (2):
      batman-adv: check proto length before accessing proto string buffer
      batman-adv: check return value of pskb_trim_rcsum()

Masami Hiramatsu (3):
      tracing/kprobes: Use rcu_dereference_raw for tp->files
      tracing/kprobes: Fix a sparse warning for incorrect type in assignment
      tracing/kprobes: Make print_*probe_event static

Matthijs Kooijman (1):
      MIPS: ralink: use the dwc2 driver for the rt305x USB controller

Miao Xie (10):
      Btrfs: don't abort the current transaction if there is no enough
space for inode cache
      Btrfs: don't use global block reservation for inode cache truncation
      Btrfs: optimize the error handle of use_block_rsv()
      Btrfs: don't steal the reserved space from the global reserve if
their space type is different
      Btrfs: update the global reserve if it is empty
      Btrfs: fix accessing a freed tree root
      Btrfs: fix unprotected root node of the subvolume's inode rb-tree
      Btrfs: pause the space balance when remounting to R/O
      Btrfs: remove BUG_ON() in btrfs_read_fs_tree_no_radix()
      Btrfs: don't invoke btrfs_invalidate_inodes() in the spin lock context

Michael Ellerman (2):
      powerpc: Make CONFIG_RTAS_PROC depend on CONFIG_PROC_FS
      ALSA: snd-aoa: Add a layout entry for PowerBook6,5

Michael Neuling (3):
      powerpc/perf: Move BHRB code into CONFIG_PPC64 region
      powerpc/pmu: Fix order of interpreting BHRB target entries
      powerpc/perf: Fix setting of "to" addresses for BHRB

Nicholas Bellinger (5):
      iscsi-target: Fix NULL pointer dereference in iscsit_send_reject
      target/rd: Add ramdisk bit for NULLIO operation
      iscsi-target: Fix typos in RDMAEXTENSIONS macro usage
      MAINTAINERS: Update target git tree URL
      target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression

Nicolas Pitre (1):
      ARM: 7715/1: MCPM: adapt to GIC changes after upstream merge

Nishanth Menon (1):
      cpufreq: cpufreq-cpu0: defer probe when regulator is not ready

Oleg Nesterov (1):
      usermodehelper: check subprocess_info->path != NULL

Or Gerlitz (1):
      net/mlx4_core: Add missing report on VST and spoof-checking dev caps

Paul Bolle (1):
      sound: Fix make allmodconfig on MIPS correctly

Paul E. McKenney (2):
      kthread: Document ways of reducing OS jitter due to per-CPU kthreads
      rcu: Fix comparison sense in rcu_needs_cpu()

Petri Gynther (1):
      emac: Fix EMAC soft reset on 460EX/GT

Rafael J. Wysocki (1):
      ACPI / PM: Move processor suspend/resume to syscore_ops

Rahul Sharma (1):
      of/documentation: move video device bindings to a common place

Rajesh Borundia (2):
      qlcnic: Fix mailbox response handling.
      qlcnic: Fix validation of link event command.

Richard Genoud (1):
      spi/spi-atmel: BUG: fix doesn' support 16 bits transfers using PIO

Robert Jennings (1):
      powerpc: Bring all threads online prior to migration/hibernation

Rony Efraim (1):
      net/mlx4: Strengthen VLAN tags/priorities enforcement in VST mode

Russell King (1):
      ARM: finally enable IRQ time accounting config

Rusty Russell (1):
      lguest: clear cached last cpu when guest_set_pgd() called.

Sasha Levin (1):
      rcu: Don't allocate bootmem from rcu_init()

Scott Wood (2):
      powerpc: hard_irq_disable(): Call trace_hardirqs_off after disabling
      powerpc/booke64: Fix kernel hangs at kernel_dbg_exc

Sebastian Hesselbarth (1):
      ARM: 7711/1: dove: fix Dove cpu type from V7 to PJ4

Sergei Shtylyov (2):
      <linux/of_platform.h>: fix compilation warnings with DT disabled
      3c59x: fix PCI resource management

Shahed Shaikh (1):
      qlcnic: Fix ethtool strings

Shawn Guo (1):
      net: fec: enable hardware checksum only on imx6q-fec

Shlomo Pongratz (1):
      iscsi-target: Fix processing of OOO commands

Shuah Khan (1):
      PM: Avoid calling kfree() under spinlock in dev_pm_put_subsys_data()

Sony Chacko (1):
      qlcnic: Fix reset recovery after transmit timeout

Srivatsa S. Bhat (2):
      rcu/idle: Wrap cpu-idle poll mode within rcu_idle_enter/exit
      cpufreq: Preserve sysfs files across suspend/resume

Stanislaw Gruszka (2):
      ath5k: do not reschedule tx_complete_work on stop
      iwl4965: workaround connection regression on passive channel

Stefan Behrens (3):
      Btrfs: don't allow device replace on RAID5/RAID6
      Btrfs: fix possible memory leak in replace_path()
      Btrfs: explicitly use global_block_rsv for quota_tree

Stefano Stabellini (3):
      xen/arm: initialize pm functions later
      xen/arm: do not handle VCPUOP_register_vcpu_info failures
      xen/arm: rename xen_secondary_init and run it on every online cpu

Steven Rostedt (2):
      kmemleak: Scan all allocated, writeable and not executable module sections
      kmemleak: No need for scanning specific module sections

Steven Rostedt (Red Hat) (1):
      tracing: Fix leaks of filter preds

Sujith Manoharan (2):
      ath9k: Fix beacon reconfiguration
      ath9k: Update initvals for AR9565

Sukanto Ghosh (1):
      arm64: mm: Fix operands of clz in __flush_dcache_all

Takashi Iwai (1):
      ALSA: hda - Check the activity of the NID to be powered down

Tang Yuantian (1):
      of/base: release the node correctly in of_parse_phandle_with_args()

Tejun Heo (2):
      workqueue: workqueue_congested() shouldn't translate
WORK_CPU_UNBOUND into node number
      workqueue: don't perform NUMA-aware allocations on offline nodes
in wq_numa_init()

Thadeu Lima de Souza Cascardo (1):
      qlge: fix dma map leak when the last chunk is not allocated

Theodore Ts'o (1):
      ext4: revert "ext4: use io_end for multiple bios"

Thomas Gleixner (4):
      tick: Use zalloc_cpumask_var for allocating offstack cpumasks
      x86: Fix idle consolidation fallout
      tick: Cleanup NOHZ per cpu data on cpu down
      tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

Tirupathi Reddy (1):
      timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

Tony Prisk (1):
      pinctrl: vt8500: Fix incorrect data in WM8750 pinctrl table

Tony Wu (2):
      MIPS: Fix sibling call handling in get_frame_info
      MIPS: Extract schedule_mfi info from __schedule

Torstein Hegge (1):
      ALSA: usb-audio: proc: use found syncmaxsize to determine feedback format

Uwe Kleine-König (1):
      Documentation/devicetree: make semantic of initrd-end more explicit

Vasant Hegde (1):
      powerpc/rtas_flash: Fix validate_flash buffer overflow issue

Ville Syrjälä (3):
      drm/i915: Fix pipe enabled mask for pipe C in WM calculations
      drm: Add kernel-doc for drm_fb_helper_funcs->initial_config
      drm: Remove pointless '-' characters from drm_fb_helper documentation

Viresh Kumar (9):
      cpufreq: ARM big LITTLE: Select PM_OPP
      cpufreq: ARM big LITTLE DT: Return correct transition latency
      cpufreq: ARM big LITTLE DT: Return CPUFREQ_ETERNAL if
clock-latency isn't found
      cpufreq: ARM big LITTLE: Move cpu_to_cluster() to arm_big_little.h
      cpufreq: ARM big LITTLE: Improve print message
      cpufreq: governors: Fix CPUFREQ_GOV_POLICY_{INIT|EXIT} notifiers
      cpufreq: Issue CPUFREQ_GOV_POLICY_EXIT notifier before dropping
policy refcount
      cpufreq: cpufreq-cpu0: Free parent node for error cases
      cpufreq: ARM big LITTLE: Fix Kconfig entries

Wang Shilong (1):
      Btrfs: fix possible memory leak in the find_parent_nodes()

Wei Yongjun (5):
      ASoC: wm0010: fix error return code in wm0010_boot()
      hwmon: fix error return code in abituguru_probe()
      bna: add missing iounmap() on error in bnad_init()
      cpufreq / intel_pstate: use vzalloc() instead of vmalloc()/memset(0)
      pinctrl: single: fix error return code in pcs_parse_one_pinctrl_entry()

Will Deacon (2):
      arm64: debug: clear mdscr_el1 instead of taking the OS lock
      arm64: debug: fix mdscr.ss check when enabling debug exceptions

Wolfram Sang (34):
      cpufreq / kirkwood: don't check resource with devm_ioremap_resource
      drivers/ata: don't check resource with devm_ioremap_resource
      drivers/char/hw_random: don't check resource with devm_ioremap_resource
      drivers/cpufreq: don't check resource with devm_ioremap_resource
      drivers/dma: don't check resource with devm_ioremap_resource
      drivers/gpio: don't check resource with devm_ioremap_resource
      drivers/gpu/drm/exynos: don't check resource with devm_ioremap_resource
      drivers/gpu/host1x/drm: don't check resource with devm_ioremap_resource
      drivers/i2c/busses: don't check resource with devm_ioremap_resource
      drivers/memory: don't check resource with devm_ioremap_resource
      drivers/mfd: don't check resource with devm_ioremap_resource
      drivers/misc: don't check resource with devm_ioremap_resource
      drivers/mtd/nand: don't check resource with devm_ioremap_resource
      drivers/net/ethernet/renesas: don't check resource with
devm_ioremap_resource
      drivers/pinctrl: don't check resource with devm_ioremap_resource
      drivers/pwm: don't check resource with devm_ioremap_resource
      drivers/rtc: don't check resource with devm_ioremap_resource
      drivers/spi: don't check resource with devm_ioremap_resource
      drivers/staging/dwc2: don't check resource with devm_ioremap_resource
      drivers/staging/nvec: don't check resource with devm_ioremap_resource
      drivers/thermal: don't check resource with devm_ioremap_resource
      drivers/usb/chipidea: don't check resource with devm_ioremap_resource
      drivers/usb/gadget: don't check resource with devm_ioremap_resource
      drivers/usb/host: don't check resource with devm_ioremap_resource
      drivers/usb/phy: don't check resource with devm_ioremap_resource
      drivers/video/omap2: don't check resource with devm_ioremap_resource
      drivers/video/omap2/dss: don't check resource with devm_ioremap_resource
      drivers/w1/masters: don't check resource with devm_ioremap_resource
      drivers/watchdog: don't check resource with devm_ioremap_resource
      arch/arm/mach-tegra: don't check resource with devm_ioremap_resource
      arch/arm/plat-samsung: don't check resource with devm_ioremap_resource
      arch/mips/lantiq/xway: don't check resource with devm_ioremap_resource
      sound/soc/fsl: don't check resource with devm_ioremap_resource
      sound/soc/kirkwood: don't check resource with devm_ioremap_resource

Yan, Zheng (1):
      ext4: fix fio regression

Zhang Rui (2):
      PM: Documentation update for freeze state
      PM / Documentation: remove inaccurate suspend/hibernate
transition lantency statement

Zhang Yanfei (1):
      x86/mm: Add missing comments for initial kernel direct mapping
