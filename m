Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaDAXfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:35:01 -0400
Received: from gate.crashing.org ([63.228.1.57]:39561 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaDAXe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:34:58 -0400
Message-ID: <1396395283.19762.29.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 02 Apr 2014 10:34:43 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

This time around, the powerpc merges are going to be a little bit
more complicated than usual.

This is the main pull request with most of the work for this merge
window. I will describe it a bit more further down.

There is some additional cpuidle driver work, however I haven't included
it in this tree as it depends on some work in tip/timer-core which
Thomas accidentally forgot to put in a topic branch. Since I didn't want
to carry all of that tip timer stuff in powerpc -next, I setup a
separate branch on top of Thomas tree with just that cpuidle driver in
it, and Stephen has been carrying that in next separately for a while
now. I'll send a separate pull request for it.

Additionally, two new pieces in this tree add users for a sysfs API
that Tejun and Greg have been deprecating in drivers-core-next.
Thankfully Greg reverted the patch that removes the old API so this
merge can happen cleanly, but once merged, I will send a patch adjusting
our new code to the new API so that Greg can send you the removal patch.

Now as for the content of this branch, we have a lot of perf work for
power8 new counters including support for our new "nest" counters
(also called 24x7) under pHyp (not natively yet).

We have new functionality when running under the OPAL firmware
(non-virtualized or KVM host), such as access to the firmware error logs
and service processor dumps, system parameters and sensors, along with
a hwmon driver for the latter.

There's also a bunch of bug fixes accross the board, some LE fixes,
and a nice set of selftests for validating our various types of
copy loops.

On the Freescale side, we see mostly new chip/board revisions, some
clock updates, better support for machine checks and debug exceptions,
etc...

Cheers,
Ben.

The following changes since commit a5b2cf5b1af424ee3dd9e3ce6d5cea18cb927e67:

  powerpc: Align p_dyn, p_rela and p_st symbols (2014-03-07 13:50:19 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to cd427485357c0c4b99f69719251baacf25946e11:

  Merge remote-tracking branch 'scott/next' into next (2014-03-24 10:26:10 +1100)

----------------------------------------------------------------

Aneesh Kumar K.V (2):
      powerpc/mm: Make sure a local_irq_disable prevent a parallel THP split
      powerpc/defconfigs: Enable THP in pseries defconfig

Anshuman Khandual (2):
      powerpc/perf: Make some new raw event codes available in sysfs
      powerpc/perf: Define perf_event_print_debug() to print PMU register values

Anton Blanchard (2):
      powerpc: Use default set of netfilter modules (CONFIG_NETFILTER_ADVANCED=n)
      powerpc/compat: 32-bit little endian machine name is ppcle, not ppc

Benjamin Herrenschmidt (2):
      powerpc/pseries: Don't try to register pseries cpu hotplug on non-pseries
      Merge remote-tracking branch 'scott/next' into next

Benjamin Krill (1):
      powerpc/book3e: Fix check for linear mapping in TLB miss handler

Brandon Stewart (1):
      macintosh/adb: Fixed some coding style problems

Cody P Schafer (10):
      sysfs: create bin_attributes under the requested group
      powerpc: Add hvcalls for 24x7 and gpci (Get Performance Counter Info)
      powerpc/perf: Add hv_gpci interface header
      powerpc/perf: Add 24x7 interface headers
      powerpc/perf: Add a shared interface to get gpci version and capabilities
      powerpc/perf: Add macros for defining event fields & formats
      powerpc/perf: Add support for the hv gpci (get performance counter info) interface
      powerpc/perf: Add support for the hv 24x7 interface
      powerpc/perf: Add kconfig option for hypervisor provided counters
      powerpc/perf/hv_{gpci, 24x7}: Add documentation of device attributes

Greg Kurz (1):
      powerpc/le: Big endian arguments for ppc_rtas()

Haren Myneni (2):
      powerpc/pseries: Device tree should only be updated once after suspend/migrate
      powerpc/pseries: Update dynamic cache nodes for suspend/resume operation

Josh Boyer (1):
      powerpc: Update ppc4xx maintainer

Li Zhong (1):
      powerpc: Revert c6102609 and replace it with the correct fix for vio dma mask setting

Luis Henriques (1):
      powerpc/kconfig: Remove TSI108_BRIDGE duplicates

Mahesh Salgaonkar (2):
      powerpc/book3s: Recover from MC in sapphire on SCOM read via MMIO.
      powerpc/book3s: Fix CFAR clobbering issue in machine check handler.

Michael Ellerman (9):
      selftests/powerpc: Import Anton's memcpy / copy_tofrom_user tests
      powerpc: Add a cpu feature CPU_FTR_PMAO_BUG
      powerpc/perf: Add lost exception workaround
      powerpc/perf: Reject EBB events which specify a sample_type
      powerpc/perf: Clean up the EBB hash defines a little
      powerpc/perf: Avoid mutating event in power8_get_constraint()
      powerpc/perf: Add BHRB constraint and IFM MMCRA handling for EBB
      powerpc/perf: Enable BHRB access for EBB events
      powerpc/perf: Fix handling of L3 events with bank == 1

Michael Neuling (1):
      powerpc: Rate-limit users spamming kernel log buffer

Minghuan Lian (1):
      powerpc/pci: Fix IMMRBAR address

Nathan Fontenot (1):
      powerpc/pseries: Use remove_memory() to remove memory

Neelesh Gupta (3):
      powerpc/powernv: Infrastructure to support OPAL async completion
      powerpc/powernv: Enable reading and updating of system parameters
      powerpc/powernv: Enable fetching of platform sensor data

Paul Gortmaker (1):
      powerpc: Delete old PrPMC 280/2800 support

Philippe Bergheaud (1):
      powerpc: Fix xmon disassembler for little-endian

Prabhakar Kushwaha (1):
      powerpc/config: Remove unnecssary CONFIG_FSL_IFC

Scott Wood (8):
      powerpc/booke64: Fix exception numbers
      powerpc/e6500: Make TLB lock recursive
      powerpc/booke64: Use SPRG7 for VDSO
      powerpc/booke64: Use SPRG_TLB_EXFRAME on bolted handlers
      powerpc/booke64: Remove ints from EXCEPTION_COMMON
      powerpc/booke64: Add crit/mc/debug support to EXCEPTION_COMMON
      powerpc/booke64: Critical and machine check exception support
      Revert "powerpc/watchdog: Don't enable interrupt on PPC64 BookE"

Sebastian Siewior (2):
      powerpc: Add "force config cmd line" Kconfig option
      powerpc: 85xx rdb: move np pointer to avoid builderror

Shivaprasad G Bhat (1):
      powerpc/powernv: hwmon driver for power values, fan rpm and temperature

Shuah Khan (1):
      macintosh/adb: Change platform power management to use dev_pm_ops

Stewart Smith (2):
      powerpc/powernv: Read OPAL error log and export it through sysfs
      powerpc/powernv Platform dump interface

Tang Yuantian (2):
      powerpc/mpc85xx: Update clock nodes in device tree
      powerpc: T4240: Add ina220 node in dts

Tiejun Chen (2):
      powerpc/book3e: initialize crit/mc/dbg kernel stack pointers
      powerpc/book3e: store crit/mc/dbg exception thread info

Tyrel Datwyler (1):
      powerpc/pseries: Expose in kernel device tree update to drmgr

Wang Dongsheng (2):
      powerpc/fsl: add PVR definition for E500MC and E5500
      fsl/pci: The new pci suspend/resume implementation

Zhao Qiang (2):
      QE: split function mpc85xx_qe_init() into two functions.
      Corenet: Add QE platform support for Corenet

harninder rai (1):
      powerpc/fsl: Add/update miscellaneous missing binding

송은봉 (1):
      powerpc: : Kill CONFIG_MTD_PARTITIONS

 Documentation/ABI/stable/sysfs-firmware-opal-dump  |  41 ++
 Documentation/ABI/stable/sysfs-firmware-opal-elog  |  60 +++
 .../testing/sysfs-bus-event_source-devices-events  | 517 ++++++++++++++++++++
 .../testing/sysfs-bus-event_source-devices-hv_24x7 |  23 +
 .../testing/sysfs-bus-event_source-devices-hv_gpci |  43 ++
 .../devicetree/bindings/powerpc/fsl/l2cache.txt    |  23 +
 .../devicetree/bindings/powerpc/fsl/mem-ctrlr.txt  |  27 ++
 Documentation/devicetree/bindings/usb/fsl-usb.txt  |   4 +-
 MAINTAINERS                                        |   3 +-
 arch/powerpc/Kconfig                               |   9 +
 arch/powerpc/boot/Makefile                         |   5 +-
 arch/powerpc/boot/dts/fsl/b4420si-post.dtsi        |  36 ++
 arch/powerpc/boot/dts/fsl/b4420si-pre.dtsi         |   2 +
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi        |  36 ++
 arch/powerpc/boot/dts/fsl/b4860si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |  60 +++
 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |  61 +++
 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        | 113 +++++
 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi         |   8 +
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |  43 ++
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |   2 +
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |  61 +++
 arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |  86 ++++
 arch/powerpc/boot/dts/fsl/t4240si-pre.dtsi         |  12 +
 arch/powerpc/boot/dts/t4240qds.dts                 |  42 ++
 arch/powerpc/configs/40x/acadia_defconfig          |   1 -
 arch/powerpc/configs/40x/ep405_defconfig           |   1 -
 arch/powerpc/configs/40x/kilauea_defconfig         |   1 -
 arch/powerpc/configs/40x/makalu_defconfig          |   1 -
 arch/powerpc/configs/40x/walnut_defconfig          |   1 -
 arch/powerpc/configs/44x/arches_defconfig          |   1 -
 arch/powerpc/configs/44x/bluestone_defconfig       |   1 -
 arch/powerpc/configs/44x/canyonlands_defconfig     |   1 -
 arch/powerpc/configs/44x/ebony_defconfig           |   1 -
 arch/powerpc/configs/44x/eiger_defconfig           |   1 -
 arch/powerpc/configs/44x/icon_defconfig            |   1 -
 arch/powerpc/configs/44x/iss476-smp_defconfig      |   1 -
 arch/powerpc/configs/44x/katmai_defconfig          |   1 -
 arch/powerpc/configs/44x/rainier_defconfig         |   1 -
 arch/powerpc/configs/44x/redwood_defconfig         |   1 -
 arch/powerpc/configs/44x/sequoia_defconfig         |   1 -
 arch/powerpc/configs/44x/taishan_defconfig         |   1 -
 arch/powerpc/configs/44x/warp_defconfig            |   1 -
 arch/powerpc/configs/52xx/cm5200_defconfig         |   1 -
 arch/powerpc/configs/52xx/motionpro_defconfig      |   1 -
 arch/powerpc/configs/52xx/pcm030_defconfig         |   1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig        |   1 -
 arch/powerpc/configs/83xx/asp8347_defconfig        |   1 -
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig    |   1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig    |   1 -
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig    |   1 -
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig    |   1 -
 arch/powerpc/configs/83xx/sbc834x_defconfig        |   1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig        |   1 -
 arch/powerpc/configs/85xx/ppa8548_defconfig        |   1 -
 arch/powerpc/configs/85xx/socrates_defconfig       |   1 -
 arch/powerpc/configs/85xx/tqm8540_defconfig        |   1 -
 arch/powerpc/configs/85xx/tqm8541_defconfig        |   1 -
 arch/powerpc/configs/85xx/tqm8548_defconfig        |   1 -
 arch/powerpc/configs/85xx/tqm8555_defconfig        |   1 -
 arch/powerpc/configs/85xx/tqm8560_defconfig        |   1 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig    |   1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |   1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     |   1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |   1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig   |   1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig       |   1 -
 arch/powerpc/configs/c2k_defconfig                 |   1 -
 arch/powerpc/configs/corenet64_smp_defconfig       |   2 -
 arch/powerpc/configs/linkstation_defconfig         |   1 -
 arch/powerpc/configs/mpc85xx_defconfig             |   2 -
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   2 -
 arch/powerpc/configs/ppc40x_defconfig              |   1 -
 arch/powerpc/configs/ppc44x_defconfig              |   1 -
 arch/powerpc/configs/ppc64_defconfig               |  70 +--
 arch/powerpc/configs/ppc64e_defconfig              |  70 +--
 arch/powerpc/configs/prpmc2800_defconfig           | 108 -----
 arch/powerpc/configs/pseries_defconfig             |  55 +--
 arch/powerpc/configs/pseries_le_defconfig          |  53 +--
 arch/powerpc/configs/storcenter_defconfig          |   1 -
 arch/powerpc/configs/tqm8xx_defconfig              |   1 -
 arch/powerpc/include/asm/compat.h                  |   4 +
 arch/powerpc/include/asm/cputable.h                |   6 +-
 arch/powerpc/include/asm/exception-64e.h           |  15 +-
 arch/powerpc/include/asm/exception-64s.h           |   8 +
 arch/powerpc/include/asm/hvcall.h                  |   5 +
 arch/powerpc/include/asm/kvm_booke_hv_asm.h        |  17 +-
 arch/powerpc/include/asm/machdep.h                 |   7 +
 arch/powerpc/include/asm/mce.h                     |   3 +-
 arch/powerpc/include/asm/mmu-book3e.h              |   9 +-
 arch/powerpc/include/asm/opal.h                    |  60 ++-
 arch/powerpc/include/asm/paca.h                    |   9 +-
 arch/powerpc/include/asm/perf_event_server.h       |   1 +
 arch/powerpc/include/asm/reg.h                     |  18 +-
 arch/powerpc/include/asm/rtas.h                    |   1 +
 arch/powerpc/kernel/asm-offsets.c                  |   2 +-
 arch/powerpc/kernel/cacheinfo.c                    |   7 +-
 arch/powerpc/kernel/cputable.c                     |   2 +-
 arch/powerpc/kernel/exceptions-64e.S               | 435 +++++++++++++----
 arch/powerpc/kernel/exceptions-64s.S               |   5 +
 arch/powerpc/kernel/mce.c                          |   4 +-
 arch/powerpc/kernel/mce_power.c                    |  37 +-
 arch/powerpc/kernel/prom.c                         |   5 +
 arch/powerpc/kernel/rtas.c                         |  22 +-
 arch/powerpc/kernel/setup_64.c                     |  20 +-
 arch/powerpc/kernel/traps.c                        |   5 +-
 arch/powerpc/kernel/vdso.c                         |   8 +-
 arch/powerpc/kernel/vdso32/getcpu.S                |   2 +-
 arch/powerpc/kernel/vdso64/getcpu.S                |   2 +-
 arch/powerpc/kernel/vio.c                          |   3 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |   4 +-
 arch/powerpc/kvm/book3s_interrupts.S               |   4 +-
 arch/powerpc/kvm/bookehv_interrupts.S              |  21 +-
 arch/powerpc/lib/memcpy_64.S                       |   2 +
 arch/powerpc/mm/mem.c                              |   7 +-
 arch/powerpc/mm/pgtable_64.c                       |   5 +
 arch/powerpc/mm/tlb_low_64e.S                      |  66 ++-
 arch/powerpc/mm/tlb_nohash.c                       |  11 +
 arch/powerpc/perf/Makefile                         |   2 +
 arch/powerpc/perf/core-book3s.c                    | 172 ++++++-
 arch/powerpc/perf/hv-24x7-catalog.h                |  33 ++
 arch/powerpc/perf/hv-24x7.c                        | 510 ++++++++++++++++++++
 arch/powerpc/perf/hv-24x7.h                        | 109 +++++
 arch/powerpc/perf/hv-common.c                      |  39 ++
 arch/powerpc/perf/hv-common.h                      |  36 ++
 arch/powerpc/perf/hv-gpci.c                        | 294 ++++++++++++
 arch/powerpc/perf/hv-gpci.h                        |  73 +++
 arch/powerpc/perf/power7-events-list.h             |  10 +
 arch/powerpc/perf/power8-pmu.c                     |  78 ++-
 arch/powerpc/platforms/85xx/c293pcie.c             |   1 +
 arch/powerpc/platforms/85xx/common.c               |   6 +
 arch/powerpc/platforms/85xx/corenet_generic.c      |  17 +
 arch/powerpc/platforms/85xx/ge_imp3a.c             |   1 +
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |   1 +
 arch/powerpc/platforms/85xx/mpc85xx.h              |   2 +
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |   1 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |   3 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |   4 +
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  16 +-
 arch/powerpc/platforms/85xx/p1010rdb.c             |   1 +
 arch/powerpc/platforms/85xx/p1022_ds.c             |   1 +
 arch/powerpc/platforms/85xx/p1022_rdk.c            |   1 +
 arch/powerpc/platforms/85xx/p1023_rds.c            |   2 +
 arch/powerpc/platforms/85xx/qemu_e500.c            |   1 +
 arch/powerpc/platforms/85xx/sbc8548.c              |   1 +
 arch/powerpc/platforms/85xx/twr_p102x.c            |   1 +
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |   3 +
 arch/powerpc/platforms/embedded6xx/Kconfig         |  10 -
 arch/powerpc/platforms/embedded6xx/Makefile        |   1 -
 arch/powerpc/platforms/embedded6xx/prpmc2800.c     | 156 ------
 arch/powerpc/platforms/powernv/Makefile            |   4 +-
 arch/powerpc/platforms/powernv/opal-async.c        | 203 ++++++++
 arch/powerpc/platforms/powernv/opal-dump.c         | 525 ++++++++++++++++++++
 arch/powerpc/platforms/powernv/opal-elog.c         | 313 ++++++++++++
 arch/powerpc/platforms/powernv/opal-sensor.c       |  64 +++
 arch/powerpc/platforms/powernv/opal-sysparam.c     | 290 +++++++++++
 arch/powerpc/platforms/powernv/opal-wrappers.S     |  14 +
 arch/powerpc/platforms/powernv/opal.c              | 106 ++++-
 arch/powerpc/platforms/powernv/setup.c             |   1 +
 arch/powerpc/platforms/pseries/Kconfig             |  12 +
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  83 ++--
 arch/powerpc/platforms/pseries/mobility.c          |  26 +-
 arch/powerpc/platforms/pseries/suspend.c           |  44 +-
 arch/powerpc/sysdev/fsl_pci.c                      | 178 ++++++-
 arch/powerpc/sysdev/fsl_pci.h                      |   8 +
 arch/powerpc/xmon/xmon.c                           |   4 +
 drivers/hwmon/Kconfig                              |   8 +
 drivers/hwmon/Makefile                             |   1 +
 drivers/hwmon/ibmpowernv.c                         | 529 +++++++++++++++++++++
 drivers/macintosh/adb.c                            |  57 ++-
 drivers/watchdog/booke_wdt.c                       |   8 -
 fs/sysfs/group.c                                   |   7 +-
 tools/testing/selftests/powerpc/Makefile           |   2 +-
 tools/testing/selftests/powerpc/copyloops/Makefile |  29 ++
 .../selftests/powerpc/copyloops/asm/ppc_asm.h      |  86 ++++
 .../selftests/powerpc/copyloops/asm/processor.h    |   0
 .../selftests/powerpc/copyloops/copyuser_64.S      |   1 +
 .../selftests/powerpc/copyloops/copyuser_power7.S  |   1 +
 .../selftests/powerpc/copyloops/memcpy_64.S        |   1 +
 .../selftests/powerpc/copyloops/memcpy_power7.S    |   1 +
 .../testing/selftests/powerpc/copyloops/validate.c |  99 ++++
 tools/testing/selftests/powerpc/utils.h            |   3 +
 186 files changed, 5955 insertions(+), 926 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-firmware-opal-dump
 create mode 100644 Documentation/ABI/stable/sysfs-firmware-opal-elog
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
 create mode 100644 Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/l2cache.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/mem-ctrlr.txt
 delete mode 100644 arch/powerpc/configs/prpmc2800_defconfig
 create mode 100644 arch/powerpc/perf/hv-24x7-catalog.h
 create mode 100644 arch/powerpc/perf/hv-24x7.c
 create mode 100644 arch/powerpc/perf/hv-24x7.h
 create mode 100644 arch/powerpc/perf/hv-common.c
 create mode 100644 arch/powerpc/perf/hv-common.h
 create mode 100644 arch/powerpc/perf/hv-gpci.c
 create mode 100644 arch/powerpc/perf/hv-gpci.h
 delete mode 100644 arch/powerpc/platforms/embedded6xx/prpmc2800.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-async.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-dump.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-elog.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-sensor.c
 create mode 100644 arch/powerpc/platforms/powernv/opal-sysparam.c
 create mode 100644 drivers/hwmon/ibmpowernv.c
 create mode 100644 tools/testing/selftests/powerpc/copyloops/Makefile
 create mode 100644 tools/testing/selftests/powerpc/copyloops/asm/ppc_asm.h
 create mode 100644 tools/testing/selftests/powerpc/copyloops/asm/processor.h
 create mode 120000 tools/testing/selftests/powerpc/copyloops/copyuser_64.S
 create mode 120000 tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
 create mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_64.S
 create mode 120000 tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
 create mode 100644 tools/testing/selftests/powerpc/copyloops/validate.c


