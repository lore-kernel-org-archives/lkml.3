Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761640Ab3BNUVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:21:36 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58658 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab3BNUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:21:34 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-doc@vger.kernel.org>
CC: Rob Landley <rob@landley.net>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] Documentation: update top level 00-INDEX file with new additions
Date: Thu, 14 Feb 2013 15:20:54 -0500
Message-ID: <1360873254-28937-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems there are about 80 new, but undocumented addtions at
the top level Documentation directory.  This fixes up the top
level 00-INDEX by adding new entries and deleting a couple orphans.
Some subdirs could probably still use a check/cleanup too though.

Acked-by: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[vectoring this via trivial tree as requested by Rob]

 Documentation/00-INDEX | 149 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 139 insertions(+), 10 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 8afe64f..0f3e8bb 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -2,7 +2,7 @@
 This is a brief list of all the files in ./linux/Documentation and what
 they contain. If you add a documentation file, please list it here in
 alphabetical order as well, or risk being hunted down like a rabid dog.
-Please try and keep the descriptions small enough to fit on one line.
+Please keep the descriptions small enough to fit on one line.
 							 Thanks -- Paul G.
 
 Following translations are available on the WWW:
@@ -20,24 +20,33 @@ BUG-HUNTING
 Changes
 	- list of changes that break older software packages.
 CodingStyle
-	- how the boss likes the C code in the kernel to look.
-development-process/
-	- An extended tutorial on how to work with the kernel development
-	  process.
+	- how the maintainers expect the C code in the kernel to look.
 DMA-API.txt
 	- DMA API, pci_ API & extensions for non-consistent memory machines.
+DMA-API-HOWTO.txt
+	- Dynamic DMA mapping Guide
 DMA-ISA-LPC.txt
 	- How to do DMA with ISA (and LPC) devices.
+DMA-attributes.txt
+	- listing of the various possible attributes a DMA region can have
 DocBook/
 	- directory with DocBook templates etc. for kernel documentation.
+EDID/
+	- directory with info on customizing EDID for broken gfx/displays.
 HOWTO
 	- the process and procedures of how to do Linux kernel development.
 IPMI.txt
 	- info on Linux Intelligent Platform Management Interface (IPMI) Driver.
 IRQ-affinity.txt
 	- how to select which CPU(s) handle which interrupt events on SMP.
+IRQ-domain.txt
+	- info on inerrupt numbering and setting up IRQ domains.
 IRQ.txt
 	- description of what an IRQ is.
+Intel-IOMMU.txt
+	- basic info on the Intel IOMMU virtualization support.
+Makefile
+	- some files in Documentation dir are actually sample code to build
 ManagementStyle
 	- how to (attempt to) manage kernel hackers.
 RCU/
@@ -66,10 +75,16 @@ applying-patches.txt
 	- description of various trees and how to apply their patches.
 arm/
 	- directory with info about Linux on the ARM architecture.
+arm64/
+	- directory with info about Linux on the 64 bit ARM architecture.
 atomic_ops.txt
 	- semantics and behavior of atomic and bitmask operations.
 auxdisplay/
 	- misc. LCD driver documentation (cfag12864b, ks0108).
+backlight/
+	- directory with info on controlling backlights in flat panel displays
+bad_memory.txt
+	- how to use kernel parameters to exclude bad RAM regions.
 basic_profiling.txt
 	- basic instructions for those who wants to profile Linux kernel.
 binfmt_misc.txt
@@ -80,8 +95,14 @@ block/
 	- info on the Block I/O (BIO) layer.
 blockdev/
 	- info on block devices & drivers
+braille-console.txt
+	- info on how to use serial devices for Braille support.
+bt8xxgpio.txt
+	- info on how to modify a bt8xx video card for GPIO usage.
 btmrvl.txt
 	- info on Marvell Bluetooth driver usage.
+bus-devices/
+	- directory with info on TI GPMC (General Purpose Memory Controller)
 bus-virt-phys-mapping.txt
 	- how to access I/O mapped memory from within device drivers.
 cachetlb.txt
@@ -90,6 +111,12 @@ cdrom/
 	- directory with information on the CD-ROM drivers that Linux has.
 cgroups/
 	- cgroups features, including cpusets and memory controller.
+circular-buffers.txt
+	- how to make use of the existing circular buffer infrastructure
+clk.txt
+	- info on the common clock framework
+coccinelle.txt
+	- info on how to get and use the Coccinelle code checking tool.
 connector/
 	- docs on the netlink based userspace<->kernel space communication mod.
 console/
@@ -114,24 +141,42 @@ dcdbas.txt
 	- information on the Dell Systems Management Base Driver.
 debugging-modules.txt
 	- some notes on debugging modules after Linux 2.6.3.
+debugging-via-ohci1394.txt
+	- how to use firewire like a hardware debugger memory reader.
 dell_rbu.txt
 	- document demonstrating the use of the Dell Remote BIOS Update driver.
+development-process/
+	- how to work with the mainline kernel development process.
 device-mapper/
 	- directory with info on Device Mapper.
 devices.txt
 	- plain ASCII listing of all the nodes in /dev/ with major minor #'s.
+devicetree/
+	- directory with info on device tree files used by OF/PowerPC/ARM
+digsig.txt
+	-info on the Digital Signature Verification API
+dma-buf-sharing.txt
+	- the DMA Buffer Sharing API Guide
+dmaengine.txt
+	-the DMA Engine API Guide
 dontdiff
 	- file containing a list of files that should never be diff'ed.
 driver-model/
 	- directory with info about Linux driver model.
 dvb/
 	- info on Linux Digital Video Broadcast (DVB) subsystem.
+dynamic-debug-howto.txt
+	- how to use the dynamic debug (dyndbg) feature.
 early-userspace/
 	- info about initramfs, klibc, and userspace early during boot.
 edac.txt
 	- information on EDAC - Error Detection And Correction
 eisa.txt
 	- info on EISA bus support.
+email-clients.txt
+	- info on how to use e-mail to send un-mangled (git) patches.
+extcon/
+	- directory with porting guide for Android kernel switch driver.
 fault-injection/
 	- dir with docs about the fault injection capabilities infrastructure.
 fb/
@@ -140,12 +185,22 @@ filesystems/
 	- info on the vfs and the various filesystems that Linux supports.
 firmware_class/
 	- request_firmware() hotplug interface info.
+flexible-arrays.txt
+	- how to make use of flexible sized arrays in linux
 frv/
 	- Fujitsu FR-V Linux documentation.
+futex-requeue-pi.txt
+	- info on requeueing of tasks from a non-PI futex to a PI futex
+gcov.txt
+	- use of GCC's coverage testing tool "gcov" with the Linux kernel
 gpio.txt
 	- overview of GPIO (General Purpose Input/Output) access conventions.
+hid/
+	- directory with information on human interface devices
 highuid.txt
 	- notes on the change from 16 bit to 32 bit user/group IDs.
+hwspinlock.txt
+	- hardware spinlock provides hardware assistance for synchronization
 timers/
 	- info on the timer related topics
 hw_random.txt
@@ -162,10 +217,14 @@ ia64/
 	- directory with info about Linux on Intel 64 bit architecture.
 infiniband/
 	- directory with documents concerning Linux InfiniBand support.
+init.txt
+	- what to do when the kernel can't find the 1st process to run.
 initrd.txt
 	- how to use the RAM disk as an initial/temporary root filesystem.
 input/
 	- info on Linux input device support.
+intel_txt.txt
+	- info on intel Trusted Execution Technology (intel TXT).
 io-mapping.txt
 	- description of io_mapping functions in linux/io-mapping.h
 io_ordering.txt
@@ -182,6 +241,8 @@ isdn/
 	- directory with info on the Linux ISDN support, and supported cards.
 java.txt
 	- info on the in-kernel binary support for Java(tm).
+ja_JP/
+	- directory with Japanese translations of various documents
 kbuild/
 	- directory with info about the kernel build process.
 kdump/
@@ -192,6 +253,12 @@ kernel-docs.txt
 	- listing of various WWW + books that document kernel internals.
 kernel-parameters.txt
 	- summary listing of command line / boot prompt args for the kernel.
+kmemcheck.txt
+	- info on dynamic checker that detects uses of uninitialized memory.
+kmemleak.txt
+	- info on how to make use of the kernel memory leak detection system
+ko_KR/
+	- directory with Korean translations of various documents
 kobject.txt
 	- info of the kobject infrastructure of the Linux kernel.
 kprobes.txt
@@ -208,6 +275,8 @@ local_ops.txt
 	- semantics and behavior of local atomic operations.
 lockdep-design.txt
 	- documentation on the runtime locking correctness validator.
+lockstat.txt
+	- info on collecting statistics on locks (and contention).
 lockup-watchdogs.txt
 	- info on soft and hard lockup detectors (aka nmi_watchdog).
 logo.gif
@@ -220,16 +289,26 @@ magic-number.txt
 	- list of magic numbers used to mark/protect kernel data structures.
 md.txt
 	- info on boot arguments for the multiple devices driver.
+media-framework.txt
+	- info on media framework, its data structures, functions and usage.
 memory-barriers.txt
 	- info on Linux kernel memory barriers.
+memory-devices/
+	- directory with info on parts like the Texas Instruments EMIF driver
 memory-hotplug.txt
 	- Hotpluggable memory support, how to use and current status.
 memory.txt
 	- info on typical Linux memory problems.
 mips/
 	- directory with info about Linux on MIPS architecture.
+misc-devices/
+	- directory with info about devices using the misc dev subsystem
 mmc/
 	- directory with info about the MMC subsystem
+mn10300/
+	- directory with info about the mn10300 architecture port
+mtd/
+	- directory with info about memory technology devices (flash)
 mono.txt
 	- how to execute Mono-based .NET binaries with the help of BINFMT_MISC.
 mutex-design.txt
@@ -240,6 +319,8 @@ netlabel/
 	- directory with information on the NetLabel subsystem.
 networking/
 	- directory with info on various aspects of networking with Linux.
+nfc/
+	- directory relating info about Near Field Communications support.
 nommu-mmap.txt
 	- documentation about no-mmu memory mapping support.
 numastat.txt
@@ -256,26 +337,46 @@ parport-lowlevel.txt
 	- description and usage of the low level parallel port functions.
 pcmcia/
 	- info on the Linux PCMCIA driver.
+percpu-rw-semaphore.txt
+	- RCU based read-write semaphore optimized for locking for reading
 pi-futex.txt
-	- documentation on lightweight PI-futexes.
+	- documentation on lightweight priority inheritance futexes.
+pinctrl.txt
+	- info on pinctrl subsystem and the PINMUX/PINCONF and drivers
 pnp.txt
 	- Linux Plug and Play documentation.
 power/
 	- directory with info on Linux PCI power management.
 powerpc/
 	- directory with info on using Linux with the PowerPC.
+prctl/
+	- directory with info on the priveledge control subsystem
 preempt-locking.txt
 	- info on locking under a preemptive kernel.
 printk-formats.txt
 	- how to get printk format specifiers right
+pps/
+	- directory with information on the pulse-per-second support
+ptp/
+	- directory with info on support for IEEE 1588 PTP clocks in Linux.
+pwm.txt
+	- info on the pulse width modulation driver subsystem
 ramoops.txt
 	- documentation of the ramoops oops/panic logging module.
+rapidio/
+	- directory with info on RapidIO packet-based fabric interconnect
 rbtree.txt
 	- info on what red-black trees are and what they are for.
+remoteproc.txt
+	- info on how to handle remote processor (e.g. AMP) offloads/usage.
+rfkill.txt
+	- info on the radio frequency kill switch subsystem/support.
 robust-futex-ABI.txt
 	- documentation of the robust futex ABI.
 robust-futexes.txt
 	- a description of what robust futexes are.
+rpmsg.txt
+	- info on the Remote Processor Messaging (rpmsg) Framework
 rt-mutex-design.txt
 	- description of the RealTime mutex implementation design.
 rt-mutex.txt
@@ -300,10 +401,10 @@ sgi-visws.txt
 	- short blurb on the SGI Visual Workstations.
 sh/
 	- directory with info on porting Linux to a new architecture.
+smsc_ece1099.txt
+	-info on the smsc Keyboard Scan Expansion/GPIO Expansion device.
 sound/
 	- directory with info on sound card support.
-sparc/
-	- directory with info on using Linux on Sparc architecture.
 sparse.txt
 	- info on how to obtain and use the sparse tool for typechecking.
 spi/
@@ -314,6 +415,8 @@ stable_api_nonsense.txt
 	- info on why the kernel does not have a stable in-kernel api or abi.
 stable_kernel_rules.txt
 	- rules and procedures for the -stable kernel releases.
+static-keys.txt
+	- info on how static keys allow debug code in hotpaths via patching
 svga.txt
 	- short guide on selecting video modes at boot via VGA BIOS.
 sysfs-rules.txt
@@ -322,27 +425,53 @@ sysctl/
 	- directory with info on the /proc/sys/* files.
 sysrq.txt
 	- info on the magic SysRq key.
-telephony/
-	- directory with info on telephony (e.g. voice over IP) support.
+target/
+	- directory with info on generating TCM v4 fabric .ko modules
+thermal/
+	- directory with information on managing thermal issues (CPU/temp)
+trace/
+	- directory with info on tracing technologies within linux
+unaligned-memory-access.txt
+	- info on how to avoid arch breaking unaligned memory access in code.
 unicode.txt
 	- info on the Unicode character/font mapping used in Linux.
 unshare.txt
 	- description of the Linux unshare system call.
 usb/
 	- directory with info regarding the Universal Serial Bus.
+vDSO/
+	- directory with info regarding virtual dynamic shared objects
+vfio.txt
+	- info on Virtual Function I/O used in guest/hypervisor instances.
+vgaarbiter.txt
+	- info on enable/disable the legacy decoding on different VGA devices
 video-output.txt
 	- sysfs class driver interface to enable/disable a video output device.
 video4linux/
 	- directory with info regarding video/TV/radio cards and linux.
+virtual/
+	- directory with information on the various linux virtualizations.
 vm/
 	- directory with info on the Linux vm code.
+vme_api.txt
+	- file relating info on the VME bus API in linux
 volatile-considered-harmful.txt
 	- Why the "volatile" type class should not be used
 w1/
 	- directory with documents regarding the 1-wire (w1) subsystem.
 watchdog/
 	- how to auto-reboot Linux if it has "fallen and can't get up". ;-)
+wimax/
+	- directory with info about Intel Wireless Wimax Connections
+workqueue.txt
+	- information on the Concurrency Managed Workqueue implementation
 x86/x86_64/
 	- directory with info on Linux support for AMD x86-64 (Hammer) machines.
+xtensa/
+	- directory with documents relating to arch/xtensa port/implementation
+xz.txt
+	- how to make use of the XZ data compression within linux kernel
+zh_CN/
+	- directory with Chinese translations of various documents
 zorro.txt
 	- info on writing drivers for Zorro bus devices found on Amigas.
-- 
1.8.1.2

