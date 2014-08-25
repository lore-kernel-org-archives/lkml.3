Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbaHYXC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 19:02:29 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:55838 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbaHYXC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 19:02:26 -0400
MIME-Version: 1.0
Date: Mon, 25 Aug 2014 16:02:25 -0700
X-Google-Sender-Auth: fqAGvtQMfUh8OqZRuGFnwKFvnGg
Message-ID: <CA+55aFz+3JzdB+sZgOFfzd9zczL=borNgLwZykx=_tOMD6n4qw@mail.gmail.com>
Subject: Linux 3.17-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I deviated from my normal Sunday schedule partly because there
wasn't much there (I blame the KS and LinuxCon), but partly due to
sentimental reasons: Aug 25 is the anniversary of the original Linux
announcement ("Hello everybody out there using minix"), so it's just a
good day for release announcements.

Anyway, for being an rc2 it's pretty small, and I can always hope that
things stay that way. It's about 60% drivers (drm, networking, hid,
sound, PCI), with 15% filesystem updates (cifs, isofs, nfs), 10%
architectures (mips, arm, some minor x86 stuff) and the rest is "misc"
(kernel, networking, documentation).

All over the place, in other words, and nothing in particular stands out.

Please do give it a good testing,

              Linus

---

Aaro Koskinen (1):
      MIPS: OCTEON: make get_system_type() thread-safe

Al Cooper (1):
      of: Allow mem_reserve of memory with a base address of zero

Alan Cox (1):
      i2c: i801: Add PCI ID for Intel Braswell

Alan Ott (1):
      MAINTAINERS: Add section for MRF24J40 IEEE 802.15.4 radio driver

Alex Deucher (12):
      drm/radeon: add bapm module parameter
      drm/radeon: use pfp for all vm_flush related updates
      drm/radeon/dpm: select the appropriate vce power state for KV/KB/ML
      drm/radeon: fix pm handling in radeon_gpu_reset
      drm/radeon: fix display handling in radeon_gpu_reset
      drm/radeon: re-enable selective GPUVM flushing
      drm/radeon: fix active cu count for SI and CIK
      drm/radeon: fix active_cu mask on SI and CIK after re-init (v3)
      Revert "drm/radeon: Use write-combined CPU mappings of ring
buffers with PCIe"
      drm/radeon: add new KV pci id
      drm/radeon: add new bonaire pci ids
      drm/radeon: add additional SI pci ids

Alexander Stein (1):
      can: flexcan: Disable error interrupt when bus error reporting is disabled

Alexey Kardashevskiy (1):
      PC, KVM, CMA: Fix regression caused by wrong get_order() use

Andreas Ruprecht (1):
      drm/radeon: Remove duplicate include from Makefile

Andrew Duggan (1):
      HID: rmi: print an error if F11 is not found instead of stopping
the device

Andrew Lunn (1):
      PCI: mvebu: Remove ARCH_KIRKWOOD dependency

Anish Bhatt (1):
      cxgb4: Fix race condition in cleanup

Anjali Singhai Jain (2):
      i40e: Fix for recent kernel panic
      i40e: Fix a few potential VF dereferences

Anson Huang (1):
      ARM: imx: correct gpu2d_axi and gpu3d_axi clock setting

Anton Blanchard (1):
      ibmveth: Fix endian issues with rx_no_buffer statistic

Ard Biesheuvel (2):
      arm64: fix typo in I-cache policy detection
      arm64: align randomized TEXT_OFFSET on 4 kB boundary

Arjun Sreedharan (2):
      pata_samsung_cf: change ret type to signed
      pata_scc: propagate return value of scc_wait_after_reset

Arnd Bergmann (1):
      ARM: imx6: fix SMP compilation again

Benjamin Block (1):
      net: ipv6: fib: don't sleep inside atomic lock

Benjamin LaHaise (1):
      aio: fix reqs_available handling

Bill Pringlemeir (1):
      ARM: dts: vf610-twr: Fix pinctrl_esdhc1 pin definitions.

Chao Yu (1):
      udf: avoid unneeded up_write when fail to add entry in ->symlink

Chen Gang (1):
      virt/kvm/assigned-dev.c: Set 'dev->irq_source_id' to '-1' after free it

Chen-Yu Tsai (1):
      ARM: dt: sun6i: Add #address-cells and #size-cells to i2c controller nodes

Chin-Tsung Cheng (1):
      ext3: Count internal journal as bsddf overhead in ext3_statfs

Christian König (2):
      drm/radeon: properly document reloc priority mask
      drm/radeon: Sync ME and PFP after CP semaphore waits v4

Dan Carpenter (2):
      drm/radeon: add a check for allocation failure (v2)
      can: c_can: checking IS_ERR() instead of NULL

Daniel Borkmann (2):
      net: sctp: spare unnecessary comparison in sctp_trans_elect_best
      net: sctp: fix suboptimal edge-case on non-active active/retrans
path selection

Daniel Drake (2):
      ARM: dts: Enable PMIC interrupts on ODROID
      ARM: dts: ODROID i2c improvements

Daniel Mack (1):
      ASoC: pxa-ssp: drop SNDRV_PCM_FMTBIT_S24_LE

Dariusz Marcinkiewicz (1):
      MAINTAINERS: add entry for ec_bhf driver

Dave Hansen (1):
      x86/mm: Fix RCU splat from new TLB tracepoints

David Jeffery (1):
      nfs: Don't busy-wait on SIGKILL in __nfs_iocounter_wait

David S. Miller (1):
      tipc: Fix build.

Davidlohr Bueso (1):
      frv: Define cpu_relax_lowlatency()

Eric Dumazet (1):
      packet: handle too big packets for PACKET_V3

Erik Hugne (1):
      tipc: fix message importance range check

Florian Fainelli (4):
      of/irq: Fix lookup to use 'interrupts-extended' property first
      net: phy: bcm7xxx: remove 28nm wildcard entry
      net: phy: bcm7xxx: re-advertise all supported modes out of suspend
      net: phy: bcm7xxx: remove suspend callback for 28nm PHYs

Fugang Duan (1):
      ARM: dts: imx6sx: fix the pad setting for uart CTS_B

Ganapatrao Kulkarni (1):
      arm64: mm: update max pa bits to 48

Gaurav Minocha (1):
      Enabling OF selftest to run without machine's devicetree

Geert Uytterhoeven (4):
      ASoC: dapm: Fix uninitialized variable in snd_soc_dapm_get_enum_double()
      pwm: Fix period and polarity in pwm_get() for non-perfect matches
      sh: intc: Confine SH_INTC to platforms that need it
      ARM: shmobile: koelsch: Remove non-existent i2c6 pinmux

Guenter Roeck (4):
      [SCSI] fix qemu boot hang problem
      MIPS: NL: Fix nlm_xlp_defconfig build error
      scsi: Fix qemu boot hang problem
      firmware: Do not use WARN_ON(!spin_is_locked())

Gwenhael Goavec-Merou (1):
      net: phy: smsc: move smsc_phy_config_init reset part in a
soft_reset function

Hariprasad Shenai (1):
      cxgb4: Free completed tx skbs promptly

Hauke Mehrtens (1):
      MIPS: BCM47XX: Fix reboot problem on BCM4705/BCM4785

Heiko Stuebner (2):
      ARM: dts: rockchip: readd missing mmc0 pinctrl settings
      MAINTAINERS: add new Rockchip SoC list

Himangi Saraogi (1):
      HID: hid-sensor-hub: use devm_ functions consistently

Huacai Chen (1):
      MIPS: Loongson: Fix COP2 usage for preemptible kernel

Hui Wang (1):
      ALSA: hda - restore the gpio led after resume

Imre Deak (5):
      drm/i915: take display port power domain in DP HPD handler
      drm/i915: fix HPD IRQ reenable work cancelation
      drm/i915: cancel hotplug and dig_port work during suspend and unload
      drm/i915: make sure VDD is turned off during system suspend
      drm/i915: don't try to retrain a DP link on an inactive CRTC

Iyappan Subramanian (1):
      net: xgene: fix possible NULL dereference in xgene_enet_free_desc_rings()

Jan Kara (1):
      isofs: Fix unbounded recursion when processing relocated directories

Jarkko Nikula (4):
      ASoC: Intel: Update Baytrail ADSP firmware name
      ASoC: Intel: Merge Baytrail ADSP suspend_noirq into suspend_late
      ASoC: Intel: Wait Baytrail ADSP boot at resume_early stage
      ASoC: Intel: Restore Baytrail ADSP streams only when ADSP was in reset

Jeff Layton (1):
      cifs: handle lease F_UNLCK requests properly

Jeremiah Mahler (2):
      x86/mm: Fix sparse 'tlb_single_page_flush_ceiling' warning and
make the variable read-mostly
      x86/doc: Fix the 'tlb_single_page_flush_ceiling' sysconfig path

Jesse Brandeburg (1):
      i40e: fix PTP bug

Jiri Benc (1):
      openvswitch: fix panic with multiple vlan headers

Jiri Kosina (3):
      HID: logitech: fix bounds checking on LED report size
      HID: logitech: perform bounds checking on device_id early enough
      HID: fix a couple of off-by-ones

Jitendra Kalsaria (1):
      qlcnic: Fix flash access interface to application

Joerg Roedel (3):
      iommu/vt-d: Defer domain removal if device is assigned to a driver
      iommu/amd: Fix cleanup_domain for mass device removal
      iommu/core: Check for the right function pointer in iommu_map()

Juergen Gross (1):
      [SCSI] save command pool address of Scsi_Host

Julia Lawall (2):
      gpiolib: devres: use correct structure type name in sizeof
      gpio: delete unneeded test before of_node_put

Jyri Sarha (1):
      ASoC: mcasp: Fix implicit BLCK divider setting

Kishon Vijay Abraham I (3):
      PCI: designware: Look for configuration space in 'reg', not 'ranges'
      PCI: designware: Program ATU with untranslated address
      PCI: dra7xx: Add TI DRA7xx PCIe driver

Lan Tianyu (1):
      i2c: rework kernel config I2C_ACPI

Lars Persson (1):
      MIPS: Remove race window in page fault handling

Lars-Peter Clausen (1):
      gpio: zynq: Fix IRQ handlers

Laurent Pinchart (1):
      MAINTAINERS: Add entry for Renesas DRM drivers

Leif Lindholm (1):
      arm64: ignore DT memreserve entries when booting in UEFI mode

Libin Yang (2):
      ALSA: hda/hdmi - set depop_delay for haswell plus
      ALSA: hda/hdmi - apply Valleyview fix-ups to Cherryview display codec

Linus Torvalds (1):
      Linux 3.17-rc2

Linus Walleij (1):
      gpio: move GPIOD flags outside #ifdef

Lothar Waßmann (1):
      ARM: dts: i.MX53: fix apparent bug in VPU clks

Manuel Lauss (1):
      MIPS: Alchemy: Fix db1200 PSC clock enablement

Marcel Ziswiler (1):
      ARM: tegra: apalis/colibri t30: fix on-module 5v0 supplies

Mark Brown (3):
      MAINTAINERS: Add i.MX maintainers and paths to Freescale ASoC entry
      ASoC: pcm512x: Correct Digital Playback control names
      arm64: configs: Enable X-Gene SATA and ethernet in defconfig

Markos Chandras (6):
      MIPS: Malta: Improve system memory detection for '{e, }memsize' >= 2G
      MIPS: syscall: Fix AUDIT value for O32 processes on MIPS64
      MIPS: scall64-o32: Fix indirect syscall detection
      MIPS: EVA: Add new EVA header
      MIPS: Malta: EVA: Rename 'eva_entry' to 'platform_eva_init'
      MIPS: CPS: Initialize EVA before bringing up VPEs from secondary cores

Markus Mayer (1):
      MAINTAINERS: Change maintainer for gpio-bcm-kona.c

Masami Hiramatsu (1):
      kprobes: Skip kretprobe hit in NMI context to avoid deadlock

Mathias Nyman (1):
      gpio-lynxpoint: enable input sensing in resume

Matthew Garrett (1):
      Revert "platform/x86/toshiba-apci.c possible bad if test?"

Michael S. Tsirkin (1):
      kvm: iommu: fix the third parameter of kvm_iommu_put_pages (CVE-2014-3601)

Michal Kazior (1):
      mac80211: fix channel switch for chanctx-based drivers

Michal Simek (3):
      microblaze: Wire-up seccomp syscall
      microblaze: Wire-up getrandom syscall
      microblaze: Wire-up memfd_create syscall

Michel Dänzer (2):
      drm/radeon: Always flush VM again on < CIK
      drm/radeon: Only flush HDP cache for indirect buffers from userspace

Mikko Perttunen (1):
      ata: ahci_tegra: Change include to fix compilation

Mirza Krak (1):
      can: sja1000: Validate initialization state in start method

Murali Karicheri (2):
      PCI: designware: Add config access-related pcie_host_ops for
v3.65 hardware
      PCI: designware: Add MSI-related pcie_host_ops for v3.65 hardware

Nadav Amit (1):
      KVM: x86: Avoid emulating instructions on #UD mistakenly

NeilBrown (6):
      md/raid5: avoid livelock caused by non-aligned writes.
      md/raid6: avoid data corruption during recovery of double-degraded RAID6
      md/raid10: fix memory leak when reshaping a RAID10.
      md/raid10: Fix memory leak when raid10 reshape completes.
      md/raid10: avoid memory leak on error path during reshape.
      md/raid10: always initialise ->state on newly allocated r10_bio

Nikesh Oswal (1):
      ASoC: arizona: Fix TDM slot length handling in arizona_hw_params

Nikolai Kondrashov (2):
      HID: huion: Fail on parameter retrieval errors
      HID: huion: Use allocated buffer for DMA

Nimrod Andy (1):
      net: fec: ptp: avoid register access when ipg clock is disabled

Oleg Chernovskiy (1):
      drm/radeon: Add missing lines to ci_set_thermal_temperature_range

Pali Rohár (1):
      drm/radeon: Add ability to get and change dpm state when radeon
PX card is turned off

Paolo Bonzini (2):
      KVM: x86: do not check CS.DPL against RPL during task switch
      Revert "KVM: x86: Increase the number of fixed MTRR regs to 10"

Pavel Shilovsky (2):
      CIFS: Fix SMB2 readdir error handling
      CIFS: Fix wrong directory attributes after rename

Pawel Moll (2):
      perf: Handle compat ioctl
      bus: arm-ccn: Fix warning message

Rajesh Borundia (1):
      qlcnic: Fix endianess issue in FW dump template header

Ralf Baechle (1):
      MIPS: GIC: Remove useless parens from GICBIS().

Rasmus Villemoes (2):
      net: ethernet: broadcom: bnx2x: Remove redundant #ifdef
      drivers: isdn: eicon: xdi_msg.h: Fix typo in #ifndef

Sebastian Andrzej Siewior (1):
      can: flexcan: handle state passive -> warning transition

Semen Protsenko (1):
      efi/arm64: Store Runtime Services revision

Sergey Ryazanov (2):
      MIPS: MSP71xx: remove unused plat_irq_dispatch() argument
      MIPS: Add common plat_irq_dispatch declaration

Shahed Shaikh (1):
      qlcnic: Fix endianess issue in firmware load from file operation

Shawn Guo (2):
      ARM: imx: fix TLB missing of IOMUXC base address during suspend
      ARM: imx: remove unnecessary ARCH_HAS_OPP select

Shengjiu Wang (1):
      ASoC: fsl-esai: Revert .xlate_tdm_slot_mask() support

Silvio Fricke (1):
      ARM: dts: imx6: edmqmx6: change enet reset pin

Simon Wood (1):
      HID: logitech: Prevent possibility of infinite loop when using
/sys interface

Stefan Bader (1):
      x86_32, entry: Clean up sysenter_badsys declaration

Steve French (8):
      Add missing definitions for CIFS File System Attributes
      Add sparse file support to SMB2/SMB3 mounts
      Cleanup sparse file support by creating worker function for it
      [CIFS] Workaround MacOS server problem with SMB2.1 write      response
      [CIFS] Possible null ptr deref in SMB2_tcon
      Incorrect error returned on setting file compressed on SMB2
      enable fallocate punch hole ("fallocate -p") for SMB3
      [SMB3] Enable fallocate -z support for SMB3 mounts

Steven Rostedt (Red Hat) (5):
      ftrace: Allow ftrace_ops to use the hashes from other ops
      ftrace: Update all ftrace_ops for a ftrace_hash_ops update
      ftrace: Fix up trampoline accounting with looping on hash ops
      ftrace: Fix function_profiler and function tracer together
      ftrace: Use current addr when converting to nop in __ftrace_replace_code()

Suman Tripathi (1):
      ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI
SATA Host Controller driver.

Sven Eckelmann (1):
      batman-adv: Fix parameter order of hlist_add_behind

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid setting wrong COEF on ALC269 & co

Tejun Heo (1):
      libata: widen Crucial M550 blacklist matching

Thierry Reding (1):
      PCI: tegra: Add debugfs support

Tony Luck (1):
      [IA64] Wire up memfd_create() system call

Vasily Averin (2):
      cbq: incorrectly low bandwidth setting blocks limited traffic
      cbq: now_rt removal

Ville Syrjälä (3):
      drm/i915: Fix locking for intel_enable_pipe_a()
      drm/i915: Skip load detect when intel_crtc->new_enable==true
      drm/i915: Don't try to enable cursor from setplane when crtc is disabled

Vincent Stehlé (1):
      cifs: remove unused function cifs_oplock_break_wait

Vlad Yasevich (1):
      macvlan: Allow setting multicast filter on all macvlan types

Wei Yongjun (1):
      MIPS: Remove duplicated include from numa.c

Weston Andros Adamson (7):
      nfs: change nfs_page_group_lock argument
      nfs: fix nonblocking calls to nfs_page_group_lock
      nfs: use blocking page_group_lock in add_request
      nfs: fix error handling in lock_and_join_requests
      nfs: don't sleep with inode lock in lock_and_join_requests
      nfs: disallow duplicate pages in pgio page vectors
      nfs: can_coalesce_requests must enforce contiguity

Will Deacon (3):
      arm64: compat: wire up memfd_create and getrandom syscalls for aarch32
      asm-generic: add memfd_create system call to unistd.h
      Revert "arm64: Do not invoke audit_syscall_* functions if
!CONFIG_AUDIT_SYSCALL"

Wolfram Sang (1):
      MAINTAINERS: add maintainer for ACPI parts of I2C

Yang Wei (1):
      MIPS: perf: Mark pmu interupt IRQF_NO_THREAD

Yuval Mintz (1):
      bnx2x: Revert UNDI flushing mechanism

chas williams (1):
      lec: Use rtnl lock/unlock when updating MTU

zhuyj (1):
      sctp: not send SCTP_PEER_ADDR_CHANGE notifications with failed probe
