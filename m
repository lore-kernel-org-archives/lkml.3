Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688AbaDVRYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:24:05 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33555 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbaDVRYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:24:01 -0400
Date: Tue, 22 Apr 2014 10:23:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Microblaze image hanging in qemu with 3.15-rc
Message-ID: <20140422172356.GA15672@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in qemu,
I get the following hangup. This used to work with earlier kernels
with the same configuration.

Is this a known problem, or is something wrong with my configuration 
or with my qemu command line ?

Thanks,
Guenter

---
Qemu console log:

Early console on uartlite at 0x84000000
bootconsole [earlyser0] enabled
Ramdisk addr 0x00000000, 
FDT at 0x90543814
Linux version 3.15.0-rc1 (groeck@hyperion) (gcc version 4.8.0 (GCC) ) #1 Mon Apr 14 02:48:03 PDT 2014
setup_cpuinfo: initialising
setup_cpuinfo: No PVR support. Using static CPU info from FDT
wt_msr
setup_memory: max_mapnr: 0x8000
setup_memory: min_low_pfn: 0x90000
setup_memory: max_low_pfn: 0x98000
setup_memory: max_pfn: 0x98000
Zone ranges:
  DMA      [mem 0x90000000-0x97ffffff]
  Normal   empty
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x90000000-0x97ffffff]
On node 0 totalpages: 32768
free_area_init_node: node 0, pgdat c03b688c, node_mem_map c0577000
  DMA zone: 256 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 32768 pages, LIFO batch:7
early_printk_console remapping from 0x84000000 to 0xffffd000
pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
pcpu-alloc: [0] 0 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line: console=ttyUL0,115200
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Memory: 124172K/131072K available (2887K kernel code, 116K rwdata, 760K rodata, 1574K init, 202K bss, 6900K reserved)
Kernel virtual memory layout:
  * 0xffffe000..0xfffff000  : fixmap
  * 0xffffd000..0xffffe000  : early ioremap
  * 0xf0000000..0xffffd000  : vmalloc & ioremap
NR_IRQS:33
/plb@0/interrupt-controller@81800000: num_irq=4, edge=0xa
ERROR: CPU CCF input clock not found
/plb@0/timer@83c00000: irq=1
ERROR: timer CCF input clock not found
ERROR: Using CPU clock frequency
xilinx_timer_set_mode: shutdown
xilinx_timer_set_mode: periodic
sched_clock: 32 bits at 62MHz, resolution 16ns, wraps every 68719476720ns
Calibrating delay loop...

The image hangs here, and I have to kill qemu to get out.
Note the ERROR messages in the log.

---

Configuration file:

CONFIG_EXPERIMENTAL=y
CONFIG_SYSVIPC=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE="rootfs.cpio"
CONFIG_INITRAMFS_COMPRESSION_GZIP=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_EXPERT=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
# CONFIG_HOTPLUG is not set
# CONFIG_BASE_FULL is not set
# CONFIG_FUTEX is not set
# CONFIG_EPOLL is not set
# CONFIG_SIGNALFD is not set
# CONFIG_SHMEM is not set
CONFIG_SLAB=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_BLK_DEV_BSG is not set
CONFIG_OPT_LIB_ASM=y
CONFIG_XILINX_MICROBLAZE0_FAMILY="spartan3adsp"
CONFIG_XILINX_MICROBLAZE0_USE_MSR_INSTR=1
CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR=1
CONFIG_XILINX_MICROBLAZE0_USE_BARREL=1
CONFIG_XILINX_MICROBLAZE0_USE_HW_MUL=1
CONFIG_HZ_100=y
CONFIG_MMU=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE_FORCE=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
# CONFIG_INET_LRO is not set
# CONFIG_IPV6 is not set
CONFIG_PROC_DEVICETREE=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_SIZE=8192
CONFIG_NETDEVICES=y
CONFIG_NET_ETHERNET=y
CONFIG_XILINX_EMACLITE=y
# CONFIG_INPUT is not set
# CONFIG_SERIO is not set
# CONFIG_VT is not set
CONFIG_SERIAL_UARTLITE=y
CONFIG_SERIAL_UARTLITE_CONSOLE=y
# CONFIG_HW_RANDOM is not set
# CONFIG_HWMON is not set
# CONFIG_USB_SUPPORT is not set
CONFIG_EXT2_FS=y
# CONFIG_DNOTIFY is not set
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_INFO=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_CRYPTO_ANSI_CPRNG is not set

---

Qemu command line:

qemu-system-microblaze -M petalogix-s3adsp1800 \
	-kernel arch/microblaze/boot/linux.bin -no-reboot \
	-append "console=ttyUL0,115200" -nographic 

