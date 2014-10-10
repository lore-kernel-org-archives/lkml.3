Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaJJWqs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:46:48 -0400
Received: from ozlabs.org ([103.22.144.67]:36359 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbaJJWqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:46:45 -0400
Message-ID: <1412981172.21427.3.camel@concordia>
Subject: [git pull] Please pull mpe.git for-linus branch (for powerpc)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arndb@arndb.de>, gregkh@linuxfoundation.org,
        linuxppc-dev list <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 11 Oct 2014 09:46:12 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4UaPUiHs5g8NeQGeGyKy"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4UaPUiHs5g8NeQGeGyKy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here's a first pull request for powerpc updates for 3.18.

The bulk of the additions are for the "cxl" driver, for IBM's Coherent
Accelerator Processor Interface (CAPI). Most of it's in drivers/misc, which
Greg & Arnd maintain, Greg said he was happy for us to take it through our
tree. I've CC'ed them in case they have any last minute objections.

There's the usual minor cleanups and fixes, including a bit of noise in dri=
vers
from some of those. A bunch of updates to our EEH code, which has been gett=
ing
more testing. Several nice speedups from Anton, including 20% in clear_page=
().=20

And a bunch of updates for freescale from Scott.

cheers


The following changes since commit 9e82bf014195d6f0054982c463575cdce24292be=
:

  Linux 3.17-rc5 (2014-09-14 17:50:12 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git for-linus

for you to fetch changes up to d53ba6b3bba33432cc37b7101a86f8f3392c46e7:

  cxl: Fix afu_read() not doing finish_wait() on signal or non-blocking (20=
14-10-09 11:29:57 +1100)

----------------------------------------------------------------
Aaron Sierra (2):
      fsl_ifc: Fix csor_ext position in fsl_ifc_regs
      powerpc: fsl_pci: Add forced PCI Agent enumeration

Alexey Kardashevskiy (1):
      powerpc/iommu/ddw: Fix endianness

Andreas Schwab (1):
      powerpc: Simplify symbol check in prom_init_check.sh

Anton Blanchard (23):
      powerpc: Move adb symbol exports next to function definitions
      powerpc: Move via-cuda symbol exports next to function definitions
      powerpc: Move more symbol exports next to function definitions
      powerpc: Remove unused 32bit symbol exports
      powerpc: Move lib symbol exports into arch/powerpc/lib/ppc_ksyms.c
      powerpc: Separate ppc32 symbol exports into ppc_ksyms_32.c
      powerpc: Make a bunch of things static
      powerpc: Ensure global functions include their prototype
      powerpc: Remove stale function prototypes
      powerpc: Move htab_remove_mapping function prototype into header file
      powerpc: Add POWER8 CPU selection
      powerpc: Use CONFIG_ARCH_HAS_FAST_MULTIPLIER
      powerpc: Implement load_unaligned_zeropad
      powerpc: ppc64le optimised word at a time
      powerpc: Enable DCACHE_WORD_ACCESS on ppc64le
      powerpc: Speed up clear_page by unrolling it
      powerpc: Simplify do_sigbus
      powerpc: Add VM_FAULT_HWPOISON handling to powerpc page fault handler
      powerpc: Fill in si_addr_lsb siginfo field
      powerpc: Use pr_fmt in module loader code
      powerpc: Remove powerpc specific cmd_line
      powerpc: Add printk levels to powernv platform code
      powerpc: Add printk levels to powerpc code

Benjamin Herrenschmidt (1):
      powerpc/powernv: Fix endian bug in LPC bus debugfs accessors

Cody P Schafer (1):
      powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack allocat=
ions

Gavin Shan (21):
      powerpc/eeh: Drop unused argument in eeh_check_failure()
      powerpc/eeh: Add eeh_pe_state sysfs entry
      powerpc/eeh: Freeze PE before PE reset
      powerpc/eeh: Reenable PCI devices after reset
      powerpc/eeh: Clear frozen state on passing device
      powerpc/powernv: Sync header with firmware
      powerpc/eeh: Introduce eeh_ops::err_inject
      powerpc/powernv: Clear PAPR error injection registers
      powerpc/eeh: Clear frozen device state in time
      powerpc/eeh: Fix improper condition in eeh_pci_enable()
      powerpc/eeh: Unfreeze PE on enabling EEH functionality
      powerpc/eeh: Use eeh_unfreeze_pe()
      powerpc/eeh: Block PCI config access during reset
      powerpc/pseries: Decrease message level on EEH initialization
      powerpc/powernv: Sync OpalPciResetScope with firmware
      powerpc/eeh: Tag reset state for user owned PE
      powerpc/eeh: Emulate EEH recovery for VFIO devices
      powerpc/eeh: Dump PCI config space for all child devices
      powerpc/powernv: Fetch frozen PE on top level
      powerpc/powernv: Override dma_get_required_mask()
      powerpc/eeh: Show hex prefix for PE state sysfs

Himangi Saraogi (1):
      powerpc/pseries: Drop unnecessary continue

Ian Munsie (17):
      powerpc/cell: Move spu_handle_mm_fault() out of cell platform
      powerpc/cell: Move data segment faulting code out of cell platform
      powerpc/cell: Make spu_flush_all_slbs() generic
      powerpc/msi: Improve IRQ bitmap allocator
      powerpc/mm: Export mmu_kernel_ssize and mmu_linear_psize
      powerpc/powernv: Split out set MSI IRQ chip code
      cxl: Add new header for call backs and structs
      powerpc/powerpc: Add new PCIe functions for allocating cxl interrupts
      powerpc/mm: Add new hash_page_mm()
      powerpc/opal: Add PHB to cxl mode call
      powerpc/mm: Add hooks for cxl
      cxl: Add base builtin support
      cxl: Driver code for powernv PCIe based cards for userspace access
      cxl: Add userspace header file
      cxl: Add driver to Kbuild and Makefiles
      cxl: Add documentation for userspace APIs
      cxl: Fix afu_read() not doing finish_wait() on signal or non-blocking

Joe Perches (2):
      powerpc: pci-ioda: Remove unnecessary return value from printk
      powerpc: pci-ioda: Use a single function to emit logging messages

LEROY Christophe (7):
      powerpc/8xx: Declare SPRG2 as a SCRATCH register
      powerpc/8xx: Use SCRATCH0 and SCRATCH1 also for TLB handlers
      powerpc/8xx: Remove loading of r10 at end of FixupDAR
      powerpc/8xx: Fix comment about DIRTY update
      powerpc/8xx: No need to save r10 and r3 when not calling FixupDAR
      powerpc/8xx: Optimize verification in FixupDAR
      powerpc/8xx: Duplicate two insns instead of branching

Li Zhong (3):
      powerpc: Fix warning reported by verify_cpu_node_mapping()
      powerpc: Only set numa node information for present cpus at boottime
      powerpc: some changes in numa_setup_cpu()

Michael Ellerman (9):
      powerpc: Check flat device tree version at boot
      powerpc/ppc64: Clean up the boot-time settings display
      powerpc/ppc64: Print CPU/MMU/FW features at boot
      powerpc/mm: Unindent htab_dt_scan_page_sizes()
      selftests/powerpc: Add test of load_unaligned_zero_pad()
      powerpc: Don't build powernv for other platform defconfigs
      powerpc/kdump: crash_dump.c needs to include io.h
      powerpc: Enable CONFIG_CRASH_DUMP=3Dy for ppc64_defconfig
      Merge branch 'next' of git://git.kernel.org/.../scottwood/linux.git

Michael Neuling (5):
      powerpc/powernv: Add OPAL check token call
      powerpc/powernv: Check OPAL RTC calls exists before using
      powerpc/powernv: Check OPAL elog calls exist before using
      powerpc/powernv: Check OPAL dump calls exist before using
      powerpc/pseries: Use new defines when calling H_SET_MODE

Mike Qiu (1):
      powerpc/powernv: Add PCI error injection debugfs entry

Nikhil Badola (3):
      powerpc: configs: Add VFAT file-system configs
      powerpc: dts: t4240: Change T4240 USB controller version
      powerpc: dts: t208x: Change T208x USB controller version

Paul Mackerras (4):
      powerpc/powernv: Don't call generic code on offline cpus
      powerpc: Split out instruction analysis part of emulate_step()
      powerpc: Emulate icbi, mcrf and conditional-trap instructions
      powerpc: Implement emulation of string loads and stores

Pranith Kumar (4):
      powerpc: Fix build error with CONFIG_PCI=3Dn
      powerpc: Export dcr_ind_lock to fix build error
      powerpc: Fix build failure on 44x
      powerpc: Fix build failure when CONFIG_USB=3Dy

Priyanka Jain (2):
      powerpc/fsl-booke: Add initial T1040/T1042 RDB board support
      powerpc/fsl-booke: Add initial T1042RDB_PI board support

Scott Wood (7):
      powerpc: Dynamic DMA zone limits
      powerpc/64: Honor swiotlb limit in coherent allocations
      powerpc/64: Limit ZONE_DMA32 to 4GiB in swiotlb_detect_4g()
      powerpc/fsl-pci: Limit ZONE_DMA32 to 2GiB on 64-bit platforms
      powerpc/85xx/defconfig: Remove duplicate CONFIG_RTC_DRV_DS1307
      powerpc/mm: Use common paging_init() for NUMA
      Revert "powerpc/fsl_msi: spread msi ints across different MSIRs"

Thomas Falcon (2):
      pseries: Fix endian issues in onlining cpu threads
      pseries: Fix endian issues in cpu hot-removal

Tony Breeds (1):
      powerpc/boot: Don't install zImage.* from make install

Tudor Laurentiu (6):
      powerpc/fsl_msi: support vmpic msi with mpic 4.3
      powerpc/fsl_msi: reorganize structs to improve clarity and flexibilit=
y
      powerpc/fsl_msi: change the irq handler from chained to normal
      powerpc/fsl_msi: show more meaningful names in /proc/interrupts
      powerpc/fsl_msi: spread msi ints across different MSIRs
      powerpc/fsl-booke64: add missing virtualization options in defconfig

Uwe Kleine-K=C3=B6nig (1):
      powerpc: make of_device_ids const

Vasant Hegde (1):
      powerpc/powernv: Improve error messages in dump code

Wei Yang (2):
      powerpc/eeh: Fix kernel crash when passing through VF
      powerpc/pci: remove duplicate declaration of pci_bus_find_capability

Zhouyi Zhou (1):
      powerpc/jump_label: use HAVE_JUMP_LABEL?

sukadev@linux.vnet.ibm.com (2):
      powerpc/perf/hv-24x7: Simplify catalog_read()
      powerpc: Update contact info in Documentation files

 .../testing/sysfs-bus-event_source-devices-hv_24x7 |    6 +-
 .../testing/sysfs-bus-event_source-devices-hv_gpci |   12 +-
 Documentation/ABI/testing/sysfs-class-cxl          |  129 +++
 Documentation/devicetree/bindings/pci/fsl,pci.txt  |   27 +
 Documentation/ioctl/ioctl-number.txt               |    1 +
 Documentation/powerpc/00-INDEX                     |    2 +
 Documentation/powerpc/cxl.txt                      |  379 ++++++++
 MAINTAINERS                                        |   12 +
 arch/powerpc/Kconfig                               |   11 +-
 arch/powerpc/Makefile                              |    1 +
 arch/powerpc/boot/Makefile                         |    5 +
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |    4 +-
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |    4 +-
 arch/powerpc/boot/dts/t1040rdb.dts                 |   48 +
 arch/powerpc/boot/dts/t1042rdb.dts                 |   48 +
 arch/powerpc/boot/dts/t1042rdb_pi.dts              |   57 ++
 arch/powerpc/boot/dts/t104xrdb.dtsi                |  156 +++
 arch/powerpc/configs/cell_defconfig                |    1 +
 arch/powerpc/configs/celleb_defconfig              |    1 +
 arch/powerpc/configs/corenet32_smp_defconfig       |    2 +
 arch/powerpc/configs/corenet64_smp_defconfig       |   46 +-
 arch/powerpc/configs/g5_defconfig                  |    1 +
 arch/powerpc/configs/maple_defconfig               |    1 +
 arch/powerpc/configs/mpc85xx_defconfig             |    4 +-
 arch/powerpc/configs/mpc85xx_smp_defconfig         |    4 +-
 arch/powerpc/configs/mpc86xx_defconfig             |    3 +
 arch/powerpc/configs/pasemi_defconfig              |    1 +
 arch/powerpc/configs/ppc64_defconfig               |    1 +
 arch/powerpc/include/asm/bug.h                     |    1 -
 arch/powerpc/include/asm/copro.h                   |   29 +
 arch/powerpc/include/asm/dma-mapping.h             |    1 +
 arch/powerpc/include/asm/eeh.h                     |   39 +-
 arch/powerpc/include/asm/hydra.h                   |    1 -
 arch/powerpc/include/asm/irq.h                     |    5 -
 arch/powerpc/include/asm/kexec.h                   |    1 -
 arch/powerpc/include/asm/machdep.h                 |    2 -
 arch/powerpc/include/asm/mmu-hash64.h              |   10 +
 arch/powerpc/include/asm/opal.h                    |   45 +-
 arch/powerpc/include/asm/page_64.h                 |   43 +-
 arch/powerpc/include/asm/pgtable-ppc32.h           |    6 +-
 arch/powerpc/include/asm/pgtable-ppc64-4k.h        |    2 +-
 arch/powerpc/include/asm/pgtable-ppc64.h           |    6 +-
 arch/powerpc/include/asm/pgtable.h                 |    3 +
 arch/powerpc/include/asm/plpar_wrappers.h          |   12 +-
 arch/powerpc/include/asm/pnv-pci.h                 |   31 +
 arch/powerpc/include/asm/prom.h                    |    2 -
 arch/powerpc/include/asm/reg.h                     |    3 +-
 arch/powerpc/include/asm/rio.h                     |    1 -
 arch/powerpc/include/asm/spu.h                     |    5 +-
 arch/powerpc/include/asm/sstep.h                   |   62 ++
 arch/powerpc/include/asm/tsi108.h                  |    4 -
 arch/powerpc/include/asm/udbg.h                    |    1 -
 arch/powerpc/include/asm/word-at-a-time.h          |  112 ++-
 arch/powerpc/include/asm/xics.h                    |    1 +
 arch/powerpc/kernel/Makefile                       |    3 +
 arch/powerpc/kernel/crash_dump.c                   |    1 +
 arch/powerpc/kernel/dma-swiotlb.c                  |    8 +-
 arch/powerpc/kernel/dma.c                          |   47 +-
 arch/powerpc/kernel/eeh.c                          |  269 ++++--
 arch/powerpc/kernel/eeh_driver.c                   |  106 ++-
 arch/powerpc/kernel/eeh_pe.c                       |   23 +-
 arch/powerpc/kernel/eeh_sysfs.c                    |   41 +-
 arch/powerpc/kernel/head_8xx.S                     |  150 ++-
 arch/powerpc/kernel/hw_breakpoint.c                |    2 +-
 arch/powerpc/kernel/ibmebus.c                      |    2 +-
 arch/powerpc/kernel/idle_power7.S                  |    2 +-
 arch/powerpc/kernel/irq.c                          |    6 +-
 arch/powerpc/kernel/legacy_serial.c                |    2 +-
 arch/powerpc/kernel/module_32.c                    |   31 +-
 arch/powerpc/kernel/module_64.c                    |   36 +-
 arch/powerpc/kernel/nvram_64.c                     |    2 +-
 arch/powerpc/kernel/of_platform.c                  |    2 +-
 arch/powerpc/kernel/pci-common.c                   |    3 +-
 arch/powerpc/kernel/pci_of_scan.c                  |    2 +-
 arch/powerpc/kernel/ppc_ksyms.c                    |  192 +---
 arch/powerpc/kernel/ppc_ksyms_32.c                 |   61 ++
 arch/powerpc/kernel/process.c                      |    2 +
 arch/powerpc/kernel/prom.c                         |   13 +-
 arch/powerpc/kernel/prom_init_check.sh             |   22 +-
 arch/powerpc/kernel/ptrace.c                       |    2 +-
 arch/powerpc/kernel/rtasd.c                        |    2 +-
 arch/powerpc/kernel/setup-common.c                 |    7 +-
 arch/powerpc/kernel/setup_32.c                     |    2 +-
 arch/powerpc/kernel/setup_64.c                     |   32 +-
 arch/powerpc/kernel/smp.c                          |   11 +-
 arch/powerpc/kernel/time.c                         |    5 +-
 arch/powerpc/lib/Makefile                          |    2 +-
 arch/powerpc/lib/feature-fixups.c                  |    2 +-
 arch/powerpc/lib/ppc_ksyms.c                       |   39 +
 arch/powerpc/lib/sstep.c                           |  996 ++++++++++++----=
---
 arch/powerpc/mm/Makefile                           |    1 +
 .../cell/spu_fault.c =3D> mm/copro_fault.c}          |   69 +-
 arch/powerpc/mm/fault.c                            |   43 +-
 arch/powerpc/mm/hash_native_64.c                   |    6 +-
 arch/powerpc/mm/hash_utils_64.c                    |  160 ++--
 arch/powerpc/mm/init_32.c                          |    4 +-
 arch/powerpc/mm/init_64.c                          |    3 -
 arch/powerpc/mm/mem.c                              |   68 +-
 arch/powerpc/mm/numa.c                             |   27 +-
 arch/powerpc/mm/pgtable.c                          |    2 +-
 arch/powerpc/mm/slb.c                              |    3 -
 arch/powerpc/mm/slice.c                            |   12 +-
 arch/powerpc/oprofile/backtrace.c                  |    1 +
 arch/powerpc/perf/core-book3s.c                    |   18 +-
 arch/powerpc/perf/hv-24x7.c                        |  156 +--
 arch/powerpc/platforms/40x/ep405.c                 |    2 +-
 arch/powerpc/platforms/40x/ppc40x_simple.c         |    2 +-
 arch/powerpc/platforms/40x/virtex.c                |    2 +-
 arch/powerpc/platforms/40x/walnut.c                |    2 +-
 arch/powerpc/platforms/44x/Kconfig                 |    6 +-
 arch/powerpc/platforms/44x/canyonlands.c           |    2 +-
 arch/powerpc/platforms/44x/ebony.c                 |    2 +-
 arch/powerpc/platforms/44x/iss4xx.c                |    2 +-
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    2 +-
 arch/powerpc/platforms/44x/ppc476.c                |    2 +-
 arch/powerpc/platforms/44x/sam440ep.c              |    2 +-
 arch/powerpc/platforms/44x/virtex.c                |    2 +-
 arch/powerpc/platforms/44x/warp.c                  |    2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |    2 +-
 arch/powerpc/platforms/52xx/lite5200.c             |    4 +-
 arch/powerpc/platforms/52xx/media5200.c            |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |   12 +-
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |    4 +-
 arch/powerpc/platforms/82xx/ep8248e.c              |    2 +-
 arch/powerpc/platforms/82xx/km82xx.c               |    2 +-
 arch/powerpc/platforms/82xx/mpc8272_ads.c          |    2 +-
 arch/powerpc/platforms/82xx/pq2fads.c              |    2 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |    2 +-
 arch/powerpc/platforms/83xx/misc.c                 |    2 +-
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    2 +-
 arch/powerpc/platforms/83xx/suspend.c              |    4 +-
 arch/powerpc/platforms/85xx/Kconfig                |    2 +-
 arch/powerpc/platforms/85xx/common.c               |    2 +-
 arch/powerpc/platforms/85xx/corenet_generic.c      |   14 +
 arch/powerpc/platforms/85xx/ppa8548.c              |    2 +-
 arch/powerpc/platforms/85xx/qemu_e500.c            |   10 +
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |    4 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    2 +-
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    2 +-
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    2 +-
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    2 +-
 arch/powerpc/platforms/86xx/sbc8641d.c             |    2 +-
 arch/powerpc/platforms/8xx/adder875.c              |    2 +-
 arch/powerpc/platforms/8xx/ep88xc.c                |    2 +-
 arch/powerpc/platforms/8xx/mpc86xads_setup.c       |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |    2 +-
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |    2 +-
 arch/powerpc/platforms/Kconfig.cputype             |    6 +
 arch/powerpc/platforms/cell/Kconfig                |    1 +
 arch/powerpc/platforms/cell/Makefile               |    2 +-
 arch/powerpc/platforms/cell/celleb_pci.c           |    2 +-
 arch/powerpc/platforms/cell/celleb_setup.c         |    2 +-
 arch/powerpc/platforms/cell/spu_base.c             |   55 +-
 arch/powerpc/platforms/cell/spufs/fault.c          |    4 +-
 arch/powerpc/platforms/chrp/setup.c                |    2 +-
 arch/powerpc/platforms/embedded6xx/gamecube.c      |    2 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c   |    2 +-
 arch/powerpc/platforms/embedded6xx/mvme5100.c      |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    2 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |    2 +-
 arch/powerpc/platforms/pasemi/gpio_mdio.c          |    2 +-
 arch/powerpc/platforms/pasemi/setup.c              |    2 +-
 arch/powerpc/platforms/powermac/setup.c            |    8 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c          |  226 ++++-
 arch/powerpc/platforms/powernv/eeh-powernv.c       |   26 +
 arch/powerpc/platforms/powernv/opal-dump.c         |   18 +-
 arch/powerpc/platforms/powernv/opal-elog.c         |    4 +
 arch/powerpc/platforms/powernv/opal-lpc.c          |    4 +-
 arch/powerpc/platforms/powernv/opal-nvram.c        |    2 +-
 arch/powerpc/platforms/powernv/opal-rtc.c          |   15 +-
 arch/powerpc/platforms/powernv/opal-tracepoints.c  |    2 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |    3 +
 arch/powerpc/platforms/powernv/opal.c              |    6 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          |  290 ++++--
 arch/powerpc/platforms/powernv/pci.c               |   11 +
 arch/powerpc/platforms/powernv/pci.h               |    4 +
 arch/powerpc/platforms/powernv/powernv.h           |    6 +
 arch/powerpc/platforms/powernv/setup.c             |   11 +-
 arch/powerpc/platforms/powernv/smp.c               |    8 +-
 arch/powerpc/platforms/powernv/subcore.c           |    1 +
 arch/powerpc/platforms/pseries/cmm.c               |    1 -
 arch/powerpc/platforms/pseries/dlpar.c             |   29 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   40 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   10 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |    1 +
 arch/powerpc/platforms/pseries/iommu.c             |   51 +-
 arch/powerpc/platforms/pseries/lpar.c              |    4 +-
 arch/powerpc/platforms/pseries/nvram.c             |   12 +-
 arch/powerpc/platforms/pseries/pci.c               |    1 +
 arch/powerpc/platforms/pseries/ras.c               |    2 +-
 arch/powerpc/platforms/pseries/setup.c             |    2 +-
 arch/powerpc/sysdev/axonram.c                      |    2 +-
 arch/powerpc/sysdev/dcr.c                          |    1 +
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c              |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                      |   95 +-
 arch/powerpc/sysdev/fsl_msi.h                      |    4 +-
 arch/powerpc/sysdev/fsl_pci.c                      |    3 +-
 arch/powerpc/sysdev/mpic.c                         |    2 +-
 arch/powerpc/sysdev/msi_bitmap.c                   |   42 +-
 arch/powerpc/sysdev/mv64x60_dev.c                  |    2 +-
 arch/powerpc/sysdev/pmi.c                          |    2 +-
 arch/powerpc/sysdev/xics/icp-native.c              |   25 +
 arch/powerpc/sysdev/xilinx_intc.c                  |    2 +-
 arch/powerpc/sysdev/xilinx_pci.c                   |    2 +-
 drivers/cpufreq/pmac32-cpufreq.c                   |    2 +-
 drivers/macintosh/adb.c                            |    5 +
 drivers/macintosh/via-cuda.c                       |    2 +
 drivers/misc/Kconfig                               |    1 +
 drivers/misc/Makefile                              |    1 +
 drivers/misc/cxl/Kconfig                           |   25 +
 drivers/misc/cxl/Makefile                          |    3 +
 drivers/misc/cxl/base.c                            |   86 ++
 drivers/misc/cxl/context.c                         |  193 ++++
 drivers/misc/cxl/cxl.h                             |  629 ++++++++++++
 drivers/misc/cxl/debugfs.c                         |  132 +++
 drivers/misc/cxl/fault.c                           |  291 ++++++
 drivers/misc/cxl/file.c                            |  518 ++++++++++
 drivers/misc/cxl/irq.c                             |  402 ++++++++
 drivers/misc/cxl/main.c                            |  230 +++++
 drivers/misc/cxl/native.c                          |  683 +++++++++++++
 drivers/misc/cxl/pci.c                             | 1000 ++++++++++++++++=
++++
 drivers/misc/cxl/sysfs.c                           |  385 ++++++++
 drivers/tty/hvc/hvc_vio.c                          |    2 +-
 include/linux/fsl_ifc.h                            |    6 +-
 include/misc/cxl.h                                 |   48 +
 include/uapi/Kbuild                                |    1 +
 include/uapi/misc/Kbuild                           |    2 +
 include/uapi/misc/cxl.h                            |   88 ++
 tools/testing/selftests/powerpc/Makefile           |    2 +-
 .../testing/selftests/powerpc/primitives/Makefile  |   17 +
 .../selftests/powerpc/primitives/asm/asm-compat.h  |    1 +
 .../selftests/powerpc/primitives/asm/ppc-opcode.h  |    0
 .../powerpc/primitives/load_unaligned_zeropad.c    |  147 +++
 .../selftests/powerpc/primitives/word-at-a-time.h  |    1 +
 236 files changed, 8633 insertions(+), 1566 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-cxl
 create mode 100644 Documentation/devicetree/bindings/pci/fsl,pci.txt
 create mode 100644 Documentation/powerpc/cxl.txt
 create mode 100644 arch/powerpc/boot/dts/t1040rdb.dts
 create mode 100644 arch/powerpc/boot/dts/t1042rdb.dts
 create mode 100644 arch/powerpc/boot/dts/t1042rdb_pi.dts
 create mode 100644 arch/powerpc/boot/dts/t104xrdb.dtsi
 create mode 100644 arch/powerpc/include/asm/copro.h
 create mode 100644 arch/powerpc/include/asm/pnv-pci.h
 create mode 100644 arch/powerpc/kernel/ppc_ksyms_32.c
 create mode 100644 arch/powerpc/lib/ppc_ksyms.c
 rename arch/powerpc/{platforms/cell/spu_fault.c =3D> mm/copro_fault.c} (56=
%)
 create mode 100644 drivers/misc/cxl/Kconfig
 create mode 100644 drivers/misc/cxl/Makefile
 create mode 100644 drivers/misc/cxl/base.c
 create mode 100644 drivers/misc/cxl/context.c
 create mode 100644 drivers/misc/cxl/cxl.h
 create mode 100644 drivers/misc/cxl/debugfs.c
 create mode 100644 drivers/misc/cxl/fault.c
 create mode 100644 drivers/misc/cxl/file.c
 create mode 100644 drivers/misc/cxl/irq.c
 create mode 100644 drivers/misc/cxl/main.c
 create mode 100644 drivers/misc/cxl/native.c
 create mode 100644 drivers/misc/cxl/pci.c
 create mode 100644 drivers/misc/cxl/sysfs.c
 create mode 100644 include/misc/cxl.h
 create mode 100644 include/uapi/misc/Kbuild
 create mode 100644 include/uapi/misc/cxl.h
 create mode 100644 tools/testing/selftests/powerpc/primitives/Makefile
 create mode 120000 tools/testing/selftests/powerpc/primitives/asm/asm-comp=
at.h
 create mode 100644 tools/testing/selftests/powerpc/primitives/asm/ppc-opco=
de.h
 create mode 100644 tools/testing/selftests/powerpc/primitives/load_unalign=
ed_zeropad.c
 create mode 120000 tools/testing/selftests/powerpc/primitives/word-at-a-ti=
me.h


--=-4UaPUiHs5g8NeQGeGyKy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJUOGHSAAoJEFHr6jzI4aWA0FAQAKVgF6VhRwaye2zW4oYlhhFw
Ydk3KujNm/2Z9AjPLYLu6H0z49Azl3CrdkJ1cQYJDVw45hIcGueQZpH02BBnzYy4
KSSU1r1IdmetPsSECNJlnQNfQ3NTNMOVbLcv2cgWrThQztVA3FkgKO4TUofdw/kj
vjTLZJkW7eTmoJOPTaagNk56UYo6Z6BcpiBKUaakTh0Vo/6W6vNvQR6e9W5mUGbe
4VXzEc77aCzLzzXgJbPddpwdOw+5/GHf74YWfNz9Q07OhsD1lK7J/+mIHuZCwzlL
ZOfiqoqX74q7wkY2nSSOysezrQKq7oDLAuEuKTrRPiB1J0+4N1XbuKxWjrXVRGHk
IxUP1iQ/no8Hgs5PDqPxu+aq/FwaAx/BxsVQMJvthFv8k4y7lJFTnhgvZDFVpdLN
dTGdoN8QS55iSwX7jL2zaREcsZDApEpygDfGrIPWZY+Idk/jr1EeQzcDxzkAvtAA
WMngpI4b7NI/4KdtgxDeRptRGnzPDHcm2DxGyPqKvoOpsKx06btI7CmJTsoXw1+p
du4Tx/UCufl2LoBowApOaZeaQ53QtrN7Fs0oQnFPCqGLXSCET3YCP8CAE58sX7JB
3p1+JOOgDbSmYOTEX2OD1UHToWReaIhpIePtNwK7CuhiPvdZOXvKa/mlyppvYlQI
mhJjUjjdyU3UoukMOJhj
=7IyG
-----END PGP SIGNATURE-----

--=-4UaPUiHs5g8NeQGeGyKy--

