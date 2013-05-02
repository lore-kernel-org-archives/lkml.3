Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3EBHfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:35:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:40107 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3EBHfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:35:42 -0400
Message-ID: <1367480121.4389.15.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Thu, 02 May 2013 17:35:21 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the next pack of powerpc changes !

The main highlights this time around are:

 - A pile of addition POWER8 bits and nits, such as updated performance
counter support (Michael Ellerman), new branch history buffer support
(Anshuman Khandual), base support for the new PCI host bridge when
not using the hypervisor (Gavin Shan) and other random related bits
and fixes from various contributors.

 - Some rework of our page table format by Aneesh Kumar which fixes
a thing or two and paves the way for THP support. THP itself will
not make it this time around however.

 - More Freescale updates, including Altivec support on the new
e6500 cores, new PCI controller support, and a pile of new boards
support and updates.

 - The usual batch of trivial cleanups & fixes.

Cheers,
Ben.

The following changes since commit 60d509fa6a9c4653a86ad830e4c4b30360b23f0e:

  Linux 3.9-rc8 (2013-04-21 14:38:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 54d5999d98f2ab36ad71b9ef4d82cf5f399205f5:

  powerpc: Fix build error for book3e (2013-05-02 10:37:37 +1000)

----------------------------------------------------------------
Adhemerval Zanella (1):
      powerpc: Add VDSO version of time

Adrian-Leonard Radu (1):
      powerpc: Use PTR_RET instead of IS_ERR/PTR_ERR

Alex Grad (1):
      powerpc/kgdb: Removed kmalloc returned value cast

Alexey Kardashevskiy (1):
      powerpc: fixing ptrace_get_reg to return an error

Anatolij Gustschin (2):
      powerpc/mpc512x: create SoC devices for more nodes
      powerpc/512x: add ifm ac14xx board

Andy Shevchenko (1):
      powerpc/pmac/smu: Use %*ph to print small buffers

Aneesh Kumar K.V (16):
      powerpc: Use signed formatting when printing error
      powerpc: Save DAR and DSISR in pt_regs on MCE
      powerpc: Don't hard code the size of pte page
      powerpc: Don't truncate pgd_index wrongly
      powerpc: New hugepage directory format
      powerpc: Switch 16GB and 16MB explicit hugepages to a different page table format
      powerpc: Reduce the PTE_INDEX_SIZE
      powerpc: Move the pte free routines from common header
      powerpc: Reduce PTE table memory wastage
      powerpc: Use encode avpn where we need only avpn values
      powerpc: Decode the pte-lp-encoding bits correctly.
      powerpc: Fix hpte_decode to use the correct decoding for page sizes
      powerpc: print both base and actual page size on hash failure
      powerpc: Print page size info during boot
      powerpc: Update tlbie/tlbiel as per ISA doc
      powerpc: Fix build error for book3e

Anshuman Khandual (6):
      powerpc/perf: Add new BHRB related instructions for POWER8
      powerpc/perf: Add basic assembly code to read BHRB entries on POWER8
      powerpc/perf: Add new BHRB related generic functions, data and flags
      powerpc/perf: Define BHRB generic functions, data and flags for POWER8
      powerpc/perf: Enable branch stack sampling framework
      powerpc: Setup BHRB instructions facility in HFSCR for POWER8

Ben Collins (1):
      powerpc/85xx: sgy-cts1000 - Remove __dev* attributes

Benjamin Herrenschmidt (5):
      Merge remote-tracking branch 'mpe/master' into next
      Merge remote-tracking branch 'origin/master' into next
      powerpc/powernv: Fix missing Kconfig dependency for MSIs
      Merge remote-tracking branch 'agust/next' into next
      Merge remote-tracking branch 'kumar/next' into next

Bharat Bhushan (1):
      powerpc: Fix interrupt range check on debug exception

Brian King (2):
      pci: Set dev->dev.type in alloc_pci_dev
      powerpc: Set default VGA device

Chen Gang (1):
      powerpc/pseries/lparcfg: Fix possible overflow are more than 1026

Chen-Hui Zhao (1):
      powerpc/85xx: fix a bug with the parameter of mpic_reset_core()

Gavin Shan (8):
      powerpc/kernel: Cleanup on rtas_pci.c
      powerpc/powernv: Use MSI bitmap to manage IRQs
      powerpc/powernv: Supports PHB3
      powerpc/powernv: Add option CONFIG_POWERNV_MSI
      powerpc/powernv: Patch MSI EOI handler on P8
      powerpc/powernv: TCE invalidation for PHB3
      powerpc/powernv: Build DMA space for PE on PHB3
      powerpc/powernv: Fix invalid IOMMU table

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

Ian Munsie (1):
      powerpc: Add accounting for Doorbell interrupts

Jesse Larrew (4):
      powerpc/pseries: Add PRRN RTAS event handler
      powerpc/pseries: Update CPU maps when device tree is updated
      powerpc/pseries: Update NUMA VDSO information when updating CPU maps
      powerpc/pseries: RE-enable Virtual Processor Home Node updating

Jia Hongtao (1):
      powerpc/85xx: Add platform_device declaration to fsl_pci.h

Jiucheng Xu (1):
      powerpc/85xx: Reserve a partition of NOR flash for QE ucode firmware

Kevin Hao (3):
      powerpc/fsl-pci: don't unmap the PCI SoC controller registers in setup_pci_atmu
      powerpc/fsl-booke: add the reg prop for pci bridge device node for T4/B4
      powerpc/booke: Remove obsolete macro FINISH_EXCEPTION

Kumar Gala (11):
      powerpc/fsl-booke: Support detection of page sizes on e6500
      powerpc/85xx: Add AltiVec support for e6500
      powerpc/fsl-booke: Add initial silicon device tree for T4240
      powerpc/fsl-booke: Add initial T4240QDS board device tree
      powerpc/fsl-booke: Add initial T4240QDS board support
      powerpc/85xx: Update corenet64_smp_defconfig for T4240
      powerpc/qe: Fix Kconfig enablement of QE_USB support
      powerpc/fsl-booke: Update T4240 device config node in device tree
      powerpc/fsl-booke: Minor fixes to T4240 Si device tree
      powerpc/fsl-pci: Keep PCI SoC controller registers in pci_controller
      powerpc/85xx: Fix MPC8536DS 36-bit device tree

Li Zhong (4):
      powerpc: Use VPA subfunction macros instead of numbers for vpa calls
      powerpc: Move the setting of rflags out of loop in __hash_page_huge
      powerpc: Split the code trying to insert hpte repeatedly as an helper function
      powerpc: Try to insert the hptes repeatedly in kernel_map_linear_page()

Matteo Facchinetti (2):
      powerpc/512x: move mpc5121_generic platform to mpc512x_generic.
      powerpc/mpc512x: add platform code for MPC5125.

Michael Ellerman (12):
      powerpc: Remove unused postfix parameter to DEFINE_BITOP()
      powerpc/cell: Only iterate over online nodes in cbe_init_pm_irq()
      powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
      powerpc: Initialise PMU related regs on Power8
      powerpc/perf: Add an explict flag indicating presence of SLOT field
      powerpc/perf: Convert mmcra_sipr/sihv() to regs_sipr/sihv()
      powerpc/perf: Add an accessor for regs->result
      powerpc/perf: Add regs_no_sipr()
      powerpc/perf: Add support for SIER
      powerpc/perf: Power8 PMU support
      powerpc: Replace CPU_FTR_BCTAR with CPU_FTR_ARCH_207S
      powerpc: Context switch the new EBB SPRs

Michael Neuling (9):
      powerpc: Add HFSCR SPR definitions
      powerpc: Setup in HFSCR for POWER8
      powerpc/ptrace: Add DAWR debug feature info for userspace
      powerpc: Add HWCAP2 aux entry
      powerpc: Add isync to copy_and_flush
      powerpc/power8: Fix secondary CPUs hanging on boot for HV=0
      powerpc: Fix hardware IRQs with MMU on exceptions when HV=0
      powerpc: Fix usage of setup_pci_atmu()
      powerpc: Turn on the EBB H/FSCR bits

Michel Lespinasse (2):
      mm: remove free_area_cache use in powerpc architecture
      mm: use vm_unmapped_area() on powerpc architecture

Nathan Fontenot (10):
      powerpc/pseries: Expose pseries devicetree_update()
      powerpc/pseries: Correct buffer parsing in update_dt_node()
      powerpc/pseries: Move architecture vector definitions to prom.h
      powerpc/pseries: Use ARRAY_SIZE to iterate over firmware_features_table array
      powerpc/pseries: Update firmware_has_feature() to check architecture vector 5 bits
      powerpc/pseries: Update numa.c to use updated firmware_has_feature()
      powerpc/pseries: Use stop machine to update cpu maps
      powerpc/pseries: Enable PRRN handling
      powerpc/pseries: Add /proc interface to control topology updates
      powerpc/pseries: Correct builds break when CONFIG_SMP not defined

Nishanth Aravamudan (1):
      powerpc/pseries: close DDW race between functions of adapter

Oleg Nesterov (1):
      ptrace/powerpc: Don't flush_ptrace_hw_breakpoint() on fork()

Paul Bolle (12):
      powerpc: remove "config 8260_PCI9"
      powerpc: remove "config MPC10X_OPENPIC"
      powerpc/wsp: drop "select PPC_WSP_COPRO"
      powerpc: remove outdated default on PCI_PERMEDIA
      powerpc/40x: remove unused "config 405GPR"
      powerpc: remove dead CONFIG_HVC_SCOM code
      powerpc: remove PReP platform
      memblock: kill "config MAX_ACTIVE_REGIONS"
      powerpc: Fix typo "CONFIG_ICSWX_PID"
      powerpc: remove unused CONFIG_405EP
      powerpc: remove CONFIG_MPC10X_OPENPIC
      powerpc: drop even more unused Kconfig symbols

Paul Mackerras (2):
      powerpc: Fix build errors with UP configs in HV-style KVM
      powerpc: Fix "attempt to move .org backwards" error

Prabhakar Kushwaha (1):
      powerpc: add CONFIG(s) require for using flash controller

Ramneek Mehresh (1):
      powerpc/85xx: Add first usb controller node for Qonverge platforms

Rojhalat Ibrahim (1):
      powerpc/fsl-pci Make PCIe hotplug work with Freescale PCIe controllers

Roy ZANG (2):
      powerpc/85xx: Add support for FSL PCIe controller v3.0
      powerpc/85xx: enable Silicon image 3132 PCIe to SATA controller

Roy Zang (2):
      powerpc/85xx: enable E1000 NIC to mpc85xx_defconfig
      powerpc/fsl_pci: fix 64 bit pci size issue

Scott Wood (1):
      powerpc/85xx: add CONFIG_E1000E to corenet64_smp_defconfig

Sebastian Andrzej Siewior (1):
      powerpc/fsl-msi: use a different lockclass for the cascade interrupt

Shaveta Leekha (5):
      powerpc/85xx: add SEC-5.3 device tree
      powerpc/fsl-booke: Add initial silicon device tree files for B4860 and B4420
      powerpc/fsl-booke: Add initial B4860QDS and B4420QDS board device tree
      powerpc/fsl-booke: Add B4_QDS board support
      powerpc/85xx: Update corenet64_smp_defconfig for B4_QDS

Stephen George (2):
      powerpc/fsl-booke: Added device tree DCSR entries for T4240 Chassis v2 Debug IP
      powerpc/fsl-booke: Update DCSR EPU device tree entries for existing SoCs

Stephen Rothwell (2):
      powerpc: fix annotation of fake_numa_create_new_node()
      powerpc: Fix build failure after merge of the cgroup tree

Stuart Yoder (3):
      powerpc/e6500: Add architecture categories for e6500 cores
      powerpc: add missing deo arch category to e500mc/e5500 dts
      powerpc: Add paravirt idle loop for 64-bit Book-E

Tang Yuantian (1):
      powerpc/fsl: remove the PPC_CLOCK dependency

Vaidyanathan Srinivasan (1):
      powerpc: fix numa distance for form0 device tree

Vakul Garg (3):
      powerpc/85xx: Added SEC-5.0 device tree.
      powerpc/fsl: removed qoriq-sec4.1-0.dtsi.
      powerpc/fsl: Add property for 'era' in SEC dts crypto node

Valentina Manea (1):
      powerpc: place EXPORT_SYMBOL macro right after declaration

Vasant Hegde (4):
      powerpc/rtas_flash: Free kmem upon module exit
      powerpc/rtas_flash: Update return token comments
      powerpc/rtas_flash: New return code to indicate FW entitlement expiry
      powerpc/rtas_flash: Fix bad memory access

Wei Yongjun (1):
      powerpc: use for_each_compatible_node() macro

Yuanquan Chen (1):
      powerpc/pci: fix PCI-e devices rescan issue on powerpc platform

Zhang Yanfei (1):
      powerpc: remove cast for kmalloc/kzalloc return value

Zhicheng Fan (1):
      powerpc/dts: Fix the dts for p1025rdb 36bit

 .../devicetree/bindings/powerpc/fsl/cpus.txt       |   22 +
 Documentation/powerpc/00-INDEX                     |    4 -
 Documentation/powerpc/ptrace.txt                   |    1 +
 Documentation/powerpc/sound.txt                    |   81 ---
 Documentation/powerpc/zImage_layout.txt            |   47 --
 arch/metag/mm/Kconfig                              |    5 -
 arch/powerpc/Kconfig                               |   20 +-
 arch/powerpc/boot/dts/ac14xx.dts                   |  392 +++++++++++++
 arch/powerpc/boot/dts/b4420qds.dts                 |   50 ++
 arch/powerpc/boot/dts/b4860qds.dts                 |   61 ++
 arch/powerpc/boot/dts/b4qds.dts                    |  169 ++++++
 arch/powerpc/boot/dts/fsl/b4420si-post.dtsi        |   98 ++++
 arch/powerpc/boot/dts/fsl/b4420si-pre.dtsi         |   73 +++
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi        |  142 +++++
 arch/powerpc/boot/dts/fsl/b4860si-pre.dtsi         |   83 +++
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |  268 +++++++++
 arch/powerpc/boot/dts/fsl/e500mc_power_isa.dtsi    |    1 +
 arch/powerpc/boot/dts/fsl/e5500_power_isa.dtsi     |    1 +
 arch/powerpc/boot/dts/fsl/e6500_power_isa.dtsi     |   65 +++
 arch/powerpc/boot/dts/fsl/p1023si-post.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |    2 +-
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |    2 +-
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |    2 +-
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |    2 +-
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |    2 +-
 arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi        |    1 +
 arch/powerpc/boot/dts/fsl/qonverge-usb2-dr-0.dtsi  |   41 ++
 arch/powerpc/boot/dts/fsl/qoriq-gpio-1.dtsi        |   41 ++
 arch/powerpc/boot/dts/fsl/qoriq-gpio-2.dtsi        |   41 ++
 arch/powerpc/boot/dts/fsl/qoriq-gpio-3.dtsi        |   41 ++
 arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi      |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi      |    1 +
 .../{qoriq-sec4.1-0.dtsi => qoriq-sec5.0-0.dtsi}   |   27 +-
 arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi      |    1 +
 arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi      |  119 ++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |  442 +++++++++++++++
 arch/powerpc/boot/dts/fsl/t4240si-pre.dtsi         |  128 +++++
 arch/powerpc/boot/dts/mpc5121.dtsi                 |    2 +-
 arch/powerpc/boot/dts/mpc5121ads.dts               |    2 +-
 arch/powerpc/boot/dts/mpc5125twr.dts               |  233 ++++++++
 arch/powerpc/boot/dts/mpc8536ds_36b.dts            |    6 +-
 arch/powerpc/boot/dts/p1021rdb-pc.dtsi             |   12 +-
 arch/powerpc/boot/dts/p1025rdb_36b.dts             |    5 +
 arch/powerpc/boot/dts/pdm360ng.dts                 |    2 +-
 arch/powerpc/boot/dts/t4240qds.dts                 |  224 ++++++++
 arch/powerpc/configs/corenet64_smp_defconfig       |   46 +-
 arch/powerpc/configs/mpc512x_defconfig             |    2 +-
 arch/powerpc/configs/mpc85xx_defconfig             |   40 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   32 ++
 arch/powerpc/configs/ps3_defconfig                 |    2 +-
 arch/powerpc/include/asm/bitops.h                  |   11 +-
 arch/powerpc/include/asm/cputable.h                |   11 +-
 arch/powerpc/include/asm/dma.h                     |    5 -
 arch/powerpc/include/asm/elf.h                     |    1 +
 arch/powerpc/include/asm/exception-64s.h           |    2 +-
 arch/powerpc/include/asm/firmware.h                |    6 +-
 arch/powerpc/include/asm/hardirq.h                 |    3 +
 arch/powerpc/include/asm/hugetlb.h                 |   30 +
 arch/powerpc/include/asm/io.h                      |    4 -
 arch/powerpc/include/asm/kvm_asm.h                 |    4 +
 arch/powerpc/include/asm/machdep.h                 |    3 +-
 arch/powerpc/include/asm/mmu-book3e.h              |   22 +
 arch/powerpc/include/asm/mmu-hash64.h              |   60 +-
 arch/powerpc/include/asm/opal.h                    |    2 +
 arch/powerpc/include/asm/page.h                    |   19 +
 arch/powerpc/include/asm/page_64.h                 |    3 +-
 arch/powerpc/include/asm/parport.h                 |    4 +-
 arch/powerpc/include/asm/pci-bridge.h              |   11 +-
 arch/powerpc/include/asm/perf_event_server.h       |    9 +
 arch/powerpc/include/asm/pgalloc-32.h              |   45 ++
 arch/powerpc/include/asm/pgalloc-64.h              |  158 +++++-
 arch/powerpc/include/asm/pgalloc.h                 |   46 +-
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |    6 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |    3 +-
 arch/powerpc/include/asm/pgtable.h                 |    8 +
 arch/powerpc/include/asm/ppc-opcode.h              |    8 +
 arch/powerpc/include/asm/processor.h               |   12 +-
 arch/powerpc/include/asm/prom.h                    |   69 +++
 arch/powerpc/include/asm/ptrace.h                  |    3 +-
 arch/powerpc/include/asm/reg.h                     |   23 +
 arch/powerpc/include/asm/rtas.h                    |    6 +
 arch/powerpc/include/asm/smp.h                     |    2 +
 arch/powerpc/include/asm/topology.h                |    5 +
 arch/powerpc/include/asm/xics.h                    |    1 +
 arch/powerpc/include/uapi/asm/ptrace.h             |    1 +
 arch/powerpc/kernel/asm-offsets.c                  |    3 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |   16 +
 arch/powerpc/kernel/cpu_setup_power.S              |   31 +-
 arch/powerpc/kernel/cputable.c                     |    9 +-
 arch/powerpc/kernel/dbell.c                        |    2 +
 arch/powerpc/kernel/entry_64.S                     |   20 +-
 arch/powerpc/kernel/epapr_hcalls.S                 |    2 +
 arch/powerpc/kernel/exceptions-64e.S               |   47 ++
 arch/powerpc/kernel/exceptions-64s.S               |   22 +-
 arch/powerpc/kernel/head_44x.S                     |    2 +
 arch/powerpc/kernel/head_64.S                      |    1 +
 arch/powerpc/kernel/head_booke.h                   |   21 +-
 arch/powerpc/kernel/head_fsl_booke.S               |    2 +
 arch/powerpc/kernel/idle_book3e.S                  |   32 +-
 arch/powerpc/kernel/iommu.c                        |    2 +-
 arch/powerpc/kernel/irq.c                          |   12 +
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/lparcfg.c                      |    1 +
 arch/powerpc/kernel/nvram_64.c                     |    3 +-
 arch/powerpc/kernel/pci-common.c                   |   56 +-
 arch/powerpc/kernel/process.c                      |    8 +-
 arch/powerpc/kernel/prom_init.c                    |   98 +---
 arch/powerpc/kernel/ptrace.c                       |   31 +-
 arch/powerpc/kernel/ptrace32.c                     |   15 +-
 arch/powerpc/kernel/rtas_flash.c                   |   51 +-
 arch/powerpc/kernel/rtas_pci.c                     |    4 +-
 arch/powerpc/kernel/rtasd.c                        |   49 +-
 arch/powerpc/kernel/setup-common.c                 |    6 -
 arch/powerpc/kernel/setup_64.c                     |    4 +-
 arch/powerpc/kernel/time.c                         |    4 +-
 arch/powerpc/kernel/vdso.c                         |    4 +
 arch/powerpc/kernel/vdso32/gettimeofday.S          |   26 +
 arch/powerpc/kernel/vdso32/vdso32.lds.S            |    1 +
 arch/powerpc/kernel/vdso64/gettimeofday.S          |   26 +
 arch/powerpc/kernel/vdso64/vdso64.lds.S            |    1 +
 arch/powerpc/kvm/book3s_64_mmu_host.c              |    2 +-
 arch/powerpc/kvm/book3s_hv.c                       |    8 +-
 arch/powerpc/kvm/book3s_hv_interrupts.S            |    6 +
 arch/powerpc/kvm/book3s_pr.c                       |    2 +-
 arch/powerpc/mm/gup.c                              |   18 +-
 arch/powerpc/mm/hash_low_64.S                      |   22 +-
 arch/powerpc/mm/hash_native_64.c                   |  178 ++++--
 arch/powerpc/mm/hash_utils_64.c                    |  183 ++++--
 arch/powerpc/mm/hugetlbpage-hash64.c               |   33 +-
 arch/powerpc/mm/hugetlbpage.c                      |  192 +++++--
 arch/powerpc/mm/icswx.c                            |    2 +-
 arch/powerpc/mm/init_64.c                          |    3 +-
 arch/powerpc/mm/mem.c                              |    3 +-
 arch/powerpc/mm/mmu_context_hash64.c               |   37 ++
 arch/powerpc/mm/numa.c                             |  279 +++++++--
 arch/powerpc/mm/pgtable_64.c                       |  118 ++++
 arch/powerpc/mm/slice.c                            |  223 +++-----
 arch/powerpc/mm/tlb_nohash.c                       |   18 +-
 arch/powerpc/perf/Makefile                         |    5 +-
 arch/powerpc/perf/bhrb.S                           |   44 ++
 arch/powerpc/perf/core-book3s.c                    |  231 +++++++-
 arch/powerpc/perf/power5+-pmu.c                    |    2 +-
 arch/powerpc/perf/power5-pmu.c                     |    1 +
 arch/powerpc/perf/power8-pmu.c                     |  592 ++++++++++++++++++++
 arch/powerpc/platforms/40x/Kconfig                 |    7 -
 arch/powerpc/platforms/512x/Kconfig                |    8 +-
 arch/powerpc/platforms/512x/Makefile               |    2 +-
 arch/powerpc/platforms/512x/clock.c                |    9 +-
 arch/powerpc/platforms/512x/mpc512x.h              |    1 +
 .../512x/{mpc5121_generic.c => mpc512x_generic.c}  |   12 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   33 +-
 arch/powerpc/platforms/85xx/Kconfig                |   34 ++
 arch/powerpc/platforms/85xx/Makefile               |    2 +
 arch/powerpc/platforms/85xx/b4_qds.c               |  102 ++++
 arch/powerpc/platforms/85xx/corenet_ds.c           |    5 +-
 arch/powerpc/platforms/85xx/smp.c                  |    2 +-
 arch/powerpc/platforms/85xx/t4240_qds.c            |   98 ++++
 arch/powerpc/platforms/Kconfig                     |    4 +-
 arch/powerpc/platforms/Kconfig.cputype             |    2 +-
 arch/powerpc/platforms/cell/beat_htab.c            |   26 +-
 arch/powerpc/platforms/cell/pmu.c                  |    2 +-
 arch/powerpc/platforms/cell/spufs/file.c           |    2 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    1 +
 arch/powerpc/platforms/embedded6xx/Kconfig         |    5 -
 arch/powerpc/platforms/powernv/Kconfig             |    5 +
 arch/powerpc/platforms/powernv/opal-wrappers.S     |    1 +
 arch/powerpc/platforms/powernv/pci-ioda.c          |  307 ++++++++--
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |   15 +-
 arch/powerpc/platforms/powernv/pci.c               |  113 +---
 arch/powerpc/platforms/powernv/pci.h               |   26 +-
 arch/powerpc/platforms/prep/Kconfig                |   23 -
 arch/powerpc/platforms/ps3/htab.c                  |    8 +-
 arch/powerpc/platforms/ps3/time.c                  |    4 +-
 arch/powerpc/platforms/pseries/firmware.c          |   54 +-
 arch/powerpc/platforms/pseries/iommu.c             |   26 +
 arch/powerpc/platforms/pseries/lpar.c              |    8 +-
 arch/powerpc/platforms/pseries/mobility.c          |   41 +-
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   15 +-
 arch/powerpc/platforms/pseries/pseries.h           |    5 +-
 arch/powerpc/platforms/pseries/setup.c             |   40 +-
 arch/powerpc/platforms/wsp/Kconfig                 |    5 -
 arch/powerpc/sysdev/Kconfig                        |    1 +
 arch/powerpc/sysdev/fsl_msi.c                      |    4 +-
 arch/powerpc/sysdev/fsl_pci.c                      |  114 ++--
 arch/powerpc/sysdev/fsl_pci.h                      |   13 +
 arch/powerpc/sysdev/indirect_pci.c                 |   10 +-
 arch/powerpc/sysdev/qe_lib/Kconfig                 |    2 +-
 arch/powerpc/sysdev/rtc_cmos_setup.c               |    5 +-
 arch/powerpc/sysdev/xics/icp-native.c              |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 arch/sh/mm/Kconfig                                 |    7 -
 drivers/macintosh/smu.c                            |    6 +-
 drivers/macintosh/via-pmu.c                        |    5 +-
 drivers/pci/probe.c                                |    2 +-
 drivers/pnp/pnpbios/core.c                         |    9 +-
 drivers/video/cirrusfb.c                           |   62 +-
 fs/binfmt_elf.c                                    |    3 +
 fs/binfmt_elf_fdpic.c                              |    8 +-
 include/uapi/linux/auxvec.h                        |    1 +
 199 files changed, 6489 insertions(+), 1328 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/cpus.txt
 delete mode 100644 Documentation/powerpc/sound.txt
 delete mode 100644 Documentation/powerpc/zImage_layout.txt
 create mode 100644 arch/powerpc/boot/dts/ac14xx.dts
 create mode 100644 arch/powerpc/boot/dts/b4420qds.dts
 create mode 100644 arch/powerpc/boot/dts/b4860qds.dts
 create mode 100644 arch/powerpc/boot/dts/b4qds.dts
 create mode 100644 arch/powerpc/boot/dts/fsl/b4420si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/b4420si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/b4860si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/b4si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/e6500_power_isa.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qonverge-usb2-dr-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-gpio-1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-gpio-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-gpio-3.dtsi
 rename arch/powerpc/boot/dts/fsl/{qoriq-sec4.1-0.dtsi => qoriq-sec5.0-0.dtsi} (83%)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t4240si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/mpc5125twr.dts
 create mode 100644 arch/powerpc/boot/dts/t4240qds.dts
 create mode 100644 arch/powerpc/perf/bhrb.S
 create mode 100644 arch/powerpc/perf/power8-pmu.c
 rename arch/powerpc/platforms/512x/{mpc5121_generic.c => mpc512x_generic.c} (83%)
 create mode 100644 arch/powerpc/platforms/85xx/b4_qds.c
 create mode 100644 arch/powerpc/platforms/85xx/t4240_qds.c
 delete mode 100644 arch/powerpc/platforms/prep/Kconfig


