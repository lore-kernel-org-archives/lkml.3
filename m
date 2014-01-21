Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaAUFVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 00:21:14 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37179 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaAUFVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 00:21:01 -0500
Date: Mon, 20 Jan 2014 21:20:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [rcu] c0f4dfd4f9: -65% softirqs.RCU
Message-ID: <20140121052055.GA18874@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140119121608.GB2859@localhost>
 <20140119231114.GE10038@linux.vnet.ibm.com>
 <20140120122912.GA18137@localhost>
 <20140121044100.GS10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <20140121044100.GS10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012105-7164-0000-0000-0000054700AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 20, 2014 at 08:41:00PM -0800, Paul E. McKenney wrote:
> On Mon, Jan 20, 2014 at 08:29:12PM +0800, Fengguang Wu wrote:
> > On Sun, Jan 19, 2014 at 03:11:14PM -0800, Paul E. McKenney wrote:
> > > On Sun, Jan 19, 2014 at 08:16:08PM +0800, Fengguang Wu wrote:
> > > > Hi Paul,
> > > > 
> > > > Just FYI, we noticed the following changes (which looks good) on old commit
> > > > c0f4dfd4f9 ("rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks") 
> > > > in test case dd-write/4HDD-JBOD-cfq-btrfs-1dd:
> > > > 
> > > > b11cc5 (parent)  c0f4dfd4f90f1667d234d21f1  
> > > > ---------------  -------------------------  
> > > >     213757 ~ 4%     -65.4%      73929 ~ 3%  softirqs.RCU
> > > >      21193 ~ 5%     -36.5%      13451 ~ 4%  softirqs.SCHED
> > > >       2036 ~ 4%     -59.4%        825 ~ 3%  vmstat.system.cs
> > > >    1304520 ~ 4%     -59.2%     532451 ~ 3%  perf-stat.context-switches
> > > >      95685 ~ 4%     -44.0%      53598 ~ 2%  perf-stat.cpu-migrations
> > > 
> > > Glad it helped!  IIRC, this same commit increased latencies due to
> > > synchronize_rcu() latency increasing.  So this is the good side of
> > > that other not-so-good result.  ;-)
> > 
> > If you care it and there is a low cost way for user space to get that
> > synchronize_rcu() latency, I'd be eager to collect it in my tests. :)
> 
> Would a kernel module that measured the latency be OK, or do you need
> some system call that is exposed to synchronize_rcu() latency?

Or, perhaps marginally more helpfully, please see attached for a tarball
of some old modules and scripts to measure RCU performance.  These date
from 2007 or thereabouts, so probably need a bit of modification.

							Thanx, Paul

> > Thanks,
> > Fengguang
> > 
> > > 							Thanx, Paul
> > > 
> > > > The "~ N%" numbers are stddev percent.
> > > > 
> > > >                                perf-stat.cpu-migrations
> > > > 
> > > >    120000 ++----------------------------------------------------------------+
> > > >           |                                                                 |
> > > >    110000 ++          *     *    *.       *   **.                           |
> > > >    100000 *+ .*    *  :+    ::  +  *.*   : : :   *    .*                    |
> > > >           | *  *. + +:  *  : : *      :  : : :    + .*  :                   |
> > > >     90000 ++     *   *   + :  *       : *   *      *    *.*                 |
> > > >           |               *            *                                    |
> > > >     80000 ++                                                                |
> > > >           |                                                                 |
> > > >     70000 ++                                                                |
> > > >     60000 ++                                                                |
> > > >           | O        O  O O O  O O O        O  O   O   O    O   O    O      O
> > > >     50000 O+  OO O O  O       O      O OO O               O   O  O O   OO O |
> > > >           |                                   O  O   O  O                   |
> > > >     40000 ++----------------------------------------------------------------+
> > > > 
> > > > 
> > > >                               perf-stat.context-switches
> > > > 
> > > >    1.5e+06 ++---------------------------------------------------------------+
> > > >    1.4e+06 ++       *  *     *    *.       *  *.*.*    *                    |
> > > >            *. .**  : + :+   + *. +  **    + :+     :  + +                   |
> > > >    1.3e+06 ++*   + :  *  *.*    *     + .*  *      *.*   **                 |
> > > >    1.2e+06 ++     *                    *                                    |
> > > >    1.1e+06 ++                                                               |
> > > >      1e+06 ++                                                               |
> > > >            |                                                                |
> > > >     900000 ++                                                               |
> > > >     800000 ++                                                               |
> > > >     700000 ++                                                               |
> > > >     600000 ++O               O  O                                           |
> > > >            O   OO O   OO O O  O   O OO O O OO O O OO O O OO O O O  O O    O O
> > > >     500000 ++       O                                            O     OO   |
> > > >     400000 ++---------------------------------------------------------------+
> > > > 
> > > > 
> > > >                                   vmstat.system.cs
> > > > 
> > > >    2400 ++------------------------------------------------------------------+
> > > >         |            *    *.    *.       *   *. *     *                     |
> > > >    2200 *+ .*.*  *. + +   : *. +  *.*   + + +  * +   + +                    |
> > > >    2000 ++*    :+  *   *.*    *      *.*   *      *.*   *.*                 |
> > > >         |      *                                                            |
> > > >    1800 ++                                                                  |
> > > >    1600 ++                                                                  |
> > > >         |                                                                   |
> > > >    1400 ++                                                                  |
> > > >    1200 ++                                                                  |
> > > >         |                                                                   |
> > > >    1000 ++O              OO   O                                             |
> > > >     800 O+  O OO   O O O    O   O O  O O O O O OO O O O O OO O O   O O  O O O
> > > >         |        O                  O                            O    O     |
> > > >     600 ++------------------------------------------------------------------+
> > > > 
> > > > Thanks,
> > > > Fengguang
> > > 
> > > > #
> > > > # Automatically generated file; DO NOT EDIT.
> > > > # Linux/x86_64 3.9.0-rc2 Kernel Configuration
> > > > #
> > > > CONFIG_64BIT=y
> > > > CONFIG_X86_64=y
> > > > CONFIG_X86=y
> > > > CONFIG_INSTRUCTION_DECODER=y
> > > > CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> > > > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> > > > CONFIG_LOCKDEP_SUPPORT=y
> > > > CONFIG_STACKTRACE_SUPPORT=y
> > > > CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> > > > CONFIG_MMU=y
> > > > CONFIG_NEED_DMA_MAP_STATE=y
> > > > CONFIG_NEED_SG_DMA_LENGTH=y
> > > > CONFIG_GENERIC_ISA_DMA=y
> > > > CONFIG_GENERIC_BUG=y
> > > > CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> > > > CONFIG_GENERIC_HWEIGHT=y
> > > > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> > > > CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> > > > CONFIG_GENERIC_CALIBRATE_DELAY=y
> > > > CONFIG_ARCH_HAS_CPU_RELAX=y
> > > > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> > > > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> > > > CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
> > > > CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> > > > CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> > > > CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> > > > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> > > > CONFIG_ARCH_SUSPEND_POSSIBLE=y
> > > > CONFIG_ZONE_DMA32=y
> > > > CONFIG_AUDIT_ARCH=y
> > > > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> > > > CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> > > > CONFIG_X86_64_SMP=y
> > > > CONFIG_X86_HT=y
> > > > CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> > > > CONFIG_ARCH_CPU_PROBE_RELEASE=y
> > > > CONFIG_ARCH_SUPPORTS_UPROBES=y
> > > > CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> > > > CONFIG_IRQ_WORK=y
> > > > CONFIG_BUILDTIME_EXTABLE_SORT=y
> > > > 
> > > > #
> > > > # General setup
> > > > #
> > > > CONFIG_EXPERIMENTAL=y
> > > > CONFIG_INIT_ENV_ARG_LIMIT=32
> > > > CONFIG_CROSS_COMPILE=""
> > > > CONFIG_LOCALVERSION=""
> > > > CONFIG_LOCALVERSION_AUTO=y
> > > > CONFIG_HAVE_KERNEL_GZIP=y
> > > > CONFIG_HAVE_KERNEL_BZIP2=y
> > > > CONFIG_HAVE_KERNEL_LZMA=y
> > > > CONFIG_HAVE_KERNEL_XZ=y
> > > > CONFIG_HAVE_KERNEL_LZO=y
> > > > CONFIG_KERNEL_GZIP=y
> > > > # CONFIG_KERNEL_BZIP2 is not set
> > > > # CONFIG_KERNEL_LZMA is not set
> > > > # CONFIG_KERNEL_XZ is not set
> > > > # CONFIG_KERNEL_LZO is not set
> > > > CONFIG_DEFAULT_HOSTNAME="(none)"
> > > > CONFIG_SWAP=y
> > > > CONFIG_SYSVIPC=y
> > > > CONFIG_SYSVIPC_SYSCTL=y
> > > > CONFIG_POSIX_MQUEUE=y
> > > > CONFIG_POSIX_MQUEUE_SYSCTL=y
> > > > # CONFIG_FHANDLE is not set
> > > > # CONFIG_AUDIT is not set
> > > > CONFIG_HAVE_GENERIC_HARDIRQS=y
> > > > 
> > > > #
> > > > # IRQ subsystem
> > > > #
> > > > CONFIG_GENERIC_HARDIRQS=y
> > > > CONFIG_GENERIC_IRQ_PROBE=y
> > > > CONFIG_GENERIC_IRQ_SHOW=y
> > > > CONFIG_GENERIC_PENDING_IRQ=y
> > > > CONFIG_IRQ_DOMAIN=y
> > > > # CONFIG_IRQ_DOMAIN_DEBUG is not set
> > > > CONFIG_IRQ_FORCED_THREADING=y
> > > > CONFIG_SPARSE_IRQ=y
> > > > CONFIG_CLOCKSOURCE_WATCHDOG=y
> > > > CONFIG_ARCH_CLOCKSOURCE_DATA=y
> > > > CONFIG_ALWAYS_USE_PERSISTENT_CLOCK=y
> > > > CONFIG_GENERIC_TIME_VSYSCALL=y
> > > > CONFIG_GENERIC_CLOCKEVENTS=y
> > > > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> > > > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> > > > CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> > > > CONFIG_GENERIC_CMOS_UPDATE=y
> > > > 
> > > > #
> > > > # Timers subsystem
> > > > #
> > > > CONFIG_TICK_ONESHOT=y
> > > > CONFIG_NO_HZ=y
> > > > CONFIG_HIGH_RES_TIMERS=y
> > > > 
> > > > #
> > > > # CPU/Task time and stats accounting
> > > > #
> > > > CONFIG_TICK_CPU_ACCOUNTING=y
> > > > # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> > > > # CONFIG_IRQ_TIME_ACCOUNTING is not set
> > > > CONFIG_BSD_PROCESS_ACCT=y
> > > > CONFIG_BSD_PROCESS_ACCT_V3=y
> > > > CONFIG_TASKSTATS=y
> > > > CONFIG_TASK_DELAY_ACCT=y
> > > > CONFIG_TASK_XACCT=y
> > > > CONFIG_TASK_IO_ACCOUNTING=y
> > > > 
> > > > #
> > > > # RCU Subsystem
> > > > #
> > > > CONFIG_TREE_RCU=y
> > > > # CONFIG_PREEMPT_RCU is not set
> > > > CONFIG_RCU_STALL_COMMON=y
> > > > # CONFIG_RCU_USER_QS is not set
> > > > CONFIG_RCU_FANOUT=64
> > > > CONFIG_RCU_FANOUT_LEAF=16
> > > > # CONFIG_RCU_FANOUT_EXACT is not set
> > > > CONFIG_RCU_FAST_NO_HZ=y
> > > > # CONFIG_TREE_RCU_TRACE is not set
> > > > # CONFIG_RCU_NOCB_CPU is not set
> > > > CONFIG_IKCONFIG=y
> > > > CONFIG_IKCONFIG_PROC=y
> > > > CONFIG_LOG_BUF_SHIFT=20
> > > > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> > > > CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> > > > CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> > > > CONFIG_ARCH_USES_NUMA_PROT_NONE=y
> > > > # CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
> > > > CONFIG_NUMA_BALANCING=y
> > > > CONFIG_CGROUPS=y
> > > > # CONFIG_CGROUP_DEBUG is not set
> > > > CONFIG_CGROUP_FREEZER=y
> > > > CONFIG_CGROUP_DEVICE=y
> > > > CONFIG_CPUSETS=y
> > > > CONFIG_PROC_PID_CPUSET=y
> > > > # CONFIG_CGROUP_CPUACCT is not set
> > > > CONFIG_RESOURCE_COUNTERS=y
> > > > CONFIG_MEMCG=y
> > > > CONFIG_MEMCG_SWAP=y
> > > > CONFIG_MEMCG_SWAP_ENABLED=y
> > > > CONFIG_MEMCG_KMEM=y
> > > > CONFIG_CGROUP_HUGETLB=y
> > > > CONFIG_CGROUP_PERF=y
> > > > CONFIG_CGROUP_SCHED=y
> > > > CONFIG_FAIR_GROUP_SCHED=y
> > > > # CONFIG_CFS_BANDWIDTH is not set
> > > > # CONFIG_RT_GROUP_SCHED is not set
> > > > CONFIG_BLK_CGROUP=y
> > > > # CONFIG_DEBUG_BLK_CGROUP is not set
> > > > CONFIG_CHECKPOINT_RESTORE=y
> > > > CONFIG_NAMESPACES=y
> > > > CONFIG_UTS_NS=y
> > > > CONFIG_IPC_NS=y
> > > > CONFIG_PID_NS=y
> > > > CONFIG_NET_NS=y
> > > > # CONFIG_SCHED_AUTOGROUP is not set
> > > > CONFIG_MM_OWNER=y
> > > > # CONFIG_SYSFS_DEPRECATED is not set
> > > > CONFIG_RELAY=y
> > > > CONFIG_BLK_DEV_INITRD=y
> > > > CONFIG_INITRAMFS_SOURCE=""
> > > > CONFIG_RD_GZIP=y
> > > > CONFIG_RD_BZIP2=y
> > > > CONFIG_RD_LZMA=y
> > > > CONFIG_RD_XZ=y
> > > > CONFIG_RD_LZO=y
> > > > CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> > > > CONFIG_SYSCTL=y
> > > > CONFIG_ANON_INODES=y
> > > > CONFIG_EXPERT=y
> > > > CONFIG_HAVE_UID16=y
> > > > CONFIG_UID16=y
> > > > # CONFIG_SYSCTL_SYSCALL is not set
> > > > CONFIG_SYSCTL_EXCEPTION_TRACE=y
> > > > CONFIG_KALLSYMS=y
> > > > # CONFIG_KALLSYMS_ALL is not set
> > > > CONFIG_HOTPLUG=y
> > > > CONFIG_PRINTK=y
> > > > CONFIG_BUG=y
> > > > CONFIG_ELF_CORE=y
> > > > CONFIG_PCSPKR_PLATFORM=y
> > > > CONFIG_HAVE_PCSPKR_PLATFORM=y
> > > > CONFIG_BASE_FULL=y
> > > > CONFIG_FUTEX=y
> > > > CONFIG_EPOLL=y
> > > > CONFIG_SIGNALFD=y
> > > > CONFIG_TIMERFD=y
> > > > CONFIG_EVENTFD=y
> > > > CONFIG_SHMEM=y
> > > > CONFIG_AIO=y
> > > > # CONFIG_EMBEDDED is not set
> > > > CONFIG_HAVE_PERF_EVENTS=y
> > > > 
> > > > #
> > > > # Kernel Performance Events And Counters
> > > > #
> > > > CONFIG_PERF_EVENTS=y
> > > > # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> > > > CONFIG_VM_EVENT_COUNTERS=y
> > > > CONFIG_PCI_QUIRKS=y
> > > > CONFIG_SLUB_DEBUG=y
> > > > # CONFIG_COMPAT_BRK is not set
> > > > # CONFIG_SLAB is not set
> > > > CONFIG_SLUB=y
> > > > # CONFIG_SLOB is not set
> > > > CONFIG_PROFILING=y
> > > > CONFIG_TRACEPOINTS=y
> > > > # CONFIG_OPROFILE is not set
> > > > CONFIG_HAVE_OPROFILE=y
> > > > CONFIG_OPROFILE_NMI_TIMER=y
> > > > CONFIG_KPROBES=y
> > > > # CONFIG_JUMP_LABEL is not set
> > > > CONFIG_OPTPROBES=y
> > > > CONFIG_KPROBES_ON_FTRACE=y
> > > > CONFIG_UPROBES=y
> > > > # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> > > > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> > > > CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> > > > CONFIG_KRETPROBES=y
> > > > CONFIG_USER_RETURN_NOTIFIER=y
> > > > CONFIG_HAVE_IOREMAP_PROT=y
> > > > CONFIG_HAVE_KPROBES=y
> > > > CONFIG_HAVE_KRETPROBES=y
> > > > CONFIG_HAVE_OPTPROBES=y
> > > > CONFIG_HAVE_KPROBES_ON_FTRACE=y
> > > > CONFIG_HAVE_ARCH_TRACEHOOK=y
> > > > CONFIG_HAVE_DMA_ATTRS=y
> > > > CONFIG_USE_GENERIC_SMP_HELPERS=y
> > > > CONFIG_GENERIC_SMP_IDLE_THREAD=y
> > > > CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> > > > CONFIG_HAVE_DMA_API_DEBUG=y
> > > > CONFIG_HAVE_HW_BREAKPOINT=y
> > > > CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> > > > CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> > > > CONFIG_HAVE_PERF_EVENTS_NMI=y
> > > > CONFIG_HAVE_PERF_REGS=y
> > > > CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> > > > CONFIG_HAVE_ARCH_JUMP_LABEL=y
> > > > CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> > > > CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> > > > CONFIG_HAVE_CMPXCHG_LOCAL=y
> > > > CONFIG_HAVE_CMPXCHG_DOUBLE=y
> > > > CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> > > > CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> > > > CONFIG_HAVE_VIRT_TO_BUS=y
> > > > CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> > > > CONFIG_SECCOMP_FILTER=y
> > > > CONFIG_HAVE_CONTEXT_TRACKING=y
> > > > CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> > > > CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> > > > CONFIG_MODULES_USE_ELF_RELA=y
> > > > CONFIG_OLD_SIGSUSPEND3=y
> > > > CONFIG_COMPAT_OLD_SIGACTION=y
> > > > 
> > > > #
> > > > # GCOV-based kernel profiling
> > > > #
> > > > # CONFIG_GCOV_KERNEL is not set
> > > > # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> > > > CONFIG_SLABINFO=y
> > > > CONFIG_RT_MUTEXES=y
> > > > CONFIG_BASE_SMALL=0
> > > > CONFIG_MODULES=y
> > > > # CONFIG_MODULE_FORCE_LOAD is not set
> > > > CONFIG_MODULE_UNLOAD=y
> > > > # CONFIG_MODULE_FORCE_UNLOAD is not set
> > > > CONFIG_MODVERSIONS=y
> > > > CONFIG_MODULE_SRCVERSION_ALL=y
> > > > # CONFIG_MODULE_SIG is not set
> > > > CONFIG_STOP_MACHINE=y
> > > > CONFIG_BLOCK=y
> > > > CONFIG_BLK_DEV_BSG=y
> > > > CONFIG_BLK_DEV_BSGLIB=y
> > > > CONFIG_BLK_DEV_INTEGRITY=y
> > > > CONFIG_BLK_DEV_THROTTLING=y
> > > > 
> > > > #
> > > > # Partition Types
> > > > #
> > > > CONFIG_PARTITION_ADVANCED=y
> > > > # CONFIG_ACORN_PARTITION is not set
> > > > CONFIG_OSF_PARTITION=y
> > > > CONFIG_AMIGA_PARTITION=y
> > > > # CONFIG_ATARI_PARTITION is not set
> > > > CONFIG_MAC_PARTITION=y
> > > > CONFIG_MSDOS_PARTITION=y
> > > > CONFIG_BSD_DISKLABEL=y
> > > > CONFIG_MINIX_SUBPARTITION=y
> > > > CONFIG_SOLARIS_X86_PARTITION=y
> > > > CONFIG_UNIXWARE_DISKLABEL=y
> > > > # CONFIG_LDM_PARTITION is not set
> > > > CONFIG_SGI_PARTITION=y
> > > > # CONFIG_ULTRIX_PARTITION is not set
> > > > CONFIG_SUN_PARTITION=y
> > > > CONFIG_KARMA_PARTITION=y
> > > > CONFIG_EFI_PARTITION=y
> > > > # CONFIG_SYSV68_PARTITION is not set
> > > > CONFIG_BLOCK_COMPAT=y
> > > > 
> > > > #
> > > > # IO Schedulers
> > > > #
> > > > CONFIG_IOSCHED_NOOP=y
> > > > CONFIG_IOSCHED_DEADLINE=y
> > > > CONFIG_IOSCHED_CFQ=y
> > > > CONFIG_CFQ_GROUP_IOSCHED=y
> > > > # CONFIG_DEFAULT_DEADLINE is not set
> > > > CONFIG_DEFAULT_CFQ=y
> > > > # CONFIG_DEFAULT_NOOP is not set
> > > > CONFIG_DEFAULT_IOSCHED="cfq"
> > > > CONFIG_PREEMPT_NOTIFIERS=y
> > > > CONFIG_PADATA=y
> > > > CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> > > > CONFIG_INLINE_READ_UNLOCK=y
> > > > CONFIG_INLINE_READ_UNLOCK_IRQ=y
> > > > CONFIG_INLINE_WRITE_UNLOCK=y
> > > > CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> > > > CONFIG_MUTEX_SPIN_ON_OWNER=y
> > > > CONFIG_FREEZER=y
> > > > 
> > > > #
> > > > # Processor type and features
> > > > #
> > > > CONFIG_ZONE_DMA=y
> > > > CONFIG_SMP=y
> > > > CONFIG_X86_MPPARSE=y
> > > > CONFIG_X86_EXTENDED_PLATFORM=y
> > > > # CONFIG_X86_VSMP is not set
> > > > # CONFIG_X86_INTEL_LPSS is not set
> > > > CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> > > > # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> > > > CONFIG_PARAVIRT_GUEST=y
> > > > # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> > > > # CONFIG_XEN is not set
> > > > # CONFIG_XEN_PRIVILEGED_GUEST is not set
> > > > CONFIG_KVM_GUEST=y
> > > > CONFIG_PARAVIRT=y
> > > > # CONFIG_PARAVIRT_SPINLOCKS is not set
> > > > CONFIG_PARAVIRT_CLOCK=y
> > > > # CONFIG_PARAVIRT_DEBUG is not set
> > > > CONFIG_NO_BOOTMEM=y
> > > > # CONFIG_MEMTEST is not set
> > > > # CONFIG_MK8 is not set
> > > > # CONFIG_MPSC is not set
> > > > # CONFIG_MCORE2 is not set
> > > > # CONFIG_MATOM is not set
> > > > CONFIG_GENERIC_CPU=y
> > > > CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> > > > CONFIG_X86_L1_CACHE_SHIFT=6
> > > > CONFIG_X86_TSC=y
> > > > CONFIG_X86_CMPXCHG64=y
> > > > CONFIG_X86_CMOV=y
> > > > CONFIG_X86_MINIMUM_CPU_FAMILY=64
> > > > CONFIG_X86_DEBUGCTLMSR=y
> > > > # CONFIG_PROCESSOR_SELECT is not set
> > > > CONFIG_CPU_SUP_INTEL=y
> > > > CONFIG_CPU_SUP_AMD=y
> > > > CONFIG_CPU_SUP_CENTAUR=y
> > > > CONFIG_HPET_TIMER=y
> > > > CONFIG_HPET_EMULATE_RTC=y
> > > > CONFIG_DMI=y
> > > > CONFIG_GART_IOMMU=y
> > > > # CONFIG_CALGARY_IOMMU is not set
> > > > CONFIG_SWIOTLB=y
> > > > CONFIG_IOMMU_HELPER=y
> > > > # CONFIG_MAXSMP is not set
> > > > CONFIG_NR_CPUS=512
> > > > CONFIG_SCHED_SMT=y
> > > > CONFIG_SCHED_MC=y
> > > > # CONFIG_PREEMPT_NONE is not set
> > > > CONFIG_PREEMPT_VOLUNTARY=y
> > > > # CONFIG_PREEMPT is not set
> > > > CONFIG_PREEMPT_COUNT=y
> > > > CONFIG_X86_LOCAL_APIC=y
> > > > CONFIG_X86_IO_APIC=y
> > > > CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> > > > CONFIG_X86_MCE=y
> > > > CONFIG_X86_MCE_INTEL=y
> > > > # CONFIG_X86_MCE_AMD is not set
> > > > CONFIG_X86_MCE_THRESHOLD=y
> > > > CONFIG_X86_MCE_INJECT=m
> > > > CONFIG_X86_THERMAL_VECTOR=y
> > > > CONFIG_I8K=m
> > > > CONFIG_MICROCODE=m
> > > > CONFIG_MICROCODE_INTEL=y
> > > > CONFIG_MICROCODE_AMD=y
> > > > CONFIG_MICROCODE_OLD_INTERFACE=y
> > > > CONFIG_MICROCODE_INTEL_LIB=y
> > > > # CONFIG_MICROCODE_INTEL_EARLY is not set
> > > > CONFIG_X86_MSR=m
> > > > CONFIG_X86_CPUID=m
> > > > CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> > > > CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> > > > CONFIG_DIRECT_GBPAGES=y
> > > > CONFIG_NUMA=y
> > > > CONFIG_AMD_NUMA=y
> > > > CONFIG_X86_64_ACPI_NUMA=y
> > > > CONFIG_NODES_SPAN_OTHER_NODES=y
> > > > # CONFIG_NUMA_EMU is not set
> > > > CONFIG_NODES_SHIFT=6
> > > > CONFIG_ARCH_SPARSEMEM_ENABLE=y
> > > > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> > > > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> > > > CONFIG_ARCH_MEMORY_PROBE=y
> > > > CONFIG_ARCH_PROC_KCORE_TEXT=y
> > > > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> > > > CONFIG_SELECT_MEMORY_MODEL=y
> > > > CONFIG_SPARSEMEM_MANUAL=y
> > > > CONFIG_SPARSEMEM=y
> > > > CONFIG_NEED_MULTIPLE_NODES=y
> > > > CONFIG_HAVE_MEMORY_PRESENT=y
> > > > CONFIG_SPARSEMEM_EXTREME=y
> > > > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> > > > CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> > > > CONFIG_SPARSEMEM_VMEMMAP=y
> > > > CONFIG_HAVE_MEMBLOCK=y
> > > > CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> > > > CONFIG_ARCH_DISCARD_MEMBLOCK=y
> > > > CONFIG_MEMORY_ISOLATION=y
> > > > # CONFIG_MOVABLE_NODE is not set
> > > > CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> > > > CONFIG_MEMORY_HOTPLUG=y
> > > > CONFIG_MEMORY_HOTPLUG_SPARSE=y
> > > > CONFIG_MEMORY_HOTREMOVE=y
> > > > CONFIG_PAGEFLAGS_EXTENDED=y
> > > > CONFIG_SPLIT_PTLOCK_CPUS=4
> > > > CONFIG_BALLOON_COMPACTION=y
> > > > CONFIG_COMPACTION=y
> > > > CONFIG_MIGRATION=y
> > > > CONFIG_PHYS_ADDR_T_64BIT=y
> > > > CONFIG_ZONE_DMA_FLAG=1
> > > > CONFIG_BOUNCE=y
> > > > CONFIG_NEED_BOUNCE_POOL=y
> > > > CONFIG_VIRT_TO_BUS=y
> > > > CONFIG_MMU_NOTIFIER=y
> > > > CONFIG_KSM=y
> > > > CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> > > > CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> > > > CONFIG_MEMORY_FAILURE=y
> > > > CONFIG_HWPOISON_INJECT=m
> > > > CONFIG_TRANSPARENT_HUGEPAGE=y
> > > > # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> > > > CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> > > > CONFIG_CROSS_MEMORY_ATTACH=y
> > > > # CONFIG_CLEANCACHE is not set
> > > > # CONFIG_FRONTSWAP is not set
> > > > CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> > > > CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
> > > > CONFIG_X86_RESERVE_LOW=64
> > > > CONFIG_MTRR=y
> > > > CONFIG_MTRR_SANITIZER=y
> > > > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> > > > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> > > > CONFIG_X86_PAT=y
> > > > CONFIG_ARCH_USES_PG_UNCACHED=y
> > > > CONFIG_ARCH_RANDOM=y
> > > > CONFIG_X86_SMAP=y
> > > > CONFIG_EFI=y
> > > > CONFIG_EFI_STUB=y
> > > > CONFIG_SECCOMP=y
> > > > CONFIG_CC_STACKPROTECTOR=y
> > > > # CONFIG_HZ_100 is not set
> > > > CONFIG_HZ_250=y
> > > > # CONFIG_HZ_300 is not set
> > > > # CONFIG_HZ_1000 is not set
> > > > CONFIG_HZ=250
> > > > CONFIG_SCHED_HRTICK=y
> > > > CONFIG_KEXEC=y
> > > > CONFIG_CRASH_DUMP=y
> > > > CONFIG_KEXEC_JUMP=y
> > > > CONFIG_PHYSICAL_START=0x1000000
> > > > CONFIG_RELOCATABLE=y
> > > > CONFIG_PHYSICAL_ALIGN=0x1000000
> > > > CONFIG_HOTPLUG_CPU=y
> > > > # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> > > > # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> > > > CONFIG_COMPAT_VDSO=y
> > > > # CONFIG_CMDLINE_BOOL is not set
> > > > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> > > > CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> > > > CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> > > > 
> > > > #
> > > > # Power management and ACPI options
> > > > #
> > > > CONFIG_ARCH_HIBERNATION_HEADER=y
> > > > CONFIG_SUSPEND=y
> > > > CONFIG_SUSPEND_FREEZER=y
> > > > CONFIG_HIBERNATE_CALLBACKS=y
> > > > CONFIG_HIBERNATION=y
> > > > CONFIG_PM_STD_PARTITION=""
> > > > CONFIG_PM_SLEEP=y
> > > > CONFIG_PM_SLEEP_SMP=y
> > > > CONFIG_PM_AUTOSLEEP=y
> > > > # CONFIG_PM_WAKELOCKS is not set
> > > > CONFIG_PM_RUNTIME=y
> > > > CONFIG_PM=y
> > > > CONFIG_PM_DEBUG=y
> > > > CONFIG_PM_ADVANCED_DEBUG=y
> > > > # CONFIG_PM_TEST_SUSPEND is not set
> > > > CONFIG_PM_SLEEP_DEBUG=y
> > > > # CONFIG_PM_TRACE_RTC is not set
> > > > CONFIG_ACPI=y
> > > > CONFIG_ACPI_SLEEP=y
> > > > # CONFIG_ACPI_PROCFS is not set
> > > > # CONFIG_ACPI_PROCFS_POWER is not set
> > > > # CONFIG_ACPI_EC_DEBUGFS is not set
> > > > CONFIG_ACPI_PROC_EVENT=y
> > > > CONFIG_ACPI_AC=y
> > > > CONFIG_ACPI_BATTERY=y
> > > > CONFIG_ACPI_BUTTON=y
> > > > CONFIG_ACPI_FAN=y
> > > > CONFIG_ACPI_DOCK=y
> > > > CONFIG_ACPI_I2C=y
> > > > CONFIG_ACPI_PROCESSOR=m
> > > > # CONFIG_ACPI_IPMI is not set
> > > > CONFIG_ACPI_HOTPLUG_CPU=y
> > > > CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> > > > CONFIG_ACPI_THERMAL=m
> > > > CONFIG_ACPI_NUMA=y
> > > > # CONFIG_ACPI_CUSTOM_DSDT is not set
> > > > # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> > > > CONFIG_ACPI_BLACKLIST_YEAR=0
> > > > # CONFIG_ACPI_DEBUG is not set
> > > > CONFIG_ACPI_PCI_SLOT=y
> > > > CONFIG_X86_PM_TIMER=y
> > > > CONFIG_ACPI_CONTAINER=y
> > > > # CONFIG_ACPI_HOTPLUG_MEMORY is not set
> > > > # CONFIG_ACPI_SBS is not set
> > > > CONFIG_ACPI_HED=y
> > > > # CONFIG_ACPI_CUSTOM_METHOD is not set
> > > > # CONFIG_ACPI_BGRT is not set
> > > > CONFIG_ACPI_APEI=y
> > > > CONFIG_ACPI_APEI_GHES=y
> > > > CONFIG_ACPI_APEI_PCIEAER=y
> > > > CONFIG_ACPI_APEI_MEMORY_FAILURE=y
> > > > CONFIG_ACPI_APEI_EINJ=y
> > > > # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> > > > # CONFIG_SFI is not set
> > > > 
> > > > #
> > > > # CPU Frequency scaling
> > > > #
> > > > CONFIG_CPU_FREQ=y
> > > > CONFIG_CPU_FREQ_TABLE=y
> > > > CONFIG_CPU_FREQ_GOV_COMMON=y
> > > > CONFIG_CPU_FREQ_STAT=y
> > > > CONFIG_CPU_FREQ_STAT_DETAILS=y
> > > > # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> > > > # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> > > > CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> > > > # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> > > > # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> > > > CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> > > > CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> > > > CONFIG_CPU_FREQ_GOV_USERSPACE=y
> > > > CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > > > CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> > > > 
> > > > #
> > > > # x86 CPU frequency scaling drivers
> > > > #
> > > > CONFIG_X86_INTEL_PSTATE=y
> > > > CONFIG_X86_PCC_CPUFREQ=m
> > > > CONFIG_X86_ACPI_CPUFREQ=m
> > > > CONFIG_X86_ACPI_CPUFREQ_CPB=y
> > > > CONFIG_X86_POWERNOW_K8=m
> > > > CONFIG_X86_SPEEDSTEP_CENTRINO=m
> > > > # CONFIG_X86_P4_CLOCKMOD is not set
> > > > 
> > > > #
> > > > # shared options
> > > > #
> > > > # CONFIG_X86_SPEEDSTEP_LIB is not set
> > > > CONFIG_CPU_IDLE=y
> > > > # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> > > > CONFIG_CPU_IDLE_GOV_LADDER=y
> > > > CONFIG_CPU_IDLE_GOV_MENU=y
> > > > # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> > > > CONFIG_INTEL_IDLE=y
> > > > 
> > > > #
> > > > # Memory power savings
> > > > #
> > > > # CONFIG_I7300_IDLE is not set
> > > > 
> > > > #
> > > > # Bus options (PCI etc.)
> > > > #
> > > > CONFIG_PCI=y
> > > > CONFIG_PCI_DIRECT=y
> > > > CONFIG_PCI_MMCONFIG=y
> > > > CONFIG_PCI_DOMAINS=y
> > > > # CONFIG_PCI_CNB20LE_QUIRK is not set
> > > > CONFIG_PCIEPORTBUS=y
> > > > CONFIG_HOTPLUG_PCI_PCIE=y
> > > > CONFIG_PCIEAER=y
> > > > # CONFIG_PCIE_ECRC is not set
> > > > # CONFIG_PCIEAER_INJECT is not set
> > > > CONFIG_PCIEASPM=y
> > > > # CONFIG_PCIEASPM_DEBUG is not set
> > > > CONFIG_PCIEASPM_DEFAULT=y
> > > > # CONFIG_PCIEASPM_POWERSAVE is not set
> > > > # CONFIG_PCIEASPM_PERFORMANCE is not set
> > > > CONFIG_PCIE_PME=y
> > > > CONFIG_ARCH_SUPPORTS_MSI=y
> > > > CONFIG_PCI_MSI=y
> > > > # CONFIG_PCI_DEBUG is not set
> > > > CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> > > > CONFIG_PCI_STUB=m
> > > > CONFIG_HT_IRQ=y
> > > > CONFIG_PCI_ATS=y
> > > > CONFIG_PCI_IOV=y
> > > > CONFIG_PCI_PRI=y
> > > > CONFIG_PCI_PASID=y
> > > > CONFIG_PCI_IOAPIC=y
> > > > CONFIG_PCI_LABEL=y
> > > > CONFIG_ISA_DMA_API=y
> > > > CONFIG_AMD_NB=y
> > > > CONFIG_PCCARD=y
> > > > CONFIG_PCMCIA=y
> > > > CONFIG_PCMCIA_LOAD_CIS=y
> > > > CONFIG_CARDBUS=y
> > > > 
> > > > #
> > > > # PC-card bridges
> > > > #
> > > > CONFIG_YENTA=y
> > > > CONFIG_YENTA_O2=y
> > > > CONFIG_YENTA_RICOH=y
> > > > CONFIG_YENTA_TI=y
> > > > CONFIG_YENTA_ENE_TUNE=y
> > > > CONFIG_YENTA_TOSHIBA=y
> > > > # CONFIG_PD6729 is not set
> > > > # CONFIG_I82092 is not set
> > > > CONFIG_PCCARD_NONSTATIC=y
> > > > CONFIG_HOTPLUG_PCI=y
> > > > CONFIG_HOTPLUG_PCI_ACPI=y
> > > > # CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
> > > > # CONFIG_HOTPLUG_PCI_CPCI is not set
> > > > # CONFIG_HOTPLUG_PCI_SHPC is not set
> > > > # CONFIG_RAPIDIO is not set
> > > > 
> > > > #
> > > > # Executable file formats / Emulations
> > > > #
> > > > CONFIG_BINFMT_ELF=y
> > > > CONFIG_COMPAT_BINFMT_ELF=y
> > > > CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> > > > # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> > > > # CONFIG_HAVE_AOUT is not set
> > > > CONFIG_BINFMT_MISC=y
> > > > CONFIG_COREDUMP=y
> > > > CONFIG_IA32_EMULATION=y
> > > > CONFIG_IA32_AOUT=y
> > > > # CONFIG_X86_X32 is not set
> > > > CONFIG_COMPAT=y
> > > > CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> > > > CONFIG_SYSVIPC_COMPAT=y
> > > > CONFIG_KEYS_COMPAT=y
> > > > CONFIG_HAVE_TEXT_POKE_SMP=y
> > > > CONFIG_X86_DEV_DMA_OPS=y
> > > > CONFIG_NET=y
> > > > 
> > > > #
> > > > # Networking options
> > > > #
> > > > CONFIG_PACKET=y
> > > > CONFIG_PACKET_DIAG=m
> > > > CONFIG_UNIX=y
> > > > CONFIG_UNIX_DIAG=m
> > > > CONFIG_XFRM=y
> > > > CONFIG_XFRM_ALGO=y
> > > > CONFIG_XFRM_USER=y
> > > > # CONFIG_XFRM_SUB_POLICY is not set
> > > > # CONFIG_XFRM_MIGRATE is not set
> > > > # CONFIG_XFRM_STATISTICS is not set
> > > > # CONFIG_NET_KEY is not set
> > > > CONFIG_INET=y
> > > > CONFIG_IP_MULTICAST=y
> > > > CONFIG_IP_ADVANCED_ROUTER=y
> > > > # CONFIG_IP_FIB_TRIE_STATS is not set
> > > > CONFIG_IP_MULTIPLE_TABLES=y
> > > > CONFIG_IP_ROUTE_MULTIPATH=y
> > > > CONFIG_IP_ROUTE_VERBOSE=y
> > > > CONFIG_IP_PNP=y
> > > > CONFIG_IP_PNP_DHCP=y
> > > > CONFIG_IP_PNP_BOOTP=y
> > > > CONFIG_IP_PNP_RARP=y
> > > > # CONFIG_NET_IPIP is not set
> > > > # CONFIG_NET_IPGRE_DEMUX is not set
> > > > CONFIG_IP_MROUTE=y
> > > > # CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
> > > > CONFIG_IP_PIMSM_V1=y
> > > > CONFIG_IP_PIMSM_V2=y
> > > > # CONFIG_ARPD is not set
> > > > CONFIG_SYN_COOKIES=y
> > > > # CONFIG_INET_AH is not set
> > > > # CONFIG_INET_ESP is not set
> > > > # CONFIG_INET_IPCOMP is not set
> > > > # CONFIG_INET_XFRM_TUNNEL is not set
> > > > CONFIG_INET_TUNNEL=y
> > > > # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> > > > # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> > > > CONFIG_INET_XFRM_MODE_BEET=y
> > > > # CONFIG_INET_LRO is not set
> > > > # CONFIG_INET_DIAG is not set
> > > > CONFIG_TCP_CONG_ADVANCED=y
> > > > CONFIG_TCP_CONG_BIC=y
> > > > # CONFIG_TCP_CONG_CUBIC is not set
> > > > # CONFIG_TCP_CONG_WESTWOOD is not set
> > > > # CONFIG_TCP_CONG_HTCP is not set
> > > > # CONFIG_TCP_CONG_HSTCP is not set
> > > > # CONFIG_TCP_CONG_HYBLA is not set
> > > > # CONFIG_TCP_CONG_VEGAS is not set
> > > > # CONFIG_TCP_CONG_SCALABLE is not set
> > > > # CONFIG_TCP_CONG_LP is not set
> > > > # CONFIG_TCP_CONG_VENO is not set
> > > > # CONFIG_TCP_CONG_YEAH is not set
> > > > # CONFIG_TCP_CONG_ILLINOIS is not set
> > > > CONFIG_DEFAULT_BIC=y
> > > > # CONFIG_DEFAULT_RENO is not set
> > > > CONFIG_DEFAULT_TCP_CONG="bic"
> > > > # CONFIG_TCP_MD5SIG is not set
> > > > CONFIG_IPV6=y
> > > > # CONFIG_IPV6_PRIVACY is not set
> > > > # CONFIG_IPV6_ROUTER_PREF is not set
> > > > # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> > > > # CONFIG_INET6_AH is not set
> > > > # CONFIG_INET6_ESP is not set
> > > > # CONFIG_INET6_IPCOMP is not set
> > > > # CONFIG_IPV6_MIP6 is not set
> > > > # CONFIG_INET6_XFRM_TUNNEL is not set
> > > > # CONFIG_INET6_TUNNEL is not set
> > > > CONFIG_INET6_XFRM_MODE_TRANSPORT=y
> > > > CONFIG_INET6_XFRM_MODE_TUNNEL=y
> > > > CONFIG_INET6_XFRM_MODE_BEET=y
> > > > # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> > > > CONFIG_IPV6_SIT=y
> > > > # CONFIG_IPV6_SIT_6RD is not set
> > > > CONFIG_IPV6_NDISC_NODETYPE=y
> > > > # CONFIG_IPV6_TUNNEL is not set
> > > > # CONFIG_IPV6_GRE is not set
> > > > # CONFIG_IPV6_MULTIPLE_TABLES is not set
> > > > # CONFIG_IPV6_MROUTE is not set
> > > > CONFIG_NETWORK_SECMARK=y
> > > > # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> > > > # CONFIG_NETFILTER is not set
> > > > # CONFIG_IP_DCCP is not set
> > > > CONFIG_IP_SCTP=y
> > > > # CONFIG_NET_SCTPPROBE is not set
> > > > # CONFIG_SCTP_DBG_MSG is not set
> > > > # CONFIG_SCTP_DBG_OBJCNT is not set
> > > > CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
> > > > # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
> > > > # CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
> > > > CONFIG_SCTP_COOKIE_HMAC_MD5=y
> > > > # CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
> > > > # CONFIG_RDS is not set
> > > > # CONFIG_TIPC is not set
> > > > # CONFIG_ATM is not set
> > > > # CONFIG_L2TP is not set
> > > > # CONFIG_BRIDGE is not set
> > > > CONFIG_HAVE_NET_DSA=y
> > > > CONFIG_VLAN_8021Q=y
> > > > # CONFIG_VLAN_8021Q_GVRP is not set
> > > > # CONFIG_VLAN_8021Q_MVRP is not set
> > > > # CONFIG_DECNET is not set
> > > > # CONFIG_LLC2 is not set
> > > > # CONFIG_IPX is not set
> > > > # CONFIG_ATALK is not set
> > > > # CONFIG_X25 is not set
> > > > # CONFIG_LAPB is not set
> > > > # CONFIG_PHONET is not set
> > > > # CONFIG_IEEE802154 is not set
> > > > # CONFIG_NET_SCHED is not set
> > > > # CONFIG_DCB is not set
> > > > CONFIG_DNS_RESOLVER=y
> > > > # CONFIG_BATMAN_ADV is not set
> > > > # CONFIG_OPENVSWITCH is not set
> > > > # CONFIG_VSOCKETS is not set
> > > > CONFIG_RPS=y
> > > > CONFIG_RFS_ACCEL=y
> > > > CONFIG_XPS=y
> > > > # CONFIG_NETPRIO_CGROUP is not set
> > > > CONFIG_BQL=y
> > > > # CONFIG_BPF_JIT is not set
> > > > 
> > > > #
> > > > # Network testing
> > > > #
> > > > # CONFIG_NET_PKTGEN is not set
> > > > # CONFIG_NET_TCPPROBE is not set
> > > > # CONFIG_NET_DROP_MONITOR is not set
> > > > # CONFIG_HAMRADIO is not set
> > > > # CONFIG_CAN is not set
> > > > # CONFIG_IRDA is not set
> > > > # CONFIG_BT is not set
> > > > # CONFIG_AF_RXRPC is not set
> > > > CONFIG_FIB_RULES=y
> > > > CONFIG_WIRELESS=y
> > > > # CONFIG_CFG80211 is not set
> > > > # CONFIG_LIB80211 is not set
> > > > 
> > > > #
> > > > # CFG80211 needs to be enabled for MAC80211
> > > > #
> > > > # CONFIG_WIMAX is not set
> > > > # CONFIG_RFKILL is not set
> > > > # CONFIG_NET_9P is not set
> > > > # CONFIG_CAIF is not set
> > > > # CONFIG_CEPH_LIB is not set
> > > > # CONFIG_NFC is not set
> > > > CONFIG_HAVE_BPF_JIT=y
> > > > 
> > > > #
> > > > # Device Drivers
> > > > #
> > > > 
> > > > #
> > > > # Generic Driver Options
> > > > #
> > > > CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> > > > CONFIG_DEVTMPFS=y
> > > > # CONFIG_DEVTMPFS_MOUNT is not set
> > > > CONFIG_STANDALONE=y
> > > > CONFIG_PREVENT_FIRMWARE_BUILD=y
> > > > CONFIG_FW_LOADER=y
> > > > CONFIG_FIRMWARE_IN_KERNEL=y
> > > > CONFIG_EXTRA_FIRMWARE=""
> > > > CONFIG_FW_LOADER_USER_HELPER=y
> > > > # CONFIG_DEBUG_DRIVER is not set
> > > > # CONFIG_DEBUG_DEVRES is not set
> > > > # CONFIG_SYS_HYPERVISOR is not set
> > > > # CONFIG_GENERIC_CPU_DEVICES is not set
> > > > # CONFIG_DMA_SHARED_BUFFER is not set
> > > > 
> > > > #
> > > > # Bus devices
> > > > #
> > > > CONFIG_CONNECTOR=y
> > > > CONFIG_PROC_EVENTS=y
> > > > # CONFIG_MTD is not set
> > > > # CONFIG_PARPORT is not set
> > > > CONFIG_PNP=y
> > > > CONFIG_PNP_DEBUG_MESSAGES=y
> > > > 
> > > > #
> > > > # Protocols
> > > > #
> > > > CONFIG_PNPACPI=y
> > > > CONFIG_BLK_DEV=y
> > > > # CONFIG_BLK_DEV_FD is not set
> > > > # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> > > > # CONFIG_BLK_CPQ_DA is not set
> > > > # CONFIG_BLK_CPQ_CISS_DA is not set
> > > > # CONFIG_BLK_DEV_DAC960 is not set
> > > > # CONFIG_BLK_DEV_UMEM is not set
> > > > # CONFIG_BLK_DEV_COW_COMMON is not set
> > > > CONFIG_BLK_DEV_LOOP=y
> > > > CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> > > > # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> > > > # CONFIG_BLK_DEV_DRBD is not set
> > > > # CONFIG_BLK_DEV_NBD is not set
> > > > # CONFIG_BLK_DEV_NVME is not set
> > > > # CONFIG_BLK_DEV_SX8 is not set
> > > > CONFIG_BLK_DEV_RAM=y
> > > > CONFIG_BLK_DEV_RAM_COUNT=16
> > > > CONFIG_BLK_DEV_RAM_SIZE=16384
> > > > # CONFIG_BLK_DEV_XIP is not set
> > > > # CONFIG_CDROM_PKTCDVD is not set
> > > > # CONFIG_ATA_OVER_ETH is not set
> > > > CONFIG_VIRTIO_BLK=y
> > > > # CONFIG_BLK_DEV_HD is not set
> > > > # CONFIG_BLK_DEV_RBD is not set
> > > > # CONFIG_BLK_DEV_RSXX is not set
> > > > 
> > > > #
> > > > # Misc devices
> > > > #
> > > > # CONFIG_SENSORS_LIS3LV02D is not set
> > > > # CONFIG_AD525X_DPOT is not set
> > > > # CONFIG_IBM_ASM is not set
> > > > # CONFIG_PHANTOM is not set
> > > > # CONFIG_INTEL_MID_PTI is not set
> > > > # CONFIG_SGI_IOC4 is not set
> > > > # CONFIG_TIFM_CORE is not set
> > > > # CONFIG_ICS932S401 is not set
> > > > # CONFIG_ATMEL_SSC is not set
> > > > # CONFIG_ENCLOSURE_SERVICES is not set
> > > > # CONFIG_HP_ILO is not set
> > > > # CONFIG_APDS9802ALS is not set
> > > > # CONFIG_ISL29003 is not set
> > > > # CONFIG_ISL29020 is not set
> > > > # CONFIG_SENSORS_TSL2550 is not set
> > > > # CONFIG_SENSORS_BH1780 is not set
> > > > # CONFIG_SENSORS_BH1770 is not set
> > > > # CONFIG_SENSORS_APDS990X is not set
> > > > # CONFIG_HMC6352 is not set
> > > > # CONFIG_DS1682 is not set
> > > > # CONFIG_VMWARE_BALLOON is not set
> > > > # CONFIG_BMP085_I2C is not set
> > > > # CONFIG_PCH_PHUB is not set
> > > > # CONFIG_USB_SWITCH_FSA9480 is not set
> > > > # CONFIG_C2PORT is not set
> > > > 
> > > > #
> > > > # EEPROM support
> > > > #
> > > > # CONFIG_EEPROM_AT24 is not set
> > > > # CONFIG_EEPROM_LEGACY is not set
> > > > # CONFIG_EEPROM_MAX6875 is not set
> > > > # CONFIG_EEPROM_93CX6 is not set
> > > > # CONFIG_CB710_CORE is not set
> > > > 
> > > > #
> > > > # Texas Instruments shared transport line discipline
> > > > #
> > > > # CONFIG_SENSORS_LIS3_I2C is not set
> > > > 
> > > > #
> > > > # Altera FPGA firmware download module
> > > > #
> > > > # CONFIG_ALTERA_STAPL is not set
> > > > # CONFIG_INTEL_MEI is not set
> > > > # CONFIG_VMWARE_VMCI is not set
> > > > CONFIG_HAVE_IDE=y
> > > > # CONFIG_IDE is not set
> > > > 
> > > > #
> > > > # SCSI device support
> > > > #
> > > > CONFIG_SCSI_MOD=y
> > > > CONFIG_RAID_ATTRS=y
> > > > CONFIG_SCSI=y
> > > > CONFIG_SCSI_DMA=y
> > > > # CONFIG_SCSI_TGT is not set
> > > > CONFIG_SCSI_NETLINK=y
> > > > CONFIG_SCSI_PROC_FS=y
> > > > 
> > > > #
> > > > # SCSI support type (disk, tape, CD-ROM)
> > > > #
> > > > CONFIG_BLK_DEV_SD=y
> > > > # CONFIG_CHR_DEV_ST is not set
> > > > # CONFIG_CHR_DEV_OSST is not set
> > > > # CONFIG_BLK_DEV_SR is not set
> > > > CONFIG_CHR_DEV_SG=y
> > > > # CONFIG_CHR_DEV_SCH is not set
> > > > CONFIG_SCSI_MULTI_LUN=y
> > > > CONFIG_SCSI_CONSTANTS=y
> > > > CONFIG_SCSI_LOGGING=y
> > > > CONFIG_SCSI_SCAN_ASYNC=y
> > > > 
> > > > #
> > > > # SCSI Transports
> > > > #
> > > > CONFIG_SCSI_SPI_ATTRS=y
> > > > CONFIG_SCSI_FC_ATTRS=y
> > > > CONFIG_SCSI_ISCSI_ATTRS=y
> > > > CONFIG_SCSI_SAS_ATTRS=y
> > > > CONFIG_SCSI_SAS_LIBSAS=y
> > > > # CONFIG_SCSI_SAS_ATA is not set
> > > > CONFIG_SCSI_SAS_HOST_SMP=y
> > > > # CONFIG_SCSI_SRP_ATTRS is not set
> > > > CONFIG_SCSI_LOWLEVEL=y
> > > > # CONFIG_ISCSI_TCP is not set
> > > > # CONFIG_ISCSI_BOOT_SYSFS is not set
> > > > # CONFIG_SCSI_CXGB3_ISCSI is not set
> > > > # CONFIG_SCSI_CXGB4_ISCSI is not set
> > > > # CONFIG_SCSI_BNX2_ISCSI is not set
> > > > # CONFIG_SCSI_BNX2X_FCOE is not set
> > > > # CONFIG_BE2ISCSI is not set
> > > > # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> > > > # CONFIG_SCSI_HPSA is not set
> > > > # CONFIG_SCSI_3W_9XXX is not set
> > > > # CONFIG_SCSI_3W_SAS is not set
> > > > CONFIG_SCSI_ACARD=y
> > > > CONFIG_SCSI_AACRAID=y
> > > > CONFIG_SCSI_AIC7XXX=y
> > > > CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
> > > > CONFIG_AIC7XXX_RESET_DELAY_MS=15000
> > > > CONFIG_AIC7XXX_DEBUG_ENABLE=y
> > > > CONFIG_AIC7XXX_DEBUG_MASK=0
> > > > # CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
> > > > CONFIG_SCSI_AIC7XXX_OLD=y
> > > > CONFIG_SCSI_AIC79XX=y
> > > > CONFIG_AIC79XX_CMDS_PER_DEVICE=4
> > > > CONFIG_AIC79XX_RESET_DELAY_MS=15000
> > > > CONFIG_AIC79XX_DEBUG_ENABLE=y
> > > > CONFIG_AIC79XX_DEBUG_MASK=0
> > > > # CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
> > > > CONFIG_SCSI_AIC94XX=y
> > > > # CONFIG_AIC94XX_DEBUG is not set
> > > > # CONFIG_SCSI_MVSAS is not set
> > > > # CONFIG_SCSI_MVUMI is not set
> > > > # CONFIG_SCSI_DPT_I2O is not set
> > > > # CONFIG_SCSI_ADVANSYS is not set
> > > > # CONFIG_SCSI_ARCMSR is not set
> > > > CONFIG_MEGARAID_NEWGEN=y
> > > > CONFIG_MEGARAID_MM=y
> > > > CONFIG_MEGARAID_MAILBOX=y
> > > > CONFIG_MEGARAID_LEGACY=y
> > > > CONFIG_MEGARAID_SAS=y
> > > > CONFIG_SCSI_MPT2SAS=m
> > > > CONFIG_SCSI_MPT2SAS_MAX_SGE=128
> > > > # CONFIG_SCSI_MPT2SAS_LOGGING is not set
> > > > CONFIG_SCSI_MPT3SAS=m
> > > > CONFIG_SCSI_MPT3SAS_MAX_SGE=128
> > > > # CONFIG_SCSI_MPT3SAS_LOGGING is not set
> > > > # CONFIG_SCSI_UFSHCD is not set
> > > > CONFIG_SCSI_HPTIOP=y
> > > > CONFIG_SCSI_BUSLOGIC=y
> > > > # CONFIG_VMWARE_PVSCSI is not set
> > > > # CONFIG_LIBFC is not set
> > > > # CONFIG_LIBFCOE is not set
> > > > # CONFIG_FCOE is not set
> > > > # CONFIG_FCOE_FNIC is not set
> > > > # CONFIG_SCSI_DMX3191D is not set
> > > > # CONFIG_SCSI_EATA is not set
> > > > # CONFIG_SCSI_FUTURE_DOMAIN is not set
> > > > CONFIG_SCSI_GDTH=y
> > > > CONFIG_SCSI_ISCI=m
> > > > # CONFIG_SCSI_IPS is not set
> > > > # CONFIG_SCSI_INITIO is not set
> > > > # CONFIG_SCSI_INIA100 is not set
> > > > # CONFIG_SCSI_STEX is not set
> > > > # CONFIG_SCSI_SYM53C8XX_2 is not set
> > > > # CONFIG_SCSI_IPR is not set
> > > > CONFIG_SCSI_QLOGIC_1280=y
> > > > CONFIG_SCSI_QLA_FC=y
> > > > # CONFIG_SCSI_QLA_ISCSI is not set
> > > > # CONFIG_SCSI_LPFC is not set
> > > > # CONFIG_SCSI_DC395x is not set
> > > > # CONFIG_SCSI_DC390T is not set
> > > > # CONFIG_SCSI_DEBUG is not set
> > > > # CONFIG_SCSI_PMCRAID is not set
> > > > # CONFIG_SCSI_PM8001 is not set
> > > > # CONFIG_SCSI_SRP is not set
> > > > # CONFIG_SCSI_BFA_FC is not set
> > > > CONFIG_SCSI_VIRTIO=y
> > > > # CONFIG_SCSI_CHELSIO_FCOE is not set
> > > > # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> > > > # CONFIG_SCSI_DH is not set
> > > > # CONFIG_SCSI_OSD_INITIATOR is not set
> > > > CONFIG_ATA=y
> > > > # CONFIG_ATA_NONSTANDARD is not set
> > > > CONFIG_ATA_VERBOSE_ERROR=y
> > > > CONFIG_ATA_ACPI=y
> > > > # CONFIG_SATA_ZPODD is not set
> > > > CONFIG_SATA_PMP=y
> > > > 
> > > > #
> > > > # Controllers with non-SFF native interface
> > > > #
> > > > CONFIG_SATA_AHCI=y
> > > > # CONFIG_SATA_AHCI_PLATFORM is not set
> > > > # CONFIG_SATA_INIC162X is not set
> > > > # CONFIG_SATA_ACARD_AHCI is not set
> > > > # CONFIG_SATA_SIL24 is not set
> > > > CONFIG_ATA_SFF=y
> > > > 
> > > > #
> > > > # SFF controllers with custom DMA interface
> > > > #
> > > > # CONFIG_PDC_ADMA is not set
> > > > # CONFIG_SATA_QSTOR is not set
> > > > # CONFIG_SATA_SX4 is not set
> > > > CONFIG_ATA_BMDMA=y
> > > > 
> > > > #
> > > > # SATA SFF controllers with BMDMA
> > > > #
> > > > CONFIG_ATA_PIIX=y
> > > > # CONFIG_SATA_HIGHBANK is not set
> > > > # CONFIG_SATA_MV is not set
> > > > # CONFIG_SATA_NV is not set
> > > > # CONFIG_SATA_PROMISE is not set
> > > > # CONFIG_SATA_SIL is not set
> > > > # CONFIG_SATA_SIS is not set
> > > > # CONFIG_SATA_SVW is not set
> > > > # CONFIG_SATA_ULI is not set
> > > > # CONFIG_SATA_VIA is not set
> > > > # CONFIG_SATA_VITESSE is not set
> > > > 
> > > > #
> > > > # PATA SFF controllers with BMDMA
> > > > #
> > > > # CONFIG_PATA_ALI is not set
> > > > # CONFIG_PATA_AMD is not set
> > > > # CONFIG_PATA_ARTOP is not set
> > > > # CONFIG_PATA_ATIIXP is not set
> > > > # CONFIG_PATA_ATP867X is not set
> > > > # CONFIG_PATA_CMD64X is not set
> > > > # CONFIG_PATA_CS5520 is not set
> > > > # CONFIG_PATA_CS5530 is not set
> > > > # CONFIG_PATA_CS5536 is not set
> > > > # CONFIG_PATA_CYPRESS is not set
> > > > # CONFIG_PATA_EFAR is not set
> > > > # CONFIG_PATA_HPT366 is not set
> > > > # CONFIG_PATA_HPT37X is not set
> > > > # CONFIG_PATA_HPT3X2N is not set
> > > > # CONFIG_PATA_HPT3X3 is not set
> > > > # CONFIG_PATA_IT8213 is not set
> > > > # CONFIG_PATA_IT821X is not set
> > > > # CONFIG_PATA_JMICRON is not set
> > > > # CONFIG_PATA_MARVELL is not set
> > > > # CONFIG_PATA_NETCELL is not set
> > > > # CONFIG_PATA_NINJA32 is not set
> > > > # CONFIG_PATA_NS87415 is not set
> > > > # CONFIG_PATA_OLDPIIX is not set
> > > > # CONFIG_PATA_OPTIDMA is not set
> > > > # CONFIG_PATA_PDC2027X is not set
> > > > # CONFIG_PATA_PDC_OLD is not set
> > > > # CONFIG_PATA_RADISYS is not set
> > > > # CONFIG_PATA_RDC is not set
> > > > # CONFIG_PATA_SC1200 is not set
> > > > # CONFIG_PATA_SCH is not set
> > > > # CONFIG_PATA_SERVERWORKS is not set
> > > > # CONFIG_PATA_SIL680 is not set
> > > > # CONFIG_PATA_SIS is not set
> > > > # CONFIG_PATA_TOSHIBA is not set
> > > > # CONFIG_PATA_TRIFLEX is not set
> > > > # CONFIG_PATA_VIA is not set
> > > > # CONFIG_PATA_WINBOND is not set
> > > > 
> > > > #
> > > > # PIO-only SFF controllers
> > > > #
> > > > # CONFIG_PATA_CMD640_PCI is not set
> > > > # CONFIG_PATA_MPIIX is not set
> > > > # CONFIG_PATA_NS87410 is not set
> > > > # CONFIG_PATA_OPTI is not set
> > > > # CONFIG_PATA_PCMCIA is not set
> > > > # CONFIG_PATA_PLATFORM is not set
> > > > # CONFIG_PATA_RZ1000 is not set
> > > > 
> > > > #
> > > > # Generic fallback / legacy drivers
> > > > #
> > > > # CONFIG_PATA_ACPI is not set
> > > > # CONFIG_ATA_GENERIC is not set
> > > > # CONFIG_PATA_LEGACY is not set
> > > > CONFIG_MD=y
> > > > CONFIG_BLK_DEV_MD=y
> > > > # CONFIG_MD_AUTODETECT is not set
> > > > CONFIG_MD_LINEAR=y
> > > > CONFIG_MD_RAID0=y
> > > > CONFIG_MD_RAID1=y
> > > > CONFIG_MD_RAID10=y
> > > > CONFIG_MD_RAID456=y
> > > > CONFIG_MD_MULTIPATH=y
> > > > CONFIG_MD_FAULTY=y
> > > > CONFIG_BLK_DEV_DM=y
> > > > # CONFIG_DM_DEBUG is not set
> > > > CONFIG_DM_BUFIO=y
> > > > CONFIG_DM_BIO_PRISON=y
> > > > CONFIG_DM_PERSISTENT_DATA=y
> > > > CONFIG_DM_CRYPT=y
> > > > CONFIG_DM_SNAPSHOT=y
> > > > # CONFIG_DM_THIN_PROVISIONING is not set
> > > > CONFIG_DM_CACHE=y
> > > > CONFIG_DM_CACHE_MQ=y
> > > > CONFIG_DM_CACHE_CLEANER=y
> > > > CONFIG_DM_MIRROR=y
> > > > # CONFIG_DM_RAID is not set
> > > > # CONFIG_DM_LOG_USERSPACE is not set
> > > > CONFIG_DM_ZERO=y
> > > > CONFIG_DM_MULTIPATH=y
> > > > # CONFIG_DM_MULTIPATH_QL is not set
> > > > # CONFIG_DM_MULTIPATH_ST is not set
> > > > CONFIG_DM_DELAY=y
> > > > # CONFIG_DM_UEVENT is not set
> > > > CONFIG_DM_FLAKEY=y
> > > > # CONFIG_DM_VERITY is not set
> > > > # CONFIG_TARGET_CORE is not set
> > > > CONFIG_FUSION=y
> > > > CONFIG_FUSION_SPI=y
> > > > CONFIG_FUSION_FC=y
> > > > CONFIG_FUSION_SAS=y
> > > > CONFIG_FUSION_MAX_SGE=40
> > > > CONFIG_FUSION_CTL=y
> > > > # CONFIG_FUSION_LOGGING is not set
> > > > 
> > > > #
> > > > # IEEE 1394 (FireWire) support
> > > > #
> > > > # CONFIG_FIREWIRE is not set
> > > > # CONFIG_FIREWIRE_NOSY is not set
> > > > # CONFIG_I2O is not set
> > > > # CONFIG_MACINTOSH_DRIVERS is not set
> > > > CONFIG_NETDEVICES=y
> > > > CONFIG_NET_CORE=y
> > > > # CONFIG_BONDING is not set
> > > > # CONFIG_DUMMY is not set
> > > > # CONFIG_EQUALIZER is not set
> > > > # CONFIG_NET_FC is not set
> > > > CONFIG_MII=y
> > > > # CONFIG_NET_TEAM is not set
> > > > # CONFIG_MACVLAN is not set
> > > > # CONFIG_VXLAN is not set
> > > > # CONFIG_NETCONSOLE is not set
> > > > # CONFIG_NETPOLL is not set
> > > > # CONFIG_NET_POLL_CONTROLLER is not set
> > > > CONFIG_TUN=y
> > > > # CONFIG_VETH is not set
> > > > CONFIG_VIRTIO_NET=y
> > > > # CONFIG_ARCNET is not set
> > > > 
> > > > #
> > > > # CAIF transport drivers
> > > > #
> > > > 
> > > > #
> > > > # Distributed Switch Architecture drivers
> > > > #
> > > > # CONFIG_NET_DSA_MV88E6XXX is not set
> > > > # CONFIG_NET_DSA_MV88E6060 is not set
> > > > # CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
> > > > # CONFIG_NET_DSA_MV88E6131 is not set
> > > > # CONFIG_NET_DSA_MV88E6123_61_65 is not set
> > > > CONFIG_ETHERNET=y
> > > > CONFIG_MDIO=y
> > > > # CONFIG_NET_VENDOR_3COM is not set
> > > > CONFIG_NET_VENDOR_ADAPTEC=y
> > > > # CONFIG_ADAPTEC_STARFIRE is not set
> > > > CONFIG_NET_VENDOR_ALTEON=y
> > > > CONFIG_ACENIC=y
> > > > # CONFIG_ACENIC_OMIT_TIGON_I is not set
> > > > CONFIG_NET_VENDOR_AMD=y
> > > > CONFIG_AMD8111_ETH=y
> > > > CONFIG_PCNET32=y
> > > > # CONFIG_PCMCIA_NMCLAN is not set
> > > > CONFIG_NET_VENDOR_ATHEROS=y
> > > > CONFIG_ATL2=y
> > > > CONFIG_ATL1=y
> > > > CONFIG_ATL1E=y
> > > > CONFIG_ATL1C=y
> > > > CONFIG_NET_CADENCE=y
> > > > # CONFIG_ARM_AT91_ETHER is not set
> > > > # CONFIG_MACB is not set
> > > > CONFIG_NET_VENDOR_BROADCOM=y
> > > > # CONFIG_B44 is not set
> > > > CONFIG_BNX2=y
> > > > # CONFIG_CNIC is not set
> > > > CONFIG_TIGON3=y
> > > > # CONFIG_BNX2X is not set
> > > > CONFIG_NET_VENDOR_BROCADE=y
> > > > # CONFIG_BNA is not set
> > > > # CONFIG_NET_CALXEDA_XGMAC is not set
> > > > CONFIG_NET_VENDOR_CHELSIO=y
> > > > # CONFIG_CHELSIO_T1 is not set
> > > > # CONFIG_CHELSIO_T3 is not set
> > > > # CONFIG_CHELSIO_T4 is not set
> > > > # CONFIG_CHELSIO_T4VF is not set
> > > > CONFIG_NET_VENDOR_CISCO=y
> > > > # CONFIG_ENIC is not set
> > > > # CONFIG_DNET is not set
> > > > CONFIG_NET_VENDOR_DEC=y
> > > > CONFIG_NET_TULIP=y
> > > > # CONFIG_DE2104X is not set
> > > > CONFIG_TULIP=y
> > > > # CONFIG_TULIP_MWI is not set
> > > > # CONFIG_TULIP_MMIO is not set
> > > > # CONFIG_TULIP_NAPI is not set
> > > > CONFIG_DE4X5=y
> > > > CONFIG_WINBOND_840=y
> > > > CONFIG_DM9102=y
> > > > CONFIG_ULI526X=y
> > > > # CONFIG_PCMCIA_XIRCOM is not set
> > > > CONFIG_NET_VENDOR_DLINK=y
> > > > CONFIG_DL2K=y
> > > > # CONFIG_SUNDANCE is not set
> > > > CONFIG_NET_VENDOR_EMULEX=y
> > > > # CONFIG_BE2NET is not set
> > > > CONFIG_NET_VENDOR_EXAR=y
> > > > # CONFIG_S2IO is not set
> > > > # CONFIG_VXGE is not set
> > > > CONFIG_NET_VENDOR_FUJITSU=y
> > > > # CONFIG_PCMCIA_FMVJ18X is not set
> > > > CONFIG_NET_VENDOR_HP=y
> > > > # CONFIG_HP100 is not set
> > > > CONFIG_NET_VENDOR_INTEL=y
> > > > CONFIG_E100=y
> > > > CONFIG_E1000=y
> > > > CONFIG_E1000E=y
> > > > CONFIG_IGB=y
> > > > CONFIG_IGB_HWMON=y
> > > > # CONFIG_IGBVF is not set
> > > > CONFIG_IXGB=y
> > > > CONFIG_IXGBE=y
> > > > CONFIG_IXGBE_HWMON=y
> > > > # CONFIG_IXGBEVF is not set
> > > > CONFIG_NET_VENDOR_I825XX=y
> > > > # CONFIG_IP1000 is not set
> > > > # CONFIG_JME is not set
> > > > CONFIG_NET_VENDOR_MARVELL=y
> > > > # CONFIG_MVMDIO is not set
> > > > CONFIG_SKGE=y
> > > > # CONFIG_SKGE_DEBUG is not set
> > > > # CONFIG_SKGE_GENESIS is not set
> > > > CONFIG_SKY2=y
> > > > # CONFIG_SKY2_DEBUG is not set
> > > > CONFIG_NET_VENDOR_MELLANOX=y
> > > > # CONFIG_MLX4_EN is not set
> > > > # CONFIG_MLX4_CORE is not set
> > > > CONFIG_NET_VENDOR_MICREL=y
> > > > # CONFIG_KS8851_MLL is not set
> > > > # CONFIG_KSZ884X_PCI is not set
> > > > CONFIG_NET_VENDOR_MYRI=y
> > > > # CONFIG_MYRI10GE is not set
> > > > # CONFIG_FEALNX is not set
> > > > CONFIG_NET_VENDOR_NATSEMI=y
> > > > # CONFIG_NATSEMI is not set
> > > > # CONFIG_NS83820 is not set
> > > > CONFIG_NET_VENDOR_8390=y
> > > > # CONFIG_PCMCIA_AXNET is not set
> > > > CONFIG_NE2K_PCI=y
> > > > # CONFIG_PCMCIA_PCNET is not set
> > > > CONFIG_NET_VENDOR_NVIDIA=y
> > > > CONFIG_FORCEDETH=y
> > > > CONFIG_NET_VENDOR_OKI=y
> > > > # CONFIG_PCH_GBE is not set
> > > > # CONFIG_ETHOC is not set
> > > > # CONFIG_NET_PACKET_ENGINE is not set
> > > > CONFIG_NET_VENDOR_QLOGIC=y
> > > > # CONFIG_QLA3XXX is not set
> > > > # CONFIG_QLCNIC is not set
> > > > # CONFIG_QLGE is not set
> > > > # CONFIG_NETXEN_NIC is not set
> > > > CONFIG_NET_VENDOR_REALTEK=y
> > > > CONFIG_8139CP=y
> > > > CONFIG_8139TOO=y
> > > > CONFIG_8139TOO_PIO=y
> > > > # CONFIG_8139TOO_TUNE_TWISTER is not set
> > > > # CONFIG_8139TOO_8129 is not set
> > > > # CONFIG_8139_OLD_RX_RESET is not set
> > > > CONFIG_R8169=y
> > > > CONFIG_NET_VENDOR_RDC=y
> > > > # CONFIG_R6040 is not set
> > > > CONFIG_NET_VENDOR_SEEQ=y
> > > > CONFIG_NET_VENDOR_SILAN=y
> > > > # CONFIG_SC92031 is not set
> > > > CONFIG_NET_VENDOR_SIS=y
> > > > CONFIG_SIS900=y
> > > > # CONFIG_SIS190 is not set
> > > > # CONFIG_SFC is not set
> > > > CONFIG_NET_VENDOR_SMSC=y
> > > > # CONFIG_PCMCIA_SMC91C92 is not set
> > > > # CONFIG_EPIC100 is not set
> > > > # CONFIG_SMSC9420 is not set
> > > > CONFIG_NET_VENDOR_STMICRO=y
> > > > # CONFIG_STMMAC_ETH is not set
> > > > CONFIG_NET_VENDOR_SUN=y
> > > > # CONFIG_HAPPYMEAL is not set
> > > > # CONFIG_SUNGEM is not set
> > > > # CONFIG_CASSINI is not set
> > > > # CONFIG_NIU is not set
> > > > CONFIG_NET_VENDOR_TEHUTI=y
> > > > # CONFIG_TEHUTI is not set
> > > > CONFIG_NET_VENDOR_TI=y
> > > > # CONFIG_TLAN is not set
> > > > CONFIG_NET_VENDOR_VIA=y
> > > > CONFIG_VIA_RHINE=y
> > > > # CONFIG_VIA_RHINE_MMIO is not set
> > > > CONFIG_VIA_VELOCITY=y
> > > > CONFIG_NET_VENDOR_WIZNET=y
> > > > # CONFIG_WIZNET_W5100 is not set
> > > > # CONFIG_WIZNET_W5300 is not set
> > > > CONFIG_NET_VENDOR_XIRCOM=y
> > > > # CONFIG_PCMCIA_XIRC2PS is not set
> > > > # CONFIG_FDDI is not set
> > > > # CONFIG_HIPPI is not set
> > > > # CONFIG_NET_SB1000 is not set
> > > > CONFIG_PHYLIB=y
> > > > 
> > > > #
> > > > # MII PHY device drivers
> > > > #
> > > > # CONFIG_AT803X_PHY is not set
> > > > # CONFIG_AMD_PHY is not set
> > > > # CONFIG_MARVELL_PHY is not set
> > > > # CONFIG_DAVICOM_PHY is not set
> > > > # CONFIG_QSEMI_PHY is not set
> > > > # CONFIG_LXT_PHY is not set
> > > > # CONFIG_CICADA_PHY is not set
> > > > # CONFIG_VITESSE_PHY is not set
> > > > # CONFIG_SMSC_PHY is not set
> > > > CONFIG_BROADCOM_PHY=y
> > > > # CONFIG_BCM87XX_PHY is not set
> > > > # CONFIG_ICPLUS_PHY is not set
> > > > # CONFIG_REALTEK_PHY is not set
> > > > # CONFIG_NATIONAL_PHY is not set
> > > > # CONFIG_STE10XP is not set
> > > > # CONFIG_LSI_ET1011C_PHY is not set
> > > > # CONFIG_MICREL_PHY is not set
> > > > # CONFIG_FIXED_PHY is not set
> > > > # CONFIG_MDIO_BITBANG is not set
> > > > # CONFIG_PPP is not set
> > > > # CONFIG_SLIP is not set
> > > > 
> > > > #
> > > > # USB Network Adapters
> > > > #
> > > > CONFIG_USB_CATC=y
> > > > CONFIG_USB_KAWETH=y
> > > > CONFIG_USB_PEGASUS=y
> > > > CONFIG_USB_RTL8150=y
> > > > CONFIG_USB_USBNET=y
> > > > CONFIG_USB_NET_AX8817X=y
> > > > CONFIG_USB_NET_AX88179_178A=y
> > > > CONFIG_USB_NET_CDCETHER=y
> > > > CONFIG_USB_NET_CDC_EEM=y
> > > > CONFIG_USB_NET_CDC_NCM=y
> > > > # CONFIG_USB_NET_CDC_MBIM is not set
> > > > CONFIG_USB_NET_DM9601=y
> > > > CONFIG_USB_NET_SMSC75XX=y
> > > > CONFIG_USB_NET_SMSC95XX=y
> > > > CONFIG_USB_NET_GL620A=y
> > > > CONFIG_USB_NET_NET1080=y
> > > > CONFIG_USB_NET_PLUSB=y
> > > > CONFIG_USB_NET_MCS7830=y
> > > > CONFIG_USB_NET_RNDIS_HOST=y
> > > > CONFIG_USB_NET_CDC_SUBSET=y
> > > > CONFIG_USB_ALI_M5632=y
> > > > CONFIG_USB_AN2720=y
> > > > CONFIG_USB_BELKIN=y
> > > > CONFIG_USB_ARMLINUX=y
> > > > CONFIG_USB_EPSON2888=y
> > > > CONFIG_USB_KC2190=y
> > > > CONFIG_USB_NET_ZAURUS=y
> > > > # CONFIG_USB_NET_CX82310_ETH is not set
> > > > # CONFIG_USB_NET_KALMIA is not set
> > > > # CONFIG_USB_NET_QMI_WWAN is not set
> > > > CONFIG_USB_NET_INT51X1=y
> > > > CONFIG_USB_IPHETH=y
> > > > CONFIG_USB_SIERRA_NET=y
> > > > # CONFIG_USB_VL600 is not set
> > > > CONFIG_WLAN=y
> > > > # CONFIG_PCMCIA_RAYCS is not set
> > > > # CONFIG_AIRO is not set
> > > > # CONFIG_ATMEL is not set
> > > > # CONFIG_AIRO_CS is not set
> > > > # CONFIG_PCMCIA_WL3501 is not set
> > > > # CONFIG_PRISM54 is not set
> > > > # CONFIG_USB_ZD1201 is not set
> > > > # CONFIG_HOSTAP is not set
> > > > # CONFIG_WL_TI is not set
> > > > 
> > > > #
> > > > # Enable WiMAX (Networking options) to see the WiMAX drivers
> > > > #
> > > > # CONFIG_WAN is not set
> > > > # CONFIG_VMXNET3 is not set
> > > > # CONFIG_ISDN is not set
> > > > 
> > > > #
> > > > # Input device support
> > > > #
> > > > CONFIG_INPUT=y
> > > > CONFIG_INPUT_FF_MEMLESS=y
> > > > # CONFIG_INPUT_POLLDEV is not set
> > > > # CONFIG_INPUT_SPARSEKMAP is not set
> > > > # CONFIG_INPUT_MATRIXKMAP is not set
> > > > 
> > > > #
> > > > # Userland interfaces
> > > > #
> > > > CONFIG_INPUT_MOUSEDEV=y
> > > > # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> > > > CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> > > > CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> > > > # CONFIG_INPUT_JOYDEV is not set
> > > > CONFIG_INPUT_EVDEV=y
> > > > # CONFIG_INPUT_EVBUG is not set
> > > > 
> > > > #
> > > > # Input Device Drivers
> > > > #
> > > > CONFIG_INPUT_KEYBOARD=y
> > > > # CONFIG_KEYBOARD_ADP5588 is not set
> > > > # CONFIG_KEYBOARD_ADP5589 is not set
> > > > CONFIG_KEYBOARD_ATKBD=y
> > > > # CONFIG_KEYBOARD_QT1070 is not set
> > > > # CONFIG_KEYBOARD_QT2160 is not set
> > > > # CONFIG_KEYBOARD_LKKBD is not set
> > > > # CONFIG_KEYBOARD_TCA6416 is not set
> > > > # CONFIG_KEYBOARD_TCA8418 is not set
> > > > # CONFIG_KEYBOARD_LM8333 is not set
> > > > # CONFIG_KEYBOARD_MAX7359 is not set
> > > > # CONFIG_KEYBOARD_MCS is not set
> > > > # CONFIG_KEYBOARD_MPR121 is not set
> > > > # CONFIG_KEYBOARD_NEWTON is not set
> > > > # CONFIG_KEYBOARD_OPENCORES is not set
> > > > # CONFIG_KEYBOARD_STOWAWAY is not set
> > > > # CONFIG_KEYBOARD_SUNKBD is not set
> > > > # CONFIG_KEYBOARD_XTKBD is not set
> > > > CONFIG_INPUT_MOUSE=y
> > > > CONFIG_MOUSE_PS2=y
> > > > CONFIG_MOUSE_PS2_ALPS=y
> > > > CONFIG_MOUSE_PS2_LOGIPS2PP=y
> > > > CONFIG_MOUSE_PS2_SYNAPTICS=y
> > > > CONFIG_MOUSE_PS2_CYPRESS=y
> > > > CONFIG_MOUSE_PS2_LIFEBOOK=y
> > > > CONFIG_MOUSE_PS2_TRACKPOINT=y
> > > > # CONFIG_MOUSE_PS2_ELANTECH is not set
> > > > # CONFIG_MOUSE_PS2_SENTELIC is not set
> > > > # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> > > > CONFIG_MOUSE_SERIAL=y
> > > > # CONFIG_MOUSE_APPLETOUCH is not set
> > > > # CONFIG_MOUSE_BCM5974 is not set
> > > > # CONFIG_MOUSE_CYAPA is not set
> > > > # CONFIG_MOUSE_VSXXXAA is not set
> > > > # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> > > > # CONFIG_MOUSE_SYNAPTICS_USB is not set
> > > > # CONFIG_INPUT_JOYSTICK is not set
> > > > # CONFIG_INPUT_TABLET is not set
> > > > # CONFIG_INPUT_TOUCHSCREEN is not set
> > > > CONFIG_INPUT_MISC=y
> > > > # CONFIG_INPUT_AD714X is not set
> > > > # CONFIG_INPUT_BMA150 is not set
> > > > # CONFIG_INPUT_PCSPKR is not set
> > > > # CONFIG_INPUT_MMA8450 is not set
> > > > # CONFIG_INPUT_MPU3050 is not set
> > > > # CONFIG_INPUT_ATLAS_BTNS is not set
> > > > # CONFIG_INPUT_ATI_REMOTE2 is not set
> > > > # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> > > > # CONFIG_INPUT_KXTJ9 is not set
> > > > # CONFIG_INPUT_POWERMATE is not set
> > > > # CONFIG_INPUT_YEALINK is not set
> > > > # CONFIG_INPUT_CM109 is not set
> > > > # CONFIG_INPUT_UINPUT is not set
> > > > # CONFIG_INPUT_PCF8574 is not set
> > > > # CONFIG_INPUT_ADXL34X is not set
> > > > # CONFIG_INPUT_CMA3000 is not set
> > > > 
> > > > #
> > > > # Hardware I/O ports
> > > > #
> > > > CONFIG_SERIO=y
> > > > CONFIG_SERIO_I8042=y
> > > > CONFIG_SERIO_SERPORT=y
> > > > # CONFIG_SERIO_CT82C710 is not set
> > > > # CONFIG_SERIO_PCIPS2 is not set
> > > > CONFIG_SERIO_LIBPS2=y
> > > > # CONFIG_SERIO_RAW is not set
> > > > # CONFIG_SERIO_ALTERA_PS2 is not set
> > > > # CONFIG_SERIO_PS2MULT is not set
> > > > # CONFIG_SERIO_ARC_PS2 is not set
> > > > # CONFIG_GAMEPORT is not set
> > > > 
> > > > #
> > > > # Character devices
> > > > #
> > > > CONFIG_TTY=y
> > > > CONFIG_VT=y
> > > > CONFIG_CONSOLE_TRANSLATIONS=y
> > > > CONFIG_VT_CONSOLE=y
> > > > CONFIG_VT_CONSOLE_SLEEP=y
> > > > CONFIG_HW_CONSOLE=y
> > > > CONFIG_VT_HW_CONSOLE_BINDING=y
> > > > CONFIG_UNIX98_PTYS=y
> > > > # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> > > > # CONFIG_LEGACY_PTYS is not set
> > > > CONFIG_SERIAL_NONSTANDARD=y
> > > > # CONFIG_ROCKETPORT is not set
> > > > # CONFIG_CYCLADES is not set
> > > > # CONFIG_MOXA_INTELLIO is not set
> > > > # CONFIG_MOXA_SMARTIO is not set
> > > > # CONFIG_SYNCLINK is not set
> > > > # CONFIG_SYNCLINKMP is not set
> > > > # CONFIG_SYNCLINK_GT is not set
> > > > # CONFIG_NOZOMI is not set
> > > > # CONFIG_ISI is not set
> > > > # CONFIG_N_HDLC is not set
> > > > # CONFIG_N_GSM is not set
> > > > # CONFIG_TRACE_SINK is not set
> > > > CONFIG_DEVKMEM=y
> > > > # CONFIG_STALDRV is not set
> > > > 
> > > > #
> > > > # Serial drivers
> > > > #
> > > > CONFIG_SERIAL_8250=y
> > > > CONFIG_SERIAL_8250_PNP=y
> > > > CONFIG_SERIAL_8250_CONSOLE=y
> > > > CONFIG_FIX_EARLYCON_MEM=y
> > > > CONFIG_SERIAL_8250_PCI=y
> > > > # CONFIG_SERIAL_8250_CS is not set
> > > > CONFIG_SERIAL_8250_NR_UARTS=32
> > > > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> > > > CONFIG_SERIAL_8250_EXTENDED=y
> > > > CONFIG_SERIAL_8250_MANY_PORTS=y
> > > > CONFIG_SERIAL_8250_SHARE_IRQ=y
> > > > CONFIG_SERIAL_8250_DETECT_IRQ=y
> > > > CONFIG_SERIAL_8250_RSA=y
> > > > # CONFIG_SERIAL_8250_DW is not set
> > > > 
> > > > #
> > > > # Non-8250 serial port support
> > > > #
> > > > # CONFIG_SERIAL_MFD_HSU is not set
> > > > CONFIG_SERIAL_CORE=y
> > > > CONFIG_SERIAL_CORE_CONSOLE=y
> > > > # CONFIG_SERIAL_JSM is not set
> > > > # CONFIG_SERIAL_SCCNXP is not set
> > > > # CONFIG_SERIAL_TIMBERDALE is not set
> > > > # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> > > > # CONFIG_SERIAL_ALTERA_UART is not set
> > > > # CONFIG_SERIAL_PCH_UART is not set
> > > > # CONFIG_SERIAL_ARC is not set
> > > > # CONFIG_SERIAL_RP2 is not set
> > > > # CONFIG_TTY_PRINTK is not set
> > > > CONFIG_HVC_DRIVER=y
> > > > CONFIG_VIRTIO_CONSOLE=y
> > > > CONFIG_IPMI_HANDLER=m
> > > > # CONFIG_IPMI_PANIC_EVENT is not set
> > > > CONFIG_IPMI_DEVICE_INTERFACE=m
> > > > CONFIG_IPMI_SI=m
> > > > CONFIG_IPMI_WATCHDOG=m
> > > > CONFIG_IPMI_POWEROFF=m
> > > > CONFIG_HW_RANDOM=y
> > > > # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> > > > CONFIG_HW_RANDOM_INTEL=y
> > > > CONFIG_HW_RANDOM_AMD=y
> > > > CONFIG_HW_RANDOM_VIA=y
> > > > CONFIG_HW_RANDOM_VIRTIO=y
> > > > CONFIG_NVRAM=y
> > > > # CONFIG_R3964 is not set
> > > > # CONFIG_APPLICOM is not set
> > > > 
> > > > #
> > > > # PCMCIA character devices
> > > > #
> > > > # CONFIG_SYNCLINK_CS is not set
> > > > # CONFIG_CARDMAN_4000 is not set
> > > > # CONFIG_CARDMAN_4040 is not set
> > > > # CONFIG_IPWIRELESS is not set
> > > > # CONFIG_MWAVE is not set
> > > > # CONFIG_RAW_DRIVER is not set
> > > > CONFIG_HPET=y
> > > > # CONFIG_HPET_MMAP is not set
> > > > # CONFIG_HANGCHECK_TIMER is not set
> > > > # CONFIG_TCG_TPM is not set
> > > > # CONFIG_TELCLOCK is not set
> > > > CONFIG_DEVPORT=y
> > > > CONFIG_I2C=y
> > > > CONFIG_I2C_BOARDINFO=y
> > > > CONFIG_I2C_COMPAT=y
> > > > # CONFIG_I2C_CHARDEV is not set
> > > > # CONFIG_I2C_MUX is not set
> > > > CONFIG_I2C_HELPER_AUTO=y
> > > > CONFIG_I2C_ALGOBIT=y
> > > > 
> > > > #
> > > > # I2C Hardware Bus support
> > > > #
> > > > 
> > > > #
> > > > # PC SMBus host controller drivers
> > > > #
> > > > # CONFIG_I2C_ALI1535 is not set
> > > > # CONFIG_I2C_ALI1563 is not set
> > > > # CONFIG_I2C_ALI15X3 is not set
> > > > # CONFIG_I2C_AMD756 is not set
> > > > # CONFIG_I2C_AMD8111 is not set
> > > > # CONFIG_I2C_I801 is not set
> > > > # CONFIG_I2C_ISCH is not set
> > > > # CONFIG_I2C_ISMT is not set
> > > > # CONFIG_I2C_PIIX4 is not set
> > > > # CONFIG_I2C_NFORCE2 is not set
> > > > # CONFIG_I2C_SIS5595 is not set
> > > > # CONFIG_I2C_SIS630 is not set
> > > > # CONFIG_I2C_SIS96X is not set
> > > > # CONFIG_I2C_VIA is not set
> > > > # CONFIG_I2C_VIAPRO is not set
> > > > 
> > > > #
> > > > # ACPI drivers
> > > > #
> > > > # CONFIG_I2C_SCMI is not set
> > > > 
> > > > #
> > > > # I2C system bus drivers (mostly embedded / system-on-chip)
> > > > #
> > > > # CONFIG_I2C_DESIGNWARE_PCI is not set
> > > > # CONFIG_I2C_EG20T is not set
> > > > # CONFIG_I2C_INTEL_MID is not set
> > > > # CONFIG_I2C_OCORES is not set
> > > > # CONFIG_I2C_PCA_PLATFORM is not set
> > > > # CONFIG_I2C_PXA_PCI is not set
> > > > # CONFIG_I2C_SIMTEC is not set
> > > > # CONFIG_I2C_XILINX is not set
> > > > 
> > > > #
> > > > # External I2C/SMBus adapter drivers
> > > > #
> > > > # CONFIG_I2C_DIOLAN_U2C is not set
> > > > # CONFIG_I2C_PARPORT_LIGHT is not set
> > > > # CONFIG_I2C_TAOS_EVM is not set
> > > > # CONFIG_I2C_TINY_USB is not set
> > > > 
> > > > #
> > > > # Other I2C/SMBus bus drivers
> > > > #
> > > > # CONFIG_I2C_STUB is not set
> > > > # CONFIG_I2C_DEBUG_CORE is not set
> > > > # CONFIG_I2C_DEBUG_ALGO is not set
> > > > # CONFIG_I2C_DEBUG_BUS is not set
> > > > # CONFIG_SPI is not set
> > > > # CONFIG_HSI is not set
> > > > 
> > > > #
> > > > # PPS support
> > > > #
> > > > CONFIG_PPS=y
> > > > # CONFIG_PPS_DEBUG is not set
> > > > 
> > > > #
> > > > # PPS clients support
> > > > #
> > > > # CONFIG_PPS_CLIENT_KTIMER is not set
> > > > # CONFIG_PPS_CLIENT_LDISC is not set
> > > > # CONFIG_PPS_CLIENT_GPIO is not set
> > > > 
> > > > #
> > > > # PPS generators support
> > > > #
> > > > 
> > > > #
> > > > # PTP clock support
> > > > #
> > > > CONFIG_PTP_1588_CLOCK=y
> > > > 
> > > > #
> > > > # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> > > > #
> > > > # CONFIG_PTP_1588_CLOCK_PCH is not set
> > > > CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> > > > CONFIG_GPIO_DEVRES=y
> > > > # CONFIG_GPIOLIB is not set
> > > > # CONFIG_W1 is not set
> > > > CONFIG_POWER_SUPPLY=y
> > > > # CONFIG_POWER_SUPPLY_DEBUG is not set
> > > > # CONFIG_PDA_POWER is not set
> > > > # CONFIG_TEST_POWER is not set
> > > > # CONFIG_BATTERY_DS2780 is not set
> > > > # CONFIG_BATTERY_DS2781 is not set
> > > > # CONFIG_BATTERY_DS2782 is not set
> > > > # CONFIG_BATTERY_SBS is not set
> > > > # CONFIG_BATTERY_BQ27x00 is not set
> > > > # CONFIG_BATTERY_MAX17040 is not set
> > > > # CONFIG_BATTERY_MAX17042 is not set
> > > > # CONFIG_CHARGER_MAX8903 is not set
> > > > # CONFIG_CHARGER_LP8727 is not set
> > > > # CONFIG_CHARGER_BQ2415X is not set
> > > > # CONFIG_CHARGER_SMB347 is not set
> > > > # CONFIG_BATTERY_GOLDFISH is not set
> > > > # CONFIG_POWER_RESET is not set
> > > > # CONFIG_POWER_AVS is not set
> > > > CONFIG_HWMON=y
> > > > # CONFIG_HWMON_VID is not set
> > > > # CONFIG_HWMON_DEBUG_CHIP is not set
> > > > 
> > > > #
> > > > # Native drivers
> > > > #
> > > > # CONFIG_SENSORS_ABITUGURU is not set
> > > > # CONFIG_SENSORS_ABITUGURU3 is not set
> > > > # CONFIG_SENSORS_AD7414 is not set
> > > > # CONFIG_SENSORS_AD7418 is not set
> > > > # CONFIG_SENSORS_ADM1021 is not set
> > > > # CONFIG_SENSORS_ADM1025 is not set
> > > > # CONFIG_SENSORS_ADM1026 is not set
> > > > # CONFIG_SENSORS_ADM1029 is not set
> > > > # CONFIG_SENSORS_ADM1031 is not set
> > > > # CONFIG_SENSORS_ADM9240 is not set
> > > > # CONFIG_SENSORS_ADT7410 is not set
> > > > # CONFIG_SENSORS_ADT7411 is not set
> > > > # CONFIG_SENSORS_ADT7462 is not set
> > > > # CONFIG_SENSORS_ADT7470 is not set
> > > > # CONFIG_SENSORS_ADT7475 is not set
> > > > # CONFIG_SENSORS_ASC7621 is not set
> > > > # CONFIG_SENSORS_K8TEMP is not set
> > > > # CONFIG_SENSORS_K10TEMP is not set
> > > > # CONFIG_SENSORS_FAM15H_POWER is not set
> > > > # CONFIG_SENSORS_ASB100 is not set
> > > > # CONFIG_SENSORS_ATXP1 is not set
> > > > # CONFIG_SENSORS_DS620 is not set
> > > > # CONFIG_SENSORS_DS1621 is not set
> > > > # CONFIG_SENSORS_I5K_AMB is not set
> > > > # CONFIG_SENSORS_F71805F is not set
> > > > # CONFIG_SENSORS_F71882FG is not set
> > > > # CONFIG_SENSORS_F75375S is not set
> > > > # CONFIG_SENSORS_FSCHMD is not set
> > > > # CONFIG_SENSORS_G760A is not set
> > > > # CONFIG_SENSORS_GL518SM is not set
> > > > # CONFIG_SENSORS_GL520SM is not set
> > > > # CONFIG_SENSORS_HIH6130 is not set
> > > > # CONFIG_SENSORS_CORETEMP is not set
> > > > # CONFIG_SENSORS_IBMAEM is not set
> > > > # CONFIG_SENSORS_IBMPEX is not set
> > > > # CONFIG_SENSORS_IT87 is not set
> > > > # CONFIG_SENSORS_JC42 is not set
> > > > # CONFIG_SENSORS_LINEAGE is not set
> > > > # CONFIG_SENSORS_LM63 is not set
> > > > # CONFIG_SENSORS_LM73 is not set
> > > > # CONFIG_SENSORS_LM75 is not set
> > > > # CONFIG_SENSORS_LM77 is not set
> > > > # CONFIG_SENSORS_LM78 is not set
> > > > # CONFIG_SENSORS_LM80 is not set
> > > > # CONFIG_SENSORS_LM83 is not set
> > > > # CONFIG_SENSORS_LM85 is not set
> > > > # CONFIG_SENSORS_LM87 is not set
> > > > # CONFIG_SENSORS_LM90 is not set
> > > > # CONFIG_SENSORS_LM92 is not set
> > > > # CONFIG_SENSORS_LM93 is not set
> > > > # CONFIG_SENSORS_LTC4151 is not set
> > > > # CONFIG_SENSORS_LTC4215 is not set
> > > > # CONFIG_SENSORS_LTC4245 is not set
> > > > # CONFIG_SENSORS_LTC4261 is not set
> > > > # CONFIG_SENSORS_LM95241 is not set
> > > > # CONFIG_SENSORS_LM95245 is not set
> > > > # CONFIG_SENSORS_MAX16065 is not set
> > > > # CONFIG_SENSORS_MAX1619 is not set
> > > > # CONFIG_SENSORS_MAX1668 is not set
> > > > # CONFIG_SENSORS_MAX197 is not set
> > > > # CONFIG_SENSORS_MAX6639 is not set
> > > > # CONFIG_SENSORS_MAX6642 is not set
> > > > # CONFIG_SENSORS_MAX6650 is not set
> > > > # CONFIG_SENSORS_MAX6697 is not set
> > > > # CONFIG_SENSORS_MCP3021 is not set
> > > > # CONFIG_SENSORS_NTC_THERMISTOR is not set
> > > > # CONFIG_SENSORS_PC87360 is not set
> > > > # CONFIG_SENSORS_PC87427 is not set
> > > > # CONFIG_SENSORS_PCF8591 is not set
> > > > # CONFIG_PMBUS is not set
> > > > # CONFIG_SENSORS_SHT21 is not set
> > > > # CONFIG_SENSORS_SIS5595 is not set
> > > > # CONFIG_SENSORS_SMM665 is not set
> > > > # CONFIG_SENSORS_DME1737 is not set
> > > > # CONFIG_SENSORS_EMC1403 is not set
> > > > # CONFIG_SENSORS_EMC2103 is not set
> > > > # CONFIG_SENSORS_EMC6W201 is not set
> > > > # CONFIG_SENSORS_SMSC47M1 is not set
> > > > # CONFIG_SENSORS_SMSC47M192 is not set
> > > > # CONFIG_SENSORS_SMSC47B397 is not set
> > > > # CONFIG_SENSORS_SCH56XX_COMMON is not set
> > > > # CONFIG_SENSORS_SCH5627 is not set
> > > > # CONFIG_SENSORS_SCH5636 is not set
> > > > # CONFIG_SENSORS_ADS1015 is not set
> > > > # CONFIG_SENSORS_ADS7828 is not set
> > > > # CONFIG_SENSORS_AMC6821 is not set
> > > > # CONFIG_SENSORS_INA209 is not set
> > > > # CONFIG_SENSORS_INA2XX is not set
> > > > # CONFIG_SENSORS_THMC50 is not set
> > > > # CONFIG_SENSORS_TMP102 is not set
> > > > # CONFIG_SENSORS_TMP401 is not set
> > > > # CONFIG_SENSORS_TMP421 is not set
> > > > # CONFIG_SENSORS_VIA_CPUTEMP is not set
> > > > # CONFIG_SENSORS_VIA686A is not set
> > > > # CONFIG_SENSORS_VT1211 is not set
> > > > # CONFIG_SENSORS_VT8231 is not set
> > > > # CONFIG_SENSORS_W83781D is not set
> > > > # CONFIG_SENSORS_W83791D is not set
> > > > # CONFIG_SENSORS_W83792D is not set
> > > > # CONFIG_SENSORS_W83793 is not set
> > > > # CONFIG_SENSORS_W83795 is not set
> > > > # CONFIG_SENSORS_W83L785TS is not set
> > > > # CONFIG_SENSORS_W83L786NG is not set
> > > > # CONFIG_SENSORS_W83627HF is not set
> > > > # CONFIG_SENSORS_W83627EHF is not set
> > > > # CONFIG_SENSORS_APPLESMC is not set
> > > > 
> > > > #
> > > > # ACPI drivers
> > > > #
> > > > # CONFIG_SENSORS_ACPI_POWER is not set
> > > > # CONFIG_SENSORS_ATK0110 is not set
> > > > CONFIG_THERMAL=y
> > > > CONFIG_THERMAL_HWMON=y
> > > > CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> > > > # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> > > > # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> > > > # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> > > > CONFIG_THERMAL_GOV_STEP_WISE=y
> > > > CONFIG_THERMAL_GOV_USER_SPACE=y
> > > > # CONFIG_CPU_THERMAL is not set
> > > > # CONFIG_THERMAL_EMULATION is not set
> > > > # CONFIG_INTEL_POWERCLAMP is not set
> > > > CONFIG_WATCHDOG=y
> > > > CONFIG_WATCHDOG_CORE=y
> > > > # CONFIG_WATCHDOG_NOWAYOUT is not set
> > > > 
> > > > #
> > > > # Watchdog Device Drivers
> > > > #
> > > > CONFIG_SOFT_WATCHDOG=y
> > > > # CONFIG_ACQUIRE_WDT is not set
> > > > # CONFIG_ADVANTECH_WDT is not set
> > > > # CONFIG_ALIM1535_WDT is not set
> > > > # CONFIG_ALIM7101_WDT is not set
> > > > # CONFIG_F71808E_WDT is not set
> > > > # CONFIG_SP5100_TCO is not set
> > > > # CONFIG_SC520_WDT is not set
> > > > # CONFIG_SBC_FITPC2_WATCHDOG is not set
> > > > # CONFIG_EUROTECH_WDT is not set
> > > > # CONFIG_IB700_WDT is not set
> > > > # CONFIG_IBMASR is not set
> > > > # CONFIG_WAFER_WDT is not set
> > > > CONFIG_I6300ESB_WDT=y
> > > > # CONFIG_IE6XX_WDT is not set
> > > > CONFIG_ITCO_WDT=y
> > > > CONFIG_ITCO_VENDOR_SUPPORT=y
> > > > # CONFIG_IT8712F_WDT is not set
> > > > # CONFIG_IT87_WDT is not set
> > > > # CONFIG_HP_WATCHDOG is not set
> > > > # CONFIG_SC1200_WDT is not set
> > > > # CONFIG_PC87413_WDT is not set
> > > > # CONFIG_NV_TCO is not set
> > > > # CONFIG_60XX_WDT is not set
> > > > # CONFIG_SBC8360_WDT is not set
> > > > # CONFIG_CPU5_WDT is not set
> > > > # CONFIG_SMSC_SCH311X_WDT is not set
> > > > # CONFIG_SMSC37B787_WDT is not set
> > > > # CONFIG_VIA_WDT is not set
> > > > # CONFIG_W83627HF_WDT is not set
> > > > # CONFIG_W83697HF_WDT is not set
> > > > # CONFIG_W83697UG_WDT is not set
> > > > # CONFIG_W83877F_WDT is not set
> > > > # CONFIG_W83977F_WDT is not set
> > > > # CONFIG_MACHZ_WDT is not set
> > > > # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> > > > 
> > > > #
> > > > # PCI-based Watchdog Cards
> > > > #
> > > > # CONFIG_PCIPCWATCHDOG is not set
> > > > # CONFIG_WDTPCI is not set
> > > > 
> > > > #
> > > > # USB-based Watchdog Cards
> > > > #
> > > > # CONFIG_USBPCWATCHDOG is not set
> > > > CONFIG_SSB_POSSIBLE=y
> > > > 
> > > > #
> > > > # Sonics Silicon Backplane
> > > > #
> > > > # CONFIG_SSB is not set
> > > > CONFIG_BCMA_POSSIBLE=y
> > > > 
> > > > #
> > > > # Broadcom specific AMBA
> > > > #
> > > > # CONFIG_BCMA is not set
> > > > 
> > > > #
> > > > # Multifunction device drivers
> > > > #
> > > > CONFIG_MFD_CORE=y
> > > > # CONFIG_MFD_88PM860X is not set
> > > > # CONFIG_MFD_88PM800 is not set
> > > > # CONFIG_MFD_88PM805 is not set
> > > > # CONFIG_MFD_SM501 is not set
> > > > # CONFIG_MFD_RTSX_PCI is not set
> > > > # CONFIG_MFD_TI_AM335X_TSCADC is not set
> > > > # CONFIG_HTC_PASIC3 is not set
> > > > # CONFIG_MFD_LM3533 is not set
> > > > # CONFIG_TPS6105X is not set
> > > > # CONFIG_TPS6507X is not set
> > > > # CONFIG_MFD_TPS65217 is not set
> > > > # CONFIG_MFD_TPS6586X is not set
> > > > # CONFIG_MFD_TPS80031 is not set
> > > > # CONFIG_TWL4030_CORE is not set
> > > > # CONFIG_TWL6040_CORE is not set
> > > > # CONFIG_MFD_STMPE is not set
> > > > # CONFIG_MFD_TC3589X is not set
> > > > # CONFIG_MFD_TMIO is not set
> > > > # CONFIG_MFD_SMSC is not set
> > > > # CONFIG_PMIC_DA903X is not set
> > > > # CONFIG_MFD_DA9052_I2C is not set
> > > > # CONFIG_MFD_DA9055 is not set
> > > > # CONFIG_PMIC_ADP5520 is not set
> > > > # CONFIG_MFD_LP8788 is not set
> > > > # CONFIG_MFD_MAX77686 is not set
> > > > # CONFIG_MFD_MAX77693 is not set
> > > > # CONFIG_MFD_MAX8907 is not set
> > > > # CONFIG_MFD_MAX8925 is not set
> > > > # CONFIG_MFD_MAX8997 is not set
> > > > # CONFIG_MFD_MAX8998 is not set
> > > > # CONFIG_MFD_SEC_CORE is not set
> > > > # CONFIG_MFD_ARIZONA_I2C is not set
> > > > # CONFIG_MFD_WM8400 is not set
> > > > # CONFIG_MFD_WM831X_I2C is not set
> > > > # CONFIG_MFD_WM8350_I2C is not set
> > > > # CONFIG_MFD_WM8994 is not set
> > > > # CONFIG_MFD_PCF50633 is not set
> > > > # CONFIG_MFD_MC13XXX_I2C is not set
> > > > # CONFIG_ABX500_CORE is not set
> > > > # CONFIG_MFD_CS5535 is not set
> > > > # CONFIG_LPC_SCH is not set
> > > > CONFIG_LPC_ICH=y
> > > > # CONFIG_MFD_RDC321X is not set
> > > > # CONFIG_MFD_JANZ_CMODIO is not set
> > > > # CONFIG_MFD_VX855 is not set
> > > > # CONFIG_MFD_WL1273_CORE is not set
> > > > # CONFIG_MFD_TPS65090 is not set
> > > > # CONFIG_MFD_RC5T583 is not set
> > > > # CONFIG_MFD_PALMAS is not set
> > > > # CONFIG_MFD_VIPERBOARD is not set
> > > > # CONFIG_MFD_RETU is not set
> > > > # CONFIG_MFD_AS3711 is not set
> > > > # CONFIG_REGULATOR is not set
> > > > # CONFIG_MEDIA_SUPPORT is not set
> > > > 
> > > > #
> > > > # Graphics support
> > > > #
> > > > # CONFIG_AGP is not set
> > > > CONFIG_VGA_ARB=y
> > > > CONFIG_VGA_ARB_MAX_GPUS=16
> > > > # CONFIG_VGA_SWITCHEROO is not set
> > > > # CONFIG_DRM is not set
> > > > # CONFIG_VGASTATE is not set
> > > > # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> > > > # CONFIG_FB is not set
> > > > # CONFIG_EXYNOS_VIDEO is not set
> > > > # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> > > > 
> > > > #
> > > > # Console display driver support
> > > > #
> > > > CONFIG_VGA_CONSOLE=y
> > > > CONFIG_VGACON_SOFT_SCROLLBACK=y
> > > > CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
> > > > CONFIG_DUMMY_CONSOLE=y
> > > > # CONFIG_SOUND is not set
> > > > 
> > > > #
> > > > # HID support
> > > > #
> > > > CONFIG_HID=y
> > > > CONFIG_HID_BATTERY_STRENGTH=y
> > > > # CONFIG_HIDRAW is not set
> > > > # CONFIG_UHID is not set
> > > > CONFIG_HID_GENERIC=y
> > > > 
> > > > #
> > > > # Special HID drivers
> > > > #
> > > > CONFIG_HID_A4TECH=y
> > > > # CONFIG_HID_ACRUX is not set
> > > > CONFIG_HID_APPLE=y
> > > > # CONFIG_HID_AUREAL is not set
> > > > CONFIG_HID_BELKIN=y
> > > > CONFIG_HID_CHERRY=y
> > > > CONFIG_HID_CHICONY=y
> > > > CONFIG_HID_CYPRESS=y
> > > > CONFIG_HID_DRAGONRISE=y
> > > > # CONFIG_DRAGONRISE_FF is not set
> > > > # CONFIG_HID_EMS_FF is not set
> > > > CONFIG_HID_EZKEY=y
> > > > # CONFIG_HID_HOLTEK is not set
> > > > # CONFIG_HID_KEYTOUCH is not set
> > > > CONFIG_HID_KYE=y
> > > > # CONFIG_HID_UCLOGIC is not set
> > > > # CONFIG_HID_WALTOP is not set
> > > > CONFIG_HID_GYRATION=y
> > > > CONFIG_HID_TWINHAN=y
> > > > CONFIG_HID_KENSINGTON=y
> > > > # CONFIG_HID_LCPOWER is not set
> > > > # CONFIG_HID_LENOVO_TPKBD is not set
> > > > CONFIG_HID_LOGITECH=y
> > > > CONFIG_HID_LOGITECH_DJ=m
> > > > CONFIG_LOGITECH_FF=y
> > > > # CONFIG_LOGIRUMBLEPAD2_FF is not set
> > > > # CONFIG_LOGIG940_FF is not set
> > > > CONFIG_LOGIWHEELS_FF=y
> > > > CONFIG_HID_MICROSOFT=y
> > > > CONFIG_HID_MONTEREY=y
> > > > # CONFIG_HID_MULTITOUCH is not set
> > > > CONFIG_HID_NTRIG=y
> > > > CONFIG_HID_ORTEK=y
> > > > CONFIG_HID_PANTHERLORD=y
> > > > # CONFIG_PANTHERLORD_FF is not set
> > > > CONFIG_HID_PETALYNX=y
> > > > # CONFIG_HID_PICOLCD is not set
> > > > # CONFIG_HID_PRIMAX is not set
> > > > # CONFIG_HID_ROCCAT is not set
> > > > # CONFIG_HID_SAITEK is not set
> > > > CONFIG_HID_SAMSUNG=y
> > > > # CONFIG_HID_SONY is not set
> > > > # CONFIG_HID_SPEEDLINK is not set
> > > > # CONFIG_HID_STEELSERIES is not set
> > > > CONFIG_HID_SUNPLUS=y
> > > > CONFIG_HID_GREENASIA=y
> > > > # CONFIG_GREENASIA_FF is not set
> > > > CONFIG_HID_SMARTJOYPLUS=y
> > > > # CONFIG_SMARTJOYPLUS_FF is not set
> > > > # CONFIG_HID_TIVO is not set
> > > > CONFIG_HID_TOPSEED=y
> > > > CONFIG_HID_THRUSTMASTER=y
> > > > CONFIG_THRUSTMASTER_FF=y
> > > > CONFIG_HID_ZEROPLUS=y
> > > > # CONFIG_ZEROPLUS_FF is not set
> > > > # CONFIG_HID_ZYDACRON is not set
> > > > # CONFIG_HID_SENSOR_HUB is not set
> > > > 
> > > > #
> > > > # USB HID support
> > > > #
> > > > CONFIG_USB_HID=y
> > > > CONFIG_HID_PID=y
> > > > CONFIG_USB_HIDDEV=y
> > > > 
> > > > #
> > > > # I2C HID support
> > > > #
> > > > # CONFIG_I2C_HID is not set
> > > > CONFIG_USB_ARCH_HAS_OHCI=y
> > > > CONFIG_USB_ARCH_HAS_EHCI=y
> > > > CONFIG_USB_ARCH_HAS_XHCI=y
> > > > CONFIG_USB_SUPPORT=y
> > > > CONFIG_USB_COMMON=y
> > > > CONFIG_USB_ARCH_HAS_HCD=y
> > > > CONFIG_USB=y
> > > > # CONFIG_USB_DEBUG is not set
> > > > # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> > > > 
> > > > #
> > > > # Miscellaneous USB options
> > > > #
> > > > # CONFIG_USB_DYNAMIC_MINORS is not set
> > > > # CONFIG_USB_SUSPEND is not set
> > > > # CONFIG_USB_OTG_WHITELIST is not set
> > > > # CONFIG_USB_OTG_BLACKLIST_HUB is not set
> > > > # CONFIG_USB_DWC3 is not set
> > > > CONFIG_USB_MON=y
> > > > # CONFIG_USB_WUSB_CBAF is not set
> > > > 
> > > > #
> > > > # USB Host Controller Drivers
> > > > #
> > > > # CONFIG_USB_C67X00_HCD is not set
> > > > # CONFIG_USB_XHCI_HCD is not set
> > > > CONFIG_USB_EHCI_HCD=y
> > > > CONFIG_USB_EHCI_ROOT_HUB_TT=y
> > > > CONFIG_USB_EHCI_TT_NEWSCHED=y
> > > > CONFIG_USB_EHCI_PCI=y
> > > > # CONFIG_USB_OXU210HP_HCD is not set
> > > > # CONFIG_USB_ISP116X_HCD is not set
> > > > # CONFIG_USB_ISP1760_HCD is not set
> > > > # CONFIG_USB_ISP1362_HCD is not set
> > > > CONFIG_USB_OHCI_HCD=y
> > > > # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> > > > # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> > > > # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> > > > # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> > > > CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> > > > CONFIG_USB_UHCI_HCD=y
> > > > # CONFIG_USB_SL811_HCD is not set
> > > > # CONFIG_USB_R8A66597_HCD is not set
> > > > # CONFIG_USB_CHIPIDEA is not set
> > > > 
> > > > #
> > > > # USB Device Class drivers
> > > > #
> > > > # CONFIG_USB_ACM is not set
> > > > # CONFIG_USB_PRINTER is not set
> > > > # CONFIG_USB_WDM is not set
> > > > # CONFIG_USB_TMC is not set
> > > > 
> > > > #
> > > > # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> > > > #
> > > > 
> > > > #
> > > > # also be needed; see USB_STORAGE Help for more info
> > > > #
> > > > CONFIG_USB_STORAGE=y
> > > > # CONFIG_USB_STORAGE_DEBUG is not set
> > > > # CONFIG_USB_STORAGE_REALTEK is not set
> > > > CONFIG_USB_STORAGE_DATAFAB=y
> > > > CONFIG_USB_STORAGE_FREECOM=y
> > > > CONFIG_USB_STORAGE_ISD200=y
> > > > CONFIG_USB_STORAGE_USBAT=y
> > > > CONFIG_USB_STORAGE_SDDR09=y
> > > > CONFIG_USB_STORAGE_SDDR55=y
> > > > CONFIG_USB_STORAGE_JUMPSHOT=y
> > > > CONFIG_USB_STORAGE_ALAUDA=y
> > > > # CONFIG_USB_STORAGE_ONETOUCH is not set
> > > > # CONFIG_USB_STORAGE_KARMA is not set
> > > > # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> > > > # CONFIG_USB_STORAGE_ENE_UB6250 is not set
> > > > 
> > > > #
> > > > # USB Imaging devices
> > > > #
> > > > # CONFIG_USB_MDC800 is not set
> > > > # CONFIG_USB_MICROTEK is not set
> > > > 
> > > > #
> > > > # USB port drivers
> > > > #
> > > > # CONFIG_USB_SERIAL is not set
> > > > 
> > > > #
> > > > # USB Miscellaneous drivers
> > > > #
> > > > # CONFIG_USB_EMI62 is not set
> > > > # CONFIG_USB_EMI26 is not set
> > > > # CONFIG_USB_ADUTUX is not set
> > > > # CONFIG_USB_SEVSEG is not set
> > > > # CONFIG_USB_RIO500 is not set
> > > > # CONFIG_USB_LEGOTOWER is not set
> > > > # CONFIG_USB_LCD is not set
> > > > # CONFIG_USB_LED is not set
> > > > # CONFIG_USB_CYPRESS_CY7C63 is not set
> > > > # CONFIG_USB_CYTHERM is not set
> > > > # CONFIG_USB_IDMOUSE is not set
> > > > # CONFIG_USB_FTDI_ELAN is not set
> > > > # CONFIG_USB_APPLEDISPLAY is not set
> > > > # CONFIG_USB_SISUSBVGA is not set
> > > > # CONFIG_USB_LD is not set
> > > > # CONFIG_USB_TRANCEVIBRATOR is not set
> > > > # CONFIG_USB_IOWARRIOR is not set
> > > > CONFIG_USB_TEST=y
> > > > # CONFIG_USB_ISIGHTFW is not set
> > > > # CONFIG_USB_YUREX is not set
> > > > # CONFIG_USB_EZUSB_FX2 is not set
> > > > # CONFIG_USB_HSIC_USB3503 is not set
> > > > 
> > > > #
> > > > # USB Physical Layer drivers
> > > > #
> > > > # CONFIG_OMAP_USB3 is not set
> > > > # CONFIG_OMAP_CONTROL_USB is not set
> > > > # CONFIG_USB_ISP1301 is not set
> > > > # CONFIG_USB_RCAR_PHY is not set
> > > > # CONFIG_USB_GADGET is not set
> > > > 
> > > > #
> > > > # OTG and related infrastructure
> > > > #
> > > > # CONFIG_NOP_USB_XCEIV is not set
> > > > # CONFIG_UWB is not set
> > > > # CONFIG_MMC is not set
> > > > # CONFIG_MEMSTICK is not set
> > > > # CONFIG_NEW_LEDS is not set
> > > > # CONFIG_ACCESSIBILITY is not set
> > > > # CONFIG_INFINIBAND is not set
> > > > CONFIG_EDAC=y
> > > > CONFIG_EDAC_LEGACY_SYSFS=y
> > > > # CONFIG_EDAC_DEBUG is not set
> > > > CONFIG_EDAC_MM_EDAC=y
> > > > CONFIG_EDAC_GHES=y
> > > > CONFIG_EDAC_E752X=y
> > > > # CONFIG_EDAC_I82975X is not set
> > > > # CONFIG_EDAC_I3000 is not set
> > > > # CONFIG_EDAC_I3200 is not set
> > > > # CONFIG_EDAC_X38 is not set
> > > > # CONFIG_EDAC_I5400 is not set
> > > > # CONFIG_EDAC_I7CORE is not set
> > > > # CONFIG_EDAC_I5000 is not set
> > > > # CONFIG_EDAC_I5100 is not set
> > > > # CONFIG_EDAC_I7300 is not set
> > > > # CONFIG_EDAC_SBRIDGE is not set
> > > > CONFIG_RTC_LIB=y
> > > > CONFIG_RTC_CLASS=y
> > > > # CONFIG_RTC_DEBUG is not set
> > > > 
> > > > #
> > > > # RTC interfaces
> > > > #
> > > > CONFIG_RTC_INTF_SYSFS=y
> > > > CONFIG_RTC_INTF_PROC=y
> > > > CONFIG_RTC_INTF_DEV=y
> > > > # CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
> > > > # CONFIG_RTC_DRV_TEST is not set
> > > > 
> > > > #
> > > > # I2C RTC drivers
> > > > #
> > > > # CONFIG_RTC_DRV_DS1307 is not set
> > > > # CONFIG_RTC_DRV_DS1374 is not set
> > > > # CONFIG_RTC_DRV_DS1672 is not set
> > > > # CONFIG_RTC_DRV_DS3232 is not set
> > > > # CONFIG_RTC_DRV_MAX6900 is not set
> > > > # CONFIG_RTC_DRV_RS5C372 is not set
> > > > # CONFIG_RTC_DRV_ISL1208 is not set
> > > > # CONFIG_RTC_DRV_ISL12022 is not set
> > > > # CONFIG_RTC_DRV_X1205 is not set
> > > > # CONFIG_RTC_DRV_PCF8523 is not set
> > > > # CONFIG_RTC_DRV_PCF8563 is not set
> > > > # CONFIG_RTC_DRV_PCF8583 is not set
> > > > # CONFIG_RTC_DRV_M41T80 is not set
> > > > # CONFIG_RTC_DRV_BQ32K is not set
> > > > # CONFIG_RTC_DRV_S35390A is not set
> > > > # CONFIG_RTC_DRV_FM3130 is not set
> > > > # CONFIG_RTC_DRV_RX8581 is not set
> > > > # CONFIG_RTC_DRV_RX8025 is not set
> > > > # CONFIG_RTC_DRV_EM3027 is not set
> > > > # CONFIG_RTC_DRV_RV3029C2 is not set
> > > > 
> > > > #
> > > > # SPI RTC drivers
> > > > #
> > > > 
> > > > #
> > > > # Platform RTC drivers
> > > > #
> > > > CONFIG_RTC_DRV_CMOS=y
> > > > # CONFIG_RTC_DRV_DS1286 is not set
> > > > # CONFIG_RTC_DRV_DS1511 is not set
> > > > # CONFIG_RTC_DRV_DS1553 is not set
> > > > # CONFIG_RTC_DRV_DS1742 is not set
> > > > # CONFIG_RTC_DRV_STK17TA8 is not set
> > > > # CONFIG_RTC_DRV_M48T86 is not set
> > > > # CONFIG_RTC_DRV_M48T35 is not set
> > > > # CONFIG_RTC_DRV_M48T59 is not set
> > > > # CONFIG_RTC_DRV_MSM6242 is not set
> > > > # CONFIG_RTC_DRV_BQ4802 is not set
> > > > # CONFIG_RTC_DRV_RP5C01 is not set
> > > > # CONFIG_RTC_DRV_V3020 is not set
> > > > # CONFIG_RTC_DRV_DS2404 is not set
> > > > 
> > > > #
> > > > # on-CPU RTC drivers
> > > > #
> > > > 
> > > > #
> > > > # HID Sensor RTC drivers
> > > > #
> > > > # CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
> > > > # CONFIG_DMADEVICES is not set
> > > > # CONFIG_AUXDISPLAY is not set
> > > > # CONFIG_UIO is not set
> > > > CONFIG_VIRTIO=y
> > > > 
> > > > #
> > > > # Virtio drivers
> > > > #
> > > > CONFIG_VIRTIO_PCI=y
> > > > CONFIG_VIRTIO_BALLOON=y
> > > > CONFIG_VIRTIO_MMIO=y
> > > > # CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set
> > > > 
> > > > #
> > > > # Microsoft Hyper-V guest support
> > > > #
> > > > # CONFIG_HYPERV is not set
> > > > # CONFIG_STAGING is not set
> > > > CONFIG_X86_PLATFORM_DEVICES=y
> > > > # CONFIG_ACERHDF is not set
> > > > # CONFIG_ASUS_LAPTOP is not set
> > > > # CONFIG_CHROMEOS_LAPTOP is not set
> > > > # CONFIG_FUJITSU_TABLET is not set
> > > > # CONFIG_HP_ACCEL is not set
> > > > # CONFIG_THINKPAD_ACPI is not set
> > > > # CONFIG_SENSORS_HDAPS is not set
> > > > # CONFIG_INTEL_MENLOW is not set
> > > > # CONFIG_EEEPC_LAPTOP is not set
> > > > # CONFIG_ACPI_WMI is not set
> > > > # CONFIG_TOPSTAR_LAPTOP is not set
> > > > # CONFIG_TOSHIBA_BT_RFKILL is not set
> > > > # CONFIG_ACPI_CMPC is not set
> > > > # CONFIG_INTEL_IPS is not set
> > > > # CONFIG_IBM_RTL is not set
> > > > # CONFIG_XO15_EBOOK is not set
> > > > # CONFIG_SAMSUNG_Q10 is not set
> > > > 
> > > > #
> > > > # Hardware Spinlock drivers
> > > > #
> > > > CONFIG_CLKEVT_I8253=y
> > > > CONFIG_I8253_LOCK=y
> > > > CONFIG_CLKBLD_I8253=y
> > > > # CONFIG_MAILBOX is not set
> > > > CONFIG_IOMMU_SUPPORT=y
> > > > # CONFIG_AMD_IOMMU is not set
> > > > # CONFIG_INTEL_IOMMU is not set
> > > > # CONFIG_IRQ_REMAP is not set
> > > > 
> > > > #
> > > > # Remoteproc drivers
> > > > #
> > > > # CONFIG_STE_MODEM_RPROC is not set
> > > > 
> > > > #
> > > > # Rpmsg drivers
> > > > #
> > > > # CONFIG_VIRT_DRIVERS is not set
> > > > # CONFIG_PM_DEVFREQ is not set
> > > > # CONFIG_EXTCON is not set
> > > > # CONFIG_MEMORY is not set
> > > > # CONFIG_IIO is not set
> > > > # CONFIG_NTB is not set
> > > > # CONFIG_VME_BUS is not set
> > > > # CONFIG_PWM is not set
> > > > # CONFIG_IPACK_BUS is not set
> > > > 
> > > > #
> > > > # Firmware Drivers
> > > > #
> > > > CONFIG_EDD=y
> > > > # CONFIG_EDD_OFF is not set
> > > > CONFIG_FIRMWARE_MEMMAP=y
> > > > # CONFIG_EFI_VARS is not set
> > > > CONFIG_DELL_RBU=y
> > > > CONFIG_DCDBAS=y
> > > > CONFIG_DMIID=y
> > > > # CONFIG_DMI_SYSFS is not set
> > > > # CONFIG_ISCSI_IBFT_FIND is not set
> > > > # CONFIG_GOOGLE_FIRMWARE is not set
> > > > 
> > > > #
> > > > # File systems
> > > > #
> > > > CONFIG_DCACHE_WORD_ACCESS=y
> > > > CONFIG_EXT2_FS=y
> > > > CONFIG_EXT2_FS_XATTR=y
> > > > CONFIG_EXT2_FS_POSIX_ACL=y
> > > > CONFIG_EXT2_FS_SECURITY=y
> > > > CONFIG_EXT2_FS_XIP=y
> > > > CONFIG_EXT3_FS=y
> > > > # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> > > > CONFIG_EXT3_FS_XATTR=y
> > > > CONFIG_EXT3_FS_POSIX_ACL=y
> > > > CONFIG_EXT3_FS_SECURITY=y
> > > > CONFIG_EXT4_FS=y
> > > > CONFIG_EXT4_FS_POSIX_ACL=y
> > > > CONFIG_EXT4_FS_SECURITY=y
> > > > # CONFIG_EXT4_DEBUG is not set
> > > > CONFIG_FS_XIP=y
> > > > CONFIG_JBD=y
> > > > # CONFIG_JBD_DEBUG is not set
> > > > CONFIG_JBD2=y
> > > > # CONFIG_JBD2_DEBUG is not set
> > > > CONFIG_FS_MBCACHE=y
> > > > CONFIG_REISERFS_FS=y
> > > > # CONFIG_REISERFS_CHECK is not set
> > > > CONFIG_REISERFS_PROC_INFO=y
> > > > CONFIG_REISERFS_FS_XATTR=y
> > > > CONFIG_REISERFS_FS_POSIX_ACL=y
> > > > CONFIG_REISERFS_FS_SECURITY=y
> > > > # CONFIG_JFS_FS is not set
> > > > CONFIG_XFS_FS=y
> > > > CONFIG_XFS_QUOTA=y
> > > > CONFIG_XFS_POSIX_ACL=y
> > > > CONFIG_XFS_RT=y
> > > > # CONFIG_XFS_DEBUG is not set
> > > > # CONFIG_GFS2_FS is not set
> > > > # CONFIG_OCFS2_FS is not set
> > > > CONFIG_BTRFS_FS=y
> > > > CONFIG_BTRFS_FS_POSIX_ACL=y
> > > > # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> > > > # CONFIG_NILFS2_FS is not set
> > > > CONFIG_FS_POSIX_ACL=y
> > > > CONFIG_EXPORTFS=y
> > > > CONFIG_FILE_LOCKING=y
> > > > CONFIG_FSNOTIFY=y
> > > > CONFIG_DNOTIFY=y
> > > > CONFIG_INOTIFY_USER=y
> > > > # CONFIG_FANOTIFY is not set
> > > > CONFIG_QUOTA=y
> > > > # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> > > > # CONFIG_PRINT_QUOTA_WARNING is not set
> > > > # CONFIG_QUOTA_DEBUG is not set
> > > > CONFIG_QUOTA_TREE=y
> > > > # CONFIG_QFMT_V1 is not set
> > > > CONFIG_QFMT_V2=y
> > > > CONFIG_QUOTACTL=y
> > > > CONFIG_QUOTACTL_COMPAT=y
> > > > CONFIG_AUTOFS4_FS=y
> > > > CONFIG_FUSE_FS=y
> > > > # CONFIG_CUSE is not set
> > > > CONFIG_GENERIC_ACL=y
> > > > 
> > > > #
> > > > # Caches
> > > > #
> > > > # CONFIG_FSCACHE is not set
> > > > 
> > > > #
> > > > # CD-ROM/DVD Filesystems
> > > > #
> > > > CONFIG_ISO9660_FS=y
> > > > CONFIG_JOLIET=y
> > > > CONFIG_ZISOFS=y
> > > > CONFIG_UDF_FS=y
> > > > CONFIG_UDF_NLS=y
> > > > 
> > > > #
> > > > # DOS/FAT/NT Filesystems
> > > > #
> > > > CONFIG_FAT_FS=y
> > > > CONFIG_MSDOS_FS=y
> > > > CONFIG_VFAT_FS=y
> > > > CONFIG_FAT_DEFAULT_CODEPAGE=437
> > > > CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
> > > > # CONFIG_NTFS_FS is not set
> > > > 
> > > > #
> > > > # Pseudo filesystems
> > > > #
> > > > CONFIG_PROC_FS=y
> > > > CONFIG_PROC_KCORE=y
> > > > CONFIG_PROC_VMCORE=y
> > > > CONFIG_PROC_SYSCTL=y
> > > > CONFIG_PROC_PAGE_MONITOR=y
> > > > CONFIG_SYSFS=y
> > > > CONFIG_TMPFS=y
> > > > CONFIG_TMPFS_POSIX_ACL=y
> > > > CONFIG_TMPFS_XATTR=y
> > > > CONFIG_HUGETLBFS=y
> > > > CONFIG_HUGETLB_PAGE=y
> > > > CONFIG_CONFIGFS_FS=y
> > > > CONFIG_MISC_FILESYSTEMS=y
> > > > # CONFIG_ADFS_FS is not set
> > > > # CONFIG_AFFS_FS is not set
> > > > # CONFIG_ECRYPT_FS is not set
> > > > # CONFIG_HFS_FS is not set
> > > > # CONFIG_HFSPLUS_FS is not set
> > > > # CONFIG_BEFS_FS is not set
> > > > # CONFIG_BFS_FS is not set
> > > > # CONFIG_EFS_FS is not set
> > > > # CONFIG_LOGFS is not set
> > > > # CONFIG_CRAMFS is not set
> > > > # CONFIG_SQUASHFS is not set
> > > > # CONFIG_VXFS_FS is not set
> > > > # CONFIG_MINIX_FS is not set
> > > > # CONFIG_OMFS_FS is not set
> > > > # CONFIG_HPFS_FS is not set
> > > > # CONFIG_QNX4FS_FS is not set
> > > > # CONFIG_QNX6FS_FS is not set
> > > > CONFIG_ROMFS_FS=y
> > > > CONFIG_ROMFS_BACKED_BY_BLOCK=y
> > > > CONFIG_ROMFS_ON_BLOCK=y
> > > > CONFIG_PSTORE=y
> > > > # CONFIG_PSTORE_CONSOLE is not set
> > > > # CONFIG_PSTORE_FTRACE is not set
> > > > # CONFIG_PSTORE_RAM is not set
> > > > # CONFIG_SYSV_FS is not set
> > > > # CONFIG_UFS_FS is not set
> > > > # CONFIG_F2FS_FS is not set
> > > > CONFIG_NETWORK_FILESYSTEMS=y
> > > > CONFIG_NFS_FS=y
> > > > CONFIG_NFS_V2=y
> > > > CONFIG_NFS_V3=y
> > > > CONFIG_NFS_V3_ACL=y
> > > > CONFIG_NFS_V4=y
> > > > # CONFIG_NFS_SWAP is not set
> > > > CONFIG_NFS_V4_1=y
> > > > CONFIG_PNFS_FILE_LAYOUT=m
> > > > CONFIG_PNFS_BLOCK=m
> > > > CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> > > > CONFIG_ROOT_NFS=y
> > > > # CONFIG_NFS_USE_LEGACY_DNS is not set
> > > > CONFIG_NFS_USE_KERNEL_DNS=y
> > > > CONFIG_NFSD=y
> > > > CONFIG_NFSD_V2_ACL=y
> > > > CONFIG_NFSD_V3=y
> > > > CONFIG_NFSD_V3_ACL=y
> > > > CONFIG_NFSD_V4=y
> > > > # CONFIG_NFSD_FAULT_INJECTION is not set
> > > > CONFIG_LOCKD=y
> > > > CONFIG_LOCKD_V4=y
> > > > CONFIG_NFS_ACL_SUPPORT=y
> > > > CONFIG_NFS_COMMON=y
> > > > CONFIG_SUNRPC=y
> > > > CONFIG_SUNRPC_GSS=y
> > > > CONFIG_SUNRPC_BACKCHANNEL=y
> > > > CONFIG_RPCSEC_GSS_KRB5=y
> > > > # CONFIG_SUNRPC_DEBUG is not set
> > > > # CONFIG_CEPH_FS is not set
> > > > CONFIG_CIFS=y
> > > > # CONFIG_CIFS_STATS is not set
> > > > CONFIG_CIFS_WEAK_PW_HASH=y
> > > > # CONFIG_CIFS_UPCALL is not set
> > > > CONFIG_CIFS_XATTR=y
> > > > CONFIG_CIFS_POSIX=y
> > > > # CONFIG_CIFS_ACL is not set
> > > > CONFIG_CIFS_DEBUG=y
> > > > # CONFIG_CIFS_DEBUG2 is not set
> > > > # CONFIG_CIFS_DFS_UPCALL is not set
> > > > # CONFIG_CIFS_SMB2 is not set
> > > > # CONFIG_NCP_FS is not set
> > > > # CONFIG_CODA_FS is not set
> > > > # CONFIG_AFS_FS is not set
> > > > CONFIG_NLS=y
> > > > CONFIG_NLS_DEFAULT="utf8"
> > > > CONFIG_NLS_CODEPAGE_437=y
> > > > # CONFIG_NLS_CODEPAGE_737 is not set
> > > > # CONFIG_NLS_CODEPAGE_775 is not set
> > > > # CONFIG_NLS_CODEPAGE_850 is not set
> > > > # CONFIG_NLS_CODEPAGE_852 is not set
> > > > # CONFIG_NLS_CODEPAGE_855 is not set
> > > > # CONFIG_NLS_CODEPAGE_857 is not set
> > > > # CONFIG_NLS_CODEPAGE_860 is not set
> > > > # CONFIG_NLS_CODEPAGE_861 is not set
> > > > # CONFIG_NLS_CODEPAGE_862 is not set
> > > > # CONFIG_NLS_CODEPAGE_863 is not set
> > > > # CONFIG_NLS_CODEPAGE_864 is not set
> > > > # CONFIG_NLS_CODEPAGE_865 is not set
> > > > # CONFIG_NLS_CODEPAGE_866 is not set
> > > > # CONFIG_NLS_CODEPAGE_869 is not set
> > > > # CONFIG_NLS_CODEPAGE_936 is not set
> > > > # CONFIG_NLS_CODEPAGE_950 is not set
> > > > # CONFIG_NLS_CODEPAGE_932 is not set
> > > > # CONFIG_NLS_CODEPAGE_949 is not set
> > > > # CONFIG_NLS_CODEPAGE_874 is not set
> > > > # CONFIG_NLS_ISO8859_8 is not set
> > > > # CONFIG_NLS_CODEPAGE_1250 is not set
> > > > # CONFIG_NLS_CODEPAGE_1251 is not set
> > > > CONFIG_NLS_ASCII=y
> > > > CONFIG_NLS_ISO8859_1=y
> > > > # CONFIG_NLS_ISO8859_2 is not set
> > > > # CONFIG_NLS_ISO8859_3 is not set
> > > > # CONFIG_NLS_ISO8859_4 is not set
> > > > # CONFIG_NLS_ISO8859_5 is not set
> > > > # CONFIG_NLS_ISO8859_6 is not set
> > > > # CONFIG_NLS_ISO8859_7 is not set
> > > > # CONFIG_NLS_ISO8859_9 is not set
> > > > # CONFIG_NLS_ISO8859_13 is not set
> > > > # CONFIG_NLS_ISO8859_14 is not set
> > > > # CONFIG_NLS_ISO8859_15 is not set
> > > > # CONFIG_NLS_KOI8_R is not set
> > > > # CONFIG_NLS_KOI8_U is not set
> > > > # CONFIG_NLS_MAC_ROMAN is not set
> > > > # CONFIG_NLS_MAC_CELTIC is not set
> > > > # CONFIG_NLS_MAC_CENTEURO is not set
> > > > # CONFIG_NLS_MAC_CROATIAN is not set
> > > > # CONFIG_NLS_MAC_CYRILLIC is not set
> > > > # CONFIG_NLS_MAC_GAELIC is not set
> > > > # CONFIG_NLS_MAC_GREEK is not set
> > > > # CONFIG_NLS_MAC_ICELAND is not set
> > > > # CONFIG_NLS_MAC_INUIT is not set
> > > > # CONFIG_NLS_MAC_ROMANIAN is not set
> > > > # CONFIG_NLS_MAC_TURKISH is not set
> > > > CONFIG_NLS_UTF8=y
> > > > # CONFIG_DLM is not set
> > > > 
> > > > #
> > > > # Kernel hacking
> > > > #
> > > > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> > > > CONFIG_PRINTK_TIME=y
> > > > CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> > > > CONFIG_ENABLE_WARN_DEPRECATED=y
> > > > CONFIG_ENABLE_MUST_CHECK=y
> > > > CONFIG_FRAME_WARN=2048
> > > > CONFIG_MAGIC_SYSRQ=y
> > > > # CONFIG_STRIP_ASM_SYMS is not set
> > > > # CONFIG_READABLE_ASM is not set
> > > > # CONFIG_UNUSED_SYMBOLS is not set
> > > > CONFIG_DEBUG_FS=y
> > > > # CONFIG_HEADERS_CHECK is not set
> > > > # CONFIG_DEBUG_SECTION_MISMATCH is not set
> > > > CONFIG_DEBUG_KERNEL=y
> > > > # CONFIG_DEBUG_SHIRQ is not set
> > > > # CONFIG_LOCKUP_DETECTOR is not set
> > > > # CONFIG_PANIC_ON_OOPS is not set
> > > > CONFIG_PANIC_ON_OOPS_VALUE=0
> > > > # CONFIG_DETECT_HUNG_TASK is not set
> > > > CONFIG_SCHED_DEBUG=y
> > > > # CONFIG_SCHEDSTATS is not set
> > > > # CONFIG_TIMER_STATS is not set
> > > > # CONFIG_DEBUG_OBJECTS is not set
> > > > # CONFIG_SLUB_DEBUG_ON is not set
> > > > # CONFIG_SLUB_STATS is not set
> > > > CONFIG_HAVE_DEBUG_KMEMLEAK=y
> > > > # CONFIG_DEBUG_KMEMLEAK is not set
> > > > # CONFIG_DEBUG_RT_MUTEXES is not set
> > > > # CONFIG_RT_MUTEX_TESTER is not set
> > > > # CONFIG_DEBUG_SPINLOCK is not set
> > > > # CONFIG_DEBUG_MUTEXES is not set
> > > > # CONFIG_DEBUG_LOCK_ALLOC is not set
> > > > # CONFIG_PROVE_LOCKING is not set
> > > > # CONFIG_LOCK_STAT is not set
> > > > CONFIG_TRACE_IRQFLAGS=y
> > > > CONFIG_DEBUG_ATOMIC_SLEEP=y
> > > > # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> > > > CONFIG_STACKTRACE=y
> > > > # CONFIG_DEBUG_STACK_USAGE is not set
> > > > # CONFIG_DEBUG_KOBJECT is not set
> > > > CONFIG_DEBUG_BUGVERBOSE=y
> > > > # CONFIG_DEBUG_INFO is not set
> > > > # CONFIG_DEBUG_VM is not set
> > > > # CONFIG_DEBUG_VIRTUAL is not set
> > > > # CONFIG_DEBUG_WRITECOUNT is not set
> > > > CONFIG_DEBUG_MEMORY_INIT=y
> > > > # CONFIG_DEBUG_LIST is not set
> > > > # CONFIG_TEST_LIST_SORT is not set
> > > > # CONFIG_DEBUG_SG is not set
> > > > # CONFIG_DEBUG_NOTIFIERS is not set
> > > > # CONFIG_DEBUG_CREDENTIALS is not set
> > > > CONFIG_ARCH_WANT_FRAME_POINTERS=y
> > > > CONFIG_FRAME_POINTER=y
> > > > # CONFIG_BOOT_PRINTK_DELAY is not set
> > > > 
> > > > #
> > > > # RCU Debugging
> > > > #
> > > > CONFIG_SPARSE_RCU_POINTER=y
> > > > # CONFIG_RCU_TORTURE_TEST is not set
> > > > CONFIG_RCU_CPU_STALL_TIMEOUT=60
> > > > # CONFIG_RCU_CPU_STALL_INFO is not set
> > > > # CONFIG_RCU_TRACE is not set
> > > > # CONFIG_KPROBES_SANITY_TEST is not set
> > > > # CONFIG_BACKTRACE_SELF_TEST is not set
> > > > # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> > > > # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> > > > # CONFIG_DEBUG_PER_CPU_MAPS is not set
> > > > CONFIG_LKDTM=y
> > > > # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> > > > # CONFIG_FAULT_INJECTION is not set
> > > > # CONFIG_LATENCYTOP is not set
> > > > # CONFIG_DEBUG_PAGEALLOC is not set
> > > > CONFIG_USER_STACKTRACE_SUPPORT=y
> > > > CONFIG_NOP_TRACER=y
> > > > CONFIG_HAVE_FUNCTION_TRACER=y
> > > > CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> > > > CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> > > > CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> > > > CONFIG_HAVE_DYNAMIC_FTRACE=y
> > > > CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> > > > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> > > > CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> > > > CONFIG_HAVE_FENTRY=y
> > > > CONFIG_HAVE_C_RECORDMCOUNT=y
> > > > CONFIG_TRACER_MAX_TRACE=y
> > > > CONFIG_TRACE_CLOCK=y
> > > > CONFIG_RING_BUFFER=y
> > > > CONFIG_EVENT_TRACING=y
> > > > CONFIG_CONTEXT_SWITCH_TRACER=y
> > > > CONFIG_RING_BUFFER_ALLOW_SWAP=y
> > > > CONFIG_TRACING=y
> > > > CONFIG_GENERIC_TRACER=y
> > > > CONFIG_TRACING_SUPPORT=y
> > > > CONFIG_FTRACE=y
> > > > CONFIG_FUNCTION_TRACER=y
> > > > CONFIG_FUNCTION_GRAPH_TRACER=y
> > > > CONFIG_IRQSOFF_TRACER=y
> > > > CONFIG_SCHED_TRACER=y
> > > > CONFIG_FTRACE_SYSCALLS=y
> > > > CONFIG_TRACER_SNAPSHOT=y
> > > > CONFIG_BRANCH_PROFILE_NONE=y
> > > > # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> > > > # CONFIG_PROFILE_ALL_BRANCHES is not set
> > > > # CONFIG_STACK_TRACER is not set
> > > > CONFIG_BLK_DEV_IO_TRACE=y
> > > > CONFIG_KPROBE_EVENT=y
> > > > CONFIG_UPROBE_EVENT=y
> > > > CONFIG_PROBE_EVENTS=y
> > > > CONFIG_DYNAMIC_FTRACE=y
> > > > CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> > > > CONFIG_FUNCTION_PROFILER=y
> > > > CONFIG_FTRACE_MCOUNT_RECORD=y
> > > > # CONFIG_FTRACE_STARTUP_TEST is not set
> > > > CONFIG_MMIOTRACE=y
> > > > # CONFIG_MMIOTRACE_TEST is not set
> > > > # CONFIG_RING_BUFFER_BENCHMARK is not set
> > > > # CONFIG_RBTREE_TEST is not set
> > > > # CONFIG_INTERVAL_TREE_TEST is not set
> > > > # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> > > > CONFIG_DYNAMIC_DEBUG=y
> > > > # CONFIG_DMA_API_DEBUG is not set
> > > > CONFIG_ATOMIC64_SELFTEST=y
> > > > # CONFIG_ASYNC_RAID6_TEST is not set
> > > > # CONFIG_SAMPLES is not set
> > > > CONFIG_HAVE_ARCH_KGDB=y
> > > > # CONFIG_KGDB is not set
> > > > CONFIG_HAVE_ARCH_KMEMCHECK=y
> > > > # CONFIG_TEST_KSTRTOX is not set
> > > > # CONFIG_STRICT_DEVMEM is not set
> > > > CONFIG_X86_VERBOSE_BOOTUP=y
> > > > CONFIG_EARLY_PRINTK=y
> > > > # CONFIG_EARLY_PRINTK_DBGP is not set
> > > > # CONFIG_DEBUG_STACKOVERFLOW is not set
> > > > # CONFIG_X86_PTDUMP is not set
> > > > CONFIG_DEBUG_RODATA=y
> > > > CONFIG_DEBUG_RODATA_TEST=y
> > > > CONFIG_DEBUG_SET_MODULE_RONX=y
> > > > # CONFIG_DEBUG_NX_TEST is not set
> > > > # CONFIG_DEBUG_TLBFLUSH is not set
> > > > # CONFIG_IOMMU_DEBUG is not set
> > > > # CONFIG_IOMMU_STRESS is not set
> > > > CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> > > > # CONFIG_X86_DECODER_SELFTEST is not set
> > > > CONFIG_IO_DELAY_TYPE_0X80=0
> > > > CONFIG_IO_DELAY_TYPE_0XED=1
> > > > CONFIG_IO_DELAY_TYPE_UDELAY=2
> > > > CONFIG_IO_DELAY_TYPE_NONE=3
> > > > CONFIG_IO_DELAY_0X80=y
> > > > # CONFIG_IO_DELAY_0XED is not set
> > > > # CONFIG_IO_DELAY_UDELAY is not set
> > > > # CONFIG_IO_DELAY_NONE is not set
> > > > CONFIG_DEFAULT_IO_DELAY_TYPE=0
> > > > # CONFIG_DEBUG_BOOT_PARAMS is not set
> > > > # CONFIG_CPA_DEBUG is not set
> > > > # CONFIG_OPTIMIZE_INLINING is not set
> > > > # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> > > > # CONFIG_DEBUG_NMI_SELFTEST is not set
> > > > 
> > > > #
> > > > # Security options
> > > > #
> > > > CONFIG_KEYS=y
> > > > # CONFIG_ENCRYPTED_KEYS is not set
> > > > CONFIG_KEYS_DEBUG_PROC_KEYS=y
> > > > # CONFIG_SECURITY_DMESG_RESTRICT is not set
> > > > # CONFIG_SECURITY is not set
> > > > # CONFIG_SECURITYFS is not set
> > > > CONFIG_DEFAULT_SECURITY_DAC=y
> > > > CONFIG_DEFAULT_SECURITY=""
> > > > CONFIG_XOR_BLOCKS=y
> > > > CONFIG_ASYNC_CORE=y
> > > > CONFIG_ASYNC_MEMCPY=y
> > > > CONFIG_ASYNC_XOR=y
> > > > CONFIG_ASYNC_PQ=y
> > > > CONFIG_ASYNC_RAID6_RECOV=y
> > > > CONFIG_CRYPTO=y
> > > > 
> > > > #
> > > > # Crypto core or helper
> > > > #
> > > > CONFIG_CRYPTO_ALGAPI=y
> > > > CONFIG_CRYPTO_ALGAPI2=y
> > > > CONFIG_CRYPTO_AEAD=y
> > > > CONFIG_CRYPTO_AEAD2=y
> > > > CONFIG_CRYPTO_BLKCIPHER=y
> > > > CONFIG_CRYPTO_BLKCIPHER2=y
> > > > CONFIG_CRYPTO_HASH=y
> > > > CONFIG_CRYPTO_HASH2=y
> > > > CONFIG_CRYPTO_RNG=y
> > > > CONFIG_CRYPTO_RNG2=y
> > > > CONFIG_CRYPTO_PCOMP=y
> > > > CONFIG_CRYPTO_PCOMP2=y
> > > > CONFIG_CRYPTO_MANAGER=y
> > > > CONFIG_CRYPTO_MANAGER2=y
> > > > # CONFIG_CRYPTO_USER is not set
> > > > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> > > > CONFIG_CRYPTO_GF128MUL=y
> > > > CONFIG_CRYPTO_NULL=y
> > > > CONFIG_CRYPTO_PCRYPT=y
> > > > CONFIG_CRYPTO_WORKQUEUE=y
> > > > CONFIG_CRYPTO_CRYPTD=y
> > > > CONFIG_CRYPTO_AUTHENC=y
> > > > CONFIG_CRYPTO_TEST=m
> > > > CONFIG_CRYPTO_ABLK_HELPER_X86=y
> > > > CONFIG_CRYPTO_GLUE_HELPER_X86=y
> > > > 
> > > > #
> > > > # Authenticated Encryption with Associated Data
> > > > #
> > > > CONFIG_CRYPTO_CCM=y
> > > > CONFIG_CRYPTO_GCM=y
> > > > CONFIG_CRYPTO_SEQIV=y
> > > > 
> > > > #
> > > > # Block modes
> > > > #
> > > > CONFIG_CRYPTO_CBC=y
> > > > CONFIG_CRYPTO_CTR=y
> > > > CONFIG_CRYPTO_CTS=y
> > > > CONFIG_CRYPTO_ECB=y
> > > > CONFIG_CRYPTO_LRW=y
> > > > CONFIG_CRYPTO_PCBC=y
> > > > CONFIG_CRYPTO_XTS=y
> > > > 
> > > > #
> > > > # Hash modes
> > > > #
> > > > CONFIG_CRYPTO_HMAC=y
> > > > CONFIG_CRYPTO_XCBC=y
> > > > CONFIG_CRYPTO_VMAC=y
> > > > 
> > > > #
> > > > # Digest
> > > > #
> > > > CONFIG_CRYPTO_CRC32C=y
> > > > CONFIG_CRYPTO_CRC32C_X86_64=y
> > > > CONFIG_CRYPTO_CRC32C_INTEL=y
> > > > CONFIG_CRYPTO_CRC32=y
> > > > CONFIG_CRYPTO_CRC32_PCLMUL=y
> > > > CONFIG_CRYPTO_GHASH=y
> > > > CONFIG_CRYPTO_MD4=y
> > > > CONFIG_CRYPTO_MD5=y
> > > > CONFIG_CRYPTO_MICHAEL_MIC=y
> > > > CONFIG_CRYPTO_RMD128=y
> > > > CONFIG_CRYPTO_RMD160=y
> > > > CONFIG_CRYPTO_RMD256=y
> > > > CONFIG_CRYPTO_RMD320=y
> > > > CONFIG_CRYPTO_SHA1=y
> > > > CONFIG_CRYPTO_SHA1_SSSE3=y
> > > > CONFIG_CRYPTO_SHA256=y
> > > > CONFIG_CRYPTO_SHA512=y
> > > > CONFIG_CRYPTO_TGR192=y
> > > > CONFIG_CRYPTO_WP512=y
> > > > CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y
> > > > 
> > > > #
> > > > # Ciphers
> > > > #
> > > > CONFIG_CRYPTO_AES=y
> > > > CONFIG_CRYPTO_AES_X86_64=y
> > > > CONFIG_CRYPTO_AES_NI_INTEL=y
> > > > CONFIG_CRYPTO_ANUBIS=y
> > > > CONFIG_CRYPTO_ARC4=y
> > > > CONFIG_CRYPTO_BLOWFISH=y
> > > > CONFIG_CRYPTO_BLOWFISH_COMMON=y
> > > > CONFIG_CRYPTO_BLOWFISH_X86_64=y
> > > > CONFIG_CRYPTO_CAMELLIA=y
> > > > CONFIG_CRYPTO_CAMELLIA_X86_64=y
> > > > CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
> > > > CONFIG_CRYPTO_CAST_COMMON=y
> > > > CONFIG_CRYPTO_CAST5=y
> > > > CONFIG_CRYPTO_CAST5_AVX_X86_64=y
> > > > CONFIG_CRYPTO_CAST6=y
> > > > CONFIG_CRYPTO_CAST6_AVX_X86_64=y
> > > > CONFIG_CRYPTO_DES=y
> > > > CONFIG_CRYPTO_FCRYPT=y
> > > > CONFIG_CRYPTO_KHAZAD=y
> > > > CONFIG_CRYPTO_SALSA20=y
> > > > CONFIG_CRYPTO_SALSA20_X86_64=y
> > > > CONFIG_CRYPTO_SEED=y
> > > > CONFIG_CRYPTO_SERPENT=y
> > > > CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
> > > > CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
> > > > CONFIG_CRYPTO_TEA=y
> > > > CONFIG_CRYPTO_TWOFISH=y
> > > > CONFIG_CRYPTO_TWOFISH_COMMON=y
> > > > CONFIG_CRYPTO_TWOFISH_X86_64=y
> > > > CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
> > > > CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y
> > > > 
> > > > #
> > > > # Compression
> > > > #
> > > > CONFIG_CRYPTO_DEFLATE=y
> > > > CONFIG_CRYPTO_ZLIB=y
> > > > CONFIG_CRYPTO_LZO=y
> > > > 
> > > > #
> > > > # Random Number Generation
> > > > #
> > > > CONFIG_CRYPTO_ANSI_CPRNG=y
> > > > CONFIG_CRYPTO_USER_API=y
> > > > CONFIG_CRYPTO_USER_API_HASH=y
> > > > CONFIG_CRYPTO_USER_API_SKCIPHER=y
> > > > CONFIG_CRYPTO_HW=y
> > > > # CONFIG_CRYPTO_DEV_PADLOCK is not set
> > > > CONFIG_ASYMMETRIC_KEY_TYPE=y
> > > > CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> > > > CONFIG_PUBLIC_KEY_ALGO_RSA=y
> > > > # CONFIG_X509_CERTIFICATE_PARSER is not set
> > > > CONFIG_HAVE_KVM=y
> > > > CONFIG_HAVE_KVM_IRQCHIP=y
> > > > CONFIG_HAVE_KVM_EVENTFD=y
> > > > CONFIG_KVM_APIC_ARCHITECTURE=y
> > > > CONFIG_KVM_MMIO=y
> > > > CONFIG_KVM_ASYNC_PF=y
> > > > CONFIG_HAVE_KVM_MSI=y
> > > > CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
> > > > CONFIG_VIRTUALIZATION=y
> > > > CONFIG_KVM=y
> > > > CONFIG_KVM_INTEL=y
> > > > # CONFIG_KVM_AMD is not set
> > > > # CONFIG_KVM_MMU_AUDIT is not set
> > > > CONFIG_VHOST_NET=y
> > > > CONFIG_BINARY_PRINTF=y
> > > > 
> > > > #
> > > > # Library routines
> > > > #
> > > > CONFIG_RAID6_PQ=y
> > > > CONFIG_BITREVERSE=y
> > > > CONFIG_GENERIC_STRNCPY_FROM_USER=y
> > > > CONFIG_GENERIC_STRNLEN_USER=y
> > > > CONFIG_GENERIC_FIND_FIRST_BIT=y
> > > > CONFIG_GENERIC_PCI_IOMAP=y
> > > > CONFIG_GENERIC_IOMAP=y
> > > > CONFIG_GENERIC_IO=y
> > > > CONFIG_PERCPU_RWSEM=y
> > > > CONFIG_CRC_CCITT=y
> > > > CONFIG_CRC16=y
> > > > CONFIG_CRC_T10DIF=y
> > > > CONFIG_CRC_ITU_T=y
> > > > CONFIG_CRC32=y
> > > > # CONFIG_CRC32_SELFTEST is not set
> > > > CONFIG_CRC32_SLICEBY8=y
> > > > # CONFIG_CRC32_SLICEBY4 is not set
> > > > # CONFIG_CRC32_SARWATE is not set
> > > > # CONFIG_CRC32_BIT is not set
> > > > # CONFIG_CRC7 is not set
> > > > CONFIG_LIBCRC32C=y
> > > > # CONFIG_CRC8 is not set
> > > > CONFIG_ZLIB_INFLATE=y
> > > > CONFIG_ZLIB_DEFLATE=y
> > > > CONFIG_LZO_COMPRESS=y
> > > > CONFIG_LZO_DECOMPRESS=y
> > > > CONFIG_XZ_DEC=y
> > > > CONFIG_XZ_DEC_X86=y
> > > > CONFIG_XZ_DEC_POWERPC=y
> > > > CONFIG_XZ_DEC_IA64=y
> > > > CONFIG_XZ_DEC_ARM=y
> > > > CONFIG_XZ_DEC_ARMTHUMB=y
> > > > CONFIG_XZ_DEC_SPARC=y
> > > > CONFIG_XZ_DEC_BCJ=y
> > > > # CONFIG_XZ_DEC_TEST is not set
> > > > CONFIG_DECOMPRESS_GZIP=y
> > > > CONFIG_DECOMPRESS_BZIP2=y
> > > > CONFIG_DECOMPRESS_LZMA=y
> > > > CONFIG_DECOMPRESS_XZ=y
> > > > CONFIG_DECOMPRESS_LZO=y
> > > > CONFIG_GENERIC_ALLOCATOR=y
> > > > CONFIG_HAS_IOMEM=y
> > > > CONFIG_HAS_IOPORT=y
> > > > CONFIG_HAS_DMA=y
> > > > CONFIG_CPU_RMAP=y
> > > > CONFIG_DQL=y
> > > > CONFIG_NLATTR=y
> > > > CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> > > > # CONFIG_AVERAGE is not set
> > > > CONFIG_CLZ_TAB=y
> > > > # CONFIG_CORDIC is not set
> > > > # CONFIG_DDR is not set
> > > > CONFIG_MPILIB=y
> > 
> > 

--zhXaljGHf11kAtnf
Content-Type: application/x-gtar-compressed
Content-Description: perfmodules.2014.01.21a.tgz
Content-Disposition: attachment; filename="perfmodules.2014.01.21a.tgz"
Content-Transfer-Encoding: base64

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

--zhXaljGHf11kAtnf--

