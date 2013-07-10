Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3GJIjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:39:01 -0400
Received: from www84.your-server.de ([213.133.104.84]:45824 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3GJIi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:38:57 -0400
Message-ID: <1373445543.348.5.camel@wall-e>
Subject: BUG: 32 Bit Kernel kexec hangs on P2020
From: Stefani Seibold <stefani@seibold.net>
To: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Cc: Stefani Seibold <Stefani@seibold.net>
Date: Wed, 10 Jul 2013 10:39:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

i have tried to kexec a 32 bit kernel on a Freescale P2020 dual core CPU
(e500v2, revison 5.1 - pvr 8021 1051), but Kexec will hang after the
"Bye!".

The host and the kexec kernel are the same, based on the current kernel
version 3.10.

I have tried it with kexec-tools 2.0.4.git released 30 June 2013.

Invoking kexec with

kexec --command-line "1 maxcpus=1 noirqdistrib reset_devices $(cat /proc/cmdline)" -t elf-ppc --dtb=rs2020.dtb \
--reuse-node="/cpus/PowerPC,P2020@0/timebase-frequency" \
--reuse-node="/cpus/PowerPC,P2020@0/bus-frequency" \
--reuse-node="/cpus/PowerPC,P2020@0/clock-frequency" \
--reuse-node="/cpus/PowerPC,P2020@0/next-level-cache" \
--reuse-node="/cpus/PowerPC,P2020@1/timebase-frequency" \
--reuse-node="/cpus/PowerPC,P2020@1/bus-frequency" \
--reuse-node="/cpus/PowerPC,P2020@1/clock-frequency" \
--reuse-node="/cpus/PowerPC,P2020@1/next-level-cache" \
--reuse-node="/cpus/PowerPC,P2020@1/cpu-release-addr" \
--reuse-node="/cpus/PowerPC,P2020@1/enable-method" \
--reuse-node="/soc@ffe00000/bus-frequency" \
--reuse-node="/soc@ffe00000/serial@4500/clock-frequency" \
--reuse-node="/soc@ffe00000/ethernet@24000/local-mac-address" \
-d -l -x vmlinux
kexec -e

This will be the result output of the run:

kernel: 0x48032008 kernel_size: 54568c
0000000000000000-0000000080000000 : 0
get base memory ranges:1
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 584012
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 58401a
sym: sha256_starts info: 12 other: 00 shndx: 1 value: 99c size: e0
sym: sha256_starts value: 58499c addr: 584024
sym: sha256_update info: 12 other: 00 shndx: 1 value: 565c size: 1b0
sym: sha256_update value: 58965c addr: 584038
sym: sha256_finish info: 12 other: 00 shndx: 1 value: 580c size: 528
sym: sha256_finish value: 58980c addr: 584050
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 584056
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 58405a
sym:     memcmp info: 12 other: 00 shndx: 1 value: 664 size: 40
sym: memcmp value: 584664 addr: 584068
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d34 addr: 58407a
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d64 addr: 58407e
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d34 addr: 584082
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 58408c
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d54 addr: 584092
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d54 addr: 584096
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 58409c
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d64 addr: 5840a6
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 5840b4
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d6c addr: 5840c2
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 5840c6
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d6c addr: 5840ca
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589da8 addr: 5840ce
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 5840d4
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d70 addr: 5840da
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d70 addr: 5840de
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 5840e8
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 5840fc
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d6c addr: 58410a
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d6c addr: 58410e
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 584114
sym: _rest32gpr_29_x info: 12 other: 00 shndx: 1 value: 8fc size: 0
sym: _rest32gpr_29_x value: 5848fc addr: 584124
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d80 addr: 58412e
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d80 addr: 584136
sym:     printf info: 12 other: 00 shndx: 1 value: 55c size: 68
sym: printf value: 58455c addr: 584140
sym: setup_arch info: 12 other: 00 shndx: 1 value: 98c size: 4
sym: setup_arch value: 58498c addr: 584144
sym: verify_sha256_digest info: 12 other: 00 shndx: 1 value: 0 size: 128
sym: verify_sha256_digest value: 584000 addr: 584148
sym: post_verification_setup_arch info: 12 other: 00 shndx: 1 value: 990 size: 4
sym: post_verification_setup_arch value: 584990 addr: 584158
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d94 addr: 58417a
sym: .rodata.str1.4 info: 03 other: 00 shndx: 3 value: 0 size: 0
sym: .rodata.str1.4 value: 589d94 addr: 584196
sym:    putchar info: 12 other: 00 shndx: 1 value: 998 size: 4
sym: putchar value: 584998 addr: 5841b8
sym:    putchar info: 12 other: 00 shndx: 1 value: 998 size: 4
sym: putchar value: 584998 addr: 58421c
sym:  __lshrdi3 info: 10 other: 00 shndx: 1 value: 968 size: 0
sym: __lshrdi3 value: 584968 addr: 58433c
sym:    putchar info: 12 other: 00 shndx: 1 value: 998 size: 4
sym: putchar value: 584998 addr: 5844cc
sym: _rest32gpr_21_x info: 12 other: 00 shndx: 1 value: 8dc size: 0
sym: _rest32gpr_21_x value: 5848dc addr: 5844fc
sym:   vsprintf info: 12 other: 00 shndx: 1 value: 16c size: 394
sym: vsprintf value: 58416c addr: 584548
sym:   vsprintf info: 12 other: 00 shndx: 1 value: 16c size: 394
sym: vsprintf value: 58416c addr: 5845b0
sym: my_thread_ptr info: 11 other: 00 shndx: 5 value: 10 size: 4
sym: my_thread_ptr value: 589f18 addr: 5847b6
sym: my_thread_ptr info: 11 other: 00 shndx: 5 value: 10 size: 4
sym: my_thread_ptr value: 589f18 addr: 5847ba
sym:      stack info: 11 other: 00 shndx: 5 value: 8 size: 4
sym: stack value: 589f10 addr: 5847c2
sym:      stack info: 11 other: 00 shndx: 5 value: 8 size: 4
sym: stack value: 589f10 addr: 5847c6
sym:  purgatory info: 12 other: 00 shndx: 1 value: 128 size: 44
sym: purgatory value: 584128 addr: 5847d0
sym:  dt_offset info: 11 other: 00 shndx: 5 value: c size: 4
sym: dt_offset value: 589f14 addr: 5847ea
sym:  dt_offset info: 11 other: 00 shndx: 5 value: c size: 4
sym: dt_offset value: 589f14 addr: 5847ee
sym:     kernel info: 11 other: 00 shndx: 5 value: 14 size: 4
sym: kernel value: 589f1c addr: 584806
sym:     kernel info: 11 other: 00 shndx: 5 value: 14 size: 4
sym: kernel value: 589f1c addr: 58480a
sym:     memcpy info: 12 other: 00 shndx: 1 value: 630 size: 34
sym: memcpy value: 584630 addr: 58974c
sym: sha256_process info: 12 other: 00 shndx: 1 value: a7c size: 4be0
sym: sha256_process value: 584a7c addr: 589760
sym: sha256_process info: 12 other: 00 shndx: 1 value: a7c size: 4be0
sym: sha256_process value: 584a7c addr: 589798
sym:     memcpy info: 12 other: 00 shndx: 1 value: 630 size: 34
sym: memcpy value: 584630 addr: 5897e8
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589ec8 addr: 58991a
sym:      .data info: 03 other: 00 shndx: 4 value: 0 size: 0
sym: .data value: 589ec8 addr: 58991e
sym: sha256_update info: 12 other: 00 shndx: 1 value: 565c size: 1b0
sym: sha256_update value: 58965c addr: 589924
sym: sha256_update info: 12 other: 00 shndx: 1 value: 565c size: 1b0
sym: sha256_update value: 58965c addr: 589938
reserve regions: 1
0: offset: 17fd000, size: 3000
debug.dtb written
kexec_load: entry = 0x5846a4 flags = 0
nr_segments = 3
segment[0].buf   = 0x48042008
segment[0].bufsz = 534e80
segment[0].mem   = (nil)
segment[0].memsz = 584000
segment[1].buf   = 0x1007b250
segment[1].bufsz = 5f20
segment[1].mem   = 0x584000
segment[1].memsz = 6000
segment[2].buf   = 0x100811d8
segment[2].bufsz = 25fe
segment[2].mem   = 0x17fd000
segment[2].memsz = 3000
[   46.492284] xhci_hcd 0001:03:00.0: Host not halted after 16000 microseconds.
[   46.499501] Starting new kernel
[   46.506211] Bye!

Kexec is still working on a Freescale 834x PowerPC CPU and the output
of kexec looks similary.

Any ideas?

- Stefani

BTW: This is a extract of my kernel .config

#
# Processor support
#
# CONFIG_PPC_BOOK3S_32 is not set
CONFIG_PPC_85xx=y
# CONFIG_PPC_8xx is not set
# CONFIG_40x is not set
# CONFIG_44x is not set
# CONFIG_E200 is not set
CONFIG_E500=y
# CONFIG_PPC_E500MC is not set
CONFIG_FSL_EMB_PERFMON=y
CONFIG_BOOKE=y
CONFIG_FSL_BOOKE=y
CONFIG_PPC_FSL_BOOK3E=y
# CONFIG_PHYS_64BIT is not set
CONFIG_SPE=y
CONFIG_PPC_MMU_NOHASH=y
CONFIG_PPC_BOOK3E_MMU=y
# CONFIG_PPC_MM_SLICES is not set
CONFIG_SMP=y
CONFIG_NR_CPUS=2
CONFIG_PPC_DOORBELL=y
CONFIG_PPC32=y
CONFIG_32BIT=y
CONFIG_WORD_SIZE=32
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_MMU=y
# CONFIG_HAVE_SETUP_PER_CPU_AREA is not set
# CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK is not set
CONFIG_NR_IRQS=512
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_LOCKBREAK=y
CONFIG_ARCH_HAS_ILOG2_U32=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_PPC=y
CONFIG_EARLY_PRINTK=y
CONFIG_GENERIC_NVRAM=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_PPC_OF=y
CONFIG_PPC_UDBG_16550=y
CONFIG_GENERIC_TBSYNC=y
CONFIG_AUDIT_ARCH=y
CONFIG_GENERIC_BUG=y
# CONFIG_EPAPR_BOOT is not set
CONFIG_DEFAULT_UIMAGE=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_PPC_DCR_NATIVE is not set
# CONFIG_PPC_DCR_MMIO is not set
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_PPC_ADV_DEBUG_REGS=y
CONFIG_PPC_ADV_DEBUG_IACS=2
CONFIG_PPC_ADV_DEBUG_DACS=2
CONFIG_PPC_ADV_DEBUG_DVCS=0
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_DEFAULT_HOSTNAME="instrument"
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_SHOW_LEVEL=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_GENERIC_TIME_VSYSCALL_OLD=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_BOOST is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
# CONFIG_CGROUPS is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_UIDGID_CONVERTED=y
# CONFIG_UIDGID_STRICT_TYPE_CHECKS is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_RD_GZIP is not set
# CONFIG_RD_BZIP2 is not set
CONFIG_RD_LZMA=y
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HOTPLUG=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
# CONFIG_PERF_EVENTS is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_BSGLIB is not set
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set
CONFIG_PPC_MSI_BITMAP=y
# CONFIG_PPC_XICS is not set
# CONFIG_PPC_ICP_NATIVE is not set
# CONFIG_PPC_ICP_HV is not set
# CONFIG_PPC_ICS_RTAS is not set
# CONFIG_GE_FPGA is not set

#
# Platform support
#
CONFIG_POWERNV_MSI=y
# CONFIG_PPC_CELL is not set
# CONFIG_PPC_CELL_NATIVE is not set
# CONFIG_PQ2ADS is not set
CONFIG_FSL_SOC_BOOKE=y
# CONFIG_BSC9131_RDB is not set
# CONFIG_MPC8540_ADS is not set
# CONFIG_MPC8560_ADS is not set
# CONFIG_MPC85xx_CDS is not set
# CONFIG_MPC85xx_MDS is not set
# CONFIG_MPC8536_DS is not set
# CONFIG_MPC85xx_DS is not set
# CONFIG_MPC85xx_RDB is not set
# CONFIG_P1010_RDB is not set
# CONFIG_P1022_DS is not set
# CONFIG_P1022_RDK is not set
# CONFIG_P1023_RDS is not set
# CONFIG_SOCRATES is not set
# CONFIG_KSI8560 is not set
# CONFIG_XES_MPC85xx is not set
# CONFIG_STX_GP3 is not set
# CONFIG_TQM8540 is not set
# CONFIG_TQM8541 is not set
# CONFIG_TQM8548 is not set
# CONFIG_TQM8555 is not set
# CONFIG_TQM8560 is not set
# CONFIG_SBC8548 is not set
# CONFIG_PPA8548 is not set
# CONFIG_GE_IMP3A is not set
# CONFIG_P2041_RDB is not set
# CONFIG_P3041_DS is not set
# CONFIG_P4080_DS is not set
CONFIG_RS85xx=y
# CONFIG_P5020_DS is not set
# CONFIG_P5040_DS is not set
# CONFIG_PPC_QEMU_E500 is not set
# CONFIG_PPC_WSP is not set
# CONFIG_KVM_GUEST is not set
# CONFIG_EPAPR_PARAVIRT is not set
CONFIG_PPC_SMP_MUXED_IPI=y
# CONFIG_IPIC is not set
CONFIG_MPIC=y
# CONFIG_PPC_EPAPR_HV_PIC is not set
# CONFIG_MPIC_WEIRD is not set
# CONFIG_MPIC_MSGR is not set
CONFIG_PPC_I8259=y
# CONFIG_PPC_RTAS is not set
# CONFIG_MMIO_NVRAM is not set
# CONFIG_MPIC_U3_HT_IRQS is not set
# CONFIG_PPC_MPC106 is not set
# CONFIG_PPC_970_NAP is not set
# CONFIG_PPC_P7_NAP is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPUIdle driver
#
# CONFIG_CPU_IDLE is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
# CONFIG_QUICC_ENGINE is not set
# CONFIG_CPM2 is not set
CONFIG_FSL_ULI1575=y
CONFIG_SIMPLE_GPIO=y

#
# Kernel options
#
CONFIG_HIGHMEM=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
CONFIG_MATH_EMULATION=y
CONFIG_IOMMU_HELPER=y
CONFIG_SWIOTLB=y
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HAS_WALK_MEMORY=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_IRQ_ALL_CPUS=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_CLEANCACHE is not set
CONFIG_PPC_4K_PAGES=y
CONFIG_FORCE_MAX_ZONEORDER=12
# CONFIG_CMDLINE_BOOL is not set
CONFIG_EXTRA_TARGETS=""
# CONFIG_SUSPEND is not set
# CONFIG_PM_RUNTIME is not set
# CONFIG_SECCOMP is not set
CONFIG_ISA_DMA_API=y

#
# Bus options
#
CONFIG_ZONE_DMA=y
# CONFIG_NEED_DMA_MAP_STATE is not set
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_PPC_INDIRECT_PCI=y
CONFIG_FSL_SOC=y
CONFIG_FSL_PCI=y
CONFIG_FSL_LBC=y
CONFIG_PPC_PCI_CHOICE=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_SYSCALL=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
# CONFIG_PCIEASPM_DEFAULT is not set
# CONFIG_PCIEASPM_POWERSAVE is not set
CONFIG_PCIEASPM_PERFORMANCE=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_HAS_RAPIDIO is not set
# CONFIG_RAPIDIO is not set
CONFIG_NONSTATIC_KERNEL=y

#
# Advanced setup
#
CONFIG_ADVANCED_OPTIONS=y
# CONFIG_LOWMEM_SIZE_BOOL is not set
CONFIG_LOWMEM_SIZE=0x30000000
# CONFIG_LOWMEM_CAM_NUM_BOOL is not set
CONFIG_LOWMEM_CAM_NUM=3
CONFIG_DYNAMIC_MEMSTART=y
# CONFIG_PAGE_OFFSET_BOOL is not set
CONFIG_PAGE_OFFSET=0xc0000000
# CONFIG_KERNEL_START_BOOL is not set
CONFIG_KERNEL_START=0xc0000000
# CONFIG_PHYSICAL_START_BOOL is not set
CONFIG_PHYSICAL_START=0x00000000
CONFIG_PHYSICAL_ALIGN=0x04000000
# CONFIG_TASK_SIZE_BOOL is not set
CONFIG_TASK_SIZE=0xc0000000
CONFIG_NET=y

