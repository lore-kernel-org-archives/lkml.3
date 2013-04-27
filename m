Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3D0Igr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 04:36:47 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47398 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3D0Igl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 04:36:41 -0400
MIME-Version: 1.0
Date: Sat, 27 Apr 2013 16:36:39 +0800
Message-ID: <CAGr9mPwXnPWR2rVo-cN3-5rLFqNBHhUhRVqpBwYS9MaVQB6h9A@mail.gmail.com>
Subject: Re: Linux 3.2.44 - build error
From: =?GB2312?B?0PGraLXL?= <dengxuyue@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation error:
kernel/trace/ftrace.c:3846: error: 'ftrace_filter_lseek' undeclared here
(not in a function)

'ftrace_filter_lseek' is defined in the scope between
kernel/trace/ftrace.c:932 and kernel/trace/ftrace.c:3044 guarded by "#ifdef
CONFIG_DYNAMIC_FTRACE", but "dynamic ftrace" can be disabled.

The following is the ".config" file

#------------------------------begin--------------------------------------
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi
-fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
-fcall-saved-r10 -fcall-saved-r11"
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-Berserk"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
CONFIG_DEFAULT_HOSTNAME="zeta"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y

CONFIG_TINY_RCU=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_CGROUP_MEM_RES_CTLR=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP=y
CONFIG_CGROUP_MEM_RES_CTLR_SWAP_ENABLED=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_MM_OWNER=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_UID16=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

CONFIG_PERF_EVENTS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
CONFIG_SLAB=y
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y

CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_FREEZER=y

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_X86_MPPARSE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_NO_BOOTMEM=y
CONFIG_MCORE2=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_CMPXCHG_DOUBLE=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_NEED_PER_CPU_KM=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x200000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_X86_PM_TIMER=y

CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_INTEL_IDLE=y

CONFIG_I7300_IDLE_IOAT_CHANNEL=y
CONFIG_I7300_IDLE=m

CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y

CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=m
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_DEFAULT_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y

CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=y


CONFIG_NETFILTER_XT_TARGET_NOTRACK=y
CONFIG_NETFILTER_XT_TARGET_TRACE=m

CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_STATE=y

CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_RAW=y
CONFIG_HAVE_BPF_JIT=y

CONFIG_FIB_RULES=y


CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_PNP=y

CONFIG_PNPACPI=y
CONFIG_HAVE_IDE=y

CONFIG_SCSI_MOD=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

CONFIG_ATA_SFF=y

CONFIG_ATA_BMDMA=y

CONFIG_ATA_PIIX=y



CONFIG_ATA_GENERIC=y
CONFIG_MD=y
CONFIG_BLK_DEV_DM=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_MAX_SGE=32
CONFIG_FUSION_CTL=y

CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y

CONFIG_ETHERNET=y
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E1000=y


CONFIG_INPUT=y

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=y

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y

CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m

CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=0
CONFIG_DEVKMEM=y

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=8

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_NVRAM=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_DEVPORT=y




CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_THERMAL=y
CONFIG_SSB_POSSIBLE=y

CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y



CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=0
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

CONFIG_FB_VESA=y


CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_AC97_CODEC=y
CONFIG_SND_DRIVERS=y
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_PCI=y
CONFIG_SND_ENS1371=y
CONFIG_AC97_BUS=y


CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y

CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y

CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_FS_POSIX_ACL=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_AUTOFS4_FS=y
CONFIG_GENERIC_ACL=y




CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y

CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_UTF8=y

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
CONFIG_DEBUG_FS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_EARLY_PRINTK=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0

CONFIG_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
CONFIG_DEFAULT_SECURITY_SELINUX=y
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_CRYPTO=y

CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_AUTHENC=y

CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m

CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m

CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_DES=y

CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=m

CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_HAVE_KVM=y
CONFIG_BINARY_PRINTF=y

CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_NLATTR=y

#--------------------------------------end--------------------------------------------------

>
> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ben Hutchings
> Sent: Friday, April 26, 2013 7:43 PM
> To: linux-kernel@vger.kernel.org; Andrew Morton; torvalds@linux-foundation.org; Jiri Slaby; stable@vger.kernel.org
> Cc: lwn@lwn.net
> Subject: Linux 3.2.44
>
> I'm announcing the release of the 3.2.44 kernel.
>
> All users of the 3.2 kernel series should upgrade.
>
> The updated 3.2.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git
>
> The diff from 3.2.43 is attached to this message.
>
> Ben.
>
> ------------
>
>  Documentation/kernel-parameters.txt                |   14 +++++
>  Makefile                                           |    2 +-
>  arch/alpha/kernel/sys_nautilus.c                   |    5 ++
>  arch/arm/kernel/perf_event.c                       |    5 +-
>  arch/arm/mm/cache-feroceon-l2.c                    |    1 +
>  arch/arm/mm/proc-arm920.S                          |    2 +-
>  arch/arm/mm/proc-arm926.S                          |    2 +-
>  arch/arm/mm/proc-sa1100.S                          |    2 +-
>  arch/arm/mm/proc-v6.S                              |    2 +-
>  arch/arm/mm/proc-xsc3.S                            |    2 +-
>  arch/arm/mm/proc-xscale.S                          |    2 +-
>  arch/powerpc/platforms/pseries/lpar.c              |    8 ++-
>  arch/x86/include/asm/kvm_host.h                    |    4 +-
>  arch/x86/include/asm/paravirt.h                    |    5 +-
>  arch/x86/include/asm/paravirt_types.h              |    2 +
>  arch/x86/kernel/paravirt.c                         |   25 ++++-----
>  arch/x86/kvm/x86.c                                 |   43 +++++++--------
>  arch/x86/lguest/boot.c                             |    1 +
>  arch/x86/mm/fault.c                                |    6 ++-
>  arch/x86/xen/mmu.c                                 |    1 +
>  block/blk-sysfs.c                                  |    2 +
>  crypto/gcm.c                                       |   17 ++++--
>  drivers/ata/ata_piix.c                             |   14 ++++-
>  drivers/ata/libata-core.c                          |    4 ++
>  drivers/gpu/drm/i915/i915_drv.h                    |    1 +
>  drivers/gpu/drm/i915/intel_display.c               |   55 ++++++++++++++++++++
>  drivers/gpu/drm/i915/intel_panel.c                 |   24 +++++++++
>  drivers/gpu/vga/vga_switcheroo.c                   |    3 ++
>  drivers/hwspinlock/hwspinlock_core.c               |    2 +
>  drivers/mtd/mtdchar.c                              |    6 ++-
>  drivers/net/can/sja1000/sja1000_of_platform.c      |   31 ++++++-----
>  drivers/net/ethernet/realtek/r8169.c               |   28 ++++++++--
>  .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |    2 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
>  drivers/net/wireless/rt2x00/rt2x00pci.c            |    4 +-
>  drivers/platform/x86/msi-wmi.c                     |    4 +-
>  drivers/target/target_core_alua.c                  |    9 ++--
>  drivers/target/target_core_transport.c             |    3 +-
>  drivers/thermal/thermal_sys.c                      |    1 +
>  drivers/usb/serial/ark3116.c                       |   10 ++--
>  drivers/usb/serial/ch341.c                         |   11 ++--
>  drivers/usb/serial/cypress_m8.c                    |   14 ++---
>  drivers/usb/serial/ftdi_sio.c                      |   19 +++----
>  drivers/usb/serial/io_edgeport.c                   |   12 +++--
>  drivers/usb/serial/io_ti.c                         |   12 ++---
>  drivers/usb/serial/mct_u232.c                      |   13 ++---
>  drivers/usb/serial/mos7840.c                       |   16 +++---
>  drivers/usb/serial/oti6858.c                       |   10 ++--
>  drivers/usb/serial/pl2303.c                        |   11 ++--
>  drivers/usb/serial/spcp8x5.c                       |    9 ++--
>  drivers/usb/serial/ssu100.c                        |   12 +++--
>  drivers/usb/serial/ti_usb_3410_5052.c              |   10 ++--
>  drivers/usb/serial/usb-serial.c                    |    1 +
>  drivers/video/console/fbcon.c                      |   11 ++--
>  drivers/video/fbmem.c                              |    2 +
>  fs/btrfs/extent_io.c                               |   33 ++++++++++++
>  fs/btrfs/extent_io.h                               |    2 +
>  fs/btrfs/inode.c                                   |   14 +++++
>  fs/btrfs/tree-log.c                                |   48 ++++++++++++++---
>  fs/hfsplus/extents.c                               |    2 +-
>  fs/inode.c                                         |    2 +-
>  include/linux/ata.h                                |    2 +-
>  include/linux/kref.h                               |   21 ++++++++
>  include/linux/kvm_host.h                           |    2 +-
>  include/linux/kvm_types.h                          |    1 +
>  include/linux/libata.h                             |    1 +
>  include/linux/of.h                                 |   16 ++++++
>  include/linux/preempt.h                            |   18 ++++---
>  include/linux/socket.h                             |    1 +
>  include/linux/spinlock_up.h                        |   29 +++++++----
>  include/linux/usb/serial.h                         |    2 +
>  include/linux/writeback.h                          |    2 +
>  include/net/scm.h                                  |    2 +-
>  kernel/hrtimer.c                                   |    3 +-
>  kernel/sched.c                                     |    6 ++-
>  kernel/sched_clock.c                               |   26 +++++++++
>  kernel/signal.c                                    |    2 +-
>  kernel/sys.c                                       |    3 +-
>  kernel/trace/ftrace.c                              |   19 +++----
>  lib/kobject.c                                      |    9 +++-
>  mm/hugetlb.c                                       |   12 ++++-
>  mm/page-writeback.c                                |   19 +++++++
>  net/can/gw.c                                       |    6 +--
>  net/core/sock.c                                    |   14 +++++
>  sound/pci/hda/hda_codec.c                          |    2 +-
>  sound/pci/hda/patch_realtek.c                      |    4 +-
>  sound/soc/codecs/wm8903.c                          |    2 +
>  sound/usb/mixer_quirks.c                           |    4 +-
>  sound/usb/quirks.c                                 |    2 +-
>  virt/kvm/ioapic.c                                  |    7 ++-
>  virt/kvm/kvm_main.c                                |   47 +++++++++++++----
>  91 files changed, 678 insertions(+), 226 deletions(-)
>
> Alban Bedel (1):
>       ASoC: wm8903: Fix the bypass to HP/LINEOUT when no DAC or ADC is running
>
> Andrew Honig (1):
>       KVM: Allow cross page reads and writes from cached translations.
>
> Andy Honig (3):
>       KVM: x86: fix for buffer overflow in handling of MSR_KVM_SYSTEM_TIME (CVE-2013-1796)
>       KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use gfn_to_hva_cache functions (CVE-2013-1797)
>       KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
>
> Arnd Bergmann (1):
>       block: avoid using uninitialized value in from queue_var_store
>
> Ben Hutchings (1):
>       Linux 3.2.44
>
> Boris Ostrovsky (1):
>       x86, mm: Patch out arch_flush_lazy_mmu_mode() when running on bare metal
>
> Carsten Emde (3):
>       drm/i915: panel: invert brightness via parameter
>       drm/i915: panel: invert brightness via quirk
>       drm/i915: panel: invert brightness acer aspire 5734z
>
> Chris Mason (1):
>       Btrfs: fix race between mmap writes and compression
>
> Christoph Fritz (1):
>       can: sja1000: fix handling on dt properties on little endian systems
>
> Dave Airlie (1):
>       fbcon: fix locking harder
>
> David Henningsson (1):
>       ALSA: hda - fix typo in proc output
>
> David Woodhouse (1):
>       mtd: Disable mtdchar mmap on MMU systems
>
> Egbert Eich (1):
>       DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
>
> Eldad Zack (1):
>       ALSA: usb-audio: fix endianness bug in snd_nativeinstruments_*
>
> Emese Revfy (1):
>       kernel/signal.c: stop info leak via the tkill and the tgkill syscalls
>
> Felix Fietkau (2):
>       ath9k_htc: accept 1.x firmware newer than 1.3
>       ath9k_hw: change AR9580 initvals to fix a stability issue
>
> Huacai Chen (1):
>       PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()
>
> Illia Ragozin (1):
>       ARM: 7696/1: Fix kexec by setting outer_cache.inv_all for Feroceon
>
> Jan Kiszka (1):
>       ftrace: Consistently restore trace function on sysctl enabling
>
> Jani Nikula (3):
>       drm/i915: add quirk to invert brightness on eMachines G725
>       drm/i915: add quirk to invert brightness on eMachines e725
>       drm/i915: add quirk to invert brightness on Packard Bell NCL20
>
> Jay Estabrook (1):
>       alpha: Add irongate_io to PCI bus resources
>
> Jean-Christophe PLAGNIOL-VILLARD (1):
>       of: introduce helper to manage boolean
>
> Johan Hovold (15):
>       USB: serial: add modem-status-change wait queue
>       USB: ark3116: fix use-after-free in TIOCMIWAIT
>       USB: ch341: fix use-after-free in TIOCMIWAIT
>       USB: cypress_m8: fix use-after-free in TIOCMIWAIT
>       USB: ftdi_sio: fix use-after-free in TIOCMIWAIT
>       USB: io_edgeport: fix use-after-free in TIOCMIWAIT
>       USB: io_ti: fix use-after-free in TIOCMIWAIT
>       USB: mct_u232: fix use-after-free in TIOCMIWAIT
>       USB: mos7840: fix broken TIOCMIWAIT
>       USB: mos7840: fix use-after-free in TIOCMIWAIT
>       USB: oti6858: fix use-after-free in TIOCMIWAIT
>       USB: pl2303: fix use-after-free in TIOCMIWAIT
>       USB: spcp8x5: fix use-after-free in TIOCMIWAIT
>       USB: ssu100: fix use-after-free in TIOCMIWAIT
>       USB: ti_usb_3410_5052: fix use-after-free in TIOCMIWAIT
>
> Josef Bacik (1):
>       Btrfs: make sure nbytes are right after log replay
>
> Jussi Kivilinna (1):
>       crypto: gcm - fix assumption that assoc has one segment
>
> Li Fei (1):
>       hwspinlock: fix __hwspin_lock_request error path
>
> Linus Torvalds (3):
>       spinlocks and preemption points need to be at least compiler barriers
>       kobject: fix kset_find_obj() race with concurrent last kobject_put()
>       net: fix incorrect credentials passing
>
> Maxim Mikityanskiy (1):
>       msi-wmi: Fix memory leak
>
> Michael Bohan (1):
>       hrtimer: Don't reinitialize a cpu_base lock on CPU_UP
>
> Michael Wolf (1):
>       powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test
>
> Ming Lei (1):
>       USB: serial: fix hang when opening port
>
> Namhyung Kim (2):
>       tracing: Fix double free when function profile init failed
>       tracing: Fix possible NULL pointer dereferences
>
> Naoya Horiguchi (1):
>       hugetlbfs: add swap entry check in follow_hugetlb_page()
>
> Nicholas Bellinger (2):
>       target: Fix MAINTENANCE_IN service action CDB checks to use lower 5 bits
>       target: Fix incorrect fallthrough of ALUA Standby/Offline/Transition CDBs
>
> Rainer Koenig (1):
>       ALSA: hda - Enabling Realtek ALC 671 codec
>
> Richard Guy Briggs (1):
>       thermal: return an error on failure to register thermal class
>
> Russell King (1):
>       ARM: Do 15e0d9e37c (ARM: pm: let platforms select cpu_suspend support) properly
>
> Samu Kallio (1):
>       x86, mm, paravirt: Fix vmalloc_fault oops during lazy MMU updates
>
> Shan Hai (2):
>       libata: Use integer return value for atapi_command_packet_set
>       libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive
>
> Suleiman Souhlal (1):
>       vfs: Revert spurious fix to spinning prevention in prune_icache_sb
>
> Tejun Heo (1):
>       sched: Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s
>
> Thomas Gleixner (1):
>       sched_clock: Prevent 64bit inatomicity on 32bit systems
>
> Thomas Hellstrom (1):
>       kref: Implement kref_get_unless_zero v3
>
> Tim Gardner (1):
>       rt2x00: rt2x00pci_regbusy_read() - only print register access failure once
>
> Vyacheslav Dubeyko (1):
>       hfsplus: fix potential overflow in hfsplus_file_truncate()
>
> Wei Yongjun (1):
>       can: gw: use kmem_cache_free() instead of kfree()
>
> Will Deacon (1):
>       ARM: 7698/1: perf: fix group validation when using enable_on_exec
>
> Wu Fengguang (1):
>       writeback: fix dirtied pages accounting on redirty
>
> Youquan Song (1):
>       ata_piix: Fix DVD not dectected at some Haswell platforms
>
> hayeswang (1):
>       r8169: fix auto speed down issue
>
>
