Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaDYPeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:34:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:8763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176AbaDYPd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:33:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,927,1389772800"; 
   d="scan'208";a="519778428"
Date: Fri, 25 Apr 2014 23:33:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ssantosh-keystone:for_3.16/wip/net-qmss5 8/13]
 drivers/net/phy/mv88x2242.c:160:21: error: dereferencing pointer to
 incomplete type
Message-ID: <20140425153347.GA31982@localhost>
References: <53487309.biBWHw4kEb74MAjd%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53487309.biBWHw4kEb74MAjd%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

This error seems still not fixed..

Thanks,
Fengguang

On Sat, Apr 12, 2014 at 06:56:09AM +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/keystone.git for_3.16/wip/net-qmss5
> head:   e7da7a167c0eca50ac4473536c7e4ce4d150a7f7
> commit: 28304c5ea4830c155e85d48abb61aed86bba883f [8/13] net: phy: Add Marvell 88x2242 10G PHY
> config: i386-randconfig-i006 (attached as .config)
> 
> All error/warnings:
> 
>    drivers/net/phy/mv88x2242.c: In function 'mv88x2242_gpiochip_match_by_label':
> >> drivers/net/phy/mv88x2242.c:160:21: error: dereferencing pointer to incomplete type
>      return !strcmp(chip->label, data);
>                         ^
>    drivers/net/phy/mv88x2242.c: In function 'mv88x2242_reset_phy':
> >> drivers/net/phy/mv88x2242.c:167:2: error: implicit declaration of function 'gpiochip_find' [-Werror=implicit-function-declaration]
>      gc = gpiochip_find("pca9555", mv88x2242_gpiochip_match_by_label);
>      ^
> >> drivers/net/phy/mv88x2242.c:167:5: warning: assignment makes pointer from integer without a cast [enabled by default]
>      gc = gpiochip_find("pca9555", mv88x2242_gpiochip_match_by_label);
>         ^
>    In file included from include/linux/dmaengine.h:24:0,
>                     from include/linux/skbuff.h:31,
>                     from include/linux/if_ether.h:23,
>                     from include/uapi/linux/ethtool.h:17,
>                     from include/linux/ethtool.h:16,
>                     from include/linux/phy.h:20,
>                     from drivers/net/phy/mv88x2242.c:21:
> >> drivers/net/phy/mv88x2242.c:175:6: error: dereferencing pointer to incomplete type
>        gc->base);
>          ^
>    include/linux/device.h:1089:58: note: in definition of macro 'dev_info'
>     #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>                                                              ^
> >> drivers/net/phy/mv88x2242.c:177:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 8, 0);
>                                ^
> >> drivers/net/phy/mv88x2242.c:178:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 9, 0);
>                                ^
> >> drivers/net/phy/mv88x2242.c:179:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 10, 0);
>                                ^
> >> drivers/net/phy/mv88x2242.c:181:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 8, 1);
>                                ^
> >> drivers/net/phy/mv88x2242.c:182:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 9, 1);
>                                ^
> >> drivers/net/phy/mv88x2242.c:183:28: error: dereferencing pointer to incomplete type
>      gpio_set_value_cansleep(gc->base + 10, 1);
>                                ^
>    drivers/net/phy/mv88x2242.c: In function 'mv88x2242_gpiochip_match_by_label':
> >> drivers/net/phy/mv88x2242.c:161:1: warning: control reaches end of non-void function [-Wreturn-type]
>     }
>     ^
>    cc1: some warnings being treated as errors
> 
> vim +160 drivers/net/phy/mv88x2242.c
> 
>     15	 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>     16	 * GNU General Public License for more details.
>     17	 */
>     18	
>     19	#include <linux/module.h>
>     20	#include <linux/delay.h>
>     21	#include <linux/phy.h>
>     22	#include <linux/of.h>
>     23	#include <linux/gpio.h>
>     24	
>     25	#define MARVELL_PHY_ID_88X2242	0x01410f12
>     26	#define MARVELL_PHY_ID_MASK	0xfffffc00
>     27	
>     28	/* chip level regs */
>     29	#define MV88X2242_TX_SRC_N		(MII_ADDR_C45 | 0x1ff400)
>     30	#define MV88X2242_TX_SRC_M		(MII_ADDR_C45 | 0x1ff401)
>     31	#define MV88X2242_HOST_LANE_MUX		(MII_ADDR_C45 | 0x1ff402)
>     32	#define MV88X2242_HW_RESET		(MII_ADDR_C45 | 0x1ff404)
>     33	
>     34	/* port level regs */
>     35	#define MV88X2242_PCS_CONFIG		(MII_ADDR_C45 | 0x1ff002)
>     36	#define MV88X2242_PORT_RESET		(MII_ADDR_C45 | 0x1ff003)
>     37	#define MV88X2242_GPIO_TRI_CTRL		(MII_ADDR_C45 | 0x1ff013)
>     38	#define MV88X2242_GPIO_INTR_TYPE3	(MII_ADDR_C45 | 0x1ff016)
>     39	
>     40	/* SFI PMA regs */
>     41	#define MV88X2242_PMD_RX_SIGNAL_DETECT	(MII_ADDR_C45 | 0x01000a)
>     42	
>     43	/* SFI 10BASE-R PCS regs */
>     44	#define MV88X2242_10GBASER_PCS_CTRL	(MII_ADDR_C45 | 0x030000)
>     45	#define MV88X2242_10GBASER_PCS_STATUS	(MII_ADDR_C45 | 0x030020)
>     46	#define MV88X2242_LASI_CONTROL		(MII_ADDR_C45 | 0x038000)
>     47	#define MV88X2242_LASI_STATUS		(MII_ADDR_C45 | 0x038001)
>     48	
>     49	/* XFI 10BASE-R PCS regs */
>     50	#define MV88X2242_BASER_PCS_STATUS	(MII_ADDR_C45 | 0x040020)
>     51	
>     52	/* FIXME */
>     53	static int mv88x2242_chip_cfg;
>     54	
>     55	#if IS_ENABLED(CONFIG_OF_MDIO)
>     56	static int mv88x2242_chip_level_config(struct phy_device *phydev)
>     57	{
>     58		int val;
>     59	
>     60		/* chip hw reset */
>     61		phy_write(phydev, MV88X2242_HW_RESET, 0x4000);
>     62	
>     63		mdelay(10);
>     64	
>     65		/* Map ports */
>     66		/* Added by TI for port mapping 0123:0123,
>     67		   The default is M0-to-N0, M2-to-N1,
>     68		   so setting bit 9 makes M1-to-N1 instead.
>     69		   Must be done prior to the reset!
>     70		   BEGR: I believe only one write is required for this,
>     71			 as 31.F4xx registers are accessible through any of the
>     72			 4 PHY addresses.
>     73		*/
>     74		phy_write(phydev, MV88X2242_HOST_LANE_MUX, BIT(9));
>     75	
>     76		/* Shut down unused lanes */
>     77		val = phy_read(phydev, MV88X2242_TX_SRC_N);
>     78		val &= 0x00ff;
>     79		phy_write(phydev, MV88X2242_TX_SRC_N, val);
>     80	
>     81		val = phy_read(phydev, MV88X2242_TX_SRC_M);
>     82		val &= 0x00ff;
>     83		phy_write(phydev, MV88X2242_TX_SRC_M, val);
>     84	
>     85		return 0;
>     86	}
>     87	
>     88	/* Set and/or override some configuration registers based on the
>     89	 * marvell,c45-reg-init property stored in the of_node for the phydev.
>     90	 *
>     91	 * marvell,c45-reg-init = <devid reg mask value>,...;
>     92	 *
>     93	 * There may be one or more sets of <devid reg mask value>:
>     94	 *
>     95	 * devid: which sub-device to use.
>     96	 * reg: the register.
>     97	 * mask: if non-zero, ANDed with existing register value.
>     98	 * value: ORed with the masked value and written to the regiser.
>     99	 *
>    100	 */
>    101	static int mv88x2242_of_reg_init(struct phy_device *phydev)
>    102	{
>    103		int val;
>    104	
>    105		if (phydev->priv) {
>    106			dev_info(&phydev->dev, "phy %d already configured\n",
>    107				phydev->addr);
>    108			return 0;
>    109		}
>    110	
>    111		/*10gx2, 6G */
>    112		phy_write(phydev, MV88X2242_PCS_CONFIG, 0x7171);
>    113	
>    114		/* pcs reset */
>    115		phy_write(phydev, MV88X2242_PORT_RESET, 0x8080);
>    116	
>    117		mdelay(10);
>    118	
>    119		/* Required to Enable Optical module transmitter */
>    120		/* For Fiber Tx Disable to enable optics (REQUIRED) */
>    121		val = phy_read(phydev, MV88X2242_GPIO_INTR_TYPE3);
>    122		val = (val & ~0x0018) | 0x0010;
>    123		phy_write(phydev, MV88X2242_GPIO_INTR_TYPE3, val);
>    124	
>    125		/* Enable Marvell I2C SCL/SDA operations */
>    126		val = phy_read(phydev, MV88X2242_GPIO_INTR_TYPE3);
>    127		val = (val & ~0x0800) | 0x0800;
>    128		phy_write(phydev, MV88X2242_GPIO_INTR_TYPE3, val);
>    129	
>    130		val = phy_read(phydev, MV88X2242_GPIO_INTR_TYPE3);
>    131		val = (val & ~0x8000) | 0x8000;
>    132		phy_write(phydev, MV88X2242_GPIO_INTR_TYPE3, val);
>    133	
>    134		val = phy_read(phydev, MV88X2242_GPIO_TRI_CTRL);
>    135		val = (val & ~0x0800) | 0x0800;
>    136		phy_write(phydev, MV88X2242_GPIO_TRI_CTRL, val);
>    137	
>    138		mdelay(10);
>    139	
>    140		phydev->priv = (void *)1;
>    141	
>    142		/* Read Each Lane Optical traceiver name? */
>    143	
>    144		return 0;
>    145	}
>    146	#else
>    147	static int mv88x2242_chip_level_config(struct phy_device *phydev)
>    148	{
>    149		return 0;
>    150	}
>    151	
>    152	static int mv88x2242_of_reg_init(struct phy_device *phydev)
>    153	{
>    154		return 0;
>    155	}
>    156	#endif /* CONFIG_OF_MDIO */
>    157	
>    158	static int mv88x2242_gpiochip_match_by_label(struct gpio_chip *chip, void *data)
>    159	{
>  > 160		return !strcmp(chip->label, data);
>    161	}
>    162	
>    163	static int mv88x2242_reset_phy(struct phy_device *phydev)
>    164	{
>    165		struct gpio_chip *gc;
>    166	
>    167		gc = gpiochip_find("pca9555", mv88x2242_gpiochip_match_by_label);
>    168		if (!gc) {
>    169			dev_err(&phydev->dev,
>    170				"Can't find gpio chip with label pca9555\n");
>    171			return -ENODEV;
>    172		} else
>    173			dev_info(&phydev->dev,
>    174				"Found gpio chip with label pca9555, gpio base = %d\n",
>    175				gc->base);
>    176	
>    177		gpio_set_value_cansleep(gc->base + 8, 0);
>    178		gpio_set_value_cansleep(gc->base + 9, 0);
>    179		gpio_set_value_cansleep(gc->base + 10, 0);
>    180	
>    181		gpio_set_value_cansleep(gc->base + 8, 1);
>    182		gpio_set_value_cansleep(gc->base + 9, 1);
>    183		gpio_set_value_cansleep(gc->base + 10, 1);
>    184	
>    185		return 0;
>    186	}
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.14.0 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_X86_32_SMP=y
> CONFIG_X86_HT=y
> CONFIG_X86_32_LAZY_GS=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> CONFIG_COMPILE_TEST=y
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_KERNEL_LZ4=y
> CONFIG_DEFAULT_HOSTNAME="(none)"
> # CONFIG_SWAP is not set
> # CONFIG_SYSVIPC is not set
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_FHANDLE=y
> CONFIG_USELIB=y
> # CONFIG_AUDIT is not set
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_DOMAIN=y
> # CONFIG_IRQ_DOMAIN_DEBUG is not set
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> CONFIG_NO_HZ=y
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> # CONFIG_TICK_CPU_ACCOUNTING is not set
> CONFIG_IRQ_TIME_ACCOUNTING=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_FANOUT=32
> CONFIG_RCU_FANOUT_LEAF=16
> CONFIG_RCU_FANOUT_EXACT=y
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_RCU_NOCB_CPU is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> CONFIG_USER_NS=y
> # CONFIG_PID_NS is not set
> CONFIG_NET_NS=y
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> CONFIG_RD_XZ=y
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> # CONFIG_EXPERT is not set
> CONFIG_UID16=y
> CONFIG_SYSFS_SYSCALL=y
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLUB_CPU_PARTIAL is not set
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> # CONFIG_SYSTEM_TRUSTED_KEYRING is not set
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_AMIGA_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_PADATA=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> CONFIG_ZONE_DMA=y
> CONFIG_SMP=y
> CONFIG_X86_MPPARSE=y
> CONFIG_X86_BIGSMP=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_32_IRIS is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> # CONFIG_PARAVIRT_SPINLOCKS is not set
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> CONFIG_MPENTIUM4=y
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=7
> CONFIG_X86_L1_CACHE_SHIFT=7
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_CPU_SUP_TRANSMETA_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> CONFIG_NR_CPUS=32
> # CONFIG_SCHED_SMT is not set
> # CONFIG_SCHED_MC is not set
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> CONFIG_I8K=y
> # CONFIG_X86_REBOOTFIXUPS is not set
> CONFIG_MICROCODE=y
> CONFIG_MICROCODE_INTEL=y
> # CONFIG_MICROCODE_AMD is not set
> CONFIG_MICROCODE_OLD_INTERFACE=y
> CONFIG_MICROCODE_INTEL_EARLY=y
> # CONFIG_MICROCODE_AMD_EARLY is not set
> CONFIG_MICROCODE_EARLY=y
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> CONFIG_HIGHMEM64G=y
> CONFIG_PAGE_OFFSET=0xC0000000
> CONFIG_HIGHMEM=y
> CONFIG_X86_PAE=y
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> # CONFIG_NUMA is not set
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> CONFIG_TRANSPARENT_HUGEPAGE=y
> # CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
> CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
> CONFIG_CROSS_MEMORY_ATTACH=y
> # CONFIG_CLEANCACHE is not set
> CONFIG_CMA=y
> # CONFIG_CMA_DEBUG is not set
> # CONFIG_ZBUD is not set
> CONFIG_ZSMALLOC=y
> # CONFIG_PGTABLE_MAPPING is not set
> CONFIG_HIGHPTE=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> CONFIG_ARCH_RANDOM=y
> CONFIG_X86_SMAP=y
> CONFIG_EFI=y
> # CONFIG_EFI_STUB is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> # CONFIG_SCHED_HRTICK is not set
> # CONFIG_KEXEC is not set
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> CONFIG_RANDOMIZE_BASE=y
> CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_HOTPLUG_CPU is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_EC_DEBUGFS=y
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> CONFIG_ACPI_VIDEO=y
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> # CONFIG_ACPI_PROCESSOR is not set
> CONFIG_ACPI_IPMI=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> CONFIG_ACPI_HED=y
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> CONFIG_ACPI_BGRT=y
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> CONFIG_SFI=y
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> # CONFIG_PCIEAER is not set
> CONFIG_PCIEASPM=y
> # CONFIG_PCIEASPM_DEBUG is not set
> # CONFIG_PCIEASPM_DEFAULT is not set
> # CONFIG_PCIEASPM_POWERSAVE is not set
> CONFIG_PCIEASPM_PERFORMANCE=y
> CONFIG_PCIE_PME=y
> CONFIG_PCI_MSI=y
> # CONFIG_PCI_DEBUG is not set
> CONFIG_PCI_REALLOC_ENABLE_AUTO=y
> CONFIG_PCI_STUB=y
> CONFIG_HT_IRQ=y
> CONFIG_PCI_ATS=y
> # CONFIG_PCI_IOV is not set
> CONFIG_PCI_PRI=y
> # CONFIG_PCI_PASID is not set
> CONFIG_PCI_IOAPIC=y
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> # CONFIG_EISA is not set
> # CONFIG_SCx200 is not set
> # CONFIG_ALIX is not set
> # CONFIG_NET5501 is not set
> # CONFIG_GEOS is not set
> CONFIG_AMD_NB=y
> # CONFIG_PCCARD is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> CONFIG_X86_SYSFB=y
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> CONFIG_COREDUMP=y
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NET_PTP_CLASSIFY=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> # CONFIG_NETFILTER_DEBUG is not set
> # CONFIG_NETFILTER_ADVANCED is not set
> CONFIG_ATM=y
> CONFIG_ATM_LANE=y
> CONFIG_STP=y
> CONFIG_GARP=y
> CONFIG_MRP=y
> # CONFIG_BRIDGE is not set
> CONFIG_HAVE_NET_DSA=y
> CONFIG_NET_DSA=y
> CONFIG_NET_DSA_TAG_DSA=y
> CONFIG_NET_DSA_TAG_EDSA=y
> CONFIG_NET_DSA_TAG_TRAILER=y
> CONFIG_VLAN_8021Q=y
> CONFIG_VLAN_8021Q_GVRP=y
> CONFIG_VLAN_8021Q_MVRP=y
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> # CONFIG_IPX is not set
> CONFIG_ATALK=y
> # CONFIG_DEV_APPLETALK is not set
> CONFIG_X25=y
> CONFIG_LAPB=y
> CONFIG_PHONET=y
> CONFIG_IEEE802154=y
> # CONFIG_MAC802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> CONFIG_NET_SCH_CBQ=y
> CONFIG_NET_SCH_HTB=y
> # CONFIG_NET_SCH_HFSC is not set
> CONFIG_NET_SCH_ATM=y
> # CONFIG_NET_SCH_PRIO is not set
> # CONFIG_NET_SCH_MULTIQ is not set
> CONFIG_NET_SCH_RED=y
> CONFIG_NET_SCH_SFB=y
> CONFIG_NET_SCH_SFQ=y
> CONFIG_NET_SCH_TEQL=y
> CONFIG_NET_SCH_TBF=y
> # CONFIG_NET_SCH_GRED is not set
> # CONFIG_NET_SCH_DSMARK is not set
> CONFIG_NET_SCH_NETEM=y
> # CONFIG_NET_SCH_DRR is not set
> CONFIG_NET_SCH_MQPRIO=y
> # CONFIG_NET_SCH_CHOKE is not set
> CONFIG_NET_SCH_QFQ=y
> # CONFIG_NET_SCH_CODEL is not set
> CONFIG_NET_SCH_FQ_CODEL=y
> # CONFIG_NET_SCH_FQ is not set
> CONFIG_NET_SCH_HHF=y
> # CONFIG_NET_SCH_PIE is not set
> CONFIG_NET_SCH_INGRESS=y
> # CONFIG_NET_SCH_PLUG is not set
> 
> #
> # Classification
> #
> CONFIG_NET_CLS=y
> CONFIG_NET_CLS_BASIC=y
> # CONFIG_NET_CLS_TCINDEX is not set
> # CONFIG_NET_CLS_FW is not set
> CONFIG_NET_CLS_U32=y
> # CONFIG_CLS_U32_PERF is not set
> CONFIG_CLS_U32_MARK=y
> CONFIG_NET_CLS_RSVP=y
> CONFIG_NET_CLS_RSVP6=y
> CONFIG_NET_CLS_FLOW=y
> # CONFIG_NET_CLS_BPF is not set
> CONFIG_NET_EMATCH=y
> CONFIG_NET_EMATCH_STACK=32
> CONFIG_NET_EMATCH_CMP=y
> CONFIG_NET_EMATCH_NBYTE=y
> CONFIG_NET_EMATCH_U32=y
> CONFIG_NET_EMATCH_META=y
> CONFIG_NET_EMATCH_TEXT=y
> CONFIG_NET_CLS_ACT=y
> CONFIG_NET_ACT_POLICE=y
> # CONFIG_NET_ACT_GACT is not set
> # CONFIG_NET_ACT_MIRRED is not set
> CONFIG_NET_ACT_NAT=y
> # CONFIG_NET_ACT_PEDIT is not set
> CONFIG_NET_ACT_SIMP=y
> CONFIG_NET_ACT_SKBEDIT=y
> # CONFIG_NET_CLS_IND is not set
> CONFIG_NET_SCH_FIFO=y
> CONFIG_DCB=y
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_NC is not set
> # CONFIG_BATMAN_ADV_MCAST is not set
> # CONFIG_BATMAN_ADV_DEBUG is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_MMAP is not set
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> # CONFIG_HSR is not set
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_XPS=y
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> CONFIG_HAMRADIO=y
> 
> #
> # Packet Radio protocols
> #
> CONFIG_AX25=y
> # CONFIG_AX25_DAMA_SLAVE is not set
> # CONFIG_NETROM is not set
> CONFIG_ROSE=y
> 
> #
> # AX.25 network device drivers
> #
> CONFIG_MKISS=y
> CONFIG_6PACK=y
> CONFIG_BPQETHER=y
> CONFIG_SCC=y
> # CONFIG_SCC_DELAY is not set
> CONFIG_SCC_TRXECHO=y
> CONFIG_BAYCOM_SER_FDX=y
> # CONFIG_BAYCOM_SER_HDX is not set
> CONFIG_BAYCOM_PAR=y
> # CONFIG_BAYCOM_EPP is not set
> CONFIG_YAM=y
> # CONFIG_CAN is not set
> CONFIG_IRDA=y
> 
> #
> # IrDA protocols
> #
> CONFIG_IRLAN=y
> CONFIG_IRCOMM=y
> CONFIG_IRDA_ULTRA=y
> 
> #
> # IrDA options
> #
> # CONFIG_IRDA_CACHE_LAST_LSAP is not set
> CONFIG_IRDA_FAST_RR=y
> # CONFIG_IRDA_DEBUG is not set
> 
> #
> # Infrared-port device drivers
> #
> 
> #
> # SIR device drivers
> #
> CONFIG_IRTTY_SIR=y
> 
> #
> # Dongle support
> #
> CONFIG_DONGLE=y
> CONFIG_ESI_DONGLE=y
> # CONFIG_ACTISYS_DONGLE is not set
> CONFIG_TEKRAM_DONGLE=y
> CONFIG_TOIM3232_DONGLE=y
> CONFIG_LITELINK_DONGLE=y
> # CONFIG_MA600_DONGLE is not set
> CONFIG_GIRBIL_DONGLE=y
> CONFIG_MCP2120_DONGLE=y
> CONFIG_OLD_BELKIN_DONGLE=y
> CONFIG_ACT200L_DONGLE=y
> CONFIG_KINGSUN_DONGLE=y
> CONFIG_KSDAZZLE_DONGLE=y
> CONFIG_KS959_DONGLE=y
> 
> #
> # FIR device drivers
> #
> CONFIG_USB_IRDA=y
> # CONFIG_SIGMATEL_FIR is not set
> # CONFIG_NSC_FIR is not set
> CONFIG_WINBOND_FIR=y
> # CONFIG_TOSHIBA_FIR is not set
> # CONFIG_SMC_IRCC_FIR is not set
> # CONFIG_ALI_FIR is not set
> CONFIG_VLSI_FIR=y
> # CONFIG_VIA_FIR is not set
> CONFIG_MCS_FIR=y
> CONFIG_BT=y
> # CONFIG_BT_RFCOMM is not set
> CONFIG_BT_BNEP=y
> # CONFIG_BT_BNEP_MC_FILTER is not set
> # CONFIG_BT_BNEP_PROTO_FILTER is not set
> CONFIG_BT_HIDP=y
> 
> #
> # Bluetooth device drivers
> #
> CONFIG_BT_HCIBTUSB=y
> # CONFIG_BT_HCIBTSDIO is not set
> CONFIG_BT_HCIUART=y
> # CONFIG_BT_HCIUART_H4 is not set
> CONFIG_BT_HCIUART_BCSP=y
> # CONFIG_BT_HCIUART_ATH3K is not set
> CONFIG_BT_HCIUART_LL=y
> CONFIG_BT_HCIUART_3WIRE=y
> # CONFIG_BT_HCIBCM203X is not set
> CONFIG_BT_HCIBPA10X=y
> CONFIG_BT_HCIBFUSB=y
> CONFIG_BT_HCIVHCI=y
> # CONFIG_BT_MRVL is not set
> # CONFIG_BT_ATH3K is not set
> CONFIG_WIRELESS=y
> CONFIG_CFG80211=y
> CONFIG_NL80211_TESTMODE=y
> CONFIG_CFG80211_DEVELOPER_WARNINGS=y
> # CONFIG_CFG80211_REG_DEBUG is not set
> # CONFIG_CFG80211_DEFAULT_PS is not set
> # CONFIG_CFG80211_DEBUGFS is not set
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> # CONFIG_CFG80211_WEXT is not set
> # CONFIG_LIB80211 is not set
> # CONFIG_MAC80211 is not set
> CONFIG_WIMAX=y
> CONFIG_WIMAX_DEBUG_LEVEL=8
> CONFIG_RFKILL=y
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> CONFIG_RFKILL_REGULATOR=y
> # CONFIG_NET_9P is not set
> CONFIG_CAIF=y
> CONFIG_CAIF_DEBUG=y
> CONFIG_CAIF_NETDEV=y
> # CONFIG_CAIF_USB is not set
> CONFIG_NFC=y
> CONFIG_NFC_DIGITAL=y
> CONFIG_NFC_NCI=y
> # CONFIG_NFC_NCI_SPI is not set
> CONFIG_NFC_HCI=y
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> CONFIG_NFC_PN533=y
> CONFIG_NFC_TRF7970A=y
> # CONFIG_NFC_MEI_PHY is not set
> # CONFIG_NFC_SIM is not set
> # CONFIG_NFC_PORT100 is not set
> # CONFIG_NFC_PN544 is not set
> # CONFIG_NFC_MICROREAD is not set
> # CONFIG_NFC_MRVL is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_SPI=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> # CONFIG_PROC_EVENTS is not set
> # CONFIG_MTD is not set
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> # CONFIG_PARPORT_PC is not set
> # CONFIG_PARPORT_GSC is not set
> CONFIG_PARPORT_AX88796=y
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
> 
> #
> # Protocols
> #
> CONFIG_ISAPNP=y
> CONFIG_PNPBIOS=y
> # CONFIG_PNPBIOS_PROC_FS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> CONFIG_BLK_DEV_FD=y
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_ZRAM is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> CONFIG_BLK_DEV_DAC960=y
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> # CONFIG_BLK_DEV_LOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_NBD is not set
> # CONFIG_BLK_DEV_NVME is not set
> CONFIG_BLK_DEV_SX8=y
> CONFIG_BLK_DEV_RAM=y
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> CONFIG_BLK_DEV_XIP=y
> # CONFIG_CDROM_PKTCDVD is not set
> CONFIG_ATA_OVER_ETH=y
> # CONFIG_VIRTIO_BLK is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_BLK_DEV_RSXX=y
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> # CONFIG_DUMMY_IRQ is not set
> CONFIG_IBM_ASM=y
> CONFIG_PHANTOM=y
> # CONFIG_INTEL_MID_PTI is not set
> CONFIG_SGI_IOC4=y
> CONFIG_TIFM_CORE=y
> CONFIG_TIFM_7XX1=y
> # CONFIG_ICS932S401 is not set
> CONFIG_ATMEL_SSC=y
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_CS5535_MFGPT is not set
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> CONFIG_ISL29003=y
> # CONFIG_ISL29020 is not set
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> CONFIG_SENSORS_APDS990X=y
> CONFIG_HMC6352=y
> CONFIG_DS1682=y
> CONFIG_TI_DAC7512=y
> CONFIG_VMWARE_BALLOON=y
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> CONFIG_BMP085_SPI=y
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> CONFIG_LATTICE_ECP3_CONFIG=y
> CONFIG_SRAM=y
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> CONFIG_EEPROM_AT24=y
> CONFIG_EEPROM_AT25=y
> CONFIG_EEPROM_LEGACY=y
> CONFIG_EEPROM_MAX6875=y
> CONFIG_EEPROM_93CX6=y
> # CONFIG_EEPROM_93XX46 is not set
> CONFIG_CB710_CORE=y
> CONFIG_CB710_DEBUG=y
> CONFIG_CB710_DEBUG_ASSUMPTIONS=y
> 
> #
> # Texas Instruments shared transport line discipline
> #
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> # CONFIG_ALTERA_STAPL is not set
> CONFIG_INTEL_MEI=y
> # CONFIG_INTEL_MEI_ME is not set
> CONFIG_INTEL_MEI_TXE=y
> CONFIG_VMWARE_VMCI=y
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_ECHO is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=y
> 
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> CONFIG_IDE_XFER_MODE=y
> CONFIG_IDE_TIMINGS=y
> CONFIG_IDE_ATAPI=y
> CONFIG_IDE_LEGACY=y
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=y
> # CONFIG_IDE_GD_ATA is not set
> # CONFIG_IDE_GD_ATAPI is not set
> # CONFIG_BLK_DEV_IDECD is not set
> CONFIG_BLK_DEV_IDETAPE=y
> # CONFIG_BLK_DEV_IDEACPI is not set
> CONFIG_IDE_TASK_IOCTL=y
> # CONFIG_IDE_PROC_FS is not set
> 
> #
> # IDE chipset support/bugfixes
> #
> CONFIG_IDE_GENERIC=y
> # CONFIG_BLK_DEV_PLATFORM is not set
> CONFIG_BLK_DEV_CMD640=y
> # CONFIG_BLK_DEV_CMD640_ENHANCED is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
> 
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> # CONFIG_IDEPCI_PCIBUS_ORDER is not set
> CONFIG_BLK_DEV_OFFBOARD=y
> CONFIG_BLK_DEV_GENERIC=y
> CONFIG_BLK_DEV_OPTI621=y
> # CONFIG_BLK_DEV_RZ1000 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> CONFIG_BLK_DEV_AEC62XX=y
> CONFIG_BLK_DEV_ALI15X3=y
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_ATIIXP is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> CONFIG_BLK_DEV_CS5520=y
> CONFIG_BLK_DEV_CS5530=y
> CONFIG_BLK_DEV_CS5535=y
> # CONFIG_BLK_DEV_CS5536 is not set
> CONFIG_BLK_DEV_HPT366=y
> CONFIG_BLK_DEV_JMICRON=y
> CONFIG_BLK_DEV_SC1200=y
> # CONFIG_BLK_DEV_PIIX is not set
> CONFIG_BLK_DEV_IT8172=y
> CONFIG_BLK_DEV_IT8213=y
> CONFIG_BLK_DEV_IT821X=y
> CONFIG_BLK_DEV_NS87415=y
> CONFIG_BLK_DEV_PDC202XX_OLD=y
> CONFIG_BLK_DEV_PDC202XX_NEW=y
> CONFIG_BLK_DEV_SVWKS=y
> CONFIG_BLK_DEV_SIIMAGE=y
> CONFIG_BLK_DEV_SIS5513=y
> CONFIG_BLK_DEV_SLC90E66=y
> CONFIG_BLK_DEV_TRM290=y
> CONFIG_BLK_DEV_VIA82CXXX=y
> # CONFIG_BLK_DEV_TC86C001 is not set
> 
> #
> # Other IDE chipsets support
> #
> 
> #
> # Note: most of these also require special kernel boot parameters
> #
> CONFIG_BLK_DEV_4DRIVES=y
> CONFIG_BLK_DEV_ALI14XX=y
> CONFIG_BLK_DEV_DTC2278=y
> # CONFIG_BLK_DEV_HT6560B is not set
> # CONFIG_BLK_DEV_QD65XX is not set
> CONFIG_BLK_DEV_UMC8672=y
> CONFIG_BLK_DEV_IDEDMA=y
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> CONFIG_RAID_ATTRS=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> CONFIG_CHR_DEV_ST=y
> CONFIG_CHR_DEV_OSST=y
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> # CONFIG_SCSI_MULTI_LUN is not set
> # CONFIG_SCSI_CONSTANTS is not set
> CONFIG_SCSI_LOGGING=y
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> CONFIG_SCSI_FC_ATTRS=y
> CONFIG_SCSI_FC_TGT_ATTRS=y
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> CONFIG_SCSI_SAS_LIBSAS=y
> CONFIG_SCSI_SAS_ATA=y
> CONFIG_SCSI_SAS_HOST_SMP=y
> CONFIG_SCSI_SRP_ATTRS=y
> CONFIG_SCSI_SRP_TGT_ATTRS=y
> # CONFIG_SCSI_LOWLEVEL is not set
> CONFIG_SCSI_DH=y
> CONFIG_SCSI_DH_RDAC=y
> # CONFIG_SCSI_DH_HP_SW is not set
> CONFIG_SCSI_DH_EMC=y
> # CONFIG_SCSI_DH_ALUA is not set
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> # CONFIG_SATA_PMP is not set
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_AHCI_IMX is not set
> # CONFIG_AHCI_XGENE is not set
> CONFIG_SATA_INIC162X=y
> # CONFIG_SATA_ACARD_AHCI is not set
> CONFIG_SATA_SIL24=y
> # CONFIG_ATA_SFF is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=y
> CONFIG_MD_AUTODETECT=y
> CONFIG_MD_LINEAR=y
> # CONFIG_MD_RAID0 is not set
> CONFIG_MD_RAID1=y
> CONFIG_MD_RAID10=y
> CONFIG_MD_RAID456=y
> CONFIG_MD_MULTIPATH=y
> # CONFIG_MD_FAULTY is not set
> CONFIG_BCACHE=y
> # CONFIG_BCACHE_DEBUG is not set
> CONFIG_BCACHE_CLOSURES_DEBUG=y
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=y
> CONFIG_DM_BIO_PRISON=y
> CONFIG_DM_PERSISTENT_DATA=y
> CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
> # CONFIG_DM_CRYPT is not set
> # CONFIG_DM_SNAPSHOT is not set
> CONFIG_DM_THIN_PROVISIONING=y
> # CONFIG_DM_CACHE is not set
> CONFIG_DM_ERA=y
> CONFIG_DM_MIRROR=y
> CONFIG_DM_LOG_USERSPACE=y
> CONFIG_DM_RAID=y
> CONFIG_DM_ZERO=y
> CONFIG_DM_MULTIPATH=y
> # CONFIG_DM_MULTIPATH_QL is not set
> CONFIG_DM_MULTIPATH_ST=y
> # CONFIG_DM_DELAY is not set
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=y
> CONFIG_DM_VERITY=y
> CONFIG_DM_SWITCH=y
> CONFIG_TARGET_CORE=y
> CONFIG_TCM_IBLOCK=y
> CONFIG_TCM_FILEIO=y
> # CONFIG_TCM_PSCSI is not set
> CONFIG_LOOPBACK_TARGET=y
> CONFIG_ISCSI_TARGET=y
> CONFIG_SBP_TARGET=y
> CONFIG_FUSION=y
> # CONFIG_FUSION_SPI is not set
> CONFIG_FUSION_FC=y
> CONFIG_FUSION_SAS=y
> CONFIG_FUSION_MAX_SGE=128
> CONFIG_FUSION_CTL=y
> CONFIG_FUSION_LAN=y
> CONFIG_FUSION_LOGGING=y
> 
> #
> # IEEE 1394 (FireWire) support
> #
> CONFIG_FIREWIRE=y
> CONFIG_FIREWIRE_OHCI=y
> CONFIG_FIREWIRE_SBP2=y
> CONFIG_FIREWIRE_NOSY=y
> # CONFIG_I2O is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_MII=y
> CONFIG_NET_CORE=y
> CONFIG_DUMMY=y
> CONFIG_EQUALIZER=y
> CONFIG_NET_FC=y
> CONFIG_IFB=y
> # CONFIG_NET_TEAM is not set
> CONFIG_MACVLAN=y
> CONFIG_MACVTAP=y
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> CONFIG_NTB_NETDEV=y
> CONFIG_TUN=y
> CONFIG_VETH=y
> CONFIG_VIRTIO_NET=y
> CONFIG_NLMON=y
> CONFIG_ARCNET=y
> # CONFIG_ARCNET_1201 is not set
> # CONFIG_ARCNET_1051 is not set
> CONFIG_ARCNET_RAW=y
> CONFIG_ARCNET_CAP=y
> CONFIG_ARCNET_COM90xx=y
> # CONFIG_ARCNET_COM90xxIO is not set
> CONFIG_ARCNET_RIM_I=y
> # CONFIG_ARCNET_COM20020 is not set
> # CONFIG_ATM_DRIVERS is not set
> 
> #
> # CAIF transport drivers
> #
> CONFIG_CAIF_TTY=y
> CONFIG_CAIF_SPI_SLAVE=y
> # CONFIG_CAIF_SPI_SYNC is not set
> # CONFIG_CAIF_HSI is not set
> CONFIG_CAIF_VIRTIO=y
> CONFIG_VHOST_NET=y
> CONFIG_VHOST_RING=y
> CONFIG_VHOST=y
> 
> #
> # Distributed Switch Architecture drivers
> #
> CONFIG_NET_DSA_MV88E6XXX=y
> CONFIG_NET_DSA_MV88E6060=y
> CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
> CONFIG_NET_DSA_MV88E6131=y
> CONFIG_NET_DSA_MV88E6123_61_65=y
> CONFIG_ETHERNET=y
> CONFIG_MDIO=y
> # CONFIG_NET_VENDOR_3COM is not set
> CONFIG_NET_VENDOR_ADAPTEC=y
> CONFIG_ADAPTEC_STARFIRE=y
> CONFIG_NET_VENDOR_ALTEON=y
> # CONFIG_ACENIC is not set
> CONFIG_ALTERA_TSE=y
> CONFIG_NET_VENDOR_AMD=y
> CONFIG_AMD8111_ETH=y
> CONFIG_LANCE=y
> CONFIG_PCNET32=y
> # CONFIG_NI65 is not set
> # CONFIG_NET_VENDOR_ARC is not set
> # CONFIG_NET_VENDOR_ATHEROS is not set
> CONFIG_NET_CADENCE=y
> # CONFIG_ARM_AT91_ETHER is not set
> CONFIG_MACB=y
> # CONFIG_NET_VENDOR_BROADCOM is not set
> CONFIG_NET_VENDOR_BROCADE=y
> CONFIG_BNA=y
> CONFIG_NET_CALXEDA_XGMAC=y
> CONFIG_NET_VENDOR_CHELSIO=y
> CONFIG_CHELSIO_T1=y
> CONFIG_CHELSIO_T1_1G=y
> # CONFIG_CHELSIO_T4 is not set
> # CONFIG_CHELSIO_T4VF is not set
> CONFIG_NET_VENDOR_CIRRUS=y
> # CONFIG_CS89x0 is not set
> CONFIG_NET_VENDOR_CISCO=y
> CONFIG_ENIC=y
> CONFIG_DNET=y
> CONFIG_NET_VENDOR_DEC=y
> CONFIG_NET_TULIP=y
> CONFIG_DE2104X=y
> CONFIG_DE2104X_DSL=0
> CONFIG_TULIP=y
> # CONFIG_TULIP_MWI is not set
> CONFIG_TULIP_MMIO=y
> # CONFIG_TULIP_NAPI is not set
> CONFIG_DE4X5=y
> CONFIG_WINBOND_840=y
> CONFIG_DM9102=y
> CONFIG_ULI526X=y
> # CONFIG_NET_VENDOR_DLINK is not set
> CONFIG_NET_VENDOR_EMULEX=y
> CONFIG_BE2NET=y
> CONFIG_NET_VENDOR_EXAR=y
> CONFIG_S2IO=y
> CONFIG_VXGE=y
> CONFIG_VXGE_DEBUG_TRACE_ALL=y
> # CONFIG_NET_VENDOR_HP is not set
> CONFIG_NET_VENDOR_INTEL=y
> CONFIG_E100=y
> CONFIG_E1000=y
> CONFIG_E1000E=y
> CONFIG_IGB=y
> # CONFIG_IGB_HWMON is not set
> CONFIG_IGBVF=y
> CONFIG_IXGB=y
> # CONFIG_IXGBE is not set
> # CONFIG_IXGBEVF is not set
> # CONFIG_I40E is not set
> CONFIG_I40EVF=y
> CONFIG_NET_VENDOR_I825XX=y
> CONFIG_IP1000=y
> # CONFIG_JME is not set
> CONFIG_NET_VENDOR_MARVELL=y
> CONFIG_MVMDIO=y
> CONFIG_SKGE=y
> # CONFIG_SKGE_DEBUG is not set
> CONFIG_SKGE_GENESIS=y
> CONFIG_SKY2=y
> # CONFIG_SKY2_DEBUG is not set
> CONFIG_NET_VENDOR_MELLANOX=y
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> # CONFIG_MLX5_CORE is not set
> CONFIG_NET_VENDOR_MICREL=y
> # CONFIG_KS8842 is not set
> CONFIG_KS8851=y
> CONFIG_KS8851_MLL=y
> # CONFIG_KSZ884X_PCI is not set
> CONFIG_NET_VENDOR_MICROCHIP=y
> # CONFIG_ENC28J60 is not set
> CONFIG_FEALNX=y
> CONFIG_NET_VENDOR_NATSEMI=y
> # CONFIG_NATSEMI is not set
> CONFIG_NS83820=y
> # CONFIG_NET_VENDOR_8390 is not set
> CONFIG_NET_VENDOR_NVIDIA=y
> CONFIG_FORCEDETH=y
> CONFIG_NET_VENDOR_OKI=y
> # CONFIG_PCH_GBE is not set
> # CONFIG_ETHOC is not set
> # CONFIG_NET_PACKET_ENGINE is not set
> # CONFIG_NET_VENDOR_QLOGIC is not set
> # CONFIG_NET_VENDOR_REALTEK is not set
> # CONFIG_SH_ETH is not set
> CONFIG_NET_VENDOR_RDC=y
> CONFIG_R6040=y
> CONFIG_NET_VENDOR_SAMSUNG=y
> # CONFIG_SXGBE_ETH is not set
> CONFIG_NET_VENDOR_SEEQ=y
> CONFIG_NET_VENDOR_SILAN=y
> CONFIG_SC92031=y
> CONFIG_NET_VENDOR_SIS=y
> CONFIG_SIS900=y
> CONFIG_SIS190=y
> CONFIG_SFC=y
> # CONFIG_SFC_MCDI_MON is not set
> CONFIG_NET_VENDOR_SMSC=y
> # CONFIG_SMC9194 is not set
> CONFIG_EPIC100=y
> CONFIG_SMSC911X=y
> # CONFIG_SMSC911X_ARCH_HOOKS is not set
> # CONFIG_SMSC9420 is not set
> # CONFIG_NET_VENDOR_STMICRO is not set
> # CONFIG_NET_VENDOR_SUN is not set
> # CONFIG_NET_VENDOR_TEHUTI is not set
> # CONFIG_NET_VENDOR_TI is not set
> CONFIG_NET_VENDOR_VIA=y
> CONFIG_VIA_RHINE=y
> CONFIG_VIA_RHINE_MMIO=y
> CONFIG_VIA_VELOCITY=y
> # CONFIG_NET_VENDOR_WIZNET is not set
> CONFIG_FDDI=y
> # CONFIG_DEFXX is not set
> CONFIG_SKFP=y
> CONFIG_NET_SB1000=y
> CONFIG_PHYLIB=y
> 
> #
> # MII PHY device drivers
> #
> CONFIG_AT803X_PHY=y
> CONFIG_AMD_PHY=y
> CONFIG_MARVELL_PHY=y
> # CONFIG_DAVICOM_PHY is not set
> # CONFIG_QSEMI_PHY is not set
> CONFIG_LXT_PHY=y
> # CONFIG_CICADA_PHY is not set
> CONFIG_VITESSE_PHY=y
> CONFIG_SMSC_PHY=y
> # CONFIG_BROADCOM_PHY is not set
> CONFIG_BCM7XXX_PHY=y
> CONFIG_BCM87XX_PHY=y
> CONFIG_ICPLUS_PHY=y
> # CONFIG_REALTEK_PHY is not set
> CONFIG_NATIONAL_PHY=y
> CONFIG_STE10XP=y
> CONFIG_LSI_ET1011C_PHY=y
> CONFIG_MICREL_PHY=y
> CONFIG_FIXED_PHY=y
> CONFIG_MDIO_BITBANG=y
> CONFIG_MICREL_KS8995MA=y
> # CONFIG_PLIP is not set
> # CONFIG_PPP is not set
> CONFIG_SLIP=y
> CONFIG_SLHC=y
> CONFIG_SLIP_COMPRESSED=y
> # CONFIG_SLIP_SMART is not set
> CONFIG_SLIP_MODE_SLIP6=y
> 
> #
> # USB Network Adapters
> #
> CONFIG_USB_CATC=y
> CONFIG_USB_KAWETH=y
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> CONFIG_USB_RTL8152=y
> CONFIG_USB_USBNET=y
> CONFIG_USB_NET_AX8817X=y
> # CONFIG_USB_NET_AX88179_178A is not set
> CONFIG_USB_NET_CDCETHER=y
> CONFIG_USB_NET_CDC_EEM=y
> CONFIG_USB_NET_CDC_NCM=y
> CONFIG_USB_NET_HUAWEI_CDC_NCM=y
> CONFIG_USB_NET_CDC_MBIM=y
> # CONFIG_USB_NET_DM9601 is not set
> # CONFIG_USB_NET_SR9700 is not set
> CONFIG_USB_NET_SR9800=y
> CONFIG_USB_NET_SMSC75XX=y
> CONFIG_USB_NET_SMSC95XX=y
> CONFIG_USB_NET_GL620A=y
> # CONFIG_USB_NET_NET1080 is not set
> CONFIG_USB_NET_PLUSB=y
> CONFIG_USB_NET_MCS7830=y
> CONFIG_USB_NET_RNDIS_HOST=y
> # CONFIG_USB_NET_CDC_SUBSET is not set
> CONFIG_USB_NET_ZAURUS=y
> CONFIG_USB_NET_CX82310_ETH=y
> # CONFIG_USB_NET_KALMIA is not set
> # CONFIG_USB_NET_QMI_WWAN is not set
> CONFIG_USB_HSO=y
> CONFIG_USB_NET_INT51X1=y
> CONFIG_USB_CDC_PHONET=y
> CONFIG_USB_IPHETH=y
> # CONFIG_USB_SIERRA_NET is not set
> CONFIG_USB_VL600=y
> # CONFIG_WLAN is not set
> 
> #
> # WiMAX Wireless Broadband devices
> #
> CONFIG_WIMAX_I2400M=y
> CONFIG_WIMAX_I2400M_USB=y
> CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
> # CONFIG_WAN is not set
> # CONFIG_IEEE802154_DRIVERS is not set
> CONFIG_HYPERV_NET=y
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> CONFIG_INPUT_JOYDEV=y
> # CONFIG_INPUT_EVDEV is not set
> CONFIG_INPUT_EVBUG=y
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> # CONFIG_KEYBOARD_ADP5588 is not set
> # CONFIG_KEYBOARD_ADP5589 is not set
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_QT1070 is not set
> # CONFIG_KEYBOARD_QT2160 is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_TCA6416 is not set
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> # CONFIG_KEYBOARD_MAX7359 is not set
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_OPENCORES is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_SH_KEYSC is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> CONFIG_INPUT_MOUSE=y
> # CONFIG_MOUSE_PS2 is not set
> CONFIG_MOUSE_SERIAL=y
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> CONFIG_MOUSE_CYAPA=y
> CONFIG_MOUSE_INPORT=y
> # CONFIG_MOUSE_ATIXL is not set
> CONFIG_MOUSE_LOGIBM=y
> # CONFIG_MOUSE_PC110PAD is not set
> CONFIG_MOUSE_VSXXXAA=y
> CONFIG_MOUSE_SYNAPTICS_I2C=y
> # CONFIG_MOUSE_SYNAPTICS_USB is not set
> CONFIG_INPUT_JOYSTICK=y
> CONFIG_JOYSTICK_ANALOG=y
> # CONFIG_JOYSTICK_A3D is not set
> CONFIG_JOYSTICK_ADI=y
> CONFIG_JOYSTICK_COBRA=y
> # CONFIG_JOYSTICK_GF2K is not set
> CONFIG_JOYSTICK_GRIP=y
> # CONFIG_JOYSTICK_GRIP_MP is not set
> CONFIG_JOYSTICK_GUILLEMOT=y
> CONFIG_JOYSTICK_INTERACT=y
> CONFIG_JOYSTICK_SIDEWINDER=y
> CONFIG_JOYSTICK_TMDC=y
> # CONFIG_JOYSTICK_IFORCE is not set
> CONFIG_JOYSTICK_WARRIOR=y
> CONFIG_JOYSTICK_MAGELLAN=y
> # CONFIG_JOYSTICK_SPACEORB is not set
> CONFIG_JOYSTICK_SPACEBALL=y
> CONFIG_JOYSTICK_STINGER=y
> CONFIG_JOYSTICK_TWIDJOY=y
> CONFIG_JOYSTICK_ZHENHUA=y
> # CONFIG_JOYSTICK_DB9 is not set
> CONFIG_JOYSTICK_GAMECON=y
> CONFIG_JOYSTICK_TURBOGRAFX=y
> # CONFIG_JOYSTICK_AS5011 is not set
> CONFIG_JOYSTICK_JOYDUMP=y
> CONFIG_JOYSTICK_XPAD=y
> # CONFIG_JOYSTICK_XPAD_FF is not set
> CONFIG_JOYSTICK_XPAD_LEDS=y
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> CONFIG_SERIO_CT82C710=y
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> # CONFIG_SERIO_ARC_PS2 is not set
> # CONFIG_SERIO_OLPC_APSP is not set
> CONFIG_HYPERV_KEYBOARD=y
> CONFIG_GAMEPORT=y
> # CONFIG_GAMEPORT_NS558 is not set
> CONFIG_GAMEPORT_L4=y
> CONFIG_GAMEPORT_EMU10K1=y
> CONFIG_GAMEPORT_FM801=y
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> CONFIG_SERIAL_NONSTANDARD=y
> CONFIG_ROCKETPORT=y
> CONFIG_CYCLADES=y
> # CONFIG_CYZ_INTR is not set
> CONFIG_MOXA_INTELLIO=y
> CONFIG_MOXA_SMARTIO=y
> # CONFIG_SYNCLINK is not set
> # CONFIG_SYNCLINKMP is not set
> CONFIG_SYNCLINK_GT=y
> # CONFIG_NOZOMI is not set
> CONFIG_ISI=y
> CONFIG_N_HDLC=y
> CONFIG_N_GSM=y
> # CONFIG_TRACE_ROUTER is not set
> CONFIG_TRACE_SINK=y
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_DMA=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> # CONFIG_SERIAL_8250_FOURPORT is not set
> # CONFIG_SERIAL_8250_ACCENT is not set
> CONFIG_SERIAL_8250_BOCA=y
> CONFIG_SERIAL_8250_EXAR_ST16C554=y
> # CONFIG_SERIAL_8250_HUB6 is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_CLPS711X is not set
> CONFIG_SERIAL_MAX3100=y
> # CONFIG_SERIAL_MAX310X is not set
> CONFIG_SERIAL_MRST_MAX3110=y
> CONFIG_SERIAL_MFD_HSU=y
> # CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
> # CONFIG_SERIAL_SH_SCI is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_TIMBERDALE is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> CONFIG_SERIAL_PCH_UART=y
> # CONFIG_SERIAL_PCH_UART_CONSOLE is not set
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> CONFIG_SERIAL_RP2=y
> CONFIG_SERIAL_RP2_NR_UARTS=32
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_ST_ASC is not set
> CONFIG_PRINTER=y
> # CONFIG_LP_CONSOLE is not set
> CONFIG_PPDEV=y
> CONFIG_HVC_DRIVER=y
> CONFIG_VIRTIO_CONSOLE=y
> CONFIG_IPMI_HANDLER=y
> CONFIG_IPMI_PANIC_EVENT=y
> CONFIG_IPMI_PANIC_STRING=y
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_WATCHDOG is not set
> # CONFIG_IPMI_POWEROFF is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_NVRAM=y
> CONFIG_DTLK=y
> CONFIG_R3964=y
> CONFIG_APPLICOM=y
> CONFIG_SONYPI=y
> CONFIG_MWAVE=y
> # CONFIG_PC8736x_GPIO is not set
> # CONFIG_NSC_GPIO is not set
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> # CONFIG_TCG_TIS_I2C_ATMEL is not set
> CONFIG_TCG_TIS_I2C_INFINEON=y
> # CONFIG_TCG_TIS_I2C_NUVOTON is not set
> CONFIG_TCG_NSC=y
> CONFIG_TCG_ATMEL=y
> CONFIG_TCG_INFINEON=y
> # CONFIG_TELCLOCK is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> # CONFIG_I2C_CHARDEV is not set
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> CONFIG_I2C_ALI1535=y
> CONFIG_I2C_ALI1563=y
> CONFIG_I2C_ALI15X3=y
> CONFIG_I2C_AMD756=y
> CONFIG_I2C_AMD756_S4882=y
> CONFIG_I2C_AMD8111=y
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> CONFIG_I2C_PIIX4=y
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> CONFIG_I2C_SIS630=y
> CONFIG_I2C_SIS96X=y
> CONFIG_I2C_VIA=y
> CONFIG_I2C_VIAPRO=y
> 
> #
> # ACPI drivers
> #
> CONFIG_I2C_SCMI=y
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_DESIGNWARE_CORE=y
> CONFIG_I2C_DESIGNWARE_PLATFORM=y
> CONFIG_I2C_DESIGNWARE_PCI=y
> CONFIG_I2C_EG20T=y
> # CONFIG_I2C_OCORES is not set
> CONFIG_I2C_PCA_PLATFORM=y
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_RIIC is not set
> # CONFIG_I2C_SH_MOBILE is not set
> CONFIG_I2C_SIMTEC=y
> # CONFIG_I2C_XILINX is not set
> # CONFIG_I2C_RCAR is not set
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> # CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
> 
> #
> # Other I2C/SMBus bus drivers
> #
> CONFIG_I2C_PCA_ISA=y
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> CONFIG_SPI=y
> # CONFIG_SPI_DEBUG is not set
> CONFIG_SPI_MASTER=y
> 
> #
> # SPI Master Controller Drivers
> #
> CONFIG_SPI_ALTERA=y
> # CONFIG_SPI_ATMEL is not set
> # CONFIG_SPI_BCM2835 is not set
> # CONFIG_SPI_BCM63XX_HSSPI is not set
> CONFIG_SPI_BITBANG=y
> CONFIG_SPI_BUTTERFLY=y
> # CONFIG_SPI_CLPS711X is not set
> # CONFIG_SPI_EP93XX is not set
> # CONFIG_SPI_IMX is not set
> # CONFIG_SPI_LM70_LLP is not set
> # CONFIG_SPI_FSL_DSPI is not set
> # CONFIG_SPI_TI_QSPI is not set
> # CONFIG_SPI_OMAP_100K is not set
> # CONFIG_SPI_ORION is not set
> CONFIG_SPI_PXA2XX_DMA=y
> CONFIG_SPI_PXA2XX=y
> CONFIG_SPI_PXA2XX_PCI=y
> # CONFIG_SPI_SC18IS602 is not set
> # CONFIG_SPI_SH is not set
> # CONFIG_SPI_SH_HSPI is not set
> # CONFIG_SPI_SUN4I is not set
> # CONFIG_SPI_SUN6I is not set
> # CONFIG_SPI_TEGRA114 is not set
> # CONFIG_SPI_TEGRA20_SFLASH is not set
> # CONFIG_SPI_TEGRA20_SLINK is not set
> CONFIG_SPI_TOPCLIFF_PCH=y
> CONFIG_SPI_XCOMM=y
> CONFIG_SPI_XILINX=y
> # CONFIG_SPI_XTENSA_XTFPGA is not set
> CONFIG_SPI_DESIGNWARE=y
> CONFIG_SPI_DW_PCI=y
> CONFIG_SPI_DW_MID_DMA=y
> # CONFIG_SPI_DW_MMIO is not set
> 
> #
> # SPI Protocol Masters
> #
> CONFIG_SPI_SPIDEV=y
> # CONFIG_SPI_TLE62X0 is not set
> # CONFIG_SPMI is not set
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> 
> #
> # PPS clients support
> #
> CONFIG_PPS_CLIENT_KTIMER=y
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> CONFIG_W1=y
> CONFIG_W1_CON=y
> 
> #
> # 1-wire Bus Masters
> #
> CONFIG_W1_MASTER_MATROX=y
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_MXC is not set
> CONFIG_W1_MASTER_DS1WM=y
> 
> #
> # 1-wire Slaves
> #
> # CONFIG_W1_SLAVE_THERM is not set
> CONFIG_W1_SLAVE_SMEM=y
> # CONFIG_W1_SLAVE_DS2408 is not set
> # CONFIG_W1_SLAVE_DS2413 is not set
> CONFIG_W1_SLAVE_DS2423=y
> CONFIG_W1_SLAVE_DS2431=y
> CONFIG_W1_SLAVE_DS2433=y
> # CONFIG_W1_SLAVE_DS2433_CRC is not set
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> CONFIG_W1_SLAVE_DS28E04=y
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> CONFIG_GENERIC_ADC_BATTERY=y
> CONFIG_MAX8925_POWER=y
> # CONFIG_WM8350_POWER is not set
> CONFIG_TEST_POWER=y
> CONFIG_BATTERY_88PM860X=y
> # CONFIG_BATTERY_DS2760 is not set
> CONFIG_BATTERY_DS2780=y
> # CONFIG_BATTERY_DS2781 is not set
> CONFIG_BATTERY_DS2782=y
> CONFIG_BATTERY_SBS=y
> CONFIG_BATTERY_BQ27x00=y
> # CONFIG_BATTERY_BQ27X00_I2C is not set
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> CONFIG_BATTERY_DA9052=y
> CONFIG_BATTERY_MAX17040=y
> CONFIG_BATTERY_MAX17042=y
> # CONFIG_CHARGER_88PM860X is not set
> CONFIG_CHARGER_PCF50633=y
> CONFIG_CHARGER_ISP1704=y
> # CONFIG_CHARGER_MAX8903 is not set
> # CONFIG_CHARGER_LP8727 is not set
> # CONFIG_CHARGER_MANAGER is not set
> CONFIG_CHARGER_MAX8997=y
> CONFIG_CHARGER_BQ2415X=y
> CONFIG_CHARGER_SMB347=y
> CONFIG_CHARGER_TPS65090=y
> # CONFIG_BATTERY_GOLDFISH is not set
> # CONFIG_POWER_RESET is not set
> CONFIG_POWER_AVS=y
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> # CONFIG_HWMON_DEBUG_CHIP is not set
> 
> #
> # Native drivers
> #
> CONFIG_SENSORS_ABITUGURU=y
> CONFIG_SENSORS_ABITUGURU3=y
> CONFIG_SENSORS_AD7314=y
> CONFIG_SENSORS_AD7414=y
> CONFIG_SENSORS_AD7418=y
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> CONFIG_SENSORS_ADM9240=y
> CONFIG_SENSORS_ADT7X10=y
> CONFIG_SENSORS_ADT7310=y
> # CONFIG_SENSORS_ADT7410 is not set
> # CONFIG_SENSORS_ADT7411 is not set
> CONFIG_SENSORS_ADT7462=y
> CONFIG_SENSORS_ADT7470=y
> CONFIG_SENSORS_ADT7475=y
> CONFIG_SENSORS_ASC7621=y
> CONFIG_SENSORS_K8TEMP=y
> CONFIG_SENSORS_K10TEMP=y
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=y
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS620 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_DA9052_ADC is not set
> CONFIG_SENSORS_I5K_AMB=y
> CONFIG_SENSORS_F71805F=y
> CONFIG_SENSORS_F71882FG=y
> # CONFIG_SENSORS_F75375S is not set
> CONFIG_SENSORS_MC13783_ADC=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_GL518SM=y
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_G760A is not set
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IBMAEM=y
> CONFIG_SENSORS_IBMPEX=y
> # CONFIG_SENSORS_IIO_HWMON is not set
> CONFIG_SENSORS_CORETEMP=y
> CONFIG_SENSORS_IT87=y
> CONFIG_SENSORS_JC42=y
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> # CONFIG_SENSORS_LTC4215 is not set
> # CONFIG_SENSORS_LTC4222 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_LTC4260 is not set
> # CONFIG_SENSORS_LTC4261 is not set
> CONFIG_SENSORS_MAX1111=y
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> # CONFIG_SENSORS_MAX197 is not set
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> CONFIG_SENSORS_MAX6650=y
> # CONFIG_SENSORS_MAX6697 is not set
> CONFIG_SENSORS_HTU21=y
> # CONFIG_SENSORS_MCP3021 is not set
> # CONFIG_SENSORS_ADCXX is not set
> CONFIG_SENSORS_LM63=y
> # CONFIG_SENSORS_LM70 is not set
> # CONFIG_SENSORS_LM73 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> CONFIG_SENSORS_LM78=y
> CONFIG_SENSORS_LM80=y
> CONFIG_SENSORS_LM83=y
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> CONFIG_SENSORS_LM90=y
> CONFIG_SENSORS_LM92=y
> CONFIG_SENSORS_LM93=y
> CONFIG_SENSORS_LM95234=y
> CONFIG_SENSORS_LM95241=y
> CONFIG_SENSORS_LM95245=y
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> CONFIG_SENSORS_NCT6775=y
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT21=y
> CONFIG_SENSORS_SIS5595=y
> CONFIG_SENSORS_DME1737=y
> # CONFIG_SENSORS_EMC1403 is not set
> CONFIG_SENSORS_EMC2103=y
> # CONFIG_SENSORS_EMC6W201 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> CONFIG_SENSORS_SCH56XX_COMMON=y
> CONFIG_SENSORS_SCH5627=y
> # CONFIG_SENSORS_SCH5636 is not set
> CONFIG_SENSORS_SMM665=y
> # CONFIG_SENSORS_ADC128D818 is not set
> CONFIG_SENSORS_ADS1015=y
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_ADS7871=y
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> # CONFIG_SENSORS_INA2XX is not set
> CONFIG_SENSORS_THMC50=y
> # CONFIG_SENSORS_TMP102 is not set
> # CONFIG_SENSORS_TMP401 is not set
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> CONFIG_SENSORS_W83792D=y
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> CONFIG_SENSORS_W83L785TS=y
> CONFIG_SENSORS_W83L786NG=y
> CONFIG_SENSORS_W83627HF=y
> CONFIG_SENSORS_W83627EHF=y
> CONFIG_SENSORS_WM8350=y
> 
> #
> # ACPI drivers
> #
> CONFIG_SENSORS_ACPI_POWER=y
> CONFIG_SENSORS_ATK0110=y
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> CONFIG_THERMAL_GOV_STEP_WISE=y
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> # CONFIG_RCAR_THERMAL is not set
> CONFIG_INTEL_POWERCLAMP=y
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> CONFIG_WATCHDOG=y
> CONFIG_WATCHDOG_CORE=y
> CONFIG_WATCHDOG_NOWAYOUT=y
> 
> #
> # Watchdog Device Drivers
> #
> CONFIG_SOFT_WATCHDOG=y
> CONFIG_DA9052_WATCHDOG=y
> CONFIG_WM8350_WATCHDOG=y
> # CONFIG_XILINX_WATCHDOG is not set
> CONFIG_DW_WATCHDOG=y
> CONFIG_RETU_WATCHDOG=y
> # CONFIG_TEGRA_WATCHDOG is not set
> CONFIG_ACQUIRE_WDT=y
> # CONFIG_ADVANTECH_WDT is not set
> # CONFIG_ALIM1535_WDT is not set
> # CONFIG_ALIM7101_WDT is not set
> # CONFIG_F71808E_WDT is not set
> CONFIG_SP5100_TCO=y
> CONFIG_SBC_FITPC2_WATCHDOG=y
> # CONFIG_EUROTECH_WDT is not set
> CONFIG_IB700_WDT=y
> CONFIG_IBMASR=y
> # CONFIG_WAFER_WDT is not set
> CONFIG_I6300ESB_WDT=y
> # CONFIG_IE6XX_WDT is not set
> CONFIG_ITCO_WDT=y
> CONFIG_ITCO_VENDOR_SUPPORT=y
> CONFIG_IT8712F_WDT=y
> CONFIG_IT87_WDT=y
> CONFIG_HP_WATCHDOG=y
> # CONFIG_HPWDT_NMI_DECODING is not set
> CONFIG_SC1200_WDT=y
> CONFIG_PC87413_WDT=y
> CONFIG_NV_TCO=y
> CONFIG_60XX_WDT=y
> CONFIG_SBC8360_WDT=y
> # CONFIG_SBC7240_WDT is not set
> # CONFIG_CPU5_WDT is not set
> CONFIG_SMSC_SCH311X_WDT=y
> CONFIG_SMSC37B787_WDT=y
> # CONFIG_VIA_WDT is not set
> CONFIG_W83627HF_WDT=y
> CONFIG_W83697HF_WDT=y
> # CONFIG_W83697UG_WDT is not set
> # CONFIG_W83877F_WDT is not set
> CONFIG_W83977F_WDT=y
> CONFIG_MACHZ_WDT=y
> # CONFIG_SBC_EPX_C3_WATCHDOG is not set
> 
> #
> # ISA-based Watchdog Cards
> #
> CONFIG_PCWATCHDOG=y
> CONFIG_MIXCOMWD=y
> # CONFIG_WDT is not set
> 
> #
> # PCI-based Watchdog Cards
> #
> # CONFIG_PCIPCWATCHDOG is not set
> # CONFIG_WDTPCI is not set
> 
> #
> # USB-based Watchdog Cards
> #
> CONFIG_USBPCWATCHDOG=y
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_DEBUG is not set
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> CONFIG_SSB_DRIVER_PCICORE=y
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> CONFIG_MFD_CS5535=y
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_PMIC_ADP5520 is not set
> CONFIG_MFD_BCM590XX=y
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_PMIC_DA903X is not set
> CONFIG_PMIC_DA9052=y
> CONFIG_MFD_DA9052_SPI=y
> # CONFIG_MFD_DA9052_I2C is not set
> # CONFIG_MFD_DA9055 is not set
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13XXX=y
> # CONFIG_MFD_MC13XXX_SPI is not set
> CONFIG_MFD_MC13XXX_I2C=y
> # CONFIG_HTC_PASIC3 is not set
> CONFIG_LPC_ICH=y
> CONFIG_LPC_SCH=y
> CONFIG_MFD_JANZ_CMODIO=y
> # CONFIG_MFD_KEMPLD is not set
> CONFIG_MFD_88PM800=y
> CONFIG_MFD_88PM805=y
> CONFIG_MFD_88PM860X=y
> # CONFIG_MFD_MAX14577 is not set
> # CONFIG_MFD_MAX77686 is not set
> # CONFIG_MFD_MAX77693 is not set
> CONFIG_MFD_MAX8907=y
> CONFIG_MFD_MAX8925=y
> CONFIG_MFD_MAX8997=y
> # CONFIG_MFD_MAX8998 is not set
> CONFIG_EZX_PCAP=y
> # CONFIG_MFD_VIPERBOARD is not set
> CONFIG_MFD_RETU=y
> CONFIG_MFD_PCF50633=y
> CONFIG_PCF50633_ADC=y
> CONFIG_PCF50633_GPIO=y
> # CONFIG_MFD_RDC321X is not set
> CONFIG_MFD_RTSX_PCI=y
> # CONFIG_MFD_RTSX_USB is not set
> CONFIG_MFD_RC5T583=y
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=y
> CONFIG_MFD_SM501=y
> CONFIG_MFD_SMSC=y
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_STMPE is not set
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_MFD_LP3943=y
> CONFIG_MFD_LP8788=y
> # CONFIG_MFD_PALMAS is not set
> CONFIG_TPS6105X=y
> # CONFIG_TPS6507X is not set
> CONFIG_MFD_TPS65090=y
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS65218 is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS80031 is not set
> # CONFIG_TWL4030_CORE is not set
> # CONFIG_TWL6040_CORE is not set
> CONFIG_MFD_WL1273_CORE=y
> # CONFIG_MFD_LM3533 is not set
> # CONFIG_MFD_TC3589X is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_ARIZONA_SPI is not set
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> CONFIG_MFD_WM8997=y
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM831X_SPI is not set
> CONFIG_MFD_WM8350=y
> CONFIG_MFD_WM8350_I2C=y
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> # CONFIG_REGULATOR_88PM800 is not set
> # CONFIG_REGULATOR_88PM8607 is not set
> CONFIG_REGULATOR_ACT8865=y
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_ANATOP=y
> # CONFIG_REGULATOR_ARIZONA is not set
> # CONFIG_REGULATOR_BCM590XX is not set
> # CONFIG_REGULATOR_DA9052 is not set
> # CONFIG_REGULATOR_DA9063 is not set
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> # CONFIG_REGULATOR_LP3972 is not set
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> CONFIG_REGULATOR_MAX1586=y
> # CONFIG_REGULATOR_MAX8649 is not set
> CONFIG_REGULATOR_MAX8660=y
> # CONFIG_REGULATOR_MAX8907 is not set
> CONFIG_REGULATOR_MAX8925=y
> # CONFIG_REGULATOR_MAX8952 is not set
> CONFIG_REGULATOR_MAX8973=y
> CONFIG_REGULATOR_MAX8997=y
> CONFIG_REGULATOR_MC13XXX_CORE=y
> CONFIG_REGULATOR_MC13783=y
> # CONFIG_REGULATOR_MC13892 is not set
> CONFIG_REGULATOR_PCAP=y
> CONFIG_REGULATOR_PCF50633=y
> CONFIG_REGULATOR_PFUZE100=y
> # CONFIG_REGULATOR_RC5T583 is not set
> # CONFIG_REGULATOR_TPS51632 is not set
> # CONFIG_REGULATOR_TPS6105X is not set
> # CONFIG_REGULATOR_TPS62360 is not set
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65090=y
> # CONFIG_REGULATOR_TPS65217 is not set
> CONFIG_REGULATOR_TPS6524X=y
> CONFIG_REGULATOR_WM8350=y
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> CONFIG_AGP=y
> CONFIG_AGP_ALI=y
> # CONFIG_AGP_ATI is not set
> CONFIG_AGP_AMD=y
> CONFIG_AGP_AMD64=y
> CONFIG_AGP_INTEL=y
> # CONFIG_AGP_NVIDIA is not set
> CONFIG_AGP_SIS=y
> CONFIG_AGP_SWORKS=y
> CONFIG_AGP_VIA=y
> CONFIG_AGP_EFFICEON=y
> CONFIG_INTEL_GTT=y
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> CONFIG_DRM=y
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_KMS_FB_HELPER=y
> # CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
> CONFIG_DRM_TTM=y
> 
> #
> # I2C encoder or helper chips
> #
> CONFIG_DRM_I2C_CH7006=y
> CONFIG_DRM_I2C_SIL164=y
> CONFIG_DRM_I2C_NXP_TDA998X=y
> CONFIG_DRM_TDFX=y
> CONFIG_DRM_R128=y
> CONFIG_DRM_RADEON=y
> # CONFIG_DRM_RADEON_UMS is not set
> CONFIG_DRM_NOUVEAU=y
> CONFIG_NOUVEAU_DEBUG=5
> CONFIG_NOUVEAU_DEBUG_DEFAULT=3
> CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> # CONFIG_DRM_I810 is not set
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> # CONFIG_DRM_I915_FBDEV is not set
> CONFIG_DRM_I915_PRELIMINARY_HW_SUPPORT=y
> # CONFIG_DRM_I915_UMS is not set
> # CONFIG_DRM_MGA is not set
> CONFIG_DRM_SIS=y
> CONFIG_DRM_VIA=y
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> CONFIG_DRM_GMA500=y
> CONFIG_DRM_GMA600=y
> CONFIG_DRM_GMA3600=y
> # CONFIG_DRM_UDL is not set
> CONFIG_DRM_AST=y
> CONFIG_DRM_MGAG200=y
> CONFIG_DRM_CIRRUS_QEMU=y
> # CONFIG_DRM_QXL is not set
> # CONFIG_DRM_BOCHS is not set
> CONFIG_VGASTATE=y
> CONFIG_HDMI=y
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> CONFIG_FB_DDC=y
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> # CONFIG_FB_FOREIGN_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> CONFIG_FB_SVGALIB=y
> # CONFIG_FB_MACMODES is not set
> CONFIG_FB_BACKLIGHT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> 
> #
> # Frame buffer hardware drivers
> #
> CONFIG_FB_CIRRUS=y
> CONFIG_FB_PM2=y
> # CONFIG_FB_PM2_FIFO_DISCONNECT is not set
> CONFIG_FB_CYBER2000=y
> # CONFIG_FB_CYBER2000_DDC is not set
> # CONFIG_FB_ARC is not set
> # CONFIG_FB_ASILIANT is not set
> CONFIG_FB_IMSTT=y
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_UVESA=y
> # CONFIG_FB_VESA is not set
> CONFIG_FB_EFI=y
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> CONFIG_FB_OPENCORES=y
> # CONFIG_FB_S1D13XXX is not set
> CONFIG_FB_NVIDIA=y
> CONFIG_FB_NVIDIA_I2C=y
> CONFIG_FB_NVIDIA_DEBUG=y
> CONFIG_FB_NVIDIA_BACKLIGHT=y
> CONFIG_FB_RIVA=y
> CONFIG_FB_RIVA_I2C=y
> CONFIG_FB_RIVA_DEBUG=y
> # CONFIG_FB_RIVA_BACKLIGHT is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_I810 is not set
> CONFIG_FB_LE80578=y
> CONFIG_FB_CARILLO_RANCH=y
> CONFIG_FB_MATROX=y
> CONFIG_FB_MATROX_MILLENIUM=y
> # CONFIG_FB_MATROX_MYSTIQUE is not set
> CONFIG_FB_MATROX_G=y
> CONFIG_FB_MATROX_I2C=y
> CONFIG_FB_MATROX_MAVEN=y
> CONFIG_FB_RADEON=y
> CONFIG_FB_RADEON_I2C=y
> # CONFIG_FB_RADEON_BACKLIGHT is not set
> # CONFIG_FB_RADEON_DEBUG is not set
> CONFIG_FB_ATY128=y
> CONFIG_FB_ATY128_BACKLIGHT=y
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> CONFIG_FB_NEOMAGIC=y
> CONFIG_FB_KYRO=y
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> CONFIG_FB_VT8623=y
> CONFIG_FB_TRIDENT=y
> CONFIG_FB_ARK=y
> CONFIG_FB_PM3=y
> CONFIG_FB_CARMINE=y
> CONFIG_FB_CARMINE_DRAM_EVAL=y
> # CONFIG_CARMINE_DRAM_CUSTOM is not set
> # CONFIG_FB_GEODE is not set
> CONFIG_FB_TMIO=y
> CONFIG_FB_TMIO_ACCELL=y
> CONFIG_FB_SM501=y
> CONFIG_FB_SMSCUFX=y
> CONFIG_FB_UDL=y
> # CONFIG_FB_GOLDFISH is not set
> CONFIG_FB_VIRTUAL=y
> CONFIG_FB_METRONOME=y
> CONFIG_FB_MB862XX=y
> CONFIG_FB_MB862XX_PCI_GDC=y
> # CONFIG_FB_MB862XX_I2C is not set
> CONFIG_FB_BROADSHEET=y
> # CONFIG_FB_AUO_K190X is not set
> # CONFIG_FB_HYPERV is not set
> # CONFIG_FB_SIMPLE is not set
> CONFIG_EXYNOS_VIDEO=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> CONFIG_LCD_LTV350QV=y
> CONFIG_LCD_ILI922X=y
> # CONFIG_LCD_ILI9320 is not set
> # CONFIG_LCD_TDO24M is not set
> # CONFIG_LCD_VGG2432A4 is not set
> CONFIG_LCD_PLATFORM=y
> # CONFIG_LCD_S6E63M0 is not set
> CONFIG_LCD_LD9040=y
> CONFIG_LCD_AMS369FG06=y
> CONFIG_LCD_LMS501KF03=y
> CONFIG_LCD_HX8357=y
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> # CONFIG_BACKLIGHT_GENERIC is not set
> CONFIG_BACKLIGHT_CARILLO_RANCH=y
> CONFIG_BACKLIGHT_PWM=y
> # CONFIG_BACKLIGHT_DA9052 is not set
> CONFIG_BACKLIGHT_MAX8925=y
> # CONFIG_BACKLIGHT_APPLE is not set
> CONFIG_BACKLIGHT_SAHARA=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_88PM860X is not set
> # CONFIG_BACKLIGHT_PCF50633 is not set
> CONFIG_BACKLIGHT_LM3630A=y
> CONFIG_BACKLIGHT_LM3639=y
> CONFIG_BACKLIGHT_LP855X=y
> CONFIG_BACKLIGHT_LP8788=y
> CONFIG_BACKLIGHT_TPS65217=y
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_MDA_CONSOLE=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE=y
> CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
> # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> CONFIG_LOGO=y
> CONFIG_LOGO_LINUX_MONO=y
> # CONFIG_LOGO_LINUX_VGA16 is not set
> # CONFIG_LOGO_LINUX_CLUT224 is not set
> CONFIG_SOUND=y
> CONFIG_SOUND_OSS_CORE=y
> # CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
> CONFIG_SND=y
> CONFIG_SND_TIMER=y
> CONFIG_SND_PCM=y
> CONFIG_SND_HWDEP=y
> CONFIG_SND_RAWMIDI=y
> CONFIG_SND_COMPRESS_OFFLOAD=y
> CONFIG_SND_JACK=y
> CONFIG_SND_SEQUENCER=y
> CONFIG_SND_SEQ_DUMMY=y
> CONFIG_SND_OSSEMUL=y
> # CONFIG_SND_MIXER_OSS is not set
> # CONFIG_SND_PCM_OSS is not set
> CONFIG_SND_SEQUENCER_OSS=y
> # CONFIG_SND_DYNAMIC_MINORS is not set
> # CONFIG_SND_SUPPORT_OLD_API is not set
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_KCTL_JACK=y
> CONFIG_SND_DMA_SGBUF=y
> CONFIG_SND_RAWMIDI_SEQ=y
> CONFIG_SND_OPL3_LIB_SEQ=y
> CONFIG_SND_OPL4_LIB_SEQ=y
> CONFIG_SND_SBAWE_SEQ=y
> CONFIG_SND_EMU10K1_SEQ=y
> CONFIG_SND_MPU401_UART=y
> CONFIG_SND_OPL3_LIB=y
> CONFIG_SND_OPL4_LIB=y
> CONFIG_SND_AC97_CODEC=y
> # CONFIG_SND_DRIVERS is not set
> CONFIG_SND_WSS_LIB=y
> CONFIG_SND_SB_COMMON=y
> CONFIG_SND_SB8_DSP=y
> CONFIG_SND_SB16_DSP=y
> CONFIG_SND_ISA=y
> CONFIG_SND_ADLIB=y
> CONFIG_SND_AD1816A=y
> # CONFIG_SND_AD1848 is not set
> CONFIG_SND_ALS100=y
> CONFIG_SND_AZT1605=y
> CONFIG_SND_AZT2316=y
> # CONFIG_SND_AZT2320 is not set
> # CONFIG_SND_CMI8328 is not set
> CONFIG_SND_CMI8330=y
> # CONFIG_SND_CS4231 is not set
> # CONFIG_SND_CS4236 is not set
> CONFIG_SND_ES1688=y
> CONFIG_SND_ES18XX=y
> CONFIG_SND_SC6000=y
> # CONFIG_SND_GUSCLASSIC is not set
> CONFIG_SND_GUSEXTREME=y
> CONFIG_SND_GUSMAX=y
> # CONFIG_SND_INTERWAVE is not set
> CONFIG_SND_INTERWAVE_STB=y
> CONFIG_SND_JAZZ16=y
> # CONFIG_SND_OPL3SA2 is not set
> # CONFIG_SND_OPTI92X_AD1848 is not set
> CONFIG_SND_OPTI92X_CS4231=y
> CONFIG_SND_OPTI93X=y
> # CONFIG_SND_MIRO is not set
> # CONFIG_SND_SB8 is not set
> CONFIG_SND_SB16=y
> CONFIG_SND_SBAWE=y
> # CONFIG_SND_SB16_CSP is not set
> CONFIG_SND_SSCAPE=y
> CONFIG_SND_WAVEFRONT=y
> CONFIG_SND_MSND_PINNACLE=y
> CONFIG_SND_MSND_CLASSIC=y
> CONFIG_SND_PCI=y
> CONFIG_SND_AD1889=y
> # CONFIG_SND_ALS300 is not set
> CONFIG_SND_ALS4000=y
> CONFIG_SND_ALI5451=y
> CONFIG_SND_ASIHPI=y
> CONFIG_SND_ATIIXP=y
> # CONFIG_SND_ATIIXP_MODEM is not set
> CONFIG_SND_AU8810=y
> CONFIG_SND_AU8820=y
> CONFIG_SND_AU8830=y
> CONFIG_SND_AW2=y
> CONFIG_SND_AZT3328=y
> CONFIG_SND_BT87X=y
> # CONFIG_SND_BT87X_OVERCLOCK is not set
> # CONFIG_SND_CA0106 is not set
> CONFIG_SND_CMIPCI=y
> CONFIG_SND_OXYGEN_LIB=y
> # CONFIG_SND_OXYGEN is not set
> CONFIG_SND_CS4281=y
> CONFIG_SND_CS46XX=y
> # CONFIG_SND_CS46XX_NEW_DSP is not set
> # CONFIG_SND_CS5530 is not set
> CONFIG_SND_CS5535AUDIO=y
> # CONFIG_SND_CTXFI is not set
> # CONFIG_SND_DARLA20 is not set
> CONFIG_SND_GINA20=y
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> CONFIG_SND_GINA24=y
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> CONFIG_SND_ECHO3G=y
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> CONFIG_SND_INDIGODJ=y
> CONFIG_SND_INDIGOIOX=y
> CONFIG_SND_INDIGODJX=y
> CONFIG_SND_EMU10K1=y
> CONFIG_SND_EMU10K1X=y
> CONFIG_SND_ENS1370=y
> CONFIG_SND_ENS1371=y
> CONFIG_SND_ES1938=y
> CONFIG_SND_ES1968=y
> # CONFIG_SND_ES1968_INPUT is not set
> # CONFIG_SND_FM801 is not set
> CONFIG_SND_HDSP=y
> 
> #
> # Don't forget to add built-in firmwares for HDSP driver
> #
> CONFIG_SND_HDSPM=y
> CONFIG_SND_ICE1712=y
> # CONFIG_SND_ICE1724 is not set
> CONFIG_SND_INTEL8X0=y
> CONFIG_SND_INTEL8X0M=y
> CONFIG_SND_KORG1212=y
> CONFIG_SND_LOLA=y
> # CONFIG_SND_LX6464ES is not set
> # CONFIG_SND_MAESTRO3 is not set
> CONFIG_SND_MIXART=y
> CONFIG_SND_NM256=y
> CONFIG_SND_PCXHR=y
> # CONFIG_SND_RIPTIDE is not set
> CONFIG_SND_RME32=y
> # CONFIG_SND_RME96 is not set
> CONFIG_SND_RME9652=y
> CONFIG_SND_SIS7019=y
> CONFIG_SND_SONICVIBES=y
> # CONFIG_SND_TRIDENT is not set
> CONFIG_SND_VIA82XX=y
> # CONFIG_SND_VIA82XX_MODEM is not set
> CONFIG_SND_VIRTUOSO=y
> # CONFIG_SND_VX222 is not set
> CONFIG_SND_YMFPCI=y
> 
> #
> # HD-Audio
> #
> CONFIG_SND_HDA=y
> CONFIG_SND_HDA_INTEL=y
> CONFIG_SND_HDA_PREALLOC_SIZE=64
> # CONFIG_SND_HDA_HWDEP is not set
> CONFIG_SND_HDA_RECONFIG=y
> CONFIG_SND_HDA_INPUT_BEEP=y
> CONFIG_SND_HDA_INPUT_BEEP_MODE=1
> CONFIG_SND_HDA_INPUT_JACK=y
> CONFIG_SND_HDA_PATCH_LOADER=y
> # CONFIG_SND_HDA_CODEC_REALTEK is not set
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> CONFIG_SND_HDA_CODEC_VIA=y
> CONFIG_SND_HDA_CODEC_HDMI=y
> CONFIG_SND_HDA_I915=y
> CONFIG_SND_HDA_CODEC_CIRRUS=y
> CONFIG_SND_HDA_CODEC_CONEXANT=y
> # CONFIG_SND_HDA_CODEC_CA0110 is not set
> # CONFIG_SND_HDA_CODEC_CA0132 is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> CONFIG_SND_HDA_CODEC_SI3054=y
> CONFIG_SND_HDA_GENERIC=y
> CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
> CONFIG_SND_SPI=y
> # CONFIG_SND_AT73C213 is not set
> # CONFIG_SND_USB is not set
> # CONFIG_SND_FIREWIRE is not set
> CONFIG_SND_SOC=y
> # CONFIG_SND_SOC_ADI is not set
> CONFIG_SND_ATMEL_SOC=y
> # CONFIG_SND_BCM2835_SOC_I2S is not set
> # CONFIG_SND_EP93XX_SOC is not set
> # CONFIG_SND_IMX_SOC is not set
> # CONFIG_SND_KIRKWOOD_SOC is not set
> # CONFIG_SND_SOC_INTEL_SST is not set
> # CONFIG_SND_SOC_SIRF is not set
> CONFIG_SND_SOC_I2C_AND_SPI=y
> 
> #
> # CODEC drivers
> #
> # CONFIG_SND_SOC_ALL_CODECS is not set
> # CONFIG_SND_SOC_ADAU1701 is not set
> CONFIG_SND_SOC_AK4104=y
> CONFIG_SND_SOC_AK4554=y
> CONFIG_SND_SOC_AK4642=y
> # CONFIG_SND_SOC_AK5386 is not set
> CONFIG_SND_SOC_CS42L52=y
> CONFIG_SND_SOC_CS42L73=y
> CONFIG_SND_SOC_CS4270=y
> CONFIG_SND_SOC_CS4271=y
> # CONFIG_SND_SOC_CS42XX8_I2C is not set
> # CONFIG_SND_SOC_HDMI_CODEC is not set
> CONFIG_SND_SOC_PCM1681=y
> # CONFIG_SND_SOC_PCM1792A is not set
> CONFIG_SND_SOC_PCM512x=y
> # CONFIG_SND_SOC_PCM512x_I2C is not set
> CONFIG_SND_SOC_PCM512x_SPI=y
> # CONFIG_SND_SOC_SGTL5000 is not set
> CONFIG_SND_SOC_SIRF_AUDIO_CODEC=y
> CONFIG_SND_SOC_SPDIF=y
> CONFIG_SND_SOC_TAS5086=y
> CONFIG_SND_SOC_TLV320AIC3X=y
> CONFIG_SND_SOC_WM8510=y
> CONFIG_SND_SOC_WM8523=y
> # CONFIG_SND_SOC_WM8580 is not set
> # CONFIG_SND_SOC_WM8711 is not set
> CONFIG_SND_SOC_WM8728=y
> CONFIG_SND_SOC_WM8731=y
> # CONFIG_SND_SOC_WM8737 is not set
> CONFIG_SND_SOC_WM8741=y
> # CONFIG_SND_SOC_WM8750 is not set
> CONFIG_SND_SOC_WM8753=y
> # CONFIG_SND_SOC_WM8770 is not set
> CONFIG_SND_SOC_WM8776=y
> # CONFIG_SND_SOC_WM8804 is not set
> CONFIG_SND_SOC_WM8903=y
> CONFIG_SND_SOC_WM8962=y
> CONFIG_SND_SOC_TPA6130A2=y
> CONFIG_SND_SIMPLE_CARD=y
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=y
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> # CONFIG_HID_GENERIC is not set
> 
> #
> # Special HID drivers
> #
> CONFIG_HID_A4TECH=y
> CONFIG_HID_ACRUX=y
> CONFIG_HID_ACRUX_FF=y
> CONFIG_HID_APPLE=y
> # CONFIG_HID_APPLEIR is not set
> CONFIG_HID_AUREAL=y
> CONFIG_HID_BELKIN=y
> CONFIG_HID_CHERRY=y
> CONFIG_HID_CHICONY=y
> CONFIG_HID_PRODIKEYS=y
> CONFIG_HID_CYPRESS=y
> # CONFIG_HID_DRAGONRISE is not set
> CONFIG_HID_EMS_FF=y
> # CONFIG_HID_ELECOM is not set
> CONFIG_HID_ELO=y
> CONFIG_HID_EZKEY=y
> CONFIG_HID_HOLTEK=y
> CONFIG_HOLTEK_FF=y
> CONFIG_HID_HUION=y
> CONFIG_HID_KEYTOUCH=y
> # CONFIG_HID_KYE is not set
> CONFIG_HID_UCLOGIC=y
> # CONFIG_HID_WALTOP is not set
> CONFIG_HID_GYRATION=y
> CONFIG_HID_ICADE=y
> # CONFIG_HID_TWINHAN is not set
> CONFIG_HID_KENSINGTON=y
> CONFIG_HID_LCPOWER=y
> CONFIG_HID_LENOVO_TPKBD=y
> CONFIG_HID_LOGITECH=y
> CONFIG_HID_LOGITECH_DJ=y
> # CONFIG_LOGITECH_FF is not set
> CONFIG_LOGIRUMBLEPAD2_FF=y
> # CONFIG_LOGIG940_FF is not set
> # CONFIG_LOGIWHEELS_FF is not set
> # CONFIG_HID_MAGICMOUSE is not set
> CONFIG_HID_MICROSOFT=y
> CONFIG_HID_MONTEREY=y
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTRIG is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> CONFIG_HID_PICOLCD=y
> CONFIG_HID_PICOLCD_FB=y
> CONFIG_HID_PICOLCD_BACKLIGHT=y
> CONFIG_HID_PICOLCD_LCD=y
> CONFIG_HID_PICOLCD_LEDS=y
> # CONFIG_HID_PRIMAX is not set
> CONFIG_HID_ROCCAT=y
> # CONFIG_HID_SAITEK is not set
> CONFIG_HID_SAMSUNG=y
> # CONFIG_HID_SONY is not set
> CONFIG_HID_SPEEDLINK=y
> CONFIG_HID_STEELSERIES=y
> # CONFIG_HID_SUNPLUS is not set
> CONFIG_HID_GREENASIA=y
> CONFIG_GREENASIA_FF=y
> # CONFIG_HID_HYPERV_MOUSE is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> CONFIG_HID_TOPSEED=y
> CONFIG_HID_THINGM=y
> CONFIG_HID_THRUSTMASTER=y
> # CONFIG_THRUSTMASTER_FF is not set
> CONFIG_HID_WACOM=y
> CONFIG_HID_WIIMOTE=y
> CONFIG_HID_XINMO=y
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> CONFIG_HID_SENSOR_HUB=y
> 
> #
> # USB HID support
> #
> CONFIG_USB_HID=y
> CONFIG_HID_PID=y
> CONFIG_USB_HIDDEV=y
> 
> #
> # I2C HID support
> #
> CONFIG_I2C_HID=y
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> 
> #
> # Miscellaneous USB options
> #
> # CONFIG_USB_DEFAULT_PERSIST is not set
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_OTG=y
> # CONFIG_USB_OTG_WHITELIST is not set
> CONFIG_USB_OTG_BLACKLIST_HUB=y
> # CONFIG_USB_MON is not set
> CONFIG_USB_WUSB=y
> CONFIG_USB_WUSB_CBAF=y
> CONFIG_USB_WUSB_CBAF_DEBUG=y
> 
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_XHCI_PLATFORM=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_EHCI_ROOT_HUB_TT=y
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> CONFIG_USB_OXU210HP_HCD=y
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_ISP1760_HCD=y
> CONFIG_USB_ISP1362_HCD=y
> # CONFIG_USB_FUSBH200_HCD is not set
> # CONFIG_USB_FOTG210_HCD is not set
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_OHCI_HCD_PCI=y
> # CONFIG_USB_OHCI_HCD_SSB is not set
> CONFIG_USB_OHCI_HCD_PLATFORM=y
> CONFIG_USB_UHCI_HCD=y
> CONFIG_USB_U132_HCD=y
> CONFIG_USB_SL811_HCD=y
> # CONFIG_USB_SL811_HCD_ISO is not set
> CONFIG_USB_R8A66597_HCD=y
> CONFIG_USB_RENESAS_USBHS_HCD=y
> CONFIG_USB_WHCI_HCD=y
> CONFIG_USB_HWA_HCD=y
> CONFIG_USB_HCD_SSB=y
> # CONFIG_USB_HCD_TEST_MODE is not set
> CONFIG_USB_RENESAS_USBHS=y
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> # CONFIG_USB_PRINTER is not set
> CONFIG_USB_WDM=y
> CONFIG_USB_TMC=y
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> CONFIG_USB_STORAGE_USBAT=y
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> CONFIG_USB_STORAGE_JUMPSHOT=y
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> CONFIG_USB_STORAGE_KARMA=y
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> CONFIG_USB_STORAGE_ENE_UB6250=y
> CONFIG_USB_UAS=y
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
> # CONFIG_USB_MUSB_HDRC is not set
> CONFIG_USB_DWC3=y
> CONFIG_USB_DWC3_HOST=y
> # CONFIG_USB_DWC3_GADGET is not set
> # CONFIG_USB_DWC3_DUAL_ROLE is not set
> 
> #
> # Platform Glue Driver Support
> #
> CONFIG_USB_DWC3_EXYNOS=y
> CONFIG_USB_DWC3_PCI=y
> CONFIG_USB_DWC3_KEYSTONE=y
> 
> #
> # Debugging features
> #
> CONFIG_USB_DWC3_DEBUG=y
> CONFIG_USB_DWC3_VERBOSE=y
> # CONFIG_USB_DWC2 is not set
> CONFIG_USB_CHIPIDEA=y
> CONFIG_USB_CHIPIDEA_UDC=y
> CONFIG_USB_CHIPIDEA_HOST=y
> # CONFIG_USB_CHIPIDEA_DEBUG is not set
> 
> #
> # USB port drivers
> #
> # CONFIG_USB_USS720 is not set
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> # CONFIG_USB_SERIAL_GENERIC is not set
> CONFIG_USB_SERIAL_SIMPLE=y
> CONFIG_USB_SERIAL_AIRCABLE=y
> CONFIG_USB_SERIAL_ARK3116=y
> # CONFIG_USB_SERIAL_BELKIN is not set
> CONFIG_USB_SERIAL_CH341=y
> CONFIG_USB_SERIAL_WHITEHEAT=y
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> CONFIG_USB_SERIAL_CP210X=y
> CONFIG_USB_SERIAL_CYPRESS_M8=y
> CONFIG_USB_SERIAL_EMPEG=y
> CONFIG_USB_SERIAL_FTDI_SIO=y
> CONFIG_USB_SERIAL_VISOR=y
> CONFIG_USB_SERIAL_IPAQ=y
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> CONFIG_USB_SERIAL_EDGEPORT_TI=y
> CONFIG_USB_SERIAL_F81232=y
> CONFIG_USB_SERIAL_GARMIN=y
> CONFIG_USB_SERIAL_IPW=y
> CONFIG_USB_SERIAL_IUU=y
> CONFIG_USB_SERIAL_KEYSPAN_PDA=y
> CONFIG_USB_SERIAL_KEYSPAN=y
> # CONFIG_USB_SERIAL_KEYSPAN_MPR is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28 is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA28X is not set
> CONFIG_USB_SERIAL_KEYSPAN_USA28XA=y
> # CONFIG_USB_SERIAL_KEYSPAN_USA28XB is not set
> CONFIG_USB_SERIAL_KEYSPAN_USA19=y
> # CONFIG_USB_SERIAL_KEYSPAN_USA18X is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA19W is not set
> CONFIG_USB_SERIAL_KEYSPAN_USA19QW=y
> CONFIG_USB_SERIAL_KEYSPAN_USA19QI=y
> # CONFIG_USB_SERIAL_KEYSPAN_USA49W is not set
> # CONFIG_USB_SERIAL_KEYSPAN_USA49WLC is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> CONFIG_USB_SERIAL_KOBIL_SCT=y
> CONFIG_USB_SERIAL_MCT_U232=y
> # CONFIG_USB_SERIAL_METRO is not set
> # CONFIG_USB_SERIAL_MOS7720 is not set
> CONFIG_USB_SERIAL_MOS7840=y
> # CONFIG_USB_SERIAL_MXUPORT is not set
> CONFIG_USB_SERIAL_NAVMAN=y
> # CONFIG_USB_SERIAL_PL2303 is not set
> CONFIG_USB_SERIAL_OTI6858=y
> CONFIG_USB_SERIAL_QCAUX=y
> CONFIG_USB_SERIAL_QUALCOMM=y
> CONFIG_USB_SERIAL_SPCP8X5=y
> CONFIG_USB_SERIAL_SAFE=y
> CONFIG_USB_SERIAL_SAFE_PADDED=y
> # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> CONFIG_USB_SERIAL_SYMBOL=y
> CONFIG_USB_SERIAL_TI=y
> CONFIG_USB_SERIAL_CYBERJACK=y
> # CONFIG_USB_SERIAL_XIRCOM is not set
> CONFIG_USB_SERIAL_WWAN=y
> # CONFIG_USB_SERIAL_OPTION is not set
> CONFIG_USB_SERIAL_OMNINET=y
> CONFIG_USB_SERIAL_OPTICON=y
> CONFIG_USB_SERIAL_XSENS_MT=y
> CONFIG_USB_SERIAL_WISHBONE=y
> CONFIG_USB_SERIAL_ZTE=y
> CONFIG_USB_SERIAL_SSU100=y
> CONFIG_USB_SERIAL_QT2=y
> CONFIG_USB_SERIAL_DEBUG=y
> 
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> CONFIG_USB_ADUTUX=y
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> CONFIG_USB_IDMOUSE=y
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> CONFIG_USB_SISUSBVGA=y
> # CONFIG_USB_SISUSBVGA_CON is not set
> CONFIG_USB_LD=y
> CONFIG_USB_TRANCEVIBRATOR=y
> CONFIG_USB_IOWARRIOR=y
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_EHSET_TEST_FIXTURE is not set
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> CONFIG_USB_ATM=y
> CONFIG_USB_SPEEDTOUCH=y
> CONFIG_USB_CXACRU=y
> CONFIG_USB_UEAGLEATM=y
> CONFIG_USB_XUSBATM=y
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> CONFIG_USB_OTG_FSM=y
> # CONFIG_KEYSTONE_USB_PHY is not set
> CONFIG_NOP_USB_XCEIV=y
> # CONFIG_AM335X_PHY_USB is not set
> CONFIG_SAMSUNG_USBPHY=y
> CONFIG_SAMSUNG_USB2PHY=y
> CONFIG_SAMSUNG_USB3PHY=y
> CONFIG_USB_ISP1301=y
> CONFIG_USB_RCAR_PHY=y
> # CONFIG_USB_RCAR_GEN2_PHY is not set
> CONFIG_USB_GADGET=y
> CONFIG_USB_GADGET_DEBUG=y
> CONFIG_USB_GADGET_VERBOSE=y
> # CONFIG_USB_GADGET_DEBUG_FILES is not set
> CONFIG_USB_GADGET_DEBUG_FS=y
> CONFIG_USB_GADGET_VBUS_DRAW=2
> CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2
> 
> #
> # USB Peripheral Controller
> #
> # CONFIG_USB_FOTG210_UDC is not set
> # CONFIG_USB_GR_UDC is not set
> CONFIG_USB_R8A66597=y
> CONFIG_USB_RENESAS_USBHS_UDC=y
> CONFIG_USB_PXA27X=y
> CONFIG_USB_S3C_HSOTG=y
> CONFIG_USB_MV_UDC=y
> # CONFIG_USB_MV_U3D is not set
> # CONFIG_USB_M66592 is not set
> CONFIG_USB_AMD5536UDC=y
> # CONFIG_USB_NET2272 is not set
> CONFIG_USB_NET2280=y
> CONFIG_USB_GOKU=y
> # CONFIG_USB_EG20T is not set
> CONFIG_USB_DUMMY_HCD=y
> CONFIG_USB_LIBCOMPOSITE=y
> CONFIG_USB_U_ETHER=y
> CONFIG_USB_F_ECM=y
> CONFIG_USB_F_SUBSET=y
> CONFIG_USB_F_RNDIS=y
> CONFIG_USB_F_FS=y
> # CONFIG_USB_CONFIGFS is not set
> # CONFIG_USB_ZERO is not set
> # CONFIG_USB_AUDIO is not set
> # CONFIG_USB_ETH is not set
> # CONFIG_USB_G_NCM is not set
> # CONFIG_USB_GADGETFS is not set
> CONFIG_USB_FUNCTIONFS=y
> CONFIG_USB_FUNCTIONFS_ETH=y
> CONFIG_USB_FUNCTIONFS_RNDIS=y
> # CONFIG_USB_FUNCTIONFS_GENERIC is not set
> # CONFIG_USB_MASS_STORAGE is not set
> # CONFIG_USB_GADGET_TARGET is not set
> # CONFIG_USB_G_SERIAL is not set
> # CONFIG_USB_MIDI_GADGET is not set
> # CONFIG_USB_G_PRINTER is not set
> # CONFIG_USB_CDC_COMPOSITE is not set
> # CONFIG_USB_G_NOKIA is not set
> # CONFIG_USB_G_ACM_MS is not set
> # CONFIG_USB_G_MULTI is not set
> # CONFIG_USB_G_HID is not set
> # CONFIG_USB_G_DBGP is not set
> CONFIG_UWB=y
> CONFIG_UWB_HWA=y
> CONFIG_UWB_WHCI=y
> # CONFIG_UWB_I1480U is not set
> CONFIG_MMC=y
> CONFIG_MMC_DEBUG=y
> # CONFIG_MMC_UNSAFE_RESUME is not set
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> # CONFIG_MMC_BLOCK is not set
> # CONFIG_SDIO_UART is not set
> CONFIG_MMC_TEST=y
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=y
> # CONFIG_MMC_SDHCI_PCI is not set
> CONFIG_MMC_SDHCI_ACPI=y
> CONFIG_MMC_SDHCI_PLTFM=y
> # CONFIG_MMC_OMAP_HS is not set
> CONFIG_MMC_WBSD=y
> CONFIG_MMC_TIFM_SD=y
> # CONFIG_MMC_CB710 is not set
> CONFIG_MMC_VIA_SDMMC=y
> CONFIG_MMC_VUB300=y
> CONFIG_MMC_USHC=y
> CONFIG_MMC_REALTEK_PCI=y
> # CONFIG_MEMSTICK is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> # CONFIG_LEDS_88PM860X is not set
> # CONFIG_LEDS_LM3530 is not set
> CONFIG_LEDS_LM3642=y
> CONFIG_LEDS_PCA9532=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> CONFIG_LEDS_LP5521=y
> # CONFIG_LEDS_LP5523 is not set
> # CONFIG_LEDS_LP5562 is not set
> CONFIG_LEDS_LP8501=y
> CONFIG_LEDS_LP8788=y
> CONFIG_LEDS_CLEVO_MAIL=y
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA963X=y
> CONFIG_LEDS_PCA9685=y
> CONFIG_LEDS_WM8350=y
> CONFIG_LEDS_DA9052=y
> CONFIG_LEDS_DAC124S085=y
> CONFIG_LEDS_PWM=y
> CONFIG_LEDS_REGULATOR=y
> CONFIG_LEDS_BD2802=y
> CONFIG_LEDS_INTEL_SS4200=y
> # CONFIG_LEDS_DELL_NETBOOKS is not set
> # CONFIG_LEDS_MC13783 is not set
> CONFIG_LEDS_TCA6507=y
> CONFIG_LEDS_MAX8997=y
> CONFIG_LEDS_LM355x=y
> CONFIG_LEDS_OT200=y
> # CONFIG_LEDS_BLINKM is not set
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> # CONFIG_LEDS_TRIGGER_ONESHOT is not set
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> CONFIG_LEDS_TRIGGER_CPU=y
> CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> # CONFIG_LEDS_TRIGGER_CAMERA is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> # CONFIG_RTC_HCTOSYS is not set
> # CONFIG_RTC_SYSTOHC is not set
> CONFIG_RTC_DEBUG=y
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> # CONFIG_RTC_INTF_PROC is not set
> # CONFIG_RTC_INTF_DEV is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_88PM860X=y
> CONFIG_RTC_DRV_88PM80X=y
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> CONFIG_RTC_DRV_DS3232=y
> CONFIG_RTC_DRV_LP8788=y
> CONFIG_RTC_DRV_MAX6900=y
> # CONFIG_RTC_DRV_MAX8907 is not set
> CONFIG_RTC_DRV_MAX8925=y
> CONFIG_RTC_DRV_MAX8997=y
> # CONFIG_RTC_DRV_RS5C372 is not set
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> CONFIG_RTC_DRV_ISL12057=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> CONFIG_RTC_DRV_M41T80_WDT=y
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_RC5T583=y
> CONFIG_RTC_DRV_S35390A=y
> CONFIG_RTC_DRV_FM3130=y
> CONFIG_RTC_DRV_RX8581=y
> # CONFIG_RTC_DRV_RX8025 is not set
> # CONFIG_RTC_DRV_EM3027 is not set
> CONFIG_RTC_DRV_RV3029C2=y
> 
> #
> # SPI RTC drivers
> #
> CONFIG_RTC_DRV_M41T93=y
> # CONFIG_RTC_DRV_M41T94 is not set
> CONFIG_RTC_DRV_DS1305=y
> # CONFIG_RTC_DRV_DS1347 is not set
> # CONFIG_RTC_DRV_DS1390 is not set
> CONFIG_RTC_DRV_MAX6902=y
> CONFIG_RTC_DRV_R9701=y
> # CONFIG_RTC_DRV_RS5C348 is not set
> # CONFIG_RTC_DRV_DS3234 is not set
> CONFIG_RTC_DRV_PCF2123=y
> CONFIG_RTC_DRV_RX4581=y
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> CONFIG_RTC_DRV_DS1286=y
> CONFIG_RTC_DRV_DS1511=y
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> CONFIG_RTC_DRV_DA9052=y
> CONFIG_RTC_DRV_STK17TA8=y
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> CONFIG_RTC_DRV_M48T59=y
> CONFIG_RTC_DRV_MSM6242=y
> CONFIG_RTC_DRV_BQ4802=y
> # CONFIG_RTC_DRV_RP5C01 is not set
> CONFIG_RTC_DRV_V3020=y
> CONFIG_RTC_DRV_DS2404=y
> # CONFIG_RTC_DRV_WM8350 is not set
> CONFIG_RTC_DRV_PCF50633=y
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_RTC_DRV_PCAP=y
> CONFIG_RTC_DRV_MC13XXX=y
> # CONFIG_RTC_DRV_MOXART is not set
> 
> #
> # HID Sensor RTC drivers
> #
> CONFIG_RTC_DRV_HID_SENSOR_TIME=y
> CONFIG_DMADEVICES=y
> CONFIG_DMADEVICES_DEBUG=y
> # CONFIG_DMADEVICES_VDEBUG is not set
> 
> #
> # DMA Devices
> #
> CONFIG_INTEL_MID_DMAC=y
> # CONFIG_INTEL_IOATDMA is not set
> CONFIG_DW_DMAC_CORE=y
> # CONFIG_DW_DMAC is not set
> CONFIG_DW_DMAC_PCI=y
> CONFIG_TIMB_DMA=y
> # CONFIG_PCH_DMA is not set
> CONFIG_DMA_ENGINE=y
> CONFIG_DMA_ACPI=y
> 
> #
> # DMA Clients
> #
> CONFIG_ASYNC_TX_DMA=y
> CONFIG_DMATEST=y
> CONFIG_AUXDISPLAY=y
> CONFIG_UIO=y
> CONFIG_UIO_CIF=y
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> CONFIG_UIO_AEC=y
> # CONFIG_UIO_SERCOS3 is not set
> CONFIG_UIO_PCI_GENERIC=y
> CONFIG_UIO_NETX=y
> CONFIG_UIO_MF624=y
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> CONFIG_VIRTIO_BALLOON=y
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> CONFIG_HYPERV=y
> # CONFIG_HYPERV_UTILS is not set
> CONFIG_HYPERV_BALLOON=y
> CONFIG_STAGING=y
> # CONFIG_ET131X is not set
> # CONFIG_SLICOSS is not set
> CONFIG_USBIP_CORE=y
> CONFIG_USBIP_VHCI_HCD=y
> # CONFIG_USBIP_HOST is not set
> CONFIG_USBIP_DEBUG=y
> CONFIG_PANEL=y
> CONFIG_PANEL_PARPORT=0
> CONFIG_PANEL_PROFILE=5
> # CONFIG_PANEL_CHANGE_MESSAGE is not set
> CONFIG_RTS5139=y
> CONFIG_RTS5139_DEBUG=y
> CONFIG_RTS5208=y
> # CONFIG_RTS5208_DEBUG is not set
> CONFIG_TRANZPORT=y
> CONFIG_LINE6_USB=y
> # CONFIG_LINE6_USB_IMPULSE_RESPONSE is not set
> CONFIG_USB_SERIAL_QUATECH2=y
> # CONFIG_DX_SEP is not set
> 
> #
> # IIO staging drivers
> #
> 
> #
> # Accelerometers
> #
> CONFIG_ADIS16201=y
> CONFIG_ADIS16203=y
> CONFIG_ADIS16204=y
> CONFIG_ADIS16209=y
> CONFIG_ADIS16220=y
> CONFIG_ADIS16240=y
> CONFIG_SCA3000=y
> 
> #
> # Analog to digital converters
> #
> # CONFIG_AD7291 is not set
> CONFIG_AD799X=y
> CONFIG_AD799X_RING_BUFFER=y
> CONFIG_AD7192=y
> CONFIG_AD7280=y
> # CONFIG_LPC32XX_ADC is not set
> # CONFIG_MXS_LRADC is not set
> # CONFIG_SPEAR_ADC is not set
> 
> #
> # Analog digital bi-direction converters
> #
> 
> #
> # Capacitance to digital converters
> #
> CONFIG_AD7150=y
> CONFIG_AD7152=y
> CONFIG_AD7746=y
> 
> #
> # Direct Digital Synthesis
> #
> CONFIG_AD5930=y
> CONFIG_AD9832=y
> CONFIG_AD9834=y
> CONFIG_AD9850=y
> CONFIG_AD9852=y
> CONFIG_AD9910=y
> CONFIG_AD9951=y
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16060=y
> 
> #
> # Network Analyzer, Impedance Converters
> #
> CONFIG_AD5933=y
> 
> #
> # Light sensors
> #
> CONFIG_SENSORS_ISL29018=y
> CONFIG_SENSORS_ISL29028=y
> CONFIG_TSL2583=y
> # CONFIG_TSL2x7x is not set
> 
> #
> # Magnetometer sensors
> #
> CONFIG_SENSORS_HMC5843=y
> 
> #
> # Active energy metering IC
> #
> # CONFIG_ADE7753 is not set
> CONFIG_ADE7754=y
> # CONFIG_ADE7758 is not set
> CONFIG_ADE7759=y
> # CONFIG_ADE7854 is not set
> 
> #
> # Resolver to digital converters
> #
> CONFIG_AD2S90=y
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_PERIODIC_RTC_TRIGGER=y
> CONFIG_IIO_SIMPLE_DUMMY=y
> # CONFIG_IIO_SIMPLE_DUMMY_EVENTS is not set
> # CONFIG_IIO_SIMPLE_DUMMY_BUFFER is not set
> # CONFIG_CRYSTALHD is not set
> CONFIG_FB_XGI=y
> # CONFIG_ACPI_QUICKSTART is not set
> CONFIG_BCM_WIMAX=y
> CONFIG_FT1000=y
> CONFIG_FT1000_USB=y
> 
> #
> # Speakup console speech
> #
> CONFIG_SPEAKUP=y
> # CONFIG_SPEAKUP_SYNTH_ACNTSA is not set
> # CONFIG_SPEAKUP_SYNTH_ACNTPC is not set
> # CONFIG_SPEAKUP_SYNTH_APOLLO is not set
> CONFIG_SPEAKUP_SYNTH_AUDPTR=y
> CONFIG_SPEAKUP_SYNTH_BNS=y
> CONFIG_SPEAKUP_SYNTH_DECTLK=y
> # CONFIG_SPEAKUP_SYNTH_DECEXT is not set
> CONFIG_SPEAKUP_SYNTH_DTLK=y
> CONFIG_SPEAKUP_SYNTH_KEYPC=y
> CONFIG_SPEAKUP_SYNTH_LTLK=y
> CONFIG_SPEAKUP_SYNTH_SOFT=y
> CONFIG_SPEAKUP_SYNTH_SPKOUT=y
> CONFIG_SPEAKUP_SYNTH_TXPRT=y
> # CONFIG_SPEAKUP_SYNTH_DUMMY is not set
> CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
> # CONFIG_STAGING_MEDIA is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID is not set
> CONFIG_USB_WPAN_HCD=y
> CONFIG_WIMAX_GDM72XX=y
> # CONFIG_WIMAX_GDM72XX_QOS is not set
> # CONFIG_WIMAX_GDM72XX_K_MODE is not set
> # CONFIG_WIMAX_GDM72XX_WIMAX2 is not set
> # CONFIG_WIMAX_GDM72XX_USB is not set
> CONFIG_WIMAX_GDM72XX_SDIO=y
> # CONFIG_NET_VENDOR_SILICOM is not set
> # CONFIG_CED1401 is not set
> # CONFIG_DGRP is not set
> CONFIG_FIREWIRE_SERIAL=y
> CONFIG_FWTTY_MAX_TOTAL_PORTS=64
> CONFIG_FWTTY_MAX_CARD_PORTS=32
> CONFIG_XILLYBUS=y
> CONFIG_XILLYBUS_PCIE=y
> CONFIG_DGNC=y
> # CONFIG_DGAP is not set
> CONFIG_GS_FPGABOOT=y
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACER_WMI is not set
> CONFIG_ACERHDF=y
> CONFIG_ASUS_LAPTOP=y
> # CONFIG_DELL_WMI is not set
> CONFIG_DELL_WMI_AIO=y
> # CONFIG_FUJITSU_LAPTOP is not set
> # CONFIG_FUJITSU_TABLET is not set
> CONFIG_AMILO_RFKILL=y
> CONFIG_TC1100_WMI=y
> CONFIG_HP_ACCEL=y
> CONFIG_HP_WIRELESS=y
> CONFIG_HP_WMI=y
> CONFIG_MSI_LAPTOP=y
> CONFIG_PANASONIC_LAPTOP=y
> CONFIG_COMPAL_LAPTOP=y
> CONFIG_SONY_LAPTOP=y
> CONFIG_SONYPI_COMPAT=y
> # CONFIG_IDEAPAD_LAPTOP is not set
> # CONFIG_THINKPAD_ACPI is not set
> # CONFIG_SENSORS_HDAPS is not set
> CONFIG_ACPI_WMI=y
> CONFIG_MSI_WMI=y
> CONFIG_TOPSTAR_LAPTOP=y
> # CONFIG_ACPI_TOSHIBA is not set
> CONFIG_TOSHIBA_BT_RFKILL=y
> # CONFIG_ACPI_CMPC is not set
> CONFIG_INTEL_IPS=y
> # CONFIG_IBM_RTL is not set
> # CONFIG_XO15_EBOOK is not set
> CONFIG_SAMSUNG_LAPTOP=y
> CONFIG_MXM_WMI=y
> CONFIG_INTEL_OAKTRAIL=y
> CONFIG_SAMSUNG_Q10=y
> # CONFIG_APPLE_GMUX is not set
> CONFIG_INTEL_RST=y
> CONFIG_INTEL_SMARTCONNECT=y
> CONFIG_PVPANIC=y
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> # CONFIG_SOC_TI is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> CONFIG_REMOTEPROC=y
> CONFIG_STE_MODEM_RPROC=y
> 
> #
> # Rpmsg drivers
> #
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> CONFIG_MEMORY=y
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> # CONFIG_BMA180 is not set
> CONFIG_HID_SENSOR_ACCEL_3D=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> CONFIG_IIO_ST_ACCEL_SPI_3AXIS=y
> # CONFIG_KXSD9 is not set
> 
> #
> # Analog to digital converters
> #
> CONFIG_AD_SIGMA_DELTA=y
> CONFIG_AD7266=y
> CONFIG_AD7298=y
> CONFIG_AD7476=y
> CONFIG_AD7791=y
> CONFIG_AD7793=y
> # CONFIG_AD7887 is not set
> CONFIG_AD7923=y
> # CONFIG_LP8788_ADC is not set
> # CONFIG_MAX1363 is not set
> CONFIG_MCP320X=y
> # CONFIG_MCP3422 is not set
> # CONFIG_NAU7802 is not set
> CONFIG_TI_ADC081C=y
> # CONFIG_XILINX_XADC is not set
> 
> #
> # Amplifiers
> #
> CONFIG_AD8366=y
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_HID_SENSOR_IIO_COMMON=y
> CONFIG_HID_SENSOR_IIO_TRIGGER=y
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_SPI=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> # CONFIG_AD5064 is not set
> CONFIG_AD5360=y
> CONFIG_AD5380=y
> CONFIG_AD5421=y
> CONFIG_AD5446=y
> CONFIG_AD5449=y
> CONFIG_AD5504=y
> CONFIG_AD5624R_SPI=y
> # CONFIG_AD5686 is not set
> CONFIG_AD5755=y
> CONFIG_AD5764=y
> CONFIG_AD5791=y
> CONFIG_AD7303=y
> # CONFIG_MAX517 is not set
> # CONFIG_MCP4725 is not set
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> # CONFIG_AD9523 is not set
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> CONFIG_ADF4350=y
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_ADIS16080=y
> CONFIG_ADIS16130=y
> # CONFIG_ADIS16136 is not set
> # CONFIG_ADIS16260 is not set
> CONFIG_ADXRS450=y
> # CONFIG_HID_SENSOR_GYRO_3D is not set
> # CONFIG_IIO_ST_GYRO_3AXIS is not set
> CONFIG_ITG3200=y
> 
> #
> # Humidity sensors
> #
> # CONFIG_SI7005 is not set
> 
> #
> # Inertial measurement units
> #
> CONFIG_ADIS16400=y
> CONFIG_ADIS16480=y
> CONFIG_INV_MPU6050_IIO=y
> CONFIG_IIO_ADIS_LIB=y
> CONFIG_IIO_ADIS_LIB_BUFFER=y
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=y
> CONFIG_APDS9300=y
> # CONFIG_CM32181 is not set
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> CONFIG_HID_SENSOR_ALS=y
> # CONFIG_HID_SENSOR_PROX is not set
> CONFIG_LTR501=y
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> # CONFIG_TSL4531 is not set
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_MAG3110=y
> CONFIG_HID_SENSOR_MAGNETOMETER_3D=y
> CONFIG_IIO_ST_MAGN_3AXIS=y
> CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
> CONFIG_IIO_ST_MAGN_SPI_3AXIS=y
> 
> #
> # Inclinometer sensors
> #
> CONFIG_HID_SENSOR_INCLINOMETER_3D=y
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> CONFIG_HID_SENSOR_PRESS=y
> CONFIG_MPL3115=y
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> CONFIG_IIO_ST_PRESS_SPI=y
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> CONFIG_NTB=y
> CONFIG_VME_BUS=y
> 
> #
> # VME Bridge Drivers
> #
> CONFIG_VME_CA91CX42=y
> CONFIG_VME_TSI148=y
> 
> #
> # VME Board Drivers
> #
> CONFIG_VMIVME_7805=y
> 
> #
> # VME Device Drivers
> #
> CONFIG_VME_USER=y
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> # CONFIG_PWM_CLPS711X is not set
> CONFIG_PWM_LP3943=y
> # CONFIG_PWM_LPSS is not set
> # CONFIG_PWM_RENESAS_TPU is not set
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> # CONFIG_SERIAL_IPOCTAL is not set
> CONFIG_RESET_CONTROLLER=y
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> # CONFIG_GENERIC_PHY is not set
> # CONFIG_PHY_EXYNOS_MIPI_VIDEO is not set
> CONFIG_OMAP_CONTROL_PHY=y
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> CONFIG_POWERCAP=y
> CONFIG_INTEL_RAPL=y
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> # CONFIG_DCDBAS is not set
> CONFIG_DMIID=y
> CONFIG_DMI_SYSFS=y
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # EFI (Extensible Firmware Interface) Support
> #
> CONFIG_EFI_VARS=y
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> CONFIG_EXT2_FS_XIP=y
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_FS_XIP=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> CONFIG_REISERFS_PROC_INFO=y
> # CONFIG_REISERFS_FS_XATTR is not set
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=y
> # CONFIG_XFS_QUOTA is not set
> # CONFIG_XFS_POSIX_ACL is not set
> # CONFIG_XFS_RT is not set
> CONFIG_XFS_DEBUG=y
> # CONFIG_GFS2_FS is not set
> CONFIG_OCFS2_FS=y
> # CONFIG_OCFS2_FS_O2CB is not set
> # CONFIG_OCFS2_FS_STATS is not set
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> CONFIG_BTRFS_DEBUG=y
> CONFIG_BTRFS_ASSERT=y
> # CONFIG_NILFS2_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_FILE_LOCKING=y
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> # CONFIG_INOTIFY_USER is not set
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> CONFIG_PRINT_QUOTA_WARNING=y
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> CONFIG_QFMT_V1=y
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> CONFIG_FUSE_FS=y
> # CONFIG_CUSE is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> CONFIG_UDF_FS=y
> CONFIG_UDF_NLS=y
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> # CONFIG_VFAT_FS is not set
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> CONFIG_NTFS_RW=y
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> # CONFIG_PROC_VMCORE is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> # CONFIG_TMPFS_XATTR is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> # CONFIG_ADFS_FS_RW is not set
> CONFIG_AFFS_FS=y
> CONFIG_ECRYPT_FS=y
> # CONFIG_ECRYPT_FS_MESSAGING is not set
> CONFIG_HFS_FS=y
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_LOGFS is not set
> # CONFIG_CRAMFS is not set
> CONFIG_SQUASHFS=y
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> # CONFIG_SQUASHFS_XATTR is not set
> CONFIG_SQUASHFS_ZLIB=y
> # CONFIG_SQUASHFS_LZO is not set
> # CONFIG_SQUASHFS_XZ is not set
> CONFIG_SQUASHFS_4K_DEVBLK_SIZE=y
> CONFIG_SQUASHFS_EMBEDDED=y
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> CONFIG_VXFS_FS=y
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=y
> CONFIG_HPFS_FS=y
> CONFIG_QNX4FS_FS=y
> # CONFIG_QNX6FS_FS is not set
> CONFIG_ROMFS_FS=y
> CONFIG_ROMFS_BACKED_BY_BLOCK=y
> CONFIG_ROMFS_ON_BLOCK=y
> # CONFIG_PSTORE is not set
> CONFIG_SYSV_FS=y
> CONFIG_UFS_FS=y
> # CONFIG_UFS_FS_WRITE is not set
> # CONFIG_UFS_DEBUG is not set
> CONFIG_F2FS_FS=y
> CONFIG_F2FS_STAT_FS=y
> # CONFIG_F2FS_FS_XATTR is not set
> # CONFIG_F2FS_CHECK_FS is not set
> CONFIG_EFIVAR_FS=y
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> CONFIG_NLS_CODEPAGE_850=y
> CONFIG_NLS_CODEPAGE_852=y
> CONFIG_NLS_CODEPAGE_855=y
> # CONFIG_NLS_CODEPAGE_857 is not set
> CONFIG_NLS_CODEPAGE_860=y
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> CONFIG_NLS_CODEPAGE_866=y
> CONFIG_NLS_CODEPAGE_869=y
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> CONFIG_NLS_CODEPAGE_932=y
> CONFIG_NLS_CODEPAGE_949=y
> CONFIG_NLS_CODEPAGE_874=y
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=y
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> CONFIG_NLS_ISO8859_2=y
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> # CONFIG_NLS_ISO8859_5 is not set
> CONFIG_NLS_ISO8859_6=y
> # CONFIG_NLS_ISO8859_7 is not set
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> CONFIG_NLS_KOI8_R=y
> CONFIG_NLS_KOI8_U=y
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> CONFIG_NLS_MAC_GAELIC=y
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> CONFIG_NLS_MAC_ROMANIAN=y
> CONFIG_NLS_MAC_TURKISH=y
> # CONFIG_NLS_UTF8 is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> CONFIG_BOOT_PRINTK_DELAY=y
> CONFIG_DYNAMIC_DEBUG=y
> 
> #
> # Compile-time checks and compiler options
> #
> CONFIG_ENABLE_WARN_DEPRECATED=y
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> # CONFIG_STRIP_ASM_SYMS is not set
> CONFIG_READABLE_ASM=y
> CONFIG_UNUSED_SYMBOLS=y
> CONFIG_DEBUG_FS=y
> CONFIG_HEADERS_CHECK=y
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> CONFIG_DEBUG_PAGEALLOC=y
> CONFIG_WANT_PAGE_DEBUG_FLAGS=y
> CONFIG_PAGE_GUARD=y
> CONFIG_DEBUG_OBJECTS=y
> CONFIG_DEBUG_OBJECTS_SELFTEST=y
> # CONFIG_DEBUG_OBJECTS_FREE is not set
> # CONFIG_DEBUG_OBJECTS_TIMERS is not set
> CONFIG_DEBUG_OBJECTS_WORK=y
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
> CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=y
> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
> CONFIG_SLUB_DEBUG_ON=y
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_DEBUG_VM=y
> CONFIG_DEBUG_VM_RB=y
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> CONFIG_DEBUG_PER_CPU_MAPS=y
> CONFIG_DEBUG_HIGHMEM=y
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> CONFIG_TIMER_STATS=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> # CONFIG_RT_MUTEX_TESTER is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> CONFIG_LOCK_STAT=y
> CONFIG_DEBUG_LOCKDEP=y
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> CONFIG_LOCK_TORTURE_TEST=y
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_LIST=y
> # CONFIG_DEBUG_SG is not set
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_PROVE_RCU is not set
> CONFIG_SPARSE_RCU_POINTER=y
> CONFIG_TORTURE_TEST=y
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_CPU_STALL_INFO=y
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> CONFIG_PM_NOTIFIER_ERROR_INJECT=y
> CONFIG_FAULT_INJECTION=y
> # CONFIG_FAILSLAB is not set
> # CONFIG_FAIL_PAGE_ALLOC is not set
> # CONFIG_FAIL_MAKE_REQUEST is not set
> # CONFIG_FAIL_IO_TIMEOUT is not set
> # CONFIG_FAIL_MMC_REQUEST is not set
> # CONFIG_FAULT_INJECTION_DEBUG_FS is not set
> # CONFIG_LATENCYTOP is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_RING_BUFFER_ALLOW_SWAP=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_FUNCTION_TRACER=y
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> CONFIG_STACK_TRACER=y
> CONFIG_BLK_DEV_IO_TRACE=y
> # CONFIG_UPROBE_EVENT is not set
> # CONFIG_PROBE_EVENTS is not set
> # CONFIG_DYNAMIC_FTRACE is not set
> # CONFIG_FUNCTION_PROFILER is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> CONFIG_TEST_LIST_SORT=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> CONFIG_ASYNC_RAID6_TEST=y
> CONFIG_TEST_STRING_HELPERS=y
> # CONFIG_TEST_KSTRTOX is not set
> CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
> CONFIG_BUILD_DOCSRC=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> CONFIG_EARLY_PRINTK_DBGP=y
> CONFIG_EARLY_PRINTK_EFI=y
> CONFIG_X86_PTDUMP=y
> CONFIG_EFI_PGT_DUMP=y
> CONFIG_DEBUG_RODATA=y
> CONFIG_DEBUG_RODATA_TEST=y
> CONFIG_DOUBLEFAULT=y
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> CONFIG_DEBUG_BOOT_PARAMS=y
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_PERSISTENT_KEYRINGS is not set
> # CONFIG_BIG_KEYS is not set
> CONFIG_TRUSTED_KEYS=y
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> # CONFIG_SECURITY is not set
> CONFIG_SECURITYFS=y
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_ASYNC_CORE=y
> CONFIG_ASYNC_MEMCPY=y
> CONFIG_ASYNC_XOR=y
> CONFIG_ASYNC_PQ=y
> CONFIG_ASYNC_RAID6_RECOV=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_PCRYPT=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> CONFIG_CRYPTO_CTS=y
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_CMAC is not set
> CONFIG_CRYPTO_HMAC=y
> # CONFIG_CRYPTO_XCBC is not set
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> # CONFIG_CRYPTO_CRC32 is not set
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> CONFIG_CRYPTO_RMD160=y
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> # CONFIG_CRYPTO_WP512 is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_586 is not set
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> # CONFIG_CRYPTO_BLOWFISH is not set
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> CONFIG_CRYPTO_CAST6=y
> # CONFIG_CRYPTO_DES is not set
> CONFIG_CRYPTO_FCRYPT=y
> CONFIG_CRYPTO_KHAZAD=y
> CONFIG_CRYPTO_SALSA20=y
> CONFIG_CRYPTO_SALSA20_586=y
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> CONFIG_CRYPTO_TEA=y
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> CONFIG_CRYPTO_TWOFISH_586=y
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=y
> CONFIG_CRYPTO_LZO=y
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=y
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> # CONFIG_CRYPTO_HW is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> # CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
> # CONFIG_PUBLIC_KEY_ALGO_RSA is not set
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> CONFIG_LGUEST=y
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> CONFIG_CRC32_SELFTEST=y
> # CONFIG_CRC32_SLICEBY8 is not set
> # CONFIG_CRC32_SLICEBY4 is not set
> CONFIG_CRC32_SARWATE=y
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> CONFIG_CRC8=y
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> CONFIG_XZ_DEC_POWERPC=y
> CONFIG_XZ_DEC_IA64=y
> CONFIG_XZ_DEC_ARM=y
> CONFIG_XZ_DEC_ARMTHUMB=y
> CONFIG_XZ_DEC_SPARC=y
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_XZ=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_TEXTSEARCH=y
> CONFIG_TEXTSEARCH_KMP=y
> CONFIG_TEXTSEARCH_BM=y
> CONFIG_TEXTSEARCH_FSM=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> # CONFIG_CPUMASK_OFFSTACK is not set
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CORDIC=y
> CONFIG_DDR=y
> CONFIG_UCS2_STRING=y
> CONFIG_FONT_SUPPORT=y
> # CONFIG_FONTS is not set
> CONFIG_FONT_8x8=y
> CONFIG_FONT_8x16=y

