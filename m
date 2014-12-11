Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaLKFOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 00:14:39 -0500
Received: from ozlabs.org ([103.22.144.67]:50410 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbaLKFOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 00:14:37 -0500
Message-ID: <1418274873.24554.2.camel@ellerman.id.au>
Subject: [git pull] Please pull mpe/linux.git powerpc-3.19-1 tag
From: Michael Ellerman <mpe@ellerman.id.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, agraf@suse.de,
        aneesh.kumar@linux.vnet.ibm.com, anton@samba.org,
        Ashish.Kumar@freescale.com, boqun.feng@linux.vnet.ibm.com,
        christophe.leroy@c-s.fr, cl@linux.com, Emilian.Medve@freescale.com,
        gkurz@linux.vnet.ibm.com, gwshan@linux.vnet.ibm.com,
        hongtao.jia@freescale.com, Igal.Liberman@freescale.com,
        imunsie@au1.ibm.com, James.Yang@freescale.com, jk@ozlabs.org,
        jslaby@suse.cz, Julia.Lawall@lip6.fr, khandual@linux.vnet.ibm.com,
        kyle@redhat.com, lu.jiang@windriver.com, mahesh@linux.vnet.ibm.com,
        martijn.de.gouw@prodrive-technologies.com, mikey@neuling.org,
        neelegup@linux.vnet.ibm.com, paulus@samba.org, pebolle@tiscali.nl,
        prabhakar@freescale.com, scottwood@freescale.com,
        simon.kagstrom@netinsight.net, vvijayan@mvista.com,
        warrier@linux.vnet.ibm.com, zhong@linux.vnet.ibm.com,
        benh@kernel.crashing.org, scottwood@freescale.com,
        steve.capper@linaro.org, Andrew Morton <akpm@osdl.org>
Date: Thu, 11 Dec 2014 16:14:33 +1100
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-8Z1mLhUPa+uADsToTHph"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8Z1mLhUPa+uADsToTHph
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the first batch of powerpc updates for 3.19:

The following changes since commit 8a97577a5967c1234ccc3bc1b45e4b1a58b39ea8=
:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/mpe/linux (2014-11-04 11:18:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mpe/linux.git tags/powerpc-=
3.19-1

for you to fetch changes up to 56548fc0e86cb9156af7a7e1f15ba78f251dafaf:

  powerpc/powernv: Return to cpu offline loop when finished in KVM guest (2=
014-12-08 13:16:31 +1100)

----------------------------------------------------------------
Some nice cleanups like removing bootmem, and removal of __get_cpu_var().

There is one patch to mm/gup.c. This is the generic GUP implementation, but=
 is
only used by us and arm(64). We have an ack from Steve Capper, and although=
 we
didn't get an ack from Andrew he told us to take the patch through the powe=
rpc
tree.

There's one cxl patch. This is in drivers/misc, but Greg said he was happy =
for
us to manage fixes for it.

There is an infrastructure patch to support an IPMI driver for OPAL. That p=
atch
also appears in Corey Minyard's IPMI tree, you may see a conflict there.

There is also an RTC driver for OPAL. We weren't able to get any response f=
rom
the RTC maintainer, Alessandro Zummo, so in the end we just merged the driv=
er.

The usual batch of Freescale updates from Scott.
----------------------------------------------------------------

Alexander Graf (1):
      powerpc: Convert power off logic to pm_power_off

Aneesh Kumar K.V (8):
      powerpc: Disable CPU_FTR_TM if TM is disabled by firmware
      powerpc/mm: Add missing pmd accessors
      mm: Update generic gup implementation to handle hugepage directory
      powerpc/mm: Switch to generic RCU get_user_pages_fast
      powerpc/mm: Check for matching hpte without taking hpte lock
      powerpc/mm/thp: Remove code duplication
      powerpc/mm/thp: Use tlbiel if possible
      powerpc/mm: don't do tlbie for updatepp request with NO HPTE fault

Anshuman Khandual (1):
      powerpc/xmon: Enable HW instruction breakpoint on POWER8

Anton Blanchard (18):
      powerpc: Use probe_kernel_address in show_instructions
      powerpc/pci: Quieten unset I/O resource warning
      powerpc: Remove ppc64_boot_msg
      powerpc: Remove ppc_md.remove_memory
      powerpc: Remove bootmem allocator
      powerpc: Remove some old bootmem related comments
      powerpc: Remove superfluous bootmem includes
      powerpc: Move sparse_init() into initmem_init
      powerpc: make __ffs return unsigned long
      powerpc/ftrace: Remove mod_return_to_handler
      powerpc/ftrace: simplify prepare_ftrace_return
      powerpc/jump_label: Use HAVE_JUMP_LABEL
      powerpc: Don't use local named register variable in current_thread_in=
fo
      powerpc: Remove double braces in alignment code.
      powerpc: LLVM complains about forward declaration of struct rtas_sens=
ors
      powerpc/pseries: Quieten ibm,pcie-link-speed-stats warning
      powerpc/pseries: Quieten relocation on exceptions warning
      powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()

Ashish Kumar (1):
      powerpc/mpc85xx: Remove SPI and NAND partition from bsc9131rdb.dtsi

Boqun Feng (1):
      powerpc: Fix comment typos in arch/powerpc/include/asm/bitops.h

Christoph Lameter (1):
      powerpc: Replace __get_cpu_var uses

Emil Medve (7):
      powerpc/dts: Factorize the clock control node
      dt/bindings: qoriq-clock: Add binding for the platform PLL
      powerpc/dts: Add node(s) for the platform PLL
      dt/bindings: Introduce the FSL QorIQ DPAA BMan
      dt/bindings: Introduce the FSL QorIQ DPAA BMan portal(s)
      dt/bindings: Introduce the FSL QorIQ DPAA QMan
      dt/bindings: Introduce the FSL QorIQ DPAA QMan portal(s)

Gavin Shan (13):
      powerpc/mm: Use PAGE_FACTOR
      powerpc/powernv: Check PHB type in advance
      powerpc/powernv: Fix condition to remove M64
      powerpc/powernv: Rename alloc_m64_pe() to reserve_m64_pe()
      powerpc/powernv: Initialize M64 PE in time
      powerpc/powernv: Set PELTV for compound PEs
      powerpc/powernv: Simplify pnv_ioda_configure_pe()
      powerpc/powernv: Bail upon invalid master PE
      powerpc/powernv: Fix potential zero devisor
      powerpc/eeh: Refactor eeh_reset_pe()
      powerpc/eeh: Set EEH_PE_RESET on PE reset
      powerpc/eeh: Recover EEH error on ownership change for BCM5719
      powerpc/eeh: Dump PHB diag-data early

Greg Kurz (1):
      powerpc: Drop useless warning in eeh_init()

Hongtao Jia (2):
      powerpc: Add ADT7461 to device tree for supported boards
      powerpc: Add INA220 to device tree for supported boards

Ian Munsie (1):
      cxl: Return error to PSL if IRQ demultiplexing fails & print clearer =
warning

Igal Liberman (2):
      powerpc/fsl: Added rcw registers to global utility registers
      powerpc/fsl: Frame Manager Device Tree binding document

James Yang (1):
      powerpc/mm/hugetlb: Sanity check gigantic hugepage count

Jeremy Kerr (1):
      powerpc/powernv: Add OPAL IPMI interface

Jiang Lu (1):
      powerpc/oprofile: Disable pagefaults during user stack read

Jiri Slaby (1):
      powerpc/ftrace: Fix obsolete comment

Julia Lawall (5):
      powerpc/4xx/cpm: delete unneeded test before of_node_put
      powerpc/fsl: fsl_soc: delete unneeded test before of_node_put
      powerpc/mpc5xxx: delete unneeded test before of_node_put
      powerpc/pseries: delete unneeded test before of_node_put
      powerpc/gamecube/wii: delete unneeded test before of_node_put

Kyle McMartin (1):
      powerpc: Remove unused devm_ioremap_prot()

LEROY Christophe (14):
      powerpc/8xx: exception InstructionAccess does not exist on MPC8xx
      powerpc/8xx: DataAccess exception not generated by MPC8xx
      powerpc/8xx: No need to restore registers and save them again.
      powerpc/8xx: Use M_TW instead of M_TWB
      powerpc/8xx: Don't use MD_TWC for walk
      powerpc/8xx: Use PAGE size related consts
      powerpc/8xx: Const for TLB RPN forced value
      powerpc/8xx: Implement 16k pages
      powerpc/8xx: Better readibility of ERRATA CPU6 handling
      powerpc/8xx: set PTE bit 22 off TLBmiss
      powerpc/8xx: _PMD_PRESENT already set in level 1 entries
      powerpc/8xx: Don't restore regs to save them again.
      powerpc/8xx: Use DAR to save r3 for CPU6 ERRATA
      powerpc/8xx: Invalidate non present TLB as early as possible

Li Zhong (1):
      powerpc/pseries: Initialise nvram_pstore_info's buf_lock

Mahesh Salgaonkar (2):
      powerpc/powernv: Cleanup unused MCE definitions/declarations.
      powerpc/book3s: Fix partial invalidation of TLBs in MCE code.

Martijn de Gouw (1):
      powerpc/fsl-rio: add support for mapping inbound windows

Michael Ellerman (11):
      Merge branch 'topic/pm-power-off' into next
      Merge branch 'topic/get-cpu-var' into next
      powerpc: Remove CPU_FTR_HVMODE from CPU_FTRS_ALWAYS
      powerpc: Remove unused CPU_FTRS_A2
      powerpc: Remove unused vgacon_remap_base & fix build break
      Merge branch 'topic/opal-ipmi' into next
      powerpc/xmon: Fix build when 4xx=3Dy and 44x=3Dn
      Merge remote-tracking branch 'scottwood/next' into next
      powerpc: Remove more traces of bootmem
      Merge remote-tracking branch 'benh/next' into next
      powerpc/xmon: Cleanup the breakpoint flags

Michael Neuling (1):
      cxl: Name interrupts in /proc/interrupt

Neelesh Gupta (1):
      rtc/tpo: Driver to support rtc and wakeup on PowerNV platform

Paul Bolle (1):
      powerpc/8xx: Remove Kconfig symbol FADS

Paul Mackerras (2):
      powerpc: Fix compilation of emulate_step()
      powerpc/powernv: Return to cpu offline loop when finished in KVM gues=
t

Prabhakar Kushwaha (1):
      powerpc/config: Enable memory driver

Scott Wood (1):
      powerpc/fsl: Update fman dt binding with clock name and qbman link

Simon Kagstrom (1):
      powerpc/boot: Parse chosen/cmdline-timeout parameter

Suresh E. Warrier (1):
      powerpc: Save/restore PPR for KVM hypercalls

Vineeth Vijayan (1):
      powerpc: Use generic PIE randomization

 .../devicetree/bindings/clock/qoriq-clock.txt      |  14 +-
 .../devicetree/bindings/powerpc/fsl/fman.txt       | 534 +++++++++++++++++=
++++
 Documentation/devicetree/bindings/rtc/rtc-opal.txt |  16 +
 .../devicetree/bindings/soc/fsl/bman-portals.txt   |  56 +++
 Documentation/devicetree/bindings/soc/fsl/bman.txt | 125 +++++
 .../devicetree/bindings/soc/fsl/qman-portals.txt   | 154 ++++++
 Documentation/devicetree/bindings/soc/fsl/qman.txt | 165 +++++++
 arch/powerpc/Kconfig                               |   5 +-
 arch/powerpc/boot/dts/b4860emu.dts                 |   4 +-
 arch/powerpc/boot/dts/b4qds.dtsi                   |  23 +
 arch/powerpc/boot/dts/bsc9131rdb.dtsi              |  50 --
 arch/powerpc/boot/dts/fsl/b4420si-post.dtsi        |  28 +-
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi        |  28 +-
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |  48 +-
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |  48 +-
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |  48 +-
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |  48 +-
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |  48 +-
 arch/powerpc/boot/dts/fsl/qoriq-clockgen1.dtsi     |  85 ++++
 arch/powerpc/boot/dts/fsl/qoriq-clockgen2.dtsi     |  68 +++
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi        |  30 +-
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |  29 +-
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |  29 +-
 arch/powerpc/boot/dts/p3041ds.dts                  |  20 +
 arch/powerpc/boot/dts/p5020ds.dts                  |  20 +
 arch/powerpc/boot/dts/p5040ds.dts                  |  20 +
 arch/powerpc/boot/dts/t104xrdb.dtsi                |   7 +
 arch/powerpc/boot/dts/t208xqds.dtsi                |  11 +
 arch/powerpc/boot/dts/t4240emu.dts                 |   4 +-
 arch/powerpc/boot/main.c                           |  15 +-
 arch/powerpc/boot/ops.h                            |   2 +-
 arch/powerpc/boot/serial.c                         |   6 +-
 arch/powerpc/configs/corenet32_smp_defconfig       |   1 +
 arch/powerpc/configs/corenet64_smp_defconfig       |   1 +
 arch/powerpc/configs/mpc85xx_defconfig             |   1 +
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   1 +
 arch/powerpc/include/asm/bitops.h                  |   6 +-
 arch/powerpc/include/asm/cputable.h                |  10 +-
 arch/powerpc/include/asm/eeh.h                     |   2 +
 arch/powerpc/include/asm/elf.h                     |   3 +-
 arch/powerpc/include/asm/fsl_guts.h                |   5 +-
 arch/powerpc/include/asm/hardirq.h                 |   7 +-
 arch/powerpc/include/asm/hugetlb.h                 |   8 +-
 arch/powerpc/include/asm/io.h                      |   3 -
 arch/powerpc/include/asm/machdep.h                 |  19 +-
 arch/powerpc/include/asm/mmu-8xx.h                 |   2 +
 arch/powerpc/include/asm/mmu-hash64.h              |  22 +-
 arch/powerpc/include/asm/opal.h                    | 122 +----
 arch/powerpc/include/asm/paca.h                    |   7 -
 arch/powerpc/include/asm/page.h                    |   4 +-
 arch/powerpc/include/asm/pgtable-ppc32.h           |  20 +
 arch/powerpc/include/asm/pgtable-ppc64-4k.h        |  16 +-
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |   3 +
 arch/powerpc/include/asm/pgtable-ppc64.h           |  52 +-
 arch/powerpc/include/asm/pgtable.h                 |   6 +-
 arch/powerpc/include/asm/processor.h               |   2 +-
 arch/powerpc/include/asm/pte-8xx.h                 |   7 +-
 arch/powerpc/include/asm/setup.h                   |   3 +-
 arch/powerpc/include/asm/thread_info.h             |   5 +-
 arch/powerpc/include/asm/tlbflush.h                |  10 +-
 arch/powerpc/include/asm/vga.h                     |   4 +-
 arch/powerpc/include/asm/xics.h                    |   8 +-
 arch/powerpc/kernel/align.c                        |   2 +-
 arch/powerpc/kernel/asm-offsets.c                  |   7 -
 arch/powerpc/kernel/crash_dump.c                   |   1 -
 arch/powerpc/kernel/dbell.c                        |   2 +-
 arch/powerpc/kernel/eeh.c                          |  41 +-
 arch/powerpc/kernel/eeh_driver.c                   |  10 +-
 arch/powerpc/kernel/entry_32.S                     |  12 +-
 arch/powerpc/kernel/entry_64.S                     |  35 +-
 arch/powerpc/kernel/exceptions-64s.S               |  34 +-
 arch/powerpc/kernel/ftrace.c                       |  73 +--
 arch/powerpc/kernel/head_8xx.S                     | 230 ++++-----
 arch/powerpc/kernel/hw_breakpoint.c                |   6 +-
 arch/powerpc/kernel/idle_power7.S                  |  12 +-
 arch/powerpc/kernel/iommu.c                        |   2 +-
 arch/powerpc/kernel/irq.c                          |   5 +-
 arch/powerpc/kernel/kgdb.c                         |   2 +-
 arch/powerpc/kernel/kprobes.c                      |   6 +-
 arch/powerpc/kernel/mce.c                          |  24 +-
 arch/powerpc/kernel/mce_power.c                    |   4 +-
 arch/powerpc/kernel/pci-common.c                   |   3 +-
 arch/powerpc/kernel/pci_32.c                       |   4 +-
 arch/powerpc/kernel/pci_64.c                       |   1 -
 arch/powerpc/kernel/process.c                      |  36 +-
 arch/powerpc/kernel/prom.c                         |  11 +-
 arch/powerpc/kernel/rtas-proc.c                    |  20 +-
 arch/powerpc/kernel/rtas.c                         |   4 +-
 arch/powerpc/kernel/rtas_pci.c                     |   1 -
 arch/powerpc/kernel/setup-common.c                 |   6 +-
 arch/powerpc/kernel/setup_32.c                     |  11 +-
 arch/powerpc/kernel/setup_64.c                     |  35 +-
 arch/powerpc/kernel/smp.c                          |   6 +-
 arch/powerpc/kernel/sysfs.c                        |   4 +-
 arch/powerpc/kernel/time.c                         |  23 +-
 arch/powerpc/kernel/traps.c                        |   8 +-
 arch/powerpc/kernel/udbg_16550.c                   |   6 +-
 arch/powerpc/kernel/vdso.c                         |   1 -
 arch/powerpc/kvm/book3s_hv_builtin.c               |   3 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  54 ++-
 arch/powerpc/kvm/e500.c                            |  14 +-
 arch/powerpc/kvm/e500mc.c                          |   4 +-
 arch/powerpc/lib/Makefile                          |   1 -
 arch/powerpc/lib/alloc.c                           |   4 +-
 arch/powerpc/lib/devres.c                          |  43 --
 arch/powerpc/lib/sstep.c                           |   6 +-
 arch/powerpc/mm/Makefile                           |   2 +-
 arch/powerpc/mm/fault.c                            |   7 -
 arch/powerpc/mm/gup.c                              | 235 ---------
 arch/powerpc/mm/hash_low_64.S                      |  19 +-
 arch/powerpc/mm/hash_native_64.c                   |  41 +-
 arch/powerpc/mm/hash_utils_64.c                    | 114 ++++-
 arch/powerpc/mm/hugepage-hash64.c                  |  60 +--
 arch/powerpc/mm/hugetlbpage-book3e.c               |   6 +-
 arch/powerpc/mm/hugetlbpage-hash64.c               |   6 +-
 arch/powerpc/mm/hugetlbpage.c                      |  51 +-
 arch/powerpc/mm/init_32.c                          |  10 -
 arch/powerpc/mm/init_64.c                          |   1 -
 arch/powerpc/mm/mem.c                              |  77 +--
 arch/powerpc/mm/mmu_context_nohash.c               |   8 +-
 arch/powerpc/mm/numa.c                             | 224 ++-------
 arch/powerpc/mm/pgtable_32.c                       |   3 +-
 arch/powerpc/mm/pgtable_64.c                       | 104 ++--
 arch/powerpc/oprofile/backtrace.c                  |   6 +-
 arch/powerpc/perf/core-book3s.c                    |  22 +-
 arch/powerpc/perf/core-fsl-emb.c                   |   6 +-
 arch/powerpc/platforms/44x/ppc476.c                |   2 +-
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   9 +-
 arch/powerpc/platforms/52xx/efika.c                |   3 +-
 arch/powerpc/platforms/83xx/mcu_mpc8349emitx.c     |   8 +-
 arch/powerpc/platforms/85xx/corenet_generic.c      |   2 +-
 arch/powerpc/platforms/85xx/sgy_cts1000.c          |   4 +-
 arch/powerpc/platforms/8xx/Kconfig                 |   4 -
 arch/powerpc/platforms/cell/beat_htab.c            |   4 +-
 arch/powerpc/platforms/cell/celleb_pci.c           |   6 +-
 arch/powerpc/platforms/cell/celleb_scc_epci.c      |   1 -
 arch/powerpc/platforms/cell/celleb_scc_pciex.c     |   1 -
 arch/powerpc/platforms/cell/celleb_setup.c         |   4 +-
 arch/powerpc/platforms/cell/interrupt.c            |   6 +-
 arch/powerpc/platforms/cell/qpace_setup.c          |   2 +-
 arch/powerpc/platforms/cell/setup.c                |   2 +-
 arch/powerpc/platforms/cell/spu_base.c             |   5 +-
 arch/powerpc/platforms/cell/spufs/fault.c          |   2 +-
 arch/powerpc/platforms/chrp/setup.c                |   3 +-
 arch/powerpc/platforms/embedded6xx/gamecube.c      |   3 +-
 arch/powerpc/platforms/embedded6xx/linkstation.c   |   4 +-
 arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c |   6 +-
 arch/powerpc/platforms/embedded6xx/wii.c           |   3 +-
 arch/powerpc/platforms/maple/pci.c                 |   1 -
 arch/powerpc/platforms/maple/setup.c               |   4 +-
 arch/powerpc/platforms/powermac/nvram.c            |   6 +-
 arch/powerpc/platforms/powermac/pci.c              |   1 -
 arch/powerpc/platforms/powermac/setup.c            |   3 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c          |  16 +-
 arch/powerpc/platforms/powernv/opal-async.c        |   3 +
 arch/powerpc/platforms/powernv/opal-rtc.c          |  65 +--
 arch/powerpc/platforms/powernv/opal-tracepoints.c  |   4 +-
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   6 +-
 arch/powerpc/platforms/powernv/opal.c              |  21 +-
 arch/powerpc/platforms/powernv/pci-ioda.c          | 217 ++++++---
 arch/powerpc/platforms/powernv/pci-p5ioc2.c        |  44 +-
 arch/powerpc/platforms/powernv/pci.c               |   1 -
 arch/powerpc/platforms/powernv/pci.h               |   2 +-
 arch/powerpc/platforms/powernv/setup.c             |   6 +-
 arch/powerpc/platforms/powernv/smp.c               |  23 +-
 arch/powerpc/platforms/ps3/htab.c                  |   2 +-
 arch/powerpc/platforms/ps3/interrupt.c             |   2 +-
 arch/powerpc/platforms/ps3/setup.c                 |   9 +-
 arch/powerpc/platforms/pseries/dtl.c               |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  21 -
 arch/powerpc/platforms/pseries/hvCall.S            |   4 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c       |   4 +-
 arch/powerpc/platforms/pseries/iommu.c             |  11 +-
 arch/powerpc/platforms/pseries/lpar.c              |  10 +-
 arch/powerpc/platforms/pseries/nvram.c             |   2 +
 arch/powerpc/platforms/pseries/pci.c               |   2 +-
 arch/powerpc/platforms/pseries/ras.c               |   4 +-
 arch/powerpc/platforms/pseries/setup.c             |  65 +--
 arch/powerpc/sysdev/fsl_msi.c                      |   1 -
 arch/powerpc/sysdev/fsl_pci.c                      |   3 +-
 arch/powerpc/sysdev/fsl_rio.c                      | 104 ++++
 arch/powerpc/sysdev/fsl_rio.h                      |  13 +
 arch/powerpc/sysdev/fsl_soc.c                      |   5 +-
 arch/powerpc/sysdev/ipic.c                         |   1 -
 arch/powerpc/sysdev/mpc5xxx_clocks.c               |   3 +-
 arch/powerpc/sysdev/mpic.c                         |   1 -
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |   1 -
 arch/powerpc/sysdev/mpic_u3msi.c                   |   1 -
 arch/powerpc/sysdev/ppc4xx_cpm.c                   |   8 +-
 arch/powerpc/sysdev/ppc4xx_msi.c                   |   1 -
 arch/powerpc/sysdev/ppc4xx_pci.c                   |   1 -
 arch/powerpc/sysdev/qe_lib/qe.c                    |   1 -
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |   1 -
 arch/powerpc/sysdev/uic.c                          |   1 -
 arch/powerpc/sysdev/xics/xics-common.c             |   2 +-
 arch/powerpc/xmon/xmon.c                           |  82 +++-
 drivers/misc/cxl/cxl.h                             |  15 +-
 drivers/misc/cxl/fault.c                           |   8 +-
 drivers/misc/cxl/irq.c                             | 144 ++++--
 drivers/misc/cxl/native.c                          |  14 +-
 drivers/rtc/Kconfig                                |  11 +
 drivers/rtc/Makefile                               |   1 +
 drivers/rtc/rtc-opal.c                             | 261 ++++++++++
 include/linux/hugetlb.h                            |  46 ++
 mm/gup.c                                           |  81 +++-
 205 files changed, 3246 insertions(+), 2177 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/fman.txt
 create mode 100644 Documentation/devicetree/bindings/rtc/rtc-opal.txt
 create mode 100644 Documentation/devicetree/bindings/soc/fsl/bman-portals.=
txt
 create mode 100644 Documentation/devicetree/bindings/soc/fsl/bman.txt
 create mode 100644 Documentation/devicetree/bindings/soc/fsl/qman-portals.=
txt
 create mode 100644 Documentation/devicetree/bindings/soc/fsl/qman.txt
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-clockgen1.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-clockgen2.dtsi
 delete mode 100644 arch/powerpc/lib/devres.c
 delete mode 100644 arch/powerpc/mm/gup.c
 create mode 100644 drivers/rtc/rtc-opal.c



--=-8Z1mLhUPa+uADsToTHph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUiSg5AAoJEFHr6jzI4aWAxFAQALGi+KB0GKhS++WJtuIMWiRn
kO28LfxkZxbuJjX3OYj+q/9/RuOd+0AT4qlbDleXwCtorhlwhwUaAiaq+nCSFtir
Va3wxCTKTh32XtlzlYufBNxUbWLQH5lIpdanYnq/dD3dMUuQsr+9quRi9ACgZUP8
vDbiXhPtIhfsd2Pr2ODENl1k1f89sYBWtdvcNaq5xHyCVnKZILBo6ClgP9i6FRQe
8s5VWqOYxebDjo1jgm14WAsNwGlst5xoHglQ9yqFEitEcX/UYHE2uswEMQqu/aW/
xXfftCdWZdrN5KpQ30wOY1wobHTUjCNdGsYeKX19tcJLeJ2HsnJaok+g0NsQAqJw
szy+7CVSDz1ykNTa6fc+EiBPAVWczl1Tkgw6v7E6wB0SnvWq12N8iuYwLW8QxpmH
YO1cbkidatWu5WxFHrUaMnr9WY2pY+KhARw3GftfqtLsiZooIZAFvTAb20oT4H16
uO8WDJ7WCdDVf2svaLp4QrBfY80evJsFl005EQV3pLI/PnUdrJxlQ0EDjoBDTrxn
fCC7WIKj/U6Jx30mzzaVwkcsOtR91Xm1yayqDve2A7i1lSnBlv27kRG7qFF1Pb47
VZsEU0YMx5zpeVol7V5yBdpZXXJCh6S4IH+A056QqTKwAvZHLza7nnzYdKOFcDRT
n4bybSj/89DOB2PE3kTk
=i4LW
-----END PGP SIGNATURE-----

--=-8Z1mLhUPa+uADsToTHph--

