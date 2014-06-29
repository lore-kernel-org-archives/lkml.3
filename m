Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaF2WFJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 18:05:09 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:46548 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaF2WFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 18:05:04 -0400
MIME-Version: 1.0
Date: Sun, 29 Jun 2014 15:05:02 -0700
X-Google-Sender-Auth: dz7t8ZVhutSflQ5Mp-SLJLn-sWU
Message-ID: <CA+55aFxEy9Ah3BHqeki0Bzy7vTYWR9VzYvOViSR14viD_HDj_Q@mail.gmail.com>
Subject: Linux 3.16-rc3
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're back on a Sunday release schedule, and things are looking
reasonably normal.

There's perhaps relatively less driver updates than usual, with most
of them being pretty small, but that is probably just a timing thing
(ie Greg didn't send his USB/staging changes this week, so driver
changes are mostly gpu, networking and sound).

As a result misc architecture updates (mips, powerpc, x86, arm)
dominate the diff, and there are various random other updates. We've
got filesystem updates (aio, nfs and ocfs2), a small batch of mm fixes
from Andrew, some networking stuff.etc.

The shortlog gives a feel for the changes. The most noticeable to
actual users are probably the unbreaking of direct block device read
accesses on 32-bit targets, and some x86 vdso regression fixes that
caused problems. The rest probably didn't end up affecting very many
people, but it's all proper fixes..

                     Linus

---

Aaron Tomlin (2):
      nmi: provide the option to issue an NMI back trace to every cpu
but current
      kernel/watchdog.c: print traces for all cpus on lockup detection

Abhilash Kesavan (1):
      ARM: EXYNOS: fix pm code to check for cortex A9 rather than the SoC

Al Viro (1):
      Fix 32-bit regression in block device read(2)

Alex Smith (1):
      recordmcount/MIPS: Fix possible incorrect mcount_loc table
entries in modules

Alexandre Belloni (5):
      ARM: at91/dt: sam9x5: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9n12: correct PLLA ICPLL and OUT values
      ARM: at91/dt: sam9261: correctly define mainck
      ARM: at91/dt: define sam9261ek slow crystal frequency
      ARM: at91/dt: sam9261: remove slow RC osc

Andrea Adami (2):
      ARM: 8084/1: sa1100: collie: revert back to cfi_probe
      ARM: 8085/1: sa1100: collie: add top boot mtd partition

Andrew Morton (1):
      ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h

Andrzej Hajda (1):
      drm/exynos: disable unused windows on apply

Andrzej Zaborowski (1):
      efi-pstore: Fix an overflow on 32-bit builds

Andy Adamson (3):
      NFS check the return of nfs4_negotiate_security in nfs4_submount
      NFS Return -EPERM if no supported or matching SECINFO flavor
      NFSv4: test SECINFO RPC_AUTH_GSS pseudoflavors for support

Andy Gross (2):
      spi: qup: Fix order of spi_register_master
      spi: qup: Remove chip select function

Andy Lutomirski (9):
      x86/vdso: Discard the __bug_table section
      x86/vdso2c: Use better macros for ELF bitness
      x86/vdso: Improve the fake section headers
      x86/vdso: Remove some redundant in-memory section headers
      x86/vdso: Create .build-id links for unstripped vdso files
      x86_32, entry: Do syscall exit work on badsys (CVE-2014-4508)
      x86_32, signal: Fix vdso rt_sigreturn
      x86/vdso: Move DISABLE_BRANCH_PROFILING into the vdso makefile
      x86/vdso: Error out in vdso2c if DT_RELA is present

Anton Kolesov (1):
      ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Arnd Bergmann (3):
      mfd: UCB1x00: Enable modular build
      mfd: STw481x: Allow modular build
      mfd: davinci: Voicecodec needs regmap_mmio

Axel Lin (1):
      hwmon: (w83l786ng) Report correct minimum fan speed

Benjamin Herrenschmidt (1):
      powerpc: Remove __arch_swab*

Benjamin LaHaise (2):
      aio: fix aio request leak when events are reaped by userspace
      aio: fix kernel memory disclosure in io_getevents() introduced in v3.10

Björn Baumbach (1):
      fs/cifs: fix regression in cifs_create_mf_symlink()

Bjørn Mork (1):
      net: huawei_cdc_ncm: increase command buffer size

Catalin Marinas (2):
      efi: Fix compiler warnings (unused, const, type)
      powerpc/kmemleak: Do not scan the DART table

Chen Gang (1):
      lib/Kconfig.debug: let FRAME_POINTER exclude SCORE, just like
exclude most of other architectures

Chew, Chiau Ee (1):
      spi/pxa2xx: fix incorrect SW mode chipselect setting for BayTrail LPSS SPI

Chin-Ran Lo (1):
      mwifiex: fix tx_info/rx_info overlap with PCIe dma_mapping

Chirantan Ekbote (1):
      clocksource: exynos_mct: Don't reset the counter during boot and resume

Chris Metcalf (1):
      net: tile: fix unused variable warning

Chris Wilson (2):
      drm/i915: Only mark the ctx as initialised after a SET_CONTEXT operation
      drm/i915: Hold the table lock whilst walking the file's idr and
counting the objects in debugfs

Christian Riesch (1):
      ptp: In the testptp utility, use clock_adjtime from glibc when available

Christoph Lameter (1):
      MAINTAINERS: SLAB maintainer update

Dan Carpenter (2):
      drm/exynos: change zero to NULL for sparse
      Documentation: add section about git to email-clients.txt

Daniel Borkmann (3):
      net: sctp: propagate sysctl errors from proc_do* properly
      net: sctp: check proc_dointvec result in proc_sctp_do_auth
      MIPS: BPF JIT: Fix build error.

Daniel Mack (3):
      net: phylib: add link_change_notify callback to phy device
      net: phy: at803x: use #defines for supported PHY ids
      net: phy: at803x: Add support for hardware reset

Dave Jones (2):
      tcp: remove unnecessary tcp_sk assignment.
      hyperv: fix apparent cut-n-paste error in send path teardown

David Henningsson (4):
      ALSA: hda - Fix usage of "model" module parameter
      ALSA: hda - Add pin quirk for Dell XPS 15
      ALSA: hda - Make a SND_HDA_PIN_QUIRK macro
      ALSA: hda - Make the pin quirk tables use the SND_HDA_PIN_QUIRK macro

David Rientjes (2):
      mm, hotplug: probe interface is available on several platforms
      mm, pcp: allow restoring percpu_pagelist_fraction default

David S. Miller (1):
      Revert "net: return actual error on register_queue_kobjects"

David Vrabel (2):
      xen-netfront: fix oops when disconnected from backend
      xen-netfront: recreate queues correctly when reconnecting

Denis Carikli (1):
      ARM: dts: imx51-eukrea-mbimxsd51-baseboard: unbreak esdhc.

Don Zickus (1):
      kernel/watchdog.c: remove preemption restrictions when
restarting lockup detector

Doug Anderson (1):
      ARM: EXYNOS: Don't rely on firmware's secondary_cpu_start for mcpm

Eric Dumazet (1):
      ipv4: fix dst race in sk_dst_get()

Ezequiel Garcia (2):
      ARM: mvebu: enable Dove SoC in mvebu_v7_defconfig
      ARM: mvebu: Fix broken SoC ID detection

Fabian Frederick (1):
      drm/msm: use PAGE_ALIGNED instead of IS_ALIGNED(PAGE_SIZE)

Fabio Estevam (2):
      ARM: 8068/1: scoop: Remove unused variable
      ARM: imx_v6_v7_defconfig: Enable CONFIG_IMX_IPUV3_CORE

Fengguang Wu (1):
      net: phy: at803x: fix coccinelle warnings

Florian Westphal (2):
      netfilter: ctnetlink: fix refcnt leak in dying/unconfirmed list dumper
      netfilter: nf_nat: fix oops on netns removal

Fugang Duan (3):
      ARM: imx6sl: add missing enet clock for imx6sl
      ARM: dts: imx6sl: correct the fec ipg clock source
      net: fec: Don't clear IPV6 header checksum field when IP
accelerator enable

Gavin Shan (1):
      powerpc/kerenl: Enable EEH for IO accessors

Graham Williams (1):
      regulator: bcm590xx: fix vbus name

Greg Kroah-Hartman (3):
      lzo: properly check for overruns
      lz4: ensure length does not wrap
      lz4: fix another possible overrun

Gregory CLEMENT (1):
      ARM: mvebu: Fix the improper use of the compatible string
armada38x using a wildcard

Grygorii Strashko (1):
      mfd: ab8500: Fix dt irq mapping

Gu Zheng (1):
      bio: remove unused macro bip_vec_idx()

Hugh Dickins (5):
      tmpfs: ZERO_RANGE and COLLAPSE_RANGE not currently supported
      mm: thp: fix DEBUG_PAGEALLOC oops in copy_page_rep()
      mm: let mm_find_pmd fix buggy race with THP fault
      shmem: fix faulting into a hole while it's punched
      mm: fix crashes from mbind() merging vmas

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

Imre Deak (1):
      drm/i915: cache hw power well enabled state

Inki Dae (1):
      drm/exynos: hdmi: fix power order issue

Jan Beulich (1):
      swiotlb: don't assume PA 0 is invalid

Jani Nikula (1):
      drm/i915: default to having backlight if VBT not available

Jean Delvare (3):
      isdn: hisax: Merge Kconfig ifs
      isdn: hisax: Drop duplicate Kconfig entry
      ptp: ptp_pch depends on x86_32

Jeff Layton (1):
      cifs: revalidate mapping prior to satisfying read_iter request
with cache=loose

Jens Axboe (4):
      Revert "block: add __init to blkcg_policy_register"
      Revert "block: add __init to elv_register"
      block: add support for limiting gaps in SG lists
      blk-mq: blk_mq_start_hw_queue() should use blk_mq_run_hw_queue()

Jiang Liu (1):
      iommu/vt-d: fix bug in handling multiple RMRRs for the same PCI device

Jie Liu (1):
      net: return actual error on register_queue_kobjects

Jiri Kosina (1):
      floppy: format block0 read error message properly

Joe Perches (1):
      checkpatch: reduce false positives when checking void function
return statements

Joerg Roedel (1):
      iommu/amd: Fix small race between invalidate_range_end/start

Johan Hedberg (9):
      Bluetooth: Fix incorrectly overriding conn->src_type
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Add clarifying comment for conn->auth_type
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Refactor discovery stopping into its own function
      Bluetooth: Reuse hci_stop_discovery function when cleaning up HCI state
      Bluetooth: Fix locking of hdev when calling into SMP code

Joonsoo Kim (2):
      slab: fix oops when reading /proc/slab_allocators
      DMA, CMA: fix possible memory leak

Josef Gajdusek (1):
      hwmon: (emc1403) Fix missing 'select REGMAP_I2C' in Kconfig

Jukka Taimisto (1):
      Bluetooth: Fix deadlock in l2cap_conn_del()

Julian Anastasov (1):
      ipvs: stop tot_stats estimator only under CONFIG_SYSCTL

Julien D'Ascenzio (1):
      hwmon: (gpio-fan) Change name used in hwmon_device_register_with_groups

Jürg Billeter (1):
      spi: sh-sci: fix use-after-free in sh_sci_spi_remove()

Keerthy (2):
      regulator: tps65218: Add the missing of_node assignment in probe
      regulator: tps65218: Correct the the config register for LDO1

Kees Cook (1):
      net: filter: fix upper BPF instruction limit

Ken-ichirou MATSUZAWA (1):
      netfilter: ctnetlink: add zone size to length

Kumar Gala (1):
      tty: serial: msm: Fix section mismatch warning

Lars Ellenberg (1):
      drbd: fix NULL pointer deref in blk_add_request_payload

Laura Abbott (1):
      ARM: 8086/1: Set memblock limit for nommu

Laurent Dufour (1):
      powerpc/module: Fix TOC symbol CRC

Lee Jones (1):
      ARM: stih41x: Rename stih416-b2020-revE.dts to stih416-b2020e.dts

Leela Krishna Amudala (1):
      ARM: EXYNOS: Use wfi macro in platform_do_lowpower

Levente Kurusa (1):
      TC: Handle device_register() errors.

Li RongQing (2):
      8021q: fix a potential memory leak
      cxgb4: Not need to hold the adap_rcu_lock lock when read adap_rcu_list

Linus Torvalds (1):
      Linux 3.16-rc3

Linus Walleij (1):
      ARM: integrator: fix OF-related regression

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Marek Vasut (2):
      ARM: dts: mx5: Fix IPU port node placement
      ARM: dts: mx5: Move the display out of soc {} node

Markos Chandras (18):
      MIPS: uasm: Add s3s1s2 instruction builder
      MIPS: uasm: Add SLT uasm instruction
      MIPS: mm: uasm: Fix lh micro-assembler instruction
      MIPS: bpf: Use the LO register to get division's quotient
      MIPS: bpf: Return error code if the offset is a negative number
      MIPS: bpf: Use 'andi' instead of 'and' for the VLAN cases
      MIPS: bpf: Add SEEN_SKB to flags when looking for the PKT_TYPE
      MIPS: bpf: Fix branch conditional for BPF_J{GT/GE} cases
      MIPS: bpf: Use correct mask for VLAN_TAG case
      MIPS: bpf: Fix return values for VLAN_TAG_PRESENT case
      MIPS: bpf: Use pr_debug instead of pr_warn for unhandled opcodes
      MIPS: bpf: Fix is_range() semantics
      MIPS: bpf: Drop update_on_xread and always initialize the X register
      MIPS: BPF: Prevent kernel fall over for >=32bit shifts
      MIPS: bpf: Fix PKT_TYPE case for big-endian cores
      MIPS: BPF: Use 32 or 64-bit load instruction to load an address
to register
      MIPS: bpf: Fix stack space allocation for BPF memwords on MIPS64
      MIPS: MSC: Prevent out-of-bounds writes to MIPS SC ioremap'd region

Matwey V. Kornilov (1):
      drm/msm: Replace type of paddr to uint32_t.

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Mengdong Lin (1):
      ALSA: hda - restore BCLK M/N values when resuming HSW/BDW
display controller

Michael Braun (2):
      rt2800usb:fix efuse detection
      rt2800usb:fix hang during firmware load

Michael Ellerman (9):
      powerpc: Remove ancient DEBUG_SIG code
      powerpc: Add ppc_global_function_entry()
      powerpc/ftrace: Fix typo in mask of opcode
      powerpc/ftrace: Fix inverted check of create_branch()
      powerpc/ftrace: Fix nop of modules on 64bit LE (ABIv2)
      powerpc/ftrace: Use pr_fmt() to namespace error messages
      powerpc/kprobes: Fix jprobes on ABI v2 (LE)
      selftests/powerpc: Use the test harness for the TM DSCR test
      powerpc/powernv: Remove OPAL v1 takeover

Michael S. Tsirkin (2):
      vhost-scsi: don't open-code kvfree
      iovec: move memcpy_from/toiovecend to lib/iovec.c

Micky Ching (1):
      drivers/memstick/host/rtsx_pci_ms.c: add cancel_work when remove driver

Mikulas Patocka (1):
      iscsi-target: fix iscsit_del_np deadlock on unload

Mirko Lindner (1):
      skge: Added FS A8NE-FM to the list of 32bit DMA boards

Mugunthan V N (1):
      drivers: net: cpsw: fix dual EMAC stall when connected to same switch

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle
migration/hwpoisoned entry

Naveen Krishna Chatradhi (2):
      devicetree: bindings: Document murata vendor prefix
      hwmon: (ntc_thermistor) Use the manufacturer name properly

Neal Cardwell (1):
      tcp: fix tcp_match_skb_to_sack() for unaligned SACK at end of an skb

Neil Horman (1):
      vmxnet3: adjust ring sizes when interface is down

Nicholas Bellinger (6):
      iscsi-target: Convert chap_server_compute_md5 to use kstrtoul
      iscsi-target; Enforce 1024 byte maximum for CHAP_C key value
      target: Fix left-over se_lun->lun_sep pointer OOPs
      iscsi-target: Explicily clear login response PDU in exception path
      tcm_loop: Fix memory leak in tcm_loop_submission_work error path
      iscsi-target: Avoid rejecting incorrect ITT for Data-Out

Nicolas Ferre (1):
      misc: atmel_pwm: fix Kconfig symbols

Nicolas Pitre (1):
      ARM: 8080/1: mcpm.h: remove unused variable declaration

Nikolay Borisov (1):
      ARM: 8069/1: Make thread_save_fp macro aware of THUMB2 mode

Nishanth Menon (1):
      regulator: palmas: Fix SMPS enable/disable/is_enabled

Noam Camus (1):
      ARC: [SMP] Fix IPI IRQ registration

Oleg Nesterov (3):
      tracing: Fix syscall_*regfunc() vs copy_process() race
      tracing: Change syscall_*regfunc() to check PF_KTHREAD and use
for_each_process_thread()
      tracing: syscall_regfunc() should not skip kernel threads

Ondrej Zary (1):
      tulip: Poll link status more frequently for Comet chips

Or Gerlitz (2):
      bonding: Advertize vxlan offload features when supported
      net/mlx4_core: Fix the error flow when probing with invalid VF
configuration

Pablo Neira Ayuso (9):
      netfilter: ctnetlink: fix dumping of dying/unconfirmed conntracks
      netfilter: nf_tables: use RCU-safe list insertion when replacing rules
      netfilter: nf_tables: use u32 for chain use counter
      netfilter: nf_tables: decrement chain use counter when replacing rules
      netfilter: nf_tables: fix wrong type in transaction when replacing rules
      netfilter: nft_compat: call {target, match}->destroy() to cleanup entry
      netfilter: nf_tables: indicate family when dumping set elements
      netfilter: nft_nat: don't dump port information if unset
      MAINTAINERS: merge ebtables into netfilter entry

Paul Bolle (1):
      ARC: remove checks for CONFIG_ARC_MMU_V4

Paul Burton (3):
      MIPS: smp-cps: Convert smp_mb__after_atomic_dec()
      MIPS: pm-cps: convert smp_mb__*()
      Revert "MIPS: Save/restore MSA context around signals"

Peter Griffin (2):
      ARM: STi: DT: Properly define sti-ethclk & stmmaceth for stih415/6
      drm/msm: storage class should be before const qualifier

Petr Tesarik (1):
      kexec: save PG_head_mask in VMCOREINFO

Philipp Zabel (1):
      ARM: dts: imx6qdl-gw5xxx: Fix Linear Technology vendor prefix

Phoebe Buckheister (1):
      at86rf230: fix irq setup

Pierre Ossman (1):
      ALSA: hda - hdmi: call overridden init on resume

Prashant Sreedharan (2):
      tg3: Clear NETIF_F_TSO6 flag before doing software GSO
      tg3: Change nvram command timeout value to 50ms

Rafał Miłecki (3):
      b43: disable 5 GHz on G-PHY
      b43: fix typo in Kconfig (make B43_BUSES_BCMA_AND_SSB the
default for real)
      b43: fix frequency reported on G-PHY with /new/ firmware

Rahul Sharma (5):
      drm/exynos: set power state variable after enabling clocks and power
      drm/exynos: stop mixer before gating clocks during poweroff
      drm/exynos: allow multiple layer updates per vsync for mixer
      drm/exynos: soft reset mixer before reconfigure after power-on
      drm/exynos: enable vsync interrupt while waiting for vblank

Ralf Baechle (3):
      MIPS: math-emu: Work around limitations of older GCC.
      MIPS: math-emu: Reduce code duplication.
      MIPS: Lasat: Fix build error if CRC32 is not enabled.

Randy Dunlap (1):
      MAINTAINERS: exceptions for Documentation maintainer

Rasmus Villemoes (1):
      powerpc/macintosh/smu.c: Fix closing brace followed by if

Richard Retanubun (1):
      of: mdio: fixup of_phy_register_fixed_link parsing of new bindings

Rickard Strandqvist (2):
      Documentation/accounting/getdelays.c: add missing null-terminate
after strncpy call
      powerpc/cell: cbe_thermal.c: Cleaning up a variable is of the wrong type

Rodrigo Vivi (1):
      drm/i915: BDW: Adding Reserved PCI IDs.

Romain Francoise (1):
      vhost-net: don't open-code kvfree

Russell King (5):
      ARM: dts: cubox-i: add support for PWM-driven front panel LED
      ARM: dts: hummingboard/cubox-i: move usb otg configuration to
platform level
      ARM: l2c: fix dependencies on PL310 errata symbols
      ARM: perf: fix compiler warning with gcc 4.6.4 (and tidy code)
      ARM: arm925: ensure assembly sets up writethrough mapping

Sachin Kamat (1):
      drm/exynos: Fix de-registration ordering

Sascha Hauer (1):
      ARM: dts: imx51-babbage: Fix esdhc setup

Scott Mayhew (1):
      nfs: Fix cache_validity check in nfs_write_pageuptodate()

Scott Wood (1):
      powerpc: Don't skip ePAPR spin-table CPUs

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix phy-connection-type for Guruplug

Shobhit Kumar (1):
      drm/i915: vlv_prepare_pll is only needed in case of non DSI interfaces

Srinivas Kandagatla (1):
      ARM: multi_v7_defconfig: Add QCOM GSBI driver

Srivatsa S. Bhat (1):
      CPU hotplug, smp: flush any pending IPI callbacks before CPU offline

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Stephane Viau (2):
      drm/msm/hdmi: set hdp clock rate before prepare_enable
      drm/msm: fix IOMMU cleanup for -EPROBE_DEFER

Stephen Warren (1):
      regulator: palmas: fix typo in enable_reg calculation

Steve French (1):
      [CIFS] fix mount failure with broken pathnames when smb3 mount
with mapchars option

Steven Miao (1):
      mm: nommu: per-thread vma cache fix

Steven Rostedt (1):
      tracing: Add __field_struct macro for TRACE_EVENT()

Suresh Reddy (1):
      be2net: fix qnq mode detection on VFs

Takashi Iwai (2):
      ALSA: hda - Adjust speaker HPF and add LED support for HP Spectre 13
      ALSA: usb-audio: Fix races at disconnection and PCM closing

Tariq Saeed (1):
      ocfs2: fix deadlock when two nodes are converting same lock from
PR to EX and idletimeout closes conn

Tejun Heo (1):
      blkcg: fix use-after-free in __blkg_release_rcu() by making
blkcg_gq refcnt an atomic_t

Thadeu Lima de Souza Cascardo (1):
      cxgb4: use dev_port to identify ports

Thomas Petazzoni (2):
      ARM: mvebu: select ARM_CPU_SUSPEND for Marvell EBU v7 platforms
      ARM: 8076/1: mm: add support for HW coherent systems in PL310 cache

Tim Harvey (2):
      ARM: dts: imx6: ventana: fix include typo
      ARM: dts: imx6: ventana: correct gw52xx sgtl5000 clock source

Tobias Klauser (3):
      trivial: net: filter: Fix typo in comment
      trivial: net: filter: Change kerneldoc parameter order
      net: filter: Use kcalloc/kmalloc_array to allocate arrays

Tom Herbert (1):
      net: fix setting csum_start in skb_segment()

Tomasz Figa (2):
      ARM: dts: fix reg sizes of GIC for exynos4
      drm/exynos: dpi: Fix NULL pointer dereference with legacy bindings

Trond Myklebust (2):
      NFS: Clear NFS_INO_REVAL_PAGECACHE when we update the file size
      NFS: Don't mark the data cache as invalid if it has been flushed

Tyler Hall (2):
      slip: Fix deadlock in write_wakeup
      slcan: Port write_wakeup deadlock fix from slip

Vineet Gupta (4):
      ARC: fix build warning in devtree
      ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND
      ARC: optimize kernel bss clearing in early boot code
      ARC: [SMP] Enable icache coherency

Vinod Koul (1):
      ALSA: compress: fix the struct alignment to 4 bytes

Wei Liu (1):
      xen-netback: bookkeep number of active queues in our own module

Wengang Wang (1):
      ocfs2: refcount: take rw_lock in ocfs2_reflink

Will Deacon (1):
      ARM: 8087/1: ptrace: reload syscall number after secure_computing() check

Xue jiufei (3):
      ocfs2: revert "ocfs2: fix NULL pointer dereference when dismount
and ocfs2rec simultaneously"
      ocfs2/dlm: fix misuse of list_move_tail() in dlm_run_purge_list()
      ocfs2/dlm: do not purge lockres that is queued for assert master

Yiwen Jiang (1):
      ocfs2: fix a tiny race when running dirop_fileop_racer

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl

alex chen (1):
      ocfs2: should add inode into orphan dir after updating entry in
ocfs2_rename()

jiangyiwen (2):
      ocfs2: manually do the iput once ocfs2_add_entry failed in
ocfs2_symlink and ocfs2_mknod
      ocfs2: do not return DLM_MIGRATE_RESPONSE_MASTERY_REF to avoid
endless,loop during umount
