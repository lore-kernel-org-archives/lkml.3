Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab3EXJX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 05:23:59 -0400
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:55846 "HELO
	stec-inc.com.stec-inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1760022Ab3EXJXj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 05:23:39 -0400
X-ASG-Debug-ID: 1369387413-053ea947e8b8660001-xx1T2L
X-Barracuda-Envelope-From: osengineering@stec-inc.com
From: OS Engineering <osengineering@stec-inc.com>
To: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
CC: Padmini Balasubramaniyan <padminib@stec-inc.com>,
        Amit Phansalkar <aphansalkar@stec-inc.com>
Subject: EnhanceIO(TM) caching driver features [3/3][PATCH]
Thread-Topic: EnhanceIO(TM) caching driver features [3/3][PATCH]
X-ASG-Orig-Subj: EnhanceIO(TM) caching driver features [3/3][PATCH]
Thread-Index: Ac5YYCNFHkN/uymgTQ6VEPTYMojGsQ==
Date: Fri, 24 May 2013 09:22:08 +0000
Message-ID: <A44CB407BBB85C498149811C52498A4508730C@MYMBX3.stec-inc.ad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.125.250]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas03.stec-inc.ad[172.30.8.21]
X-Barracuda-Start-Time: 1369387413
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: -1001.00
X-Barracuda-Spam-Status: No, SCORE=-1001.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the patch as mentioned in previous email.
-Amit

Recent Changes
1) Added support for device failure handling
2) Added support for 32 bit Arch.
3) Added support for big endian arch(not tested though)
4) Fixed bug : handling larger than 2 TB devices
5) Added support for auto generation of udev rules file
6) ioctl numbering changed ot follow kernel convention
7) Fixed multiple minor driver and CLI bugs
8) Documentation and man page updates

Signed-off-by: Amit Kale <akale@stec-inc.com>
Signed-off-by: Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
Signed-off-by: Akhil Bhansali <abhansali@stec-inc.com>
Signed-off-by: Jinpu Wang <jinpu.wang@profitbricks.com>
Signed-off-by: Dongsu Park <dpark@profitbricks.com>
Signed-off-by: Dmitry Smirnov <onlyjob@member.fsf.org>
Signed-off-by: Nik Martin <nik.martin@gmail.com>
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: sammcj <sammcj@gmail.com>
---
 Documentation/enhanceio/Persistence.txt |   15 +
 Documentation/enhanceio/README.txt      |  226 ++
 drivers/block/Kconfig                   |    2 +
 drivers/block/Makefile                  |    1 +
 drivers/block/enhanceio/Kconfig         |   21 +
 drivers/block/enhanceio/Makefile        |   30 +
 drivers/block/enhanceio/eio.h           | 1150 ++++++++++
 drivers/block/enhanceio/eio_conf.c      | 2628 +++++++++++++++++++++++
 drivers/block/enhanceio/eio_fifo.c      |  239 +++
 drivers/block/enhanceio/eio_ioctl.c     |  157 ++
 drivers/block/enhanceio/eio_ioctl.h     |   86 +
 drivers/block/enhanceio/eio_lru.c       |  322 +++
 drivers/block/enhanceio/eio_main.c      | 3546 +++++++++++++++++++++++++++++++
 drivers/block/enhanceio/eio_mem.c       |  236 ++
 drivers/block/enhanceio/eio_policy.c    |  146 ++
 drivers/block/enhanceio/eio_policy.h    |  105 +
 drivers/block/enhanceio/eio_procfs.c    | 1949 +++++++++++++++++
 drivers/block/enhanceio/eio_rand.c      |  201 ++
 drivers/block/enhanceio/eio_setlru.c    |  170 ++
 drivers/block/enhanceio/eio_setlru.h    |   49 +
 drivers/block/enhanceio/eio_subr.c      |  444 ++++
 drivers/block/enhanceio/eio_ttc.c       | 1688 +++++++++++++++
 drivers/block/enhanceio/eio_ttc.h       |  152 ++
 tools/enhanceio/eio_cli                 |  668 ++++++
 tools/enhanceio/eio_cli.8               |  152 ++
 25 files changed, 14383 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/enhanceio/Persistence.txt
 create mode 100644 Documentation/enhanceio/README.txt
 create mode 100644 drivers/block/enhanceio/Kconfig
 create mode 100644 drivers/block/enhanceio/Makefile
 create mode 100644 drivers/block/enhanceio/eio.h
 create mode 100644 drivers/block/enhanceio/eio_conf.c
 create mode 100644 drivers/block/enhanceio/eio_fifo.c
 create mode 100644 drivers/block/enhanceio/eio_ioctl.c
 create mode 100644 drivers/block/enhanceio/eio_ioctl.h
 create mode 100644 drivers/block/enhanceio/eio_lru.c
 create mode 100644 drivers/block/enhanceio/eio_main.c
 create mode 100644 drivers/block/enhanceio/eio_mem.c
 create mode 100644 drivers/block/enhanceio/eio_policy.c
 create mode 100644 drivers/block/enhanceio/eio_policy.h
 create mode 100644 drivers/block/enhanceio/eio_procfs.c
 create mode 100644 drivers/block/enhanceio/eio_rand.c
 create mode 100644 drivers/block/enhanceio/eio_setlru.c
 create mode 100644 drivers/block/enhanceio/eio_setlru.h
 create mode 100644 drivers/block/enhanceio/eio_subr.c
 create mode 100644 drivers/block/enhanceio/eio_ttc.c
 create mode 100644 drivers/block/enhanceio/eio_ttc.h
 create mode 100755 tools/enhanceio/eio_cli
 create mode 100644 tools/enhanceio/eio_cli.8

diff --git a/Documentation/enhanceio/Persistence.txt b/Documentation/enhanceio/Persistence.txt
new file mode 100644
index 0000000..7a23c8fd
--- /dev/null
+++ b/Documentation/enhanceio/Persistence.txt
@@ -0,0 +1,15 @@
+How to create persistent cache
+==============================
+
+EnhanceIO caches are persistent by default. A udev rule file named
+94-enhanceio-<cache_name>.rules is created, removed by create, delete
+sub-commands in eio_cli.
+
+Note
+------
+1) Creating a writeback cache on root device is not supported. This is because
+   the root device is mounted as read only prior to the processing of udev
+   rules.
+
+2) For certain devices such as loop device the udev rule file will not be
+   generated
diff --git a/Documentation/enhanceio/README.txt b/Documentation/enhanceio/README.txt
new file mode 100644
index 0000000..641c9f2
--- /dev/null
+++ b/Documentation/enhanceio/README.txt
@@ -0,0 +1,226 @@
+			sTec(R) EnhanceIO SSD Caching Software
+				13th May, 2013
+
+
+1. WHAT IS ENHANCEIO?
+
+	EnhanceIO driver is based on EnhanceIO SSD caching software product
+	developed by sTec(R) Inc. EnhanceIO was derived from Facebook's open source
+	Flashcache project. EnhanceIO uses SSDs as cache devices for
+	traditional rotating hard disk drives (referred to as source volumes
+	throughout this document).
+
+	EnhanceIO can work with any block device, be it an entire physical
+	disk, an individual disk partition,  a RAIDed DAS device, a SAN volume,
+	a device mapper volume or a software RAID (md) device.
+
+	The source volume to SSD mapping is a set-associative mapping based on
+	the source volume sector number with a default set size
+	(aka associativity) of 512 blocks and a default block size of 4 KB.
+	Partial cache blocks are not used. The default value of 4 KB is chosen
+	because it is the common I/O block size of most storage systems.  With
+	these default values, each cache set is 2 MB (512 * 4 KB).  Therefore,
+	a 400 GB SSD will have a little less than 200,000 cache sets because a
+	little space is used for storing the meta data on the SSD.
+
+	EnhanceIO supports three caching modes: read-only, write-through, and
+	write-back and three cache replacement policies: random, FIFO, and LRU.
+
+	Read-only caching mode causes EnhanceIO to direct write IO requests only
+	to HDD. Read IO requests are issued to HDD and the data read from HDD is
+	stored on SSD. Subsequent Read requests for the same blocks are carried
+	out from SSD, thus reducing their latency by a substantial amount.
+
+	In Write-through mode - reads are handled similar to Read-only mode.
+	Write-through mode causes EnhanceIO to write application data to both
+	HDD and SSD. Subsequent reads of the same data benefit because they can
+	be served from SSD.
+
+	Write-back improves write latency by writing application requested data
+	only to SSD. This data, referred to as dirty data, is copied later to
+	HDD asynchronously. Reads are handled similar to Read-only and
+	Write-through modes.
+
+2. WHAT HAS ENHANCEIO ADDED TO FLASHCACHE?
+
+2.1. A new write-back engine
+
+	The write-back engine in EnhanceiO has been designed from scratch.
+	Several optimizations have been done. IO completion guarantees have
+	been improved. We have defined limits to let a user control the amount
+	of dirty data in a cache. Clean-up of dirty data is stopped by default
+	under a high load; this can be overridden if required. A user can
+	control the extent to which a single cache set can be filled with dirty
+	data. A background thread cleans-up dirty data at regular intervals.
+	Clean-up is also done at regular intevals by identifying cache sets
+	which have been written least recently.
+
+2.2. Transparent cache
+
+	EnhanceIO does not use device mapper. This enables creation and
+	deletion of caches while a source volume is being used. It's possible
+	to either create or delete cache while a partition is mounted.
+
+	EnhanceIO also supports creation of a cache for a device which contains
+	partitions. With this feature it's possible to create a cache without
+	worrying about having to create several SSD partitions and many
+	separate caches.
+
+
+2.3. Large I/O Support
+
+	Unlike Flashcache, EnhanceIO does not cause source volume I/O requests
+	to be split into cache block size pieces. For the typical SSD cache
+	block size of 4 KB, this means that a write I/O request size of, say,
+	64 KB to the source volume is not split into 16 individual requests of
+	4 KB each. This is a performance improvement over Flashcache. IO
+	codepaths have been substantially modified for this improvement.
+
+2.4. Small Memory Footprint
+
+	Through a special compression algorithm, the meta data RAM usage has
+	been reduced to only 4 bytes for each SSD cache block (versus 16 bytes
+	in Flashcache).  Since the most typical SSD cache block size is 4 KB,
+	this means that RAM usage is 0.1% (1/1000) of SSD capacity.
+	For example, for a 400 GB SSD, EnhanceIO will need only 400 MB to keep
+	all meta data in RAM.
+
+	For an SSD cache block size of 8 KB, RAM usage is 0.05% (1/2000) of SSD
+	capacity.
+
+	The compression algorithm needs at least 32,768 cache sets
+	(i.e., 16 bits to encode the set number). If the SSD capacity is small
+	and there are not at least 32,768 cache sets, EnhanceIO uses 8 bytes of
+	RAM for each SSD cache block. In this case, RAM usage is 0.2% (2/1000)
+	of SSD capacity for a cache block size of 4K.
+
+2.5. Loadable Replacement Policies
+
+	Since the SSD cache size is typically 10%-20% of the source volume
+	size, the set-associative nature of EnhanceIO necessitates cache
+	block replacement.
+
+	The main EnhanceIO kernel module that implements the caching engine
+	uses a random (actually, almost like round-robin) replacement policy
+	that does not require any additional RAM and has the least CPU
+	overhead.  However, there are two additional kernel modules that
+	implement FIFO and LRU replacement policies.  FIFO is the default cache
+	replacement policy because it uses less RAM than LRU.  The FIFO and LRU
+	kernel modules are independent of each other and do not have to be
+	loaded if they are not needed.
+
+	Since the replacement policy modules do not consume much RAM when not
+	used, both modules are typically loaded after the main caching engine
+	is loaded. RAM is used only after a cache has been instantiated to use
+	either the FIFO or the LRU replacement policy.
+
+	Please note that the RAM used for replacement policies is in addition
+	to the RAM used for meta data (mentioned in Section 2.1).  The table
+	below shows how	much RAM each cache replacement policy uses:
+
+		POLICY	RAM USAGE
+		------	---------
+		Random	0
+		FIFO	4 bytes per cache set
+		LRU	4 bytes per cache set + 4 bytes per cache block
+
+2.6. Optimal Alignment of Data Blocks on SSD
+
+	EnhanceIO writes all meta data and data blocks on 4K-aligned blocks
+	on the SSD. This minimizes write amplification and flash wear.
+	It also improves performance.
+
+2.7. Improved device failure handling
+
+	Failure of an SSD device in read-only and write-through modes is
+	handled gracefully by allowing I/O to continue to/from the
+	source volume. An application may notice a drop in performance but it
+	will not receive any I/O errors.
+
+	Failure of an SSD device in write-back mode obviously results in the
+	loss of dirty blocks in the cache. To guard against this data loss, two
+	SSD devices can be mirrored via RAID 1.
+
+	EnhanceIO identifies device failures based on error codes. Depending on
+	whether the failure is likely to be intermittent or permanent, it takes
+	the best suited action.
+
+2.8. Coding optimizations
+
+	Several coding optizations have been done to reduce CPU usage.  These
+	include removing queues which are not required for write-through and
+	read-only cache modes, splitting of a single large spinlock, and more.
+	Most of the code paths in flashcache have been substantially
+	restructured.
+
+3. EnhanceIO usage
+
+3.1. Cache creation, deletion and editing properties
+
+	eio_cli utility is used for creating and deleting caches and editing
+	their properties. Manpage for this utility eio_cli(8) provides more
+	information.
+
+3.2. Making a cache configuration persistent
+
+	It's essential that a cache be resumed before any applications or a
+	filesystem use the source volume during a bootup. If a cache is enabled
+	after a source volume is written to, stale data may be present in the
+	cache. It may cause data corruption. The document Persistent.txt
+	describes how to enable a cache during bootup using udev scripts.
+
+	In case an SSD does not come up during a bootup, it's ok to allow read
+	and write access to HDD only in the case of a Write-through or a
+	read-only cache. A cache should be created again when SSD becomes
+	available. If a previous cache configuration is resumed, it may cause
+	stale data to be read.
+
+3.3. Using a Write-back cache
+
+	It's absolutely necessary to make a Write-back cache configuration
+	persistent. This is required particularly in the case of an OS crash or
+	a power failure.  A Write-back cache may contain dirty blocks which
+	haven't been written to HDD yet. Reading the source volume without
+	enabling the cache will cause incorrect data to be read.
+
+	In case an SSD does not come up during a bootup, access to HDD should
+	stopped. It should be enabled only after SSD comes-up and a cache is
+	enabled.
+
+	Write-back cache needs to perform clean operation in order to flush the
+	dirty data to the source device(HDD). The clean can be either trigerred
+	by the user or automatically initiated, based on preconfigured
+	thresholds. These thresholds are described below. They can be set using
+	sysctl calls.
+
+	a) Dirty high threshold (%) : The upper limit on percentage of dirty
+	   blocks in the entire cache.
+	b) Dirty low threshold (%) : The lower limit on percentage of dirty
+	   blocks in the entire cache.
+	c) Dirty set high threshold (%) : The upper limit on percentage of dirty
+	   blocks in a set.
+	d) Dirty set low threshold (%) : The lower limit on percentage of dirty
+	   blocks in a set.
+	e) Automatic clean-up threshold : An automatic clean-up of the cache
+	   will occur only if the number of outstanding I/O requests from the
+	   HDD is below the threshold.
+	f) Time based clean-up interval (minutes) : This option allows you to
+	   specify an interval between each clean-up process.
+
+	Clean is trigerred when one of the upper thresholds or time based clean
+	threshold is met and stops when all the lower thresholds are met.
+
+3.4. Using a Large SSD on a 32 bit machine
+
+	EnhanceIO requires memory equivalent to about 0.1 to 0.2 % of the ssd
+	capacity to store the in-core metadata using a vmalloced memory. On a
+	32 bit machine, vmalloc may fail on requests for such large amount of
+	memory due to the lack of virtual address space.
+
+4. ACKNOWLEDGEMENTS
+
+	sTec(R) acknowledges Facebook and in particular Mohan Srinivasan
+	for the design, development, and release of Flashcache as an
+	open source project.
+
+	Flashcache, in turn, is based on DM-Cache by Ming Zhao.
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index b81ddfe..e9fd84c 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -541,4 +541,6 @@ config BLK_DEV_RSXX
 	  To compile this driver as a module, choose M here: the
 	  module will be called rsxx.
 
+source "drivers/block/enhanceio/Kconfig"
+
 endif # BLK_DEV
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index a3b4023..49ef222 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,5 +41,6 @@ obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 obj-$(CONFIG_BLK_DEV_PCIESSD_MTIP32XX)	+= mtip32xx/
 
 obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
+obj-$(CONFIG_ENHANCEIO)		+= enhanceio/
 
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/enhanceio/Kconfig b/drivers/block/enhanceio/Kconfig
new file mode 100644
index 0000000..05fbb50
--- /dev/null
+++ b/drivers/block/enhanceio/Kconfig
@@ -0,0 +1,21 @@
+#
+# EnhanceIO caching solution by sTec(R) INC.
+#
+
+config ENHANCEIO
+	tristate "Enable EnhanceIO"
+	depends on PROC_FS
+	default n
+	---help---
+	Based on Facebook's open source Flashcache project developed by
+	Mohan Srinivasan and hosted at "http://github.com", EnhanceIO is
+	a collection of (currently three) loadable kernel modules for
+	using SSDs as cache devices for traditional rotating hard disk
+
+	The caching engine is a loadable kernel module ("enhanceio.ko")
+	implemented as a device mapper target.	The cache replacement
+	policies are implemented as loadable kernel modules
+	("enhanceio_fifo.ko", "enhanceio_lru.ko") that register with
+	the caching engine module.
+
+	If unsure, say N.
diff --git a/drivers/block/enhanceio/Makefile b/drivers/block/enhanceio/Makefile
new file mode 100644
index 0000000..f866dde
--- /dev/null
+++ b/drivers/block/enhanceio/Makefile
@@ -0,0 +1,30 @@
+#
+# Makefile for EnhanceIO block device caching.
+#
+CONFIG_ENHANCEIO ?= m
+ifeq ($(KERNEL_TREE),)
+KERNEL_TREE = /lib/modules/$(shell uname -r)/build
+endif
+$(info KERNEL_TREE=$(KERNEL_TREE))
+all:
+	make -C $(KERNEL_TREE) M=$(PWD) V=1
+
+.PHONY: clean
+clean:
+	$(RM) -v *.o *.ko *.order *.symvers enhancio_*
+
+obj-$(CONFIG_ENHANCEIO)	+= enhanceio.o enhanceio_lru.o enhanceio_fifo.o \
+			   enhanceio_rand.o
+enhanceio-y	+= \
+	eio_conf.o \
+	eio_ioctl.o \
+	eio_main.o \
+	eio_mem.o \
+	eio_policy.o \
+	eio_procfs.o \
+	eio_setlru.o \
+	eio_subr.o \
+	eio_ttc.o
+enhanceio_fifo-y += eio_fifo.o
+enhanceio_lru-y	+= eio_lru.o
+enhanceio_rand-y += eio_rand.o
diff --git a/drivers/block/enhanceio/eio.h b/drivers/block/enhanceio/eio.h
new file mode 100644
index 0000000..fcb104b
--- /dev/null
+++ b/drivers/block/enhanceio/eio.h
@@ -0,0 +1,1150 @@
+/*
+ *  eio.h
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Saied Kazemi <skazemi@stec-inc.com>
+ *   Added EnhanceIO-specific code.
+ *  Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *   Common data structures and definitions between Windows and Linux.
+ *  Amit Kale <akale@stec-inc.com>
+ *   Restructured much of the io code to split bio within map function instead
+ *   of letting dm do it.
+ *  Amit Kale <akale@stec-inc.com>
+ *  Harish Pujari <hpujari@stec-inc.com>
+ *   Designed and implemented the writeback caching mode
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <asm/atomic.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+#include <linux/hash.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/pagemap.h>
+#include <linux/random.h>
+#include <linux/hardirq.h>
+#include <linux/sysctl.h>
+#include <linux/version.h>
+#include <linux/reboot.h>
+#include <linux/delay.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-kcopyd.h>
+#include <linux/sort.h>         /* required for eio_subr.c */
+#include <linux/kthread.h>
+#include <linux/jiffies.h>
+#include <linux/vmalloc.h>      /* for sysinfo (mem) variables */
+#include <linux/mm.h>
+#include <scsi/scsi_device.h>   /* required for SSD failure handling */
+/* resolve conflict with scsi/scsi_device.h */
+#ifdef QUEUED
+#undef QUEUED
+#endif
+
+#if defined(__KERNEL__) && !defined(CONFIG_PROC_FS)
+#error "EnhanceIO requires CONFIG_PROC_FS"
+#endif                          /* __KERNEL__ && !CONFIG_PROC_FS */
+
+#ifndef EIO_INC_H
+#define EIO_INC_H
+
+/* Bit offsets for wait_on_bit_lock() */
+#define EIO_UPDATE_LIST         0
+#define EIO_HANDLE_REBOOT       1
+
+/*
+ * It is to carry out 64bit division
+ * on 32bit architecture.
+ */
+static inline uint64_t
+EIO_CALCULATE_PERCENTAGE(uint64_t x64, uint64_t y64)
+{
+	uint64_t result;
+	uint32_t h_y32 = y64 >> 32;
+
+	result = x64 * 100;
+
+	while (h_y32) {
+		h_y32 >>= 1;
+		y64 >>= 1;
+		result >>= 1;
+	}
+	do_div(result, y64);
+	return result;
+}
+
+
+static inline uint64_t
+EIO_DIV(uint64_t dividend_64, uint32_t divisor_32)
+{
+	uint64_t result;
+
+	result = dividend_64;
+	do_div(result, divisor_32);
+	return result;
+}
+
+
+static inline uint32_t
+EIO_REM(uint64_t dividend_64, uint32_t divisor_32)
+{
+	uint64_t temp;
+
+	temp = dividend_64;
+	return do_div(temp, divisor_32);
+}
+
+static inline sector_t
+eio_to_sector(uint64_t size_in_bytes)
+{
+	return size_in_bytes >> 9;
+}
+
+struct eio_control_s {
+	unsigned long synch_flags;
+};
+
+int eio_wait_schedule(void *unused);
+
+struct eio_event {
+	struct task_struct *process;    /* handle of the sleeping process */
+};
+
+typedef long int index_t;
+
+extern int eio_reboot_notified;
+extern mempool_t *_io_pool;
+extern struct eio_control_s *eio_control;
+extern struct work_struct _kcached_wq;
+extern int eio_force_warm_boot;
+extern atomic_t nr_cache_jobs;
+extern mempool_t *_job_pool;
+
+/*
+ * This file has three sections as follows:
+ *
+ *      Section 1: User space only
+ *      Section 2: User space and kernel
+ *      Section 3: Kernel only
+ *
+ * Each section may contain its own subsections.
+ */
+
+/*
+ * Begin Section 1: User space only.
+ */
+
+/*
+ * End Section 1: User space only.
+ */
+
+/*
+ * Begin Section 2: User space and kernel.
+ */
+
+/* States of a cache block */
+#define INVALID                 0x0001
+#define VALID                   0x0002  /* Valid */
+#define DISKREADINPROG          0x0004  /* Read from disk in progress */
+#define DISKWRITEINPROG         0x0008  /* Write to disk in progress */
+#define CACHEREADINPROG         0x0010  /* Read from cache in progress */
+#define CACHEWRITEINPROG        0x0020  /* Write to cache in progress */
+#define DIRTY                   0x0040  /* Dirty, needs writeback to disk */
+#define QUEUED                  0x0080  /* Other requests are queued for this block */
+
+#define BLOCK_IO_INPROG (DISKREADINPROG | DISKWRITEINPROG | \
+			 CACHEREADINPROG | CACHEWRITEINPROG)
+#define DIRTY_INPROG    (VALID | DIRTY | CACHEWRITEINPROG)      /* block being dirtied */
+#define CLEAN_INPROG    (VALID | DIRTY | DISKWRITEINPROG)       /* ongoing clean */
+#define ALREADY_DIRTY   (VALID | DIRTY)                         /* block which is dirty to begin with for an I/O */
+
+/*
+ * This is a special state used only in the following scenario as
+ * part of device (SSD) failure handling:
+ *
+ * ------| dev fail |------| dev resume |------------
+ *   ...-<--- Tf --><- Td -><---- Tr ---><-- Tn ---...
+ * |---- Normal ----|-- Degraded -------|-- Normal ---|
+ *
+ * Tf: Time during device failure.
+ * Td: Time after failure when the cache is in degraded mode.
+ * Tr: Time when the SSD comes back online.
+ *
+ * When a failed SSD is added back again, it should be treated
+ * as a cold SSD.
+ *
+ * If Td is very small, then there can be IOs that were initiated
+ * before or during Tf, and did not finish until the end of Tr.  From
+ * the IO's viewpoint, the SSD was there when the IO was initiated
+ * and it was there when the IO was finished.  These IOs need special
+ * handling as described below.
+ *
+ * To add the SSD as a cold cache device, we initialize all blocks
+ * to INVALID, execept for the ones that had IOs in progress before
+ * or during Tf.  We mark such blocks as both VALID and INVALID.
+ * These blocks will be marked INVALID when finished.
+ */
+#define NO_SSD_IO_INPROG        (VALID | INVALID)
+
+/*
+ * On Flash (cache metadata) Structures
+ */
+#define CACHE_MD_STATE_DIRTY            0x55daddee
+#define CACHE_MD_STATE_CLEAN            0xacceded1
+#define CACHE_MD_STATE_FASTCLEAN        0xcafebabf
+#define CACHE_MD_STATE_UNSTABLE         0xdeaddeee
+
+/* Do we have a read cache or a read-write cache */
+#define CACHE_MODE_WB           1
+#define CACHE_MODE_RO           2
+#define CACHE_MODE_WT           3
+#define CACHE_MODE_FIRST        CACHE_MODE_WB
+#define CACHE_MODE_LAST         CACHE_MODE_WT
+#define CACHE_MODE_DEFAULT      CACHE_MODE_WT
+
+#define DEV_PATHLEN             128
+#define EIO_SUPERBLOCK_SIZE     4096
+
+#define EIO_CLEAN_ABORT         0x00000000
+#define EIO_CLEAN_START         0x00000001
+#define EIO_CLEAN_KEEP          0x00000002
+
+/* EIO magic number */
+#define EIO_MAGIC               0xE10CAC6E
+#define EIO_BAD_MAGIC           0xBADCAC6E
+
+/* EIO version */
+#define EIO_SB_VERSION          3       /* kernel superblock version */
+#define EIO_SB_MAGIC_VERSION    3       /* version in which magic number was introduced */
+
+union eio_superblock {
+	struct superblock_fields {
+		__le64 size;                    /* Cache size */
+		__le32 block_size;              /* Cache block size */
+		__le32 assoc;                   /* Cache associativity */
+		__le32 cache_sb_state;          /* Clean shutdown ? */
+		char cache_devname[DEV_PATHLEN];
+		__le64 cache_devsize;
+		char disk_devname[DEV_PATHLEN];
+		__le64 disk_devsize;
+		__le32 cache_version;
+		char cache_name[DEV_PATHLEN];
+		__le32 mode;
+		__le32 repl_policy;
+		__le32 cache_flags;
+		__le32 magic;
+		__le32 cold_boot;               /* cache to be started as cold after boot */
+		char ssd_uuid[DEV_PATHLEN];
+		__le64 cache_md_start_sect;     /* cache metadata start (8K aligned) */
+		__le64 cache_data_start_sect;   /* cache data start (8K aligned) */
+		__le32 dirty_high_threshold;
+		__le32 dirty_low_threshold;
+		__le32 dirty_set_high_threshold;
+		__le32 dirty_set_low_threshold;
+		__le32 time_based_clean_interval;
+		__le32 autoclean_threshold;
+	} sbf;
+	u_int8_t padding[EIO_SUPERBLOCK_SIZE];
+};
+
+/*
+ * For EnhanceIO, we move the superblock from sector 0 to 128
+ * and give it a full 4K.  Also, in addition to the single
+ * "red-zone" buffer that separates metadata sectors from the
+ * data sectors, we allocate extra sectors so that we can
+ * align the data sectors on a 4K boundary.
+ *
+ *    64K    4K  variable variable  8K variable  variable
+ * +--------+--+--------+---------+---+--------+---------+
+ * | unused |SB| align1 |metadata | Z | align2 | data... |
+ * +--------+--+--------+---------+---+--------+---------+
+ * <------------- dmc->md_sectors ------------>
+ */
+#define EIO_UNUSED_SECTORS              128
+#define EIO_SUPERBLOCK_SECTORS          8
+#define EIO_REDZONE_SECTORS             16
+#define EIO_START                       0
+
+#define EIO_ALIGN1_SECTORS(index)               ((index % 16) ? (24 - (index % 16)) : 8)
+#define EIO_ALIGN2_SECTORS(index)               ((index % 16) ? (16 - (index % 16)) : 0)
+#define EIO_SUPERBLOCK_START                    (EIO_START + EIO_UNUSED_SECTORS)
+#define EIO_METADATA_START(hd_start_sect)       (EIO_SUPERBLOCK_START +	\
+						 EIO_SUPERBLOCK_SECTORS + \
+						 EIO_ALIGN1_SECTORS(hd_start_sect))
+
+#define EIO_EXTRA_SECTORS(start_sect, md_sects) (EIO_METADATA_START(start_sect) + \
+						 EIO_REDZONE_SECTORS + \
+						 EIO_ALIGN2_SECTORS(md_sects))
+
+/*
+ * We do metadata updates only when a block trasitions from DIRTY -> CLEAN
+ * or from CLEAN -> DIRTY. Consequently, on an unclean shutdown, we only
+ * pick up blocks that are marked (DIRTY | CLEAN), we clean these and stick
+ * them in the cache.
+ * On a clean shutdown, we will sync the state for every block, and we will
+ * load every block back into cache on a restart.
+ */
+struct flash_cacheblock {
+	__le64 dbn;           /* Sector number of the cached block */
+	__le64 cache_state;
+};
+
+/* blksize in terms of no. of sectors */
+#define BLKSIZE_2K      4
+#define BLKSIZE_4K      8
+#define BLKSIZE_8K      16
+
+/*
+ * Give me number of pages to allocated for the
+ * iosize x specified in terms of bytes.
+ */
+#define IO_PAGE_COUNT(x)        (((x) + (PAGE_SIZE - 1)) / PAGE_SIZE)
+
+/*
+ * Macro that calculates number of biovecs to be
+ * allocated depending on the iosize and cache
+ * block size.
+ */
+#define IO_BVEC_COUNT(x, blksize) ({		\
+					   int count = IO_PAGE_COUNT(x);	   \
+					   switch ((blksize)) {			    \
+					   case BLKSIZE_2K:			   \
+						   count = count * 2;		   \
+						   break;			   \
+					   case BLKSIZE_4K:			   \
+					   case BLKSIZE_8K:			   \
+						   break;			   \
+					   }					   \
+					   count;				   \
+				   })
+
+#define MD_MAX_NR_PAGES                         16
+#define MD_BLOCKS_PER_PAGE                      ((PAGE_SIZE) / sizeof(struct flash_cacheblock))
+#define INDEX_TO_MD_PAGE(INDEX)                 ((INDEX) / MD_BLOCKS_PER_PAGE)
+#define INDEX_TO_MD_PAGE_OFFSET(INDEX)          ((INDEX) % MD_BLOCKS_PER_PAGE)
+
+#define MD_BLOCKS_PER_SECTOR                    (512 / (sizeof(struct flash_cacheblock)))
+#define INDEX_TO_MD_SECTOR(INDEX)               (EIO_DIV((INDEX), MD_BLOCKS_PER_SECTOR))
+#define INDEX_TO_MD_SECTOR_OFFSET(INDEX)        (EIO_REM((INDEX), MD_BLOCKS_PER_SECTOR))
+#define MD_BLOCKS_PER_CBLOCK(dmc)               (MD_BLOCKS_PER_SECTOR * (dmc)->block_size)
+
+#define METADATA_IO_BLOCKSIZE                   (256 * 1024)
+#define METADATA_IO_BLOCKSIZE_SECT              (METADATA_IO_BLOCKSIZE / 512)
+#define SECTORS_PER_PAGE                        ((PAGE_SIZE) / 512)
+
+/*
+ * Cache persistence.
+ */
+#define CACHE_RELOAD            1
+#define CACHE_CREATE            2
+#define CACHE_FORCECREATE       3
+
+/*
+ * Cache replacement policy.
+ */
+#define CACHE_REPL_FIFO         1
+#define CACHE_REPL_LRU          2
+#define CACHE_REPL_RANDOM       3
+#define CACHE_REPL_FIRST        CACHE_REPL_FIFO
+#define CACHE_REPL_LAST         CACHE_REPL_RANDOM
+#define CACHE_REPL_DEFAULT      CACHE_REPL_FIFO
+
+struct eio_policy_and_name {
+	u8 p;
+	char *n;
+};
+
+
+static const struct eio_policy_and_name eio_policy_names[] = {
+	{ CACHE_REPL_FIFO,   "fifo" },
+	{ CACHE_REPL_LRU,    "lru"  },
+	{ CACHE_REPL_RANDOM, "rand" },
+};
+
+
+/*
+ * Default cache parameters.
+ */
+#define DEFAULT_CACHE_ASSOC     512
+#define DEFAULT_CACHE_BLKSIZE   8       /* 4 KB */
+
+/*
+ * Valid commands that can be written to "control".
+ * NOTE: Update CACHE_CONTROL_FLAG_MAX value whenever a new control flag is added
+ */
+#define CACHE_CONTROL_FLAG_MAX  7
+#define CACHE_VERBOSE_OFF       0
+#define CACHE_VERBOSE_ON        1
+#define CACHE_WRITEBACK_ON      2       /* register write back variables */
+#define CACHE_WRITEBACK_OFF     3
+#define CACHE_INVALIDATE_ON     4       /* register invalidate variables */
+#define CACHE_INVALIDATE_OFF    5
+#define CACHE_FAST_REMOVE_ON    6       /* do not write MD when destroying cache */
+#define CACHE_FAST_REMOVE_OFF   7
+
+/*
+ * Bit definitions in "cache_flags". These are exported in Linux as
+ * hex in the "flags" output line of /proc/enhanceio/<cache_name>/config.
+ */
+
+#define CACHE_FLAGS_VERBOSE             (1 << 0)
+#define CACHE_FLAGS_INVALIDATE          (1 << 1)
+#define CACHE_FLAGS_FAST_REMOVE         (1 << 2)
+#define CACHE_FLAGS_DEGRADED            (1 << 3)
+#define CACHE_FLAGS_SSD_ADD_INPROG      (1 << 4)
+#define CACHE_FLAGS_MD8                 (1 << 5)        /* using 8-byte metadata (instead of 4-byte md) */
+#define CACHE_FLAGS_FAILED              (1 << 6)
+#define CACHE_FLAGS_STALE               (1 << 7)
+#define CACHE_FLAGS_SHUTDOWN_INPROG     (1 << 8)
+#define CACHE_FLAGS_MOD_INPROG          (1 << 9)        /* cache modification such as edit/delete in progress */
+#define CACHE_FLAGS_DELETED             (1 << 10)
+#define CACHE_FLAGS_INCORE_ONLY         (CACHE_FLAGS_DEGRADED |		\
+					 CACHE_FLAGS_SSD_ADD_INPROG |	\
+					 CACHE_FLAGS_FAILED |		\
+					 CACHE_FLAGS_SHUTDOWN_INPROG |	\
+					 CACHE_FLAGS_MOD_INPROG |	\
+					 CACHE_FLAGS_STALE |		\
+					 CACHE_FLAGS_DELETED)   /* need a proper definition */
+
+/* flags that govern cold/warm enable after reboot */
+#define BOOT_FLAG_COLD_ENABLE           (1 << 0)        /* enable the cache as cold */
+#define BOOT_FLAG_FORCE_WARM            (1 << 1)        /* override the cold enable flag */
+
+enum dev_notifier {
+	NOTIFY_INITIALIZER,
+	NOTIFY_SSD_ADD,
+	NOTIFY_SSD_REMOVED,
+	NOTIFY_SRC_REMOVED
+};
+
+/*
+ * End Section 2: User space and kernel.
+ */
+
+/*
+ * Begin Section 3: Kernel only.
+ */
+#if defined(__KERNEL__)
+
+/*
+ * Subsection 3.1: Definitions.
+ */
+
+#define EIO_SB_VERSION          3       /* kernel superblock version */
+
+/* kcached/pending job states */
+#define READCACHE               1
+#define WRITECACHE              2
+#define READDISK                3
+#define WRITEDISK               4
+#define READFILL                5       /* Read Cache Miss Fill */
+#define INVALIDATE              6
+
+/* Cache persistence */
+#define CACHE_RELOAD            1
+#define CACHE_CREATE            2
+#define CACHE_FORCECREATE       3
+
+/* Sysctl defined */
+#define MAX_CLEAN_IOS_SET       2
+#define MAX_CLEAN_IOS_TOTAL     4
+
+/*
+ * TBD
+ * Rethink on max, min, default values
+ */
+#define DIRTY_HIGH_THRESH_DEF           30
+#define DIRTY_LOW_THRESH_DEF            10
+#define DIRTY_SET_HIGH_THRESH_DEF       100
+#define DIRTY_SET_LOW_THRESH_DEF        30
+
+#define CLEAN_FACTOR(sectors)           ((sectors) >> 25)       /* in 16 GB multiples */
+#define TIME_BASED_CLEAN_INTERVAL_DEF(dmc)      (uint32_t)(CLEAN_FACTOR((dmc)->cache_size) ? \
+							   CLEAN_FACTOR((dmc)->cache_size) : 1)
+#define TIME_BASED_CLEAN_INTERVAL_MAX   720     /* in minutes */
+
+#define AUTOCLEAN_THRESH_DEF            128     /* Number of I/Os which puts a hold on time based cleaning */
+#define AUTOCLEAN_THRESH_MAX            1024    /* Number of I/Os which puts a hold on time based cleaning */
+
+/* Inject a 5s delay between cleaning blocks and metadata */
+#define CLEAN_REMOVE_DELAY      5000
+
+/*
+ * Subsection 2: Data structures.
+ */
+
+typedef void (*eio_notify_fn)(int error, void *context);
+
+/*
+ * 4-byte metadata support.
+ */
+
+#define EIO_MAX_SECTOR                  (((u_int64_t)1) << 40)
+#ifdef __BIG_ENDIAN
+struct md4 {
+	u_int8_t cache_state;
+	char dbn_bytes[3];
+};
+#else /* Little Endian */
+struct md4 {
+	char dbn_bytes[3];
+	u_int8_t cache_state;
+};
+#endif
+
+struct cacheblock {
+	union {
+		u_int32_t u_i_md4;
+		struct md4 u_s_md4;
+	} md4_u;
+};
+
+#define EIO_MD4_DBN_BITS                (32 - 8)        /* 8 bits for state */
+#define EIO_MD4_DBN_MASK                ((1 << EIO_MD4_DBN_BITS) - 1)
+#define EIO_MD4_INVALID                 (INVALID << EIO_MD4_DBN_BITS)
+
+/*
+ * 8-byte metadata support.
+ */
+#ifdef __BIG_ENDIAN
+struct md8 {
+	u_int8_t cache_state;
+	char dbn_bytes[7];
+};
+#else /* little endian*/
+struct md8 {
+	char dbn_bytes[7];
+	u_int8_t cache_state;
+};
+#endif
+struct cacheblock_md8 {
+	union {
+		u_int64_t u_i_md8;
+		struct md8 u_s_md8;
+	} md8_u;
+};
+
+#define EIO_MD8_DBN_BITS                (64 - 8)        /* 8 bits for state */
+#define EIO_MD8_DBN_MASK                ((((u_int64_t)1) << EIO_MD8_DBN_BITS) - 1)
+#define EIO_MD8_INVALID                 (((u_int64_t)INVALID) << EIO_MD8_DBN_BITS)
+#define EIO_MD8(dmc)                    CACHE_MD8_IS_SET(dmc)
+
+/* Structure used for metadata update on-disk and in-core for writeback cache */
+struct mdupdate_request {
+	struct list_head list;          /* to build mdrequest chain */
+	struct work_struct work;        /* work structure */
+	struct cache_c *dmc;            /* cache pointer */
+	index_t set;                    /* set index */
+	unsigned md_size;               /* metadata size */
+	unsigned mdbvec_count;          /* count of bvecs allocated. */
+	struct bio_vec *mdblk_bvecs;    /* bvecs for updating md_blocks */
+	atomic_t holdcount;             /* I/O hold count */
+	struct eio_bio *pending_mdlist; /* ebios pending for md update */
+	struct eio_bio *inprog_mdlist;  /* ebios processed for md update */
+	int error;                      /* error during md update */
+	struct mdupdate_request *next;  /* next mdreq in the mdreq list .TBD. Deprecate */
+};
+
+#define SETFLAG_CLEAN_INPROG    0x00000001      /* clean in progress on a set */
+#define SETFLAG_CLEAN_WHOLE     0x00000002      /* clean the set fully */
+
+/* Structure used for doing operations and storing cache set level info */
+struct cache_set {
+	struct list_head list;
+	u_int32_t nr_dirty;             /* number of dirty blocks */
+	spinlock_t cs_lock;             /* spin lock to protect struct fields */
+	struct rw_semaphore rw_lock;    /* reader-writer lock used for clean */
+	unsigned int flags;             /* misc cache set specific flags */
+	struct mdupdate_request *mdreq; /* metadata update request pointer */
+};
+
+struct eio_errors {
+	int disk_read_errors;
+	int disk_write_errors;
+	int ssd_read_errors;
+	int ssd_write_errors;
+	int memory_alloc_errors;
+	int no_cache_dev;
+	int no_source_dev;
+};
+
+/*
+ * Stats. Note that everything should be "atomic64_t" as
+ * code relies on it.
+ */
+#define SECTOR_STATS(statval, io_size)	\
+	atomic64_add(eio_to_sector(io_size), &statval);
+
+struct eio_stats {
+	atomic64_t reads;               /* Number of reads */
+	atomic64_t writes;              /* Number of writes */
+	atomic64_t read_hits;           /* Number of cache hits */
+	atomic64_t write_hits;          /* Number of write hits (includes dirty write hits) */
+	atomic64_t dirty_write_hits;    /* Number of "dirty" write hits */
+	atomic64_t cached_blocks;       /* Number of cached blocks */
+	atomic64_t rd_replace;          /* Number of read cache replacements. TBD modify def doc */
+	atomic64_t wr_replace;          /* Number of write cache replacements. TBD modify def doc */
+	atomic64_t noroom;              /* No room in set */
+	atomic64_t cleanings;           /* blocks cleaned TBD modify def doc */
+	atomic64_t md_write_dirty;      /* Metadata sector writes dirtying block */
+	atomic64_t md_write_clean;      /* Metadata sector writes cleaning block */
+	atomic64_t md_ssd_writes;       /* How many md ssd writes did we do ? */
+	atomic64_t uncached_reads;
+	atomic64_t uncached_writes;
+	atomic64_t uncached_map_size;
+	atomic64_t uncached_map_uncacheable;
+	atomic64_t disk_reads;
+	atomic64_t disk_writes;
+	atomic64_t ssd_reads;
+	atomic64_t ssd_writes;
+	atomic64_t ssd_readfills;
+	atomic64_t ssd_readfill_unplugs;
+	atomic64_t readdisk;
+	atomic64_t writedisk;
+	atomic64_t readcache;
+	atomic64_t readfill;
+	atomic64_t writecache;
+	atomic64_t wrtime_ms;   /* total write time in ms */
+	atomic64_t rdtime_ms;   /* total read time in ms */
+	atomic64_t readcount;   /* total reads received so far */
+	atomic64_t writecount;  /* total writes received so far */
+};
+
+#define PENDING_JOB_HASH_SIZE                   32
+#define PENDING_JOB_HASH(index)                 ((index) % PENDING_JOB_HASH_SIZE)
+#define SIZE_HIST                               (128 + 1)
+#define EIO_COPY_PAGES                          1024    /* Number of pages for I/O */
+#define MIN_JOBS                                1024
+#define MIN_EIO_IO                              4096
+#define MIN_DMC_BIO_PAIR                        8192
+
+/* Structure representing a sequence of sets(first to last set index) */
+struct set_seq {
+	index_t first_set;
+	index_t last_set;
+	struct set_seq *next;
+};
+
+/* EIO system control variables(tunables) */
+/*
+ * Adding synchonization is not worth the benefits.
+ */
+struct eio_sysctl {
+	uint32_t error_inject;
+	int32_t fast_remove;
+	int32_t zerostats;
+	int32_t do_clean;
+	uint32_t dirty_high_threshold;
+	uint32_t dirty_low_threshold;
+	uint32_t dirty_set_high_threshold;
+	uint32_t dirty_set_low_threshold;
+	uint32_t time_based_clean_interval;    /* time after which dirty sets should clean */
+	int32_t autoclean_threshold;
+	int32_t mem_limit_pct;
+	int32_t control;
+	u_int64_t invalidate;
+};
+
+/* forward declaration */
+struct lru_ls;
+
+/* Replacement for 'struct dm_dev' */
+struct eio_bdev {
+	struct block_device *bdev;
+	fmode_t mode;
+	char name[16];
+};
+
+/* Replacement for 'struct dm_io_region */
+struct eio_io_region {
+	struct block_device *bdev;
+	sector_t sector;
+	sector_t count;         /* If zero the region is ignored */
+};
+
+/*
+ * Cache context
+ */
+struct cache_c {
+	struct list_head cachelist;
+	make_request_fn *origmfn;
+	char dev_info;          /* partition or whole device */
+
+	sector_t dev_start_sect;
+	sector_t dev_end_sect;
+	int cache_rdonly;               /* protected by ttc_write lock */
+	struct eio_bdev *disk_dev;      /* Source device */
+	struct eio_bdev *cache_dev;     /* Cache device */
+	struct cacheblock *cache;       /* Hash table for cache blocks */
+	struct cache_set *cache_sets;
+	struct cache_c *next_cache;
+	struct kcached_job *readfill_queue;
+	struct work_struct readfill_wq;
+
+	struct list_head cleanq;        /* queue of sets to awaiting clean */
+	struct eio_event clean_event;   /* event to wait for, when cleanq is empty */
+	spinlock_t clean_sl;            /* spinlock to protect cleanq etc */
+	void *clean_thread;             /* OS specific thread object to handle cleanq */
+	int clean_thread_running;       /* to indicate that clean thread is running */
+	atomic64_t clean_pendings;      /* Number of sets pending to be cleaned */
+	struct bio_vec *clean_dbvecs;   /* Data bvecs for clean set */
+	struct page **clean_mdpages;    /* Metadata pages for clean set */
+	int dbvec_count;
+	int mdpage_count;
+	int clean_excess_dirty;         /* Clean in progress to bring cache dirty blocks in limits */
+	atomic_t clean_index;           /* set being cleaned, in case of force clean */
+
+	u_int64_t md_start_sect;        /* Sector no. at which Metadata starts */
+	u_int64_t md_sectors;           /* Numbers of metadata sectors, including header */
+	u_int64_t disk_size;            /* Source size */
+	u_int64_t size;                 /* Cache size */
+	u_int32_t assoc;                /* Cache associativity */
+	u_int32_t block_size;           /* Cache block size */
+	u_int32_t block_shift;          /* Cache block size in bits */
+	u_int32_t block_mask;           /* Cache block mask */
+	u_int32_t consecutive_shift;    /* Consecutive blocks size in bits */
+	u_int32_t persistence;          /* Create | Force create | Reload */
+	u_int32_t mode;                 /* CACHE_MODE_{WB, RO, WT} */
+	u_int32_t cold_boot;            /* Cache should be started as cold after boot */
+	u_int32_t bio_nr_pages;         /* number of hardware sectors supported by SSD in terms of PAGE_SIZE */
+
+	spinlock_t cache_spin_lock;
+	long unsigned int cache_spin_lock_flags;        /* See comments above spin_lock_irqsave_FLAGS */
+	atomic_t nr_jobs;                               /* Number of I/O jobs */
+
+	u_int32_t cache_flags;
+	u_int32_t sb_state;     /* Superblock state */
+	u_int32_t sb_version;   /* Superblock version */
+
+	int readfill_in_prog;
+	struct eio_stats eio_stats;     /* Run time stats */
+	struct eio_errors eio_errors;   /* Error stats */
+	int max_clean_ios_set;          /* Max cleaning IOs per set */
+	int max_clean_ios_total;        /* Total max cleaning IOs */
+	int clean_inprog;
+	atomic64_t nr_dirty;
+	atomic64_t nr_ios;
+	atomic64_t size_hist[SIZE_HIST];
+
+	void *sysctl_handle_common;
+	void *sysctl_handle_writeback;
+	void *sysctl_handle_invalidate;
+
+	struct eio_sysctl sysctl_pending;       /* sysctl values pending to become active */
+	struct eio_sysctl sysctl_active;        /* sysctl currently active */
+
+	char cache_devname[DEV_PATHLEN];
+	char disk_devname[DEV_PATHLEN];
+	char cache_name[DEV_PATHLEN];
+	char cache_gendisk_name[DEV_PATHLEN];   /* Used for SSD failure checks */
+	char cache_srcdisk_name[DEV_PATHLEN];   /* Used for SRC failure checks */
+	char ssd_uuid[DEV_PATHLEN];
+
+	struct cacheblock_md8 *cache_md8;
+	sector_t cache_size;                            /* Cache size passed to ctr(), used by dmsetup info */
+	sector_t cache_dev_start_sect;                  /* starting sector of cache device */
+	u_int64_t index_zero;                           /* index of cache block with starting sector 0 */
+	u_int32_t num_sets;                             /* number of cache sets */
+	u_int32_t num_sets_bits;                        /* number of bits to encode "num_sets" */
+	u_int64_t num_sets_mask;                        /* mask value for bits in "num_sets" */
+
+	struct eio_policy *policy_ops;                  /* Cache block Replacement policy */
+	u_int32_t req_policy;                           /* Policy requested by the user */
+	u_int32_t random;                               /* Use for random replacement policy */
+	void *sp_cache_blk;                             /* Per cache-block data structure */
+	void *sp_cache_set;                             /* Per cache-set data structure */
+	struct lru_ls *dirty_set_lru;                   /* lru for dirty sets : lru_list_t */
+	spinlock_t dirty_set_lru_lock;                  /* spinlock for dirty set lru */
+	struct delayed_work clean_aged_sets_work;       /* work item for clean_aged_sets */
+	int is_clean_aged_sets_sched;                   /* to know whether clean aged sets is scheduled */
+	struct workqueue_struct *mdupdate_q;            /* Workqueue to handle md updates */
+	struct workqueue_struct *callback_q;            /* Workqueue to handle io callbacks */
+};
+
+#define EIO_CACHE_IOSIZE                0
+
+#define EIO_ROUND_SECTOR(dmc, sector) (sector & (~(unsigned long)(dmc->block_size - 1)))
+#define EIO_ROUND_SET_SECTOR(dmc, sector) (sector & (~(unsigned long)((dmc->block_size * dmc->assoc) - 1)))
+
+/*
+ * The bit definitions are exported to the user space and are in the very beginning of the file.
+ */
+#define CACHE_VERBOSE_IS_SET(dmc)               (((dmc)->cache_flags & CACHE_FLAGS_VERBOSE) ? 1 : 0)
+#define CACHE_INVALIDATE_IS_SET(dmc)            (((dmc)->cache_flags & CACHE_FLAGS_INVALIDATE) ? 1 : 0)
+#define CACHE_FAST_REMOVE_IS_SET(dmc)           (((dmc)->cache_flags & CACHE_FLAGS_FAST_REMOVE) ? 1 : 0)
+#define CACHE_DEGRADED_IS_SET(dmc)              (((dmc)->cache_flags & CACHE_FLAGS_DEGRADED) ? 1 : 0)
+#define CACHE_SSD_ADD_INPROG_IS_SET(dmc)        (((dmc)->cache_flags & CACHE_FLAGS_SSD_ADD_INPROG) ? 1 : 0)
+#define CACHE_MD8_IS_SET(dmc)                   (((dmc)->cache_flags & CACHE_FLAGS_MD8) ? 1 : 0)
+#define CACHE_FAILED_IS_SET(dmc)                (((dmc)->cache_flags & CACHE_FLAGS_FAILED) ? 1 : 0)
+#define CACHE_STALE_IS_SET(dmc)                 (((dmc)->cache_flags & CACHE_FLAGS_STALE) ? 1 : 0)
+
+/* Device failure handling.  */
+#define CACHE_SRC_IS_ABSENT(dmc)                (((dmc)->eio_errors.no_source_dev == 1) ? 1 : 0)
+
+#define AUTOCLEAN_THRESHOLD_CROSSED(dmc)	\
+	((atomic64_read(&(dmc)->nr_ios) > (int64_t)(dmc)->sysctl_active.autoclean_threshold) ||	\
+	 ((dmc)->sysctl_active.autoclean_threshold == 0))
+
+#define DIRTY_CACHE_THRESHOLD_CROSSED(dmc)	\
+	((atomic64_read(&(dmc)->nr_dirty) - atomic64_read(&(dmc)->clean_pendings)) >= \
+	 (int64_t)((dmc)->sysctl_active.dirty_high_threshold * EIO_DIV((dmc)->size, 100)) && \
+	 ((dmc)->sysctl_active.dirty_high_threshold > (dmc)->sysctl_active.dirty_low_threshold))
+
+#define DIRTY_SET_THRESHOLD_CROSSED(dmc, set)	\
+	(((dmc)->cache_sets[(set)].nr_dirty >= (u_int32_t)((dmc)->sysctl_active.dirty_set_high_threshold * (dmc)->assoc) / 100) && \
+	 ((dmc)->sysctl_active.dirty_set_high_threshold > (dmc)->sysctl_active.dirty_set_low_threshold))
+
+/*
+ * Do not reverse the order of disk and cache! Code
+ * relies on this ordering. (Eg: eio_dm_io_async_bvec()).
+ */
+struct job_io_regions {
+	struct eio_io_region disk;      /* has to be the first member */
+	struct eio_io_region cache;     /* has to be the second member */
+};
+
+#define EB_MAIN_IO 1
+#define EB_SUBORDINATE_IO 2
+#define EB_INVAL 4
+#define GET_BIO_FLAGS(ebio)             ((ebio)->eb_bc->bc_bio->bi_rw)
+#define VERIFY_BIO_FLAGS(ebio)          EIO_ASSERT((ebio) && (ebio)->eb_bc && (ebio)->eb_bc->bc_bio)
+
+#define SET_BARRIER_FLAGS(rw_flags) (rw_flags |= (REQ_WRITE | REQ_FLUSH))
+
+struct eio_bio {
+	int eb_iotype;
+	struct bio_container *eb_bc;
+	unsigned eb_cacheset;
+	sector_t eb_sector;             /*sector number*/
+	unsigned eb_size;               /*size in bytes*/
+	struct bio_vec *eb_bv;          /*bvec pointer*/
+	unsigned eb_nbvec;              /*number of bio_vecs*/
+	int eb_dir;                     /* io direction*/
+	struct eio_bio *eb_next;        /*used for splitting reads*/
+	index_t eb_index;               /*for read bios*/
+	atomic_t eb_holdcount;          /* ebio hold count, currently used only for dirty block I/O */
+	struct bio_vec eb_rbv[0];
+};
+
+enum eio_io_dir {
+	EIO_IO_INVALID_DIR = 0,
+	CACHED_WRITE,
+	CACHED_READ,
+	UNCACHED_WRITE,
+	UNCACHED_READ,
+	UNCACHED_READ_AND_READFILL
+};
+
+/* ASK
+ * Container for all eio_bio corresponding to a given bio
+ */
+struct bio_container {
+	spinlock_t bc_lock;                     /* lock protecting the bc fields */
+	atomic_t bc_holdcount;                  /* number of ebios referencing bc */
+	struct bio *bc_bio;                     /* bio for the bc */
+	struct cache_c *bc_dmc;                 /* cache structure */
+	struct eio_bio *bc_mdlist;              /* ebios waiting for md update */
+	int bc_mdwait;                          /* count of ebios that will do md update */
+	struct mdupdate_request *mdreqs;        /* mdrequest structures required for md update */
+	struct set_seq *bc_setspan;             /* sets spanned by the bc(used only for wb) */
+	struct set_seq bc_singlesspan;          /* used(by wb) if bc spans a single set sequence */
+	enum eio_io_dir bc_dir;                 /* bc I/O direction */
+	int bc_error;                           /* error encountered during processing bc */
+	unsigned long bc_iotime;                /* maintains i/o time in jiffies */
+	struct bio_container *bc_next;          /* next bc in the chain */
+};
+
+/* structure used as callback context during synchronous I/O */
+struct sync_io_context {
+	struct rw_semaphore sio_lock;
+	unsigned long sio_error;
+};
+
+struct kcached_job {
+	struct list_head list;
+	struct work_struct work;
+	struct cache_c *dmc;
+	struct eio_bio *ebio;
+	struct job_io_regions job_io_regions;
+	index_t index;
+	int action;
+	int error;
+	struct flash_cacheblock *md_sector;
+	struct bio_vec md_io_bvec;
+	struct kcached_job *next;
+};
+
+struct ssd_rm_list {
+	struct cache_c *dmc;
+	int action;
+	dev_t devt;
+	enum dev_notifier note;
+	struct list_head list;
+};
+
+struct dbn_index_pair {
+	sector_t dbn;
+	index_t index;
+};
+
+/*
+ * Subsection 3: Function prototypes and definitions.
+ */
+
+struct kcached_job *eio_alloc_cache_job(void);
+void eio_free_cache_job(struct kcached_job *job);
+struct kcached_job *pop(struct list_head *jobs);
+void push(struct list_head *jobs, struct kcached_job *job);
+void do_work(struct work_struct *unused);
+void update_job_cacheregion(struct kcached_job *job, struct cache_c *dmc,
+			    struct eio_bio *bio);
+void push_io(struct kcached_job *job);
+void push_md_io(struct kcached_job *job);
+void push_md_complete(struct kcached_job *job);
+void push_uncached_io_complete(struct kcached_job *job);
+int eio_io_empty(void);
+int eio_md_io_empty(void);
+int eio_md_complete_empty(void);
+void eio_md_write_done(struct kcached_job *job);
+void eio_ssderror_diskread(struct kcached_job *job);
+void eio_md_write(struct kcached_job *job);
+void eio_md_write_kickoff(struct kcached_job *job);
+void eio_do_readfill(struct work_struct *work);
+void eio_comply_dirty_thresholds(struct cache_c *dmc, index_t set);
+void eio_clean_all(struct cache_c *dmc);
+void eio_clean_for_reboot(struct cache_c *dmc);
+void eio_clean_aged_sets(struct work_struct *work);
+void eio_comply_dirty_thresholds(struct cache_c *dmc, index_t set);
+#ifndef SSDCACHE
+void eio_reclaim_lru_movetail(struct cache_c *dmc, index_t index,
+			      struct eio_policy *);
+#endif                          /* !SSDCACHE */
+int eio_io_sync_vm(struct cache_c *dmc, struct eio_io_region *where, int rw,
+		   struct bio_vec *bvec, int nbvec);
+int eio_io_sync_pages(struct cache_c *dmc, struct eio_io_region *where, int rw,
+		      struct page **pages, int num_bvecs);
+void eio_update_sync_progress(struct cache_c *dmc);
+void eio_plug_cache_device(struct cache_c *dmc);
+void eio_unplug_cache_device(struct cache_c *dmc);
+void eio_plug_disk_device(struct cache_c *dmc);
+void eio_unplug_disk_device(struct cache_c *dmc);
+int dm_io_async_bvec(unsigned int num_regions, struct eio_io_region *where,
+		     int rw, struct bio_vec *bvec, eio_notify_fn fn,
+		     void *context);
+void eio_put_cache_device(struct cache_c *dmc);
+void eio_suspend_caching(struct cache_c *dmc, enum dev_notifier note);
+void eio_resume_caching(struct cache_c *dmc, char *dev);
+int eio_ctr_ssd_add(struct cache_c *dmc, char *dev);
+
+/* procfs */
+void eio_module_procfs_init(void);
+void eio_module_procfs_exit(void);
+void eio_procfs_ctr(struct cache_c *dmc);
+void eio_procfs_dtr(struct cache_c *dmc);
+
+int eio_sb_store(struct cache_c *dmc);
+
+int eio_md_destroy(struct dm_target *tip, char *namep, char *srcp, char *cachep,
+		   int force);
+
+/* eio_conf.c */
+extern int eio_ctr(struct dm_target *ti, unsigned int argc, char **argv);
+extern void eio_dtr(struct dm_target *ti);
+extern int eio_md_destroy(struct dm_target *tip, char *namep, char *srcp,
+			  char *cachep, int force);
+extern int eio_ctr_ssd_add(struct cache_c *dmc, char *dev);
+
+/* thread related functions */
+void *eio_create_thread(int (*func)(void *), void *context, char *name);
+void eio_thread_exit(long exit_code);
+void eio_wait_thread_exit(void *thrdptr, int *notifier);
+
+/* eio_main.c */
+extern int eio_map(struct cache_c *, struct request_queue *, struct bio *);
+extern void eio_md_write_done(struct kcached_job *job);
+extern void eio_ssderror_diskread(struct kcached_job *job);
+extern void eio_md_write(struct kcached_job *job);
+extern void eio_md_write_kickoff(struct kcached_job *job);
+extern void eio_do_readfill(struct work_struct *work);
+extern void eio_check_dirty_thresholds(struct cache_c *dmc, index_t set);
+extern void eio_clean_all(struct cache_c *dmc);
+extern int eio_clean_thread_proc(void *context);
+extern void eio_touch_set_lru(struct cache_c *dmc, index_t set);
+extern void eio_inval_range(struct cache_c *dmc, sector_t iosector,
+			    unsigned iosize);
+extern int eio_invalidate_sanity_check(struct cache_c *dmc, u_int64_t iosector,
+				       u_int64_t *iosize);
+/*
+ * Invalidates all cached blocks without waiting for them to complete
+ * Should be called with incoming IO suspended
+ */
+extern int eio_invalidate_cache(struct cache_c *dmc);
+
+/* eio_mem.c */
+extern int eio_mem_init(struct cache_c *dmc);
+extern u_int32_t eio_hash_block(struct cache_c *dmc, sector_t dbn);
+extern unsigned int eio_shrink_dbn(struct cache_c *dmc, sector_t dbn);
+extern sector_t eio_expand_dbn(struct cache_c *dmc, u_int64_t index);
+extern void eio_invalidate_md(struct cache_c *dmc, u_int64_t index);
+extern void eio_md4_dbn_set(struct cache_c *dmc, u_int64_t index,
+			    u_int32_t dbn_24);
+extern void eio_md8_dbn_set(struct cache_c *dmc, u_int64_t index, sector_t dbn);
+
+/* eio_procfs.c */
+extern void eio_module_procfs_init(void);
+extern void eio_module_procfs_exit(void);
+extern void eio_procfs_ctr(struct cache_c *dmc);
+extern void eio_procfs_dtr(struct cache_c *dmc);
+extern int eio_version_query(size_t buf_sz, char *bufp);
+
+/* eio_subr.c */
+extern void eio_free_cache_job(struct kcached_job *job);
+extern void eio_do_work(struct work_struct *unused);
+extern struct kcached_job *eio_new_job(struct cache_c *dmc, struct eio_bio *bio,
+				       index_t index);
+extern void eio_push_ssdread_failures(struct kcached_job *job);
+extern void eio_push_md_io(struct kcached_job *job);
+extern void eio_push_md_complete(struct kcached_job *job);
+extern void eio_push_uncached_io_complete(struct kcached_job *job);
+extern int eio_io_empty(void);
+extern int eio_io_sync_vm(struct cache_c *dmc, struct eio_io_region *where,
+			  int rw, struct bio_vec *bvec, int nbvec);
+extern void eio_unplug_cache_device(struct cache_c *dmc);
+extern void eio_put_cache_device(struct cache_c *dmc);
+extern void eio_suspend_caching(struct cache_c *dmc, enum dev_notifier note);
+extern void eio_resume_caching(struct cache_c *dmc, char *dev);
+
+static inline void
+EIO_DBN_SET(struct cache_c *dmc, u_int64_t index, sector_t dbn)
+{
+	if (EIO_MD8(dmc))
+		eio_md8_dbn_set(dmc, index, dbn);
+	else
+		eio_md4_dbn_set(dmc, index, eio_shrink_dbn(dmc, dbn));
+	if (dbn == 0)
+		dmc->index_zero = index;
+}
+
+static inline u_int64_t EIO_DBN_GET(struct cache_c *dmc, u_int64_t index)
+{
+	if (EIO_MD8(dmc))
+		return dmc->cache_md8[index].md8_u.u_i_md8 & EIO_MD8_DBN_MASK;
+
+	return eio_expand_dbn(dmc, index);
+}
+
+static inline void
+EIO_CACHE_STATE_SET(struct cache_c *dmc, u_int64_t index, u_int8_t cache_state)
+{
+	if (EIO_MD8(dmc))
+		dmc->cache_md8[index].md8_u.u_s_md8.cache_state = cache_state;
+	else
+		dmc->cache[index].md4_u.u_s_md4.cache_state = cache_state;
+}
+
+static inline u_int8_t
+EIO_CACHE_STATE_GET(struct cache_c *dmc, u_int64_t index)
+{
+	u_int8_t cache_state;
+
+	if (EIO_MD8(dmc))
+		cache_state = dmc->cache_md8[index].md8_u.u_s_md8.cache_state;
+	else
+		cache_state = dmc->cache[index].md4_u.u_s_md4.cache_state;
+	return cache_state;
+}
+
+static inline void
+EIO_CACHE_STATE_OFF(struct cache_c *dmc, index_t index, u_int8_t bitmask)
+{
+	u_int8_t cache_state = EIO_CACHE_STATE_GET(dmc, index);
+
+	cache_state &= ~bitmask;
+	EIO_CACHE_STATE_SET(dmc, index, cache_state);
+}
+
+static inline void
+EIO_CACHE_STATE_ON(struct cache_c *dmc, index_t index, u_int8_t bitmask)
+{
+	u_int8_t cache_state = EIO_CACHE_STATE_GET(dmc, index);
+
+	cache_state |= bitmask;
+	EIO_CACHE_STATE_SET(dmc, index, cache_state);
+}
+
+void eio_set_warm_boot(void);
+#endif                          /* defined(__KERNEL__) */
+
+#include "eio_ioctl.h"
+
+/* resolve conflict with scsi/scsi_device.h */
+#ifdef __KERNEL__
+
+#ifdef EIO_ASSERT
+#undef EIO_ASSERT
+#endif
+/*Always compiled in*/
+#define EIO_ASSERT(x)    BUG_ON(unlikely(!(x)))
+
+extern sector_t eio_get_device_size(struct eio_bdev *);
+extern sector_t eio_get_device_start_sect(struct eio_bdev *);
+#endif                          /* __KERNEL__ */
+
+#define EIO_INIT_EVENT(ev)	((ev)->process = NULL)
+
+/*Assumes that the macro gets called under the same spinlock as in wait event*/
+#define EIO_SET_EVENT_AND_UNLOCK(ev, sl, flags)					\
+	do {							\
+		struct task_struct      *p = NULL;		\
+		if ((ev)->process) {				\
+			(p) = (ev)->process;			\
+			(ev)->process = NULL;			\
+		}						\
+		spin_unlock_irqrestore((sl), flags);		\
+		if (p) {					\
+			(void)wake_up_process(p);		\
+		}						\
+	} while (0)
+
+/*Assumes that the spin lock sl is taken while calling this macro*/
+#define EIO_WAIT_EVENT(ev, sl, flags)						\
+	do {							\
+		(ev)->process = current;			\
+		set_current_state(TASK_INTERRUPTIBLE);		\
+		spin_unlock_irqrestore((sl), flags);		\
+		(void)schedule_timeout(10 * HZ);		\
+		spin_lock_irqsave((sl), flags);			\
+		(ev)->process = NULL;				\
+	} while (0)
+
+#define EIO_CLEAR_EVENT(ev)	((ev)->process = NULL)
+
+#include "eio_setlru.h"
+#include "eio_policy.h"
+#define EIO_CACHE(dmc)          (EIO_MD8(dmc) ? (void *)dmc->cache_md8 : (void *)dmc->cache)
+
+#endif                          /* !EIO_INC_H */
diff --git a/drivers/block/enhanceio/eio_conf.c b/drivers/block/enhanceio/eio_conf.c
new file mode 100644
index 0000000..fdda6eb
--- /dev/null
+++ b/drivers/block/enhanceio/eio_conf.c
@@ -0,0 +1,2628 @@
+/*
+ *  eio_conf.c
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *  Amit Kale <akale@stec-inc.com>
+ *   Restructured much of the io code to split bio within map function instead
+ *   of letting dm do it.
+ *   Simplified queued logic for write through.
+ *  Amit Kale <akale@stec-inc.com>
+ *  Harish Pujari <hpujari@stec-inc.com>
+ *   Designed and implemented the writeback caching mode
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "eio.h"
+#include "eio_ttc.h"
+
+#define KMEM_CACHE_JOB          "eio-kcached-jobs"
+#define KMEM_EIO_IO             "eio-io-context"
+#define KMEM_DMC_BIO_PAIR       "eio-dmc-bio-pair"
+/* #define KMEM_CACHE_PENDING_JOB	"eio-pending-jobs" */
+
+static struct cache_c *cache_list_head;
+struct work_struct _kcached_wq;
+
+static struct kmem_cache *_job_cache;
+struct kmem_cache *_io_cache;   /* cache of eio_context objects */
+mempool_t *_job_pool;
+mempool_t *_io_pool;            /* pool of eio_context object */
+
+atomic_t nr_cache_jobs;
+
+
+LIST_HEAD(ssd_rm_list);
+int ssd_rm_list_not_empty;
+spinlock_t ssd_rm_list_lock;
+
+struct eio_control_s *eio_control;
+
+int eio_force_warm_boot;
+static int eio_notify_reboot(struct notifier_block *nb, unsigned long action,
+			     void *x);
+void eio_stop_async_tasks(struct cache_c *dmc);
+static int eio_notify_ssd_rm(struct notifier_block *nb, unsigned long action,
+			     void *x);
+
+/*
+ * The notifiers are registered in descending order of priority and
+ * executed in descending order or priority. We should be run before
+ * any notifiers of ssd's or other block devices. Typically, devices
+ * use a priority of 0.
+ * XXX - If in the future we happen to use a md device as the cache
+ * block device, we have a problem because md uses a priority of
+ * INT_MAX as well. But we want to run before the md's reboot notifier !
+ */
+static struct notifier_block eio_reboot_notifier = {
+	.notifier_call	= eio_notify_reboot,
+	.next		= NULL,
+	.priority	= INT_MAX,         /* should be > ssd pri's and disk dev pri's */
+};
+
+static struct notifier_block eio_ssd_rm_notifier = {
+	.notifier_call	= eio_notify_ssd_rm,
+	.next		= NULL,
+	.priority	= 0,
+};
+
+int eio_wait_schedule(void *unused)
+{
+
+	schedule();
+	return 0;
+}
+
+/*
+ * Check if the System RAM threshold > requested memory, don't care
+ * if threshold is set to 0. Return value is 0 for fail and 1 for success.
+ */
+static inline int eio_mem_available(struct cache_c *dmc, size_t size)
+{
+	struct sysinfo si;
+
+	if (unlikely
+		    (dmc->sysctl_active.mem_limit_pct <= 0
+		    || dmc->sysctl_active.mem_limit_pct >= 100))
+		return 1;
+
+	si_meminfo(&si);
+	return (((si.freeram << PAGE_SHIFT) *
+		 dmc->sysctl_active.mem_limit_pct) / 100) > size;
+}
+
+/* create a new thread and call the specified function */
+void *eio_create_thread(int (*func)(void *), void *context, char *name)
+{
+	return kthread_run(func, context, "%s", name);
+}
+
+/* wait for the given thread to exit */
+void eio_wait_thread_exit(void *thrdptr, int *running)
+{
+	while (*running)
+		msleep(1);
+
+	/*do_exit() would be called within the thread func itself*/
+
+	return;
+}
+
+/* thread exit self */
+void eio_thread_exit(long exit_code)
+{
+	do_exit(exit_code);
+}
+const char *eio_policy_to_name(u8 p)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(eio_policy_names); i++)
+		if (eio_policy_names[i].p == p)
+			return eio_policy_names[i].n;
+
+	return NULL;
+}
+
+
+inline int eio_policy_init(struct cache_c *dmc)
+{
+	int error = 0;
+
+	if (dmc->req_policy == 0)
+		dmc->req_policy = CACHE_REPL_DEFAULT;
+	dmc->policy_ops = eio_get_policy(dmc->req_policy);
+	if (dmc->policy_ops == NULL) {
+		pr_err
+			("policy_init: Cannot find requested policy");
+		error = -ENOMEM;
+	} else {
+		/* Back pointer to reference dmc from policy_ops */
+		dmc->policy_ops->sp_dmc = dmc;
+		pr_info("Setting replacement policy to %s (%d)",
+			eio_policy_to_name(dmc->policy_ops->sp_name),
+			dmc->policy_ops->sp_name);
+	}
+	return error;
+}
+
+static int eio_jobs_init(void)
+{
+
+	_job_cache = _io_cache = NULL;
+	_job_pool = _io_pool = NULL;
+
+	_job_cache = kmem_cache_create(KMEM_CACHE_JOB,
+				       sizeof(struct kcached_job),
+				       __alignof__(struct kcached_job),
+				       0, NULL);
+	if (!_job_cache)
+		return -ENOMEM;
+
+	_job_pool = mempool_create(MIN_JOBS, mempool_alloc_slab,
+				   mempool_free_slab, _job_cache);
+	if (!_job_pool)
+		goto out;
+
+	_io_cache = kmem_cache_create(KMEM_EIO_IO,
+				      sizeof(struct eio_context),
+				      __alignof__(struct eio_context), 0, NULL);
+	if (!_io_cache)
+		goto out;
+
+	_io_pool = mempool_create(MIN_EIO_IO, mempool_alloc_slab,
+				  mempool_free_slab, _io_cache);
+	if (!_io_pool)
+		goto out;
+
+	return 0;
+
+out:
+	if (_io_pool)
+		mempool_destroy(_io_pool);
+	if (_io_cache)
+		kmem_cache_destroy(_io_cache);
+	if (_job_pool)
+		mempool_destroy(_job_pool);
+	if (_job_cache)
+		kmem_cache_destroy(_job_cache);
+
+	_job_pool = _io_pool = NULL;
+	_job_cache = _io_cache = NULL;
+	return -ENOMEM;
+}
+
+static void eio_jobs_exit(void)
+{
+
+	mempool_destroy(_io_pool);
+	mempool_destroy(_job_pool);
+	kmem_cache_destroy(_io_cache);
+	kmem_cache_destroy(_job_cache);
+
+	_job_pool = _io_pool = NULL;
+	_job_cache = _io_cache = NULL;
+}
+
+static int eio_kcached_init(struct cache_c *dmc)
+{
+
+	/* init_waitqueue_head(&dmc->destroyq); */
+	atomic_set(&dmc->nr_jobs, 0);
+	return 0;
+}
+
+static void eio_kcached_client_destroy(struct cache_c *dmc)
+{
+
+	/* Wait for all IOs
+	   /wait_event(dmc->destroyq, !atomic_read(&dmc->nr_jobs));*/
+}
+
+/* Store the cache superblock on ssd */
+int eio_sb_store(struct cache_c *dmc)
+{
+	union eio_superblock *sb = NULL;
+	struct eio_io_region where;
+	int error;
+
+	struct bio_vec *sb_pages;
+	int nr_pages;
+	int page_count, page_index;
+
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc)) || CACHE_DEGRADED_IS_SET(dmc))
+	    && (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))) {
+		pr_err
+			("sb_store: Cannot write superblock for cache \"%s\", in degraded/failed mode.\n",
+			dmc->cache_name);
+		return -ENODEV;
+	}
+
+	page_count = 0;
+	nr_pages = EIO_SUPERBLOCK_SIZE / PAGE_SIZE;
+	EIO_ASSERT(nr_pages != 0);
+
+	sb_pages = eio_alloc_pages(nr_pages, &page_count);
+	if (sb_pages == NULL) {
+		pr_err("sb_store: System memory too low.\n");
+		return -ENOMEM;
+	}
+
+	EIO_ASSERT(page_count == nr_pages);
+
+	nr_pages = page_count;
+	page_index = 0;
+	sb = (union eio_superblock *)kmap(sb_pages[page_index].bv_page);
+
+	sb->sbf.cache_sb_state = cpu_to_le32(dmc->sb_state);
+	sb->sbf.block_size = cpu_to_le32(dmc->block_size);
+	sb->sbf.size = cpu_to_le32(dmc->size);
+	sb->sbf.assoc = cpu_to_le32(dmc->assoc);
+	sb->sbf.cache_md_start_sect = cpu_to_le64(dmc->md_start_sect);
+	sb->sbf.cache_data_start_sect = cpu_to_le64(dmc->md_sectors);
+	strncpy(sb->sbf.disk_devname, dmc->disk_devname, DEV_PATHLEN);
+	strncpy(sb->sbf.cache_devname, dmc->cache_devname, DEV_PATHLEN);
+	strncpy(sb->sbf.ssd_uuid, dmc->ssd_uuid, DEV_PATHLEN - 1);
+	sb->sbf.cache_devsize = cpu_to_le64(eio_to_sector(eio_get_device_size(dmc->cache_dev)));
+	sb->sbf.disk_devsize = cpu_to_le64(eio_to_sector(eio_get_device_size(dmc->disk_dev)));
+	sb->sbf.cache_version = cpu_to_le32(dmc->sb_version);
+	strncpy(sb->sbf.cache_name, dmc->cache_name, DEV_PATHLEN);
+	sb->sbf.cache_name[DEV_PATHLEN - 1] = '\0';
+	sb->sbf.mode = cpu_to_le32(dmc->mode);
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	sb->sbf.repl_policy = cpu_to_le32(dmc->req_policy);
+	sb->sbf.cache_flags = cpu_to_le32(dmc->cache_flags & ~CACHE_FLAGS_INCORE_ONLY);
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+	if (dmc->sb_version)
+		sb->sbf.magic = cpu_to_le32(EIO_MAGIC);
+	else
+		sb->sbf.magic = cpu_to_le32(EIO_BAD_MAGIC);
+
+	sb->sbf.cold_boot = cpu_to_le32(dmc->cold_boot);
+	if (le32_to_cpu(sb->sbf.cold_boot) && eio_force_warm_boot)
+		sb->sbf.cold_boot = cpu_to_le32(le32_to_cpu(sb->sbf.cold_boot) |
+						BOOT_FLAG_FORCE_WARM);
+
+	sb->sbf.dirty_high_threshold = cpu_to_le32(dmc->sysctl_active.dirty_high_threshold);
+	sb->sbf.dirty_low_threshold = cpu_to_le32(dmc->sysctl_active.dirty_low_threshold);
+	sb->sbf.dirty_set_high_threshold =
+		cpu_to_le32(dmc->sysctl_active.dirty_set_high_threshold);
+	sb->sbf.dirty_set_low_threshold =
+		cpu_to_le32(dmc->sysctl_active.dirty_set_low_threshold);
+	sb->sbf.time_based_clean_interval =
+		cpu_to_le32(dmc->sysctl_active.time_based_clean_interval);
+	sb->sbf.autoclean_threshold = cpu_to_le32(dmc->sysctl_active.autoclean_threshold);
+
+	/* write out to ssd */
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = EIO_SUPERBLOCK_START;
+	where.count = eio_to_sector(EIO_SUPERBLOCK_SIZE);
+	error = eio_io_sync_vm(dmc, &where, WRITE, sb_pages, nr_pages);
+	if (error) {
+		pr_err
+			("sb_store: Could not write out superblock to sector %llu (error %d) for cache \"%s\".\n",
+			(unsigned long long)where.sector, error, dmc->cache_name);
+	}
+
+	/* free the allocated pages here */
+	if (sb_pages) {
+		kunmap(sb_pages[0].bv_page);
+		for (page_index = 0; page_index < nr_pages; page_index++)
+			put_page(sb_pages[page_index].bv_page);
+		kfree(sb_pages);
+		sb_pages = NULL;
+	}
+
+	return error;
+}
+
+/*
+ * Write out the metadata one sector at a time.
+ * Then dump out the superblock.
+ */
+int eio_md_store(struct cache_c *dmc)
+{
+	struct flash_cacheblock *next_ptr;
+	struct eio_io_region where;
+	sector_t i;
+	int j, k;
+	int num_valid = 0, num_dirty = 0;
+	int error;
+	int write_errors = 0;
+	sector_t sectors_written = 0, sectors_expected = 0;     /* debug */
+	int slots_written = 0;                                  /* How many cache slots did we fill in this MD io block ? */
+
+	struct bio_vec *pages;
+	int nr_pages;
+	int page_count, page_index;
+	void **pg_virt_addr;
+
+	if (unlikely(CACHE_FAILED_IS_SET(dmc))
+	    || unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+		pr_err
+			("md_store: Cannot write metadata in failed/degraded mode for cache \"%s\".",
+			dmc->cache_name);
+		return -ENODEV;
+	}
+
+	if (CACHE_FAST_REMOVE_IS_SET(dmc)) {
+		if (CACHE_VERBOSE_IS_SET(dmc))
+			pr_info("Skipping writing out metadata to cache");
+		if (!dmc->sb_version) {
+
+			/*
+			 * Incase of delete, flush the superblock
+			 * irrespective of fast_remove being set.
+			 */
+
+			goto sb_store;
+		}
+		return 0;
+	}
+
+	if (!eio_mem_available(dmc, METADATA_IO_BLOCKSIZE_SECT)) {
+		pr_err
+			("md_store: System memory too low for allocating metadata IO buffers");
+		return -ENOMEM;
+	}
+
+	page_count = 0;
+	pages = eio_alloc_pages(dmc->bio_nr_pages, &page_count);
+	if (pages == NULL) {
+		pr_err("eio_md_store: System memory too low.");
+		return -ENOMEM;
+	}
+
+	/* get the exact number of pages allocated */
+	nr_pages = page_count;
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = dmc->md_start_sect;
+	slots_written = 0;
+	page_index = 0;
+
+	pg_virt_addr = kmalloc(nr_pages * (sizeof(void *)), GFP_KERNEL);
+	if (pg_virt_addr == NULL) {
+		pr_err("eio_md_store: System memory too low.");
+		for (k = 0; k < nr_pages; k++)
+			put_page(pages[k].bv_page);
+		kfree(pages);
+		return -ENOMEM;
+	}
+
+	for (k = 0; k < nr_pages; k++)
+		pg_virt_addr[k] = kmap(pages[k].bv_page);
+
+	next_ptr = (struct flash_cacheblock *)pg_virt_addr[page_index];
+	j = MD_BLOCKS_PER_PAGE;
+
+	pr_info("Writing out metadata to cache device. Please wait...");
+
+	for (i = 0; i < dmc->size; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, (index_t)i) & VALID)
+			num_valid++;
+		if (EIO_CACHE_STATE_GET(dmc, (index_t)i) & DIRTY)
+			num_dirty++;
+		next_ptr->dbn = cpu_to_le64(EIO_DBN_GET(dmc, i));
+		next_ptr->cache_state = cpu_to_le64(EIO_CACHE_STATE_GET(dmc, (index_t)i) &
+					(INVALID | VALID | DIRTY));
+
+		next_ptr++;
+		slots_written++;
+		j--;
+		if (j == 0) {
+			/*
+			 * Filled the page, goto the next page.
+			 */
+			page_index++;
+
+			if (slots_written ==
+			    (int)(MD_BLOCKS_PER_PAGE * nr_pages)) {
+				/*
+				 * Wrote out an entire metadata IO block, write the block to the ssd.
+				 */
+				where.count =
+					slots_written / MD_BLOCKS_PER_SECTOR;
+				slots_written = 0;
+				page_index = 0;
+				sectors_written += where.count; /* debug */
+
+				error =
+					eio_io_sync_vm(dmc, &where, WRITE, pages,
+						       nr_pages);
+
+				if (error) {
+					write_errors++;
+					pr_err
+						("md_store: Could not write out metadata to sector %llu (error %d)",
+						(unsigned long long)where.sector, error);
+				}
+				where.sector += where.count;    /* Advance offset */
+			}
+			/* Move next slot pointer into next sector */
+			next_ptr =
+				(struct flash_cacheblock *)pg_virt_addr[page_index];
+			j = MD_BLOCKS_PER_PAGE;
+		}
+	}
+
+	if (next_ptr != (struct flash_cacheblock *)pg_virt_addr[0]) {
+		/* Write the remaining last page out */
+		EIO_ASSERT(slots_written > 0);
+
+		where.count = slots_written / MD_BLOCKS_PER_SECTOR;
+
+		if (slots_written % MD_BLOCKS_PER_SECTOR)
+			where.count++;
+
+		sectors_written += where.count;
+
+		/*
+		 * This may happen that we are at the beginning of the next page
+		 * and did not fill up any slots in this page. Verify this condition
+		 * and set page_index accordingly.
+		 */
+
+		if (next_ptr !=
+		    (struct flash_cacheblock *)pg_virt_addr[page_index]) {
+			unsigned offset;
+
+			slots_written = slots_written % MD_BLOCKS_PER_PAGE;
+
+			/*
+			 * We have some extra slots written at this page_index.
+			 * Let us try to zero out the remaining page size before submitting
+			 * this page.
+			 */
+			offset =
+				slots_written * (sizeof(struct flash_cacheblock));
+			memset(pg_virt_addr[page_index] + offset, 0,
+			       PAGE_SIZE - offset);
+
+			page_index++;
+		}
+
+		error = eio_io_sync_vm(dmc, &where, WRITE, pages, page_index);
+		/* XXX: should we call eio_sb_store() on error ?? */
+		if (error) {
+			write_errors++;
+			pr_err
+				("md_store: Could not write out metadata to sector %llu (error %d)",
+				(unsigned long long)where.sector, error);
+		}
+	}
+
+	/* Debug Tests */
+	sectors_expected = EIO_DIV(dmc->size, MD_BLOCKS_PER_SECTOR);
+	if (EIO_REM(dmc->size, MD_BLOCKS_PER_SECTOR))
+		sectors_expected++;
+	EIO_ASSERT(sectors_expected == sectors_written);
+	/* XXX: should we call eio_sb_store() on error ?? */
+	if (sectors_expected != sectors_written) {
+		pr_err
+			("md_store: Sector mismatch! sectors_expected=%llu, sectors_written=%llu\n",
+			(unsigned long long)sectors_expected, (unsigned long long)sectors_written);
+	}
+
+	for (k = 0; k < nr_pages; k++)
+		kunmap(pages[k].bv_page);
+	kfree(pg_virt_addr);
+
+	if (pages)
+		for (k = 0; k < nr_pages; k++)
+			put_page(pages[k].bv_page);
+	kfree(pages);
+	pages = NULL;
+
+	if (write_errors == 0) {
+		if (num_dirty == 0)
+			dmc->sb_state = CACHE_MD_STATE_CLEAN;
+		else
+			dmc->sb_state = CACHE_MD_STATE_FASTCLEAN;
+	} else
+		dmc->sb_state = CACHE_MD_STATE_UNSTABLE;
+
+sb_store:
+	error = eio_sb_store(dmc);
+	if (error) {
+		/* TBD. should we return error */
+		write_errors++;
+		pr_err("md_store: superblock store failed(error %d)", error);
+	}
+	if (!dmc->sb_version && CACHE_FAST_REMOVE_IS_SET(dmc))
+		return 0;
+
+	if (write_errors == 0)
+		pr_info("Metadata saved on the cache device");
+	else {
+		pr_info
+			("CRITICAL: There were %d errors in saving metadata on cache device",
+			write_errors);
+		if (num_dirty)
+			pr_info
+				("CRITICAL: %d dirty blocks could not be written out",
+				num_dirty);
+	}
+
+	pr_info("Valid blocks: %d, Dirty blocks: %d, Metadata sectors: %llu",
+		num_valid, num_dirty, (long long unsigned int)dmc->md_sectors);
+
+	return 0;
+}
+
+static int eio_md_create(struct cache_c *dmc, int force, int cold)
+{
+	struct flash_cacheblock *next_ptr;
+	union eio_superblock *header;
+	struct eio_io_region where;
+	sector_t i;
+	int j, error;
+	uint64_t cache_size, dev_size;
+	sector_t order;
+	sector_t sectors_written = 0, sectors_expected = 0;     /* debug */
+	int slots_written = 0;                                  /* How many cache slots did we fill in this MD io block ? */
+
+	struct bio_vec *header_page = NULL;                     /* Header page */
+	struct bio_vec *pages = NULL;                           /* Metadata pages */
+	int nr_pages = 0;
+	int page_count, page_index;
+	int ret = 0, k;
+	void **pg_virt_addr = NULL;
+
+	/* Allocate single page for superblock header.*/
+	page_count = 0;
+	header_page = eio_alloc_pages(1, &page_count);
+	if (header_page == NULL) {
+		pr_err("eio_md_create: System memory too low.");
+		return -ENOMEM;
+	}
+
+	EIO_ASSERT(page_count = 1);
+	header = (union eio_superblock *)kmap(header_page[0].bv_page);
+
+	/*
+	 * Apart from normal cache creation, eio_md_create() is also called when
+	 * the SSD is added as part of eio_resume_caching(). At this point,
+	 * the CACHE_FLAGS_DEGRADED is set, but we do want to write to the md area.
+	 * Therefore, if the CACHE_FLAGS_SSD_ADD_INPROG is set, then proceed instead
+	 * of returning -ENODEV.
+	 */
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc))
+	     || unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+	    && (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))) {
+		pr_err
+			("md_create: Cannot write metadata in failed/degraded mode for cache \"%s\".\n",
+			dmc->cache_name);
+		ret = -ENODEV;
+		goto free_header;
+	}
+
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = EIO_SUPERBLOCK_START;
+	where.count = eio_to_sector(EIO_SUPERBLOCK_SIZE);
+	error = eio_io_sync_vm(dmc, &where, READ, header_page, 1);
+	if (error) {
+		pr_err
+			("md_create: Could not read superblock sector %llu error %d for cache \"%s\".\n",
+			(unsigned long long)where.sector, error, dmc->cache_name);
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	if (!force &&
+	    ((le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_DIRTY) ||
+	     (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_CLEAN) ||
+	     (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_FASTCLEAN))) {
+		pr_err
+			("md_create: Existing cache detected, use force to re-create.\n");
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	/*
+	 * Compute the size of the metadata including header.
+	 * and here we also are making sure that metadata and userdata
+	 * on SSD is aligned at 8K boundary.
+	 *
+	 * Note dmc->size is in raw sectors
+	 */
+	dmc->md_start_sect = EIO_METADATA_START(dmc->cache_dev_start_sect);
+	dmc->md_sectors =
+		INDEX_TO_MD_SECTOR(EIO_DIV(dmc->size, (sector_t)dmc->block_size));
+	dmc->md_sectors +=
+		EIO_EXTRA_SECTORS(dmc->cache_dev_start_sect, dmc->md_sectors);
+	dmc->size -= dmc->md_sectors;   /* total sectors available for cache */
+	do_div(dmc->size, dmc->block_size);
+	dmc->size = EIO_DIV(dmc->size, dmc->assoc) * (sector_t)dmc->assoc;
+	/* Recompute since dmc->size was possibly trunc'ed down */
+	dmc->md_sectors = INDEX_TO_MD_SECTOR(dmc->size);
+	dmc->md_sectors +=
+		EIO_EXTRA_SECTORS(dmc->cache_dev_start_sect, dmc->md_sectors);
+
+	error = eio_mem_init(dmc);
+	if (error == -1) {
+		ret = -EINVAL;
+		goto free_header;
+	}
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc))
+	     || unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+	    && (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))) {
+		pr_err
+			("md_create: Cannot write metadata in failed/degraded mode for cache \"%s\".\n",
+			dmc->cache_name);
+		ret = -ENODEV;
+		goto free_header;
+	}
+	dev_size = eio_to_sector(eio_get_device_size(dmc->cache_dev));
+	cache_size = dmc->md_sectors + (dmc->size * dmc->block_size);
+	if (cache_size > dev_size) {
+		pr_err
+			("md_create: Requested cache size exceeds the cache device's capacity (%llu > %llu)",
+			(unsigned long long)cache_size, (unsigned long long)dev_size);
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	order =
+		dmc->size *
+		(EIO_MD8(dmc) ? sizeof(struct cacheblock_md8) :
+		 sizeof(struct cacheblock));
+	i = EIO_MD8(dmc) ? sizeof(struct cacheblock_md8) : sizeof(struct
+								  cacheblock);
+	pr_info("Allocate %lluKB (%lluB per) mem for %llu-entry cache "	\
+		"(capacity:%lluMB, associativity:%u, block size:%u bytes)",
+		(unsigned long long)order >> 10, (unsigned long long)i,
+		(long long unsigned int)dmc->size,
+		(unsigned long long)(cache_size >> (20 - SECTOR_SHIFT)), dmc->assoc,
+		dmc->block_size << SECTOR_SHIFT);
+
+	if (!eio_mem_available(dmc, order) && !CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+		pr_err
+			("md_create: System memory too low for allocating cache metadata.\n");
+		ret = -ENOMEM;
+		goto free_header;
+	}
+
+	/*
+	 * If we are called due to SSD add, the memory was already allocated
+	 * as part of cache creation (i.e., eio_ctr()) in the past.
+	 */
+	if (!CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+		if (EIO_MD8(dmc))
+			dmc->cache_md8 = vmalloc((size_t)order);
+		else
+			dmc->cache = vmalloc((size_t)order);
+		if ((EIO_MD8(dmc) && !dmc->cache_md8)
+		    || (!EIO_MD8(dmc) && !dmc->cache)) {
+			pr_err
+				("md_create: Unable to allocate cache md for cache \"%s\".\n",
+				dmc->cache_name);
+			ret = -ENOMEM;
+			goto free_header;
+		}
+	}
+	if (eio_repl_blk_init(dmc->policy_ops) != 0) {
+		pr_err
+			("md_create: Unable to allocate memory for policy cache block for cache \"%s\".\n",
+			dmc->cache_name);
+		ret = -ENOMEM;
+		goto free_header;
+	}
+
+	if (cold) {
+		int retry = 0;
+		do {
+			for (i = 0; i < dmc->size; i++) {
+				if (CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+					u_int8_t cache_state =
+						EIO_CACHE_STATE_GET(dmc, i);
+					if (cache_state & BLOCK_IO_INPROG) {
+						/* sleep for 1 sec and retry */
+						msleep(1000);
+						break;
+					}
+				}
+				eio_invalidate_md(dmc, i);
+			}
+		} while ((retry++ < 10) && (i < dmc->size));
+
+		if (i < dmc->size) {
+			pr_err
+				("md_create: Cache \"%s\" is not in quiesce state. Can't proceed to resume.\n",
+				dmc->cache_name);
+			ret = -EBUSY;
+			goto free_header;
+		}
+
+		/* Allocate pages of the order dmc->bio_nr_pages */
+		page_count = 0;
+		pages = eio_alloc_pages(dmc->bio_nr_pages, &page_count);
+		if (!pages) {
+			pr_err
+				("md_create: Unable to allocate pages for cache \"%s\".\n",
+				dmc->cache_name);
+			pr_err
+				("md_create: Could not write out cache metadata.\n");
+			ret = -ENOMEM;
+			goto free_header;
+		}
+
+		/* nr_pages is used for freeing the pages */
+		nr_pages = page_count;
+
+		where.bdev = dmc->cache_dev->bdev;
+		where.sector = dmc->md_start_sect;
+		slots_written = 0;
+		page_index = 0;
+
+		pg_virt_addr = kmalloc(nr_pages * (sizeof(void *)), GFP_KERNEL);
+		if (pg_virt_addr == NULL) {
+			pr_err("md_create: System memory too low.\n");
+			for (k = 0; k < nr_pages; k++)
+				put_page(pages[k].bv_page);
+			kfree(pages);
+			ret = -ENOMEM;
+			goto free_header;
+		}
+
+		for (k = 0; k < nr_pages; k++)
+			pg_virt_addr[k] = kmap(pages[k].bv_page);
+
+		next_ptr = (struct flash_cacheblock *)pg_virt_addr[page_index];
+		j = MD_BLOCKS_PER_PAGE;
+
+		for (i = 0; i < dmc->size; i++) {
+			next_ptr->dbn = cpu_to_le64(EIO_DBN_GET(dmc, i));
+			next_ptr->cache_state =
+				cpu_to_le64(EIO_CACHE_STATE_GET(dmc,
+				(index_t)i) & (INVALID | VALID | DIRTY));
+			next_ptr++;
+			slots_written++;
+			j--;
+
+			if (j == 0) {
+
+				page_index++;
+
+				if ((unsigned)slots_written ==
+				    MD_BLOCKS_PER_PAGE * nr_pages) {
+
+					where.count =
+						slots_written /
+						MD_BLOCKS_PER_SECTOR;
+					slots_written = 0;
+					page_index = 0;
+					sectors_written += where.count; /* debug */
+					error =
+						eio_io_sync_vm(dmc, &where, WRITE,
+							       pages, nr_pages);
+
+					if (error) {
+						if (!CACHE_SSD_ADD_INPROG_IS_SET
+							    (dmc))
+							vfree(EIO_CACHE(dmc));
+						pr_err
+							("md_create: Could not write cache metadata sector %llu error %d.\n for cache \"%s\".\n",
+							(unsigned long long)where.sector, error,
+							dmc->cache_name);
+						ret = -EIO;
+						goto free_md;
+					}
+					where.sector += where.count;    /* Advance offset */
+				}
+
+				/* Move next slot pointer into next page */
+				next_ptr =
+					(struct flash_cacheblock *)
+					pg_virt_addr[page_index];
+				j = MD_BLOCKS_PER_PAGE;
+			}
+		}
+
+		if (next_ptr != (struct flash_cacheblock *)pg_virt_addr[0]) {
+			/* Write the remaining last page out */
+			EIO_ASSERT(slots_written > 0);
+
+			where.count = slots_written / MD_BLOCKS_PER_SECTOR;
+
+			if (slots_written % MD_BLOCKS_PER_SECTOR)
+				where.count++;
+
+			sectors_written += where.count;
+
+			if (next_ptr !=
+			    (struct flash_cacheblock *)pg_virt_addr[page_index]) {
+				unsigned offset;
+
+				slots_written =
+					slots_written % MD_BLOCKS_PER_PAGE;
+
+				/*
+				 * We have some extra slots written at this page_index.
+				 * Let us try to zero out the remaining page size before submitting
+				 * this page.
+				 */
+				offset =
+					slots_written *
+					(sizeof(struct flash_cacheblock));
+				memset(pg_virt_addr[page_index] + offset, 0,
+				       PAGE_SIZE - offset);
+
+				page_index = page_index + 1;
+			}
+
+			error =
+				eio_io_sync_vm(dmc, &where, WRITE, pages,
+					       page_index);
+			if (error) {
+				if (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))
+					vfree((void *)EIO_CACHE(dmc));
+				pr_err
+					("md_create: Could not write cache metadata sector %llu error %d for cache \"%s\".\n",
+					(unsigned long long)where.sector, error, dmc->cache_name);
+				ret = -EIO;
+				goto free_md;
+			}
+		}
+
+		/* Debug Tests */
+		sectors_expected = EIO_DIV(dmc->size, MD_BLOCKS_PER_SECTOR);
+		if (EIO_REM(dmc->size, MD_BLOCKS_PER_SECTOR))
+			sectors_expected++;
+		if (sectors_expected != sectors_written) {
+			pr_err
+				("md_create: Sector mismatch! sectors_expected=%llu, sectors_written=%llu for cache \"%s\".\n",
+				(unsigned long long)sectors_expected, (unsigned long long)sectors_written,
+				dmc->cache_name);
+			ret = -EIO;
+			goto free_md;
+		}
+	}
+
+	/* if cold ends here */
+	/* Write the superblock */
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc))
+	     || unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+	    && (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))) {
+		pr_err
+			("md_create: Cannot write metadata in failed/degraded mode for cache \"%s\".\n",
+			dmc->cache_name);
+		vfree((void *)EIO_CACHE(dmc));
+		ret = -ENODEV;
+		goto free_md;
+	}
+
+	dmc->sb_state = CACHE_MD_STATE_DIRTY;
+	dmc->sb_version = EIO_SB_VERSION;
+	error = eio_sb_store(dmc);
+	if (error) {
+		if (!CACHE_SSD_ADD_INPROG_IS_SET(dmc))
+			vfree((void *)EIO_CACHE(dmc));
+		pr_err
+			("md_create: Could not write cache superblock sector(error %d) for cache \"%s\"\n",
+			error, dmc->cache_name);
+		ret = -EIO;
+		goto free_md;
+	}
+
+free_md:
+	for (k = 0; k < nr_pages; k++)
+		kunmap(pages[k].bv_page);
+	kfree(pg_virt_addr);
+
+	/* Free metadata pages here. */
+	if (pages) {
+		for (k = 0; k < nr_pages; k++)
+			put_page(pages[k].bv_page);
+		kfree(pages);
+		pages = NULL;
+	}
+
+free_header:
+	/* Free header page here */
+	if (header_page) {
+		kunmap(header_page[0].bv_page);
+		put_page(header_page[0].bv_page);
+		kfree(header_page);
+		header_page = NULL;
+	}
+
+	return ret;
+}
+
+static int eio_md_load(struct cache_c *dmc)
+{
+	struct flash_cacheblock *meta_data_cacheblock, *next_ptr;
+	union eio_superblock *header;
+	struct eio_io_region where;
+	int i;
+	index_t j, slots_read;
+	sector_t size;
+	int clean_shutdown;
+	int dirty_loaded = 0;
+	sector_t order, data_size;
+	int num_valid = 0;
+	int error;
+	sector_t sectors_read = 0, sectors_expected = 0;        /* Debug */
+	int force_warm_boot = 0;
+
+	struct bio_vec *header_page, *pages;
+	int nr_pages, page_count, page_index;
+	int ret = 0;
+	void **pg_virt_addr;
+
+	page_count = 0;
+	header_page = eio_alloc_pages(1, &page_count);
+	if (header_page == NULL) {
+		pr_err("md_load: Unable to allocate memory");
+		return -ENOMEM;
+	}
+
+	EIO_ASSERT(page_count == 1);
+	header = (union eio_superblock *)kmap(header_page[0].bv_page);
+
+	if (CACHE_FAILED_IS_SET(dmc) || CACHE_DEGRADED_IS_SET(dmc)) {
+		pr_err
+			("md_load: Cannot load metadata in failed / degraded mode");
+		ret = -ENODEV;
+		goto free_header;
+	}
+
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = EIO_SUPERBLOCK_START;
+	where.count = eio_to_sector(EIO_SUPERBLOCK_SIZE);
+	error = eio_io_sync_vm(dmc, &where, READ, header_page, 1);
+	if (error) {
+		pr_err
+			("md_load: Could not read cache superblock sector %llu error %d",
+			(unsigned long long)where.sector, error);
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	/* check ondisk superblock version */
+	if (le32_to_cpu(header->sbf.cache_version) != EIO_SB_VERSION) {
+		pr_info("md_load: Cache superblock mismatch detected." \
+			" (current: %u, ondisk: %u)", EIO_SB_VERSION,
+			header->sbf.cache_version);
+
+		if (le32_to_cpu(header->sbf.cache_version) == 0) {
+			pr_err("md_load: Can't enable cache %s. Either " \
+			       "superblock version is invalid or cache has" \
+			       " been deleted", header->sbf.cache_name);
+			ret = 1;
+			goto free_header;
+		}
+
+		if (le32_to_cpu(header->sbf.cache_version) > EIO_SB_VERSION) {
+			pr_err("md_load: Can't enable cache %s with newer " \
+			       " superblock version.", header->sbf.cache_name);
+			ret = 1;
+			goto free_header;
+		}
+
+		if (le32_to_cpu(header->sbf.mode) == CACHE_MODE_WB) {
+			pr_err("md_load: Can't enable write-back cache %s" \
+			       " with newer superblock version.",
+			       header->sbf.cache_name);
+			ret = 1;
+			goto free_header;
+		} else if ((le32_to_cpu(header->sbf.mode) == CACHE_MODE_RO) ||
+			   (le32_to_cpu(header->sbf.mode) == CACHE_MODE_WT)) {
+			dmc->persistence = CACHE_FORCECREATE;
+			pr_info("md_load: Can't enable cache, recreating" \
+				" cache %s with newer superblock version.",
+				header->sbf.cache_name);
+			ret = 0;
+			goto free_header;
+		}
+	}
+
+	/* check ondisk magic number */
+
+	if (le32_to_cpu(header->sbf.cache_version) >= EIO_SB_MAGIC_VERSION &&
+	    le32_to_cpu(header->sbf.magic) != EIO_MAGIC) {
+		pr_err("md_load: Magic number mismatch in superblock detected."	\
+		       " (current: %u, ondisk: %u)", EIO_MAGIC,
+		       le32_to_cpu(header->sbf.magic));
+		ret = 1;
+		goto free_header;
+	}
+
+	dmc->sb_version = EIO_SB_VERSION;
+
+	/*
+	 * TBD
+	 * For writeback, only when the dirty blocks are non-zero
+	 * and header state is unexpected, we should treat it as md corrupted.
+	 * Otherwise, a bad write in last shutdown, can lead to data inaccessible
+	 * in writeback case.
+	 */
+	if (!((le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_DIRTY) ||
+	      (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_CLEAN) ||
+	      (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_FASTCLEAN))) {
+		pr_err("md_load: Corrupt cache superblock");
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	if (le32_to_cpu(header->sbf.cold_boot) & BOOT_FLAG_FORCE_WARM) {
+		force_warm_boot = 1;
+		header->sbf.cold_boot = cpu_to_le32(le32_to_cpu(header->sbf.cold_boot) &
+						    ~BOOT_FLAG_FORCE_WARM);
+	}
+
+	/*
+	 * Determine if we can start as cold or hot cache
+	 * - if cold_boot is set(unless force_warm_boot), start as cold cache
+	 * - else if it is unclean shutdown, start as cold cache
+	 * cold cache will still treat the dirty blocks as hot
+	 */
+	if (dmc->cold_boot != le32_to_cpu(header->sbf.cold_boot)) {
+		pr_info
+			("superblock(%u) and config(%u) cold boot values do not match. Relying on config",
+			le32_to_cpu(header->sbf.cold_boot), dmc->cold_boot);
+	}
+	if (dmc->cold_boot && !force_warm_boot) {
+		pr_info
+			("Cold boot is set, starting as if unclean shutdown(only dirty blocks will be hot)");
+		clean_shutdown = 0;
+	} else {
+		if (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_DIRTY) {
+			pr_info("Unclean shutdown detected");
+			pr_info("Only dirty blocks exist in cache");
+			clean_shutdown = 0;
+		} else if (le32_to_cpu(header->sbf.cache_sb_state) == CACHE_MD_STATE_CLEAN) {
+			pr_info("Slow (clean) shutdown detected");
+			pr_info("Only clean blocks exist in cache");
+			clean_shutdown = 1;
+		} else if (le32_to_cpu(header->sbf.cache_sb_state) ==
+			   CACHE_MD_STATE_FASTCLEAN) {
+			pr_info("Fast (clean) shutdown detected");
+			pr_info("Both clean and dirty blocks exist in cache");
+			clean_shutdown = 1;
+		} else {
+			/* Won't reach here, but TBD may change the previous if condition */
+			pr_info
+				("cache state is %d. Treating as unclean shutdown",
+				le32_to_cpu(header->sbf.cache_sb_state));
+			pr_info("Only dirty blocks exist in cache");
+			clean_shutdown = 0;
+		}
+	}
+
+	if (!dmc->mode)
+		dmc->mode = le32_to_cpu(header->sbf.mode);
+	if (!dmc->req_policy)
+		dmc->req_policy = le32_to_cpu(header->sbf.repl_policy);
+
+	if (!dmc->cache_flags)
+		dmc->cache_flags = le32_to_cpu(header->sbf.cache_flags);
+
+	(void)eio_policy_init(dmc);
+
+	dmc->block_size = le64_to_cpu(header->sbf.block_size);
+	dmc->block_shift = ffs(dmc->block_size) - 1;
+	dmc->block_mask = dmc->block_size - 1;
+	dmc->size = le32_to_cpu(header->sbf.size);
+	dmc->cache_size = le64_to_cpu(header->sbf.cache_devsize);
+	dmc->assoc = le32_to_cpu(header->sbf.assoc);
+	dmc->consecutive_shift = ffs(dmc->assoc) - 1;
+	dmc->md_start_sect = le64_to_cpu(header->sbf.cache_md_start_sect);
+	dmc->md_sectors = le64_to_cpu(header->sbf.cache_data_start_sect);
+	dmc->sysctl_active.dirty_high_threshold =
+		le32_to_cpu(header->sbf.dirty_high_threshold);
+	dmc->sysctl_active.dirty_low_threshold =
+		le32_to_cpu(header->sbf.dirty_low_threshold);
+	dmc->sysctl_active.dirty_set_high_threshold =
+		le32_to_cpu(header->sbf.dirty_set_high_threshold);
+	dmc->sysctl_active.dirty_set_low_threshold =
+		le32_to_cpu(header->sbf.dirty_set_low_threshold);
+	dmc->sysctl_active.time_based_clean_interval =
+		le32_to_cpu(header->sbf.time_based_clean_interval);
+	dmc->sysctl_active.autoclean_threshold =
+		le32_to_cpu(header->sbf.autoclean_threshold);
+
+	i = eio_mem_init(dmc);
+	if (i == -1) {
+		pr_err("eio_md_load: Failed to initialize memory.");
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	order =
+		dmc->size *
+		((i ==
+		  1) ? sizeof(struct cacheblock_md8) : sizeof(struct cacheblock));
+	data_size = dmc->size * dmc->block_size;
+	size =
+		EIO_MD8(dmc) ? sizeof(struct cacheblock_md8) : sizeof(struct
+								      cacheblock);
+	pr_info("Allocate %lluKB (%lluB per) mem for %llu-entry cache "	\
+		"(capacity:%lluMB, associativity:%u, block size:%u bytes)",
+		(unsigned long long)order >> 10, (unsigned long long)size,
+		(long long unsigned int)dmc->size,
+		(long long unsigned int)(dmc->md_sectors + data_size) >> (20 -
+									  SECTOR_SHIFT),
+		dmc->assoc, dmc->block_size << SECTOR_SHIFT);
+
+	if (EIO_MD8(dmc))
+		dmc->cache_md8 = vmalloc((size_t)order);
+	else
+		dmc->cache = vmalloc((size_t)order);
+
+	if ((EIO_MD8(dmc) && !dmc->cache_md8) || (!EIO_MD8(dmc) && !dmc->cache)) {
+		pr_err("md_load: Unable to allocate memory");
+		vfree((void *)header);
+		return 1;
+	}
+
+	if (eio_repl_blk_init(dmc->policy_ops) != 0) {
+		vfree((void *)EIO_CACHE(dmc));
+		pr_err
+			("md_load: Unable to allocate memory for policy cache block");
+		ret = -EINVAL;
+		goto free_header;
+	}
+
+	/* Allocate pages of the order dmc->bio_nr_pages */
+	page_count = 0;
+	pages = eio_alloc_pages(dmc->bio_nr_pages, &page_count);
+	if (!pages) {
+		pr_err("md_create: unable to allocate pages");
+		pr_err("md_create: Could not write out cache metadata");
+		vfree((void *)EIO_CACHE(dmc));
+		ret = -ENOMEM;
+		goto free_header;
+	}
+
+	/* nr_pages is used for freeing the pages */
+	nr_pages = page_count;
+
+	pg_virt_addr = kmalloc(nr_pages * (sizeof(void *)), GFP_KERNEL);
+	if (pg_virt_addr == NULL) {
+		pr_err("eio_md_store: System memory too low.");
+		for (i = 0; i < nr_pages; i++)
+			put_page(pages[i].bv_page);
+		kfree(pages);
+		ret = -ENOMEM;
+		goto free_header;
+	}
+
+	for (i = 0; i < nr_pages; i++)
+		pg_virt_addr[i] = kmap(pages[i].bv_page);
+
+	/*
+	 * Read 1 PAGE of the metadata at a time and load up the
+	 * incore metadata struct.
+	 */
+
+	page_index = 0;
+	page_count = 0;
+	meta_data_cacheblock =
+		(struct flash_cacheblock *)pg_virt_addr[page_index];
+
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = dmc->md_start_sect;
+	size = dmc->size;
+	i = 0;
+	while (size > 0) {
+		slots_read =
+			min((long)size, ((long)MD_BLOCKS_PER_PAGE * nr_pages));
+
+		if (slots_read % MD_BLOCKS_PER_SECTOR)
+			where.count = 1 + (slots_read / MD_BLOCKS_PER_SECTOR);
+		else
+			where.count = slots_read / MD_BLOCKS_PER_SECTOR;
+
+		if (slots_read % MD_BLOCKS_PER_PAGE)
+			page_count = 1 + (slots_read / MD_BLOCKS_PER_PAGE);
+		else
+			page_count = slots_read / MD_BLOCKS_PER_PAGE;
+
+		sectors_read += where.count;    /* Debug */
+		error = eio_io_sync_vm(dmc, &where, READ, pages, page_count);
+		if (error) {
+			vfree((void *)EIO_CACHE(dmc));
+			pr_err
+				("md_load: Could not read cache metadata sector %llu error %d",
+				(unsigned long long)where.sector, error);
+			ret = -EIO;
+			goto free_md;
+		}
+
+		where.sector += where.count;
+		next_ptr = meta_data_cacheblock;
+
+		for (j = 0, page_index = 0; j < slots_read; j++) {
+
+			if ((j % MD_BLOCKS_PER_PAGE) == 0)
+				next_ptr =
+					(struct flash_cacheblock *)
+					pg_virt_addr[page_index++];
+
+			/* If unclean shutdown, only the DIRTY blocks are loaded.*/
+			if (clean_shutdown || (next_ptr->cache_state & DIRTY)) {
+
+				if (next_ptr->cache_state & DIRTY)
+					dirty_loaded++;
+
+				EIO_CACHE_STATE_SET(dmc, i,
+					(u_int8_t)le64_to_cpu(next_ptr->
+					cache_state) & ~QUEUED);
+
+				EIO_ASSERT((EIO_CACHE_STATE_GET(dmc, i) &
+					    (VALID | INVALID))
+					   != (VALID | INVALID));
+
+				if (EIO_CACHE_STATE_GET(dmc, i) & VALID)
+					num_valid++;
+				EIO_DBN_SET(dmc, i, le64_to_cpu(next_ptr->dbn));
+			} else
+				eio_invalidate_md(dmc, i);
+			next_ptr++;
+			i++;
+		}
+		size -= slots_read;
+	}
+
+	/*
+	 * If the cache contains dirty data, the only valid mode is write back.
+	 */
+	if (dirty_loaded && dmc->mode != CACHE_MODE_WB) {
+		vfree((void *)EIO_CACHE(dmc));
+		pr_err
+			("md_load: Cannot use %s mode because dirty data exists in the cache",
+			(dmc->mode ==
+			 CACHE_MODE_RO) ? "read only" : "write through");
+		ret = -EINVAL;
+		goto free_md;
+	}
+
+	/* Debug Tests */
+	sectors_expected = EIO_DIV(dmc->size, MD_BLOCKS_PER_SECTOR);
+	if (EIO_REM(dmc->size, MD_BLOCKS_PER_SECTOR))
+		sectors_expected++;
+	if (sectors_expected != sectors_read) {
+		pr_err
+			("md_load: Sector mismatch! sectors_expected=%llu, sectors_read=%llu\n",
+			(unsigned long long)sectors_expected, (unsigned long long)sectors_read);
+		vfree((void *)EIO_CACHE(dmc));
+		ret = -EIO;
+		goto free_md;
+	}
+
+	/* Before we finish loading, we need to dirty the superblock and write it out */
+	dmc->sb_state = CACHE_MD_STATE_DIRTY;
+	error = eio_sb_store(dmc);
+	if (error) {
+		vfree((void *)EIO_CACHE(dmc));
+		pr_err
+			("md_load: Could not write cache superblock sector(error %d)",
+			error);
+		ret = 1;
+		goto free_md;
+	}
+
+free_md:
+	for (i = 0; i < nr_pages; i++)
+		kunmap(pages[i].bv_page);
+	kfree(pg_virt_addr);
+
+	if (pages) {
+		for (i = 0; i < nr_pages; i++)
+			put_page(pages[i].bv_page);
+		kfree(pages);
+		pages = NULL;
+	}
+
+free_header:
+	/* Free header page here */
+	if (header_page) {
+		kunmap(header_page[0].bv_page);
+		put_page(header_page[0].bv_page);
+		kfree(header_page);
+		header_page = NULL;
+	}
+
+	pr_info("Cache metadata loaded from disk with %d valid %d dirty blocks",
+		num_valid, dirty_loaded);
+	return ret;
+}
+
+void eio_policy_free(struct cache_c *dmc)
+{
+
+	if (dmc->policy_ops != NULL) {
+		eio_put_policy(dmc->policy_ops);
+		vfree(dmc->policy_ops);
+	}
+	if (dmc->sp_cache_blk != NULL)
+		vfree(dmc->sp_cache_blk);
+	if (dmc->sp_cache_set != NULL)
+		vfree(dmc->sp_cache_set);
+
+	dmc->policy_ops = NULL;
+	dmc->sp_cache_blk = dmc->sp_cache_set = NULL;
+	return;
+}
+
+static int eio_clean_thread_init(struct cache_c *dmc)
+{
+	INIT_LIST_HEAD(&dmc->cleanq);
+	spin_lock_init(&dmc->clean_sl);
+	EIO_INIT_EVENT(&dmc->clean_event);
+	return eio_start_clean_thread(dmc);
+}
+
+int
+eio_handle_ssd_message(char *cache_name, char *ssd_name, enum dev_notifier note)
+{
+	struct cache_c *dmc;
+
+	dmc = eio_cache_lookup(cache_name);
+	if (NULL == dmc) {
+		pr_err("eio_handle_ssd_message: cache %s does not exist",
+		       cache_name);
+		return -EINVAL;
+	}
+
+	switch (note) {
+
+	case NOTIFY_SSD_ADD:
+		/* Making sure that CACHE state is not active */
+		if (CACHE_FAILED_IS_SET(dmc) || CACHE_DEGRADED_IS_SET(dmc))
+			eio_resume_caching(dmc, ssd_name);
+		else
+			pr_err
+				("eio_handle_ssd_message: SSD_ADD event called for ACTIVE cache \"%s\", ignoring!!!",
+				dmc->cache_name);
+		break;
+
+	case NOTIFY_SSD_REMOVED:
+		eio_suspend_caching(dmc, note);
+		break;
+
+	default:
+		pr_err("Wrong notifier passed for eio_handle_ssd_message\n");
+	}
+
+	return 0;
+}
+
+static void eio_init_ssddev_props(struct cache_c *dmc)
+{
+	struct request_queue *rq;
+	uint32_t max_hw_sectors, max_nr_pages;
+	uint32_t nr_pages = 0;
+
+	rq = bdev_get_queue(dmc->cache_dev->bdev);
+	max_hw_sectors = to_bytes(queue_max_hw_sectors(rq)) / PAGE_SIZE;
+	max_nr_pages = (u_int32_t)bio_get_nr_vecs(dmc->cache_dev->bdev);
+	nr_pages = min_t(u_int32_t, max_hw_sectors, max_nr_pages);
+	dmc->bio_nr_pages = nr_pages;
+
+	/*
+	 * If the cache device is not a physical device (eg: lv), then
+	 * driverfs_dev will be null and we make cache_gendisk_name a null
+	 * string. The eio_notify_ssd_rm() function in this case,
+	 * cannot detect device removal, and therefore, we will have to rely
+	 * on user space udev for the notification.
+	 */
+
+	if (dmc->cache_dev && dmc->cache_dev->bdev &&
+	    dmc->cache_dev->bdev->bd_disk &&
+	    dmc->cache_dev->bdev->bd_disk->driverfs_dev) {
+		strncpy(dmc->cache_gendisk_name,
+			dev_name(dmc->cache_dev->bdev->bd_disk->driverfs_dev),
+			DEV_PATHLEN);
+	} else
+		dmc->cache_gendisk_name[0] = '\0';
+}
+
+static void eio_init_srcdev_props(struct cache_c *dmc)
+{
+	/* Same applies for source device as well. */
+	if (dmc->disk_dev && dmc->disk_dev->bdev &&
+	    dmc->disk_dev->bdev->bd_disk &&
+	    dmc->disk_dev->bdev->bd_disk->driverfs_dev) {
+		strncpy(dmc->cache_srcdisk_name,
+			dev_name(dmc->disk_dev->bdev->bd_disk->driverfs_dev),
+			DEV_PATHLEN);
+	} else
+		dmc->cache_srcdisk_name[0] = '\0';
+}
+
+int eio_cache_create(struct cache_rec_short *cache)
+{
+	struct cache_c *dmc;
+	struct cache_c **nodepp;
+	unsigned int consecutive_blocks;
+	u_int64_t i;
+	index_t prev_set;
+	index_t cur_set;
+	sector_t order;
+	int error = -EINVAL;
+	uint32_t persistence = 0;
+	fmode_t mode = (FMODE_READ | FMODE_WRITE);
+	char *strerr = NULL;
+
+	dmc = kzalloc(sizeof(*dmc), GFP_KERNEL);
+	if (dmc == NULL) {
+		strerr = "Failed to allocate memory for cache context";
+		error = -ENOMEM;
+		goto bad;
+	}
+
+	/*
+	 * Source device.
+	 */
+
+	error = eio_ttc_get_device(cache->cr_src_devname, mode, &dmc->disk_dev);
+	if (error) {
+		strerr = "get_device for source device failed";
+		goto bad1;
+	}
+	if (NULL == dmc->disk_dev) {
+		error = -EINVAL;
+		strerr = "Failed to lookup source device";
+		goto bad1;
+	}
+	dmc->disk_size = eio_to_sector(eio_get_device_size(dmc->disk_dev));
+	if (dmc->disk_size >= EIO_MAX_SECTOR) {
+		strerr = "Source device too big to support";
+		error = -EFBIG;
+		goto bad2;
+	}
+	strncpy(dmc->disk_devname, cache->cr_src_devname, DEV_PATHLEN);
+
+	/*
+	 * Cache device.
+	 */
+
+	error =
+		eio_ttc_get_device(cache->cr_ssd_devname, mode, &dmc->cache_dev);
+	if (error) {
+		strerr = "get_device for cache device failed";
+		goto bad2;
+	}
+	if (NULL == dmc->cache_dev) {
+		error = -EINVAL;
+		strerr = "Failed to lookup source device";
+		goto bad2;
+	}
+	if (dmc->disk_dev == dmc->cache_dev) {
+		error = -EINVAL;
+		strerr = "Same devices specified";
+		goto bad3;
+	}
+	strncpy(dmc->cache_devname, cache->cr_ssd_devname, DEV_PATHLEN);
+
+	if (cache->cr_name[0] != '\0') {
+		strncpy(dmc->cache_name, cache->cr_name,
+			sizeof(dmc->cache_name));
+		/* make sure it is zero terminated */
+		dmc->cache_name[sizeof(dmc->cache_name) - 1] = '\x00';
+	} else {
+		strerr = "Need cache name";
+		error = -EINVAL;
+		goto bad3;
+	}
+
+	strncpy(dmc->ssd_uuid, cache->cr_ssd_uuid, DEV_PATHLEN - 1);
+
+	dmc->cache_dev_start_sect = eio_get_device_start_sect(dmc->cache_dev);
+	error = eio_do_preliminary_checks(dmc);
+	if (error) {
+		if (error == -EINVAL)
+			strerr = "Either Source and Cache devices belong to "
+				 "same device or a cache already exists on"
+				 " specified source device";
+		else if (error == -EEXIST)
+			strerr = "Cache already exists";
+		goto bad3;
+	}
+
+	eio_init_ssddev_props(dmc);
+	eio_init_srcdev_props(dmc);
+
+	/*
+	 * Initialize the io callback queue.
+	 */
+
+	dmc->callback_q = create_singlethread_workqueue("eio_callback");
+	if (!dmc->callback_q) {
+		error = -ENOMEM;
+		strerr = "Failed to initialize callback workqueue";
+		goto bad4;
+	}
+	error = eio_kcached_init(dmc);
+	if (error) {
+		strerr = "Failed to initialize kcached";
+		goto bad4;
+	}
+
+	/*
+	 * We read policy before reading other args. The reason is that
+	 * if there is a policy module loaded, we first need dmc->p_ops to be
+	 * allocated so that it is non NULL. Once p_ops is !NULL, cache_blk_init
+	 * and cache_set_init can set their pointers to dmc->p_ops->xxx
+	 *
+	 * policy_ops == NULL is not really an error. It just means that there
+	 * is no registered policy and therefore we use EIO_REPL_RANDOM (random)
+	 * as the replacement policy.
+	 */
+
+	/* We do a kzalloc for dmc, but being extra careful here */
+	dmc->sp_cache_blk = NULL;
+	dmc->sp_cache_set = NULL;
+	dmc->policy_ops = NULL;
+	if (cache->cr_policy) {
+		dmc->req_policy = cache->cr_policy;
+		if (dmc->req_policy && (dmc->req_policy < CACHE_REPL_FIRST ||
+					dmc->req_policy > CACHE_REPL_LAST)) {
+			strerr = "Invalid cache policy";
+			error = -EINVAL;
+			goto bad5;
+		}
+	}
+
+	/*
+	 * We need to determine the requested cache mode before we call
+	 * eio_md_load becuase it examines dmc->mode. The cache mode is
+	 * set as follows:
+	 * 1. For a "reload" operation:
+	 *      - if mode is not provided as an argument,
+	   it is read from superblock.
+	 *      - if mode is provided as an argument,
+	   eio_md_load verifies that it is valid.
+	 * 2. For a "create" operation:
+	 *      - if mode is not provided, it is set to CACHE_MODE_DEFAULT.
+	 *      - if mode is provided, it is validate and set.
+	 */
+	if (cache->cr_mode) {
+		dmc->mode = cache->cr_mode;
+		if (dmc->mode && (dmc->mode < CACHE_MODE_FIRST ||
+				  dmc->mode > CACHE_MODE_LAST)) {
+			strerr = "Invalid cache mode";
+			error = -EINVAL;
+			goto bad5;
+		}
+	}
+
+	dmc->cold_boot = cache->cr_cold_boot;
+	if ((dmc->cold_boot != 0) && (dmc->cold_boot != BOOT_FLAG_COLD_ENABLE)) {
+		strerr = "Invalid cold boot option";
+		error = -EINVAL;
+		goto bad5;
+	}
+
+	if (cache->cr_persistence) {
+		persistence = cache->cr_persistence;
+		if (persistence < CACHE_RELOAD ||
+		    persistence > CACHE_FORCECREATE) {
+			pr_err("ctr: persistence = %d", persistence);
+			strerr = "Invalid cache persistence";
+			error = -EINVAL;
+			goto bad5;
+		}
+		dmc->persistence = persistence;
+	}
+	if (persistence == CACHE_RELOAD) {
+		if (eio_md_load(dmc)) {
+			strerr = "Failed to reload cache";
+			error = -EINVAL;
+			goto bad5;
+		}
+
+		/*
+		 * "eio_md_load" will reset "dmc->persistence" from
+		 * CACHE_RELOAD to CACHE_FORCECREATE in the case of
+		 * cache superblock version mismatch and cache mode
+		 * is Read-Only or Write-Through.
+		 */
+		if (dmc->persistence != persistence)
+			persistence = dmc->persistence;
+	}
+
+	/*
+	 * Now that we're back from "eio_md_load" in the case of a reload,
+	 * we're ready to finish setting up the mode and policy.
+	 */
+	if (dmc->mode == 0) {
+		dmc->mode = CACHE_MODE_DEFAULT;
+		pr_info("Setting mode to default");
+	} else {
+		pr_info("Setting mode to %s ",
+			(dmc->mode == CACHE_MODE_WB) ? "write back" :
+			((dmc->mode == CACHE_MODE_RO) ? "read only" :
+			 "write through"));
+	}
+
+	/* eio_policy_init() is already called from within eio_md_load() */
+	if (persistence != CACHE_RELOAD)
+		(void)eio_policy_init(dmc);
+
+	if (cache->cr_flags) {
+		int flags;
+		flags = cache->cr_flags;
+		if (flags == 0)
+			dmc->cache_flags &= ~CACHE_FLAGS_INVALIDATE;
+		else if (flags == 1) {
+			dmc->cache_flags |= CACHE_FLAGS_INVALIDATE;
+			pr_info("Enabling invalidate API");
+		} else
+			pr_info("Ignoring unknown flags value: %u", flags);
+	}
+
+	if (persistence == CACHE_RELOAD)
+		goto init;      /* Skip reading cache parameters from command line */
+
+	if (cache->cr_blksize && cache->cr_ssd_sector_size) {
+		dmc->block_size = EIO_DIV(cache->cr_blksize, cache->cr_ssd_sector_size);
+		if (dmc->block_size & (dmc->block_size - 1)) {
+			strerr = "Invalid block size";
+			error = -EINVAL;
+			goto bad5;
+		}
+		if (dmc->block_size == 0)
+			dmc->block_size = DEFAULT_CACHE_BLKSIZE;
+	} else
+		dmc->block_size = DEFAULT_CACHE_BLKSIZE;
+	dmc->block_shift = ffs(dmc->block_size) - 1;
+	dmc->block_mask = dmc->block_size - 1;
+
+	/*
+	 * dmc->size is specified in sectors here, and converted to blocks later
+	 *
+	 * Giving preference to kernel got cache size.
+	 * Only when we can't get the cache size in kernel, we accept user passed size.
+	 * User mode may be using a different API or could also do some rounding, so we
+	 * prefer kernel getting the cache size. In case of device failure and coming back, we
+	 * rely on the device size got in kernel and we hope that it is equal to the
+	 * one we used for creating the cache, so we ideally should always use the kernel
+	 * got cache size.
+	 */
+	dmc->size = eio_to_sector(eio_get_device_size(dmc->cache_dev));
+	if (dmc->size == 0) {
+		if (cache->cr_ssd_dev_size && cache->cr_ssd_sector_size)
+			dmc->size =
+				EIO_DIV(cache->cr_ssd_dev_size, cache->cr_ssd_sector_size);
+
+		if (dmc->size == 0) {
+			strerr = "Invalid cache size or can't be fetched";
+			error = -EINVAL;
+			goto bad5;
+		}
+	}
+
+	dmc->cache_size = dmc->size;
+
+	if (cache->cr_assoc) {
+		dmc->assoc = cache->cr_assoc;
+		if ((dmc->assoc & (dmc->assoc - 1)) ||
+		    dmc->assoc > EIO_MAX_ASSOC || dmc->size < dmc->assoc) {
+			strerr = "Invalid cache associativity";
+			error = -EINVAL;
+			goto bad5;
+		}
+		if (dmc->assoc == 0)
+			dmc->assoc = DEFAULT_CACHE_ASSOC;
+	} else
+		dmc->assoc = DEFAULT_CACHE_ASSOC;
+
+	/*
+	 * initialize to an invalid index
+	 */
+
+	dmc->index_zero = dmc->assoc + 1;
+
+	/*
+	 * Although it's very unlikely, we need to make sure that
+	 * for the given associativity and block size our source
+	 * device will have less than 4 billion sets.
+	 */
+
+	i = EIO_DIV(eio_to_sector(eio_get_device_size(dmc->disk_dev)),
+		    (dmc->assoc * dmc->block_size));
+	if (i >= (((u_int64_t)1) << 32)) {
+		strerr = "Too many cache sets to support";
+		goto bad5;
+	}
+
+	consecutive_blocks = dmc->assoc;
+	dmc->consecutive_shift = ffs(consecutive_blocks) - 1;
+
+	/* Initialize persistent thresholds */
+	dmc->sysctl_active.dirty_high_threshold = DIRTY_HIGH_THRESH_DEF;
+	dmc->sysctl_active.dirty_low_threshold = DIRTY_LOW_THRESH_DEF;
+	dmc->sysctl_active.dirty_set_high_threshold = DIRTY_SET_HIGH_THRESH_DEF;
+	dmc->sysctl_active.dirty_set_low_threshold = DIRTY_SET_LOW_THRESH_DEF;
+	dmc->sysctl_active.autoclean_threshold = AUTOCLEAN_THRESH_DEF;
+	dmc->sysctl_active.time_based_clean_interval =
+		TIME_BASED_CLEAN_INTERVAL_DEF(dmc);
+
+	spin_lock_init(&dmc->cache_spin_lock);
+	if (persistence == CACHE_CREATE) {
+		error = eio_md_create(dmc, /* force */ 0, /* cold */ 1);
+		if (error) {
+			strerr = "Failed to create cache";
+			goto bad5;
+		}
+	} else {
+		error = eio_md_create(dmc, /* force */ 1, /* cold */ 1);
+		if (error) {
+			strerr = "Failed to force create cache";
+			goto bad5;
+		}
+	}
+
+init:
+	order = (dmc->size >> dmc->consecutive_shift) *
+		sizeof(struct cache_set);
+
+	if (!eio_mem_available(dmc, order)) {
+		strerr = "System memory too low"
+			 " for allocating cache set metadata";
+		error = -ENOMEM;
+		vfree((void *)EIO_CACHE(dmc));
+		goto bad5;
+	}
+
+	dmc->cache_sets = vmalloc((size_t)order);
+	if (!dmc->cache_sets) {
+		strerr = "Failed to allocate memory";
+		error = -ENOMEM;
+		vfree((void *)EIO_CACHE(dmc));
+		goto bad5;
+	}
+
+	for (i = 0; i < (dmc->size >> dmc->consecutive_shift); i++) {
+		dmc->cache_sets[i].nr_dirty = 0;
+		spin_lock_init(&dmc->cache_sets[i].cs_lock);
+		init_rwsem(&dmc->cache_sets[i].rw_lock);
+		dmc->cache_sets[i].mdreq = NULL;
+		dmc->cache_sets[i].flags = 0;
+	}
+	error = eio_repl_sets_init(dmc->policy_ops);
+	if (error < 0) {
+		strerr = "Failed to allocate memory for cache policy";
+		vfree((void *)dmc->cache_sets);
+		vfree((void *)EIO_CACHE(dmc));
+		goto bad5;
+	}
+	eio_policy_lru_pushblks(dmc->policy_ops);
+
+	if (dmc->mode == CACHE_MODE_WB) {
+		error = eio_allocate_wb_resources(dmc);
+		if (error) {
+			vfree((void *)dmc->cache_sets);
+			vfree((void *)EIO_CACHE(dmc));
+			goto bad5;
+		}
+	}
+
+	dmc->sysctl_active.error_inject = 0;
+	dmc->sysctl_active.fast_remove = 0;
+	dmc->sysctl_active.zerostats = 0;
+	dmc->sysctl_active.do_clean = 0;
+
+	atomic_set(&dmc->clean_index, 0);
+
+	atomic64_set(&dmc->nr_ios, 0);
+
+	/*
+	 * sysctl_mem_limit_pct [0 - 100]. Before doing a vmalloc()
+	 * make sure that the allocation size requested is less than
+	 * sysctl_mem_limit_pct percentage of the free RAM available
+	 * in the system. This is to avoid OOM errors in Linux.
+	 * 0 => do the vmalloc without checking system memory.
+	 */
+
+	dmc->sysctl_active.mem_limit_pct = 75;
+
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_UPDATE_LIST, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	dmc->next_cache = cache_list_head;
+	cache_list_head = dmc;
+	clear_bit(EIO_UPDATE_LIST, (void *)&eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_UPDATE_LIST);
+
+	prev_set = -1;
+	for (i = 0; i < dmc->size; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, i) & VALID)
+			atomic64_inc(&dmc->eio_stats.cached_blocks);
+		if (EIO_CACHE_STATE_GET(dmc, i) & DIRTY) {
+			dmc->cache_sets[EIO_DIV(i, dmc->assoc)].nr_dirty++;
+			atomic64_inc(&dmc->nr_dirty);
+			cur_set = EIO_DIV(i, dmc->assoc);
+			if (prev_set != cur_set) {
+				/* Move the given set at the head of the set LRU list */
+				eio_touch_set_lru(dmc, cur_set);
+				prev_set = cur_set;
+			}
+		}
+	}
+
+	INIT_WORK(&dmc->readfill_wq, eio_do_readfill);
+
+	/*
+	 * invalid index, but signifies cache successfully built
+	 */
+
+	dmc->index_zero = dmc->assoc;
+
+	eio_procfs_ctr(dmc);
+
+	/*
+	 * Activate Application Transparent Caching.
+	 */
+
+	error = eio_ttc_activate(dmc);
+	if (error)
+		goto bad6;
+
+	/*
+	 * In future if anyone adds code here and something fails,
+	 * do call eio_ttc_deactivate(dmc) as part of cleanup.
+	 */
+
+	return 0;
+
+bad6:
+	eio_procfs_dtr(dmc);
+	if (dmc->mode == CACHE_MODE_WB) {
+		eio_stop_async_tasks(dmc);
+		eio_free_wb_resources(dmc);
+	}
+	vfree((void *)dmc->cache_sets);
+	vfree((void *)EIO_CACHE(dmc));
+
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_UPDATE_LIST, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	nodepp = &cache_list_head;
+	while (*nodepp != NULL) {
+		if (*nodepp == dmc) {
+			*nodepp = dmc->next_cache;
+			break;
+		}
+		nodepp = &((*nodepp)->next_cache);
+	}
+	clear_bit(EIO_UPDATE_LIST, (void *)&eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_UPDATE_LIST);
+bad5:
+	eio_kcached_client_destroy(dmc);
+bad4:
+bad3:
+	eio_put_cache_device(dmc);
+bad2:
+	eio_ttc_put_device(&dmc->disk_dev);
+bad1:
+	eio_policy_free(dmc);
+	kfree(dmc);
+bad:
+	if (strerr)
+		pr_err("Cache creation failed: %s.\n", strerr);
+	return error;
+}
+
+/*
+ * Destroy the cache mapping.
+ */
+
+int eio_cache_delete(char *cache_name, int do_delete)
+{
+	struct cache_c *dmc;
+	struct cache_c **nodepp;
+	int ret, error;
+	int restart_async_task;
+
+	ret = 0;
+	restart_async_task = 0;
+
+	dmc = eio_cache_lookup(cache_name);
+	if (NULL == dmc) {
+		pr_err("cache delete: cache \"%s\" doesn't exist.", cache_name);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	if (dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG) {
+		pr_err("cache_delete: system shutdown in progress, cannot " \
+		       "delete cache %s", cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return -EINVAL;
+	}
+	if (dmc->cache_flags & CACHE_FLAGS_MOD_INPROG) {
+		pr_err
+			("cache_delete: simultaneous edit/delete operation " \
+			" on cache %s is not permitted", cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return -EINVAL;
+	}
+	dmc->cache_flags |= CACHE_FLAGS_MOD_INPROG;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+
+	/*
+	 * Earlier attempt to delete failed.
+	 * Allow force deletes only for FAILED caches.
+	 */
+	if (unlikely(CACHE_STALE_IS_SET(dmc))) {
+		if (likely(CACHE_FAILED_IS_SET(dmc))) {
+			pr_err
+				("cache_delete: Cache \"%s\" is in STALE state. Force deleting!!!",
+				dmc->cache_name);
+			goto force_delete;
+		} else {
+			if (atomic64_read(&dmc->nr_dirty) != 0) {
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags &= ~CACHE_FLAGS_MOD_INPROG;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				pr_err
+					("cache_delete: Stale Cache detected with dirty blocks=%lld.\n",
+					(long long)atomic64_read(&dmc->nr_dirty));
+				pr_err
+					("cache_delete: Cache \"%s\" wont be deleted. Deleting will result in data corruption.\n",
+					dmc->cache_name);
+				return -EINVAL;
+			}
+		}
+	}
+
+	eio_stop_async_tasks(dmc);
+
+	/*
+	 * Deactivate Application Transparent Caching.
+	 * For wb cache, finish_nr_dirty may take long time.
+	 * It should be guaranteed that normal cache delete should succeed
+	 * only when finish_nr_dirty is completely done.
+	 */
+
+	if (eio_ttc_deactivate(dmc, 0)) {
+
+		/* If deactivate fails; only option is to delete cache. */
+		pr_err("cache_delete: Failed to deactivate the cache \"%s\".",
+		       dmc->cache_name);
+		if (CACHE_FAILED_IS_SET(dmc))
+			pr_err
+				("cache_delete: Use -f option to delete the cache \"%s\".",
+				dmc->cache_name);
+		ret = -EPERM;
+		dmc->cache_flags |= CACHE_FLAGS_STALE;
+
+		/* Restart async tasks. */
+		restart_async_task = 1;
+		goto out;
+	}
+
+	if (!CACHE_FAILED_IS_SET(dmc))
+		EIO_ASSERT(dmc->sysctl_active.fast_remove
+			   || (atomic64_read(&dmc->nr_dirty) == 0));
+
+	/*
+	 * If ttc_deactivate succeeded... proceed with cache delete.
+	 * Dont entertain device failure hereafter.
+	 */
+	if (unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	    unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+		pr_err
+			("cache_delete: Cannot update metadata of cache \"%s\" in failed/degraded mode.",
+			dmc->cache_name);
+	} else
+		eio_md_store(dmc);
+
+force_delete:
+	eio_procfs_dtr(dmc);
+
+	if (CACHE_STALE_IS_SET(dmc)) {
+		pr_info("Force deleting cache \"%s\"!!!.", dmc->cache_name);
+		eio_ttc_deactivate(dmc, 1);
+	}
+
+	eio_free_wb_resources(dmc);
+	vfree((void *)EIO_CACHE(dmc));
+	vfree((void *)dmc->cache_sets);
+	eio_ttc_put_device(&dmc->disk_dev);
+	eio_put_cache_device(dmc);
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_UPDATE_LIST, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	nodepp = &cache_list_head;
+	while (*nodepp != NULL) {
+		if (*nodepp == dmc) {
+			*nodepp = dmc->next_cache;
+			break;
+		}
+		nodepp = &((*nodepp)->next_cache);
+	}
+	clear_bit(EIO_UPDATE_LIST, &eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_UPDATE_LIST);
+
+out:
+	if (restart_async_task) {
+		EIO_ASSERT(dmc->clean_thread == NULL);
+		error = eio_start_clean_thread(dmc);
+		if (error)
+			pr_err
+				("cache_delete: Failed to restart async tasks. error=%d\n",
+				error);
+	}
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	dmc->cache_flags &= ~CACHE_FLAGS_MOD_INPROG;
+	if (!ret)
+		dmc->cache_flags |= CACHE_FLAGS_DELETED;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+
+	if (!ret) {
+		eio_policy_free(dmc);
+
+		/*
+		 * We don't need synchronisation since at this point the dmc is
+		 * no more accessible via lookup.
+		 */
+
+		if (!(dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG))
+			kfree(dmc);
+	}
+
+	return ret;
+}
+
+/*
+ * Reconstruct a degraded cache after the SSD is added.
+ * This function mimics the constructor eio_ctr() except
+ * for code that does not require re-initialization.
+ */
+int eio_ctr_ssd_add(struct cache_c *dmc, char *dev)
+{
+	int r = 0;
+	struct eio_bdev *prev_cache_dev;
+	u_int32_t prev_persistence = dmc->persistence;
+	fmode_t mode = (FMODE_READ | FMODE_WRITE);
+
+	/* verify if source device is present */
+	EIO_ASSERT(dmc->eio_errors.no_source_dev == 0);
+
+	/* mimic relevant portions from eio_ctr() */
+
+	prev_cache_dev = dmc->cache_dev;
+	r = eio_ttc_get_device(dev, mode, &dmc->cache_dev);
+	if (r) {
+		dmc->cache_dev = prev_cache_dev;
+		pr_err("ctr_ssd_add: Failed to lookup cache device %s", dev);
+		return -EINVAL;
+	}
+	/*
+	 * For Linux, we have to put the old SSD device now because
+	 * we did not do so during SSD removal.
+	 */
+	eio_ttc_put_device(&prev_cache_dev);
+
+	/* sanity check */
+	if (dmc->cache_size != eio_to_sector(eio_get_device_size(dmc->cache_dev))) {
+		pr_err("ctr_ssd_add: Cache device size has changed," \
+		       "expected (%llu) found (%llu)" \
+		       "continuing in degraded mode",
+		       (unsigned long long)dmc->cache_size,
+		       (unsigned long long)eio_to_sector(
+			       eio_get_device_size(dmc->cache_dev)));
+		r = -EINVAL;
+		goto out;
+	}
+
+	/* sanity check for cache device start sector */
+	if (dmc->cache_dev_start_sect !=
+	    eio_get_device_start_sect(dmc->cache_dev)) {
+		pr_err("ctr_ssd_add: Cache device starting sector changed," \
+		       "expected (%llu) found (%llu) continuing in" \
+		       "degraded mode", (unsigned long long)dmc->cache_dev_start_sect,
+		       (unsigned long long)eio_get_device_start_sect(dmc->cache_dev));
+		r = -EINVAL;
+		goto out;
+	}
+
+	strncpy(dmc->cache_devname, dev, DEV_PATHLEN);
+	eio_init_ssddev_props(dmc);
+	dmc->size = dmc->cache_size;    /* dmc->size will be recalculated in eio_md_create() */
+
+	/*
+	 * In case of writeback mode, trust the content of SSD and reload the MD.
+	 */
+	dmc->persistence = CACHE_FORCECREATE;
+
+	eio_policy_free(dmc);
+	(void)eio_policy_init(dmc);
+
+	r = eio_md_create(dmc, /* force */ 1, /* cold */
+			  (dmc->mode != CACHE_MODE_WB));
+	if (r) {
+		pr_err
+			("ctr_ssd_add: Failed to create md, continuing in degraded mode");
+		goto out;
+	}
+
+	r = eio_repl_sets_init(dmc->policy_ops);
+	if (r < 0) {
+		pr_err
+			("ctr_ssd_add: Failed to allocate memory for cache policy");
+		goto out;
+	}
+	eio_policy_lru_pushblks(dmc->policy_ops);
+	if (dmc->mode != CACHE_MODE_WB)
+		/* Cold cache will reset the stats */
+		memset(&dmc->eio_stats, 0, sizeof(dmc->eio_stats));
+
+	return 0;
+out:
+	dmc->persistence = prev_persistence;
+
+	return r;
+}
+
+/*
+ * Stop the async tasks for a cache(threads, scheduled works).
+ * Used during the cache remove
+ */
+void eio_stop_async_tasks(struct cache_c *dmc)
+{
+	unsigned long flags = 0;
+
+	if (dmc->clean_thread) {
+		dmc->sysctl_active.fast_remove = 1;
+		spin_lock_irqsave(&dmc->clean_sl, flags);
+		EIO_SET_EVENT_AND_UNLOCK(&dmc->clean_event, &dmc->clean_sl,
+					 flags);
+		eio_wait_thread_exit(dmc->clean_thread,
+				     &dmc->clean_thread_running);
+		EIO_CLEAR_EVENT(&dmc->clean_event);
+		dmc->clean_thread = NULL;
+	}
+
+	dmc->sysctl_active.fast_remove = CACHE_FAST_REMOVE_IS_SET(dmc) ? 1 : 0;
+
+	if (dmc->mode == CACHE_MODE_WB) {
+		/*
+		 * Prevent new I/Os to schedule the time based cleaning.
+		 * Cancel existing delayed work
+		 */
+		dmc->sysctl_active.time_based_clean_interval = 0;
+		cancel_delayed_work_sync(&dmc->clean_aged_sets_work);
+	}
+}
+
+int eio_start_clean_thread(struct cache_c *dmc)
+{
+	EIO_ASSERT(dmc->clean_thread == NULL);
+	EIO_ASSERT(dmc->mode == CACHE_MODE_WB);
+	EIO_ASSERT(dmc->clean_thread_running == 0);
+	EIO_ASSERT(!(dmc->sysctl_active.do_clean & EIO_CLEAN_START));
+
+	dmc->clean_thread = eio_create_thread(eio_clean_thread_proc,
+					      (void *)dmc, "eio_clean_thread");
+	if (!dmc->clean_thread)
+		return -EFAULT;
+	return 0;
+}
+
+int eio_allocate_wb_resources(struct cache_c *dmc)
+{
+	int nr_bvecs, nr_pages;
+	unsigned iosize;
+	int ret;
+
+	EIO_ASSERT(dmc->clean_dbvecs == NULL);
+	EIO_ASSERT(dmc->clean_mdpages == NULL);
+	EIO_ASSERT(dmc->dbvec_count == 0);
+	EIO_ASSERT(dmc->mdpage_count == 0);
+
+	/* Data page allocations are done in terms of "bio_vec" structures */
+	iosize = (dmc->block_size * dmc->assoc) << SECTOR_SHIFT;
+	nr_bvecs = IO_BVEC_COUNT(iosize, dmc->block_size);
+	dmc->clean_dbvecs = kmalloc(sizeof(struct bio_vec) * nr_bvecs,
+				GFP_KERNEL);
+	if (dmc->clean_dbvecs == NULL) {
+		pr_err("cache_create: Failed to allocated memory.\n");
+		ret = -ENOMEM;
+		goto errout;
+	}
+	/* Allocate pages for each bio_vec */
+	ret = eio_alloc_wb_bvecs(dmc->clean_dbvecs, nr_bvecs, dmc->block_size);
+	if (ret)
+		goto errout;
+	EIO_ASSERT(dmc->clean_dbvecs != NULL);
+	dmc->dbvec_count = nr_bvecs;
+
+	/* Metadata page allocations are done in terms of pages only */
+	iosize = dmc->assoc * sizeof(struct flash_cacheblock);
+	nr_pages = IO_PAGE_COUNT(iosize);
+	dmc->clean_mdpages = kmalloc(sizeof(struct page *) * nr_pages,
+				GFP_KERNEL);
+	if (dmc->clean_mdpages == NULL) {
+		pr_err("cache_create: Failed to allocated memory.\n");
+		ret = -ENOMEM;
+		eio_free_wb_bvecs(dmc->clean_dbvecs, dmc->dbvec_count,
+				  dmc->block_size);
+		goto errout;
+	}
+	ret = eio_alloc_wb_pages(dmc->clean_mdpages, nr_pages);
+	if (ret) {
+		eio_free_wb_bvecs(dmc->clean_dbvecs, dmc->dbvec_count,
+				  dmc->block_size);
+		goto errout;
+	}
+	EIO_ASSERT(dmc->clean_mdpages != NULL);
+	dmc->mdpage_count = nr_pages;
+
+	/*
+	 * For writeback cache:
+	 * 1. Initialize the time based clean work queue
+	 * 2. Initialize the dirty set lru
+	 * 3. Initialize clean thread
+	 */
+
+	/*
+	 * Reset dmc->is_clean_aged_sets_sched.
+	 * Time based clean will be enabled in eio_touch_set_lru()
+	 * only when dmc->is_clean_aged_sets_sched  is zero and
+	 * dmc->sysctl_active.time_based_clean_interval > 0.
+	 */
+
+	dmc->is_clean_aged_sets_sched = 0;
+	INIT_DELAYED_WORK(&dmc->clean_aged_sets_work, eio_clean_aged_sets);
+	dmc->dirty_set_lru = NULL;
+	ret =
+		lru_init(&dmc->dirty_set_lru,
+			 (dmc->size >> dmc->consecutive_shift));
+	if (ret == 0) {
+		spin_lock_init(&dmc->dirty_set_lru_lock);
+		ret = eio_clean_thread_init(dmc);
+	}
+	EIO_ASSERT(dmc->mdupdate_q == NULL);
+	dmc->mdupdate_q = create_singlethread_workqueue("eio_mdupdate");
+	if (!dmc->mdupdate_q)
+		ret = -ENOMEM;
+
+	if (ret < 0) {
+		pr_err("cache_create: Failed to initialize dirty lru set or" \
+		       "clean/mdupdate thread for wb cache.\n");
+		if (dmc->dirty_set_lru) {
+			lru_uninit(dmc->dirty_set_lru);
+			dmc->dirty_set_lru = NULL;
+		}
+
+		eio_free_wb_pages(dmc->clean_mdpages, dmc->mdpage_count);
+		eio_free_wb_bvecs(dmc->clean_dbvecs, dmc->dbvec_count,
+				  dmc->block_size);
+		goto errout;
+	}
+
+	goto out;
+
+errout:
+	if (dmc->clean_mdpages) {
+		kfree(dmc->clean_mdpages);
+		dmc->clean_mdpages = NULL;
+		dmc->mdpage_count = 0;
+	}
+	if (dmc->clean_dbvecs) {
+		kfree(dmc->clean_dbvecs);
+		dmc->clean_dbvecs = NULL;
+		dmc->dbvec_count = 0;
+	}
+
+out:
+	return ret;
+}
+
+void eio_free_wb_resources(struct cache_c *dmc)
+{
+
+	if (dmc->mdupdate_q) {
+		flush_workqueue(dmc->mdupdate_q);
+		destroy_workqueue(dmc->mdupdate_q);
+		dmc->mdupdate_q = NULL;
+	}
+	if (dmc->dirty_set_lru) {
+		lru_uninit(dmc->dirty_set_lru);
+		dmc->dirty_set_lru = NULL;
+	}
+	if (dmc->clean_mdpages) {
+		eio_free_wb_pages(dmc->clean_mdpages, dmc->mdpage_count);
+		kfree(dmc->clean_mdpages);
+		dmc->clean_mdpages = NULL;
+	}
+	if (dmc->clean_dbvecs) {
+		eio_free_wb_bvecs(dmc->clean_dbvecs, dmc->dbvec_count,
+				  dmc->block_size);
+		kfree(dmc->clean_dbvecs);
+		dmc->clean_dbvecs = NULL;
+	}
+
+	dmc->dbvec_count = dmc->mdpage_count = 0;
+	return;
+}
+
+static int
+eio_notify_reboot(struct notifier_block *this, unsigned long code, void *x)
+{
+	struct cache_c *dmc;
+
+	if (eio_reboot_notified == EIO_REBOOT_HANDLING_DONE)
+		return NOTIFY_DONE;
+
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_HANDLE_REBOOT, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	if (eio_reboot_notified == EIO_REBOOT_HANDLING_DONE) {
+		clear_bit(EIO_HANDLE_REBOOT, (void *)&eio_control->synch_flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit((void *)&eio_control->synch_flags,
+			    EIO_HANDLE_REBOOT);
+		return NOTIFY_DONE;
+	}
+	EIO_ASSERT(eio_reboot_notified == 0);
+	eio_reboot_notified = EIO_REBOOT_HANDLING_INPROG;
+
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_UPDATE_LIST, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	for (dmc = cache_list_head; dmc != NULL; dmc = dmc->next_cache) {
+		if (unlikely(CACHE_FAILED_IS_SET(dmc))
+		    || unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+			pr_err
+				("notify_reboot: Cannot sync in failed / degraded mode");
+			continue;
+		}
+		if (dmc->cold_boot && atomic64_read(&dmc->nr_dirty)
+		    && !eio_force_warm_boot) {
+			pr_info
+				("Cold boot set for cache %s: Draining dirty blocks: %lld",
+				dmc->cache_name, (long long)atomic64_read(&dmc->nr_dirty));
+			eio_clean_for_reboot(dmc);
+		}
+		eio_md_store(dmc);
+	}
+	clear_bit(EIO_UPDATE_LIST, (void *)&eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_UPDATE_LIST);
+
+	eio_reboot_notified = EIO_REBOOT_HANDLING_DONE;
+	clear_bit(EIO_HANDLE_REBOOT, (void *)&eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_HANDLE_REBOOT);
+	return NOTIFY_DONE;
+}
+
+/*
+ * The SSD add/remove is handled using udev from the user space. The driver
+ * is notified from the user space via dmsetup message. Both device addition
+ * and removal events are handled in the driver by eio_handle_message().
+ *
+ * The device remove has a special case. From the time the device is removed,
+ * until the time the driver gets notified from the user space could be a few msec
+ * or a couple of seconds. During this time, any IO to the SSD fails. While this
+ * is handled gracefully, the logs can get filled with IO error messages.
+ *
+ * In order to cover that gap, we handle the device removal within the kernel
+ * using this function. Note that using the scsi notifier function in the kernel
+ * (vs. receiving the message from user space) minimizes the notification delay
+ * between the time the SSD is removed until the driver is notified. This cannot,
+ * however, make this delay zero. Therefore, there will be a small window during
+ * which eio_io_callback() may fail on CACHEWRITE action.
+ *
+ * We still need the user space (udev) method of handling for the following
+ * reasons:
+ * (i)  This notifier is only for a scsi device.
+ * (ii) The add/remove feature in user space can also be used to dynamically
+ *      turn the cache on and off.
+ *
+ * This notifier is used only when SSD is removed. The add event can
+ * be caught using the BUS_NOTIFY_ADD_DEVICE in action. However, we only
+ * get a scsi handle and do not have a reference to our device pointer.
+ */
+static int
+eio_notify_ssd_rm(struct notifier_block *nb, unsigned long action, void *data)
+{
+	struct device *dev = data;
+	struct cache_c *dmc;
+	const char *device_name;
+	size_t len;
+	unsigned long int flags = 0;
+	struct ssd_rm_list *ssd_list_ptr;
+	unsigned check_src = 0, check_ssd = 0;
+	enum dev_notifier notify = NOTIFY_INITIALIZER;
+
+	if (likely(action != BUS_NOTIFY_DEL_DEVICE))
+		return 0;
+
+	if (unlikely(dev == NULL)) {
+		pr_info("notify_cache_dev: device is NULL!");
+		return 0;
+	}
+
+	if (!scsi_is_sdev_device(dev))
+		return 0;
+	device_name = dev_name(dev);
+	if (device_name == NULL)
+		return 0;
+	len = strlen(device_name);
+
+	/* push to a list for future processing as we could be in an interrupt context */
+	for (dmc = cache_list_head; dmc != NULL; dmc = dmc->next_cache) {
+		notify = NOTIFY_INITIALIZER;
+		check_src = ('\0' == dmc->cache_srcdisk_name[0] ? 0 : 1);
+		check_ssd = ('\0' == dmc->cache_gendisk_name[0] ? 0 : 1);
+
+		if (check_src == 0 && check_ssd == 0)
+			continue;
+
+		/*Check if source dev name or ssd dev name is available or not. */
+		if (check_ssd
+		    && 0 == strncmp(device_name, dmc->cache_gendisk_name,
+				    len)) {
+			pr_info("SSD Removed for cache name %s",
+				dmc->cache_name);
+			notify = NOTIFY_SSD_REMOVED;
+		}
+
+		if (check_src
+		    && 0 == strncmp(device_name, dmc->cache_srcdisk_name,
+				    len)) {
+			pr_info("SRC Removed for cache name %s",
+				dmc->cache_name);
+			notify = NOTIFY_SRC_REMOVED;
+		}
+
+		if (notify == NOTIFY_INITIALIZER)
+			continue;
+
+		ssd_list_ptr = kmalloc(sizeof(struct ssd_rm_list), GFP_ATOMIC);
+		if (unlikely(ssd_list_ptr == NULL)) {
+			pr_err("Cannot allocate memory for ssd_rm_list");
+			return -ENOMEM;
+		}
+		ssd_list_ptr->dmc = dmc;
+		ssd_list_ptr->action = action;
+		ssd_list_ptr->devt = dev->devt;
+		ssd_list_ptr->note = notify;
+		spin_lock_irqsave(&ssd_rm_list_lock, flags);
+		list_add_tail(&ssd_list_ptr->list, &ssd_rm_list);
+		ssd_rm_list_not_empty = 1;
+		spin_unlock_irqrestore(&ssd_rm_list_lock, flags);
+	}
+
+	spin_lock_irqsave(&ssd_rm_list_lock, flags);
+	if (ssd_rm_list_not_empty) {
+		spin_unlock_irqrestore(&ssd_rm_list_lock, flags);
+		schedule_work(&_kcached_wq);
+	} else
+		spin_unlock_irqrestore(&ssd_rm_list_lock, flags);
+
+	return 0;
+}
+
+/*
+ * Initiate a cache target.
+ */
+static int __init eio_init(void)
+{
+	int r;
+	extern struct bus_type scsi_bus_type;
+
+	eio_ttc_init();
+	r = eio_create_misc_device();
+	if (r)
+		return r;
+
+	r = eio_jobs_init();
+	if (r) {
+		(void)eio_delete_misc_device();
+		return r;
+	}
+	atomic_set(&nr_cache_jobs, 0);
+	INIT_WORK(&_kcached_wq, eio_do_work);
+
+	eio_module_procfs_init();
+	eio_control = kmalloc(sizeof(*eio_control), GFP_KERNEL);
+	if (eio_control == NULL) {
+		pr_err("init: Cannot allocate memory for eio_control");
+		(void)eio_delete_misc_device();
+		return -ENOMEM;
+	}
+	eio_control->synch_flags = 0;
+
+	register_reboot_notifier(&eio_reboot_notifier);
+	r = bus_register_notifier(&scsi_bus_type, &eio_ssd_rm_notifier);
+	if (r) {
+		pr_err("init: bus register notifier failed %d", r);
+		(void)eio_delete_misc_device();
+	}
+	return r;
+}
+
+/*
+ * Destroy a cache target.
+ */
+static void eio_exit(void)
+{
+	int r;
+	extern struct bus_type scsi_bus_type;
+
+	unregister_reboot_notifier(&eio_reboot_notifier);
+	r = bus_unregister_notifier(&scsi_bus_type, &eio_ssd_rm_notifier);
+	if (r)
+		pr_err("exit: Bus unregister notifier failed %d", r);
+
+	eio_jobs_exit();
+	eio_module_procfs_exit();
+	if (eio_control) {
+		eio_control->synch_flags = 0;
+		kfree(eio_control);
+		eio_control = NULL;
+	}
+	(void)eio_delete_misc_device();
+}
+
+/*
+ * eio_get_device_size
+ */
+sector_t eio_get_device_size(struct eio_bdev *dev)
+{
+
+	return dev->bdev->bd_inode->i_size;
+}
+
+/*
+ * To get starting sector of the device
+ */
+sector_t eio_get_device_start_sect(struct eio_bdev *dev)
+{
+
+	if (dev == NULL || dev->bdev == NULL || dev->bdev->bd_part == NULL)
+		return 0;
+
+	return dev->bdev->bd_part->start_sect;
+}
+
+module_init(eio_init);
+module_exit(eio_exit);
+
+MODULE_DESCRIPTION(DM_NAME "sTec(R) EnhanceIO target");
+MODULE_AUTHOR("sTec(R), Inc. based on code by Facebook");
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/block/enhanceio/eio_fifo.c b/drivers/block/enhanceio/eio_fifo.c
new file mode 100644
index 0000000..b377d86
--- /dev/null
+++ b/drivers/block/enhanceio/eio_fifo.c
@@ -0,0 +1,239 @@
+/*
+ *  eio_fifo.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "eio.h"
+/* Generic policy functions prototypes */
+int eio_fifo_init(struct cache_c *);
+void eio_fifo_exit(void);
+int eio_fifo_cache_sets_init(struct eio_policy *);
+int eio_fifo_cache_blk_init(struct eio_policy *);
+void eio_fifo_find_reclaim_dbn(struct eio_policy *, index_t, index_t *);
+int eio_fifo_clean_set(struct eio_policy *, index_t, int);
+
+/* Per policy instance initialization */
+struct eio_policy *eio_fifo_instance_init(void);
+
+/* Per cache set data structure */
+struct eio_fifo_cache_set {
+	index_t set_fifo_next;
+	index_t set_clean_next;
+};
+
+/*
+ * Context that captures the FIFO replacement policy
+ */
+static struct eio_policy_header eio_fifo_ops = {
+	.sph_name		= CACHE_REPL_FIFO,
+	.sph_instance_init	= eio_fifo_instance_init,
+};
+
+/*
+ * Initialize FIFO policy.
+ */
+int eio_fifo_init(struct cache_c *dmc)
+{
+	return 0;
+}
+
+/*
+ * Initialize FIFO data structure called from ctr.
+ */
+int eio_fifo_cache_sets_init(struct eio_policy *p_ops)
+{
+	int i;
+	sector_t order;
+	struct cache_c *dmc = p_ops->sp_dmc;
+	struct eio_fifo_cache_set *cache_sets;
+
+	pr_info("Initializing fifo cache sets\n");
+	order = (dmc->size >> dmc->consecutive_shift) *
+		sizeof(struct eio_fifo_cache_set);
+
+	dmc->sp_cache_set = vmalloc((size_t)order);
+	if (dmc->sp_cache_set == NULL)
+		return -ENOMEM;
+
+	cache_sets = (struct eio_fifo_cache_set *)dmc->sp_cache_set;
+
+	for (i = 0; i < (int)(dmc->size >> dmc->consecutive_shift); i++) {
+		cache_sets[i].set_fifo_next = i * dmc->assoc;
+		cache_sets[i].set_clean_next = i * dmc->assoc;
+	}
+
+	return 0;
+}
+
+/*
+ * The actual function that returns a victim block in index.
+ */
+void
+eio_fifo_find_reclaim_dbn(struct eio_policy *p_ops, index_t start_index,
+			  index_t *index)
+{
+	index_t end_index;
+	int slots_searched = 0;
+	index_t i;
+	index_t set;
+	struct eio_fifo_cache_set *cache_sets;
+	struct cache_c *dmc = p_ops->sp_dmc;
+
+	set = start_index / dmc->assoc;
+	end_index = start_index + dmc->assoc;
+	cache_sets = (struct eio_fifo_cache_set *)dmc->sp_cache_set;
+
+	i = cache_sets[set].set_fifo_next;
+	while (slots_searched < (int)dmc->assoc) {
+		EIO_ASSERT(i >= start_index);
+		EIO_ASSERT(i < end_index);
+		if (EIO_CACHE_STATE_GET(dmc, i) == VALID) {
+			*index = i;
+			break;
+		}
+		slots_searched++;
+		i++;
+		if (i == end_index)
+			i = start_index;
+	}
+	i++;
+	if (i == end_index)
+		i = start_index;
+	cache_sets[set].set_fifo_next = i;
+}
+
+/*
+ * Go through the entire set and clean.
+ */
+int eio_fifo_clean_set(struct eio_policy *p_ops, index_t set, int to_clean)
+{
+	index_t i;
+	int scanned = 0, nr_writes = 0;
+	index_t start_index;
+	index_t end_index;
+	struct eio_fifo_cache_set *cache_sets;
+	struct cache_c *dmc;
+
+	dmc = p_ops->sp_dmc;
+	cache_sets = (struct eio_fifo_cache_set *)dmc->sp_cache_set;
+	start_index = set * dmc->assoc;
+	end_index = start_index + dmc->assoc;
+	i = cache_sets[set].set_clean_next;
+
+	while ((scanned < (int)dmc->assoc) && (nr_writes < to_clean)) {
+		if ((EIO_CACHE_STATE_GET(dmc, i) & (DIRTY | BLOCK_IO_INPROG)) ==
+		    DIRTY) {
+			EIO_CACHE_STATE_ON(dmc, i, DISKWRITEINPROG);
+			nr_writes++;
+		}
+		scanned++;
+		i++;
+		if (i == end_index)
+			i = start_index;
+	}
+	cache_sets[set].set_clean_next = i;
+
+	return nr_writes;
+}
+
+/*
+ * FIFO is per set, so do nothing on a per block init.
+ */
+int eio_fifo_cache_blk_init(struct eio_policy *p_ops)
+{
+	return 0;
+}
+
+/*
+ * Allocate a new instance of eio_policy per dmc
+ */
+struct eio_policy *eio_fifo_instance_init(void)
+{
+	struct eio_policy *new_instance;
+
+	new_instance = vmalloc(sizeof(struct eio_policy));
+	if (new_instance == NULL) {
+		pr_err("ssdscache_fifo_instance_init: vmalloc failed");
+		return NULL;
+	}
+
+	/* Initialize the FIFO specific functions and variables */
+	new_instance->sp_name = CACHE_REPL_FIFO;
+	new_instance->sp_policy.lru = NULL;
+	new_instance->sp_repl_init = eio_fifo_init;
+	new_instance->sp_repl_exit = eio_fifo_exit;
+	new_instance->sp_repl_sets_init = eio_fifo_cache_sets_init;
+	new_instance->sp_repl_blk_init = eio_fifo_cache_blk_init;
+	new_instance->sp_find_reclaim_dbn = eio_fifo_find_reclaim_dbn;
+	new_instance->sp_clean_set = eio_fifo_clean_set;
+	new_instance->sp_dmc = NULL;
+
+	try_module_get(THIS_MODULE);
+
+	pr_info("eio_fifo_instance_init: created new instance of FIFO");
+
+	return new_instance;
+}
+
+/*
+ * Cleanup an instance of eio_policy (called from dtr).
+ */
+void eio_fifo_exit(void)
+{
+	module_put(THIS_MODULE);
+}
+
+static
+int __init fifo_register(void)
+{
+	int ret;
+
+	ret = eio_register_policy(&eio_fifo_ops);
+	if (ret != 0)
+		pr_info("eio_fifo already registered");
+
+	return ret;
+}
+
+static
+void __exit fifo_unregister(void)
+{
+	int ret;
+
+	ret = eio_unregister_policy(&eio_fifo_ops);
+	if (ret != 0)
+		pr_err("eio_fifo unregister failed");
+}
+
+module_init(fifo_register);
+module_exit(fifo_unregister);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("FIFO policy for EnhanceIO");
+MODULE_AUTHOR("sTec(R), Inc. based on code by Facebook");
diff --git a/drivers/block/enhanceio/eio_ioctl.c b/drivers/block/enhanceio/eio_ioctl.c
new file mode 100644
index 0000000..79a8785
--- /dev/null
+++ b/drivers/block/enhanceio/eio_ioctl.c
@@ -0,0 +1,157 @@
+/*
+ *  eio_ioctl.c
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+#include "eio_ttc.h"
+
+long eio_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+{
+	int error = 0;
+	struct cache_rec_short *cache;
+	uint64_t ncaches;
+	enum dev_notifier note;
+	int do_delete = 0;
+
+	switch (cmd) {
+	case EIO_IOC_CREATE:
+	case EIO_IOC_ENABLE:
+
+		cache = vmalloc(sizeof(struct cache_rec_short));
+		if (!cache)
+			return -ENOMEM;
+
+		if (copy_from_user(cache, (void __user *)arg,
+				   sizeof(struct cache_rec_short))) {
+			vfree(cache);
+			return -EFAULT;
+		}
+		error = eio_cache_create(cache);
+		vfree(cache);
+		break;
+
+	case EIO_IOC_DELETE:
+		do_delete = 1;
+
+	case EIO_IOC_DISABLE:
+
+		cache = vmalloc(sizeof(struct cache_rec_short));
+		if (!cache)
+			return -ENOMEM;
+
+		if (copy_from_user(cache, (void __user *)arg,
+				   sizeof(struct cache_rec_short))) {
+			vfree(cache);
+			return -EFAULT;
+		}
+		error = eio_cache_delete(cache->cr_name, do_delete);
+		vfree(cache);
+		break;
+
+	case EIO_IOC_EDIT:
+		cache = vmalloc(sizeof(struct cache_rec_short));
+		if (!cache)
+			return -ENOMEM;
+
+		if (copy_from_user(cache, (void __user *)arg,
+				   sizeof(struct cache_rec_short))) {
+			vfree(cache);
+			return -EFAULT;
+		}
+		error = eio_cache_edit(cache->cr_name,
+				       (u_int32_t)cache->cr_mode,
+				       (u_int32_t)cache->cr_policy);
+		vfree(cache);
+		break;
+
+	case EIO_IOC_NCACHES:
+		ncaches = eio_get_cache_count();
+		if (copy_to_user((uint64_t __user *)arg, &ncaches,
+				 sizeof(uint64_t)))
+			return -EFAULT;
+		break;
+
+	case EIO_IOC_CACHE_LIST:
+		error = eio_get_cache_list((unsigned long __user *)arg);
+		break;
+
+	case EIO_IOC_SET_WARM_BOOT:
+		eio_set_warm_boot();
+		break;
+
+	case EIO_IOC_SSD_ADD:
+		cache = vmalloc(sizeof(struct cache_rec_short));
+		if (!cache)
+			return -ENOMEM;
+
+		if (copy_from_user(cache, (void __user *)arg,
+				   sizeof(struct cache_rec_short))) {
+			vfree(cache);
+			return -EFAULT;
+		}
+		note = NOTIFY_SSD_ADD;
+		error =
+			eio_handle_ssd_message(cache->cr_name,
+					       cache->cr_ssd_devname, note);
+		vfree(cache);
+
+		break;
+
+	case EIO_IOC_SSD_REMOVE:
+		cache = vmalloc(sizeof(struct cache_rec_short));
+		if (!cache)
+			return -ENOMEM;
+		if (copy_from_user(cache, (void __user *)arg,
+				   sizeof(struct cache_rec_short))) {
+			vfree(cache);
+			return -EFAULT;
+		}
+		note = NOTIFY_SSD_REMOVED;
+		error =
+			eio_handle_ssd_message(cache->cr_name,
+					       cache->cr_ssd_devname, note);
+		vfree(cache);
+		break;
+
+	case EIO_IOC_SRC_ADD:
+		break;
+
+	case EIO_IOC_NOTIFY_REBOOT:
+		eio_reboot_handling();
+		break;
+
+	default:
+		error = EINVAL;
+	}
+	return error;
+}
+
+long eio_compact_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+{
+	return eio_ioctl(filp, cmd, arg);
+}
diff --git a/drivers/block/enhanceio/eio_ioctl.h b/drivers/block/enhanceio/eio_ioctl.h
new file mode 100644
index 0000000..213fc78
--- /dev/null
+++ b/drivers/block/enhanceio/eio_ioctl.h
@@ -0,0 +1,86 @@
+/*
+ *  eio_ioctl.h
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ ****************************************************************************/
+
+#ifndef EIO_IOCTL_H
+#define EIO_IOCTL_H
+
+#define EIO_DEVPATH     "/dev/eiodev"
+#define MISC_DEVICE     "eiodev"
+
+#define CACHE_NAME_LEN          31
+#define CACHE_NAME_SZ           (CACHE_NAME_LEN + 1)
+
+#define NAME_LEN                127
+#define NAME_SZ                 (NAME_LEN + 1)
+
+#define EIO_IOC_CREATE _IOW('E', 0, struct cache_rec_short)
+#define EIO_IOC_DELETE _IOW('E', 1, struct cache_rec_short)
+#define EIO_IOC_ENABLE _IOW('E', 2, struct cache_rec_short)
+#define EIO_IOC_DISABLE _IOW('E', 3, struct cache_rec_short)
+#define EIO_IOC_EDIT _IOW('E', 4, struct cache_rec_short)
+#define EIO_IOC_NCACHES _IOR('E', 5, uint64_t)
+#define EIO_IOC_CACHE_LIST _IOWR('E', 6, struct cache_list)
+#define EIO_IOC_SSD_ADD _IOW('E', 7, struct cache_rec_short)
+#define EIO_IOC_SSD_REMOVE _IOW('E', 8, struct cache_rec_short)
+#define EIO_IOC_SRC_ADD _IOW('E', 9, struct cache_rec_short)
+#define EIO_IOC_SRC_REMOVE _IOW('E', 10, struct cache_rec_short)
+#define EIO_IOC_NOTIFY_REBOOT _IO('E', 11)
+#define EIO_IOC_SET_WARM_BOOT _IO('E', 12)
+#define EIO_IOC_UNUSED _IO('E', 13)
+
+
+struct cache_rec_short {
+	char cr_name[CACHE_NAME_SZ];
+	char cr_src_devname[NAME_SZ];
+	char cr_ssd_devname[NAME_SZ];
+	char cr_ssd_uuid[NAME_SZ];
+	uint64_t cr_src_dev_size;
+	uint64_t cr_ssd_dev_size;
+	uint32_t cr_src_sector_size;
+	uint32_t cr_ssd_sector_size;
+	uint32_t cr_flags;      /* CACHE_FLAGS_INV* etc. */
+	char cr_policy;
+	char cr_mode;
+	char cr_persistence;
+	char cr_cold_boot;
+	uint64_t cr_blksize;
+	uint64_t cr_assoc;
+};
+
+struct cache_list {
+	uint64_t ncaches;
+	struct cache_rec_short *cachelist;
+};
+
+#ifdef __KERNEL__
+long eio_ioctl(struct file *filp, unsigned cmd, unsigned long arg);
+long eio_compact_ioctl(struct file *filp, unsigned cmd, unsigned long arg);
+#endif                          /* __KERNEL__ */
+
+#endif                          /* !EIO_IOCTL_H */
diff --git a/drivers/block/enhanceio/eio_lru.c b/drivers/block/enhanceio/eio_lru.c
new file mode 100644
index 0000000..c94083d
--- /dev/null
+++ b/drivers/block/enhanceio/eio_lru.c
@@ -0,0 +1,322 @@
+/*
+ *  eio_lru.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "eio.h"
+/* Generic policy functions prototyes */
+int eio_lru_init(struct cache_c *);
+void eio_lru_exit(void);
+int eio_lru_cache_sets_init(struct eio_policy *);
+int eio_lru_cache_blk_init(struct eio_policy *);
+void eio_lru_find_reclaim_dbn(struct eio_policy *, index_t, index_t *);
+int eio_lru_clean_set(struct eio_policy *, index_t, int);
+/* Per policy instance initialization */
+struct eio_policy *eio_lru_instance_init(void);
+
+/* LRU specific policy functions prototype */
+void eio_lru_pushblks(struct eio_policy *);
+void eio_reclaim_lru_movetail(struct cache_c *, index_t, struct eio_policy *);
+
+/* Per cache set data structure */
+struct eio_lru_cache_set {
+	u_int16_t lru_head, lru_tail;
+};
+
+/* Per cache block data structure */
+struct eio_lru_cache_block {
+	u_int16_t lru_prev, lru_next;
+};
+
+/* LRU specifc data structures */
+static struct eio_lru eio_lru = {
+	.sl_lru_pushblks		= eio_lru_pushblks,
+	.sl_reclaim_lru_movetail	= eio_reclaim_lru_movetail,
+};
+
+/*
+ * Context that captures the LRU replacement policy
+ */
+static struct eio_policy_header eio_lru_ops = {
+	.sph_name		= CACHE_REPL_LRU,
+	.sph_instance_init	= eio_lru_instance_init,
+};
+
+/*
+ * Intialize LRU. Called from ctr.
+ */
+int eio_lru_init(struct cache_c *dmc)
+{
+	return 0;
+}
+
+/*
+ * Initialize per set LRU data structures.
+ */
+int eio_lru_cache_sets_init(struct eio_policy *p_ops)
+{
+	sector_t order;
+	int i;
+	struct cache_c *dmc = p_ops->sp_dmc;
+	struct eio_lru_cache_set *cache_sets;
+
+	order =
+		(dmc->size >> dmc->consecutive_shift) *
+		sizeof(struct eio_lru_cache_set);
+
+	dmc->sp_cache_set = vmalloc((size_t)order);
+	if (dmc->sp_cache_set == NULL)
+		return -ENOMEM;
+
+	cache_sets = (struct eio_lru_cache_set *)dmc->sp_cache_set;
+
+	for (i = 0; i < (int)(dmc->size >> dmc->consecutive_shift); i++) {
+		cache_sets[i].lru_tail = EIO_LRU_NULL;
+		cache_sets[i].lru_head = EIO_LRU_NULL;
+	}
+	pr_info("Initialized %d sets in LRU", i);
+
+	return 0;
+}
+
+/*
+ * Initialize per block LRU data structures
+ */
+int eio_lru_cache_blk_init(struct eio_policy *p_ops)
+{
+	sector_t order;
+	struct cache_c *dmc = p_ops->sp_dmc;
+
+	order = dmc->size * sizeof(struct eio_lru_cache_block);
+
+	dmc->sp_cache_blk = vmalloc((size_t)order);
+	if (dmc->sp_cache_blk == NULL)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Allocate a new instance of eio_policy per dmc
+ */
+struct eio_policy *eio_lru_instance_init(void)
+{
+	struct eio_policy *new_instance;
+
+	new_instance = vmalloc(sizeof(struct eio_policy));
+	if (new_instance == NULL) {
+		pr_err("eio_lru_instance_init: vmalloc failed");
+		return NULL;
+	}
+
+	/* Initialize the LRU specific functions and variables */
+	new_instance->sp_name = CACHE_REPL_LRU;
+	new_instance->sp_policy.lru = &eio_lru;
+	new_instance->sp_repl_init = eio_lru_init;
+	new_instance->sp_repl_exit = eio_lru_exit;
+	new_instance->sp_repl_sets_init = eio_lru_cache_sets_init;
+	new_instance->sp_repl_blk_init = eio_lru_cache_blk_init;
+	new_instance->sp_find_reclaim_dbn = eio_lru_find_reclaim_dbn;
+	new_instance->sp_clean_set = eio_lru_clean_set;
+	new_instance->sp_dmc = NULL;
+
+	try_module_get(THIS_MODULE);
+
+	pr_info("eio_lru_instance_init: created new instance of LRU");
+
+	return new_instance;
+}
+
+/*
+ * Cleanup an instance of eio_policy (called from dtr).
+ */
+void eio_lru_exit(void)
+{
+	module_put(THIS_MODULE);
+}
+
+/*
+ * Find a victim block to evict and return it in index.
+ */
+void
+eio_lru_find_reclaim_dbn(struct eio_policy *p_ops,
+			 index_t start_index, index_t *index)
+{
+	index_t lru_rel_index;
+	struct eio_lru_cache_set *lru_sets;
+	struct eio_lru_cache_block *lru_blk;
+	struct cache_c *dmc = p_ops->sp_dmc;
+	index_t set;
+
+	set = start_index / dmc->assoc;
+	lru_sets = (struct eio_lru_cache_set *)(dmc->sp_cache_set);
+
+	lru_rel_index = lru_sets[set].lru_head;
+	while (lru_rel_index != EIO_LRU_NULL) {
+		lru_blk =
+			((struct eio_lru_cache_block *)dmc->sp_cache_blk +
+			 lru_rel_index + start_index);
+		if (EIO_CACHE_STATE_GET(dmc, (lru_rel_index + start_index)) ==
+		    VALID) {
+			EIO_ASSERT((lru_blk - (struct eio_lru_cache_block *)
+				    dmc->sp_cache_blk) ==
+				   (lru_rel_index + start_index));
+			*index = lru_rel_index + start_index;
+			eio_reclaim_lru_movetail(dmc, *index, p_ops);
+			break;
+		}
+		lru_rel_index = lru_blk->lru_next;
+	}
+
+	return;
+}
+
+/*
+ * Go through the entire set and clean.
+ */
+int eio_lru_clean_set(struct eio_policy *p_ops, index_t set, int to_clean)
+{
+	struct cache_c *dmc = p_ops->sp_dmc;
+	index_t lru_rel_index;
+	int nr_writes = 0;
+	struct eio_lru_cache_set *lru_cache_sets;
+	struct eio_lru_cache_block *lru_cacheblk;
+	index_t dmc_idx;
+	index_t start_index;
+
+	lru_cache_sets = (struct eio_lru_cache_set *)dmc->sp_cache_set;
+	start_index = set * dmc->assoc;
+	lru_rel_index = lru_cache_sets[set].lru_head;
+
+	while ((lru_rel_index != EIO_LRU_NULL) && (nr_writes < to_clean)) {
+		dmc_idx = lru_rel_index + start_index;
+		lru_cacheblk =
+			((struct eio_lru_cache_block *)dmc->sp_cache_blk +
+			 lru_rel_index + start_index);
+		EIO_ASSERT((lru_cacheblk -
+			    (struct eio_lru_cache_block *)dmc->sp_cache_blk) ==
+			   (lru_rel_index + start_index));
+		if ((EIO_CACHE_STATE_GET(dmc, dmc_idx) &
+		     (DIRTY | BLOCK_IO_INPROG)) == DIRTY) {
+			EIO_CACHE_STATE_ON(dmc, dmc_idx, DISKWRITEINPROG);
+			nr_writes++;
+		}
+		lru_rel_index = lru_cacheblk->lru_next;
+	}
+
+	return nr_writes;
+}
+
+/*
+ * LRU specific functions.
+ */
+void
+eio_reclaim_lru_movetail(struct cache_c *dmc, index_t index,
+			 struct eio_policy *p_ops)
+{
+	index_t set = index / dmc->assoc;
+	index_t start_index = set * dmc->assoc;
+	index_t my_index = index - start_index;
+	struct eio_lru_cache_block *cacheblk;
+	struct eio_lru_cache_set *cache_sets;
+	struct eio_lru_cache_block *blkptr;
+
+	cacheblk =
+		(((struct eio_lru_cache_block *)(dmc->sp_cache_blk)) + index);
+	cache_sets = (struct eio_lru_cache_set *)dmc->sp_cache_set;
+	blkptr = (struct eio_lru_cache_block *)(dmc->sp_cache_blk);
+
+	/* Remove from LRU */
+	if (likely((cacheblk->lru_prev != EIO_LRU_NULL) ||
+		   (cacheblk->lru_next != EIO_LRU_NULL))) {
+		if (cacheblk->lru_prev != EIO_LRU_NULL)
+			blkptr[cacheblk->lru_prev + start_index].lru_next =
+				cacheblk->lru_next;
+		else
+			cache_sets[set].lru_head = cacheblk->lru_next;
+		if (cacheblk->lru_next != EIO_LRU_NULL)
+			blkptr[cacheblk->lru_next + start_index].lru_prev =
+				cacheblk->lru_prev;
+		else
+			cache_sets[set].lru_tail = cacheblk->lru_prev;
+	}
+	/* And add it to LRU Tail */
+	cacheblk->lru_next = EIO_LRU_NULL;
+	cacheblk->lru_prev = cache_sets[set].lru_tail;
+	if (cache_sets[set].lru_tail == EIO_LRU_NULL)
+		cache_sets[set].lru_head = (u_int16_t)my_index;
+	else
+		blkptr[cache_sets[set].lru_tail + start_index].lru_next =
+			(u_int16_t)my_index;
+	cache_sets[set].lru_tail = (u_int16_t)my_index;
+}
+
+void eio_lru_pushblks(struct eio_policy *p_ops)
+{
+	struct cache_c *dmc = p_ops->sp_dmc;
+	struct eio_lru_cache_block *cache_block;
+	int i;
+
+	cache_block = dmc->sp_cache_blk;
+	for (i = 0; i < (int)dmc->size; i++) {
+		cache_block[i].lru_prev = EIO_LRU_NULL;
+		cache_block[i].lru_next = EIO_LRU_NULL;
+		eio_reclaim_lru_movetail(dmc, i, p_ops);
+	}
+	return;
+}
+
+static
+int __init lru_register(void)
+{
+	int ret;
+
+	ret = eio_register_policy(&eio_lru_ops);
+	if (ret != 0)
+		pr_info("eio_lru already registered");
+
+	return ret;
+}
+
+static
+void __exit lru_unregister(void)
+{
+	int ret;
+
+	ret = eio_unregister_policy(&eio_lru_ops);
+	if (ret != 0)
+		pr_err("eio_lru unregister failed");
+}
+
+module_init(lru_register);
+module_exit(lru_unregister);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LRU policy for EnhanceIO");
+MODULE_AUTHOR("sTec(R), Inc. based on code by Facebook");
diff --git a/drivers/block/enhanceio/eio_main.c b/drivers/block/enhanceio/eio_main.c
new file mode 100644
index 0000000..a85a3a0
--- /dev/null
+++ b/drivers/block/enhanceio/eio_main.c
@@ -0,0 +1,3546 @@
+/*
+ *  eio_main.c
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *  Amit Kale <akale@stec-inc.com>
+ *   Restructured much of the io code to split bio within map function instead
+ *   of letting dm do it.
+ *   Simplified queued logic for write through.
+ *   Created per-cache spinlocks for reducing contention in IO codepath.
+ *  Amit Kale <akale@stec-inc.com>
+ *  Harish Pujari <hpujari@stec-inc.com>
+ *   Designed and implemented the writeback caching mode
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+#include "eio_ttc.h"
+
+#define CTRACE(X) { }
+
+/*
+ * TODO List :
+ * 1) sysctls : Create per-cache device sysctls instead of global sysctls.
+ * 2) Management of non cache pids : Needs improvement. Remove registration
+ * on process exits (with  a pseudo filesstem'ish approach perhaps) ?
+ * 3) Breaking up the cache spinlock : Right now contention on the spinlock
+ * is not a problem. Might need change in future.
+ * 4) Use the standard linked list manipulation macros instead rolling our own.
+ * 5) Fix a security hole : A malicious process with 'ro' access to a file can
+ * potentially corrupt file data. This can be fixed by copying the data on a
+ * cache read miss.
+ */
+
+static int eio_read_peek(struct cache_c *dmc, struct eio_bio *ebio);
+static int eio_write_peek(struct cache_c *dmc, struct eio_bio *ebio);
+static void eio_read(struct cache_c *dmc, struct bio_container *bc,
+		     struct eio_bio *ebegin);
+static void eio_write(struct cache_c *dmc, struct bio_container *bc,
+		      struct eio_bio *ebegin);
+static int eio_inval_block(struct cache_c *dmc, sector_t iosector);
+static void eio_enqueue_readfill(struct cache_c *dmc, struct kcached_job *job);
+static int eio_acquire_set_locks(struct cache_c *dmc, struct bio_container *bc);
+static int eio_release_io_resources(struct cache_c *dmc,
+				    struct bio_container *bc);
+static void eio_clean_set(struct cache_c *dmc, index_t set, int whole,
+			  int force);
+static void eio_do_mdupdate(struct work_struct *work);
+static void eio_mdupdate_callback(int error, void *context);
+static void eio_enq_mdupdate(struct bio_container *bc);
+static void eio_uncached_read_done(struct kcached_job *job);
+static void eio_addto_cleanq(struct cache_c *dmc, index_t set, int whole);
+static int eio_alloc_mdreqs(struct cache_c *, struct bio_container *);
+static void eio_check_dirty_set_thresholds(struct cache_c *dmc, index_t set);
+static void eio_check_dirty_cache_thresholds(struct cache_c *dmc);
+static void eio_post_mdupdate(struct work_struct *work);
+static void eio_post_io_callback(struct work_struct *work);
+
+static void bc_addfb(struct bio_container *bc, struct eio_bio *ebio)
+{
+
+	atomic_inc(&bc->bc_holdcount);
+
+	ebio->eb_bc = bc;
+}
+
+static void bc_put(struct bio_container *bc, unsigned int doneio)
+{
+	struct cache_c *dmc;
+	int data_dir;
+	long elapsed;
+
+	if (atomic_dec_and_test(&bc->bc_holdcount)) {
+		if (bc->bc_dmc->mode == CACHE_MODE_WB)
+			eio_release_io_resources(bc->bc_dmc, bc);
+		bc->bc_bio->bi_size = 0;
+		dmc = bc->bc_dmc;
+
+		/* update iotime for latency */
+		data_dir = bio_data_dir(bc->bc_bio);
+		elapsed = (long)jiffies_to_msecs(jiffies - bc->bc_iotime);
+
+		if (data_dir == READ)
+			atomic64_add(elapsed, &dmc->eio_stats.rdtime_ms);
+		else
+			atomic64_add(elapsed, &dmc->eio_stats.wrtime_ms);
+
+		bio_endio(bc->bc_bio, bc->bc_error);
+		atomic64_dec(&bc->bc_dmc->nr_ios);
+		kfree(bc);
+	}
+}
+
+static void eb_endio(struct eio_bio *ebio, int error)
+{
+
+	EIO_ASSERT(ebio->eb_bc);
+
+	/*Propagate only main io errors and sizes*/
+	if (ebio->eb_iotype == EB_MAIN_IO) {
+		if (error)
+			ebio->eb_bc->bc_error = error;
+		bc_put(ebio->eb_bc, ebio->eb_size);
+	} else
+		bc_put(ebio->eb_bc, 0);
+	ebio->eb_bc = NULL;
+	kfree(ebio);
+}
+
+static int
+eio_io_async_bvec(struct cache_c *dmc, struct eio_io_region *where, int rw,
+		  struct bio_vec *pages, unsigned nr_bvecs, eio_notify_fn fn,
+		  void *context, int hddio)
+{
+	struct eio_io_request req;
+	int error = 0;
+
+	memset((char *)&req, 0, sizeof(req));
+
+	if (unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+		if (where->bdev != dmc->disk_dev->bdev) {
+			pr_err
+				("eio_io_async_bvec: Cache is in degraded mode.\n");
+			pr_err
+				("eio_io_async_Bvec: Can not issue i/o to ssd device.\n");
+			return -ENODEV;
+		}
+	}
+
+	req.mtype = EIO_BVECS;
+	req.dptr.pages = pages;
+	req.num_bvecs = nr_bvecs;
+	req.notify = fn;
+	req.context = context;
+	req.hddio = hddio;
+
+	error = eio_do_io(dmc, where, rw, &req);
+
+	return error;
+}
+
+static void
+eio_flag_abios(struct cache_c *dmc, struct eio_bio *abio, int invalidated)
+{
+	struct eio_bio *nbio;
+
+	while (abio) {
+		int invalidate;
+		unsigned long flags;
+		int cwip_on = 0;
+		int dirty_on = 0;
+		int callendio = 0;
+		nbio = abio->eb_next;
+
+		EIO_ASSERT(!(abio->eb_iotype & EB_INVAL) || abio->eb_index == -1);
+		invalidate = !invalidated && (abio->eb_iotype & EB_INVAL);
+
+		spin_lock_irqsave(&dmc->cache_sets[abio->eb_cacheset].cs_lock,
+				  flags);
+
+		if (abio->eb_index != -1) {
+			if (EIO_CACHE_STATE_GET(dmc, abio->eb_index) & DIRTY)
+				dirty_on = 1;
+
+			if (unlikely
+				    (EIO_CACHE_STATE_GET(dmc, abio->eb_index) &
+				    CACHEWRITEINPROG))
+				cwip_on = 1;
+		}
+
+		if (dirty_on) {
+			/*
+			 * For dirty blocks, we don't change the cache state flags.
+			 * We however, need to end the ebio, if this was the last
+			 * hold on it.
+			 */
+			if (atomic_dec_and_test(&abio->eb_holdcount)) {
+				callendio = 1;
+				/* We shouldn't reach here when the DIRTY_INPROG flag
+				 * is set on the cache block. It should either have been
+				 * cleared to become DIRTY or INVALID elsewhere.
+				 */
+				EIO_ASSERT(EIO_CACHE_STATE_GET(dmc, abio->eb_index)
+					   != DIRTY_INPROG);
+			}
+		} else if (abio->eb_index != -1) {
+			if (invalidate) {
+				if (cwip_on)
+					EIO_CACHE_STATE_ON(dmc, abio->eb_index,
+							   QUEUED);
+				else {
+					EIO_CACHE_STATE_SET(dmc, abio->eb_index,
+							    INVALID);
+					atomic64_dec_if_positive(&dmc->
+								 eio_stats.
+								 cached_blocks);
+				}
+			} else {
+				if (cwip_on)
+					EIO_CACHE_STATE_OFF(dmc, abio->eb_index,
+							    DISKWRITEINPROG);
+				else {
+					if (EIO_CACHE_STATE_GET
+						    (dmc, abio->eb_index) & QUEUED) {
+						EIO_CACHE_STATE_SET(dmc,
+								    abio->
+								    eb_index,
+								    INVALID);
+						atomic64_dec_if_positive(&dmc->
+									 eio_stats.
+									 cached_blocks);
+					} else {
+						EIO_CACHE_STATE_SET(dmc,
+								    abio->
+								    eb_index,
+								    VALID);
+					}
+				}
+			}
+		} else {
+			EIO_ASSERT(invalidated || invalidate);
+			if (invalidate)
+				eio_inval_block(dmc, abio->eb_sector);
+		}
+		spin_unlock_irqrestore(&dmc->cache_sets[abio->eb_cacheset].
+				       cs_lock, flags);
+		if (!cwip_on && (!dirty_on || callendio))
+			eb_endio(abio, 0);
+		abio = nbio;
+	}
+}
+
+static void eio_disk_io_callback(int error, void *context)
+{
+	struct kcached_job *job;
+	struct eio_bio *ebio;
+	struct cache_c *dmc;
+	unsigned long flags;
+	unsigned eb_cacheset;
+
+	flags = 0;
+	job = (struct kcached_job *)context;
+	dmc = job->dmc;
+	ebio = job->ebio;
+
+	EIO_ASSERT(ebio != NULL);
+	eb_cacheset = ebio->eb_cacheset;
+
+	if (unlikely(error))
+		dmc->eio_errors.disk_read_errors++;
+
+	spin_lock_irqsave(&dmc->cache_sets[eb_cacheset].cs_lock, flags);
+	/* Invalidate the cache block */
+	EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+	atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+	spin_unlock_irqrestore(&dmc->cache_sets[eb_cacheset].cs_lock, flags);
+
+	if (unlikely(error))
+		pr_err("disk_io_callback: io error %d block %llu action %d",
+		       error,
+		       (unsigned long long)job->job_io_regions.disk.sector,
+		       job->action);
+
+	eb_endio(ebio, error);
+	ebio = NULL;
+	job->ebio = NULL;
+	eio_free_cache_job(job);
+	job = NULL;
+}
+
+static void eio_uncached_read_done(struct kcached_job *job)
+{
+	struct eio_bio *ebio = job->ebio;
+	struct cache_c *dmc = job->dmc;
+	struct eio_bio *iebio;
+	struct eio_bio *nebio;
+	unsigned long flags = 0;
+
+	if (ebio->eb_bc->bc_dir == UNCACHED_READ) {
+		EIO_ASSERT(ebio != NULL);
+		iebio = ebio->eb_next;
+		while (iebio != NULL) {
+			nebio = iebio->eb_next;
+			if (iebio->eb_index != -1) {
+				spin_lock_irqsave(&dmc->
+						  cache_sets[iebio->
+							     eb_cacheset].
+						  cs_lock, flags);
+				if (unlikely
+					    (EIO_CACHE_STATE_GET(dmc, iebio->eb_index) &
+					    QUEUED)) {
+					EIO_CACHE_STATE_SET(dmc,
+							    iebio->eb_index,
+							    INVALID);
+					atomic64_dec_if_positive(&dmc->
+								 eio_stats.
+								 cached_blocks);
+				} else
+				if (EIO_CACHE_STATE_GET
+					    (dmc,
+					    iebio->eb_index) & CACHEREADINPROG) {
+					/*turn off the cache read in prog flag*/
+					EIO_CACHE_STATE_OFF(dmc,
+							    iebio->eb_index,
+							    BLOCK_IO_INPROG);
+				} else
+					/*Should never reach here*/
+					EIO_ASSERT(0);
+				spin_unlock_irqrestore(&dmc->
+						       cache_sets[iebio->
+								  eb_cacheset].
+						       cs_lock, flags);
+			}
+			eb_endio(iebio, 0);
+			iebio = nebio;
+		}
+		eb_endio(ebio, 0);
+		eio_free_cache_job(job);
+	} else if (ebio->eb_bc->bc_dir == UNCACHED_READ_AND_READFILL) {
+		/*
+		 * Kick off the READFILL. It will also do a read
+		 * from SSD, in case of ALREADY_DIRTY block
+		 */
+		job->action = READFILL;
+		eio_enqueue_readfill(dmc, job);
+	} else
+		/* Should never reach here for uncached read */
+		EIO_ASSERT(0);
+}
+
+static void eio_io_callback(int error, void *context)
+{
+	struct kcached_job *job = (struct kcached_job *)context;
+	struct cache_c *dmc = job->dmc;
+
+	job->error = error;
+	INIT_WORK(&job->work, eio_post_io_callback);
+	queue_work(dmc->callback_q, &job->work);
+	return;
+}
+
+static void eio_post_io_callback(struct work_struct *work)
+{
+	struct kcached_job *job;
+	struct cache_c *dmc;
+	struct eio_bio *ebio;
+	unsigned long flags = 0;
+	index_t index;
+	unsigned eb_cacheset;
+	u_int8_t cstate;
+	int callendio = 0;
+	int error;
+
+	job = container_of(work, struct kcached_job, work);
+	dmc = job->dmc;
+	index = job->index;
+	error = job->error;
+
+	EIO_ASSERT(index != -1 || job->action == WRITEDISK
+		   || job->action == READDISK);
+	ebio = job->ebio;
+	EIO_ASSERT(ebio != NULL);
+	EIO_ASSERT(ebio->eb_bc);
+
+	eb_cacheset = ebio->eb_cacheset;
+	if (error)
+		pr_err("io_callback: io error %d block %llu action %d",
+		       error,
+		       (unsigned long long)job->job_io_regions.disk.sector,
+		       job->action);
+
+	switch (job->action) {
+	case WRITEDISK:
+
+		atomic64_inc(&dmc->eio_stats.writedisk);
+		if (unlikely(error))
+			dmc->eio_errors.disk_write_errors++;
+		if (unlikely(error) || (ebio->eb_iotype & EB_INVAL))
+			eio_inval_range(dmc, ebio->eb_sector, ebio->eb_size);
+		if (ebio->eb_next)
+			eio_flag_abios(dmc, ebio->eb_next,
+				       error || (ebio->eb_iotype & EB_INVAL));
+		eb_endio(ebio, error);
+		job->ebio = NULL;
+		eio_free_cache_job(job);
+		return;
+
+	case READDISK:
+
+		if (unlikely(error) || unlikely(ebio->eb_iotype & EB_INVAL)
+		    || CACHE_DEGRADED_IS_SET(dmc)) {
+			if (error)
+				dmc->eio_errors.disk_read_errors++;
+			eio_inval_range(dmc, ebio->eb_sector, ebio->eb_size);
+			eio_flag_abios(dmc, ebio->eb_next, 1);
+		} else if (ebio->eb_next) {
+			eio_uncached_read_done(job);
+			return;
+		}
+		eb_endio(ebio, error);
+		job->ebio = NULL;
+		eio_free_cache_job(job);
+		return;
+
+	case READCACHE:
+
+		/*atomic64_inc(&dmc->eio_stats.readcache);*/
+		/*SECTOR_STATS(dmc->eio_stats.ssd_reads, ebio->eb_size);*/
+		EIO_ASSERT(EIO_DBN_GET(dmc, index) ==
+			   EIO_ROUND_SECTOR(dmc, ebio->eb_sector));
+		cstate = EIO_CACHE_STATE_GET(dmc, index);
+		/* We shouldn't reach here for DIRTY_INPROG blocks. */
+		EIO_ASSERT(cstate != DIRTY_INPROG);
+		if (unlikely(error)) {
+			dmc->eio_errors.ssd_read_errors++;
+			/* Retry read from HDD for non-DIRTY blocks. */
+			if (cstate != ALREADY_DIRTY) {
+				spin_lock_irqsave(&dmc->cache_sets[eb_cacheset].
+						  cs_lock, flags);
+				EIO_CACHE_STATE_OFF(dmc, ebio->eb_index,
+						    CACHEREADINPROG);
+				EIO_CACHE_STATE_ON(dmc, ebio->eb_index,
+						   DISKREADINPROG);
+				spin_unlock_irqrestore(&dmc->
+						       cache_sets[eb_cacheset].
+						       cs_lock, flags);
+
+				eio_push_ssdread_failures(job);
+				schedule_work(&_kcached_wq);
+
+				return;
+			}
+		}
+		callendio = 1;
+		break;
+
+	case READFILL:
+
+		/*atomic64_inc(&dmc->eio_stats.readfill);*/
+		/*SECTOR_STATS(dmc->eio_stats.ssd_writes, ebio->eb_size);*/
+		EIO_ASSERT(EIO_DBN_GET(dmc, index) == ebio->eb_sector);
+		if (unlikely(error))
+			dmc->eio_errors.ssd_write_errors++;
+		if (!(EIO_CACHE_STATE_GET(dmc, index) & CACHEWRITEINPROG)) {
+			pr_debug("DISKWRITEINPROG absent in READFILL \
+				sector %llu io size %u\n",
+				(unsigned long long)ebio->eb_sector,
+			       ebio->eb_size);
+		}
+		callendio = 1;
+		break;
+
+	case WRITECACHE:
+
+		/*SECTOR_STATS(dmc->eio_stats.ssd_writes, ebio->eb_size);*/
+		/*atomic64_inc(&dmc->eio_stats.writecache);*/
+		cstate = EIO_CACHE_STATE_GET(dmc, index);
+		EIO_ASSERT(EIO_DBN_GET(dmc, index) ==
+			   EIO_ROUND_SECTOR(dmc, ebio->eb_sector));
+		/* CWIP is a must for WRITECACHE, except when it is DIRTY */
+		EIO_ASSERT(cstate & (CACHEWRITEINPROG | DIRTY));
+		if (likely(error == 0)) {
+			/* If it is a DIRTY inprog block, proceed for metadata update */
+			if (cstate == DIRTY_INPROG) {
+				eio_md_write(job);
+				return;
+			}
+		} else {
+			/* TODO: ask if this if condition is required */
+			if (dmc->mode == CACHE_MODE_WT)
+				dmc->eio_errors.disk_write_errors++;
+			dmc->eio_errors.ssd_write_errors++;
+		}
+		job->ebio = NULL;
+		break;
+
+	default:
+		pr_err("io_callback: invalid action %d", job->action);
+		return;
+	}
+
+	spin_lock_irqsave(&dmc->cache_sets[eb_cacheset].cs_lock, flags);
+
+	cstate = EIO_CACHE_STATE_GET(dmc, index);
+	EIO_ASSERT(!(cstate & INVALID));
+
+	if (unlikely
+		    ((job->action == WRITECACHE) && !(cstate & DISKWRITEINPROG))) {
+		/*
+		 * Can reach here in 2 cases:
+		 * 1. Uncached write case, where WRITEDISK has finished first
+		 * 2. Cached write case
+		 *
+		 * For DIRTY or DIRTY inprog cases, use eb holdcount to determine
+		 * if end ebio can be called. This is because, we don't set DWIP etc
+		 * flags on those and we have to avoid double end ebio call
+		 */
+		EIO_ASSERT((cstate != DIRTY_INPROG) || error);
+		callendio = 1;
+		if ((cstate & DIRTY)
+		    && !atomic_dec_and_test(&ebio->eb_holdcount))
+			callendio = 0;
+	}
+
+	if (cstate & DISKWRITEINPROG) {
+		/* uncached write and WRITEDISK is not yet finished */
+		EIO_ASSERT(!(cstate & DIRTY));      /* For dirty blocks, we can't have DWIP flag */
+		if (error)
+			EIO_CACHE_STATE_ON(dmc, index, QUEUED);
+		EIO_CACHE_STATE_OFF(dmc, index, CACHEWRITEINPROG);
+	} else if (unlikely(error || (cstate & QUEUED))) {
+		/* Error or QUEUED is set: mark block as INVALID for non-DIRTY blocks */
+		if (cstate != ALREADY_DIRTY) {
+			EIO_CACHE_STATE_SET(dmc, index, INVALID);
+			atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+		}
+	} else if (cstate & VALID) {
+		EIO_CACHE_STATE_OFF(dmc, index, BLOCK_IO_INPROG);
+		/*
+		 * If we have NO_SSD_IO_INPROG flag set, then this block needs to be
+		 * invalidated. There are three things that can happen -- (i) error,
+		 * (ii) IOs are queued on this block, and (iii) success.
+		 *
+		 * If there was an error or if the QUEUED bit was set, then the logic
+		 * in the if part will take care of setting the block to INVALID.
+		 * Therefore, this is the success path where we invalidate if need be.
+		 */
+
+		/*
+		 * TBD
+		 * NO_SSD_IO_INPROG need to be differently handled, in case block is DIRTY
+		 */
+		if ((cstate & NO_SSD_IO_INPROG) == NO_SSD_IO_INPROG)
+			EIO_CACHE_STATE_OFF(dmc, index, VALID);
+	}
+
+	spin_unlock_irqrestore(&dmc->cache_sets[eb_cacheset].cs_lock, flags);
+
+	if (callendio)
+		eb_endio(ebio, error);
+
+	eio_free_cache_job(job);
+	job = NULL;
+
+}
+
+/*
+ * This function processes the kcached_job that
+ * needs to be scheduled on disk after ssd read failures.
+ */
+void eio_ssderror_diskread(struct kcached_job *job)
+{
+	struct cache_c *dmc;
+	struct eio_bio *ebio;
+	index_t index;
+	int error;
+	unsigned long flags = 0;
+
+	dmc = job->dmc;
+	error = 0;
+
+	/*
+	 * 1. Extract the ebio which needs to be scheduled on disk.
+	 * 2. Verify cache block state is VALID
+	 * 3. Make sure that the cache state in not IOINPROG
+	 */
+	/* Reset the ssd read error in the job. */
+	job->error = 0;
+	ebio = job->ebio;
+	index = ebio->eb_index;
+
+	EIO_ASSERT(index != -1);
+
+	spin_lock_irqsave(&dmc->cache_sets[index / dmc->assoc].cs_lock, flags);
+	EIO_ASSERT(EIO_CACHE_STATE_GET(dmc, index) & DISKREADINPROG);
+	spin_unlock_irqrestore(&dmc->cache_sets[index / dmc->assoc].cs_lock,
+			       flags);
+
+	EIO_ASSERT(ebio->eb_dir == READ);
+
+	atomic64_inc(&dmc->eio_stats.readdisk);
+	SECTOR_STATS(dmc->eio_stats.disk_reads, ebio->eb_size);
+	job->action = READDISK;
+
+	error = eio_io_async_bvec(dmc, &job->job_io_regions.disk, ebio->eb_dir,
+				  ebio->eb_bv, ebio->eb_nbvec,
+				  eio_disk_io_callback, job, 1);
+
+	/*
+	 * In case of disk i/o submission error clear ebio and kcached_job.
+	 * This would return the actual read that was issued on ssd.
+	 */
+	if (error)
+		goto out;
+
+	return;
+
+out:
+	/* We failed to submit the I/O to dm layer. The corresponding
+	 * block should be marked as INVALID by turning off already set
+	 * flags.
+	 */
+	spin_lock_irqsave(&dmc->cache_sets[index / dmc->assoc].cs_lock, flags);
+	EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+	spin_unlock_irqrestore(&dmc->cache_sets[index / dmc->assoc].cs_lock,
+			       flags);
+
+	atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+
+	eb_endio(ebio, error);
+	ebio = NULL;
+	job->ebio = NULL;
+	eio_free_cache_job(job);
+}
+
+/* Adds clean set request to clean queue. */
+static void eio_addto_cleanq(struct cache_c *dmc, index_t set, int whole)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&dmc->cache_sets[set].cs_lock, flags);
+
+	if (dmc->cache_sets[set].flags & SETFLAG_CLEAN_INPROG) {
+		/* Clean already in progress, just add to clean pendings */
+		spin_unlock_irqrestore(&dmc->cache_sets[set].cs_lock, flags);
+		return;
+	}
+
+	dmc->cache_sets[set].flags |= SETFLAG_CLEAN_INPROG;
+	if (whole)
+		dmc->cache_sets[set].flags |= SETFLAG_CLEAN_WHOLE;
+
+	spin_unlock_irqrestore(&dmc->cache_sets[set].cs_lock, flags);
+
+	spin_lock_irqsave(&dmc->clean_sl, flags);
+	list_add_tail(&dmc->cache_sets[set].list, &dmc->cleanq);
+	atomic64_inc(&dmc->clean_pendings);
+	EIO_SET_EVENT_AND_UNLOCK(&dmc->clean_event, &dmc->clean_sl, flags);
+	return;
+}
+
+/*
+ * Clean thread loops forever in this, waiting for
+ * new clean set requests in the clean queue.
+ */
+int eio_clean_thread_proc(void *context)
+{
+	struct cache_c *dmc = (struct cache_c *)context;
+	unsigned long flags = 0;
+	u_int64_t systime;
+	index_t index;
+
+	/* Sync makes sense only for writeback cache */
+	EIO_ASSERT(dmc->mode == CACHE_MODE_WB);
+
+	dmc->clean_thread_running = 1;
+
+	/*
+	 * Using sysctl_fast_remove to stop the clean thread
+	 * works for now. Should have another flag specifically
+	 * for such notification.
+	 */
+	for (; !dmc->sysctl_active.fast_remove; ) {
+		LIST_HEAD(setlist);
+		struct cache_set *set;
+
+		eio_comply_dirty_thresholds(dmc, -1);
+
+		if (dmc->sysctl_active.do_clean) {
+			/* pause the periodic clean */
+			cancel_delayed_work_sync(&dmc->clean_aged_sets_work);
+
+			/* clean all the sets */
+			eio_clean_all(dmc);
+
+			/* resume the periodic clean */
+			spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+			dmc->is_clean_aged_sets_sched = 0;
+			if (dmc->sysctl_active.time_based_clean_interval
+			    && atomic64_read(&dmc->nr_dirty)) {
+				/* there is a potential race here, If a sysctl changes
+				   the time_based_clean_interval to 0. However a strong
+				   synchronisation is not necessary here
+				 */
+				schedule_delayed_work(&dmc->
+						      clean_aged_sets_work,
+						      dmc->sysctl_active.
+						      time_based_clean_interval
+						      * 60 * HZ);
+				dmc->is_clean_aged_sets_sched = 1;
+			}
+			spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+		}
+
+		if (dmc->sysctl_active.fast_remove)
+			break;
+
+		spin_lock_irqsave(&dmc->clean_sl, flags);
+
+		while (!
+		       ((!list_empty(&dmc->cleanq))
+			|| dmc->sysctl_active.fast_remove
+			|| dmc->sysctl_active.do_clean))
+			EIO_WAIT_EVENT(&dmc->clean_event, &dmc->clean_sl,
+				       flags);
+
+		/*
+		 * Move cleanq elements to a private list for processing.
+		 */
+
+		list_add(&setlist, &dmc->cleanq);
+		list_del(&dmc->cleanq);
+		INIT_LIST_HEAD(&dmc->cleanq);
+
+		spin_unlock_irqrestore(&dmc->clean_sl, flags);
+
+		systime = jiffies;
+		while (!list_empty(&setlist)) {
+			set =
+				list_entry((&setlist)->next, struct cache_set,
+					   list);
+			list_del(&set->list);
+			index = set - dmc->cache_sets;
+			if (!(dmc->sysctl_active.fast_remove)) {
+				eio_clean_set(dmc, index,
+					      set->flags & SETFLAG_CLEAN_WHOLE,
+					      0);
+			} else {
+
+				/*
+				 * Since we are not cleaning the set, we should
+				 * put the set back in the lru list so that
+				 * it is picked up at a later point.
+				 * We also need to clear the clean inprog flag
+				 * otherwise this set would never be cleaned.
+				 */
+
+				spin_lock_irqsave(&dmc->cache_sets[index].
+						  cs_lock, flags);
+				dmc->cache_sets[index].flags &=
+					~(SETFLAG_CLEAN_INPROG |
+					  SETFLAG_CLEAN_WHOLE);
+				spin_unlock_irqrestore(&dmc->cache_sets[index].
+						       cs_lock, flags);
+				spin_lock_irqsave(&dmc->dirty_set_lru_lock,
+						  flags);
+				lru_touch(dmc->dirty_set_lru, index, systime);
+				spin_unlock_irqrestore(&dmc->dirty_set_lru_lock,
+						       flags);
+			}
+			atomic64_dec(&dmc->clean_pendings);
+		}
+	}
+
+	/* notifier for cache delete that the clean thread has stopped running */
+	dmc->clean_thread_running = 0;
+
+	eio_thread_exit(0);
+
+	/*Should never reach here*/
+	return 0;
+}
+
+/*
+ * Cache miss support. We read the data from disk, write it to the ssd.
+ * To avoid doing 1 IO at a time to the ssd, when the IO is kicked off,
+ * we enqueue it to a "readfill" queue in the cache in cache sector order.
+ * The worker thread can then issue all of these IOs and do 1 unplug to
+ * start them all.
+ *
+ */
+static void eio_enqueue_readfill(struct cache_c *dmc, struct kcached_job *job)
+{
+	unsigned long flags = 0;
+	struct kcached_job **j1, *next;
+	int do_schedule = 0;
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+	/* Insert job in sorted order of cache sector */
+	j1 = &dmc->readfill_queue;
+	while (*j1 != NULL && (*j1)->job_io_regions.cache.sector <
+	       job->job_io_regions.cache.sector)
+		j1 = &(*j1)->next;
+	next = *j1;
+	*j1 = job;
+	job->next = next;
+	do_schedule = (dmc->readfill_in_prog == 0);
+	spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	if (do_schedule)
+		schedule_work(&dmc->readfill_wq);
+}
+
+void eio_do_readfill(struct work_struct *work)
+{
+	struct kcached_job *job, *joblist;
+	struct eio_bio *ebio;
+	unsigned long flags = 0;
+	struct kcached_job *nextjob = NULL;
+	struct cache_c *dmc = container_of(work, struct cache_c, readfill_wq);
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+	if (dmc->readfill_in_prog)
+		goto out;
+	dmc->readfill_in_prog = 1;
+	while (dmc->readfill_queue != NULL) {
+		joblist = dmc->readfill_queue;
+		dmc->readfill_queue = NULL;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+		for (job = joblist; job != NULL; job = nextjob) {
+			struct eio_bio *iebio;
+			struct eio_bio *next;
+
+			nextjob = job->next;    /* save for later because 'job' will be freed */
+			EIO_ASSERT(job->action == READFILL);
+			/* Write to cache device */
+			ebio = job->ebio;
+			iebio = ebio->eb_next;
+			EIO_ASSERT(iebio);
+			/* other iebios are anchored on this bio. Create
+			 * jobs for them and then issue ios
+			 */
+			do {
+				struct kcached_job *job;
+				int err;
+				unsigned long flags;
+				index_t index;
+				next = iebio->eb_next;
+				index = iebio->eb_index;
+				if (index == -1) {
+					CTRACE("eio_do_readfill:1\n");
+					/* Any INPROG(including DIRTY_INPROG) case would fall here */
+					eb_endio(iebio, 0);
+					iebio = NULL;
+				} else {
+					spin_lock_irqsave(&dmc->
+							  cache_sets[iebio->
+								     eb_cacheset].
+							  cs_lock, flags);
+					/* If this block was already  valid, we don't need to write it */
+					if (unlikely
+						    (EIO_CACHE_STATE_GET(dmc, index) &
+						    QUEUED)) {
+						/*An invalidation request is queued. Can't do anything*/
+						CTRACE("eio_do_readfill:2\n");
+						EIO_CACHE_STATE_SET(dmc, index,
+								    INVALID);
+						spin_unlock_irqrestore(&dmc->
+								       cache_sets
+								       [iebio->
+									eb_cacheset].
+								       cs_lock,
+								       flags);
+						atomic64_dec_if_positive(&dmc->
+									 eio_stats.
+									 cached_blocks);
+						eb_endio(iebio, 0);
+						iebio = NULL;
+					} else
+					if ((EIO_CACHE_STATE_GET(dmc, index)
+					     & (VALID | DISKREADINPROG))
+					    == (VALID | DISKREADINPROG)) {
+						/* Do readfill. */
+						EIO_CACHE_STATE_SET(dmc, index,
+								    VALID |
+								    CACHEWRITEINPROG);
+						EIO_ASSERT(EIO_DBN_GET(dmc, index)
+							   == iebio->eb_sector);
+						spin_unlock_irqrestore(&dmc->
+								       cache_sets
+								       [iebio->
+									eb_cacheset].
+								       cs_lock,
+								       flags);
+						job =
+							eio_new_job(dmc, iebio,
+								    iebio->
+								    eb_index);
+						if (unlikely(job == NULL))
+							err = -ENOMEM;
+						else {
+							err = 0;
+							job->action = READFILL;
+							atomic_inc(&dmc->
+								   nr_jobs);
+							SECTOR_STATS(dmc->
+								     eio_stats.
+								     ssd_readfills,
+								     iebio->
+								     eb_size);
+							SECTOR_STATS(dmc->
+								     eio_stats.
+								     ssd_writes,
+								     iebio->
+								     eb_size);
+							atomic64_inc(&dmc->
+								     eio_stats.
+								     readfill);
+							atomic64_inc(&dmc->
+								     eio_stats.
+								     writecache);
+							err =
+								eio_io_async_bvec
+									(dmc,
+									&job->
+									job_io_regions.
+									cache, WRITE,
+									iebio->eb_bv,
+									iebio->eb_nbvec,
+									eio_io_callback,
+									job, 0);
+						}
+						if (err) {
+							pr_err
+								("eio_do_readfill: IO submission failed, block %llu",
+								EIO_DBN_GET(dmc,
+									    index));
+							spin_lock_irqsave(&dmc->
+									  cache_sets
+									  [iebio->
+									   eb_cacheset].
+									  cs_lock,
+									  flags);
+							EIO_CACHE_STATE_SET(dmc,
+									    iebio->
+									    eb_index,
+									    INVALID);
+							spin_unlock_irqrestore
+								(&dmc->
+								cache_sets[iebio->
+									   eb_cacheset].
+								cs_lock, flags);
+							atomic64_dec_if_positive
+								(&dmc->eio_stats.
+								cached_blocks);
+							eb_endio(iebio, err);
+
+							if (job) {
+								eio_free_cache_job
+									(job);
+								job = NULL;
+							}
+						}
+					} else
+					if (EIO_CACHE_STATE_GET(dmc, index)
+					    == ALREADY_DIRTY) {
+
+						spin_unlock_irqrestore(&dmc->
+								       cache_sets
+								       [iebio->
+									eb_cacheset].
+								       cs_lock,
+								       flags);
+
+						/*
+						 * DIRTY block handling:
+						 * Read the dirty data from the cache block to update
+						 * the data buffer already read from the disk
+						 */
+						job =
+							eio_new_job(dmc, iebio,
+								    iebio->
+								    eb_index);
+						if (unlikely(job == NULL))
+							err = -ENOMEM;
+						else {
+							job->action = READCACHE;
+							SECTOR_STATS(dmc->
+								     eio_stats.
+								     ssd_reads,
+								     iebio->
+								     eb_size);
+							atomic64_inc(&dmc->
+								     eio_stats.
+								     readcache);
+							err =
+								eio_io_async_bvec
+									(dmc,
+									&job->
+									job_io_regions.
+									cache, READ,
+									iebio->eb_bv,
+									iebio->eb_nbvec,
+									eio_io_callback,
+									job, 0);
+						}
+
+						if (err) {
+							pr_err
+								("eio_do_readfill: dirty block read IO submission failed, block %llu",
+								EIO_DBN_GET(dmc,
+									    index));
+							/* can't invalidate the DIRTY block, just return error */
+							eb_endio(iebio, err);
+							if (job) {
+								eio_free_cache_job
+									(job);
+								job = NULL;
+							}
+						}
+					} else
+					if ((EIO_CACHE_STATE_GET(dmc, index)
+					     & (VALID | CACHEREADINPROG))
+					    == (VALID | CACHEREADINPROG)) {
+						/*turn off the cache read in prog flag
+						   don't need to write the cache block*/
+						CTRACE("eio_do_readfill:3\n");
+						EIO_CACHE_STATE_OFF(dmc, index,
+								    BLOCK_IO_INPROG);
+						spin_unlock_irqrestore(&dmc->
+								       cache_sets
+								       [iebio->
+									eb_cacheset].
+								       cs_lock,
+								       flags);
+						eb_endio(iebio, 0);
+						iebio = NULL;
+					} else {
+						panic("Unknown condition");
+						spin_unlock_irqrestore(&dmc->
+								       cache_sets
+								       [iebio->
+									eb_cacheset].
+								       cs_lock,
+								       flags);
+					}
+				}
+				iebio = next;
+			} while (iebio);
+			eb_endio(ebio, 0);
+			ebio = NULL;
+			eio_free_cache_job(job);
+		}
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+	}
+	dmc->readfill_in_prog = 0;
+out:
+	spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	atomic64_inc(&dmc->eio_stats.ssd_readfill_unplugs);
+	eio_unplug_cache_device(dmc);
+}
+
+/*
+ * Map a block from the source device to a block in the cache device.
+ */
+static u_int32_t hash_block(struct cache_c *dmc, sector_t dbn)
+{
+	u_int32_t set_number;
+
+	set_number = eio_hash_block(dmc, dbn);
+	return set_number;
+}
+
+static void
+find_valid_dbn(struct cache_c *dmc, sector_t dbn,
+	       index_t start_index, index_t *index)
+{
+	index_t i;
+	index_t end_index = start_index + dmc->assoc;
+
+	for (i = start_index; i < end_index; i++) {
+		if ((EIO_CACHE_STATE_GET(dmc, i) & VALID)
+		    && EIO_DBN_GET(dmc, i) == dbn) {
+			*index = i;
+			if ((EIO_CACHE_STATE_GET(dmc, i) & BLOCK_IO_INPROG) ==
+			    0)
+				eio_policy_reclaim_lru_movetail(dmc, i,
+								dmc->
+								policy_ops);
+			return;
+		}
+	}
+	*index = -1;
+}
+
+static index_t find_invalid_dbn(struct cache_c *dmc, index_t start_index)
+{
+	index_t i;
+	index_t end_index = start_index + dmc->assoc;
+
+	/* Find INVALID slot that we can reuse */
+	for (i = start_index; i < end_index; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, i) == INVALID) {
+			eio_policy_reclaim_lru_movetail(dmc, i,
+							dmc->policy_ops);
+			return i;
+		}
+	}
+	return -1;
+}
+
+/* Search for a slot that we can reclaim */
+static void
+find_reclaim_dbn(struct cache_c *dmc, index_t start_index, index_t *index)
+{
+	eio_find_reclaim_dbn(dmc->policy_ops, start_index, index);
+}
+
+void eio_set_warm_boot(void)
+{
+	eio_force_warm_boot = 1;
+	return;
+}
+
+/*
+ * dbn is the starting sector.
+ */
+static int
+eio_lookup(struct cache_c *dmc, struct eio_bio *ebio, index_t *index)
+{
+	sector_t dbn = EIO_ROUND_SECTOR(dmc, ebio->eb_sector);
+	u_int32_t set_number;
+	index_t invalid, oldest_clean = -1;
+	index_t start_index;
+
+	/*ASK it is assumed that the lookup is being done for a single block*/
+	set_number = hash_block(dmc, dbn);
+	start_index = dmc->assoc * set_number;
+	find_valid_dbn(dmc, dbn, start_index, index);
+	if (*index >= 0)
+		/* We found the exact range of blocks we are looking for */
+		return VALID;
+
+	invalid = find_invalid_dbn(dmc, start_index);
+	if (invalid == -1)
+		/* We didn't find an invalid entry, search for oldest valid entry */
+		find_reclaim_dbn(dmc, start_index, &oldest_clean);
+	/*
+	 * Cache miss :
+	 * We can't choose an entry marked INPROG, but choose the oldest
+	 * INVALID or the oldest VALID entry.
+	 */
+	*index = start_index + dmc->assoc;
+	if (invalid != -1) {
+		*index = invalid;
+		return INVALID;
+	} else if (oldest_clean != -1) {
+		*index = oldest_clean;
+		return VALID;
+	}
+	return -1;
+}
+
+/* Do metadata update for a set */
+static void eio_do_mdupdate(struct work_struct *work)
+{
+	struct mdupdate_request *mdreq;
+	struct cache_set *set;
+	struct cache_c *dmc;
+	unsigned long flags;
+	index_t i;
+	index_t start_index;
+	index_t end_index;
+	index_t min_index;
+	index_t max_index;
+	struct flash_cacheblock *md_blocks;
+	struct eio_bio *ebio;
+	u_int8_t cstate;
+	struct eio_io_region region;
+	unsigned pindex;
+	int error, j;
+	index_t blk_index;
+	int k;
+	void *pg_virt_addr[2] = { NULL };
+	u_int8_t sector_bits[2] = { 0 };
+	int startbit, endbit;
+	int rw_flags = 0;
+
+	mdreq = container_of(work, struct mdupdate_request, work);
+	dmc = mdreq->dmc;
+	set = &dmc->cache_sets[mdreq->set];
+
+	mdreq->error = 0;
+	EIO_ASSERT(mdreq->mdblk_bvecs);
+
+	/*
+	 * md_size = dmc->assoc * sizeof(struct flash_cacheblock);
+	 * Currently, md_size is 8192 bytes, mdpage_count is 2 pages maximum.
+	 */
+
+	EIO_ASSERT(mdreq->mdbvec_count && mdreq->mdbvec_count <= 2);
+	EIO_ASSERT((dmc->assoc == 512) || mdreq->mdbvec_count == 1);
+	for (k = 0; k < (int)mdreq->mdbvec_count; k++)
+		pg_virt_addr[k] = kmap(mdreq->mdblk_bvecs[k].bv_page);
+
+	spin_lock_irqsave(&set->cs_lock, flags);
+
+	start_index = mdreq->set * dmc->assoc;
+	end_index = start_index + dmc->assoc;
+
+	pindex = 0;
+	md_blocks = (struct flash_cacheblock *)pg_virt_addr[pindex];
+	j = MD_BLOCKS_PER_PAGE;
+
+	/* initialize the md blocks to write */
+	for (i = start_index; i < end_index; i++) {
+		cstate = EIO_CACHE_STATE_GET(dmc, i);
+		md_blocks->dbn = cpu_to_le64(EIO_DBN_GET(dmc, i));
+		if (cstate == ALREADY_DIRTY)
+			md_blocks->cache_state = cpu_to_le64((VALID | DIRTY));
+		else
+			md_blocks->cache_state = cpu_to_le64(INVALID);
+		md_blocks++;
+		j--;
+
+		if ((j == 0) && (++pindex < mdreq->mdbvec_count)) {
+			md_blocks =
+				(struct flash_cacheblock *)pg_virt_addr[pindex];
+			j = MD_BLOCKS_PER_PAGE;
+		}
+
+	}
+
+	/* Update the md blocks with the pending mdlist */
+	min_index = start_index;
+	max_index = start_index;
+
+	pindex = 0;
+	md_blocks = (struct flash_cacheblock *)pg_virt_addr[pindex];
+
+	ebio = mdreq->pending_mdlist;
+	while (ebio) {
+		EIO_ASSERT(EIO_CACHE_STATE_GET(dmc, ebio->eb_index) ==
+			   DIRTY_INPROG);
+
+		blk_index = ebio->eb_index - start_index;
+		pindex = INDEX_TO_MD_PAGE(blk_index);
+		blk_index = INDEX_TO_MD_PAGE_OFFSET(blk_index);
+		sector_bits[pindex] |= (1 << INDEX_TO_MD_SECTOR(blk_index));
+
+		md_blocks = (struct flash_cacheblock *)pg_virt_addr[pindex];
+		md_blocks[blk_index].cache_state = (VALID | DIRTY);
+
+		if (min_index > ebio->eb_index)
+			min_index = ebio->eb_index;
+
+		if (max_index < ebio->eb_index)
+			max_index = ebio->eb_index;
+
+		ebio = ebio->eb_next;
+	}
+
+	/*
+	 * Below code may be required when selective pages need to be
+	 * submitted for metadata update. Currently avoiding the optimization
+	 * for correctness validation.
+	 */
+
+	/*
+	   min_cboff = (min_index - start_index) / MD_BLOCKS_PER_CBLOCK(dmc);
+	   max_cboff = (max_index - start_index) / MD_BLOCKS_PER_CBLOCK(dmc);
+	   write_size = ((uint32_t)(max_cboff - min_cboff + 1)) << dmc->block_shift;
+	   EIO_ASSERT(write_size && (write_size <= eio_to_sector(mdreq->md_size)));
+	 */
+
+	/* Move the pending mdlist to inprog list */
+	mdreq->inprog_mdlist = mdreq->pending_mdlist;
+	mdreq->pending_mdlist = NULL;
+
+	spin_unlock_irqrestore(&set->cs_lock, flags);
+
+	for (k = 0; k < (int)mdreq->mdbvec_count; k++)
+		kunmap(mdreq->mdblk_bvecs[k].bv_page);
+
+	/*
+	 * Initiate the I/O to SSD for on-disk md update.
+	 * TBD. Optimize to write only the affected blocks
+	 */
+
+	region.bdev = dmc->cache_dev->bdev;
+	/*region.sector = dmc->md_start_sect + INDEX_TO_MD_SECTOR(start_index) +
+	   (min_cboff << dmc->block_shift); */
+
+	atomic_set(&mdreq->holdcount, 1);
+	for (i = 0; i < mdreq->mdbvec_count; i++) {
+		if (!sector_bits[i])
+			continue;
+		startbit = -1;
+		j = 0;
+		while (startbit == -1) {
+			if (sector_bits[i] & (1 << j))
+				startbit = j;
+			j++;
+		}
+		endbit = -1;
+		j = 7;
+		while (endbit == -1) {
+			if (sector_bits[i] & (1 << j))
+				endbit = j;
+			j--;
+		}
+		EIO_ASSERT(startbit <= endbit && startbit >= 0 && startbit <= 7 &&
+			   endbit >= 0 && endbit <= 7);
+		EIO_ASSERT(dmc->assoc != 128 || endbit <= 3);
+		region.sector =
+			dmc->md_start_sect + INDEX_TO_MD_SECTOR(start_index) +
+			i * SECTORS_PER_PAGE + startbit;
+		region.count = endbit - startbit + 1;
+		mdreq->mdblk_bvecs[i].bv_offset = to_bytes(startbit);
+		mdreq->mdblk_bvecs[i].bv_len = to_bytes(region.count);
+
+		EIO_ASSERT(region.sector <=
+			   (dmc->md_start_sect + INDEX_TO_MD_SECTOR(end_index)));
+		atomic64_inc(&dmc->eio_stats.md_ssd_writes);
+		SECTOR_STATS(dmc->eio_stats.ssd_writes, to_bytes(region.count));
+		atomic_inc(&mdreq->holdcount);
+
+		/*
+		 * Set SYNC for making metadata
+		 * writes as high priority.
+		 */
+		rw_flags = WRITE | REQ_SYNC;
+		error = eio_io_async_bvec(dmc, &region, rw_flags,
+					  &mdreq->mdblk_bvecs[i], 1,
+					  eio_mdupdate_callback, work, 0);
+		if (error && !(mdreq->error))
+			mdreq->error = error;
+	}
+	if (atomic_dec_and_test(&mdreq->holdcount)) {
+		INIT_WORK(&mdreq->work, eio_post_mdupdate);
+		queue_work(dmc->mdupdate_q, &mdreq->work);
+	}
+}
+
+/* Callback function for ondisk metadata update */
+static void eio_mdupdate_callback(int error, void *context)
+{
+	struct work_struct *work = (struct work_struct *)context;
+	struct mdupdate_request *mdreq;
+
+	mdreq = container_of(work, struct mdupdate_request, work);
+	if (error && !(mdreq->error))
+		mdreq->error = error;
+	if (!atomic_dec_and_test(&mdreq->holdcount))
+		return;
+	INIT_WORK(&mdreq->work, eio_post_mdupdate);
+	queue_work(mdreq->dmc->mdupdate_q, &mdreq->work);
+}
+
+static void eio_post_mdupdate(struct work_struct *work)
+{
+	struct mdupdate_request *mdreq;
+	struct cache_set *set;
+	struct cache_c *dmc;
+	unsigned long flags;
+	struct eio_bio *ebio;
+	struct eio_bio *nebio;
+	int more_pending_mdupdates = 0;
+	int error;
+	index_t set_index;
+
+	mdreq = container_of(work, struct mdupdate_request, work);
+
+	dmc = mdreq->dmc;
+	EIO_ASSERT(dmc);
+	set_index = mdreq->set;
+	set = &dmc->cache_sets[set_index];
+	error = mdreq->error;
+
+	/* Update in-core cache metadata */
+
+	spin_lock_irqsave(&set->cs_lock, flags);
+
+	/*
+	 * Update dirty inprog blocks.
+	 * On error, convert them to INVALID
+	 * On success, convert them to ALREADY_DIRTY
+	 */
+	ebio = mdreq->inprog_mdlist;
+	while (ebio) {
+		EIO_ASSERT(EIO_CACHE_STATE_GET(dmc, ebio->eb_index) ==
+			   DIRTY_INPROG);
+		if (unlikely(error)) {
+			EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+			atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+		} else {
+			EIO_CACHE_STATE_SET(dmc, ebio->eb_index, ALREADY_DIRTY);
+			set->nr_dirty++;
+			atomic64_inc(&dmc->nr_dirty);
+			atomic64_inc(&dmc->eio_stats.md_write_dirty);
+		}
+		ebio = ebio->eb_next;
+	}
+
+	/*
+	 * If there are more pending requests for md update,
+	 * need to pick up those using the current mdreq.
+	 */
+	if (mdreq->pending_mdlist)
+		more_pending_mdupdates = 1;
+	else
+		/* No request pending, we can free the mdreq */
+		set->mdreq = NULL;
+
+	/*
+	 * After we unlock the set, we need to end the I/Os,
+	 * which were processed as part of this md update
+	 */
+
+	ebio = mdreq->inprog_mdlist;
+	mdreq->inprog_mdlist = NULL;
+
+	spin_unlock_irqrestore(&set->cs_lock, flags);
+
+	/* End the processed I/Os */
+	while (ebio) {
+		nebio = ebio->eb_next;
+		eb_endio(ebio, error);
+		ebio = nebio;
+	}
+
+	/*
+	 * if dirty block was added
+	 * 1. update the cache set lru list
+	 * 2. check and initiate cleaning if thresholds are crossed
+	 */
+	if (!error) {
+		eio_touch_set_lru(dmc, set_index);
+		eio_comply_dirty_thresholds(dmc, set_index);
+	}
+
+	if (more_pending_mdupdates) {
+		/*
+		 * Schedule work to process the new
+		 * pending mdupdate requests
+		 */
+		INIT_WORK(&mdreq->work, eio_do_mdupdate);
+		queue_work(dmc->mdupdate_q, &mdreq->work);
+	} else {
+		/*
+		 * No more pending mdupdates.
+		 * Free the mdreq.
+		 */
+		if (mdreq->mdblk_bvecs) {
+			eio_free_wb_bvecs(mdreq->mdblk_bvecs,
+					  mdreq->mdbvec_count,
+					  SECTORS_PER_PAGE);
+			kfree(mdreq->mdblk_bvecs);
+		}
+
+		kfree(mdreq);
+	}
+}
+
+/* Enqueue metadata update for marking dirty blocks on-disk/in-core */
+static void eio_enq_mdupdate(struct bio_container *bc)
+{
+	unsigned long flags = 0;
+	index_t set_index;
+	struct eio_bio *ebio;
+	struct cache_c *dmc = bc->bc_dmc;
+	struct cache_set *set = NULL;
+	struct mdupdate_request *mdreq;
+	int do_schedule;
+
+	ebio = bc->bc_mdlist;
+	set_index = -1;
+	do_schedule = 0;
+	while (ebio) {
+		if (ebio->eb_cacheset != set_index) {
+			set_index = ebio->eb_cacheset;
+			set = &dmc->cache_sets[set_index];
+			spin_lock_irqsave(&set->cs_lock, flags);
+		}
+		EIO_ASSERT(ebio->eb_cacheset == set_index);
+
+		bc->bc_mdlist = ebio->eb_next;
+
+		if (!set->mdreq) {
+			/* Pick up one mdreq from bc */
+			mdreq = bc->mdreqs;
+			EIO_ASSERT(mdreq != NULL);
+			bc->mdreqs = bc->mdreqs->next;
+			mdreq->next = NULL;
+			mdreq->pending_mdlist = ebio;
+			mdreq->dmc = dmc;
+			mdreq->set = set_index;
+			set->mdreq = mdreq;
+			ebio->eb_next = NULL;
+			do_schedule = 1;
+		} else {
+			mdreq = set->mdreq;
+			EIO_ASSERT(mdreq != NULL);
+			ebio->eb_next = mdreq->pending_mdlist;
+			mdreq->pending_mdlist = ebio;
+		}
+
+		ebio = bc->bc_mdlist;
+		if (!ebio || ebio->eb_cacheset != set_index) {
+			spin_unlock_irqrestore(&set->cs_lock, flags);
+			if (do_schedule) {
+				INIT_WORK(&mdreq->work, eio_do_mdupdate);
+				queue_work(dmc->mdupdate_q, &mdreq->work);
+				do_schedule = 0;
+			}
+		}
+	}
+
+	EIO_ASSERT(bc->bc_mdlist == NULL);
+}
+
+/* Kick-off a cache metadata update for marking the blocks dirty */
+void eio_md_write(struct kcached_job *job)
+{
+	struct eio_bio *ebio = job->ebio;
+	struct eio_bio *nebio;
+	struct eio_bio *pebio;
+	struct bio_container *bc = ebio->eb_bc;
+	unsigned long flags;
+	int enqueue = 0;
+
+	/*
+	 * ebios are stored in ascending order of cache sets.
+	 */
+
+	spin_lock_irqsave(&bc->bc_lock, flags);
+	EIO_ASSERT(bc->bc_mdwait > 0);
+	nebio = bc->bc_mdlist;
+	pebio = NULL;
+	while (nebio) {
+		if (nebio->eb_cacheset > ebio->eb_cacheset)
+			break;
+		pebio = nebio;
+		nebio = nebio->eb_next;
+	}
+	ebio->eb_next = nebio;
+	if (!pebio)
+		bc->bc_mdlist = ebio;
+	else
+		pebio->eb_next = ebio;
+	bc->bc_mdwait--;
+	if (bc->bc_mdwait == 0)
+		enqueue = 1;
+	spin_unlock_irqrestore(&bc->bc_lock, flags);
+
+	eio_free_cache_job(job);
+
+	if (enqueue)
+		eio_enq_mdupdate(bc);
+}
+
+/* Ensure cache level dirty thresholds compliance. If required, trigger cache-wide clean */
+static void eio_check_dirty_cache_thresholds(struct cache_c *dmc)
+{
+	if (DIRTY_CACHE_THRESHOLD_CROSSED(dmc)) {
+		int64_t required_cleans;
+		int64_t enqueued_cleans;
+		u_int64_t set_time;
+		index_t set_index;
+		unsigned long flags;
+
+		spin_lock_irqsave(&dmc->clean_sl, flags);
+		if (atomic64_read(&dmc->clean_pendings)
+		    || dmc->clean_excess_dirty) {
+			/* Already excess dirty block cleaning is in progress */
+			spin_unlock_irqrestore(&dmc->clean_sl, flags);
+			return;
+		}
+		dmc->clean_excess_dirty = 1;
+		spin_unlock_irqrestore(&dmc->clean_sl, flags);
+
+		/* Clean needs to be triggered on the cache */
+		required_cleans = atomic64_read(&dmc->nr_dirty) -
+				  (EIO_DIV((dmc->sysctl_active.dirty_low_threshold * dmc->size),
+					   100));
+		enqueued_cleans = 0;
+
+		spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+		do {
+			lru_rem_head(dmc->dirty_set_lru, &set_index, &set_time);
+			if (set_index == LRU_NULL)
+				break;
+
+			enqueued_cleans += dmc->cache_sets[set_index].nr_dirty;
+			spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+			eio_addto_cleanq(dmc, set_index, 1);
+			spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+		} while (enqueued_cleans <= required_cleans);
+		spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+		spin_lock_irqsave(&dmc->clean_sl, flags);
+		dmc->clean_excess_dirty = 0;
+		spin_unlock_irqrestore(&dmc->clean_sl, flags);
+	}
+}
+
+/* Ensure set level dirty thresholds compliance. If required, trigger set clean */
+static void eio_check_dirty_set_thresholds(struct cache_c *dmc, index_t set)
+{
+	if (DIRTY_SET_THRESHOLD_CROSSED(dmc, set)) {
+		eio_addto_cleanq(dmc, set, 0);
+		return;
+	}
+}
+
+/* Ensure various cache thresholds compliance. If required trigger clean */
+void eio_comply_dirty_thresholds(struct cache_c *dmc, index_t set)
+{
+	/*
+	 * 1. Don't trigger new cleanings if
+	 *      - cache is not wb
+	 *      - autoclean threshold is crossed
+	 *      - fast remove in progress is set
+	 *      - cache is in failed mode.
+	 * 2. Initiate set-wide clean, if set level dirty threshold is crossed
+	 * 3. Initiate cache-wide clean, if cache level dirty threshold is crossed
+	 */
+
+	if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+		pr_debug
+			("eio_comply_dirty_thresholds: Cache %s is in failed mode.\n",
+			dmc->cache_name);
+		return;
+	}
+
+	if (AUTOCLEAN_THRESHOLD_CROSSED(dmc) || (dmc->mode != CACHE_MODE_WB))
+		return;
+
+	if (set != -1)
+		eio_check_dirty_set_thresholds(dmc, set);
+	eio_check_dirty_cache_thresholds(dmc);
+}
+
+/* Do read from cache */
+static void
+eio_cached_read(struct cache_c *dmc, struct eio_bio *ebio, int rw_flags)
+{
+	struct kcached_job *job;
+	index_t index = ebio->eb_index;
+	int err = 0;
+
+	job = eio_new_job(dmc, ebio, index);
+
+	if (unlikely(job == NULL))
+		err = -ENOMEM;
+	else {
+		job->action = READCACHE;        /* Fetch data from cache */
+		atomic_inc(&dmc->nr_jobs);
+
+		SECTOR_STATS(dmc->eio_stats.read_hits, ebio->eb_size);
+		SECTOR_STATS(dmc->eio_stats.ssd_reads, ebio->eb_size);
+		atomic64_inc(&dmc->eio_stats.readcache);
+		err =
+			eio_io_async_bvec(dmc, &job->job_io_regions.cache, rw_flags,
+					  ebio->eb_bv, ebio->eb_nbvec,
+					  eio_io_callback, job, 0);
+
+	}
+	if (err) {
+		unsigned long flags;
+		pr_err("eio_cached_read: IO submission failed, block %llu",
+		       EIO_DBN_GET(dmc, index));
+		spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+				  flags);
+		/*
+		 * For already DIRTY block, invalidation is too costly, skip it.
+		 * For others, mark the block as INVALID and return error.
+		 */
+		if (EIO_CACHE_STATE_GET(dmc, ebio->eb_index) != ALREADY_DIRTY) {
+			EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+			atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+		}
+		spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].
+				       cs_lock, flags);
+		eb_endio(ebio, err);
+		ebio = NULL;
+		if (job) {
+			job->ebio = NULL;
+			eio_free_cache_job(job);
+			job = NULL;
+		}
+	}
+}
+
+/*
+ * Invalidate any colliding blocks if they are !BUSY and !DIRTY.  In BUSY case,
+ * we need to wait until the underlying IO is finished, and then proceed with
+ * the invalidation, so a QUEUED flag is added.
+ */
+static int
+eio_inval_block_set_range(struct cache_c *dmc, int set, sector_t iosector,
+			  unsigned iosize, int multiblk)
+{
+	int start_index, end_index, i;
+	sector_t endsector = iosector + eio_to_sector(iosize);
+
+	start_index = dmc->assoc * set;
+	end_index = start_index + dmc->assoc;
+	for (i = start_index; i < end_index; i++) {
+		sector_t start_dbn;
+		sector_t end_dbn;
+
+		if (EIO_CACHE_STATE_GET(dmc, i) & INVALID)
+			continue;
+		start_dbn = EIO_DBN_GET(dmc, i);
+		end_dbn = start_dbn + dmc->block_size;
+
+		if (!(endsector <= start_dbn || iosector >= end_dbn)) {
+
+			if (!
+			    (EIO_CACHE_STATE_GET(dmc, i) &
+			     (BLOCK_IO_INPROG | DIRTY | QUEUED))) {
+				EIO_CACHE_STATE_SET(dmc, i, INVALID);
+				atomic64_dec_if_positive(&dmc->eio_stats.
+							 cached_blocks);
+				if (multiblk)
+					continue;
+				return 0;
+			}
+
+			/* Skip queued flag for DIRTY(inprog or otherwise) blocks. */
+			if (!(EIO_CACHE_STATE_GET(dmc, i) & (DIRTY | QUEUED)))
+				/* BLOCK_IO_INPROG is set. Set QUEUED flag */
+				EIO_CACHE_STATE_ON(dmc, i, QUEUED);
+
+			if (!multiblk)
+				return 1;
+		}
+	}
+	return 0;
+}
+
+int
+eio_invalidate_sanity_check(struct cache_c *dmc, u_int64_t iosector,
+			    u_int64_t *num_sectors)
+{
+	u_int64_t disk_size;
+
+	/*
+	 * Sanity check the arguements
+	 */
+	if (unlikely(*num_sectors == 0)) {
+		pr_info
+			("invaldate_sector_range: nothing to do because number of sectors specified is zero");
+		return -EINVAL;
+	}
+
+	disk_size = eio_to_sector(eio_get_device_size(dmc->disk_dev));
+	if (iosector >= disk_size) {
+		pr_err
+			("eio_inval_range: nothing to do because starting sector is past last sector (%lu > %lu)",
+			(long unsigned int)iosector, (long unsigned int)disk_size);
+		return -EINVAL;
+	}
+
+	if ((iosector + (*num_sectors)) > disk_size) {
+		pr_info
+			("eio_inval_range: trimming range because there are less sectors to invalidate than requested. (%lu < %lu)",
+			(long unsigned int)(disk_size - iosector),
+			(long unsigned int)*num_sectors);
+		*num_sectors = (disk_size - iosector);
+	}
+
+	return 0;
+}
+
+void eio_inval_range(struct cache_c *dmc, sector_t iosector, unsigned iosize)
+{
+	u_int32_t bset;
+	sector_t snum;
+	sector_t snext;
+	unsigned ioinset;
+	unsigned long flags;
+	int totalsshift = dmc->block_shift + dmc->consecutive_shift;
+
+	snum = iosector;
+	while (iosize) {
+		bset = hash_block(dmc, snum);
+		snext = ((snum >> totalsshift) + 1) << totalsshift;
+		ioinset = (unsigned)to_bytes(snext - snum);
+		if (ioinset > iosize)
+			ioinset = iosize;
+		spin_lock_irqsave(&dmc->cache_sets[bset].cs_lock, flags);
+		eio_inval_block_set_range(dmc, bset, snum, ioinset, 1);
+		spin_unlock_irqrestore(&dmc->cache_sets[bset].cs_lock, flags);
+		snum = snext;
+		iosize -= ioinset;
+	}
+}
+
+/*
+ * Invalidates all cached blocks without waiting for them to complete
+ * Should be called with incoming IO suspended
+ */
+int eio_invalidate_cache(struct cache_c *dmc)
+{
+	u_int64_t i = 0;
+	unsigned long flags = 0;
+	sector_t disk_dev_size = to_bytes(eio_get_device_size(dmc->disk_dev));
+
+	/* invalidate the whole cache */
+	for (i = 0; i < (dmc->size >> dmc->consecutive_shift); i++) {
+		spin_lock_irqsave(&dmc->cache_sets[i].cs_lock, flags);
+		/* TBD. Apply proper fix for the cast to disk_dev_size */
+		(void)eio_inval_block_set_range(dmc, (int)i, 0,
+						(unsigned)disk_dev_size, 0);
+		spin_unlock_irqrestore(&dmc->cache_sets[i].cs_lock, flags);
+	}                       /* end - for all cachesets (i) */
+
+	return 0;               /* i suspect we may need to return different statuses in the future */
+}                               /* eio_invalidate_cache */
+
+static int eio_inval_block(struct cache_c *dmc, sector_t iosector)
+{
+	u_int32_t bset;
+	int queued;
+
+	/*Chop lower bits of iosector*/
+	iosector = EIO_ROUND_SECTOR(dmc, iosector);
+	bset = hash_block(dmc, iosector);
+	queued = eio_inval_block_set_range(dmc, bset, iosector,
+					   (unsigned)to_bytes(dmc->block_size),
+					   0);
+
+	return queued;
+}
+
+/* Serving write I/Os, that involves both SSD and HDD */
+static int eio_uncached_write(struct cache_c *dmc, struct eio_bio *ebio)
+{
+	struct kcached_job *job;
+	int err = 0;
+	index_t index = ebio->eb_index;
+	unsigned long flags = 0;
+	u_int8_t cstate;
+
+	if (index == -1) {
+		/*
+		 * No work, if block is not allocated.
+		 * Ensure, invalidation of the block at the end
+		 */
+		ebio->eb_iotype |= EB_INVAL;
+		return 0;
+	}
+
+	spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock, flags);
+	cstate = EIO_CACHE_STATE_GET(dmc, index);
+	EIO_ASSERT(cstate & (DIRTY | CACHEWRITEINPROG));
+	if (cstate == ALREADY_DIRTY) {
+		/*
+		 * Treat the dirty block cache write failure as
+		 * I/O failure for the entire I/O
+		 * TBD
+		 * Can we live without this restriction
+		 */
+		ebio->eb_iotype = EB_MAIN_IO;
+
+		/*
+		 * We don't set inprog flag on dirty block.
+		 * In lieu of the inprog flag, we are using the
+		 * eb_holdcount for dirty block, so that the
+		 * endio can be called, only when the write to disk
+		 * and the write to cache both complete for the ebio
+		 */
+		atomic_inc(&ebio->eb_holdcount);
+	} else
+		/* ensure DISKWRITEINPROG for uncached write on non-DIRTY blocks */
+		EIO_CACHE_STATE_ON(dmc, index, DISKWRITEINPROG);
+
+	spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+			       flags);
+
+	job = eio_new_job(dmc, ebio, index);
+	if (unlikely(job == NULL))
+		err = -ENOMEM;
+	else {
+		job->action = WRITECACHE;
+		SECTOR_STATS(dmc->eio_stats.ssd_writes, ebio->eb_size);
+		atomic64_inc(&dmc->eio_stats.writecache);
+		err = eio_io_async_bvec(dmc, &job->job_io_regions.cache, WRITE,
+					ebio->eb_bv, ebio->eb_nbvec,
+					eio_io_callback, job, 0);
+	}
+
+	if (err) {
+		pr_err("eio_uncached_write: IO submission failed, block %llu",
+		       EIO_DBN_GET(dmc, index));
+		spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+				  flags);
+		if (EIO_CACHE_STATE_GET(dmc, ebio->eb_index) == ALREADY_DIRTY)
+			/*
+			 * Treat I/O failure on a DIRTY block as failure of entire I/O.
+			 * TBD
+			 * Can do better error handling by invalidation of the dirty
+			 * block, if the cache block write failed, but disk write succeeded
+			 */
+			ebio->eb_bc->bc_error = err;
+		else {
+			/* Mark the block as INVALID for non-DIRTY block. */
+			EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+			atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+			/* Set the INVAL flag to ensure block is marked invalid at the end */
+			ebio->eb_iotype |= EB_INVAL;
+			ebio->eb_index = -1;
+		}
+		spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].
+				       cs_lock, flags);
+		if (job) {
+			job->ebio = NULL;
+			eio_free_cache_job(job);
+			job = NULL;
+		}
+	}
+
+	return err;
+}
+
+/* Serving write I/Os that can be fulfilled just by SSD */
+static int
+eio_cached_write(struct cache_c *dmc, struct eio_bio *ebio, int rw_flags)
+{
+	struct kcached_job *job;
+	int err = 0;
+	index_t index = ebio->eb_index;
+	unsigned long flags = 0;
+	u_int8_t cstate;
+
+	/*
+	 * WRITE (I->DV)
+	 * WRITE (V->DV)
+	 * WRITE (V1->DV2)
+	 * WRITE (DV->DV)
+	 */
+
+	/* Possible only in writeback caching mode */
+	EIO_ASSERT(dmc->mode == CACHE_MODE_WB);
+
+	/*
+	 * TBD
+	 * Possibly don't need the spinlock-unlock here
+	 */
+	spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock, flags);
+	cstate = EIO_CACHE_STATE_GET(dmc, index);
+	if (!(cstate & DIRTY)) {
+		EIO_ASSERT(cstate & CACHEWRITEINPROG);
+		/* make sure the block is marked DIRTY inprogress */
+		EIO_CACHE_STATE_SET(dmc, index, DIRTY_INPROG);
+	}
+	spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+			       flags);
+
+	job = eio_new_job(dmc, ebio, index);
+	if (unlikely(job == NULL))
+		err = -ENOMEM;
+	else {
+		job->action = WRITECACHE;
+
+		SECTOR_STATS(dmc->eio_stats.ssd_writes, ebio->eb_size);
+		atomic64_inc(&dmc->eio_stats.writecache);
+		EIO_ASSERT((rw_flags & 1) == WRITE);
+		err =
+			eio_io_async_bvec(dmc, &job->job_io_regions.cache, rw_flags,
+					  ebio->eb_bv, ebio->eb_nbvec,
+					  eio_io_callback, job, 0);
+
+	}
+
+	if (err) {
+		pr_err("eio_cached_write: IO submission failed, block %llu",
+		       EIO_DBN_GET(dmc, index));
+		spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+				  flags);
+		cstate = EIO_CACHE_STATE_GET(dmc, index);
+		if (cstate == DIRTY_INPROG) {
+			/* A DIRTY(inprog) block should be invalidated on error */
+			EIO_CACHE_STATE_SET(dmc, ebio->eb_index, INVALID);
+			atomic64_dec_if_positive(&dmc->eio_stats.cached_blocks);
+		} else
+			/* An already DIRTY block don't have an option but just return error. */
+			EIO_ASSERT(cstate == ALREADY_DIRTY);
+		spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].
+				       cs_lock, flags);
+		eb_endio(ebio, err);
+		ebio = NULL;
+		if (job) {
+			job->ebio = NULL;
+			eio_free_cache_job(job);
+			job = NULL;
+		}
+	}
+
+	return err;
+}
+
+static struct eio_bio *eio_new_ebio(struct cache_c *dmc, struct bio *bio,
+				    unsigned *presidual_biovec, sector_t snum,
+				    int iosize, struct bio_container *bc,
+				    int iotype)
+{
+	struct eio_bio *ebio;
+	int residual_biovec = *presidual_biovec;
+	int numbvecs = 0;
+	int ios;
+
+	if (residual_biovec) {
+		int bvecindex = bio->bi_idx;
+		int rbvindex;
+
+		/* Calculate the number of bvecs required */
+		ios = iosize;
+		while (ios > 0) {
+			int len;
+
+			if (ios == iosize)
+				len =
+					bio->bi_io_vec[bvecindex].bv_len -
+					residual_biovec;
+			else
+				len = bio->bi_io_vec[bvecindex].bv_len;
+
+			numbvecs++;
+			if (len > ios)
+				len = ios;
+			ios -= len;
+			bvecindex++;
+		}
+		ebio =
+			kmalloc(sizeof(struct eio_bio) +
+				numbvecs * sizeof(struct bio_vec), GFP_NOWAIT);
+
+		if (!ebio)
+			return ERR_PTR(-ENOMEM);
+
+		rbvindex = 0;
+		ios = iosize;
+		while (ios > 0) {
+			ebio->eb_rbv[rbvindex].bv_page =
+				bio->bi_io_vec[bio->bi_idx].bv_page;
+			ebio->eb_rbv[rbvindex].bv_offset =
+				bio->bi_io_vec[bio->bi_idx].bv_offset +
+				residual_biovec;
+			ebio->eb_rbv[rbvindex].bv_len =
+				bio->bi_io_vec[bio->bi_idx].bv_len -
+				residual_biovec;
+			if (ebio->eb_rbv[rbvindex].bv_len > (unsigned)ios) {
+				residual_biovec += ios;
+				ebio->eb_rbv[rbvindex].bv_len = ios;
+			} else {
+				residual_biovec = 0;
+				bio->bi_idx++;
+			}
+			ios -= ebio->eb_rbv[rbvindex].bv_len;
+			rbvindex++;
+		}
+		EIO_ASSERT(rbvindex == numbvecs);
+		ebio->eb_bv = ebio->eb_rbv;
+	} else {
+		ebio = kmalloc(sizeof(struct eio_bio), GFP_NOWAIT);
+
+		if (!ebio)
+			return ERR_PTR(-ENOMEM);
+		ebio->eb_bv = bio->bi_io_vec + bio->bi_idx;
+		ios = iosize;
+		while (ios > 0) {
+			numbvecs++;
+			if ((unsigned)ios < bio->bi_io_vec[bio->bi_idx].bv_len) {
+				residual_biovec = ios;
+				ios = 0;
+			} else {
+				ios -= bio->bi_io_vec[bio->bi_idx].bv_len;
+				bio->bi_idx++;
+			}
+		}
+	}
+	EIO_ASSERT(ios == 0);
+	EIO_ASSERT(numbvecs != 0);
+	*presidual_biovec = residual_biovec;
+
+	ebio->eb_sector = snum;
+	ebio->eb_cacheset = hash_block(dmc, snum);
+	ebio->eb_size = iosize;
+	ebio->eb_dir = bio_data_dir(bio);
+	ebio->eb_next = NULL;
+	ebio->eb_index = -1;
+	ebio->eb_iotype = iotype;
+	ebio->eb_nbvec = numbvecs;
+
+	bc_addfb(bc, ebio);
+
+	/* Always set the holdcount for eb to 1, to begin with. */
+	atomic_set(&ebio->eb_holdcount, 1);
+
+	return ebio;
+}
+
+/* Issues HDD I/O */
+static void
+eio_disk_io(struct cache_c *dmc, struct bio *bio,
+	    struct eio_bio *anchored_bios, struct bio_container *bc,
+	    int force_inval)
+{
+	struct eio_bio *ebio;
+	struct kcached_job *job;
+	int residual_biovec = 0;
+	int error = 0;
+
+	/*disk io happens on whole bio. Reset bi_idx*/
+	bio->bi_idx = 0;
+	ebio =
+		eio_new_ebio(dmc, bio, &residual_biovec, bio->bi_sector,
+			     bio->bi_size, bc, EB_MAIN_IO);
+
+	if (unlikely(IS_ERR(ebio))) {
+		bc->bc_error = error = PTR_ERR(ebio);
+		ebio = NULL;
+		goto errout;
+	}
+
+	if (force_inval)
+		ebio->eb_iotype |= EB_INVAL;
+	ebio->eb_next = anchored_bios;  /*Anchor the ebio list to this super bio*/
+	job = eio_new_job(dmc, ebio, -1);
+
+	if (unlikely(job == NULL)) {
+		error = -ENOMEM;
+		goto errout;
+	}
+	atomic_inc(&dmc->nr_jobs);
+	if (ebio->eb_dir == READ) {
+		job->action = READDISK;
+		SECTOR_STATS(dmc->eio_stats.disk_reads, bio->bi_size);
+		atomic64_inc(&dmc->eio_stats.readdisk);
+	} else {
+		job->action = WRITEDISK;
+		SECTOR_STATS(dmc->eio_stats.disk_writes, bio->bi_size);
+		atomic64_inc(&dmc->eio_stats.writedisk);
+	}
+
+	/*
+	 * Pass the original bio flags as is, while doing
+	 * read / write to HDD.
+	 */
+	VERIFY_BIO_FLAGS(ebio);
+	error = eio_io_async_bvec(dmc, &job->job_io_regions.disk,
+				  GET_BIO_FLAGS(ebio),
+				  ebio->eb_bv, ebio->eb_nbvec,
+				  eio_io_callback, job, 1);
+
+	if (error) {
+		job->ebio = NULL;
+		eio_free_cache_job(job);
+		goto errout;
+	}
+	return;
+
+errout:
+	eio_inval_range(dmc, bio->bi_sector, bio->bi_size);
+	eio_flag_abios(dmc, anchored_bios, error);
+
+	if (ebio)
+		eb_endio(ebio, error);
+	return;
+}
+
+/*Given a sector number and biosize, returns cache io size*/
+static unsigned int
+eio_get_iosize(struct cache_c *dmc, sector_t snum, unsigned int biosize)
+{
+	unsigned int iosize;
+	unsigned int swithinblock = snum & (dmc->block_size - 1);
+
+	/*Check whether io starts at a cache block boundary*/
+	if (swithinblock)
+		iosize = (unsigned int)to_bytes(dmc->block_size - swithinblock);
+	else
+		iosize = (unsigned int)to_bytes(dmc->block_size);
+	if (iosize > biosize)
+		iosize = biosize;
+	return iosize;
+}
+
+/* Insert a new set sequence in sorted order to existing set sequence list */
+static int
+insert_set_seq(struct set_seq **seq_list, index_t first_set, index_t last_set)
+{
+	struct set_seq *cur_seq = NULL;
+	struct set_seq *prev_seq = NULL;
+	struct set_seq *new_seq = NULL;
+
+	EIO_ASSERT((first_set != -1) && (last_set != -1)
+		   && (last_set >= first_set));
+
+	for (cur_seq = *seq_list; cur_seq;
+	     prev_seq = cur_seq, cur_seq = cur_seq->next) {
+		if (first_set > cur_seq->last_set)
+			/* go for the next seq in the sorted seq list */
+			continue;
+
+		if (last_set < cur_seq->first_set)
+			/* break here to insert the new seq to seq list at this point */
+			break;
+
+		/*
+		 * There is an overlap of the new seq with the current seq.
+		 * Adjust the first_set field of the current seq to consume
+		 * the overlap.
+		 */
+		if (first_set < cur_seq->first_set)
+			cur_seq->first_set = first_set;
+
+		if (last_set <= cur_seq->last_set)
+			/* The current seq now fully encompasses the first and last sets */
+			return 0;
+
+		/* Increment the first set so as to start from, where the current seq left */
+		first_set = cur_seq->last_set + 1;
+	}
+
+	new_seq = kmalloc(sizeof(struct set_seq), GFP_NOWAIT);
+	if (new_seq == NULL)
+		return -ENOMEM;
+	new_seq->first_set = first_set;
+	new_seq->last_set = last_set;
+	if (prev_seq) {
+		new_seq->next = prev_seq->next;
+		prev_seq->next = new_seq;
+	} else {
+		new_seq->next = *seq_list;
+		*seq_list = new_seq;
+	}
+
+	return 0;
+}
+
+/* Acquire read/shared lock for the sets covering the entire I/O range */
+static int eio_acquire_set_locks(struct cache_c *dmc, struct bio_container *bc)
+{
+	struct bio *bio = bc->bc_bio;
+	sector_t round_sector;
+	sector_t end_sector;
+	sector_t set_size;
+	index_t cur_set;
+	index_t first_set;
+	index_t last_set;
+	index_t i;
+	struct set_seq *cur_seq;
+	struct set_seq *next_seq;
+	int error;
+
+	/*
+	 * Find first set using start offset of the I/O and lock it.
+	 * Find next sets by adding the set offsets to the previous set
+	 * Identify all the sequences of set numbers that need locking.
+	 * Keep the sequences in sorted list.
+	 * For each set in each sequence
+	 * - acquire read lock on the set.
+	 */
+
+	round_sector = EIO_ROUND_SET_SECTOR(dmc, bio->bi_sector);
+	set_size = dmc->block_size * dmc->assoc;
+	end_sector = bio->bi_sector + eio_to_sector(bio->bi_size);
+	first_set = -1;
+	last_set = -1;
+	cur_set = -1;
+	bc->bc_setspan = NULL;
+
+	while (round_sector < end_sector) {
+		cur_set = hash_block(dmc, round_sector);
+		if (first_set == -1) {
+			first_set = cur_set;
+			last_set = cur_set;
+		} else if (cur_set == (last_set + 1))
+			last_set = cur_set;
+		else {
+			/*
+			 * Add the seq of start, end set to sorted (first, last) seq list
+			 * and reinit the first and last set
+			 */
+			error =
+				insert_set_seq(&bc->bc_setspan, first_set,
+					       last_set);
+			if (error)
+				goto err_out;
+			first_set = cur_set;
+			last_set = cur_set;
+		}
+
+		round_sector += set_size;
+	}
+
+	/* Add the remaining first, last set sequence */
+
+	EIO_ASSERT((first_set != -1) && (last_set == cur_set));
+
+	if (bc->bc_setspan == NULL) {
+		/* No sequence was added, can use singlespan */
+		cur_seq = &bc->bc_singlesspan;
+		cur_seq->first_set = first_set;
+		cur_seq->last_set = last_set;
+		cur_seq->next = NULL;
+		bc->bc_setspan = cur_seq;
+	} else {
+		error = insert_set_seq(&bc->bc_setspan, first_set, last_set);
+		if (error)
+			goto err_out;
+	}
+
+	/* Acquire read locks on the sets in the set span */
+	for (cur_seq = bc->bc_setspan; cur_seq; cur_seq = cur_seq->next)
+		for (i = cur_seq->first_set; i <= cur_seq->last_set; i++)
+			down_read(&dmc->cache_sets[i].rw_lock);
+
+	return 0;
+
+err_out:
+
+	/* Free the seqs in the seq list, unless it is just the local seq */
+	if (bc->bc_setspan != &bc->bc_singlesspan) {
+		for (cur_seq = bc->bc_setspan; cur_seq; cur_seq = next_seq) {
+			next_seq = cur_seq->next;
+			kfree(cur_seq);
+		}
+	}
+	return error;
+}
+
+/*
+ * Allocate mdreq and md_blocks for each set.
+ */
+static int eio_alloc_mdreqs(struct cache_c *dmc, struct bio_container *bc)
+{
+	index_t i;
+	struct mdupdate_request *mdreq;
+	int nr_bvecs, ret;
+	struct set_seq *cur_seq;
+
+	bc->mdreqs = NULL;
+
+	for (cur_seq = bc->bc_setspan; cur_seq; cur_seq = cur_seq->next) {
+		for (i = cur_seq->first_set; i <= cur_seq->last_set; i++) {
+			mdreq = kzalloc(sizeof(*mdreq), GFP_NOWAIT);
+			if (mdreq) {
+				mdreq->md_size =
+					dmc->assoc *
+					sizeof(struct flash_cacheblock);
+				nr_bvecs =
+					IO_BVEC_COUNT(mdreq->md_size,
+						      SECTORS_PER_PAGE);
+
+				mdreq->mdblk_bvecs =
+					(struct bio_vec *)
+					kmalloc(sizeof(struct bio_vec) * nr_bvecs,
+						GFP_KERNEL);
+				if (mdreq->mdblk_bvecs) {
+
+					ret =
+						eio_alloc_wb_bvecs(mdreq->
+								   mdblk_bvecs,
+								   nr_bvecs,
+								   SECTORS_PER_PAGE);
+					if (ret) {
+						pr_err
+							("eio_alloc_mdreqs: failed to allocated pages\n");
+						kfree(mdreq->mdblk_bvecs);
+						mdreq->mdblk_bvecs = NULL;
+					}
+					mdreq->mdbvec_count = nr_bvecs;
+				}
+			}
+
+			if (unlikely
+				    ((mdreq == NULL) || (mdreq->mdblk_bvecs == NULL))) {
+				struct mdupdate_request *nmdreq;
+
+				mdreq = bc->mdreqs;
+				while (mdreq) {
+					nmdreq = mdreq->next;
+					if (mdreq->mdblk_bvecs) {
+						eio_free_wb_bvecs(mdreq->
+								  mdblk_bvecs,
+								  mdreq->
+								  mdbvec_count,
+								  SECTORS_PER_PAGE);
+						kfree(mdreq->mdblk_bvecs);
+					}
+					kfree(mdreq);
+					mdreq = nmdreq;
+				}
+				bc->mdreqs = NULL;
+				return -ENOMEM;
+			} else {
+				mdreq->next = bc->mdreqs;
+				bc->mdreqs = mdreq;
+			}
+		}
+	}
+
+	return 0;
+
+}
+
+/*
+ * Release:
+ * 1. the set locks covering the entire I/O range
+ * 2. any previously allocated memory for md update
+ */
+static int
+eio_release_io_resources(struct cache_c *dmc, struct bio_container *bc)
+{
+	index_t i;
+	struct mdupdate_request *mdreq;
+	struct mdupdate_request *nmdreq;
+	struct set_seq *cur_seq;
+	struct set_seq *next_seq;
+
+	/* Release read locks on the sets in the set span */
+	for (cur_seq = bc->bc_setspan; cur_seq; cur_seq = cur_seq->next)
+		for (i = cur_seq->first_set; i <= cur_seq->last_set; i++)
+			up_read(&dmc->cache_sets[i].rw_lock);
+
+	/* Free the seqs in the set span, unless it is single span */
+	if (bc->bc_setspan != &bc->bc_singlesspan) {
+		for (cur_seq = bc->bc_setspan; cur_seq; cur_seq = next_seq) {
+			next_seq = cur_seq->next;
+			kfree(cur_seq);
+		}
+	}
+
+	mdreq = bc->mdreqs;
+	while (mdreq) {
+		nmdreq = mdreq->next;
+		if (mdreq->mdblk_bvecs) {
+			eio_free_wb_bvecs(mdreq->mdblk_bvecs,
+					  mdreq->mdbvec_count,
+					  SECTORS_PER_PAGE);
+			kfree(mdreq->mdblk_bvecs);
+		}
+		kfree(mdreq);
+		mdreq = nmdreq;
+	}
+	bc->mdreqs = NULL;
+
+	return 0;
+}
+
+/*
+ * Decide the mapping and perform necessary cache operations for a bio request.
+ */
+int eio_map(struct cache_c *dmc, struct request_queue *rq, struct bio *bio)
+{
+	sector_t sectors = eio_to_sector(bio->bi_size);
+	struct eio_bio *ebio = NULL;
+	struct bio_container *bc;
+	sector_t snum;
+	unsigned int iosize;
+	unsigned int totalio;
+	unsigned int biosize;
+	unsigned int residual_biovec;
+	unsigned int force_uncached = 0;
+	int data_dir = bio_data_dir(bio);
+
+	/*bio list*/
+	struct eio_bio *ebegin = NULL;
+	struct eio_bio *eend = NULL;
+	struct eio_bio *enext = NULL;
+
+	EIO_ASSERT(bio->bi_idx == 0);
+
+	pr_debug("this needs to be removed immediately\n");
+
+	if (bio_rw_flagged(bio, REQ_DISCARD)) {
+		pr_debug
+			("eio_map: Discard IO received. Invalidate incore start=%lu totalsectors=%d.\n",
+			(unsigned long)bio->bi_sector,
+			(int)eio_to_sector(bio->bi_size));
+		bio_endio(bio, 0);
+		pr_err
+			("eio_map: I/O with Discard flag received. Discard flag is not supported.\n");
+		return 0;
+	}
+
+	if (unlikely(dmc->cache_rdonly)) {
+		if (data_dir != READ) {
+			bio_endio(bio, -EPERM);
+			pr_debug
+				("eio_map: cache is read only, write not permitted\n");
+			return 0;
+		}
+	}
+
+	if (sectors < SIZE_HIST)
+		atomic64_inc(&dmc->size_hist[sectors]);
+
+	if (data_dir == READ) {
+		SECTOR_STATS(dmc->eio_stats.reads, bio->bi_size);
+		atomic64_inc(&dmc->eio_stats.readcount);
+	} else {
+		SECTOR_STATS(dmc->eio_stats.writes, bio->bi_size);
+		atomic64_inc(&dmc->eio_stats.writecount);
+	}
+
+	/*
+	 * Cache FAILED mode is like Hard failure.
+	 * Dont allow I/Os to go through.
+	 */
+	if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+		/*ASK confirm that once failed is set, it's never reset*/
+		/* Source device is not available. */
+		CTRACE
+			("eio_map:2 source device is not present. Cache is in Failed state\n");
+		bio_endio(bio, -ENODEV);
+		bio = NULL;
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/* WB cache will never be in degraded mode. */
+	if (unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+		EIO_ASSERT(dmc->mode != CACHE_MODE_WB);
+		force_uncached = 1;
+	}
+
+	/*
+	 * Process zero sized bios by passing original bio flags
+	 * to both HDD and SSD.
+	 */
+	if (bio->bi_size == 0) {
+		eio_process_zero_size_bio(dmc, bio);
+		return DM_MAPIO_SUBMITTED;
+	}
+
+	/* Create a bio container */
+
+	bc = kzalloc(sizeof(struct bio_container), GFP_NOWAIT);
+	if (!bc) {
+		bio_endio(bio, -ENOMEM);
+		return DM_MAPIO_SUBMITTED;
+	}
+	bc->bc_iotime = jiffies;
+	bc->bc_bio = bio;
+	bc->bc_dmc = dmc;
+	spin_lock_init(&bc->bc_lock);
+	atomic_set(&bc->bc_holdcount, 1);
+	bc->bc_error = 0;
+
+	snum = bio->bi_sector;
+	totalio = bio->bi_size;
+	biosize = bio->bi_size;
+	residual_biovec = 0;
+
+	if (dmc->mode == CACHE_MODE_WB) {
+		int ret;
+		/*
+		 * For writeback, the app I/O and the clean I/Os
+		 * need to be exclusive for a cache set. Acquire shared
+		 * lock on the cache set for app I/Os and exclusive
+		 * lock on the cache set for clean I/Os.
+		 */
+		ret = eio_acquire_set_locks(dmc, bc);
+		if (ret) {
+			bio_endio(bio, ret);
+			kfree(bc);
+			return DM_MAPIO_SUBMITTED;
+		}
+	}
+
+	atomic64_inc(&dmc->nr_ios);
+
+	/*
+	 * Prepare for I/O processing.
+	 * - Allocate ebios.
+	 * - For reads, identify if we need to do uncached read
+	 * - If force uncached I/O is set, invalidate the cache blocks for the I/O
+	 */
+
+	if (force_uncached)
+		eio_inval_range(dmc, snum, totalio);
+	else {
+		while (biosize) {
+			iosize = eio_get_iosize(dmc, snum, biosize);
+			ebio = eio_new_ebio(dmc, bio, &residual_biovec, snum,
+					iosize, bc, EB_SUBORDINATE_IO);
+			if (IS_ERR(ebio)) {
+				bc->bc_error = -ENOMEM;
+				break;
+			}
+
+			/* Anchor this ebio on ebio list. Preserve the order */
+			if (ebegin)
+				eend->eb_next = ebio;
+			else
+				ebegin = ebio;
+			eend = ebio;
+
+			biosize -= iosize;
+			snum += eio_to_sector(iosize);
+		}
+	}
+
+	if (bc->bc_error) {
+		/* Error. Do ebio and bc cleanup. */
+		ebio = ebegin;
+		while (ebio) {
+			enext = ebio->eb_next;
+			eb_endio(ebio, bc->bc_error);
+			ebio = enext;
+		}
+
+		/* By now, the bc_holdcount must be 1 */
+		EIO_ASSERT(atomic_read(&bc->bc_holdcount) == 1);
+
+		/* Goto out to cleanup the bc(in bc_put()) */
+		goto out;
+	}
+
+	/*
+	 * Start processing of the ebios.
+	 *
+	 * Note: don't return error from this point on.
+	 *      Error handling would be done as part of
+	 *      the processing of the ebios internally.
+	 */
+	if (force_uncached) {
+		EIO_ASSERT(dmc->mode != CACHE_MODE_WB);
+		if (data_dir == READ)
+			atomic64_inc(&dmc->eio_stats.uncached_reads);
+		else
+			atomic64_inc(&dmc->eio_stats.uncached_writes);
+		eio_disk_io(dmc, bio, ebegin, bc, 1);
+	} else if (data_dir == READ) {
+
+		/* read io processing */
+		eio_read(dmc, bc, ebegin);
+	} else
+		/* write io processing */
+		eio_write(dmc, bc, ebegin);
+
+out:
+
+	if (bc)
+		bc_put(bc, 0);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+/*
+ * Checks the cache block state, for deciding cached/uncached read.
+ * Also reserves/allocates the cache block, wherever necessary.
+ *
+ * Return values
+ * 1: cache hit
+ * 0: cache miss
+ */
+static int eio_read_peek(struct cache_c *dmc, struct eio_bio *ebio)
+{
+	index_t index;
+	int res;
+	int retval = 0;
+	unsigned long flags;
+	u_int8_t cstate;
+
+	spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock, flags);
+
+	res = eio_lookup(dmc, ebio, &index);
+	ebio->eb_index = -1;
+
+	if (res < 0) {
+		atomic64_inc(&dmc->eio_stats.noroom);
+		goto out;
+	}
+
+	cstate = EIO_CACHE_STATE_GET(dmc, index);
+
+	if (cstate & (BLOCK_IO_INPROG | QUEUED))
+		/*
+		 * We found a valid or invalid block but an io is on, so we can't
+		 * proceed. Don't invalidate it. This implies that we'll
+		 * have to read from disk.
+		 * Read on a DIRTY | INPROG block (block which is going to be DIRTY)
+		 * is also redirected to read from disk.
+		 */
+		goto out;
+
+	if (res == VALID) {
+		EIO_ASSERT(cstate & VALID);
+		if ((EIO_DBN_GET(dmc, index) ==
+		     EIO_ROUND_SECTOR(dmc, ebio->eb_sector))) {
+			/*
+			 * Read/write should be done on already DIRTY block
+			 * without any inprog flag.
+			 * Ensure that a failure of DIRTY block read is propagated to app.
+			 * non-DIRTY valid blocks should have inprog flag.
+			 */
+			if (cstate == ALREADY_DIRTY) {
+				ebio->eb_iotype = EB_MAIN_IO;
+				/*
+				 * Set to uncached read and readfill for now.
+				 * It may change to CACHED_READ later, if all
+				 * the blocks are found to be cached
+				 */
+				ebio->eb_bc->bc_dir =
+					UNCACHED_READ_AND_READFILL;
+			} else
+				EIO_CACHE_STATE_ON(dmc, index, CACHEREADINPROG);
+			retval = 1;
+			ebio->eb_index = index;
+			goto out;
+		}
+
+		/* cache is marked readonly. Do not allow READFILL on SSD */
+		if (unlikely(dmc->cache_rdonly))
+			goto out;
+
+		/*
+		 * Found a block to be recycled.
+		 * Its guranteed that it will be a non-DIRTY block
+		 */
+		EIO_ASSERT(!(cstate & DIRTY));
+		if (eio_to_sector(ebio->eb_size) == dmc->block_size) {
+			/*We can recycle and then READFILL only if iosize is block size*/
+			atomic64_inc(&dmc->eio_stats.rd_replace);
+			EIO_CACHE_STATE_SET(dmc, index, VALID | DISKREADINPROG);
+			EIO_DBN_SET(dmc, index, (sector_t)ebio->eb_sector);
+			ebio->eb_index = index;
+			ebio->eb_bc->bc_dir = UNCACHED_READ_AND_READFILL;
+		}
+		goto out;
+	}
+	EIO_ASSERT(res == INVALID);
+
+	/* cache is marked readonly. Do not allow READFILL on SSD */
+	if (unlikely(dmc->cache_rdonly))
+		goto out;
+	/*
+	 * Found an invalid block to be used.
+	 * Can recycle only if iosize is block size
+	 */
+	if (eio_to_sector(ebio->eb_size) == dmc->block_size) {
+		EIO_ASSERT(cstate & INVALID);
+		EIO_CACHE_STATE_SET(dmc, index, VALID | DISKREADINPROG);
+		atomic64_inc(&dmc->eio_stats.cached_blocks);
+		EIO_DBN_SET(dmc, index, (sector_t)ebio->eb_sector);
+		ebio->eb_index = index;
+		ebio->eb_bc->bc_dir = UNCACHED_READ_AND_READFILL;
+	}
+
+out:
+
+	spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+			       flags);
+
+	/*
+	 * Enqueue clean set if there is no room in the set
+	 * TBD
+	 * Ensure, a force clean
+	 */
+	if (res < 0)
+		eio_comply_dirty_thresholds(dmc, ebio->eb_cacheset);
+
+	return retval;
+}
+
+/*
+ * Checks the cache block state, for deciding cached/uncached write.
+ * Also reserves/allocates the cache block, wherever necessary.
+ *
+ * Return values
+ * 1: cache block is available or newly allocated
+ * 0: cache block could not be got for the ebio
+ */
+static int eio_write_peek(struct cache_c *dmc, struct eio_bio *ebio)
+{
+	index_t index;
+	int res;
+	int retval;
+	u_int8_t cstate;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dmc->cache_sets[ebio->eb_cacheset].cs_lock, flags);
+
+	res = eio_lookup(dmc, ebio, &index);
+	ebio->eb_index = -1;
+	retval = 0;
+
+	if (res < 0) {
+		/* cache block not found and new block couldn't be allocated */
+		atomic64_inc(&dmc->eio_stats.noroom);
+		ebio->eb_iotype |= EB_INVAL;
+		goto out;
+	}
+
+	cstate = EIO_CACHE_STATE_GET(dmc, index);
+
+	if (cstate & (BLOCK_IO_INPROG | QUEUED)) {
+		ebio->eb_iotype |= EB_INVAL;
+		/* treat as if cache block is not available */
+		goto out;
+	}
+
+	if ((res == VALID) && (EIO_DBN_GET(dmc, index) ==
+			       EIO_ROUND_SECTOR(dmc, ebio->eb_sector))) {
+		/*
+		 * Cache hit.
+		 * All except an already DIRTY block should have an INPROG flag.
+		 * If it is a cached write, a DIRTY flag would be added later.
+		 */
+		SECTOR_STATS(dmc->eio_stats.write_hits, ebio->eb_size);
+		if (cstate != ALREADY_DIRTY)
+			EIO_CACHE_STATE_ON(dmc, index, CACHEWRITEINPROG);
+		else
+			atomic64_inc(&dmc->eio_stats.dirty_write_hits);
+		ebio->eb_index = index;
+		/*
+		 * A VALID block should get upgraded to DIRTY, only when we
+		 * are updating the entire cache block(not partially).
+		 * Otherwise, 2 sequential partial writes can lead to missing
+		 * data when one write upgrades the cache block to DIRTY, while
+		 * the other just writes to HDD. Subsequent read would be
+		 * served from the cache block, which won't have the data from
+		 * 2nd write.
+		 */
+		if ((cstate == ALREADY_DIRTY) ||
+		    (eio_to_sector(ebio->eb_size) == dmc->block_size))
+			retval = 1;
+		else
+			retval = 0;
+		goto out;
+
+	}
+
+	/*
+	 * cache miss with a new block allocated for recycle.
+	 * Set INPROG flag, if the ebio size is equal to cache block size
+	 */
+	EIO_ASSERT(!(EIO_CACHE_STATE_GET(dmc, index) & DIRTY));
+	if (eio_to_sector(ebio->eb_size) == dmc->block_size) {
+		if (res == VALID)
+			atomic64_inc(&dmc->eio_stats.wr_replace);
+		else
+			atomic64_inc(&dmc->eio_stats.cached_blocks);
+		EIO_CACHE_STATE_SET(dmc, index, VALID | CACHEWRITEINPROG);
+		EIO_DBN_SET(dmc, index, (sector_t)ebio->eb_sector);
+		ebio->eb_index = index;
+		retval = 1;
+	} else {
+		/*
+		 * eb iosize smaller than cache block size shouldn't
+		 * do cache write on a cache miss
+		 */
+		retval = 0;
+		ebio->eb_iotype |= EB_INVAL;
+	}
+
+out:
+	if ((retval == 1) && (dmc->mode == CACHE_MODE_WB) &&
+	    (cstate != ALREADY_DIRTY))
+		ebio->eb_bc->bc_mdwait++;
+
+	spin_unlock_irqrestore(&dmc->cache_sets[ebio->eb_cacheset].cs_lock,
+			       flags);
+
+	/*
+	 * Enqueue clean set if there is no room in the set
+	 * TBD
+	 * Ensure, a force clean
+	 */
+	if (res < 0)
+		eio_comply_dirty_thresholds(dmc, ebio->eb_cacheset);
+
+	return retval;
+}
+
+/* Top level read function, called from eio_map */
+static void
+eio_read(struct cache_c *dmc, struct bio_container *bc, struct eio_bio *ebegin)
+{
+	int ucread = 0;
+	struct eio_bio *ebio;
+	struct eio_bio *enext;
+
+	bc->bc_dir = UNCACHED_READ;
+	ebio = ebegin;
+	while (ebio) {
+		enext = ebio->eb_next;
+		if (eio_read_peek(dmc, ebio) == 0)
+			ucread = 1;
+		ebio = enext;
+	}
+
+	if (ucread) {
+		/*
+		 * Uncached read.
+		 * Start HDD I/O. Once that is finished
+		 * readfill or dirty block re-read would start
+		 */
+		atomic64_inc(&dmc->eio_stats.uncached_reads);
+		eio_disk_io(dmc, bc->bc_bio, ebegin, bc, 0);
+	} else {
+		/* Cached read. Serve the read from SSD */
+
+		/*
+		 * Pass all orig bio flags except UNPLUG.
+		 * Unplug in the end if flagged.
+		 */
+		int rw_flags;
+
+		rw_flags = 0;
+
+		bc->bc_dir = CACHED_READ;
+		ebio = ebegin;
+
+		VERIFY_BIO_FLAGS(ebio);
+
+		EIO_ASSERT((rw_flags & 1) == READ);
+		while (ebio) {
+			enext = ebio->eb_next;
+			ebio->eb_iotype = EB_MAIN_IO;
+
+			eio_cached_read(dmc, ebio, rw_flags);
+			ebio = enext;
+		}
+	}
+}
+
+/* Top level write function called from eio_map */
+static void
+eio_write(struct cache_c *dmc, struct bio_container *bc, struct eio_bio *ebegin)
+{
+	int ucwrite = 0;
+	int error = 0;
+	struct eio_bio *ebio;
+	struct eio_bio *enext;
+
+	if ((dmc->mode != CACHE_MODE_WB) ||
+	    (dmc->sysctl_active.do_clean & EIO_CLEAN_KEEP))
+		ucwrite = 1;
+
+	ebio = ebegin;
+	while (ebio) {
+		enext = ebio->eb_next;
+		if (eio_write_peek(dmc, ebio) == 0)
+			ucwrite = 1;
+		ebio = enext;
+	}
+
+	if (ucwrite) {
+		/*
+		 * Uncached write.
+		 * Start both SSD and HDD writes
+		 */
+		atomic64_inc(&dmc->eio_stats.uncached_writes);
+		bc->bc_mdwait = 0;
+		bc->bc_dir = UNCACHED_WRITE;
+		ebio = ebegin;
+		while (ebio) {
+			enext = ebio->eb_next;
+			eio_uncached_write(dmc, ebio);
+			ebio = enext;
+		}
+
+		eio_disk_io(dmc, bc->bc_bio, ebegin, bc, 0);
+	} else {
+		/* Cached write. Start writes to SSD blocks */
+
+		int rw_flags;
+		rw_flags = 0;
+
+		bc->bc_dir = CACHED_WRITE;
+		if (bc->bc_mdwait) {
+
+			/*
+			 * mdreqs are required only if the write would cause a metadata
+			 * update.
+			 */
+
+			error = eio_alloc_mdreqs(dmc, bc);
+		}
+
+		/*
+		 * Pass all orig bio flags except UNPLUG.
+		 * UNPLUG in the end if flagged.
+		 */
+		ebio = ebegin;
+		VERIFY_BIO_FLAGS(ebio);
+
+		while (ebio) {
+			enext = ebio->eb_next;
+			ebio->eb_iotype = EB_MAIN_IO;
+
+			if (!error) {
+
+				eio_cached_write(dmc, ebio, WRITE | rw_flags);
+
+			} else {
+				unsigned long flags;
+				u_int8_t cstate;
+
+				pr_err
+					("eio_write: IO submission failed, block %llu",
+					EIO_DBN_GET(dmc, ebio->eb_index));
+				spin_lock_irqsave(&dmc->
+						  cache_sets[ebio->eb_cacheset].
+						  cs_lock, flags);
+				cstate =
+					EIO_CACHE_STATE_GET(dmc, ebio->eb_index);
+				if (cstate != ALREADY_DIRTY) {
+
+					/*
+					 * A DIRTY(inprog) block should be invalidated on error.
+					 */
+
+					EIO_CACHE_STATE_SET(dmc, ebio->eb_index,
+							    INVALID);
+					atomic64_dec_if_positive(&dmc->
+								 eio_stats.
+								 cached_blocks);
+				}
+				spin_unlock_irqrestore(&dmc->
+						       cache_sets[ebio->
+								  eb_cacheset].
+						       cs_lock, flags);
+				eb_endio(ebio, error);
+			}
+			ebio = enext;
+		}
+	}
+}
+
+/*
+ * Synchronous clean of all the cache sets. Callers of this function needs
+ * to handle the situation that clean operation was aborted midway.
+ */
+
+void eio_clean_all(struct cache_c *dmc)
+{
+	unsigned long flags = 0;
+
+	EIO_ASSERT(dmc->mode == CACHE_MODE_WB);
+	for (atomic_set(&dmc->clean_index, 0);
+	     (atomic_read(&dmc->clean_index) <
+	      (s32)(dmc->size >> dmc->consecutive_shift))
+	     && (dmc->sysctl_active.do_clean & EIO_CLEAN_START)
+	     && (atomic64_read(&dmc->nr_dirty) > 0)
+	     && (!(dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG)
+		 && !dmc->sysctl_active.fast_remove);
+	     atomic_inc(&dmc->clean_index)) {
+
+		if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+			pr_err("clean_all: CACHE \"%s\" is in FAILED state.",
+			       dmc->cache_name);
+			break;
+		}
+
+		eio_clean_set(dmc, (index_t)(atomic_read(&dmc->clean_index)),
+				/* whole */ 1, /* force */ 1);
+	}
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+	dmc->sysctl_active.do_clean &= ~EIO_CLEAN_START;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+}
+
+/*
+ * Do unconditional clean of a cache.
+ * Useful for a cold enabled writeback cache.
+ */
+void eio_clean_for_reboot(struct cache_c *dmc)
+{
+	index_t i;
+
+	for (i = 0; i < (index_t)(dmc->size >> dmc->consecutive_shift); i++)
+		eio_clean_set(dmc, i, /* whole */ 1, /* force */ 1);
+}
+
+/*
+ * Used during the partial cache set clean.
+ * Uses reclaim policy(LRU/FIFO) information to
+ * identify the cache blocks that needs cleaning.
+ * The number of such cache blocks is determined
+ * by the high and low thresholds set.
+ */
+static void
+eio_get_setblks_to_clean(struct cache_c *dmc, index_t set, int *ncleans)
+{
+	int i = 0;
+	int max_clean;
+	index_t start_index;
+	int nr_writes = 0;
+
+	*ncleans = 0;
+
+	max_clean = dmc->cache_sets[set].nr_dirty -
+		    ((dmc->sysctl_active.dirty_set_low_threshold * dmc->assoc) / 100);
+	if (max_clean <= 0)
+		/* Nothing to clean */
+		return;
+
+	start_index = set * dmc->assoc;
+
+	/*
+	 * Spinlock is not required here, as we assume that we have
+	 * taken a write lock on the cache set, when we reach here
+	 */
+	if (dmc->policy_ops == NULL) {
+		/* Scan sequentially in the set and pick blocks to clean */
+		while ((i < (int)dmc->assoc) && (nr_writes < max_clean)) {
+			if ((EIO_CACHE_STATE_GET(dmc, start_index + i) &
+			     (DIRTY | BLOCK_IO_INPROG)) == DIRTY) {
+				EIO_CACHE_STATE_ON(dmc, start_index + i,
+						   DISKWRITEINPROG);
+				nr_writes++;
+			}
+			i++;
+		}
+	} else
+		nr_writes =
+			eio_policy_clean_set(dmc->policy_ops, set, max_clean);
+
+	*ncleans = nr_writes;
+}
+
+/* Callback function, when synchronous I/O completes */
+static void eio_sync_io_callback(int error, void *context)
+{
+	struct sync_io_context *sioc = (struct sync_io_context *)context;
+
+	if (error)
+		sioc->sio_error = error;
+	up_read(&sioc->sio_lock);
+}
+
+/*
+ * Setup biovecs for preallocated biovecs per cache set.
+ */
+
+struct bio_vec *setup_bio_vecs(struct bio_vec *bvec, index_t block_index,
+			       unsigned block_size, unsigned total,
+			       unsigned *num_bvecs)
+{
+	struct bio_vec *data = NULL;
+	index_t iovec_index;
+
+	switch (block_size) {
+	case BLKSIZE_2K:
+		*num_bvecs = total;
+		iovec_index = block_index;
+		data = &bvec[iovec_index];
+		break;
+
+	case BLKSIZE_4K:
+		*num_bvecs = total;
+		iovec_index = block_index;
+		data = &bvec[iovec_index];
+		break;
+
+	case BLKSIZE_8K:
+		/*
+		 * For 8k data block size, we need 2 bio_vecs
+		 * per data block.
+		 */
+		*num_bvecs = total * 2;
+		iovec_index = block_index * 2;
+		data = &bvec[iovec_index];
+		break;
+	}
+
+	return data;
+}
+
+/* Cleans a given cache set */
+static void
+eio_clean_set(struct cache_c *dmc, index_t set, int whole, int force)
+{
+	struct eio_io_region where;
+	int error;
+	index_t i;
+	index_t j;
+	index_t start_index;
+	index_t end_index;
+	struct sync_io_context sioc;
+	int ncleans = 0;
+	int alloc_size;
+	struct flash_cacheblock *md_blocks = NULL;
+	unsigned long flags;
+
+	int pindex, k;
+	index_t blkindex;
+	struct bio_vec *bvecs;
+	unsigned nr_bvecs = 0, total;
+	void *pg_virt_addr[2] = { NULL };
+
+	/* Cache is failed mode, do nothing. */
+	if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+		pr_debug("clean_set: CACHE \"%s\" is in FAILED state.",
+			 dmc->cache_name);
+		goto err_out1;
+	}
+
+	/* Nothing to clean, if there are no dirty blocks */
+	if (dmc->cache_sets[set].nr_dirty == 0)
+		goto err_out1;
+
+	/* If this is not the suitable time to clean, postpone it */
+	if ((!force) && AUTOCLEAN_THRESHOLD_CROSSED(dmc)) {
+		eio_touch_set_lru(dmc, set);
+		goto err_out1;
+	}
+
+	/*
+	 * 1. Take exclusive lock on the cache set
+	 * 2. Verify that there are dirty blocks to clean
+	 * 3. Identify the cache blocks to clean
+	 * 4. Read the cache blocks data from ssd
+	 * 5. Write the cache blocks data to hdd
+	 * 6. Update on-disk cache metadata
+	 * 7. Update in-core cache metadata
+	 */
+
+	start_index = set * dmc->assoc;
+	end_index = start_index + dmc->assoc;
+
+	/* 1. exclusive lock. Let the ongoing writes to finish. Pause new writes */
+	down_write(&dmc->cache_sets[set].rw_lock);
+
+	/* 2. Return if there are no dirty blocks to clean */
+	if (dmc->cache_sets[set].nr_dirty == 0)
+		goto err_out2;
+
+	/* 3. identify and mark cache blocks to clean */
+	if (!whole)
+		eio_get_setblks_to_clean(dmc, set, &ncleans);
+	else {
+		for (i = start_index; i < end_index; i++) {
+			if (EIO_CACHE_STATE_GET(dmc, i) == ALREADY_DIRTY) {
+				EIO_CACHE_STATE_SET(dmc, i, CLEAN_INPROG);
+				ncleans++;
+			}
+		}
+	}
+
+	/* If nothing to clean, return */
+	if (!ncleans)
+		goto err_out2;
+
+	/*
+	 * From this point onwards, make sure to reset
+	 * the clean inflag on cache blocks before returning
+	 */
+
+	/* 4. read cache set data */
+
+	init_rwsem(&sioc.sio_lock);
+	sioc.sio_error = 0;
+
+	for (i = start_index; i < end_index; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, i) == CLEAN_INPROG) {
+
+			for (j = i; ((j < end_index) &&
+				(EIO_CACHE_STATE_GET(dmc, j) == CLEAN_INPROG));
+				j++);
+
+			blkindex = (i - start_index);
+			total = (j - i);
+
+			/*
+			 * Get the correct index and number of bvecs
+			 * setup from dmc->clean_dbvecs before issuing i/o.
+			 */
+			bvecs =
+				setup_bio_vecs(dmc->clean_dbvecs, blkindex,
+					       dmc->block_size, total, &nr_bvecs);
+			EIO_ASSERT(bvecs != NULL);
+			EIO_ASSERT(nr_bvecs > 0);
+
+			where.bdev = dmc->cache_dev->bdev;
+			where.sector =
+				(i << dmc->block_shift) + dmc->md_sectors;
+			where.count = total * dmc->block_size;
+
+			SECTOR_STATS(dmc->eio_stats.ssd_reads,
+				     to_bytes(where.count));
+			down_read(&sioc.sio_lock);
+			error =
+				eio_io_async_bvec(dmc, &where, READ, bvecs,
+						  nr_bvecs, eio_sync_io_callback,
+						  &sioc, 0);
+			if (error) {
+				sioc.sio_error = error;
+				up_read(&sioc.sio_lock);
+			}
+
+			bvecs = NULL;
+			i = j;
+		}
+	}
+	/*
+	 * In above for loop, submit all READ I/Os to SSD
+	 * and unplug the device for immediate submission to
+	 * underlying device driver.
+	 */
+	eio_unplug_cache_device(dmc);
+
+	/* wait for all I/Os to complete and release sync lock */
+	down_write(&sioc.sio_lock);
+	up_write(&sioc.sio_lock);
+
+	error = sioc.sio_error;
+	if (error)
+		goto err_out3;
+
+	/* 5. write to hdd */
+	/*
+	 * While writing the data to HDD, explicitly enable
+	 * BIO_RW_SYNC flag to hint higher priority for these
+	 * I/Os.
+	 */
+	for (i = start_index; i < end_index; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, i) == CLEAN_INPROG) {
+
+			blkindex = (i - start_index);
+			total = 1;
+
+			bvecs =
+				setup_bio_vecs(dmc->clean_dbvecs, blkindex,
+					       dmc->block_size, total, &nr_bvecs);
+			EIO_ASSERT(bvecs != NULL);
+			EIO_ASSERT(nr_bvecs > 0);
+
+			where.bdev = dmc->disk_dev->bdev;
+			where.sector = EIO_DBN_GET(dmc, i);
+			where.count = dmc->block_size;
+
+			SECTOR_STATS(dmc->eio_stats.disk_writes,
+				     to_bytes(where.count));
+			down_read(&sioc.sio_lock);
+			error = eio_io_async_bvec(dmc, &where, WRITE | REQ_SYNC,
+						  bvecs, nr_bvecs,
+						  eio_sync_io_callback, &sioc,
+						  1);
+
+			if (error) {
+				sioc.sio_error = error;
+				up_read(&sioc.sio_lock);
+			}
+			bvecs = NULL;
+		}
+	}
+
+	/* wait for all I/Os to complete and release sync lock */
+	down_write(&sioc.sio_lock);
+	up_write(&sioc.sio_lock);
+
+	error = sioc.sio_error;
+	if (error)
+		goto err_out3;
+
+	/* 6. update on-disk cache metadata */
+
+	/* TBD. Do we have to consider sector alignment here ? */
+
+	/*
+	 * md_size = dmc->assoc * sizeof(struct flash_cacheblock);
+	 * Currently, md_size is 8192 bytes, mdpage_count is 2 pages maximum.
+	 */
+
+	EIO_ASSERT(dmc->mdpage_count <= 2);
+	for (k = 0; k < dmc->mdpage_count; k++)
+		pg_virt_addr[k] = kmap(dmc->clean_mdpages[k]);
+
+	alloc_size = dmc->assoc * sizeof(struct flash_cacheblock);
+	pindex = 0;
+	md_blocks = (struct flash_cacheblock *)pg_virt_addr[pindex];
+	k = MD_BLOCKS_PER_PAGE;
+
+	for (i = start_index; i < end_index; i++) {
+
+		md_blocks->dbn = cpu_to_le64(EIO_DBN_GET(dmc, i));
+
+		if (EIO_CACHE_STATE_GET(dmc, i) == CLEAN_INPROG)
+			md_blocks->cache_state = cpu_to_le64(INVALID);
+		else if (EIO_CACHE_STATE_GET(dmc, i) == ALREADY_DIRTY)
+			md_blocks->cache_state = cpu_to_le64((VALID | DIRTY));
+		else
+			md_blocks->cache_state = cpu_to_le64(INVALID);
+
+		/* This was missing earlier. */
+		md_blocks++;
+		k--;
+
+		if (k == 0) {
+			md_blocks =
+				(struct flash_cacheblock *)pg_virt_addr[++pindex];
+			k = MD_BLOCKS_PER_PAGE;
+		}
+	}
+
+	for (k = 0; k < dmc->mdpage_count; k++)
+		kunmap(dmc->clean_mdpages[k]);
+
+	where.bdev = dmc->cache_dev->bdev;
+	where.sector = dmc->md_start_sect + INDEX_TO_MD_SECTOR(start_index);
+	where.count = eio_to_sector(alloc_size);
+	error =
+		eio_io_sync_pages(dmc, &where, WRITE, dmc->clean_mdpages,
+				  dmc->mdpage_count);
+
+	if (error)
+		goto err_out3;
+
+err_out3:
+
+	/*
+	 * 7. update in-core cache metadata for clean_inprog blocks.
+	 * If there was an error, set them back to ALREADY_DIRTY
+	 * If no error, set them to VALID
+	 */
+	for (i = start_index; i < end_index; i++) {
+		if (EIO_CACHE_STATE_GET(dmc, i) == CLEAN_INPROG) {
+			if (error)
+				EIO_CACHE_STATE_SET(dmc, i, ALREADY_DIRTY);
+			else {
+				EIO_CACHE_STATE_SET(dmc, i, VALID);
+				EIO_ASSERT(dmc->cache_sets[set].nr_dirty > 0);
+				dmc->cache_sets[set].nr_dirty--;
+				atomic64_dec(&dmc->nr_dirty);
+			}
+		}
+	}
+
+err_out2:
+
+	up_write(&dmc->cache_sets[set].rw_lock);
+
+err_out1:
+
+	/* Reset clean flags on the set */
+
+	if (!force) {
+		spin_lock_irqsave(&dmc->cache_sets[set].cs_lock, flags);
+		dmc->cache_sets[set].flags &=
+			~(SETFLAG_CLEAN_INPROG | SETFLAG_CLEAN_WHOLE);
+		spin_unlock_irqrestore(&dmc->cache_sets[set].cs_lock, flags);
+	}
+
+	if (dmc->cache_sets[set].nr_dirty)
+		/*
+		 * Lru touch the set, so that it can be picked
+		 * up for whole set clean by clean thread later
+		 */
+		eio_touch_set_lru(dmc, set);
+
+	return;
+}
+
+/*
+ * Enqueues the dirty sets for clean, which had got dirtied long
+ * time back(aged). User tunable values to determine if a set has aged
+ */
+void eio_clean_aged_sets(struct work_struct *work)
+{
+	struct cache_c *dmc;
+	unsigned long flags = 0;
+	index_t set_index;
+	u_int64_t set_time;
+	u_int64_t cur_time;
+
+	dmc = container_of(work, struct cache_c, clean_aged_sets_work.work);
+
+	/*
+	 * In FAILED state, dont schedule cleaning of sets.
+	 */
+	if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+		pr_debug("clean_aged_sets: Cache \"%s\" is in failed mode.\n",
+			 dmc->cache_name);
+		/*
+		 * This is to make sure that this thread is rescheduled
+		 * once CACHE is ACTIVE again.
+		 */
+		spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+		dmc->is_clean_aged_sets_sched = 0;
+		spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+
+		return;
+	}
+
+	cur_time = jiffies;
+
+	/* Use the set LRU list to pick up the most aged sets. */
+	spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+	do {
+		lru_read_head(dmc->dirty_set_lru, &set_index, &set_time);
+		if (set_index == LRU_NULL)
+			break;
+
+		if ((EIO_DIV((cur_time - set_time), HZ)) <
+		    (dmc->sysctl_active.time_based_clean_interval * 60))
+			break;
+		lru_rem(dmc->dirty_set_lru, set_index);
+
+		if (dmc->cache_sets[set_index].nr_dirty > 0) {
+			spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+			eio_addto_cleanq(dmc, set_index, 1);
+			spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+		}
+	} while (1);
+	spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+
+	/* Re-schedule the aged set clean, unless the clean has to stop now */
+
+	if (dmc->sysctl_active.time_based_clean_interval == 0)
+		goto out;
+
+	schedule_delayed_work(&dmc->clean_aged_sets_work,
+			      dmc->sysctl_active.time_based_clean_interval *
+			      60 * HZ);
+out:
+	return;
+}
+
+/* Move the given set at the head of the set LRU list */
+void eio_touch_set_lru(struct cache_c *dmc, index_t set)
+{
+	u_int64_t systime;
+	unsigned long flags;
+
+	systime = jiffies;
+	spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+	lru_touch(dmc->dirty_set_lru, set, systime);
+
+	if ((dmc->sysctl_active.time_based_clean_interval > 0) &&
+	    (dmc->is_clean_aged_sets_sched == 0)) {
+		schedule_delayed_work(&dmc->clean_aged_sets_work,
+				      dmc->sysctl_active.
+				      time_based_clean_interval * 60 * HZ);
+		dmc->is_clean_aged_sets_sched = 1;
+	}
+
+	spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+}
diff --git a/drivers/block/enhanceio/eio_mem.c b/drivers/block/enhanceio/eio_mem.c
new file mode 100644
index 0000000..eddc852
--- /dev/null
+++ b/drivers/block/enhanceio/eio_mem.c
@@ -0,0 +1,236 @@
+/*
+ *  eio_mem.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+
+#define SECTORS_PER_SET         (dmc->assoc * dmc->block_size)
+#define SECTORS_PER_SET_SHIFT   (dmc->consecutive_shift + dmc->block_shift)
+#define SECTORS_PER_SET_MASK    (SECTORS_PER_SET - 1)
+
+#define EIO_DBN_TO_SET(dmc, dbn, set_number, wrapped)   do {		\
+		u_int64_t value;						\
+		u_int64_t mid_i;						\
+		value = (dbn) >> SECTORS_PER_SET_SHIFT;				\
+		mid_i = (value) & (dmc)->num_sets_mask;				\
+		if (mid_i >= (dmc)->num_sets) {					\
+			(wrapped) = 1;						\
+			(set_number) = mid_i - (dmc)->num_sets;			\
+		} else {							\
+			(wrapped) = 0;						\
+			(set_number) = mid_i;					\
+		}								\
+} while (0)
+
+/*
+ * eio_mem_init
+ */
+int eio_mem_init(struct cache_c *dmc)
+{
+	u_int32_t lsb_bits;
+	u_int32_t msb_bits_24;  /* most significant bits in shrunk dbn */
+	u_int64_t max_dbn;
+	u_int64_t num_sets_64;
+
+	/*
+	 * Sanity check the number of sets.
+	 */
+	num_sets_64 = EIO_DIV(dmc->size, dmc->assoc);
+	if (num_sets_64 > UINT_MAX) {
+		pr_err("Number of cache sets (%lu) greater than maximum" \
+		       "allowed (%u)",
+		       (long unsigned int)num_sets_64, UINT_MAX);
+		return -1;
+	}
+
+	/*
+	 * Find the number of bits required to encode the set number and
+	 * its corresponding mask value.
+	 */
+	dmc->num_sets = (u_int32_t)num_sets_64;
+	for (dmc->num_sets_bits = 0; (dmc->num_sets >> dmc->num_sets_bits);
+		dmc->num_sets_bits++);
+
+	dmc->num_sets_mask = ULLONG_MAX >> (64 - dmc->num_sets_bits);
+
+	/*
+	 * If we don't have at least 16 bits to save,
+	 * we can't use small metadata.
+	 */
+	if (dmc->num_sets_bits < 16) {
+		dmc->cache_flags |= CACHE_FLAGS_MD8;
+		pr_info("Not enough sets to use small metadata");
+		return 1;
+	}
+
+	/*
+	 * Now compute the largest sector number that we can shrink; then see
+	 * if the source volume is smaller.
+	 */
+	lsb_bits = dmc->consecutive_shift + dmc->block_shift;
+	msb_bits_24 = 24 - 1 - lsb_bits;        /* 1 for wrapped bit */
+	max_dbn =
+		((u_int64_t)1) << (msb_bits_24 + dmc->num_sets_bits + lsb_bits);
+	if (eio_to_sector(eio_get_device_size(dmc->disk_dev)) > max_dbn) {
+		dmc->cache_flags |= CACHE_FLAGS_MD8;
+		pr_info("Source volume too big to use small metadata");
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
+ * eio_hash_block
+ */
+u_int32_t eio_hash_block(struct cache_c *dmc, sector_t dbn)
+{
+	int wrapped;
+	u_int64_t set_number;
+
+	EIO_DBN_TO_SET(dmc, dbn, set_number, wrapped);
+	EIO_ASSERT(set_number < dmc->num_sets);
+
+	return (u_int32_t)set_number;
+}
+
+/*
+ * eio_shrink_dbn
+ *
+ * Shrink a 5-byte "dbn" into a 3-byte "dbn" by eliminating 16 lower bits
+ * of the set number this "dbn" belongs to.
+ */
+unsigned int eio_shrink_dbn(struct cache_c *dmc, sector_t dbn)
+{
+	u_int32_t dbn_24;
+	sector_t lsb;
+	sector_t wrapped;
+	sector_t msb;
+	sector_t set_number;
+
+	EIO_ASSERT(!EIO_MD8(dmc));
+	if (unlikely(dbn == 0))
+		return 0;
+
+	lsb = dbn & SECTORS_PER_SET_MASK;
+	EIO_DBN_TO_SET(dmc, dbn, set_number, wrapped);
+	msb = dbn >> (dmc->num_sets_bits + SECTORS_PER_SET_SHIFT);
+	dbn_24 =
+		(unsigned int)(lsb | (wrapped << SECTORS_PER_SET_SHIFT) |
+			       (msb << (SECTORS_PER_SET_SHIFT + 1)));
+
+	return dbn_24;
+}
+
+/*
+ * eio_expand_dbn
+ *
+ * Expand a 3-byte "dbn" into a 5-byte "dbn" by adding 16 lower bits
+ * of the set number this "dbn" belongs to.
+ */
+sector_t eio_expand_dbn(struct cache_c *dmc, u_int64_t index)
+{
+	u_int32_t dbn_24;
+	u_int64_t set_number;
+	sector_t lsb;
+	sector_t msb;
+	sector_t dbn_40;
+
+	EIO_ASSERT(!EIO_MD8(dmc));
+	/*
+	 * Expanding "dbn" zero?
+	 */
+	if (index == dmc->index_zero &&
+	    dmc->index_zero < (u_int64_t)dmc->assoc)
+		return 0;
+
+	dbn_24 = dmc->cache[index].md4_u.u_i_md4 & EIO_MD4_DBN_MASK;
+	if (dbn_24 == 0 && EIO_CACHE_STATE_GET(dmc, index) == INVALID)
+		return (sector_t)0;
+
+	set_number = EIO_DIV(index, dmc->assoc);
+	lsb = dbn_24 & SECTORS_PER_SET_MASK;
+	msb = dbn_24 >> (SECTORS_PER_SET_SHIFT + 1);    /* 1 for wrapped */
+	/* had we wrapped? */
+	if ((dbn_24 & SECTORS_PER_SET) != 0) {
+		dbn_40 = msb << (dmc->num_sets_bits + SECTORS_PER_SET_SHIFT);
+		dbn_40 |= (set_number + dmc->num_sets) << SECTORS_PER_SET_SHIFT;
+		dbn_40 |= lsb;
+	} else {
+		dbn_40 = msb << (dmc->num_sets_bits + SECTORS_PER_SET_SHIFT);
+		dbn_40 |= set_number << SECTORS_PER_SET_SHIFT;
+		dbn_40 |= lsb;
+	}
+	EIO_ASSERT(unlikely(dbn_40 < EIO_MAX_SECTOR));
+
+	return (sector_t)dbn_40;
+}
+EXPORT_SYMBOL(eio_expand_dbn);
+
+/*
+ * eio_invalidate_md
+ */
+void eio_invalidate_md(struct cache_c *dmc, u_int64_t index)
+{
+
+	if (EIO_MD8(dmc))
+		dmc->cache_md8[index].md8_u.u_i_md8 = EIO_MD8_INVALID;
+	else
+		dmc->cache[index].md4_u.u_i_md4 = EIO_MD4_INVALID;
+}
+
+/*
+ * eio_md4_dbn_set
+ */
+void eio_md4_dbn_set(struct cache_c *dmc, u_int64_t index, u_int32_t dbn_24)
+{
+
+	EIO_ASSERT((dbn_24 & ~EIO_MD4_DBN_MASK) == 0);
+
+	/* retain "cache_state" */
+	dmc->cache[index].md4_u.u_i_md4 &= ~EIO_MD4_DBN_MASK;
+	dmc->cache[index].md4_u.u_i_md4 |= dbn_24;
+
+	/* XXX excessive debugging */
+	if (dmc->index_zero < (u_int64_t)dmc->assoc &&  /* sector 0 cached */
+	    index == dmc->index_zero &&                 /* we're accessing sector 0 */
+	    dbn_24 != 0)                                /* we're replacing sector 0 */
+		dmc->index_zero = dmc->assoc;
+}
+
+/*
+ * eio_md8_dbn_set
+ */
+void eio_md8_dbn_set(struct cache_c *dmc, u_int64_t index, sector_t dbn)
+{
+
+	EIO_ASSERT((dbn & ~EIO_MD8_DBN_MASK) == 0);
+
+	/* retain "cache_state" */
+	dmc->cache_md8[index].md8_u.u_i_md8 &= ~EIO_MD8_DBN_MASK;
+	dmc->cache_md8[index].md8_u.u_i_md8 |= dbn;
+
+	/* XXX excessive debugging */
+	if (dmc->index_zero < (u_int64_t)dmc->assoc &&  /* sector 0 cached */
+	    index == dmc->index_zero &&                 /* we're accessing sector 0 */
+	    dbn != 0)                                   /* we're replacing sector 0 */
+		dmc->index_zero = dmc->assoc;
+}
diff --git a/drivers/block/enhanceio/eio_policy.c b/drivers/block/enhanceio/eio_policy.c
new file mode 100644
index 0000000..0fa6d23
--- /dev/null
+++ b/drivers/block/enhanceio/eio_policy.c
@@ -0,0 +1,146 @@
+/*
+ *  eio_policy.c
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+
+LIST_HEAD(eio_policy_list);
+
+int eio_register_policy(struct eio_policy_header *new_policy)
+{
+	struct list_head *ptr;
+	struct eio_policy_header *curr;
+
+	list_for_each(ptr, &eio_policy_list) {
+		curr = list_entry(ptr, struct eio_policy_header, sph_list);
+		if (curr->sph_name == new_policy->sph_name)
+			return 1;
+	}
+	list_add_tail(&new_policy->sph_list, &eio_policy_list);
+
+	pr_info("register_policy: policy %d added", new_policy->sph_name);
+
+	return 0;
+}
+EXPORT_SYMBOL(eio_register_policy);
+
+int eio_unregister_policy(struct eio_policy_header *p_ops)
+{
+	struct list_head *ptr;
+	struct eio_policy_header *curr;
+
+	list_for_each(ptr, &eio_policy_list) {
+		curr = list_entry(ptr, struct eio_policy_header, sph_list);
+		if (curr->sph_name == p_ops->sph_name) {
+			list_del(&curr->sph_list);
+			pr_info("unregister_policy: policy %d removed",
+				(int)p_ops->sph_name);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL(eio_unregister_policy);
+
+struct eio_policy *eio_get_policy(int policy)
+{
+	struct list_head *ptr;
+	struct eio_policy_header *curr;
+
+	list_for_each(ptr, &eio_policy_list) {
+		curr = list_entry(ptr, struct eio_policy_header, sph_list);
+		if (curr->sph_name == policy) {
+			pr_info("get_policy: policy %d found", policy);
+			return curr->sph_instance_init();
+		}
+	}
+	pr_info("get_policy: cannot find policy %d", policy);
+
+	return NULL;
+}
+
+/*
+ * Decrement the reference count of the policy specific module
+ * and any other cleanup that is required when an instance of a
+ * policy is no longer required.
+ */
+void eio_put_policy(struct eio_policy *p_ops)
+{
+
+	if (p_ops == NULL) {
+		pr_err("put_policy: Cannot decrement reference"	\
+		       "count of NULL policy");
+		return;
+	}
+	p_ops->sp_repl_exit();
+}
+
+/*
+ * Wrappers for policy specific functions. These default to nothing if the
+ * default policy is being used.
+ */
+int eio_repl_sets_init(struct eio_policy *p_ops)
+{
+
+	return (p_ops &&
+		p_ops->sp_repl_sets_init) ? p_ops->sp_repl_sets_init(p_ops) : 0;
+}
+
+int eio_repl_blk_init(struct eio_policy *p_ops)
+{
+
+	return (p_ops &&
+		p_ops->sp_repl_blk_init) ? p_ops->sp_repl_blk_init(p_ops) : 0;
+}
+
+void
+eio_find_reclaim_dbn(struct eio_policy *p_ops,
+		     index_t start_index, index_t *index)
+{
+
+	p_ops->sp_find_reclaim_dbn(p_ops, start_index, index);
+}
+
+int eio_policy_clean_set(struct eio_policy *p_ops, index_t set, int to_clean)
+{
+
+	return p_ops->sp_clean_set(p_ops, set, to_clean);
+}
+
+/*
+ * LRU Specific functions
+ */
+void eio_policy_lru_pushblks(struct eio_policy *p_ops)
+{
+
+	if (p_ops && p_ops->sp_name == CACHE_REPL_LRU)
+		p_ops->sp_policy.lru->sl_lru_pushblks(p_ops);
+}
+
+void
+eio_policy_reclaim_lru_movetail(struct cache_c *dmc, index_t i,
+				struct eio_policy *p_ops)
+{
+
+	if (p_ops && p_ops->sp_name == CACHE_REPL_LRU)
+		p_ops->sp_policy.lru->sl_reclaim_lru_movetail(dmc, i, p_ops);
+}
diff --git a/drivers/block/enhanceio/eio_policy.h b/drivers/block/enhanceio/eio_policy.h
new file mode 100644
index 0000000..460ac79
--- /dev/null
+++ b/drivers/block/enhanceio/eio_policy.h
@@ -0,0 +1,105 @@
+/*
+ *  eio_policy.h
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef EIO_POLICY_H
+#define EIO_POLICY_H
+
+#include <linux/module.h>
+#include <linux/list.h>
+
+/*
+ * Defines for policy types (EIO_REPL_XXX are in eio.h
+ * so that user space utilties can use those definitions.
+ */
+
+/*
+ * The LRU pointers are maintained as set-relative offsets, instead of
+ * pointers. This enables us to store the LRU pointers per cacheblock
+ * using 4 bytes instead of 16 bytes. The upshot of this is that we
+ * are required to clamp the associativity at an 8K max.
+ *
+ * XXX - The above comment is from the original code. Looks like an error,
+ * maximum associativity should be 32K (2^15) and not 8K.
+ */
+#define EIO_MAX_ASSOC   8192
+#define EIO_LRU_NULL    0xFFFF
+
+/* Declerations to keep the compiler happy */
+struct cache_c;
+struct eio_policy;
+struct eio_lru;
+
+/* LRU specific data structures and functions */
+struct eio_lru {
+	void (*sl_lru_pushblks)(struct eio_policy *);
+	void (*sl_reclaim_lru_movetail)(struct cache_c *, index_t,
+					struct eio_policy *);
+};
+
+/* Function prototypes for LRU wrappers in eio_policy.c */
+void eio_policy_lru_pushblks(struct eio_policy *);
+void eio_policy_reclaim_lru_movetail(struct cache_c *, index_t,
+				     struct eio_policy *);
+
+/*
+ * Context that captures the cache block replacement policy.
+ * There is one instance of this struct per dmc (cache)
+ */
+struct eio_policy {
+	int sp_name;
+	union {
+		struct eio_lru *lru;
+	} sp_policy;
+	int (*sp_repl_init)(struct cache_c *);
+	void (*sp_repl_exit)(void);
+	int (*sp_repl_sets_init)(struct eio_policy *);
+	int (*sp_repl_blk_init)(struct eio_policy *);
+	void (*sp_find_reclaim_dbn)(struct eio_policy *,
+				    index_t start_index, index_t *index);
+	int (*sp_clean_set)(struct eio_policy *, index_t set, int);
+	struct cache_c *sp_dmc;
+};
+
+/*
+ * List of registered policies. There is one instance
+ * of this structure per policy type.
+ */
+struct eio_policy_header {
+	int sph_name;
+	struct eio_policy *(*sph_instance_init)(void);
+	struct list_head sph_list;
+};
+
+/* Prototypes of generic functions in eio_policy */
+int *eio_repl_init(struct cache_c *);
+int eio_repl_sets_init(struct eio_policy *);
+int eio_repl_blk_init(struct eio_policy *);
+void eio_find_reclaim_dbn(struct eio_policy *, index_t start_index,
+			  index_t *index);
+int eio_policy_clean_set(struct eio_policy *, index_t, int);
+
+int eio_register_policy(struct eio_policy_header *);
+int eio_unregister_policy(struct eio_policy_header *);
+struct eio_policy *eio_get_policy(int);
+void eio_put_policy(struct eio_policy *);
+
+#endif                          /* EIO_POLICY_H */
diff --git a/drivers/block/enhanceio/eio_procfs.c b/drivers/block/enhanceio/eio_procfs.c
new file mode 100644
index 0000000..c13b4f3
--- /dev/null
+++ b/drivers/block/enhanceio/eio_procfs.c
@@ -0,0 +1,1949 @@
+/*
+ *  eio_procfs.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+#define EIO_RELEASE "ENHANCEIO"
+
+#ifndef ENHANCEIO_GIT_COMMIT_HASH
+#define ENHANCEIO_GIT_COMMIT_HASH "unknown-git-version"
+#endif                          /* !ENHANCEIO_GIT_COMMIT_HASH */
+
+int eio_version_query(size_t buf_sz, char *bufp)
+{
+	if (unlikely(buf_sz == 0) || unlikely(bufp == NULL))
+		return -EINVAL;
+	snprintf(bufp, buf_sz, "EnhanceIO Version: %s %s (checksum disabled)",
+		 EIO_RELEASE, ENHANCEIO_GIT_COMMIT_HASH);
+
+	bufp[buf_sz - 1] = '\0';
+
+	return 0;
+}
+
+static struct sysctl_table_dir *sysctl_handle_dir;
+
+/*
+ * eio_zerostats_sysctl
+ */
+static int
+eio_zerostats_sysctl(ctl_table *table, int write, void __user *buffer,
+		     size_t *length, loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	long long cached_blocks;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.zerostats = dmc->sysctl_active.zerostats;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		/* do sanity check */
+
+		if ((dmc->sysctl_pending.zerostats != 0) &&
+		    (dmc->sysctl_pending.zerostats != 1)) {
+			pr_err
+				("0 or 1 are the only valid values for zerostats");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.zerostats ==
+		    dmc->sysctl_active.zerostats)
+			/* same value. Nothing to work */
+			return 0;
+
+		/* Copy to active */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_active.zerostats = dmc->sysctl_pending.zerostats;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		if (dmc->sysctl_active.zerostats) {
+			/*
+			 * The number of cached blocks should not be zero'd since
+			 * these blocks are already on cache dev. Making this zero
+			 * may lead to -ve count during block invalidate, and also,
+			 * incorrectly indicating how much data is cached.
+			 *
+			 * TODO - should have used an spinlock, but existing spinlocks
+			 * are inadequate to fully protect this
+			 */
+
+			cached_blocks =
+				atomic64_read(&dmc->eio_stats.cached_blocks);
+			memset(&dmc->eio_stats, 0, sizeof(struct eio_stats));
+			atomic64_set(&dmc->eio_stats.cached_blocks,
+				     cached_blocks);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * eio_mem_limit_pct_sysctl
+ * - sets the eio sysctl mem_limit_pct value
+ */
+static int
+eio_mem_limit_pct_sysctl(ctl_table *table, int write, void __user *buffer,
+			 size_t *length, loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.mem_limit_pct =
+			dmc->sysctl_active.mem_limit_pct;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		/* do sanity check */
+		if ((dmc->sysctl_pending.mem_limit_pct < 0) ||
+		    (dmc->sysctl_pending.mem_limit_pct > 100)) {
+			pr_err
+				("only valid percents are [0 - 100] for mem_limit_pct");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.mem_limit_pct ==
+		    dmc->sysctl_active.mem_limit_pct)
+			/* same value. Nothing more to do */
+			return 0;
+
+		/* Copy to active */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_active.mem_limit_pct =
+			dmc->sysctl_pending.mem_limit_pct;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	return 0;
+}
+
+/*
+ * eio_clean_sysctl
+ */
+static int
+eio_clean_sysctl(ctl_table *table, int write, void __user *buffer,
+		 size_t *length, loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.do_clean = dmc->sysctl_active.do_clean;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		/* Do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			/* do_clean is only valid for writeback cache */
+			pr_err("do_clean is only valid for writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.
+		    do_clean & ~(EIO_CLEAN_START | EIO_CLEAN_KEEP)) {
+			pr_err
+				("do_clean should be either clean start/clean keep");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.do_clean == dmc->sysctl_active.do_clean)
+			/* New and old values are same. No work required */
+			return 0;
+
+		/* Copy to active and apply the new tunable value */
+
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+
+		if (dmc->cache_flags & CACHE_FLAGS_MOD_INPROG) {
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+			pr_err
+				("do_clean called while cache modification in progress");
+			return -EBUSY;
+		} else {
+			dmc->sysctl_active.do_clean =
+				dmc->sysctl_pending.do_clean;
+
+			if (dmc->sysctl_active.do_clean) {
+				atomic_set(&dmc->clean_index, 0);
+				dmc->sysctl_active.do_clean |= EIO_CLEAN_START;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       flags);
+
+				/*
+				 * Wake up the clean thread.
+				 * Sync thread will do the clean and once complete
+				 * will reset the clean_start flag.
+				 * The clean_keep flag will remain set(unless reset
+				 * by user) and will prevent new I/Os from making
+				 * the blocks dirty.
+				 */
+
+				spin_lock_irqsave(&dmc->clean_sl, flags);
+				EIO_SET_EVENT_AND_UNLOCK(&dmc->clean_event,
+							 &dmc->clean_sl, flags);
+			} else
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       flags);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * eio_dirty_high_threshold_sysctl
+ */
+static int
+eio_dirty_high_threshold_sysctl(ctl_table *table, int write,
+				void __user *buffer, size_t *length,
+				loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.dirty_high_threshold =
+			dmc->sysctl_active.dirty_high_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		uint32_t old_value;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("dirty_high_threshold is only valid for writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_high_threshold > 100) {
+			pr_err
+				("dirty_high_threshold percentage should be [0 - 100]");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_high_threshold <
+		    dmc->sysctl_active.dirty_low_threshold) {
+			pr_err
+				("dirty high shouldn't be less than dirty low threshold");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_high_threshold ==
+		    dmc->sysctl_active.dirty_high_threshold)
+			/* new is same as old value. No need to take any action */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.dirty_high_threshold;
+		dmc->sysctl_active.dirty_high_threshold =
+			dmc->sysctl_pending.dirty_high_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.dirty_high_threshold = old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		/* if we reduced the high threshold, check if we require cache cleaning */
+		if (old_value > dmc->sysctl_active.dirty_high_threshold)
+			eio_comply_dirty_thresholds(dmc, -1);
+	}
+
+	return 0;
+}
+
+/*
+ * eio_dirty_low_threshold_sysctl
+ */
+static int
+eio_dirty_low_threshold_sysctl(ctl_table *table, int write,
+			       void __user *buffer, size_t *length,
+			       loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.dirty_low_threshold =
+			dmc->sysctl_active.dirty_low_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		uint32_t old_value;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("dirty_low_threshold is valid for only writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_low_threshold > 100) {
+			pr_err
+				("dirty_low_threshold percentage should be [0 - 100]");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_low_threshold >
+		    dmc->sysctl_active.dirty_high_threshold) {
+			pr_err
+				("dirty low shouldn't be more than dirty high threshold");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_low_threshold ==
+		    dmc->sysctl_active.dirty_low_threshold)
+			/* new is same as old value. No need to take any action */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.dirty_low_threshold;
+		dmc->sysctl_active.dirty_low_threshold =
+			dmc->sysctl_pending.dirty_low_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.dirty_low_threshold = old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		if (old_value > dmc->sysctl_active.dirty_low_threshold)
+			/*
+			 * Although the low threshold set shouldn't trigger new cleans,
+			 * but because we set the tunables one at a time from user mode,
+			 * it is possible that the high threshold value triggering clean
+			 * did not happen and should get triggered now that the low value
+			 * has been changed, so we are calling the comply function here
+			 */
+			eio_comply_dirty_thresholds(dmc, -1);
+	}
+
+	return 0;
+}
+
+/*
+ * eio_dirty_set_high_threshold_sysctl
+ */
+static int
+eio_dirty_set_high_threshold_sysctl(ctl_table *table, int write,
+				    void __user *buffer, size_t *length,
+				    loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.dirty_set_high_threshold =
+			dmc->sysctl_active.dirty_set_high_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		uint32_t old_value;
+		u_int64_t i;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("dirty_set_high_threshold is valid only for writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_high_threshold > 100) {
+			pr_err
+				("dirty_set_high_threshold percentage should be [0 - 100]");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_high_threshold <
+		    dmc->sysctl_active.dirty_set_low_threshold) {
+			pr_err
+				("dirty_set_high_threshold shouldn't be less than dirty low threshold");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_high_threshold ==
+		    dmc->sysctl_active.dirty_set_high_threshold)
+			/* new is same as old value. No need to take any action */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.dirty_set_high_threshold;
+		dmc->sysctl_active.dirty_set_high_threshold =
+			dmc->sysctl_pending.dirty_set_high_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.dirty_set_high_threshold = old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		if (old_value > dmc->sysctl_active.dirty_set_high_threshold) {
+			/* Check each set for dirty blocks cleaning */
+			for (i = 0; i < (dmc->size >> dmc->consecutive_shift);
+			     i++)
+				eio_comply_dirty_thresholds(dmc, i);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * eio_dirty_set_low_threshold_sysctl
+ */
+static int
+eio_dirty_set_low_threshold_sysctl(ctl_table *table, int write,
+				   void __user *buffer, size_t *length,
+				   loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post the existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.dirty_set_low_threshold =
+			dmc->sysctl_active.dirty_set_low_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		uint32_t old_value;
+		u_int64_t i;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("dirty_set_low_threshold is valid only for writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_low_threshold > 100) {
+			pr_err
+				("dirty_set_low_threshold percentage should be [0 - 100]");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_low_threshold >
+		    dmc->sysctl_active.dirty_set_high_threshold) {
+			pr_err
+				("dirty_set_low_threshold shouldn't be more than dirty_set_high_threshold");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.dirty_set_low_threshold ==
+		    dmc->sysctl_active.dirty_set_low_threshold)
+			/* new is same as old value. No need to take any action */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.dirty_set_low_threshold;
+		dmc->sysctl_active.dirty_set_low_threshold =
+			dmc->sysctl_pending.dirty_set_low_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.dirty_set_low_threshold = old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		/*
+		 * Although the low threshold value shouldn't trigger new cleans,
+		 * but because we set the tunables one at a time from user mode,
+		 * it is possible that the high threshold value triggering clean
+		 * did not happen and should get triggered now that the low value
+		 * has been changed, so we are calling the comply function again
+		 */
+		if (old_value > dmc->sysctl_active.dirty_set_low_threshold) {
+			/* Check each set for dirty blocks cleaning */
+			for (i = 0; i < (dmc->size >> dmc->consecutive_shift);
+			     i++)
+				eio_comply_dirty_thresholds(dmc, i);
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * eio_autoclean_threshold_sysctl
+ */
+static int
+eio_autoclean_threshold_sysctl(ctl_table *table, int write,
+			       void __user *buffer, size_t *length,
+			       loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.autoclean_threshold =
+			dmc->sysctl_active.autoclean_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		int old_value;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("autoclean_threshold is valid only for writeback cache");
+			return -EINVAL;
+		}
+
+		if ((dmc->sysctl_pending.autoclean_threshold < 0) ||
+		    (dmc->sysctl_pending.autoclean_threshold >
+		     AUTOCLEAN_THRESH_MAX)) {
+			pr_err("autoclean_threshold is valid range is 0 to %d",
+			       AUTOCLEAN_THRESH_MAX);
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.autoclean_threshold ==
+		    dmc->sysctl_active.autoclean_threshold)
+			/* new is same as old value. No need to take any action */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.autoclean_threshold;
+		dmc->sysctl_active.autoclean_threshold =
+			dmc->sysctl_pending.autoclean_threshold;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.autoclean_threshold = old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		/* Ensure new thresholds are being complied */
+		eio_comply_dirty_thresholds(dmc, -1);
+	}
+
+	return 0;
+}
+
+/*
+ * eio_time_based_clean_interval_sysctl
+ */
+static int
+eio_time_based_clean_interval_sysctl(ctl_table *table, int write,
+				     void __user *buffer, size_t *length,
+				     loff_t *ppos)
+{
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value or post existing value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.time_based_clean_interval =
+			dmc->sysctl_active.time_based_clean_interval;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		int error;
+		uint32_t old_value;
+
+		/* do sanity check */
+
+		if (dmc->mode != CACHE_MODE_WB) {
+			pr_err
+				("time_based_clean_interval is valid only for writeback cache");
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.time_based_clean_interval >
+		    TIME_BASED_CLEAN_INTERVAL_MAX) {
+			/* valid values are 0 to TIME_BASED_CLEAN_INTERVAL_MAX */
+			pr_err
+				("time_based_clean_interval valid range is 0 to %u",
+				TIME_BASED_CLEAN_INTERVAL_MAX);
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.time_based_clean_interval ==
+		    dmc->sysctl_active.time_based_clean_interval)
+			/* new is same as old value */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		old_value = dmc->sysctl_active.time_based_clean_interval;
+		dmc->sysctl_active.time_based_clean_interval =
+			dmc->sysctl_pending.time_based_clean_interval;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		/* Store the change persistently */
+		error = eio_sb_store(dmc);
+		if (error) {
+			/* restore back the old value and return error */
+			spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+			dmc->sysctl_active.time_based_clean_interval =
+				old_value;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+			return error;
+		}
+
+		/* Reschedule the time based clean, based on new interval */
+		cancel_delayed_work_sync(&dmc->clean_aged_sets_work);
+		spin_lock_irqsave(&dmc->dirty_set_lru_lock, flags);
+		dmc->is_clean_aged_sets_sched = 0;
+		if (dmc->sysctl_active.time_based_clean_interval
+		    && atomic64_read(&dmc->nr_dirty)) {
+			schedule_delayed_work(&dmc->clean_aged_sets_work,
+					      dmc->sysctl_active.
+					      time_based_clean_interval * 60 *
+					      HZ);
+			dmc->is_clean_aged_sets_sched = 1;
+		}
+		spin_unlock_irqrestore(&dmc->dirty_set_lru_lock, flags);
+	}
+
+	return 0;
+}
+
+static void eio_sysctl_register_writeback(struct cache_c *dmc);
+static void eio_sysctl_unregister_writeback(struct cache_c *dmc);
+static void eio_sysctl_register_invalidate(struct cache_c *dmc);
+static void eio_sysctl_unregister_invalidate(struct cache_c *dmc);
+
+/*
+ * eio_control_sysctl
+ */
+int
+eio_control_sysctl(ctl_table *table, int write, void __user *buffer,
+		   size_t *length, loff_t *ppos)
+{
+	int rv = 0;
+	struct cache_c *dmc = (struct cache_c *)table->extra1;
+	unsigned long flags = 0;
+
+	/* fetch the new tunable value */
+
+	if (!write) {
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_pending.control = dmc->sysctl_active.control;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+	}
+
+	proc_dointvec(table, write, buffer, length, ppos);
+
+	/* do write processing */
+
+	if (write) {
+		/* do sanity check */
+
+		if (dmc->sysctl_pending.control > CACHE_CONTROL_FLAG_MAX ||
+		    dmc->sysctl_pending.control < 0) {
+			/* valid values are from 0 till CACHE_CONTROL_FLAG_MAX */
+			pr_err("control valid values are from 0 till %d",
+			       CACHE_CONTROL_FLAG_MAX);
+			return -EINVAL;
+		}
+
+		if (dmc->sysctl_pending.control == dmc->sysctl_active.control)
+			/* new is same as old value. No work required */
+			return 0;
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_active.control = dmc->sysctl_pending.control;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		switch (dmc->sysctl_active.control) {
+		case CACHE_VERBOSE_OFF:
+			spin_lock_irqsave(&dmc->cache_spin_lock,
+					  dmc->cache_spin_lock_flags);
+			dmc->cache_flags &= ~CACHE_FLAGS_VERBOSE;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+			pr_info("Turning off verbose mode");
+			break;
+		case CACHE_VERBOSE_ON:
+			spin_lock_irqsave(&dmc->cache_spin_lock,
+					  dmc->cache_spin_lock_flags);
+			dmc->cache_flags |= CACHE_FLAGS_VERBOSE;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+			pr_info("Turning on verbose mode");
+			break;
+		case CACHE_WRITEBACK_ON:
+			if (dmc->sysctl_handle_writeback == NULL)
+				eio_sysctl_register_writeback(dmc);
+			break;
+		case CACHE_WRITEBACK_OFF:
+			if (dmc->sysctl_handle_writeback)
+				eio_sysctl_unregister_writeback(dmc);
+			break;
+		case CACHE_INVALIDATE_ON:
+			if (dmc->sysctl_handle_invalidate == NULL) {
+				eio_sysctl_register_invalidate(dmc);
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags |= CACHE_FLAGS_INVALIDATE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+			} else
+				pr_info("Invalidate API already registered");
+			break;
+		case CACHE_INVALIDATE_OFF:
+			if (dmc->sysctl_handle_invalidate) {
+				eio_sysctl_unregister_invalidate(dmc);
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags &= ~CACHE_FLAGS_INVALIDATE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+			} else
+				pr_info("Invalidate API not registered");
+			break;
+		case CACHE_FAST_REMOVE_ON:
+			if (dmc->mode != CACHE_MODE_WB) {
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags |= CACHE_FLAGS_FAST_REMOVE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				if (CACHE_VERBOSE_IS_SET(dmc))
+					pr_info("Turning on fast remove");
+			} else {
+#ifdef EIO_DEBUG
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags |= CACHE_FLAGS_FAST_REMOVE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				if (CACHE_VERBOSE_IS_SET(dmc))
+					pr_info("Turning on fast remove");
+#else
+				pr_err("Invalid control value: 0x%x",
+				       dmc->sysctl_active.control);
+				rv = -1;
+#endif                          /* EIO_DEBUG */
+			}
+			break;
+		case CACHE_FAST_REMOVE_OFF:
+			if (dmc->mode != CACHE_MODE_WB) {
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags &= ~CACHE_FLAGS_FAST_REMOVE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				if (CACHE_VERBOSE_IS_SET(dmc))
+					pr_info("Turning off fast remove");
+			} else {
+#ifdef EIO_DEBUG
+				spin_lock_irqsave(&dmc->cache_spin_lock,
+						  dmc->cache_spin_lock_flags);
+				dmc->cache_flags &= ~CACHE_FLAGS_FAST_REMOVE;
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				if (CACHE_VERBOSE_IS_SET(dmc))
+					pr_info("Turning off fast remove");
+#else
+				pr_err("Invalid control value: 0x%x",
+				       dmc->sysctl_active.control);
+				rv = -1;
+#endif                          /* EIO_DEBUG */
+			}
+			break;
+		default:
+			pr_err("Invalid control value: 0x%x",
+			       dmc->sysctl_active.control);
+			rv = -1;
+		}
+	}
+
+	return rv;
+}
+
+#define PROC_STR                "enhanceio"
+#define PROC_VER_STR            "enhanceio/version"
+#define PROC_STATS              "stats"
+#define PROC_ERRORS             "errors"
+#define PROC_IOSZ_HIST          "io_hist"
+#define PROC_CONFIG             "config"
+
+static int eio_invalidate_sysctl(ctl_table *table, int write,
+				 void __user *buffer, size_t *length,
+				 loff_t *ppos);
+static void *eio_find_sysctl_data(struct cache_c *dmc, ctl_table *vars);
+static char *eio_cons_sysctl_devname(struct cache_c *dmc);
+static char *eio_cons_procfs_cachename(struct cache_c *dmc,
+				       char *path_component);
+static void eio_sysctl_register_common(struct cache_c *dmc);
+static void eio_sysctl_unregister_common(struct cache_c *dmc);
+static void eio_sysctl_register_dir(void);
+static void eio_sysctl_unregister_dir(void);
+static int eio_stats_show(struct seq_file *seq, void *v);
+static int eio_stats_open(struct inode *inode, struct file *file);
+static int eio_errors_show(struct seq_file *seq, void *v);
+static int eio_errors_open(struct inode *inode, struct file *file);
+static int eio_iosize_hist_show(struct seq_file *seq, void *v);
+static int eio_iosize_hist_open(struct inode *inode, struct file *file);
+static int eio_version_show(struct seq_file *seq, void *v);
+static int eio_version_open(struct inode *inode, struct file *file);
+static int eio_config_show(struct seq_file *seq, void *v);
+static int eio_config_open(struct inode *inode, struct file *file);
+
+static const struct file_operations eio_version_operations = {
+	.open		= eio_version_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations eio_stats_operations = {
+	.open		= eio_stats_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations eio_errors_operations = {
+	.open		= eio_errors_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations eio_iosize_hist_operations = {
+	.open		= eio_iosize_hist_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations eio_config_operations = {
+	.open		= eio_config_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/*
+ * Each ctl_table array needs to be 1 more than the actual number of
+ * entries - zero padded at the end ! Therefore the NUM_*_SYSCTLS
+ * is 1 more than then number of sysctls.
+ */
+
+#define PROC_SYS_ROOT_NAME              "dev"
+#define PROC_SYS_DIR_NAME               "enhanceio"
+#define PROC_SYS_CACHE_NAME             "enhanceio-dev"
+
+/*
+ * The purpose of sysctl_table_dir is to create the "enhanceio"
+ * dir under /proc/sys/dev/. The creation is done during module
+ * load time and the dir is removed when module is removed.
+ *
+ * This was added because otherwise, the first cache instance
+ * falsely assumes that /proc/sys/kernel/ is its parent instead
+ * of /proc/sys/dev leading to an incorrect number of reference
+ * count. When you have multiple cache instances, removing the
+ * last one results in the kernel's reference count to be 0
+ * leading to a kernel warning at runtime.  Hopefully, this will
+ * be fixed in the kernel sometime.
+ */
+static struct sysctl_table_dir {
+	struct ctl_table_header *sysctl_header;
+	ctl_table vars[0 + 1];
+	ctl_table dev[0 + 1];
+	ctl_table dir[1 + 1];
+	ctl_table root[1 + 1];
+} sysctl_template_dir = {
+	.vars = {
+	}, .dev	= {
+	}, .dir	= {
+		{
+			.procname	= PROC_SYS_DIR_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_dir.dev,
+		},
+	}, .root = {
+		{
+			.procname	= PROC_SYS_ROOT_NAME,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= sysctl_template_dir.dir,
+		},
+	},
+};
+
+#define NUM_COMMON_SYSCTLS      3
+
+static struct sysctl_table_common {
+	struct ctl_table_header *sysctl_header;
+	ctl_table vars[NUM_COMMON_SYSCTLS + 1];
+	ctl_table dev[1 + 1];
+	ctl_table dir[1 + 1];
+	ctl_table root[1 + 1];
+} sysctl_template_common = {
+	.vars = {
+		{               /* 1 */
+			.procname	= "zero_stats",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &eio_zerostats_sysctl,
+		}, {            /* 2 */
+			.procname	= "mem_limit_pct",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &eio_mem_limit_pct_sysctl,
+		}, {            /* 3 */
+			.procname	= "control",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &eio_control_sysctl,
+		},
+	}, .dev	= {
+		{
+			.procname	= PROC_SYS_CACHE_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_common.vars,
+		},
+	}, .dir	= {
+		{
+			.procname	= PROC_SYS_DIR_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_common.dev,
+		},
+	}, .root = {
+		{
+			.procname	= PROC_SYS_ROOT_NAME,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= sysctl_template_common.dir,
+		},
+	},
+};
+
+#define NUM_WRITEBACK_SYSCTLS   7
+
+static struct sysctl_table_writeback {
+	struct ctl_table_header *sysctl_header;
+	ctl_table vars[NUM_WRITEBACK_SYSCTLS + 1];
+	ctl_table dev[1 + 1];
+	ctl_table dir[1 + 1];
+	ctl_table root[1 + 1];
+} sysctl_template_writeback = {
+	.vars = {
+		{               /* 1 */
+			.procname	= "do_clean",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &eio_clean_sysctl,
+		}, {            /* 2 */
+			.procname	= "time_based_clean_interval",
+			.maxlen		= sizeof(unsigned int),
+			.mode		= 0644,
+			.proc_handler	= &eio_time_based_clean_interval_sysctl,
+		}, {            /* 3 */
+			.procname	= "autoclean_threshold",
+			.maxlen		= sizeof(int),
+			.mode		= 0644,
+			.proc_handler	= &eio_autoclean_threshold_sysctl,
+		}, {            /* 4 */
+			.procname	= "dirty_high_threshold",
+			.maxlen		= sizeof(uint32_t),
+			.mode		= 0644,
+			.proc_handler	= &eio_dirty_high_threshold_sysctl,
+		}
+		, {             /* 5 */
+			.procname	= "dirty_low_threshold",
+			.maxlen		= sizeof(uint32_t),
+			.mode		= 0644,
+			.proc_handler	= &eio_dirty_low_threshold_sysctl,
+		}
+		, {             /* 6 */
+			.procname	= "dirty_set_high_threshold",
+			.maxlen		= sizeof(uint32_t),
+			.mode		= 0644,
+			.proc_handler	= &eio_dirty_set_high_threshold_sysctl,
+		}
+		, {             /* 7 */
+			.procname	= "dirty_set_low_threshold",
+			.maxlen		= sizeof(uint32_t),
+			.mode		= 0644,
+			.proc_handler	= &eio_dirty_set_low_threshold_sysctl,
+		}
+		,
+	}
+	, .dev = {
+		{
+			.procname	= PROC_SYS_CACHE_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_writeback.vars,
+		}
+		,
+	}
+	, .dir = {
+		{
+			.procname	= PROC_SYS_DIR_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_writeback.dev,
+		}
+		,
+	}
+	, .root	= {
+		{
+			.procname	= PROC_SYS_ROOT_NAME,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= sysctl_template_writeback.dir,
+		}
+		,
+	}
+	,
+};
+
+#define NUM_INVALIDATE_SYSCTLS          (1)
+static struct sysctl_table_invalidate {
+	struct ctl_table_header *sysctl_header;
+	ctl_table vars[NUM_INVALIDATE_SYSCTLS + 1];
+	ctl_table dev[1 + 1];
+	ctl_table dir[1 + 1];
+	ctl_table root[1 + 1];
+} sysctl_template_invalidate = {
+	.vars = {
+		{	/* 1 */
+			.procname	= "invalidate",
+			.maxlen		= sizeof(u_int64_t),
+			.mode		= 0644,
+			.proc_handler	= &eio_invalidate_sysctl,
+		}
+		,
+	}
+	, .dev = {
+		{
+			.procname	= PROC_SYS_CACHE_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_invalidate.vars,
+		}
+		,
+	}
+	, .dir = {
+		{
+			.procname	= PROC_SYS_DIR_NAME,
+			.maxlen		= 0,
+			.mode		= S_IRUGO | S_IXUGO,
+			.child		= sysctl_template_invalidate.dev,
+		}
+		,
+	}
+	, .root	= {
+		{
+			.procname	= PROC_SYS_ROOT_NAME,
+			.maxlen		= 0,
+			.mode		= 0555,
+			.child		= sysctl_template_invalidate.dir,
+		}
+		,
+	}
+	,
+};
+
+/*
+ * eio_module_procfs_init -- called from "eio_init()"
+ */
+void eio_module_procfs_init(void)
+{
+	struct proc_dir_entry *entry;
+
+	if (proc_mkdir(PROC_STR, NULL)) {
+		entry = create_proc_entry(PROC_VER_STR, 0, NULL);
+		if (entry)
+			entry->proc_fops = &eio_version_operations;
+	}
+	eio_sysctl_register_dir();
+}
+
+/*
+ * eio_module_procfs_exit -- called from "eio_exit()"
+ */
+void eio_module_procfs_exit(void)
+{
+	(void)remove_proc_entry(PROC_VER_STR, NULL);
+	(void)remove_proc_entry(PROC_STR, NULL);
+
+	eio_sysctl_unregister_dir();
+}
+
+/*
+ * eio_procfs_ctr -- called from "eio_ctr()"
+ */
+void eio_procfs_ctr(struct cache_c *dmc)
+{
+	char *s;
+	struct proc_dir_entry *entry;
+
+	s = eio_cons_procfs_cachename(dmc, "");
+	entry = proc_mkdir(s, NULL);
+	kfree(s);
+	if (entry == NULL) {
+		pr_err("Failed to create /proc/%s", s);
+		return;
+	}
+
+	s = eio_cons_procfs_cachename(dmc, PROC_STATS);
+	entry = create_proc_entry(s, 0, NULL);
+	if (entry) {
+		entry->proc_fops = &eio_stats_operations;
+		entry->data = dmc;
+	}
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_ERRORS);
+	entry = create_proc_entry(s, 0, NULL);
+	if (entry) {
+		entry->proc_fops = &eio_errors_operations;
+		entry->data = dmc;
+	}
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_IOSZ_HIST);
+	entry = create_proc_entry(s, 0, NULL);
+	if (entry) {
+		entry->proc_fops = &eio_iosize_hist_operations;
+		entry->data = dmc;
+	}
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_CONFIG);
+	entry = create_proc_entry(s, 0, NULL);
+	if (entry) {
+		entry->proc_fops = &eio_config_operations;
+		entry->data = dmc;
+	}
+	kfree(s);
+
+	eio_sysctl_register_common(dmc);
+	if (dmc->mode == CACHE_MODE_WB)
+		eio_sysctl_register_writeback(dmc);
+	if (CACHE_INVALIDATE_IS_SET(dmc))
+		eio_sysctl_register_invalidate(dmc);
+}
+
+/*
+ * eio_procfs_dtr -- called from "eio_dtr()"
+ */
+void eio_procfs_dtr(struct cache_c *dmc)
+{
+	char *s;
+
+	s = eio_cons_procfs_cachename(dmc, PROC_STATS);
+	remove_proc_entry(s, NULL);
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_ERRORS);
+	remove_proc_entry(s, NULL);
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_IOSZ_HIST);
+	remove_proc_entry(s, NULL);
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, PROC_CONFIG);
+	remove_proc_entry(s, NULL);
+	kfree(s);
+
+	s = eio_cons_procfs_cachename(dmc, "");
+	remove_proc_entry(s, NULL);
+	kfree(s);
+
+	if (dmc->sysctl_handle_invalidate)
+		eio_sysctl_unregister_invalidate(dmc);
+	if (dmc->sysctl_handle_writeback)
+		eio_sysctl_unregister_writeback(dmc);
+	eio_sysctl_unregister_common(dmc);
+}
+
+static spinlock_t invalidate_spin_lock;
+
+/*
+ * eio_invalidate_sysctl
+ */
+static int
+eio_invalidate_sysctl(ctl_table *table, int write, void __user *buffer,
+		      size_t *length, loff_t *ppos)
+{
+	static int have_sector;
+	static u_int64_t sector;
+	static u_int64_t num_sectors;
+	int rv;
+	unsigned long int flags;
+	struct cache_c *dmc;
+
+	spin_lock_irqsave(&invalidate_spin_lock, flags);
+
+	dmc = (struct cache_c *)table->extra1;
+	if (dmc == NULL) {
+		pr_err
+			("Cannot invalidate due to unexpected NULL cache pointer");
+		spin_unlock_irqrestore(&invalidate_spin_lock, flags);
+		return -EBUSY;
+	}
+
+	table->extra1 = NULL;
+	proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	table->extra1 = dmc;
+
+	spin_unlock_irqrestore(&invalidate_spin_lock, flags);
+
+	rv = 0;
+
+	if (write) {
+		/* TBD. Need to put appropriate sanity checks */
+
+		/* update the active value with the new tunable value */
+		spin_lock_irqsave(&dmc->cache_spin_lock, flags);
+		dmc->sysctl_active.invalidate = dmc->sysctl_pending.invalidate;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock, flags);
+
+		/* apply the new tunable value */
+
+		if (have_sector) {
+			num_sectors = dmc->sysctl_active.invalidate;
+
+			rv = eio_invalidate_sanity_check(dmc, sector,
+							 &num_sectors);
+
+			/* Invalidate only if sanity passes and reset the return value. */
+			if (rv == 0)
+				eio_inval_range(dmc, sector,
+						(unsigned)
+						to_bytes(num_sectors));
+
+			rv = 0;
+			have_sector = 0;
+
+		} else {
+			sector = dmc->sysctl_active.invalidate;
+			have_sector = 1;
+			num_sectors = 0;
+		}
+	}
+
+	if (CACHE_VERBOSE_IS_SET(dmc) && num_sectors) {
+		pr_info
+			("eio_inval_range: Invalidated sector range from sector=%lu to sector=%lu",
+			(long unsigned int)sector, (long unsigned int)num_sectors);
+	}
+
+	return rv;
+}
+
+/*
+ * eio_find_sysctl_data
+ */
+static void *eio_find_sysctl_data(struct cache_c *dmc, ctl_table *vars)
+{
+
+	if (strcmp(vars->procname, "do_clean") == 0)
+		return (void *)&dmc->sysctl_pending.do_clean;
+	if (strcmp(vars->procname, "time_based_clean_interval") == 0)
+		return (void *)&dmc->sysctl_pending.time_based_clean_interval;
+	if (strcmp(vars->procname, "dirty_high_threshold") == 0)
+		return (void *)&dmc->sysctl_pending.dirty_high_threshold;
+	if (strcmp(vars->procname, "dirty_low_threshold") == 0)
+		return (void *)&dmc->sysctl_pending.dirty_low_threshold;
+	if (strcmp(vars->procname, "dirty_set_high_threshold") == 0)
+		return (void *)&dmc->sysctl_pending.dirty_set_high_threshold;
+	if (strcmp(vars->procname, "dirty_set_low_threshold") == 0)
+		return (void *)&dmc->sysctl_pending.dirty_set_low_threshold;
+	if (strcmp(vars->procname, "autoclean_threshold") == 0)
+		return (void *)&dmc->sysctl_pending.autoclean_threshold;
+	if (strcmp(vars->procname, "zero_stats") == 0)
+		return (void *)&dmc->sysctl_pending.zerostats;
+	if (strcmp(vars->procname, "mem_limit_pct") == 0)
+		return (void *)&dmc->sysctl_pending.mem_limit_pct;
+	if (strcmp(vars->procname, "control") == 0)
+		return (void *)&dmc->sysctl_pending.control;
+	if (strcmp(vars->procname, "invalidate") == 0)
+		return (void *)&dmc->sysctl_pending.invalidate;
+
+	pr_err("Cannot find sysctl data for %s", vars->procname);
+	return NULL;
+}
+
+/*
+ * eio_cons_sysctl_devname
+ */
+static char *eio_cons_sysctl_devname(struct cache_c *dmc)
+{
+	char *pathname;
+
+	if (dmc->cache_name[0]) {
+		pathname = kzalloc(strlen(dmc->cache_name) + 1, GFP_KERNEL);
+		if (pathname)
+			strcpy(pathname, dmc->cache_name);
+		else
+			pr_err("Failed to allocate memory");
+	} else {
+		pr_err("Cache name is NULL");
+		pathname = NULL;
+	}
+
+	return pathname;
+}
+
+/*
+ * eio_cons_procfs_cachename
+ */
+static char *eio_cons_procfs_cachename(struct cache_c *dmc,
+				       char *path_component)
+{
+	char *pathname;
+
+	if (dmc->cache_name[0]) {
+		pathname =
+			kzalloc(strlen(PROC_SYS_DIR_NAME) + 1 +
+				strlen(dmc->cache_name) + 1 +
+				strlen(path_component) + 1, GFP_KERNEL);
+		if (pathname) {
+			strcpy(pathname, PROC_SYS_DIR_NAME);
+			strcat(pathname, "/");
+			strcat(pathname, dmc->cache_name);
+			if (strcmp(path_component, "") != 0) {
+				strcat(pathname, "/");
+				strcat(pathname, path_component);
+			}
+		} else
+			pr_err("Failed to allocate memory");
+	} else {
+		pr_err("Cache name is NULL");
+		pathname = NULL;
+	}
+
+	return pathname;
+}
+
+static void eio_sysctl_register_dir(void)
+{
+	struct sysctl_table_dir *dir;
+
+	dir =
+		kmemdup(&sysctl_template_dir, sizeof(sysctl_template_dir),
+			GFP_KERNEL);
+	if (unlikely(dir == NULL)) {
+		pr_err("Failed to allocate memory for dir sysctl");
+		return;
+	}
+
+	dir->dir[0].child = dir->dev;
+	dir->root[0].child = dir->dir;
+	dir->sysctl_header = register_sysctl_table(dir->root);
+	if (unlikely(dir->sysctl_header == NULL)) {
+		pr_err("Failed to register dir sysctl");
+		goto out;
+	}
+
+	sysctl_handle_dir = dir;
+	return;
+out:
+	kfree(dir);
+}
+
+static void eio_sysctl_unregister_dir(void)
+{
+	if (sysctl_handle_dir != NULL) {
+		unregister_sysctl_table(sysctl_handle_dir->sysctl_header);
+		kfree(sysctl_handle_dir);
+		sysctl_handle_dir = NULL;
+	}
+}
+
+/*
+ * eio_sysctl_register_common
+ */
+static void eio_sysctl_register_common(struct cache_c *dmc)
+{
+	unsigned int i;
+	struct sysctl_table_common *common;
+
+	common =
+		kmemdup(&sysctl_template_common, sizeof(sysctl_template_common),
+			GFP_KERNEL);
+	if (common == NULL) {
+		pr_err("Failed to allocate memory for common sysctl");
+		return;
+	}
+	for (i = 0; i < ARRAY_SIZE(common->vars) - 1; i++) {
+		common->vars[i].data =
+			eio_find_sysctl_data(dmc, &common->vars[i]);
+		common->vars[i].extra1 = dmc;
+	}
+
+	common->dev[0].procname = eio_cons_sysctl_devname(dmc);
+	common->dev[0].child = common->vars;
+	common->dir[0].child = common->dev;
+	common->root[0].child = common->dir;
+	common->sysctl_header = register_sysctl_table(common->root);
+	if (common->sysctl_header == NULL) {
+		pr_err("Failed to register common sysctl");
+		goto out;
+	}
+
+	dmc->sysctl_handle_common = common;
+	return;
+out:
+	kfree(common->dev[0].procname);
+	kfree(common);
+}
+
+/*
+ * eio_sysctl_unregister_common
+ */
+static void eio_sysctl_unregister_common(struct cache_c *dmc)
+{
+	struct sysctl_table_common *common;
+
+	common = dmc->sysctl_handle_common;
+	if (common != NULL) {
+		dmc->sysctl_handle_common = NULL;
+		unregister_sysctl_table(common->sysctl_header);
+		kfree(common->dev[0].procname);
+		kfree(common);
+	}
+}
+
+/*
+ * eio_sysctl_register_writeback
+ */
+static void eio_sysctl_register_writeback(struct cache_c *dmc)
+{
+	unsigned int i;
+	struct sysctl_table_writeback *writeback;
+
+	writeback =
+		kmemdup(&sysctl_template_writeback,
+			sizeof(sysctl_template_writeback), GFP_KERNEL);
+	if (writeback == NULL) {
+		pr_err("Failed to allocate memory for writeback sysctl");
+		return;
+	}
+	for (i = 0; i < ARRAY_SIZE(writeback->vars) - 1; i++) {
+		writeback->vars[i].data =
+			eio_find_sysctl_data(dmc, &writeback->vars[i]);
+		writeback->vars[i].extra1 = dmc;
+	}
+
+	writeback->dev[0].procname = eio_cons_sysctl_devname(dmc);
+	writeback->dev[0].child = writeback->vars;
+	writeback->dir[0].child = writeback->dev;
+	writeback->root[0].child = writeback->dir;
+	writeback->sysctl_header = register_sysctl_table(writeback->root);
+	if (writeback->sysctl_header == NULL) {
+		pr_err("Failed to register writeback sysctl");
+		goto out;
+	}
+
+	dmc->sysctl_handle_writeback = writeback;
+	return;
+out:
+	kfree(writeback->dev[0].procname);
+	kfree(writeback);
+}
+
+/*
+ * eio_sysctl_unregister_writeback
+ */
+static void eio_sysctl_unregister_writeback(struct cache_c *dmc)
+{
+	struct sysctl_table_writeback *writeback;
+
+	writeback = dmc->sysctl_handle_writeback;
+	if (writeback != NULL) {
+		dmc->sysctl_handle_writeback = NULL;
+		unregister_sysctl_table(writeback->sysctl_header);
+		kfree(writeback->dev[0].procname);
+		kfree(writeback);
+	}
+}
+
+/*
+ * eio_sysctl_register_invalidate
+ */
+static void eio_sysctl_register_invalidate(struct cache_c *dmc)
+{
+	unsigned int i;
+	struct sysctl_table_invalidate *invalidate;
+
+	invalidate =
+		kmemdup(&sysctl_template_invalidate,
+			sizeof(sysctl_template_invalidate), GFP_KERNEL);
+	if (invalidate == NULL) {
+		pr_err("Failed to allocate memory for invalidate sysctl");
+		return;
+	}
+	for (i = 0; i < ARRAY_SIZE(invalidate->vars) - 1; i++) {
+		invalidate->vars[i].data =
+			eio_find_sysctl_data(dmc, &invalidate->vars[i]);
+		invalidate->vars[i].extra1 = dmc;
+	}
+
+	invalidate->dev[0].procname = eio_cons_sysctl_devname(dmc);
+	invalidate->dev[0].child = invalidate->vars;
+	invalidate->dir[0].child = invalidate->dev;
+	invalidate->root[0].child = invalidate->dir;
+	invalidate->sysctl_header = register_sysctl_table(invalidate->root);
+	if (invalidate->sysctl_header == NULL) {
+		pr_err("Failed to register invalidate sysctl");
+		goto out;
+	}
+
+	dmc->sysctl_handle_invalidate = invalidate;
+	spin_lock_init(&invalidate_spin_lock);
+	return;
+out:
+	kfree(invalidate->dev[0].procname);
+	kfree(invalidate);
+}
+
+/*
+ * eio_sysctl_unregister_invalidate
+ */
+static void eio_sysctl_unregister_invalidate(struct cache_c *dmc)
+{
+	struct sysctl_table_invalidate *invalidate;
+
+	invalidate = dmc->sysctl_handle_invalidate;
+	if (invalidate != NULL) {
+		dmc->sysctl_handle_invalidate = NULL;
+		unregister_sysctl_table(invalidate->sysctl_header);
+		kfree(invalidate->dev[0].procname);
+		kfree(invalidate);
+	}
+}
+
+/*
+ * eio_stats_show
+ */
+static int eio_stats_show(struct seq_file *seq, void *v)
+{
+	struct cache_c *dmc = seq->private;
+	struct eio_stats *stats = &dmc->eio_stats;
+	int read_hit_pct, write_hit_pct, dirty_write_hit_pct;
+
+	if (atomic64_read(&stats->reads) > 0)
+		read_hit_pct =
+			EIO_CALCULATE_PERCENTAGE(
+				atomic64_read(&stats->read_hits),
+				atomic64_read(&stats->reads));
+	else
+		read_hit_pct = 0;
+
+	if (atomic64_read(&stats->writes) > 0) {
+		write_hit_pct =
+			EIO_CALCULATE_PERCENTAGE(
+				atomic64_read(&stats->write_hits),
+				atomic64_read(&stats->writes));
+		dirty_write_hit_pct =
+			EIO_CALCULATE_PERCENTAGE(
+				atomic64_read(&stats->dirty_write_hits),
+				atomic64_read(&stats->writes));
+	} else {
+		write_hit_pct = 0;
+		dirty_write_hit_pct = 0;
+	}
+
+	seq_printf(seq, "%-26s %12lld\n", "reads",
+		   (int64_t)atomic64_read(&stats->reads));
+	seq_printf(seq, "%-26s %12lld\n", "writes",
+		   (int64_t)atomic64_read(&stats->writes));
+
+	seq_printf(seq, "%-26s %12lld\n", "read_hits",
+		   (int64_t)atomic64_read(&stats->read_hits));
+	seq_printf(seq, "%-26s %12d\n", "read_hit_pct", read_hit_pct);
+
+	seq_printf(seq, "%-26s %12lld\n", "write_hits",
+		   (int64_t)atomic64_read(&stats->write_hits));
+	seq_printf(seq, "%-26s %12u\n", "write_hit_pct", write_hit_pct);
+
+	seq_printf(seq, "%-26s %12lld\n", "dirty_write_hits",
+		   (int64_t)atomic64_read(&stats->dirty_write_hits));
+	seq_printf(seq, "%-26s %12d\n", "dirty_write_hit_pct",
+		   dirty_write_hit_pct);
+
+	if ((int64_t)(atomic64_read(&stats->cached_blocks)) < 0)
+		atomic64_set(&stats->cached_blocks, 0);
+	seq_printf(seq, "%-26s %12lld\n", "cached_blocks",
+		   (int64_t)atomic64_read(&stats->cached_blocks));
+
+	seq_printf(seq, "%-26s %12lld\n", "rd_replace",
+		   (int64_t)atomic64_read(&stats->rd_replace));
+	seq_printf(seq, "%-26s %12lld\n", "wr_replace",
+		   (int64_t)atomic64_read(&stats->wr_replace));
+
+	seq_printf(seq, "%-26s %12lld\n", "noroom",
+		   (int64_t)atomic64_read(&stats->noroom));
+
+	seq_printf(seq, "%-26s %12lld\n", "cleanings",
+		   (int64_t)atomic64_read(&stats->cleanings));
+	seq_printf(seq, "%-26s %12lld\n", "md_write_dirty",
+		   (int64_t)atomic64_read(&stats->md_write_dirty));
+	seq_printf(seq, "%-26s %12lld\n", "md_write_clean",
+		   (int64_t)atomic64_read(&stats->md_write_clean));
+	seq_printf(seq, "%-26s %12lld\n", "md_ssd_writes",
+		   (int64_t)atomic64_read(&stats->md_ssd_writes));
+	seq_printf(seq, "%-26s %12d\n", "do_clean",
+		   dmc->sysctl_active.do_clean);
+	seq_printf(seq, "%-26s %12lld\n", "nr_blocks", dmc->size);
+	seq_printf(seq, "%-26s %12lld\n", "nr_dirty",
+		   (int64_t)atomic64_read(&dmc->nr_dirty));
+	seq_printf(seq, "%-26s %12u\n", "nr_sets", (uint32_t)dmc->num_sets);
+	seq_printf(seq, "%-26s %12d\n", "clean_index",
+		   (uint32_t)atomic_read(&dmc->clean_index));
+
+	seq_printf(seq, "%-26s %12lld\n", "uncached_reads",
+		   (int64_t)atomic64_read(&stats->uncached_reads));
+	seq_printf(seq, "%-26s %12lld\n", "uncached_writes",
+		   (int64_t)atomic64_read(&stats->uncached_writes));
+	seq_printf(seq, "%-26s %12lld\n", "uncached_map_size",
+		   (int64_t)atomic64_read(&stats->uncached_map_size));
+	seq_printf(seq, "%-26s %12lld\n", "uncached_map_uncacheable",
+		   (int64_t)atomic64_read(&stats->uncached_map_uncacheable));
+
+	seq_printf(seq, "%-26s %12lld\n", "disk_reads",
+		   (int64_t)atomic64_read(&stats->disk_reads));
+	seq_printf(seq, "%-26s %12lld\n", "disk_writes",
+		   (int64_t)atomic64_read(&stats->disk_writes));
+	seq_printf(seq, "%-26s %12lld\n", "ssd_reads",
+		   (int64_t)atomic64_read(&stats->ssd_reads));
+	seq_printf(seq, "%-26s %12lld\n", "ssd_writes",
+		   (int64_t)atomic64_read(&stats->ssd_writes));
+	seq_printf(seq, "%-26s %12lld\n", "ssd_readfills",
+		   (int64_t)atomic64_read(&stats->ssd_readfills));
+	seq_printf(seq, "%-26s %12lld\n", "ssd_readfill_unplugs",
+		   (int64_t)atomic64_read(&stats->ssd_readfill_unplugs));
+
+	seq_printf(seq, "%-26s %12lld\n", "readdisk",
+		   (int64_t)atomic64_read(&stats->readdisk));
+	seq_printf(seq, "%-26s %12lld\n", "writedisk",
+		   (int64_t)atomic64_read(&stats->readdisk));
+	seq_printf(seq, "%-26s %12lld\n", "readcache",
+		   (int64_t)atomic64_read(&stats->readcache));
+	seq_printf(seq, "%-26s %12lld\n", "readfill",
+		   (int64_t)atomic64_read(&stats->readfill));
+	seq_printf(seq, "%-26s %12lld\n", "writecache",
+		   (int64_t)atomic64_read(&stats->writecache));
+
+	seq_printf(seq, "%-26s %12lld\n", "readcount",
+		   (int64_t)atomic64_read(&stats->readcount));
+	seq_printf(seq, "%-26s %12lld\n", "writecount",
+		   (int64_t)atomic64_read(&stats->writecount));
+	seq_printf(seq, "%-26s %12lld\n", "kb_reads",
+		   (int64_t)atomic64_read(&stats->reads) / 2);
+	seq_printf(seq, "%-26s %12lld\n", "kb_writes",
+		   (int64_t)atomic64_read(&stats->writes) / 2);
+	seq_printf(seq, "%-26s %12lld\n", "rdtime_ms",
+		   (int64_t)atomic64_read(&stats->rdtime_ms));
+	seq_printf(seq, "%-26s %12lld\n", "wrtime_ms",
+		   (int64_t)atomic64_read(&stats->wrtime_ms));
+	return 0;
+}
+
+/*
+ * eio_stats_open
+ */
+static int eio_stats_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &eio_stats_show, PDE(inode)->data);
+}
+
+/*
+ * eio_errors_show
+ */
+static int eio_errors_show(struct seq_file *seq, void *v)
+{
+	struct cache_c *dmc = seq->private;
+
+	seq_printf(seq, "disk_read_errors    %4u\n",
+		   dmc->eio_errors.disk_read_errors);
+	seq_printf(seq, "disk_write_errors   %4u\n",
+		   dmc->eio_errors.disk_write_errors);
+	seq_printf(seq, "ssd_read_errors     %4u\n",
+		   dmc->eio_errors.ssd_read_errors);
+	seq_printf(seq, "ssd_write_errors    %4u\n",
+		   dmc->eio_errors.ssd_write_errors);
+	seq_printf(seq, "memory_alloc_errors %4u\n",
+		   dmc->eio_errors.memory_alloc_errors);
+	seq_printf(seq, "no_cache_dev        %4u\n",
+		   dmc->eio_errors.no_cache_dev);
+	seq_printf(seq, "no_source_dev       %4u\n",
+		   dmc->eio_errors.no_source_dev);
+
+	return 0;
+}
+
+/*
+ * eio_errors_open
+ */
+static int eio_errors_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &eio_errors_show, PDE(inode)->data);
+}
+
+/*
+ * eio_iosize_hist_show
+ */
+static int eio_iosize_hist_show(struct seq_file *seq, void *v)
+{
+	int i;
+	struct cache_c *dmc = seq->private;
+
+	for (i = 1; i <= SIZE_HIST - 1; i++) {
+		if (atomic64_read(&dmc->size_hist[i]) == 0)
+			continue;
+
+		if (i == 1)
+			seq_printf(seq, "%u   %12lld\n", i * 512,
+				   (int64_t)atomic64_read(&dmc->size_hist[i]));
+		else if (i < 20)
+			seq_printf(seq, "%u  %12lld\n", i * 512,
+				   (int64_t)atomic64_read(&dmc->size_hist[i]));
+		else
+			seq_printf(seq, "%u %12lld\n", i * 512,
+				   (int64_t)atomic64_read(&dmc->size_hist[i]));
+	}
+
+	return 0;
+}
+
+/*
+ * eio_iosize_hist_open
+ */
+static int eio_iosize_hist_open(struct inode *inode, struct file *file)
+{
+
+	return single_open(file, &eio_iosize_hist_show, PDE(inode)->data);
+}
+
+/*
+ * eio_version_show
+ */
+static int eio_version_show(struct seq_file *seq, void *v)
+{
+	char buf[128];
+
+	memset(buf, 0, sizeof(buf));
+	eio_version_query(sizeof(buf), buf);
+	seq_printf(seq, "%s\n", buf);
+
+	return 0;
+}
+
+/*
+ * eio_version_open
+ */
+static int eio_version_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, &eio_version_show, PDE(inode)->data);
+}
+
+/*
+ * eio_config_show
+ */
+static int eio_config_show(struct seq_file *seq, void *v)
+{
+	struct cache_c *dmc = seq->private;
+
+	seq_printf(seq, "src_name   %s\n", dmc->disk_devname);
+	seq_printf(seq, "ssd_name   %s\n", dmc->cache_devname);
+	seq_printf(seq, "src_size   %lu\n", (long unsigned int)dmc->disk_size);
+	seq_printf(seq, "ssd_size   %lu\n", (long unsigned int)dmc->size);
+
+	seq_printf(seq, "set_size   %10u\n", dmc->assoc);
+	seq_printf(seq, "block_size %10u\n", (dmc->block_size) << SECTOR_SHIFT);
+	seq_printf(seq, "mode       %10u\n", dmc->mode);
+	seq_printf(seq, "eviction   %10u\n", dmc->req_policy);
+	seq_printf(seq, "num_sets   %10u\n", dmc->num_sets);
+	seq_printf(seq, "num_blocks %10lu\n", (long unsigned int)dmc->size);
+	seq_printf(seq, "metadata        %s\n",
+		   CACHE_MD8_IS_SET(dmc) ? "large" : "small");
+	seq_printf(seq, "state        %s\n",
+		   CACHE_DEGRADED_IS_SET(dmc) ? "degraded"
+		   : (CACHE_FAILED_IS_SET(dmc) ? "failed" : "normal"));
+	seq_printf(seq, "flags      0x%08x\n", dmc->cache_flags);
+
+	return 0;
+}
+
+/*
+ * eio_config_open
+ */
+static int eio_config_open(struct inode *inode, struct file *file)
+{
+
+	return single_open(file, &eio_config_show, PDE(inode)->data);
+}
diff --git a/drivers/block/enhanceio/eio_rand.c b/drivers/block/enhanceio/eio_rand.c
new file mode 100644
index 0000000..92c896f
--- /dev/null
+++ b/drivers/block/enhanceio/eio_rand.c
@@ -0,0 +1,201 @@
+/*
+ *  eio_rand.c
+ *
+ *  Copyright (C) 2013 ProfitBricks, GmbH.
+ *   Jack Wang <jinpu.wang@profitbricks.com>
+ *   Dongsu Park <dongsu.park@profitbricks.com>
+ *
+ *  Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "eio.h"
+/* Generic policy functions prototypes */
+int eio_rand_init(struct cache_c *);
+void eio_rand_exit(void);
+int eio_rand_cache_sets_init(struct eio_policy *);
+int eio_rand_cache_blk_init(struct eio_policy *);
+void eio_rand_find_reclaim_dbn(struct eio_policy *, index_t, index_t *);
+int eio_rand_clean_set(struct eio_policy *, index_t, int);
+
+/* Per policy instance initialization */
+struct eio_policy *eio_rand_instance_init(void);
+
+
+/*
+ * Context that captures the rand replacement policy
+ */
+static struct eio_policy_header eio_rand_ops = {
+	.sph_name		= CACHE_REPL_RANDOM,
+	.sph_instance_init	= eio_rand_instance_init,
+};
+
+/*
+ * Initialize RAND policy.
+ */
+int eio_rand_init(struct cache_c *dmc)
+{
+	return 0;
+}
+
+/*
+ * Initialize rand data structure called from ctr.
+ */
+int eio_rand_cache_sets_init(struct eio_policy *p_ops)
+{
+	return 0;
+}
+
+/*
+ * The actual function that returns a victim block in index.
+ */
+void
+eio_rand_find_reclaim_dbn(struct eio_policy *p_ops, index_t start_index,
+			  index_t *index)
+{
+	int i = 0;
+	index_t idx;
+
+	struct cache_c *dmc = p_ops->sp_dmc;
+
+	/*
+	 * "start_index" should already be the beginning index of the set.
+	 * We're just being cautious here.
+	 */
+	start_index = (start_index / dmc->assoc) * dmc->assoc;
+	for (i = 0; i < (int)dmc->assoc; i++) {
+		idx = dmc->random++ % dmc->assoc;
+		if (EIO_CACHE_STATE_GET(dmc, start_index + idx) == VALID) {
+			*index = start_index + idx;
+			return;
+		}
+	}
+}
+
+/*
+ * Go through the entire set and clean.
+ */
+int eio_rand_clean_set(struct eio_policy *p_ops, index_t set, int to_clean)
+{
+	int i = 0, nr_writes = 0;
+	index_t start_index;
+
+	struct cache_c *dmc;
+
+	dmc = p_ops->sp_dmc;
+
+	start_index = set * dmc->assoc;
+
+	/* Scan sequentially in the set and pick blocks to clean */
+	while ((i < (int)dmc->assoc) && (nr_writes < to_clean)) {
+		if ((EIO_CACHE_STATE_GET(dmc, start_index + i) &
+		     (DIRTY | BLOCK_IO_INPROG)) == DIRTY) {
+			EIO_CACHE_STATE_ON(dmc, start_index + i,
+					   DISKWRITEINPROG);
+			nr_writes++;
+		}
+		i++;
+	}
+
+	return nr_writes;
+}
+
+/*
+ * rand is per set, so do nothing on a per block init.
+ */
+int eio_rand_cache_blk_init(struct eio_policy *p_ops)
+{
+	return 0;
+}
+
+/*
+ * Allocate a new instance of eio_policy per dmc
+ */
+struct eio_policy *eio_rand_instance_init(void)
+{
+	struct eio_policy *new_instance;
+
+	new_instance = vmalloc(sizeof(struct eio_policy));
+	if (new_instance == NULL) {
+		pr_err("ssdscache_rand_instance_init: vmalloc failed");
+		return NULL;
+	}
+
+	/* Initialize the rand specific functions and variables */
+	new_instance->sp_name = CACHE_REPL_RANDOM;
+	new_instance->sp_policy.lru = NULL;
+	new_instance->sp_repl_init = eio_rand_init;
+	new_instance->sp_repl_exit = eio_rand_exit;
+	new_instance->sp_repl_sets_init = eio_rand_cache_sets_init;
+	new_instance->sp_repl_blk_init = eio_rand_cache_blk_init;
+	new_instance->sp_find_reclaim_dbn = eio_rand_find_reclaim_dbn;
+	new_instance->sp_clean_set = eio_rand_clean_set;
+	new_instance->sp_dmc = NULL;
+
+	try_module_get(THIS_MODULE);
+
+	pr_info("eio_rand_instance_init: created new instance of RAND");
+
+	return new_instance;
+}
+
+/*
+ * Cleanup an instance of eio_policy (called from dtr).
+ */
+void eio_rand_exit(void)
+{
+	module_put(THIS_MODULE);
+}
+
+static
+int __init rand_register(void)
+{
+	int ret;
+
+	ret = eio_register_policy(&eio_rand_ops);
+	if (ret != 0)
+		pr_info("eio_rand already registered");
+
+	return ret;
+}
+
+static
+void __exit rand_unregister(void)
+{
+	int ret;
+
+	ret = eio_unregister_policy(&eio_rand_ops);
+	if (ret != 0)
+		pr_err("eio_rand unregister failed");
+}
+
+module_init(rand_register);
+module_exit(rand_unregister);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RAND policy for EnhanceIO");
+MODULE_AUTHOR("sTec(R), Inc. based on code by Facebook");
diff --git a/drivers/block/enhanceio/eio_setlru.c b/drivers/block/enhanceio/eio_setlru.c
new file mode 100644
index 0000000..d412e46
--- /dev/null
+++ b/drivers/block/enhanceio/eio_setlru.c
@@ -0,0 +1,170 @@
+/*
+ *  eio_setlru.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Amit Kale <akale@stec-inc.com>
+ *  Harish Pujari <hpujari@stec-inc.com>
+ *   Generic lru implementation used mainly for cache sets.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ */
+
+#include "eio.h"
+
+/* Initialize the lru list */
+int lru_init(struct lru_ls **llist, index_t max)
+{
+	index_t i = 0;
+
+	EIO_ASSERT(max > 0);
+	*llist = vmalloc((sizeof(struct lru_ls) + (max - 1) * sizeof(struct lru_elem)));
+	if (*llist == NULL)
+		return -ENOMEM;
+
+	(*llist)->ll_head = LRU_NULL;
+	(*llist)->ll_tail = LRU_NULL;
+	(*llist)->ll_max = max;
+	(*llist)->ll_size = 0;
+
+	for (i = 0; i < max; i++) {
+		(*llist)->ll_elem[i].le_next = LRU_NULL;
+		(*llist)->ll_elem[i].le_prev = LRU_NULL;
+		(*llist)->ll_elem[i].le_key = 0;
+	}
+
+	return 0;
+}
+
+/* Uninitialize the lru list */
+void lru_uninit(struct lru_ls *llist)
+{
+	if (llist)
+		vfree(llist);
+}
+
+/* Add a new entry to lru list */
+int lru_add(struct lru_ls *llist, index_t index, u_int64_t key)
+{
+	if (!llist || (index >= llist->ll_max))
+		return -EINVAL;
+
+	llist->ll_elem[index].le_prev = llist->ll_tail;
+	llist->ll_elem[index].le_next = LRU_NULL;
+	llist->ll_elem[index].le_key = key;
+
+	if (llist->ll_tail != LRU_NULL)
+		llist->ll_elem[llist->ll_tail].le_next = index;
+	else {
+		EIO_ASSERT(llist->ll_head == LRU_NULL);
+		llist->ll_head = index;
+	}
+	llist->ll_tail = index;
+	llist->ll_size++;
+
+	return 0;
+}
+
+/* Remove an entry from the lru list */
+int lru_rem(struct lru_ls *llist, index_t index)
+{
+	if (!llist || (index >= llist->ll_max) || (index == LRU_NULL))
+		return -EINVAL;
+
+	if (llist->ll_head == LRU_NULL && llist->ll_tail == LRU_NULL)
+		/*
+		 * No element in the list.
+		 */
+		return -EINVAL;
+
+	if (llist->ll_elem[index].le_prev == LRU_NULL &&
+	    llist->ll_elem[index].le_next == LRU_NULL &&
+	    llist->ll_head != index && llist->ll_tail != index)
+		/*
+		 * Element not in list.
+		 */
+		return 0;
+
+	if (llist->ll_elem[index].le_prev != LRU_NULL)
+		llist->ll_elem[llist->ll_elem[index].le_prev].le_next =
+			llist->ll_elem[index].le_next;
+
+	if (llist->ll_elem[index].le_next != LRU_NULL)
+		llist->ll_elem[llist->ll_elem[index].le_next].le_prev =
+			llist->ll_elem[index].le_prev;
+
+	if (llist->ll_head == index)
+		llist->ll_head = llist->ll_elem[index].le_next;
+
+	if (llist->ll_tail == index)
+		llist->ll_tail = llist->ll_elem[index].le_prev;
+
+	llist->ll_elem[index].le_prev = LRU_NULL;
+	llist->ll_elem[index].le_next = LRU_NULL;
+	EIO_ASSERT(llist->ll_size != 0);
+	llist->ll_size--;
+
+	return 0;
+}
+
+/* Move up the given lru element */
+int lru_touch(struct lru_ls *llist, index_t index, u_int64_t key)
+{
+	if (!llist || (index >= llist->ll_max))
+		return -EINVAL;
+
+	if (llist->ll_tail == index)
+		llist->ll_elem[index].le_key = key;
+	else {
+		lru_rem(llist, index);
+		lru_add(llist, index, key);
+	}
+
+	return 0;
+}
+
+/* Read the element at the head of the lru */
+int lru_read_head(struct lru_ls *llist, index_t *index, u_int64_t *key)
+{
+	if (!llist || !index || !key)
+		return -EINVAL;
+
+	*index = llist->ll_head;
+	if (llist->ll_head == LRU_NULL) {
+		*index = LRU_NULL;
+		*key = 0;
+	} else {
+		*index = llist->ll_head;
+		*key = llist->ll_elem[*index].le_key;
+	}
+
+	return 0;
+}
+
+/* Remove the element at the head of the lru */
+int lru_rem_head(struct lru_ls *llist, index_t *index, u_int64_t *key)
+{
+	if (!llist || !index || !key)
+		return -EINVAL;
+
+	*index = llist->ll_head;
+	if (llist->ll_head == LRU_NULL) {
+		*index = LRU_NULL;
+		*key = 0;
+	} else {
+		*index = llist->ll_head;
+		*key = llist->ll_elem[*index].le_key;
+		lru_rem(llist, *index);
+	}
+
+	return 0;
+}
diff --git a/drivers/block/enhanceio/eio_setlru.h b/drivers/block/enhanceio/eio_setlru.h
new file mode 100644
index 0000000..c39b94e
--- /dev/null
+++ b/drivers/block/enhanceio/eio_setlru.h
@@ -0,0 +1,49 @@
+/*
+ *  eio_setlru.h
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Amit Kale <akale@stec-inc.com>
+ *  Harish Pujari <hpujari@stec-inc.com>
+ *   Generic lru implementation used mainly for cache sets
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ */
+
+#ifndef _EIO_SETLRU_H_
+#define _EIO_SETLRU_H_
+
+#define         LRU_NULL        -1
+
+struct lru_elem {
+	index_t le_next;
+	index_t le_prev;
+	u_int64_t le_key;
+};
+
+struct lru_ls {
+	index_t ll_head;
+	index_t ll_tail;
+	index_t ll_max;
+	u_int64_t ll_size;
+	struct lru_elem ll_elem[1];
+};
+
+int lru_init(struct lru_ls **llist, index_t max);
+void lru_uninit(struct lru_ls *llist);
+int lru_add(struct lru_ls *llist, index_t index, u_int64_t key);
+int lru_rem(struct lru_ls *llist, index_t index);
+int lru_touch(struct lru_ls *llist, index_t index, u_int64_t key);
+int lru_read_head(struct lru_ls *llist, index_t *index, u_int64_t *key);
+int lru_rem_head(struct lru_ls *llist, index_t *index, u_int64_t *key);
+
+#endif                          /* _EIO_SETLRU_H_ */
diff --git a/drivers/block/enhanceio/eio_subr.c b/drivers/block/enhanceio/eio_subr.c
new file mode 100644
index 0000000..57bcbdc
--- /dev/null
+++ b/drivers/block/enhanceio/eio_subr.c
@@ -0,0 +1,444 @@
+/*
+ *  eio_subr.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *  Made EnhanceIO specific changes.
+ *   Saied Kazemi <skazemi@stec-inc.com>
+ *   Siddharth Choudhuri <schoudhuri@stec-inc.com>
+ *
+ *  Copyright 2010 Facebook, Inc.
+ *   Author: Mohan Srinivasan (mohan@facebook.com)
+ *
+ *  Based on DM-Cache:
+ *   Copyright (C) International Business Machines Corp., 2006
+ *   Author: Ming Zhao (mingzhao@ufl.edu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "eio.h"
+#include "eio_ttc.h"
+
+static DEFINE_SPINLOCK(_job_lock);
+static LIST_HEAD(_io_jobs);
+static LIST_HEAD(_disk_read_jobs);
+
+int eio_io_empty(void)
+{
+
+	return list_empty(&_io_jobs);
+}
+
+struct kcached_job *eio_alloc_cache_job(void)
+{
+	struct kcached_job *job;
+
+	job = mempool_alloc(_job_pool, GFP_NOIO);
+	if (likely(job))
+		atomic_inc(&nr_cache_jobs);
+	return job;
+}
+
+void eio_free_cache_job(struct kcached_job *job)
+{
+
+	mempool_free(job, _job_pool);
+	atomic_dec(&nr_cache_jobs);
+}
+
+/*
+ * Functions to push and pop a job onto the head of a given job list.
+ */
+static struct kcached_job *eio_pop(struct list_head *jobs)
+{
+	struct kcached_job *job = NULL;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&_job_lock, flags);
+	if (!list_empty(jobs)) {
+		job = list_entry(jobs->next, struct kcached_job, list);
+		list_del(&job->list);
+	}
+	spin_unlock_irqrestore(&_job_lock, flags);
+	return job;
+}
+
+static void eio_push(struct list_head *jobs, struct kcached_job *job)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&_job_lock, flags);
+	list_add_tail(&job->list, jobs);
+	spin_unlock_irqrestore(&_job_lock, flags);
+}
+
+void eio_push_ssdread_failures(struct kcached_job *job)
+{
+
+	eio_push(&_disk_read_jobs, job);
+}
+
+static void
+eio_process_jobs(struct list_head *jobs, void (*fn) (struct kcached_job *))
+{
+	struct kcached_job *job;
+
+	while ((job = eio_pop(jobs)) != NULL)
+		(void)fn(job);
+}
+
+static void eio_process_ssd_rm_list(void)
+{
+	unsigned long int flags = 0;
+	struct ssd_rm_list *ssd_list_ptr;
+	extern int ssd_rm_list_not_empty;
+	extern spinlock_t ssd_rm_list_lock;
+	extern struct list_head ssd_rm_list;
+
+	spin_lock_irqsave(&ssd_rm_list_lock, flags);
+	if (likely(list_empty(&ssd_rm_list))) {
+		spin_unlock_irqrestore(&ssd_rm_list_lock, flags);
+		return;
+	}
+
+	while (!list_empty(&ssd_rm_list)) {
+		ssd_list_ptr =
+		    list_entry(ssd_rm_list.next, struct ssd_rm_list, list);
+		if (ssd_list_ptr->action == BUS_NOTIFY_DEL_DEVICE)
+			eio_suspend_caching(ssd_list_ptr->dmc,
+					    ssd_list_ptr->note);
+		else
+			pr_err("eio_process_ssd_rm_list:"
+			       "Unknown status (0x%x)\n", ssd_list_ptr->action);
+		list_del(&ssd_list_ptr->list);
+		kfree(ssd_list_ptr);
+	}
+	ssd_rm_list_not_empty = 0;
+	spin_unlock_irqrestore(&ssd_rm_list_lock, flags);
+}
+
+/*
+ * Entry point of the "events" kernel thread.
+ */
+void eio_do_work(struct work_struct *unused)
+{
+	extern int ssd_rm_list_not_empty;
+
+	if (unlikely(ssd_rm_list_not_empty))
+		eio_process_ssd_rm_list();
+	eio_process_jobs(&_disk_read_jobs, eio_ssderror_diskread);
+}
+
+struct kcached_job *eio_new_job(struct cache_c *dmc, struct eio_bio *bio,
+				index_t index)
+{
+	struct kcached_job *job;
+
+	EIO_ASSERT((bio != NULL) || (index != -1));
+
+	job = eio_alloc_cache_job();
+	if (unlikely(job == NULL)) {
+		spin_lock_irqsave(&dmc->cache_spin_lock,
+				  dmc->cache_spin_lock_flags);
+		dmc->eio_errors.memory_alloc_errors++;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return NULL;
+	}
+	job->dmc = dmc;
+	job->index = index;
+	job->error = 0;
+	job->ebio = bio;
+	if (index != -1) {
+		job->job_io_regions.cache.bdev = dmc->cache_dev->bdev;
+		if (bio) {
+			job->job_io_regions.cache.sector =
+			    (index << dmc->block_shift) + dmc->md_sectors +
+			    (bio->eb_sector -
+			     EIO_ROUND_SECTOR(dmc, bio->eb_sector));
+			EIO_ASSERT(eio_to_sector(bio->eb_size) <=
+				   dmc->block_size);
+			job->job_io_regions.cache.count =
+			    eio_to_sector(bio->eb_size);
+		} else {
+			job->job_io_regions.cache.sector =
+			    (index << dmc->block_shift) + dmc->md_sectors;
+			job->job_io_regions.cache.count = dmc->block_size;
+		}
+	}
+
+	job->job_io_regions.disk.bdev = dmc->disk_dev->bdev;
+	if (bio) {
+		job->job_io_regions.disk.sector = bio->eb_sector;
+		job->job_io_regions.disk.count = eio_to_sector(bio->eb_size);
+	} else {
+		job->job_io_regions.disk.sector = EIO_DBN_GET(dmc, index);
+		job->job_io_regions.disk.count = dmc->block_size;
+	}
+	job->next = NULL;
+	job->md_sector = NULL;
+
+	return job;
+}
+
+int
+eio_io_sync_pages(struct cache_c *dmc, struct eio_io_region *where, int rw,
+		  struct page **pages, int num_bvecs)
+{
+	struct eio_io_request req;
+	int error;
+
+	req.mtype = EIO_PAGES;
+	req.dptr.plist = pages;
+	req.num_bvecs = num_bvecs;
+	req.notify = NULL;
+	req.context = NULL;
+	req.hddio = 0;
+
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	     unlikely(CACHE_DEGRADED_IS_SET(dmc))) &&
+	    (!CACHE_SSD_ADD_INPROG_IS_SET(dmc)))
+		error = -ENODEV;
+	else
+		error = eio_do_io(dmc, where, rw, &req);
+
+	if (error)
+		return error;
+
+	return 0;
+}
+
+int
+eio_io_sync_vm(struct cache_c *dmc, struct eio_io_region *where, int rw,
+	       struct bio_vec *pages, int num_bvecs)
+{
+	struct eio_io_request req;
+	int error;
+
+	memset((char *)&req, 0, sizeof(req));
+	/* Fill up the appropriate fields
+	 * in eio_io_request */
+	req.mtype = EIO_BVECS;
+	req.dptr.pages = pages;
+	req.num_bvecs = num_bvecs;
+	req.notify = NULL;
+	req.context = NULL;
+	req.hddio = 0;
+	if ((unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	     unlikely(CACHE_DEGRADED_IS_SET(dmc))) &&
+	    (!CACHE_SSD_ADD_INPROG_IS_SET(dmc)))
+		error = -ENODEV;
+	else
+		error = eio_do_io(dmc, where, rw, &req);
+	if (error)
+		return error;
+	return 0;
+}
+
+void eio_unplug_cache_device(struct cache_c *dmc)
+{
+	struct request_queue *q;
+	struct block_device *bdev;
+
+	if (unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	    unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+		return;
+	bdev = dmc->cache_dev->bdev;
+	q = bdev_get_queue(bdev);
+}
+
+void eio_unplug_disk_device(struct cache_c *dmc)
+{
+	struct request_queue *q;
+	struct block_device *bdev;
+
+	if (unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+		return;
+	bdev = dmc->disk_dev->bdev;
+	q = bdev_get_queue(bdev);
+}
+
+void eio_plug_cache_device(struct cache_c *dmc)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+
+	if (unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	    unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+		return;
+	bdev = dmc->cache_dev->bdev;
+	q = bdev_get_queue(bdev);
+}
+
+void eio_plug_disk_device(struct cache_c *dmc)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+
+	if (unlikely(CACHE_DEGRADED_IS_SET(dmc)))
+		return;
+	bdev = dmc->disk_dev->bdev;
+	q = bdev_get_queue(bdev);
+}
+
+/*
+ * For Linux, we do not do a dm_put_device() when the device underneath
+ * disappears. The logic to handle the IOs to a missing device is handled
+ * by the kernel proper. We will get an IO error if an IO is done on a
+ * device that does not exist.
+ */
+void eio_suspend_caching(struct cache_c *dmc, enum dev_notifier note)
+{
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	if (dmc->mode != CACHE_MODE_WB && CACHE_FAILED_IS_SET(dmc)) {
+		pr_err("suspend caching: Cache "
+		       "%s is already in FAILED state\n", dmc->cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return;
+	}
+
+	switch (note) {
+
+	case NOTIFY_SRC_REMOVED:
+		if (CACHE_DEGRADED_IS_SET(dmc))
+			dmc->cache_flags &= ~CACHE_FLAGS_DEGRADED;
+		dmc->cache_flags |= CACHE_FLAGS_FAILED;
+		dmc->eio_errors.no_source_dev = 1;
+		atomic64_set(&dmc->eio_stats.cached_blocks, 0);
+		pr_info("suspend_caching: Source Device Removed."
+			"Cache \"%s\" is in Failed mode.\n", dmc->cache_name);
+		break;
+	case NOTIFY_SSD_REMOVED:
+		if (dmc->mode == CACHE_MODE_WB) {
+			/*
+			 * For writeback
+			 * - Cache should never be in degraded mode
+			 * - ssd removal should result in FAILED state
+			 * - the cached block should not be reset.
+			 */
+			EIO_ASSERT(!CACHE_DEGRADED_IS_SET(dmc));
+			dmc->cache_flags |= CACHE_FLAGS_FAILED;
+			pr_info("suspend caching: SSD Device Removed.\
+				 Cache \"%s\" is in Failed mode.\n", dmc->cache_name);
+		} else {
+			if (CACHE_DEGRADED_IS_SET(dmc) ||
+			    CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+				spin_unlock_irqrestore(&dmc->cache_spin_lock,
+						       dmc->
+						       cache_spin_lock_flags);
+				pr_err("suspend_caching: Cache \
+				       \"%s\" is either degraded \
+				       or device add in progress, exiting.\n", dmc->cache_name);
+				return;
+			}
+			dmc->cache_flags |= CACHE_FLAGS_DEGRADED;
+			atomic64_set(&dmc->eio_stats.cached_blocks, 0);
+			pr_info("suspend caching: Cache \"%s\" \
+				is in Degraded mode.\n", dmc->cache_name);
+		}
+		dmc->eio_errors.no_cache_dev = 1;
+		break;
+	default:
+		pr_err("suspend_caching: incorrect notify message.\n");
+		break;
+	}
+
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+}
+
+void eio_put_cache_device(struct cache_c *dmc)
+{
+
+	eio_ttc_put_device(&dmc->cache_dev);
+}
+
+void eio_resume_caching(struct cache_c *dmc, char *dev)
+{
+	int r;
+
+	if (dmc == NULL || dev == NULL) {
+		pr_err("resume_caching: Null device or"
+		       "cache instance when resuming caching.\n");
+		return;
+	}
+	if (strlen(dev) >= DEV_PATHLEN) {
+		pr_err("resume_caching: Device name %s too long.\n", dev);
+		return;
+	}
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	if (CACHE_STALE_IS_SET(dmc)) {
+		pr_err("eio_resume_caching: Hard Failure Detected!!"
+		       "Cache \"%s\" can not be resumed.", dmc->cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return;
+	}
+
+	/* sanity check for writeback */
+	if (dmc->mode == CACHE_MODE_WB) {
+		if (!CACHE_FAILED_IS_SET(dmc) || CACHE_SRC_IS_ABSENT(dmc) ||
+		    CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+			pr_debug("eio_resume_caching: Cache not in Failed "
+				 "state or Source is absent"
+				 "or SSD add already in progress for cache \"%s\".\n",
+				 dmc->cache_name);
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+			return;
+		}
+	} else {
+		/* sanity check for WT or RO cache. */
+		if (CACHE_FAILED_IS_SET(dmc) || !CACHE_DEGRADED_IS_SET(dmc) ||
+		    CACHE_SSD_ADD_INPROG_IS_SET(dmc)) {
+			pr_err("resume_caching: Cache \"%s\" "
+			       "is either in failed mode or "
+			       "cache device add in progress, ignoring.\n ",
+			       dmc->cache_name);
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+			return;
+		}
+	}
+
+	dmc->cache_flags |= CACHE_FLAGS_SSD_ADD_INPROG;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+	r = eio_ctr_ssd_add(dmc, dev);
+	if (r) {
+		/* error */
+		pr_debug(" resume caching: returned error: %d\n ", r);
+		spin_lock_irqsave(&dmc->cache_spin_lock,
+				  dmc->cache_spin_lock_flags);
+		dmc->cache_flags &= ~CACHE_FLAGS_SSD_ADD_INPROG;
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return;
+	}
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	dmc->eio_errors.no_cache_dev = 0;
+	if (dmc->mode != CACHE_MODE_WB)
+		dmc->cache_flags &= ~CACHE_FLAGS_DEGRADED;
+	else
+		dmc->cache_flags &= ~CACHE_FLAGS_FAILED;
+	dmc->cache_flags &= ~CACHE_FLAGS_SSD_ADD_INPROG;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+	pr_info(" resume_caching:cache %s is restored to ACTIVE mode.\n",
+		dmc->cache_name);
+}
diff --git a/drivers/block/enhanceio/eio_ttc.c b/drivers/block/enhanceio/eio_ttc.c
new file mode 100644
index 0000000..830d0be
--- /dev/null
+++ b/drivers/block/enhanceio/eio_ttc.c
@@ -0,0 +1,1688 @@
+/*
+ * True Transparent Caching (TTC) code.
+ *  eio_ttc.c
+ *
+ *  Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ *   under a license included herein are reserved
+ *
+ *  Made EIO fully transparent with respect to applications. A cache can be
+ *  created or deleted while a filesystem or applications are online
+ *   Amit Kale <akale@stec-inc.com>
+ *   Ramprasad Chinthekindi <rchinthekindi@stec-inc.com>
+ *   Akhil Bhansali <abhansali@stec-inc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include "eio.h"
+#include "eio_ttc.h"
+static struct rw_semaphore eio_ttc_lock[EIO_HASHTBL_SIZE];
+static struct list_head eio_ttc_list[EIO_HASHTBL_SIZE];
+
+int eio_reboot_notified;
+
+static void eio_make_request_fn(struct request_queue *, struct bio *);
+static void eio_cache_rec_fill(struct cache_c *, struct cache_rec_short *);
+static void eio_bio_end_empty_barrier(struct bio *, int);
+static void eio_issue_empty_barrier_flush(struct block_device *, struct bio *,
+					  int, make_request_fn *, int rw_flags);
+static int eio_finish_nrdirty(struct cache_c *);
+static int eio_mode_switch(struct cache_c *, u_int32_t);
+static int eio_policy_switch(struct cache_c *, u_int32_t);
+
+static int eio_overlap_split_bio(struct request_queue *, struct bio *);
+static struct bio *eio_split_new_bio(struct bio *, struct bio_container *,
+				     unsigned *, unsigned *, sector_t);
+static void eio_split_endio(struct bio *, int);
+
+static int eio_open(struct inode *ip, struct file *filp)
+{
+	__module_get(THIS_MODULE);
+	return 0;
+}
+
+static int eio_release(struct inode *ip, struct file *filp)
+{
+	module_put(THIS_MODULE);
+	return 0;
+}
+
+static const struct file_operations eio_fops = {
+	.open		= eio_open,
+	.release	= eio_release,
+	.unlocked_ioctl = eio_ioctl,
+	.compat_ioctl	= eio_compact_ioctl,
+	.owner		= THIS_MODULE,
+};
+
+static struct miscdevice eio_misc = {
+	.minor	= MISC_DYNAMIC_MINOR,
+	.name	= MISC_DEVICE,
+	.fops	= &eio_fops,
+};
+
+int eio_create_misc_device()
+{
+	return misc_register(&eio_misc);
+}
+
+int eio_delete_misc_device()
+{
+	return misc_deregister(&eio_misc);
+}
+
+int eio_ttc_get_device(const char *path, fmode_t mode, struct eio_bdev **result)
+{
+	struct block_device *bdev;
+	struct eio_bdev *eio_bdev;
+	unsigned int major, minor;
+
+	dev_t uninitialized_var(dev);
+	static char *eio_holder = "ENHANCE IO";
+
+	if (sscanf(path, "%u:%u", &major, &minor) == 2) {
+		/* Extract the major/minor numbers */
+		dev = MKDEV(major, minor);
+		if (MAJOR(dev) != major || MINOR(dev) != minor)
+			return -EOVERFLOW;
+	} else {
+		/* convert the path to a device */
+		struct block_device *bdev = lookup_bdev(path);
+
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+
+		dev = bdev->bd_dev;
+		bdput(bdev);
+	}
+
+	bdev = blkdev_get_by_dev(dev, mode, eio_holder);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	/*
+	 * Do we need to claim the devices ??
+	 * bd_claim_by_disk(bdev, charptr, gendisk)
+	 */
+
+	eio_bdev = kzalloc(sizeof(*eio_bdev), GFP_KERNEL);
+	if (eio_bdev == NULL) {
+		blkdev_put(bdev, mode);
+		return -ENOMEM;
+	}
+
+	eio_bdev->bdev = bdev;
+	eio_bdev->mode = mode;
+	*result = eio_bdev;
+	return 0;
+}
+
+void eio_ttc_put_device(struct eio_bdev **d)
+{
+	struct eio_bdev *eio_bdev;
+
+	eio_bdev = *d;
+	blkdev_put(eio_bdev->bdev, eio_bdev->mode);
+	kfree(eio_bdev);
+	*d = NULL;
+	return;
+}
+
+struct cache_c *eio_cache_lookup(char *name)
+{
+	struct cache_c *dmc = NULL;
+	int i;
+
+	for (i = 0; i < EIO_HASHTBL_SIZE; i++) {
+		down_read(&eio_ttc_lock[i]);
+		list_for_each_entry(dmc, &eio_ttc_list[i], cachelist) {
+			if (!strcmp(name, dmc->cache_name)) {
+				up_read(&eio_ttc_lock[i]);
+				return dmc;
+			}
+		}
+		up_read(&eio_ttc_lock[i]);
+	}
+	return NULL;
+}
+
+int eio_ttc_activate(struct cache_c *dmc)
+{
+	struct block_device *bdev;
+	struct request_queue *rq;
+	make_request_fn *origmfn;
+	struct cache_c *dmc1;
+	int wholedisk;
+	int error;
+	int index;
+	int rw_flags = 0;
+
+	bdev = dmc->disk_dev->bdev;
+	if (bdev == NULL) {
+		pr_err("cache_create: Source device not found\n");
+		return -ENODEV;
+	}
+	rq = bdev->bd_disk->queue;
+
+	wholedisk = 0;
+	if (bdev == bdev->bd_contains)
+		wholedisk = 1;
+
+	dmc->dev_start_sect = bdev->bd_part->start_sect;
+	dmc->dev_end_sect =
+		bdev->bd_part->start_sect + bdev->bd_part->nr_sects - 1;
+
+	pr_debug("eio_ttc_activate: Device/Partition" \
+		 " sector_start: %llu, end: %llu\n",
+		 (uint64_t)dmc->dev_start_sect, (uint64_t)dmc->dev_end_sect);
+
+	error = 0;
+	origmfn = NULL;
+	index = EIO_HASH_BDEV(bdev->bd_contains->bd_dev);
+
+	down_write(&eio_ttc_lock[index]);
+	list_for_each_entry(dmc1, &eio_ttc_list[index], cachelist) {
+		if (dmc1->disk_dev->bdev->bd_contains != bdev->bd_contains)
+			continue;
+
+		if ((wholedisk) || (dmc1->dev_info == EIO_DEV_WHOLE_DISK) ||
+		    (dmc1->disk_dev->bdev == bdev)) {
+			error = -EINVAL;
+			up_write(&eio_ttc_lock[index]);
+			goto out;
+		}
+
+		/* some partition of same device already cached */
+		EIO_ASSERT(dmc1->dev_info == EIO_DEV_PARTITION);
+		origmfn = dmc1->origmfn;
+		break;
+	}
+
+	/*
+	 * Save original make_request_fn. Switch make_request_fn only once.
+	 */
+
+	if (origmfn) {
+		dmc->origmfn = origmfn;
+		dmc->dev_info = EIO_DEV_PARTITION;
+		EIO_ASSERT(wholedisk == 0);
+	} else {
+		dmc->origmfn = rq->make_request_fn;
+		rq->make_request_fn = eio_make_request_fn;
+		dmc->dev_info =
+			(wholedisk) ? EIO_DEV_WHOLE_DISK : EIO_DEV_PARTITION;
+	}
+
+	list_add_tail(&dmc->cachelist, &eio_ttc_list[index]);
+
+	/*
+	 * Sleep for sometime, to allow previous I/Os to hit
+	 * Issue a barrier I/O on Source device.
+	 */
+
+	msleep(1);
+	SET_BARRIER_FLAGS(rw_flags);
+	eio_issue_empty_barrier_flush(dmc->disk_dev->bdev, NULL,
+				      EIO_HDD_DEVICE, dmc->origmfn, rw_flags);
+	up_write(&eio_ttc_lock[index]);
+
+out:
+	if (error == -EINVAL) {
+		if (wholedisk)
+			pr_err
+				("cache_create: A partition of this device is already cached.\n");
+		else
+			pr_err("cache_create: Device is already cached.\n");
+	}
+	return error;
+}
+
+int eio_ttc_deactivate(struct cache_c *dmc, int force)
+{
+	struct block_device *bdev;
+	struct request_queue *rq;
+	struct cache_c *dmc1;
+	int found_partitions;
+	int index;
+	int ret;
+
+	ret = 0;
+	bdev = dmc->disk_dev->bdev;
+	rq = bdev->bd_disk->queue;
+
+	if (force)
+		goto deactivate;
+
+	/* Process and wait for nr_dirty to drop to zero */
+	if (dmc->mode == CACHE_MODE_WB) {
+		if (!CACHE_FAILED_IS_SET(dmc)) {
+			ret = eio_finish_nrdirty(dmc);
+			if (ret) {
+				pr_err
+					("ttc_deactivate: nrdirty failed to finish for cache \"%s\".",
+					dmc->cache_name);
+				return ret;
+			}
+		} else
+			pr_debug
+				("ttc_deactivate: Cache \"%s\" failed is already set. Continue with cache delete.",
+				dmc->cache_name);
+	}
+
+	/*
+	 * Traverse the list and see if other partitions of this device are
+	 * cached. Switch mfn if this is the only partition of the device
+	 * in the list.
+	 */
+deactivate:
+	index = EIO_HASH_BDEV(bdev->bd_contains->bd_dev);
+	found_partitions = 0;
+
+	/* check if barrier QUEUE is empty or not */
+	down_write(&eio_ttc_lock[index]);
+
+	if (dmc->dev_info != EIO_DEV_WHOLE_DISK)
+		list_for_each_entry(dmc1, &eio_ttc_list[index], cachelist) {
+			if (dmc == dmc1)
+				continue;
+
+			if (dmc1->disk_dev->bdev->bd_contains != bdev->bd_contains)
+				continue;
+
+			EIO_ASSERT(dmc1->dev_info == EIO_DEV_PARTITION);
+
+			/*
+			 * There are still other partitions which are cached.
+			 * Do not switch the make_request_fn.
+			 */
+
+			found_partitions = 1;
+			break;
+		}
+
+		if ((dmc->dev_info == EIO_DEV_WHOLE_DISK) || (found_partitions == 0))
+			rq->make_request_fn = dmc->origmfn;
+
+	list_del_init(&dmc->cachelist);
+	up_write(&eio_ttc_lock[index]);
+
+	/* wait for nr_ios to drain-out */
+	while (atomic64_read(&dmc->nr_ios) != 0)
+		schedule_timeout(msecs_to_jiffies(100));
+
+	return ret;
+}
+
+void eio_ttc_init(void)
+{
+	int i;
+
+	for (i = 0; i < EIO_HASHTBL_SIZE; i++) {
+		init_rwsem(&eio_ttc_lock[i]);
+		INIT_LIST_HEAD(&eio_ttc_list[i]);
+	}
+}
+
+/*
+ * Cases:-
+ * 1. Full device cached.
+ *	if (ENQUEUE || barrier(bio))
+ *		enqueue (dmc, bio) and return
+ *      else
+ *		call eio_map(dmc, bio)
+ * 2. Some partitions of the device cached.
+ *	if (ENQUEUE || barrier(bio))
+ *		All I/Os (both on cached and uncached partitions) are enqueued.
+ *      else
+ *		if (I/O on cached partition)
+ *			call eio_map(dmc, bio)
+ *		else
+ *			origmfn(bio);	// uncached partition
+ * 3. q->mfn got switched back to original
+ *	call origmfn(q, bio)
+ * 4. Race condition:
+ */
+
+static void eio_make_request_fn(struct request_queue *q, struct bio *bio)
+{
+	int ret;
+	int overlap;
+	int index;
+	make_request_fn *origmfn;
+	struct cache_c *dmc, *dmc1;
+	struct block_device *bdev;
+
+	bdev = bio->bi_bdev;
+
+re_lookup:
+	dmc = NULL;
+	origmfn = NULL;
+	overlap = ret = 0;
+
+	index = EIO_HASH_BDEV(bdev->bd_contains->bd_dev);
+
+	down_read(&eio_ttc_lock[index]);
+
+	list_for_each_entry(dmc1, &eio_ttc_list[index], cachelist) {
+		if (dmc1->disk_dev->bdev->bd_contains != bdev->bd_contains)
+			continue;
+
+		if (dmc1->dev_info == EIO_DEV_WHOLE_DISK) {
+			dmc = dmc1;     /* found cached device */
+			break;
+		}
+
+		/* Handle partitions */
+		if (!origmfn)
+			origmfn = dmc1->origmfn;
+
+		/* I/O perfectly fit within cached partition */
+		if ((bio->bi_sector >= dmc1->dev_start_sect) &&
+		    ((bio->bi_sector + eio_to_sector(bio->bi_size) - 1) <=
+		     dmc1->dev_end_sect)) {
+			EIO_ASSERT(overlap == 0);
+			dmc = dmc1;     /* found cached partition */
+			break;
+		}
+
+		/* Check if I/O is overlapping with cached partitions */
+		if (((bio->bi_sector >= dmc1->dev_start_sect) &&
+		     (bio->bi_sector <= dmc1->dev_end_sect)) ||
+		    ((bio->bi_sector + eio_to_sector(bio->bi_size) - 1 >=
+		      dmc1->dev_start_sect) &&
+		     (bio->bi_sector + eio_to_sector(bio->bi_size) - 1 <=
+		      dmc1->dev_end_sect))) {
+			overlap = 1;
+			pr_err
+				("Overlapping I/O detected on %s cache at sector: %llu, size: %u\n",
+				dmc1->cache_name, (uint64_t)bio->bi_sector,
+				bio->bi_size);
+			break;
+		}
+	}
+
+	if (unlikely(overlap)) {
+		up_read(&eio_ttc_lock[index]);
+
+		if (bio_rw_flagged(bio, REQ_DISCARD)) {
+			pr_err
+				("eio_mfn: Overlap I/O with Discard flag." \
+				" Discard flag is not supported.\n");
+			bio_endio(bio, -EOPNOTSUPP);
+		} else
+			ret = eio_overlap_split_bio(q, bio);
+	} else if (dmc) {       /* found cached partition or device */
+		/*
+		 * Start sector of cached partition may or may not be
+		 * aligned with cache blocksize.
+		 * Map start of the partition to zero reference.
+		 */
+
+		if (bio->bi_sector) {
+			EIO_ASSERT(bio->bi_sector >= dmc->dev_start_sect);
+			bio->bi_sector -= dmc->dev_start_sect;
+		}
+		ret = eio_map(dmc, q, bio);
+		if (ret)
+			/* Error case: restore the start sector of bio */
+			bio->bi_sector += dmc->dev_start_sect;
+	}
+
+	if (!overlap)
+		up_read(&eio_ttc_lock[index]);
+
+	if (overlap || dmc)
+		return;
+
+	/*
+	 * Race condition:-
+	 * origmfn can be NULL if  all partitions or whole disk got uncached.
+	 * We set origmfn = q->mfn if origmfn is NULL.
+	 * The origmfn may now again be eio_make_request_fn because
+	 * someone else switched the q->mfn because of a new
+	 * partition or whole disk being cached.
+	 * Since, we cannot protect q->make_request_fn() by any lock,
+	 * this situation may occur. However, this is a very rare event.
+	 * In this case restart the lookup.
+	 */
+
+	if (origmfn == NULL)
+		origmfn = q->make_request_fn;
+	if (origmfn == eio_make_request_fn)
+		goto re_lookup;
+
+	origmfn(q, bio);
+	return;
+}
+
+uint64_t eio_get_cache_count(void)
+{
+	struct cache_c *dmc;
+	uint64_t cnt = 0;
+	int i;
+
+	for (i = 0; i < EIO_HASHTBL_SIZE; i++) {
+		down_read(&eio_ttc_lock[i]);
+		list_for_each_entry(dmc, &eio_ttc_list[i], cachelist) {
+			cnt++;
+		}
+		up_read(&eio_ttc_lock[i]);
+	}
+	return cnt;
+}
+
+int eio_get_cache_list(unsigned long *arg)
+{
+	int error = 0;
+	unsigned int size, i, j;
+	struct cache_list reclist;
+	struct cache_rec_short *cache_recs;
+	struct cache_c *dmc;
+
+	if (copy_from_user(&reclist, (struct cache_list __user *)arg,
+			   sizeof(struct cache_list))) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	size = reclist.ncaches * sizeof(struct cache_rec_short);
+	cache_recs = vmalloc(size);
+	if (!cache_recs) {
+		error = -ENOMEM;
+		goto out;
+	}
+	memset(cache_recs, 0, size);
+
+	i = 0;
+	for (j = 0; j < EIO_HASHTBL_SIZE; j++) {
+		down_read(&eio_ttc_lock[j]);
+		list_for_each_entry(dmc, &eio_ttc_list[j], cachelist) {
+			eio_cache_rec_fill(dmc, &cache_recs[i]);
+			i++;
+
+			if (i == reclist.ncaches)
+				break;
+		}
+		up_read(&eio_ttc_lock[j]);
+
+		if (i == reclist.ncaches)
+			break;
+	}
+
+	if (copy_to_user((char __user *)reclist.cachelist,
+			 (char *)cache_recs, size)) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	if (copy_to_user((struct cache_list __user *)arg, &reclist,
+			 sizeof(struct cache_list))) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	return error;
+}
+
+static void eio_cache_rec_fill(struct cache_c *dmc, struct cache_rec_short *rec)
+{
+	strncpy(rec->cr_name, dmc->cache_name, sizeof(rec->cr_name) - 1);
+	strncpy(rec->cr_src_devname, dmc->disk_devname,
+		sizeof(rec->cr_src_devname) - 1);
+	strncpy(rec->cr_ssd_devname, dmc->cache_devname,
+		sizeof(rec->cr_ssd_devname) - 1);
+	rec->cr_src_dev_size = eio_get_device_size(dmc->disk_dev);
+	rec->cr_ssd_dev_size = eio_get_device_size(dmc->cache_dev);
+	rec->cr_src_sector_size = 0;    /* unused in userspace */
+	rec->cr_ssd_sector_size = 0;    /* unused in userspace */
+	rec->cr_flags = dmc->cache_flags;
+	rec->cr_policy = dmc->req_policy;
+	rec->cr_mode = dmc->mode;
+	rec->cr_persistence = dmc->persistence;
+	rec->cr_blksize = dmc->block_size;      /* In sectors */
+	rec->cr_assoc = dmc->assoc;
+	return;
+}
+
+/*
+ * Few sanity checks before cache creation.
+ */
+
+int eio_do_preliminary_checks(struct cache_c *dmc)
+{
+	struct block_device *bdev, *ssd_bdev;
+	struct cache_c *dmc1;
+	int error;
+	int wholedisk;
+	int index;
+
+	error = wholedisk = 0;
+	bdev = dmc->disk_dev->bdev;
+	ssd_bdev = dmc->cache_dev->bdev;
+
+	/*
+	 * Disallow cache creation if source and cache device
+	 * belong to same device.
+	 */
+
+	if (bdev->bd_contains == ssd_bdev->bd_contains)
+		return -EINVAL;
+
+	/*
+	 * Check if cache with same name exists.
+	 */
+
+	if (eio_cache_lookup(dmc->cache_name))
+		return -EEXIST;
+
+	if (bdev == bdev->bd_contains)
+		wholedisk = 1;
+
+	index = EIO_HASH_BDEV(bdev->bd_contains->bd_dev);
+
+	down_read(&eio_ttc_lock[index]);
+	list_for_each_entry(dmc1, &eio_ttc_list[index], cachelist) {
+		if (dmc1->disk_dev->bdev->bd_contains != bdev->bd_contains)
+			continue;
+
+		if ((wholedisk) || (dmc1->dev_info == EIO_DEV_WHOLE_DISK) ||
+		    (dmc1->disk_dev->bdev == bdev)) {
+			error = -EINVAL;
+			break;
+		}
+	}
+	up_read(&eio_ttc_lock[index]);
+	return error;
+}
+
+/* Use mempool_alloc and free for io in sync_io as well */
+static void eio_dec_count(struct eio_context *io, int error)
+{
+	if (error)
+		io->error = error;
+
+	if (atomic_dec_and_test(&io->count)) {
+		if (io->event)
+			complete(io->event);
+		else {
+			int err = io->error;
+			eio_notify_fn fn = io->callback;
+			void *context = io->context;
+
+			mempool_free(io, _io_pool);
+			io = NULL;
+			fn(err, context);
+		}
+	}
+}
+
+static void eio_endio(struct bio *bio, int error)
+{
+	struct eio_context *io;
+
+	io = bio->bi_private;
+	EIO_ASSERT(io != NULL);
+
+	bio_put(bio);
+
+	eio_dec_count(io, error);
+}
+
+static int eio_dispatch_io_pages(struct cache_c *dmc,
+				 struct eio_io_region *where, int rw,
+				 struct page **pagelist, struct eio_context *io,
+				 int hddio, int num_vecs, int sync)
+{
+	struct bio *bio;
+	struct page *page;
+	unsigned long len;
+	unsigned offset;
+	int num_bvecs;
+	int remaining_bvecs = num_vecs;
+	int ret = 0;
+	int pindex = 0;
+
+	sector_t remaining = where->count;
+
+	do {
+		/* Verify that num_vecs should not cross the threshhold */
+		/* Check how many max bvecs bdev supports */
+		num_bvecs =
+			min_t(int, bio_get_nr_vecs(where->bdev), remaining_bvecs);
+		bio = bio_alloc(GFP_NOIO, num_bvecs);
+		bio->bi_bdev = where->bdev;
+		bio->bi_sector = where->sector + (where->count - remaining);
+
+		/* Remap the start sector of partition */
+		if (hddio)
+			bio->bi_sector += dmc->dev_start_sect;
+		bio->bi_rw |= rw;
+		bio->bi_end_io = eio_endio;
+		bio->bi_private = io;
+
+		while (remaining) {
+			page = pagelist[pindex];
+			len =
+				min_t(unsigned long, PAGE_SIZE,
+				      to_bytes(remaining));
+			offset = 0;
+
+			if (!bio_add_page(bio, page, len, offset))
+				break;
+
+			remaining -= eio_to_sector(len);
+			pindex++;
+			remaining_bvecs--;
+		}
+
+		atomic_inc(&io->count);
+		if (hddio)
+			dmc->origmfn(bdev_get_queue(bio->bi_bdev), bio);
+
+		else
+			submit_bio(rw, bio);
+
+	} while (remaining);
+
+	EIO_ASSERT(remaining_bvecs == 0);
+	return ret;
+}
+
+/*
+ * This function will dispatch the i/o. It also takes care of
+ * splitting the large I/O requets to smaller I/Os which may not
+ * fit into single bio.
+ */
+
+static int eio_dispatch_io(struct cache_c *dmc, struct eio_io_region *where,
+			   int rw, struct bio_vec *bvec, struct eio_context *io,
+			   int hddio, int num_vecs, int sync)
+{
+	struct bio *bio;
+	struct page *page;
+	unsigned long len;
+	unsigned offset;
+	int num_bvecs;
+	int remaining_bvecs = num_vecs;
+	int ret = 0;
+
+	sector_t remaining = where->count;
+
+	do {
+		/* Verify that num_vecs should not cross the threshhold */
+		/* Check how many max bvecs bdev supports */
+		num_bvecs =
+			min_t(int, bio_get_nr_vecs(where->bdev), remaining_bvecs);
+		bio = bio_alloc(GFP_NOIO, num_bvecs);
+		bio->bi_bdev = where->bdev;
+		bio->bi_sector = where->sector + (where->count - remaining);
+
+		/* Remap the start sector of partition */
+		if (hddio)
+			bio->bi_sector += dmc->dev_start_sect;
+		bio->bi_rw |= rw;
+		bio->bi_end_io = eio_endio;
+		bio->bi_private = io;
+
+		while (remaining) {
+			page = bvec->bv_page;
+			len =
+				min_t(unsigned long, bvec->bv_len,
+				      to_bytes(remaining));
+			offset = bvec->bv_offset;
+
+			if (!bio_add_page(bio, page, len, offset))
+				break;
+
+			offset = 0;
+			remaining -= eio_to_sector(len);
+			bvec = bvec + 1;
+			remaining_bvecs--;
+		}
+
+		atomic_inc(&io->count);
+		if (hddio)
+			dmc->origmfn(bdev_get_queue(bio->bi_bdev), bio);
+		else
+			submit_bio(rw, bio);
+
+	} while (remaining);
+
+	EIO_ASSERT(remaining_bvecs == 0);
+	return ret;
+}
+
+static int eio_async_io(struct cache_c *dmc, struct eio_io_region *where,
+			int rw, struct eio_io_request *req)
+{
+	struct eio_context *io;
+	int err = 0;
+
+	io = mempool_alloc(_io_pool, GFP_NOIO);
+	if (unlikely(io == NULL)) {
+		pr_err("eio_async_io: failed to allocate eio_context.\n");
+		return -ENOMEM;
+	}
+	memset((char *)io, 0, sizeof(struct eio_context));
+
+	atomic_set(&io->count, 1);
+	io->callback = req->notify;
+	io->context = req->context;
+	io->event = NULL;
+
+	switch (req->mtype) {
+	case EIO_BVECS:
+		err =
+			eio_dispatch_io(dmc, where, rw, req->dptr.pages, io,
+					req->hddio, req->num_bvecs, 0);
+		break;
+
+	case EIO_PAGES:
+		err =
+			eio_dispatch_io_pages(dmc, where, rw, req->dptr.plist, io,
+					      req->hddio, req->num_bvecs, 0);
+		break;
+	}
+
+	/* Check if i/o submission has returned any error */
+	if (unlikely(err)) {
+		/* Wait for any i/os which are submitted, to end. */
+retry:
+		if (atomic_read(&io->count) != 1) {
+			schedule_timeout(msecs_to_jiffies(1));
+			goto retry;
+		}
+
+		EIO_ASSERT(io != NULL);
+		mempool_free(io, _io_pool);
+		io = NULL;
+		return err;
+	}
+
+	/* Drop the extra reference count here */
+	eio_dec_count(io, err);
+	return err;
+}
+
+static int eio_sync_io(struct cache_c *dmc, struct eio_io_region *where,
+		       int rw, struct eio_io_request *req)
+{
+	int ret = 0;
+	struct eio_context io;
+
+	DECLARE_COMPLETION_ONSTACK(wait);
+
+	memset((char *)&io, 0, sizeof(io));
+
+	atomic_set(&io.count, 1);
+	io.event = &wait;
+	io.callback = NULL;
+	io.context = NULL;
+
+	/* For synchronous I/Os pass SYNC */
+	rw |= REQ_SYNC;
+
+	switch (req->mtype) {
+	case EIO_BVECS:
+		ret = eio_dispatch_io(dmc, where, rw, req->dptr.pages,
+				      &io, req->hddio, req->num_bvecs, 1);
+		break;
+	case EIO_PAGES:
+		ret = eio_dispatch_io_pages(dmc, where, rw, req->dptr.plist,
+					    &io, req->hddio, req->num_bvecs, 1);
+		break;
+	}
+
+	/* Check if i/o submission has returned any error */
+	if (unlikely(ret)) {
+		/* Wait for any i/os which are submitted, to end. */
+retry:
+		if (atomic_read(&(io.count)) != 1) {
+			schedule_timeout(msecs_to_jiffies(1));
+			goto retry;
+		}
+
+		return ret;
+	}
+
+	/* Drop extra reference count here */
+	eio_dec_count(&io, ret);
+	wait_for_completion(&wait);
+
+	if (io.error)
+		ret = io.error;
+
+	return ret;
+}
+
+int eio_do_io(struct cache_c *dmc, struct eio_io_region *where, int rw,
+	      struct eio_io_request *io_req)
+{
+	if (!io_req->notify)
+		return eio_sync_io(dmc, where, rw, io_req);
+
+	return eio_async_io(dmc, where, rw, io_req);
+}
+
+void eio_process_zero_size_bio(struct cache_c *dmc, struct bio *origbio)
+{
+	unsigned long rw_flags = 0;
+
+	/* Extract bio flags from original bio */
+	rw_flags = origbio->bi_rw;
+
+	EIO_ASSERT(origbio->bi_size == 0);
+	EIO_ASSERT(rw_flags != 0);
+
+	eio_issue_empty_barrier_flush(dmc->cache_dev->bdev, NULL,
+				      EIO_SSD_DEVICE, NULL, rw_flags);
+	eio_issue_empty_barrier_flush(dmc->disk_dev->bdev, origbio,
+				      EIO_HDD_DEVICE, dmc->origmfn, rw_flags);
+}
+
+static void eio_bio_end_empty_barrier(struct bio *bio, int err)
+{
+	if (bio->bi_private)
+		bio_endio(bio->bi_private, err);
+	bio_put(bio);
+	return;
+}
+
+static void eio_issue_empty_barrier_flush(struct block_device *bdev,
+					  struct bio *orig_bio, int device,
+					  make_request_fn *origmfn,
+					  int rw_flags)
+{
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_KERNEL, 0);
+	if (!bio)
+		if (orig_bio)
+			bio_endio(orig_bio, -ENOMEM);
+	bio->bi_end_io = eio_bio_end_empty_barrier;
+	bio->bi_private = orig_bio;
+	bio->bi_bdev = bdev;
+	bio->bi_rw |= rw_flags;
+
+	bio_get(bio);
+	if (device == EIO_HDD_DEVICE)
+		origmfn(bdev_get_queue(bio->bi_bdev), bio);
+
+	else
+		submit_bio(0, bio);
+	bio_put(bio);
+	return;
+}
+
+static int eio_finish_nrdirty(struct cache_c *dmc)
+{
+	int index;
+	int ret = 0;
+	int retry_count;
+
+	/*
+	 * Due to any transient errors, finish_nr_dirty may not drop
+	 * to zero. Retry the clean operations for FINISH_NRDIRTY_RETRY_COUNT.
+	 */
+	retry_count = FINISH_NRDIRTY_RETRY_COUNT;
+
+	index = EIO_HASH_BDEV(dmc->disk_dev->bdev->bd_contains->bd_dev);
+	down_write(&eio_ttc_lock[index]);
+
+	/* Wait for the in-flight I/Os to drain out */
+	while (atomic64_read(&dmc->nr_ios) != 0) {
+		pr_debug("finish_nrdirty: Draining I/O inflight\n");
+		schedule_timeout(msecs_to_jiffies(1));
+	}
+	EIO_ASSERT(!(dmc->sysctl_active.do_clean & EIO_CLEAN_START));
+
+	dmc->sysctl_active.do_clean |= EIO_CLEAN_KEEP | EIO_CLEAN_START;
+	up_write(&eio_ttc_lock[index]);
+
+	/*
+	 * In the process of cleaning CACHE if CACHE turns to FAILED state,
+	 * its a severe error.
+	 */
+	do {
+		if (unlikely(CACHE_FAILED_IS_SET(dmc))) {
+			pr_err
+				("finish_nrdirty: CACHE \"%s\" is in FAILED state.",
+				dmc->cache_name);
+			ret = -ENODEV;
+			break;
+		}
+
+		if (!dmc->sysctl_active.fast_remove)
+			eio_clean_all(dmc);
+	} while (!dmc->sysctl_active.fast_remove &&
+		 (atomic64_read(&dmc->nr_dirty) > 0)
+		 && (!(dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG)));
+	dmc->sysctl_active.do_clean &= ~EIO_CLEAN_START;
+
+	/*
+	 * If all retry_count exhausted and nr_dirty is still not zero.
+	 * Return error.
+	 */
+	if (((dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG) ||
+	     (retry_count == 0)) && (atomic64_read(&dmc->nr_dirty) > 0))
+		ret = -EINVAL;
+	if (ret)
+		pr_err
+			("finish_nrdirty: Failed to finish %llu dirty blocks for cache \"%s\".",
+			(unsigned long long)atomic64_read(&dmc->nr_dirty), dmc->cache_name);
+
+	return ret;
+}
+
+int eio_cache_edit(char *cache_name, u_int32_t mode, u_int32_t policy)
+{
+	int error = 0;
+	int index;
+	struct cache_c *dmc;
+	uint32_t old_time_thresh = 0;
+	int restart_async_task = 0;
+	int ret;
+
+	EIO_ASSERT((mode != 0) || (policy != 0));
+
+	dmc = eio_cache_lookup(cache_name);
+	if (NULL == dmc) {
+		pr_err("cache_edit: cache %s do not exist", cache_name);
+		return -EINVAL;
+	}
+
+	if ((dmc->mode == mode) && (dmc->req_policy == policy))
+		return 0;
+
+	if (unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+	    unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+		pr_err("cache_edit: Cannot proceed with edit on cache \"%s\"" \
+		       ". Cache is in failed or degraded state.",
+		       dmc->cache_name);
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	if (dmc->cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG) {
+		pr_err("cache_edit: system shutdown in progress, cannot edit" \
+		       " cache %s", cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return -EINVAL;
+	}
+	if (dmc->cache_flags & CACHE_FLAGS_MOD_INPROG) {
+		pr_err("cache_edit: simultaneous edit/delete operation on " \
+		       "cache %s is not permitted", cache_name);
+		spin_unlock_irqrestore(&dmc->cache_spin_lock,
+				       dmc->cache_spin_lock_flags);
+		return -EINVAL;
+	}
+	dmc->cache_flags |= CACHE_FLAGS_MOD_INPROG;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+	old_time_thresh = dmc->sysctl_active.time_based_clean_interval;
+
+	if (dmc->mode == CACHE_MODE_WB) {
+		if (CACHE_FAILED_IS_SET(dmc)) {
+			pr_err
+				("cache_edit:  Can not proceed with edit for Failed cache \"%s\".",
+				dmc->cache_name);
+			error = -EINVAL;
+			goto out;
+		}
+		eio_stop_async_tasks(dmc);
+		restart_async_task = 1;
+	}
+
+	/* Wait for nr_dirty to drop to zero */
+	if (dmc->mode == CACHE_MODE_WB && mode != CACHE_MODE_WB) {
+		if (CACHE_FAILED_IS_SET(dmc)) {
+			pr_err
+				("cache_edit:  Can not proceed with edit for Failed cache \"%s\".",
+				dmc->cache_name);
+			error = -EINVAL;
+			goto out;
+		}
+
+		error = eio_finish_nrdirty(dmc);
+		/* This error can mostly occur due to Device removal */
+		if (unlikely(error)) {
+			pr_err
+				("cache_edit: nr_dirty FAILED to finish for cache \"%s\".",
+				dmc->cache_name);
+			goto out;
+		}
+		EIO_ASSERT((dmc->sysctl_active.do_clean & EIO_CLEAN_KEEP) &&
+			   !(dmc->sysctl_active.do_clean & EIO_CLEAN_START));
+		EIO_ASSERT(dmc->sysctl_active.fast_remove ||
+			   (atomic64_read(&dmc->nr_dirty) == 0));
+	}
+
+	index = EIO_HASH_BDEV(dmc->disk_dev->bdev->bd_contains->bd_dev);
+	down_write(&eio_ttc_lock[index]);
+
+	/* Wait for the in-flight I/Os to drain out */
+	while (atomic64_read(&dmc->nr_ios) != 0) {
+		pr_debug("cache_edit: Draining I/O inflight\n");
+		schedule_timeout(msecs_to_jiffies(1));
+	}
+
+	pr_debug("cache_edit: Blocking application I/O\n");
+
+	EIO_ASSERT(atomic64_read(&dmc->nr_ios) == 0);
+
+	/* policy change */
+	if ((policy != 0) && (policy != dmc->req_policy)) {
+		error = eio_policy_switch(dmc, policy);
+		if (error) {
+			up_write(&eio_ttc_lock[index]);
+			goto out;
+		}
+	}
+
+	/* mode change */
+	if ((mode != 0) && (mode != dmc->mode)) {
+		error = eio_mode_switch(dmc, mode);
+		if (error) {
+			up_write(&eio_ttc_lock[index]);
+			goto out;
+		}
+	}
+
+	dmc->sysctl_active.time_based_clean_interval = old_time_thresh;
+	/* write updated superblock */
+	error = eio_sb_store(dmc);
+	if (error) {
+		/* XXX: In case of error put the cache in degraded mode. */
+		pr_err("eio_cache_edit: superblock update failed(error %d)",
+		       error);
+		goto out;
+	}
+
+	eio_procfs_dtr(dmc);
+	eio_procfs_ctr(dmc);
+
+	up_write(&eio_ttc_lock[index]);
+
+out:
+	dmc->sysctl_active.time_based_clean_interval = old_time_thresh;
+
+	/*
+	 * Resetting EIO_CLEAN_START and EIO_CLEAN_KEEP flags.
+	 * EIO_CLEAN_START flag should be restored if eio_stop_async_tasks()
+	 * is not called in future.
+	 */
+
+	dmc->sysctl_active.do_clean &= ~(EIO_CLEAN_START | EIO_CLEAN_KEEP);
+
+	/* Restart async-task for "WB" cache. */
+	if ((dmc->mode == CACHE_MODE_WB) && (restart_async_task == 1)) {
+		pr_debug("cache_edit: Restarting the clean_thread.\n");
+		EIO_ASSERT(dmc->clean_thread == NULL);
+		ret = eio_start_clean_thread(dmc);
+		if (ret) {
+			error = ret;
+			pr_err
+				("cache_edit: Failed to restart async tasks. error=%d.\n",
+				ret);
+		}
+		if (dmc->sysctl_active.time_based_clean_interval &&
+		    atomic64_read(&dmc->nr_dirty)) {
+			schedule_delayed_work(&dmc->clean_aged_sets_work,
+					      dmc->
+					      sysctl_active.time_based_clean_interval
+					      * 60 * HZ);
+			dmc->is_clean_aged_sets_sched = 1;
+		}
+	}
+	spin_lock_irqsave(&dmc->cache_spin_lock, dmc->cache_spin_lock_flags);
+	dmc->cache_flags &= ~CACHE_FLAGS_MOD_INPROG;
+	spin_unlock_irqrestore(&dmc->cache_spin_lock,
+			       dmc->cache_spin_lock_flags);
+	pr_debug("eio_cache_edit: Allowing application I/O\n");
+	return error;
+}
+
+static int eio_mode_switch(struct cache_c *dmc, u_int32_t mode)
+{
+	int error = 0;
+	u_int32_t orig_mode;
+
+	EIO_ASSERT(dmc->mode != mode);
+	pr_debug("eio_mode_switch: mode switch from %u to %u\n",
+		 dmc->mode, mode);
+
+	if (mode == CACHE_MODE_WB) {
+		orig_mode = dmc->mode;
+		dmc->mode = mode;
+
+		error = eio_allocate_wb_resources(dmc);
+		if (error) {
+			dmc->mode = orig_mode;
+			goto out;
+		}
+	} else if (dmc->mode == CACHE_MODE_WB) {
+		eio_free_wb_resources(dmc);
+		dmc->mode = mode;
+	} else {                /* (RO -> WT) or (WT -> RO) */
+		EIO_ASSERT(((dmc->mode == CACHE_MODE_RO) && (mode == CACHE_MODE_WT))
+			   || ((dmc->mode == CACHE_MODE_WT) &&
+			       (mode == CACHE_MODE_RO)));
+		dmc->mode = mode;
+	}
+
+out:
+	if (error)
+		pr_err("mode_switch: Failed to switch mode, error: %d\n",
+		       error);
+	return error;
+}
+
+/*
+ * XXX: Error handling.
+ * In case of error put the cache in degraded mode.
+ */
+
+static int eio_policy_switch(struct cache_c *dmc, u_int32_t policy)
+{
+	int error;
+
+	EIO_ASSERT(dmc->req_policy != policy);
+
+	eio_policy_free(dmc);
+
+	dmc->req_policy = policy;
+	error = eio_policy_init(dmc);
+	if (error)
+		goto out;
+
+	error = eio_repl_blk_init(dmc->policy_ops);
+	if (error) {
+		pr_err
+			("eio_policy_swtich: Unable to allocate memory for policy cache block");
+		goto out;
+	}
+
+	error = eio_repl_sets_init(dmc->policy_ops);
+	if (error) {
+		pr_err
+			("eio_policy_switch: Failed to allocate memory for cache policy");
+		goto out;
+	}
+
+	eio_policy_lru_pushblks(dmc->policy_ops);
+	return 0;
+
+out:
+	eio_policy_free(dmc);
+	dmc->req_policy = CACHE_REPL_RANDOM;
+	(void)eio_policy_init(dmc);
+	return error;
+}
+
+void eio_free_wb_pages(struct page **pages, int allocated)
+{
+	/* Verify that allocated is never 0 or less that zero. */
+	if (allocated <= 0)
+		return;
+
+	do
+		put_page(pages[--allocated]);
+	while (allocated);
+
+	*pages = NULL;
+}
+
+void eio_free_wb_bvecs(struct bio_vec *bvec, int allocated, int blksize)
+{
+	int i;
+
+	if (allocated <= 0)
+		return;
+
+	for (i = 0; i < allocated; i++) {
+		switch (blksize) {
+		case BLKSIZE_2K:
+			/*
+			 * For 2k blocksize, each page is shared between two
+			 * bio_vecs. Hence make sure to put_page only for even
+			 * indexes.
+			 */
+			if (((i % 2) == 0) && bvec[i].bv_page) {
+				put_page(bvec[i].bv_page);
+				bvec[i].bv_page = NULL;
+				continue;
+			}
+
+			/* For odd index page should already have been freed. */
+			if ((i % 2))
+				bvec[i].bv_page = NULL;
+
+			continue;
+
+		case BLKSIZE_4K:
+		case BLKSIZE_8K:
+			if (bvec[i].bv_page) {
+				put_page(bvec[i].bv_page);
+				bvec[i].bv_page = NULL;
+			}
+
+			continue;
+		}
+	}
+}
+
+/*
+ * This function allocates pages to array of bvecs allocated by caller.
+ * It has special handling of blocksize of 2k where single page is
+ * shared between two bio_vecs.
+ */
+
+int eio_alloc_wb_bvecs(struct bio_vec *bvec, int max, int blksize)
+{
+	int i, ret;
+	struct bio_vec *iovec;
+	struct page *page;
+
+	ret = 0;
+	iovec = bvec;
+	page = NULL;
+
+	for (i = 0; i < max; i++) {
+		switch (blksize) {
+		case BLKSIZE_2K:
+			/*
+			 * In case of 2k blocksize, two biovecs will be sharing
+			 * same page address. This is handled below.
+			 */
+
+			if ((i % 2) == 0) {
+				/* Allocate page only for even bio vector */
+				page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+				if (unlikely(!page)) {
+					pr_err
+						("eio_alloc_wb_bvecs: System memory too low.\n");
+					goto err;
+				}
+				iovec[i].bv_page = page;
+				iovec[i].bv_len = to_bytes(blksize);
+				iovec[i].bv_offset = 0;
+			} else {
+				/* Let the odd biovec share page allocated earlier. */
+				EIO_ASSERT(page != NULL);
+				iovec[i].bv_page = page;
+				iovec[i].bv_len = to_bytes(blksize);
+				iovec[i].bv_offset =
+					PAGE_SIZE - to_bytes(blksize);
+
+				/* Mark page NULL here as it is not required anymore. */
+				page = NULL;
+			}
+
+			continue;
+
+		case BLKSIZE_4K:
+		case BLKSIZE_8K:
+			page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+			if (unlikely(!page)) {
+				pr_err("eio_alloc_wb_bvecs:" \
+				       " System memory too low.\n");
+				goto err;
+			}
+			iovec[i].bv_page = page;
+			iovec[i].bv_offset = 0;
+			iovec[i].bv_len = PAGE_SIZE;
+
+			page = NULL;
+			continue;
+		}
+	}
+
+	goto out;
+
+err:
+	if (i != max) {
+		if (i > 0)
+			eio_free_wb_bvecs(bvec, i, blksize);
+		ret = -ENOMEM;
+	}
+
+out:
+	return ret;
+}
+
+int eio_alloc_wb_pages(struct page **pages, int max)
+{
+	int i, ret = 0;
+	struct page *page;
+
+	for (i = 0; i < max; i++) {
+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (unlikely(!page)) {
+			pr_err("alloc_wb_pages: System memory too low.\n");
+			break;
+		}
+		pages[i] = page;
+	}
+
+	if (i != max) {
+		if (i > 0)
+			eio_free_wb_pages(pages, i);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
+/*
+ ****************************************************************************
+ * struct bio_vec *eio_alloc_pages(int max_pages, int *page_count)
+ * dmc : cache object
+ * pages : bio_vec to be allocated for synchronous I/O.
+ * page_count : total number of pages allocated.
+ ****************************************************************************
+ *
+ * This function allocates pages capped to minimum of
+ * MD_MAX_NR_PAGES OR maximun number of pages supported by
+ * block device.
+ * This is to ensure that the pages allocated should fit
+ * into single bio request.
+ */
+
+struct bio_vec *eio_alloc_pages(u_int32_t max_pages, int *page_count)
+{
+	int pcount, i;
+	struct bio_vec *pages;
+	int nr_pages;
+
+	/*
+	 * Find out no. of pages supported by block device max capped to
+	 * MD_MAX_NR_PAGES;
+	 */
+	nr_pages = min_t(u_int32_t, max_pages, MD_MAX_NR_PAGES);
+
+	pages = kzalloc(nr_pages * sizeof(struct bio_vec), GFP_NOIO);
+	if (unlikely(!pages)) {
+		pr_err("eio_alloc_pages: System memory too low.\n");
+		return NULL;
+	}
+
+	pcount = 0;
+	for (i = 0; i < nr_pages; i++) {
+		pages[i].bv_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (unlikely(!pages[i].bv_page)) {
+			pr_err("eio_alloc_pages: System memory too low.\n");
+			break;
+		} else {
+			pages[i].bv_len = PAGE_SIZE;
+			pages[i].bv_offset = 0;
+			pcount++;
+		}
+	}
+
+	if (pcount == 0) {
+		pr_err("Single page allocation failed. System memory too low.");
+		kfree(pages);
+		return NULL;
+	}
+
+	/* following can be commented out later...
+	 * we may have less pages allocated.
+	 */
+	EIO_ASSERT(pcount == nr_pages);
+
+	/* Set the return values here */
+	*page_count = pcount;
+	return pages;
+}
+
+/*
+ * As part of reboot handling, stop all activies and mark the devices as
+ * read only.
+ */
+
+int eio_reboot_handling(void)
+{
+	struct cache_c *dmc, *tempdmc = NULL;
+	int i, error;
+	uint32_t old_time_thresh;
+
+	if (eio_reboot_notified == EIO_REBOOT_HANDLING_DONE)
+		return 0;
+
+	(void)wait_on_bit_lock((void *)&eio_control->synch_flags,
+			       EIO_HANDLE_REBOOT, eio_wait_schedule,
+			       TASK_UNINTERRUPTIBLE);
+	if (eio_reboot_notified == EIO_REBOOT_HANDLING_DONE) {
+		clear_bit(EIO_HANDLE_REBOOT, (void *)&eio_control->synch_flags);
+		smp_mb__after_clear_bit();
+		wake_up_bit((void *)&eio_control->synch_flags,
+			    EIO_HANDLE_REBOOT);
+		return 0;
+	}
+	EIO_ASSERT(eio_reboot_notified == 0);
+	eio_reboot_notified = EIO_REBOOT_HANDLING_INPROG;
+
+	for (i = 0; i < EIO_HASHTBL_SIZE; i++) {
+		down_write(&eio_ttc_lock[i]);
+		list_for_each_entry(dmc, &eio_ttc_list[i], cachelist) {
+
+			kfree(tempdmc);
+			tempdmc = NULL;
+			if (unlikely(CACHE_FAILED_IS_SET(dmc)) ||
+			    unlikely(CACHE_DEGRADED_IS_SET(dmc))) {
+				pr_err
+					("Cache \"%s\" is in failed/degraded " \
+					"mode. Cannot mark cache read only.\n",
+					dmc->cache_name);
+				continue;
+			}
+
+			while (atomic64_read(&dmc->nr_ios) != 0) {
+				pr_debug("rdonly: Draining I/O inflight\n");
+				schedule_timeout(msecs_to_jiffies(10));
+			}
+
+			EIO_ASSERT(atomic64_read(&dmc->nr_ios) == 0);
+			EIO_ASSERT(dmc->cache_rdonly == 0);
+
+			/*
+			 * Shutdown processing has the highest priority.
+			 * Stop all ongoing activities.
+			 */
+
+			spin_lock_irqsave(&dmc->cache_spin_lock,
+					  dmc->cache_spin_lock_flags);
+			EIO_ASSERT(!
+				   (dmc->
+				    cache_flags & CACHE_FLAGS_SHUTDOWN_INPROG));
+			dmc->cache_flags |= CACHE_FLAGS_SHUTDOWN_INPROG;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+
+			/*
+			 * Wait for ongoing edit/delete to complete.
+			 */
+
+			while (dmc->cache_flags & CACHE_FLAGS_MOD_INPROG) {
+				up_write(&eio_ttc_lock[i]);
+				schedule_timeout(msecs_to_jiffies(1));
+				down_write(&eio_ttc_lock[i]);
+			}
+			if (dmc->cache_flags & CACHE_FLAGS_DELETED) {
+				/*
+				 * Cache got deleted. Free the dmc.
+				 */
+
+				tempdmc = dmc;
+				continue;
+			}
+			old_time_thresh =
+				dmc->sysctl_active.time_based_clean_interval;
+			eio_stop_async_tasks(dmc);
+			dmc->sysctl_active.time_based_clean_interval =
+				old_time_thresh;
+
+			dmc->cache_rdonly = 1;
+			pr_info("Cache \"%s\" marked read only\n",
+				dmc->cache_name);
+			up_write(&eio_ttc_lock[i]);
+
+			if (dmc->cold_boot && atomic64_read(&dmc->nr_dirty) &&
+			    !eio_force_warm_boot) {
+				pr_info
+					("Cold boot set for cache %s: Draining dirty blocks: %llu",
+					dmc->cache_name,
+					(unsigned long long)atomic64_read(&dmc->nr_dirty));
+				eio_clean_for_reboot(dmc);
+			}
+
+			error = eio_md_store(dmc);
+			if (error)
+				pr_err("Cannot mark cache \"%s\" read only\n",
+				       dmc->cache_name);
+
+			spin_lock_irqsave(&dmc->cache_spin_lock,
+					  dmc->cache_spin_lock_flags);
+			dmc->cache_flags &= ~CACHE_FLAGS_SHUTDOWN_INPROG;
+			spin_unlock_irqrestore(&dmc->cache_spin_lock,
+					       dmc->cache_spin_lock_flags);
+
+			down_write(&eio_ttc_lock[i]);
+		}
+		kfree(tempdmc);
+		tempdmc = NULL;
+		up_write(&eio_ttc_lock[i]);
+	}
+
+	eio_reboot_notified = EIO_REBOOT_HANDLING_DONE;
+	clear_bit(EIO_HANDLE_REBOOT, (void *)&eio_control->synch_flags);
+	smp_mb__after_clear_bit();
+	wake_up_bit((void *)&eio_control->synch_flags, EIO_HANDLE_REBOOT);
+	return 0;
+}
+
+static int eio_overlap_split_bio(struct request_queue *q, struct bio *bio)
+{
+	int i, nbios;
+	void **bioptr;
+	sector_t snum;
+	struct bio_container *bc;
+	unsigned bvec_idx;
+	unsigned bvec_consumed;
+
+	nbios = bio->bi_size >> SECTOR_SHIFT;
+	snum = bio->bi_sector;
+
+	bioptr = kmalloc(nbios * (sizeof(void *)), GFP_KERNEL);
+	if (!bioptr) {
+		bio_endio(bio, -ENOMEM);
+		return 0;
+	}
+	bc = kmalloc(sizeof(struct bio_container), GFP_NOWAIT);
+	if (!bc) {
+		bio_endio(bio, -ENOMEM);
+		kfree(bioptr);
+		return 0;
+	}
+
+	atomic_set(&bc->bc_holdcount, nbios);
+	bc->bc_bio = bio;
+	bc->bc_error = 0;
+
+	bvec_idx = bio->bi_idx;
+	bvec_consumed = 0;
+	for (i = 0; i < nbios; i++) {
+		bioptr[i] =
+			eio_split_new_bio(bio, bc, &bvec_idx,
+					&bvec_consumed, snum);
+		if (!bioptr[i])
+			break;
+		snum++;
+	}
+
+	/* Error: cleanup */
+	if (i < nbios) {
+		for (i--; i >= 0; i--)
+			bio_put(bioptr[i]);
+		bio_endio(bio, -ENOMEM);
+		kfree(bc);
+		goto out;
+	}
+
+	for (i = 0; i < nbios; i++)
+		eio_make_request_fn(q, bioptr[i]);
+
+out:
+	kfree(bioptr);
+	return 0;
+}
+
+static struct bio *eio_split_new_bio(struct bio *bio, struct bio_container *bc,
+				     unsigned *bvec_idx,
+				     unsigned *bvec_consumed, sector_t snum)
+{
+	struct bio *cbio;
+	unsigned iosize = 1 << SECTOR_SHIFT;
+
+	cbio = bio_alloc(GFP_NOIO, 1);
+	if (!cbio)
+		return NULL;
+
+	EIO_ASSERT(bio->bi_io_vec[*bvec_idx].bv_len >= iosize);
+
+	if (bio->bi_io_vec[*bvec_idx].bv_len <= *bvec_consumed) {
+		EIO_ASSERT(bio->bi_io_vec[*bvec_idx].bv_len == *bvec_consumed);
+		(*bvec_idx)++;
+		EIO_ASSERT(bio->bi_vcnt > *bvec_idx);
+		*bvec_consumed = 0;
+	}
+
+	cbio->bi_io_vec[0].bv_page = bio->bi_io_vec[*bvec_idx].bv_page;
+	cbio->bi_io_vec[0].bv_offset =
+		bio->bi_io_vec[*bvec_idx].bv_offset + *bvec_consumed;
+	cbio->bi_io_vec[0].bv_len = iosize;
+	*bvec_consumed += iosize;
+
+	cbio->bi_sector = snum;
+	cbio->bi_size = iosize;
+	cbio->bi_bdev = bio->bi_bdev;
+	cbio->bi_rw = bio->bi_rw;
+	cbio->bi_vcnt = 1;
+	cbio->bi_idx = 0;
+	cbio->bi_end_io = eio_split_endio;
+	cbio->bi_private = bc;
+	return cbio;
+}
+
+static void eio_split_endio(struct bio *bio, int error)
+{
+	struct bio_container *bc = bio->bi_private;
+
+	if (error)
+		bc->bc_error = error;
+	bio_put(bio);
+	if (atomic_dec_and_test(&bc->bc_holdcount)) {
+		bio_endio(bc->bc_bio, bc->bc_error);
+		kfree(bc);
+	}
+	return;
+}
diff --git a/drivers/block/enhanceio/eio_ttc.h b/drivers/block/enhanceio/eio_ttc.h
new file mode 100644
index 0000000..62e90f7
--- /dev/null
+++ b/drivers/block/enhanceio/eio_ttc.h
@@ -0,0 +1,152 @@
+/*
+ * Copyright (C) 2012 sTec(R), Inc. All rights not specifically granted
+ * under a license included herein are reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; under version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ */
+
+#ifndef EIO_TTC_H
+#define EIO_TTC_H
+
+#ifdef __KERNEL__
+#include <linux/device-mapper.h>
+#define curthread       get_current()
+#else
+#include <stdint.h>
+#endif                          /* __KERNEL__ */
+
+static inline bool bio_rw_flagged(struct bio *bio, int flag)
+{
+	return (bio->bi_rw & flag) != 0;
+}
+
+/*
+ * Whether the cached (source) device is a partition or a whole device.
+ * dmc->dev_info stores this info.
+ */
+enum eio_io_mem_type {
+	EIO_BVECS,              /* bio vectors */
+	EIO_PAGES,              /* array of pages */
+};
+
+struct eio_io_request {
+	enum eio_io_mem_type mtype;
+
+	union {
+		struct bio_vec *pages;
+		struct page **plist;
+	} dptr;
+
+	unsigned num_bvecs;
+	eio_notify_fn notify;
+	void *context;
+	unsigned hddio;
+};
+
+struct eio_context {
+	atomic_t count;
+	int error;
+	struct completion *event;
+	eio_notify_fn callback;
+	void *context;
+};
+
+int eio_do_io(struct cache_c *dmc, struct eio_io_region *where, int rw,
+	      struct eio_io_request *io_req);
+
+enum eio_device {
+	EIO_HDD_DEVICE = 1,
+	EIO_SSD_DEVICE,
+};
+
+enum eio_dev_info {
+	EIO_DEV_PARTITION = 1,
+	EIO_DEV_WHOLE_DISK
+};
+
+enum eio_cache_state {
+	DMC_TTC_INITIALIZING = 1,
+	DMC_TTC_READY,
+	DMC_TTC_IO_FREEZE,
+	DMC_TTC_UNINITIALIZING,
+	DMC_TTC_UNINITIALIZED
+};
+
+#ifdef __KERNEL__
+
+#define EIO_HASHTBL_SIZE        1024
+
+/*
+ * In case of i/o errors while eio_clean_all, retry for
+ * finish_nrdirty_retry count.
+ */
+#define FINISH_NRDIRTY_RETRY_COUNT      2
+
+#define EIO_HASH_BDEV(dev)	\
+	((MAJOR(dev) * EIO_MAGIC + MINOR(dev)) % EIO_HASHTBL_SIZE)
+
+/*
+ * Reboot status flags.
+ */
+
+#define EIO_REBOOT_HANDLING_INPROG      0x01
+#define EIO_REBOOT_HANDLING_DONE        0x02
+
+/*
+ * kernel function prototypes.
+ */
+
+extern int eio_create_misc_device(void);
+extern int eio_delete_misc_device(void);
+
+extern int eio_ttc_get_device(const char *, fmode_t, struct eio_bdev **);
+extern void eio_ttc_put_device(struct eio_bdev **);
+
+extern struct cache_c *eio_cache_lookup(char *);
+extern int eio_ttc_activate(struct cache_c *);
+extern int eio_ttc_deactivate(struct cache_c *, int);
+extern void eio_ttc_init(void);
+
+extern int eio_cache_create(struct cache_rec_short *);
+extern int eio_cache_delete(char *, int);
+extern uint64_t eio_get_cache_count(void);
+extern int eio_get_cache_list(unsigned long *);
+
+extern int eio_handle_ssd_message(char *cache_name, char *ssd_name,
+				  enum dev_notifier note);
+
+int eio_do_preliminary_checks(struct cache_c *);
+
+extern int eio_allocate_wb_resources(struct cache_c *);
+extern void eio_free_wb_resources(struct cache_c *);
+
+extern int eio_cache_edit(char *, u_int32_t, u_int32_t);
+
+extern void eio_stop_async_tasks(struct cache_c *dmc);
+extern int eio_start_clean_thread(struct cache_c *dmc);
+
+extern int eio_policy_init(struct cache_c *);
+extern void eio_policy_free(struct cache_c *);
+extern int eio_alloc_wb_pages(struct page **pages, int max);
+extern void eio_free_wb_pages(struct page **pages, int allocated);
+extern int eio_alloc_wb_bvecs(struct bio_vec *bvec, int max, int blksize);
+extern void eio_free_wb_bvecs(struct bio_vec *bvec, int allocated, int blksize);
+extern struct bio_vec *eio_alloc_pages(u_int32_t max_pages, int *page_count);
+extern int eio_md_store(struct cache_c *);
+extern int eio_reboot_handling(void);
+extern void eio_process_zero_size_bio(struct cache_c *dmc, struct bio *origbio);
+extern long eio_ioctl(struct file *filp, unsigned cmd, unsigned long arg);
+extern long eio_compact_ioctl(struct file *filp, unsigned cmd,
+			      unsigned long arg);
+#endif                          /* __KERNEL__ */
+
+#endif                          /* EIO_TTC_H */
diff --git a/tools/enhanceio/eio_cli b/tools/enhanceio/eio_cli
new file mode 100755
index 0000000..216e680
--- /dev/null
+++ b/tools/enhanceio/eio_cli
@@ -0,0 +1,668 @@
+#!/usr/bin/python
+#
+# Copyright (C) 2013 sTec(R), Inc. All rights not specifically granted
+# under a license included herein are reserved
+# Wrote a python based CLI for admistration of Enhanceio Driver
+# Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; under version 2 of the License.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+
+from ctypes import *
+from fcntl import *
+from argparse import ArgumentParser
+import sys,struct
+import subprocess
+import os
+import re
+
+#TBD : Change ioctl numbers to comply with linux kernel convention
+EIODEV = '/dev/eiodev'
+EIO_IOC_CREATE = 1104168192
+EIO_IOC_DELETE = 1104168193
+EIO_IOC_ENABLE = 1104168194
+EIO_IOC_DISABLE = 1104168195
+EIO_IOC_EDIT = 1104168196
+EIO_IOC_NCACHES = 1104168197
+EIO_IOC_CACHE_LIST = 1104168198
+EIO_IOC_SSD_ADD = 1104168199
+EIO_IOC_SSD_REMOVE = 1104168200
+EIO_IOC_SRC_ADD = 1104168201
+EIO_IOC_SRC_REMOVE = 1104168202
+IOC_BLKGETSIZE64 = 0x80081272
+IOC_SECTSIZE = 0x1268
+SUCCESS=0
+FAILURE=3
+
+FIOCMD="fio --rw=randrw --verify=meta --verify_pattern=0x3982 --ioengine=libaio \
+	--iodepth=16 --direct=1 --size=1G --bsrange=512-128K --numjobs=10 \
+	--group_reporting --time_based --runtime=180 --name=job1 --filename="
+
+udev_template = """
+ACTION!="add|change", GOTO="EIO_EOF"
+SUBSYSTEM!="block", GOTO="EIO_EOF"
+
+<cache_match_expr>, GOTO="EIO_CACHE"
+<source_match_expr>, GOTO="EIO_SOURCE"
+
+# If none of the rules above matched then it isn't an \
+EnhanceIO device so ignore it.
+GOTO="EIO_EOF"
+
+#=================== EIO_CACHE =======================
+
+# If we just found the cache device and the source already \
+exists then we can setup
+
+LABEL="EIO_CACHE"
+TEST!="/dev/enhanceio/<cache_name>", \
+PROGRAM="/bin/mkdir -p /dev/enhanceio/<cache_name>"
+PROGRAM="/bin/sh -c 'echo $kernel > /dev/enhanceio/<cache_name>/.ssd_name'"
+TEST=="/proc/enhanceio/<cache_name>", \
+RUN+="/sbin/eio_cli notify -a add -s /dev/$kernel -c <cache_name>", \
+GOTO="EIO_EOF"
+
+TEST=="/dev/enhanceio/<cache_name>/.disk_name", GOTO="EIO_SETUP"
+
+GOTO="EIO_EOF"
+
+#=================== EIO_SOURCE =======================
+
+# If we just found the source device and the cache already \
+exists then we can setup
+
+LABEL="EIO_SOURCE"
+TEST=="/dev/enhanceio/<cache_name>/.eio_delete", GOTO="EIO_SOURCE_DELETE"
+TEST!="/dev/enhanceio/<cache_name>", PROGRAM="/bin/mkdir -p \
+/dev/enhanceio/<cache_name>"
+PROGRAM="/bin/sh -c 'echo $kernel > /dev/enhanceio/<cache_name>/.disk_name'"
+
+PROGRAM="/bin/sh -c 'echo $major $minor > \
+/dev/enhanceio/<cache_name>/.disk_mjr_mnr'"
+
+PROGRAM="/bin/sh -c 'echo $links > \
+/dev/enhanceio/<cache_name>/.srclinks'"
+
+TEST=="/proc/enhanceio/<cache_name>",\
+PROGRAM="/bin/grep 'state\s*failed' /proc/enhanceio/<cache_name>/config", \
+PROGRAM="/bin/grep 'no_source_dev\s*1' /proc/enhanceio/<cache_name>/errors", \
+RUN+="/sbin/eio_admin notify -a add -d /dev/$kernel -c <cache_name>", NAME="", \
+GOTO="EIO_EOF"
+
+TEST!="/proc/enhanceio/<cache_name>", \
+TEST!="/dev/enhanceio/<cache_name>/.eio_delete", ACTION!="change", NAME=""
+
+TEST=="/dev/enhanceio/<cache_name>/.ssd_name", GOTO="EIO_SETUP"
+
+GOTO="EIO_EOF"
+
+#=================== EIO_SOURCE_DELETE =======================
+
+LABEL="EIO_SOURCE_DELETE"
+PROGRAM="/bin/sh -c 'cat /dev/enhanceio/<cache_name>/.disk_name'", \
+ENV{disk_name}="%c"
+TEST=="/dev/enhanceio/<cache_name>/.disk_name", ENV{disk_name}=="?*", \
+NAME="$env{disk_name}"
+PROGRAM="/bin/unlink /dev/enhanceio/<cache_name>/.disk_name"
+PROGRAM="/bin/unlink /dev/enhanceio/<cache_name>/.disk_mjr_mnr"
+GOTO="EIO_EOF"
+#=================== EIO_SETUP =======================
+
+LABEL="EIO_SETUP"
+PROGRAM="/bin/sh -c 'cat /dev/enhanceio/<cache_name>/.ssd_name'", \
+ENV{ssd_name}="%c"
+PROGRAM="/bin/sh -c 'cat /dev/enhanceio/<cache_name>/.disk_name'", \
+ENV{disk_name}="%c"
+
+TEST!="/proc/enhanceio/<cache_name>", \
+TEST!="/dev/enhanceio/<cache_name>/.skip_enable", \
+RUN+="/bin/sh -c '/bin/mknod /dev/$env{disk_name} b \
+`/bin/cat /dev/enhanceio/<cache_name>/.disk_mjr_mnr`'"
+
+TEST!="/proc/enhanceio/<cache_name>", \
+RUN+="/bin/sh -c ' for i in `cat /dev/enhanceio/<cache_name>/.srclinks`; \
+do rm -f /dev/$$i; ln -f -s /dev/$env{disk_name} /dev/$$i; done'"
+
+
+TEST!="/proc/enhanceio/<cache_name>", RUN+="/sbin/eio_cli \
+enable -d /dev/$env{disk_name} -s /dev/$env{ssd_name} -m <mode> \
+-b <block_size> -p <policy> -c <cache_name>"
+
+LABEL="EIO_EOF"
+"""
+
+def make_udev_match_expr(dev_path, cache_name):
+	dict_udev = {}
+	status = run_cmd("udevadm info --query=property --name=" + dev_path)
+	for line in status.output.split('\n'):
+		if line is not '':
+			temp = line.split("=", 1)
+			dict_udev[temp[0].strip()] = temp[1].strip()
+
+	# DM devices
+	if dict_udev["DEVTYPE"] == "disk" and "DM_UUID" in dict_udev:
+		match_expr='ENV{DM_UUID}=="'+ dict_udev["DM_UUID"] + \
+			 '", ENV{DEVTYPE}=="' + dict_udev["DEVTYPE"] +'"'
+		return	match_expr
+
+	# MD devices
+	if "MD_UUID" in dict_udev:
+		if dict_udev["DEVTYPE"] == "disk" and \
+		"MD_DEV_UUID" not in dict_udev:
+			match_expr='ENV{MD_UUID}=="' + dict_udev["MD_UUID"] + \
+			'", ENV{DEVTYPE}=="' + dict_udev["DEVTYPE"] + '"'
+			return match_expr
+
+		elif dict_udev["DEVTYPE"] == "partition":
+			try:
+				with open("/sys" + dict_udev["DEVPATH"] + "/partition") as f:
+					partition_num = f.read().strip()
+					match_expr='ENV{MD_UUID}=="' + \
+					'", ENV{MD_DEV_UUID}=="' + \
+					'", ATTR{partition}=="' + partition_num + '"'
+					return match_expr
+			except IOError as e:
+				pass
+
+	# Partition
+	if dict_udev["DEVTYPE"] == "partition" and "ID_SERIAL" in dict_udev:
+		try:
+			with open("/sys" + dict_udev["DEVPATH"] + "/partition") as f:
+				partition_num = f.read().strip()
+				match_expr='ENV{ID_SERIAL}=="' + \
+				dict_udev["ID_SERIAL"] + \
+				'", ATTR{partition}=="' + partition_num + '"'
+				return match_expr
+		except IOError as e:
+			pass
+
+
+	# Disk
+	if dict_udev["DEVTYPE"] == "disk" and "ID_SERIAL" in dict_udev :
+		match_expr='ENV{ID_SERIAL}=="'+ dict_udev["ID_SERIAL"] + \
+		'", ENV{DEVTYPE}=="'+ dict_udev["DEVTYPE"] +'"'
+		return match_expr
+
+	# Partition or disk w/ filesystem
+	if "ID_FS_UUID" in dict_udev:
+		match_expr= 'ENV{DM_NAME}!="' + cache_name + \
+		'", ENV{ID_FS_UUID}=="' + dict_udev["ID_FS_UUID"] + '"'
+		return match_expr
+
+
+def run_cmd(cmd):
+	#Utility function that runs a command
+	process = subprocess.Popen(cmd, stdout=subprocess.PIPE,\
+				stderr=subprocess.STDOUT,shell=True)
+	output = process.stdout.read()
+	ret = process.wait()
+	status = Status(output,ret)
+	return status
+
+
+
+def get_caches_list():
+
+	#Utility function that obtains cache list
+	cache_list = [f for f in os.listdir('/proc/enhanceio/')]
+	for name in cache_list:
+		if name == "version":
+			cache_list.remove(name)
+	return cache_list
+
+def sanity(hdd, ssd):
+	# Performs a very basic regression of operations
+
+	modes = {3:"Write Through", 1:"Write Back", 2:"Read Only",0:"N/A"}
+	policies = {3:"rand", 1:"fifo", 2:"lru", 0:"N/A"}
+	blksizes = {"4096":4096, "2048":2048, "8192":8192,"":0}
+	for mode in ["wb","wt","ro"]:
+		for policy in ["rand","fifo","lru"]:
+			for blksize in ["4096","2048","8192"]:
+				cache = Cache_rec(name = "test_cache", src_name = hdd,\
+						ssd_name = ssd, policy = policy, mode = mode,\
+						blksize = blksize)
+				cache.create()
+				run_cmd(FIOCMD + hdd)
+				cache.delete()
+
+
+# Class that represents cache. Also used to pass ioctl to driver
+class Cache_rec(Structure):
+	_fields_ = [
+	("name", c_char * 32),
+	("src_name", c_char * 128),
+	("ssd_name", c_char * 128),
+	("ssd_uuid", c_char * 128),
+        ("src_size", c_ulonglong),
+	("ssd_size", c_ulonglong),
+        ("src_sector_size", c_uint),
+        ("ssd_sector_size", c_uint),
+	("flags", c_uint),
+        ("policy", c_byte),
+        ("mode", c_byte),
+        ("persistence", c_byte),
+        ("cold_boot", c_byte),
+        ("blksize", c_ulonglong),
+        ("assoc", c_ulonglong)
+	]
+	def __init__(self, name, src_name="", ssd_name="", src_size=0,\
+		     ssd_size=0, src_sector_size=0, ssd_sector_size=0,\
+		     flags=0, policy="", mode="", persistence=0, cold_boot="",\
+		     blksize="", assoc=""):
+
+		modes = {"wt":3,"wb":1,"ro":2,"":0}
+		policies = {"rand":3,"fifo":1, "lru":2,"":0}
+		blksizes = {"4096":4096, "2048":2048, "8192":8192,"":0}
+		associativity = {2048:128, 4096:256, 8192:512,0:0}
+
+		self.name = name
+		self.src_name =src_name
+		self.ssd_name = ssd_name
+		self.src_size = src_size
+		self.src_sector_size = src_sector_size
+		self.ssd_size = ssd_size
+		self.ssd_sector_size = ssd_sector_size
+		self.flags = flags
+		self.policy = policies[policy]
+		self.mode = modes[mode]
+		self.persistence = persistence
+		self.blksize = blksizes[blksize]
+		self.assoc = associativity[self.blksize]
+
+
+	def print_info(self):
+
+		# Display Cache info
+		modes = {3:"Write Through", 1:"Write Back", 2:"Read Only",0:"N/A"}
+		policies = {3:"rand", 1:"fifo", 2:"lru", 0:"N/A"}
+
+		print "Cache Name       : " + self.name
+		print "Source Device    : " + self.src_name
+		print "SSD Device       : " + self.ssd_name
+		print "Policy           : " + policies[self.policy]
+		print "Mode             : " + modes[self.mode]
+		print "Block Size       : " + str(self.blksize)
+		print "Associativity    : " + str(self.assoc)
+
+		if os.path.exists("/proc/enhanceio/" + self.name):
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep state"
+			status = run_cmd(cmd)
+			print "State            : " + status.output.split()[1]
+
+		pass
+
+
+	def do_eio_ioctl(self,IOC_TYPE):
+		#send ioctl to driver
+		fd = open(EIODEV, "r")
+		fmt = ''
+		try:
+			if ioctl(fd, IOC_TYPE, addressof(self)) == SUCCESS:
+				return SUCCESS
+		except Exception as e:
+			print e
+		return FAILURE
+
+
+	def clean(self):
+		#do sysctl corresponding to clean
+		cmd = "/sbin/sysctl dev.enhanceio." + self.name + ".do_clean=1"
+		print cmd
+		run_cmd(cmd)
+		pass
+
+
+	def get_cache_info(self):
+		#function to extract information from /proc/enhanceio
+		status = Status()
+
+		if os.path.exists("/proc/enhanceio/" + self.name):
+
+			associativity = {2048:128, 4096:256, 8192:512,0:0}
+
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep src_name"
+			status = run_cmd(cmd)
+			self.src_name =  status.output.split()[1]
+
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep ssd_name"
+			status = run_cmd(cmd)
+			self.ssd_name = status.output.split()[1]
+
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep mode"
+			status = run_cmd(cmd)
+			self.mode = int(status.output.split()[1])
+
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep eviction"
+			status = run_cmd(cmd)
+			self.policy = int(status.output.split()[1])
+
+			cmd = "cat /proc/enhanceio/" + self.name + "/config" + " | grep block_size"
+			status = run_cmd(cmd)
+			self.blksize = int(status.output.split()[1])
+
+			self.assoc = associativity[self.blksize]
+
+			return SUCCESS
+
+		return FAILURE
+
+
+	def create(self):
+
+		src_sz = Dev_info()
+		src_sz.get_device_size_info(self.src_name)
+		self.src_size = src_sz.dev_size
+		self.src_sector_size = src_sz.dev_sect_size
+
+		ssd_sz = Dev_info()
+		ssd_sz.get_device_size_info(self.ssd_name)
+		self.ssd_size = ssd_sz.dev_size
+		self.ssd_sector_size = ssd_sz.dev_sect_size
+
+		self.print_info()
+		if self.do_eio_ioctl(EIO_IOC_CREATE) == SUCCESS:
+			self.create_rules()
+			print 'Cache created successfully'
+			return SUCCESS
+		else:
+			print 'Cache creation failed ' + \
+			'(dmesg can provide you more info)'
+
+		return FAILURE
+
+
+	def edit(self):
+		mode = self.mode
+		policy = self.policy
+		if self.get_cache_info() == SUCCESS:
+			if mode != 0:
+				self.mode = mode
+			if policy != 0:
+				self.policy = policy
+
+			if self.do_eio_ioctl(EIO_IOC_EDIT) == SUCCESS:
+				self.create_rules()
+				print 'Cache edited Successfully'
+				return SUCCESS
+			else:
+				print 'Edit cache failed ' + \
+				'(dmesg can provide you more info)'
+		else:
+			print 'Requested cache not found'
+
+		return FAILURE
+
+
+	def create_rules(self):
+
+		source_match_expr = make_udev_match_expr(self.src_name, self.name)
+		print source_match_expr
+		cache_match_expr = make_udev_match_expr(self.ssd_name, self.name)
+		print cache_match_expr
+		modes = {3:"wt", 1:"wb", 2:"ro",0:"N/A"}
+		policies = {3:"rand", 1:"fifo", 2:"lru", 0:"N/A"}
+
+		try:
+			udev_rule = udev_template.replace("<cache_name>",\
+				    self.name).replace("<source_match_expr>",\
+				    source_match_expr).replace("<cache_match_expr>",\
+				    cache_match_expr).replace("<mode>",\
+				    modes[self.mode]).replace("<block_size>",\
+				    str(self.blksize)).replace("<policy>",\
+				    policies[self.policy])
+
+			# write rule file
+			rule_file_path = "/etc/udev/rules.d/94-enhanceio-" + \
+					self.name + ".rules"
+			rule_file = open(rule_file_path, "w")
+			rule_file.write(udev_rule)
+			return SUCCESS
+
+		except Exception as e:
+			print "Creation of udev rules file failed\n"
+			print e
+			return FAILURE
+
+	def delete(self):
+
+		if self.get_cache_info() == FAILURE:
+			print "No cache exists with the name " + self.name
+			return FAILURE
+
+		run_cmd("/bin/touch /dev/enhanceio/" + self.name + "/.eio_delete")
+
+		if self.do_eio_ioctl(EIO_IOC_DELETE) == SUCCESS:
+			if self.delete_rules() == SUCCESS:
+				return SUCCESS
+		else:
+			print 'Cache deletion failed (dmesg can provide you more info)'
+
+		run_cmd("/bin/rm -f /dev/enhanceio/" + self.name + "/.eio_delete")
+
+		return FAILURE
+
+
+	def delete_rules(self):
+
+		rule_file_path = "/etc/udev/rules.d/94-enhanceio-" + self.name + ".rules"
+		print "Removing file" + rule_file_path
+		try:
+			os.remove(rule_file_path)
+			print "Done removing rule file"
+			return SUCCESS
+		except Exception as e:
+			print "Unable to delete rule file" + \
+			"(please remove it manually)"
+			print e
+		return FAILURE
+
+class Status:
+	output = ""
+	ret = 0
+
+	def __init__(self, outstr="", outret=0):
+		self.output = outstr
+		self.ret = outret
+		pass
+
+#Block Device class
+class Dev_info:
+
+	dev_size = 0
+	dev_sect_size = 0
+
+	def get_device_size_info(self,name):
+		fd = open(name,"r")
+
+		status = run_cmd("blockdev --getsize64 "+ name);
+		self.dev_size = int(status.output.split()[0])
+
+		status = run_cmd("blockdev --getss "+ name);
+                self.dev_sect_size = int(status.output.split()[0])
+
+		pass
+
+def create_parser():
+
+
+	mainparser = ArgumentParser()
+	parser = mainparser.add_subparsers()
+
+	#delete
+	parser_delete = parser.add_parser('delete', help='used to delete cache')
+	parser_delete.add_argument("-c", action="store", dest= "cache",required=True)
+
+	#edit
+	parser_edit = parser.add_parser('edit', help="used to edit \
+					cache policy or mode or both")
+	parser_edit.add_argument("-c", action="store",  dest="cache",required=True)
+	parser_edit.add_argument("-m", action="store", dest="mode", \
+			choices=["wb","wt","ro"], help="cache mode",default="")
+	parser_edit.add_argument("-p", action="store", dest="policy", \
+				choices=["rand","fifo","lru"], help="cache \
+				replacement policy",default="")
+
+	#info
+	parser_info = parser.add_parser('info', help='displays information \
+					about currently create caches')
+
+	#clean
+	parser_clean = parser.add_parser('clean', help='clean the dirty blocks \
+				in the cache (Applicable only to writeback caches)')
+	parser_clean.add_argument("-c", action="store", dest="cache",required=True)
+
+	#create
+	parser_create = parser.add_parser('create', help="create")
+	parser_create.add_argument("-d", action="store", dest="hdd",\
+				required=True, help="name of the source device")
+	parser_create.add_argument("-s", action="store", dest="ssd",\
+				required=True, help="name of the ssd device")
+	parser_create.add_argument("-p", action="store", dest="policy",\
+				   choices=["rand","fifo","lru"],\
+				   help="cache replacement policy",default="lru")
+	parser_create.add_argument("-m", action="store", dest="mode",\
+				   choices=["wb","wt","ro"],\
+				   help="cache mode",default="wt")
+	parser_create.add_argument("-b", action="store", dest="blksize",\
+				   choices=["2048","4096","8192"],\
+				   default="4096" ,help="block size for cache")
+	parser_create.add_argument("-c", action="store", dest="cache", required=True)
+
+	#enable
+	parser_enable = parser.add_parser('enable', help='used to enable cache')
+	parser_enable.add_argument("-d", action="store", dest="hdd",\
+				   required=True, help="name of the source device")
+	parser_enable.add_argument("-s", action="store", dest="ssd",\
+				   required=True, help="name of the ssd device")
+	parser_enable.add_argument("-p", action="store", dest="policy",
+				   choices=["rand","fifo","lru"],\
+				   help="cache replacement policy",default="lru")
+	parser_enable.add_argument("-m", action="store", dest="mode",\
+				   choices=["wb","wt","ro"],\
+				   help="cache mode",default="wt")
+	parser_enable.add_argument("-b", action="store", dest="blksize",\
+				   choices=["2048","4096","8192"],\
+				   default="4096" ,help="block size for cache")
+	parser_enable.add_argument("-c", action="store", dest="cache", required=True)
+
+	#notify
+	parser_notify = parser.add_parser('notify')
+	parser_notify.add_argument("-s", action="store", dest="ssd",\
+				   help="name of the ssd device")
+	parser_notify.add_argument("-a", action="store", dest="action",\
+				    help="add/remove/reboot")
+	parser_notify.add_argument("-d", action="store", dest="hdd",\
+				    help="name of the source device")
+	parser_notify.add_argument("-c", action="store", dest="cache", required=True)
+
+	#sanity
+	parser_sanity = parser.add_parser('sanity')
+	parser_sanity.add_argument("-s", action="store", dest="ssd",\
+			          required=True, help="name of the ssd device")
+	parser_sanity.add_argument("-d", action="store", dest="hdd",\
+				  required=True, help="name of the source device")
+	return mainparser
+
+def main():
+
+	mainparser = create_parser()
+	args = mainparser.parse_args()
+
+	run_cmd("/sbin/modprobe enhanceio")
+	run_cmd("/sbin/modprobe enhanceio_fifo")
+	run_cmd("/sbin/modprobe enhanceio_lru")
+	run_cmd("/sbin/modprobe enhanceio_rand")
+
+	if sys.argv[1] == "create":
+
+		if re.match('^[\w]+$', args.cache) is None:
+			print "Cache name can contain only alphanumeric" + \
+			" characters and underscore ('_')"
+			return FAILURE
+
+		cache = Cache_rec(name = args.cache, src_name = args.hdd,\
+				ssd_name = args.ssd, policy = args.policy,\
+				mode = args.mode, blksize = args.blksize)
+		return cache.create()
+
+	elif sys.argv[1] == "info":
+		cache_list = get_caches_list()
+		if not cache_list:
+			print "No caches Found"
+		else:
+			for cache_name in cache_list:
+				cache = Cache_rec(name = cache_name)
+				cache.get_cache_info()
+				cache.print_info()
+
+			print "\nFor more information look at " + \
+			      "/proc/enhanceio/<cache_name>/config"
+		return SUCCESS
+
+	elif sys.argv[1] == "edit":
+		cache = Cache_rec(name = args.cache, policy = args.policy, mode = args.mode)
+		return cache.edit()
+
+	elif sys.argv[1] == "delete":
+		cache = Cache_rec(name = args.cache)
+		return cache.delete()
+
+	elif sys.argv[1] == "clean":
+		cache = Cache_rec(name = args.cache)
+		return cache.clean()
+
+	elif sys.argv[1] == "enable":
+		# This command will be fired by udev rule on SSD/Source addition
+		cache = Cache_rec(name = args.cache, src_name = args.hdd,\
+				ssd_name = args.ssd, policy = args.policy,\
+				mode = args.mode, blksize = args.blksize, persistence = 1)
+
+		cache.do_eio_ioctl(EIO_IOC_ENABLE)
+
+	elif sys.argv[1] == "notify":
+		# This command will be fired by udev rule on SSD/Source addition
+		if args.action == "reboot":
+			cache = Cache_rec(name = "dummy")
+			cache.do_eio_ioctl(EIO_IOC_ENABLE)
+
+		elif args.action == "add":
+			if args.ssd:
+				cache = Cache_rec(name = args.cache,\
+						ssd_name = args.ssd, persistence = 1)
+				cache.do_eio_ioctl(EIO_IOC_SSD_ADD)
+
+			elif args.hdd:
+				cache = Cache_rec(name = args.cache,\
+						ssd_name = args.hdd, persistence = 1)
+				cache.do_eio_ioctl(EIO_IOC_HDD_ADD)
+
+		elif args.action == "remove":
+			if args.ssd:
+				cache = Cache_rec(name = args.cache, ssd_name = args.ssd,\
+						persistence = 1)
+				cache.do_eio_ioctl(EIO_SSD_REMOVE)
+			elif args.hdd:
+				cache = Cache_rec(name = args.cache, hdd_name = args.hdd,\
+						persistence = 1)
+				cache.do_eio_ioctl(EIO_HDD_REMOVE)
+
+		pass
+
+	elif sys.argv[1] == "sanity":
+		# Performs a basic sanity check
+		sanity(args.hdd, args.ssd)
+		return SUCCESS
+
+if __name__ == '__main__':
+	sys.exit(main())
diff --git a/tools/enhanceio/eio_cli.8 b/tools/enhanceio/eio_cli.8
new file mode 100644
index 0000000..e48cce6
--- /dev/null
+++ b/tools/enhanceio/eio_cli.8
@@ -0,0 +1,152 @@
+.TH EIO_CLI 8 "April 16, 2013" "" "eio_cli"
+
+.SH NAME
+eio_cli \- EnhanceIO command line interface
+
+.SH SYNOPSIS
+.B eio_cli create
+.I -d <src device> -s <SSD device> [-p <policy>] [-m <cache mode>] [-b <block size>] -c <cache name>
+.br
+.B eio_cli delete
+.I -c <cache name>
+.br
+.B eio_cli clean
+.I -c <cache name>
+.br
+.B eio_cli info
+.I
+.br
+.B eio_cli edit
+.I [-p <policy>] [-m <cache mode>] -c <cache name>
+.br
+
+.SH DESCRIPTION
+.B EnhanceIO
+is a block device caching software that uses an SSD as cache for traditional HDDs.
+The eio_cli command line interface is intended to serve the purpose of administering the caches.
+The eio_cli command takes the first argument as a sub-command, rest of the arguments are options
+specific to the sub-command.
+
+.SH SUB-COMMANDS
+.SS "eio_cli create \fIoptions\fR"
+.PP
+Creates a new cache by associating an SSD device with a source device\&.
+.PP
+\-d \fR\fB\f\<source device>\fR\fR
+.RS 4
+Specifies the source device\&.
+.RE
+.PP
+\-s \fR\fB\f\<SSD device>\fR\fR
+.RS 4
+Specifies the SSD device\&.
+.RE
+.PP
+\-c \fR\fB\f\<Cache name >\fR\fR
+.RS 4
+Specifies the Cache name\&.
+.RE
+.PP
+\fR\fB\f\[\-p <policy>]\fR\fR
+.RS 4
+Cache block replacement policy\&. Policies are:
+\fBlru\fR,
+\fBfifo(default)\fR,
+\fBrand(random)\fR\&.
+.RE
+.PP
+\fR\fB\f\[\-m <cache mode>]\fR\fR
+.RS 4
+Specifies the caching mode\&. Supported caching modes are:
+\fBro(Read-Only)\fR,
+\fBwt(default: Write-Through)\fR,
+\fBwb(Write-Back)\fR\&.
+.RE
+.PP
+\fR\fB\f\[\-b <block size>]\fR\fR
+.RS 4
+Specifies the block size of each single cache entry\&. Block size are:
+\fB2048\fR,
+\fB4096(default)\fR,
+\fB8192\fR\&.
+.RE
+.PP
+.SS "eio_cli delete \fIoptions\fR"
+.RE
+.PP
+Deletes a pre-existing cache\&.
+.RE
+.PP
+\-c \fR\fB\f\<Cache name>\fR\fR
+.RS 4
+Specifies the Cache name\&.
+.RE
+.PP
+.SS "eio_cli clean \fIoptions\fR"
+.RE
+.PP
+Cleans a pre-existing cache\&.
+.RE
+.PP
+\-c \fR\fB\f\<Cache name>\fR\fR
+.RS 4
+Specifies the Cache name\&.
+.PP
+.RE
+.SS "eio_cli info"
+.PP
+Displays information of existing cache devices\&.
+.RE
+.RE
+.SS "eio_cli edit \fIoptions\fR"
+.PP
+Modifies the properties of a cache\&.
+.RE
+.PP
+\-c \fR\fB\f\<Cache name>\fR\fR
+.RS 4
+Specifies the Cache name\&.
+.RE
+.PP
+\fR\fB\f\[\-p <policy>]\fR\fR
+.RS 4
+Cache block replacement policy\&. Policies are:
+\fBlru\fR,
+\fBfifo(default)\fR,
+\fBrand(random)\fR\&.
+.RE
+.PP
+\fR\fB\f\[\-m <cache mode>]\fR\fR
+.RS 4
+Specifies the caching mode\&. Supported caching modes are:
+\fBro(Read-Only)\fR,
+\fBwt(Write-Through)\fR,
+\fBwb(Write-Back)\fR\&.
+.RE
+.PP
+
+.SH EXAMPLES
+
+# Create a cache
+    $ eio_cli create \-d /dev/sdg \-s /dev/sdf \-p lru \-m wt \-c SDG_CACHE
+    $ eio_cli create \-d /dev/sdm \-s /dev/sdk \-c SDM_CACHE
+    $ eio_cli create \-d /dev/sdc1 \-s /dev/sdd1 \-c SDC1_CACHE
+
+# Display properties of the cache devices
+    $ eio_cli info
+
+# Edit the properties of the cache SDG_CACHE
+    $ eio_cli edit \-p fifo \-c SDG_CACHE
+    $ eio_cli edit \-p rand \-m ro \-c SDG_CACHE
+
+# Delete the cache SDG_CACHE
+    $ eio_cli clean \-c SDG_CACHE
+
+# Clean the cache SDG_CACHE
+    $ eio_cli clean \-c SDG_CACHE
+
+
+
+.SH AUTHOR
+	\fRsTec(R), Inc. \fI<http://www.stec-inc.com/>
+Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
-- 
1.7.4.1



