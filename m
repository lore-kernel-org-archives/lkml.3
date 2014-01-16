Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaAPEeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:34:18 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45807 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbaAPEeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:34:13 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 14/15] w1: format for DocBook and fixes
Date: Wed, 15 Jan 2014 22:29:25 -0600
Message-Id: <1389846566-28862-15-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:34:05 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the code documentation format style to DocBook format, enable
DocBook documentation generation, and fix some comments.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 Documentation/DocBook/Makefile |    2 +-
 Documentation/DocBook/w1.tmpl  |  101 +++++++++++++++++++++++++++++
 Documentation/w1/w1.netlink    |    8 +--
 drivers/w1/w1.c                |   30 +++++++--
 drivers/w1/w1.h                |  136 +++++++++++++++++++++++++++-------------
 drivers/w1/w1_family.c         |    8 +++
 drivers/w1/w1_family.h         |   13 ++++
 drivers/w1/w1_int.c            |    8 +++
 drivers/w1/w1_io.c             |  102 +++++++++++++++++-------------
 drivers/w1/w1_netlink.h        |    6 +-
 10 files changed, 315 insertions(+), 99 deletions(-)
 create mode 100644 Documentation/DocBook/w1.tmpl

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bc3d9f8..662e4ef 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -14,7 +14,7 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml drm.xml media_api.xml
+	    tracepoint.xml drm.xml media_api.xml w1.xml
 
 include $(srctree)/Documentation/DocBook/media/Makefile
 
diff --git a/Documentation/DocBook/w1.tmpl b/Documentation/DocBook/w1.tmpl
new file mode 100644
index 0000000..b0228d4
--- /dev/null
+++ b/Documentation/DocBook/w1.tmpl
@@ -0,0 +1,101 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="w1id">
+  <bookinfo>
+    <title>W1: Dallas' 1-wire bus</title>
+
+    <authorgroup>
+      <author>
+        <firstname>David</firstname>
+        <surname>Fries</surname>
+        <affiliation>
+          <address>
+            <email>David@Fries.net</email>
+          </address>
+        </affiliation>
+      </author>
+
+    </authorgroup>
+
+    <copyright>
+      <year>2013</year>
+      <!--
+      <holder></holder>
+      -->
+    </copyright>
+
+    <legalnotice>
+      <para>
+        This documentation is free software; you can redistribute
+        it and/or modify it under the terms of the GNU General Public
+        License version 2.
+      </para>
+
+      <para>
+        This program is distributed in the hope that it will be
+        useful, but WITHOUT ANY WARRANTY; without even the implied
+        warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+        For more details see the file COPYING in the source
+        distribution of Linux.
+      </para>
+    </legalnotice>
+  </bookinfo>
+
+  <toc></toc>
+
+  <chapter id="w1_internal">
+    <title>W1 API internal to the kernel</title>
+
+    <sect1 id="w1_internal_api">
+      <title>W1 API internal to the kernel</title>
+      <sect2 id="w1.h">
+        <title>drivers/w1/w1.h</title>
+        <para>W1 core functions.</para>
+!Idrivers/w1/w1.h
+      </sect2>
+
+      <sect2 id="w1.c">
+        <title>drivers/w1/w1.c</title>
+        <para>W1 core functions.</para>
+!Idrivers/w1/w1.c
+      </sect2>
+
+      <sect2 id="w1_family.h">
+        <title>drivers/w1/w1_family.h</title>
+        <para>Allows registering device family operations.</para>
+!Idrivers/w1/w1_family.h
+      </sect2>
+
+      <sect2 id="w1_family.c">
+        <title>drivers/w1/w1_family.c</title>
+        <para>Allows registering device family operations.</para>
+!Edrivers/w1/w1_family.c
+      </sect2>
+
+      <sect2 id="w1_int.c">
+        <title>drivers/w1/w1_int.c</title>
+        <para>W1 internal initialization for master devices.</para>
+!Edrivers/w1/w1_int.c
+      </sect2>
+
+      <sect2 id="w1_netlink.h">
+        <title>drivers/w1/w1_netlink.h</title>
+        <para>W1 external netlink API structures and commands.</para>
+!Idrivers/w1/w1_netlink.h
+      </sect2>
+
+      <sect2 id="w1_io.c">
+        <title>drivers/w1/w1_io.c</title>
+        <para>W1 input/output.</para>
+!Edrivers/w1/w1_io.c
+!Idrivers/w1/w1_io.c
+      </sect2>
+
+    </sect1>
+
+
+  </chapter>
+
+</book>
diff --git a/Documentation/w1/w1.netlink b/Documentation/w1/w1.netlink
index f59a319..927a52c 100644
--- a/Documentation/w1/w1.netlink
+++ b/Documentation/w1/w1.netlink
@@ -5,8 +5,8 @@ Message types.
 =============
 
 There are three types of messages between w1 core and userspace:
-1. Events. They are generated each time new master or slave device
-	found either due to automatic or requested search.
+1. Events. They are generated each time a new master or slave device
+	is found either due to automatic or requested search.
 2. Userspace commands.
 3. Replies to userspace commands.
 
@@ -131,7 +131,7 @@ of the w1_netlink_cmd structure and cn_msg.len will be equal to the sum
 of the sizeof(struct w1_netlink_msg) and sizeof(struct w1_netlink_cmd).
 If reply is generated for master or root command (which do not have
 w1_netlink_cmd attached), reply will contain only cn_msg and w1_netlink_msg
-structires.
+structures.
 
 w1_netlink_msg.status field will carry positive error value
 (EINVAL for example) or zero in case of success.
@@ -160,7 +160,7 @@ procedure is started to select given device.
 Then all requested in w1_netlink_msg operations are performed one by one.
 If command requires reply (like read command) it is sent on command completion.
 
-When all commands (w1_netlink_cmd) are processed muster device is unlocked
+When all commands (w1_netlink_cmd) are processed master device is unlocked
 and next w1_netlink_msg header processing started.
 
 
diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 53846c7..9eb816b 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -50,8 +50,21 @@ int w1_max_slave_count = 64;
 int w1_max_slave_ttl = 10;
 
 module_param_named(timeout, w1_timeout, int, 0);
+MODULE_PARM_DESC(timeout, "time in seconds between automatic slave searches");
+/* A search stops when w1_max_slave_count devices have been found in that
+ * search.  The next search will start over and detect the same set of devices
+ * on a static 1-wire bus.  Memory is not allocated based on this number, just
+ * on the number of devices known to the kernel.  Having a high number does not
+ * consume additional resources.  As a special case, if there is only one
+ * device on the network and w1_max_slave_count is set to 1, the device id can
+ * be read directly skipping the normal slower search process.
+ */
 module_param_named(max_slave_count, w1_max_slave_count, int, 0);
+MODULE_PARM_DESC(max_slave_count,
+	"maximum number of slaves detected in a search");
 module_param_named(slave_ttl, w1_max_slave_ttl, int, 0);
+MODULE_PARM_DESC(slave_ttl,
+	"Number of searches not seeing a slave before it will be removed");
 
 DEFINE_MUTEX(w1_mlock);
 LIST_HEAD(w1_masters);
@@ -920,7 +933,12 @@ void w1_slave_found(struct w1_master *dev, u64 rn)
 }
 
 /**
- * Performs a ROM Search & registers any devices found.
+ * w1_search() - Performs a ROM Search & registers any devices found.
+ * @dev: The master device to search
+ * @search_type: W1_SEARCH to search all devices, or W1_ALARM_SEARCH
+ * to return only devices in the alarmed state
+ * @cb: Function to call when a device is found
+ *
  * The 1-wire search is a simple binary tree search.
  * For each bit of the address, we read two bits and write one bit.
  * The bit written will put to sleep all devies that don't match that bit.
@@ -930,8 +948,6 @@ void w1_slave_found(struct w1_master *dev, u64 rn)
  *
  * See "Application note 187 1-wire search algorithm" at www.maxim-ic.com
  *
- * @dev        The master device to search
- * @cb         Function to call when a device is found
  */
 void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb)
 {
@@ -990,7 +1006,7 @@ void w1_search(struct w1_master *dev, u8 search_type, w1_slave_found_callback cb
 			else
 				search_bit = ((last_rn >> i) & 0x1);
 
-			/** Read two bits and write one bit */
+			/* Read two bits and write one bit */
 			triplet_ret = w1_triplet(dev, search_bit);
 
 			/* quit if no device responded */
@@ -1074,6 +1090,12 @@ static void w1_search_process(struct w1_master *dev, u8 search_type)
 	w1_search_process_cb(dev, search_type, w1_slave_found);
 }
 
+/**
+ * w1_process_callbacks() - execute each dev->async_list callback entry
+ * @dev: w1_master device
+ *
+ * Return: 1 if there were commands to executed 0 otherwise
+ */
 int w1_process_callbacks(struct w1_master *dev)
 {
 	int ret = 0;
diff --git a/drivers/w1/w1.h b/drivers/w1/w1.h
index 0eb5050..734dab7 100644
--- a/drivers/w1/w1.h
+++ b/drivers/w1/w1.h
@@ -22,6 +22,13 @@
 #ifndef __W1_H
 #define __W1_H
 
+/**
+ * struct w1_reg_num - broken out slave device id
+ *
+ * @family: identifies the type of device
+ * @id: along with family is the unique device id
+ * @crc: checksum of the other bytes
+ */
 struct w1_reg_num
 {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
@@ -60,6 +67,22 @@ struct w1_reg_num
 #define W1_SLAVE_ACTIVE		0
 #define W1_SLAVE_DETACH		1
 
+/**
+ * struct w1_slave - holds a single slave device on the bus
+ *
+ * @owner: Points to the one wire "wire" kernel module.
+ * @name: Device id is ascii.
+ * @w1_slave_entry: data for the linked list
+ * @reg_num: the slave id in binary
+ * @refcnt: reference count, delete when 0
+ * @flags: bit flags for W1_SLAVE_ACTIVE W1_SLAVE_DETACH
+ * @ttl: decrement per search this slave isn't found, deatch at 0
+ * @master: bus which this slave is on
+ * @family: module for device family type
+ * @family_data: pointer for use by the family module
+ * @dev: kernel device identifier
+ *
+ */
 struct w1_slave
 {
 	struct module		*owner;
@@ -80,77 +103,74 @@ typedef void (*w1_slave_found_callback)(struct w1_master *, u64);
 
 
 /**
+ * struct w1_bus_master - operations available on a bus master
+ *
+ * @data: the first parameter in all the functions below
+ *
+ * @read_bit: Sample the line level @return the level read (0 or 1)
+ *
+ * @write_bit: Sets the line level
+ *
+ * @touch_bit: the lowest-level function for devices that really support the
+ * 1-wire protocol.
+ * touch_bit(0) = write-0 cycle
+ * touch_bit(1) = write-1 / read cycle
+ * @return the bit read (0 or 1)
+ *
+ * @read_byte: Reads a bytes. Same as 8 touch_bit(1) calls.
+ * @return the byte read
+ *
+ * @write_byte: Writes a byte. Same as 8 touch_bit(x) calls.
+ *
+ * @read_block: Same as a series of read_byte() calls
+ * @return the number of bytes read
+ *
+ * @write_block: Same as a series of write_byte() calls
+ *
+ * @triplet: Combines two reads and a smart write for ROM searches
+ * @return bit0=Id bit1=comp_id bit2=dir_taken
+ *
+ * @reset_bus: long write-0 with a read for the presence pulse detection
+ * @return -1=Error, 0=Device present, 1=No device present
+ *
+ * @set_pullup: Put out a strong pull-up pulse of the specified duration.
+ * @return -1=Error, 0=completed
+ *
+ * @search: Really nice hardware can handles the different types of ROM search
+ * w1_master* is passed to the slave found callback.
+ * u8 is search_type, W1_SEARCH or W1_ALARM_SEARCH
+ *
  * Note: read_bit and write_bit are very low level functions and should only
  * be used with hardware that doesn't really support 1-wire operations,
  * like a parallel/serial port.
  * Either define read_bit and write_bit OR define, at minimum, touch_bit and
  * reset_bus.
+ *
  */
 struct w1_bus_master
 {
-	/** the first parameter in all the functions below */
 	void		*data;
 
-	/**
-	 * Sample the line level
-	 * @return the level read (0 or 1)
-	 */
 	u8		(*read_bit)(void *);
 
-	/** Sets the line level */
 	void		(*write_bit)(void *, u8);
 
-	/**
-	 * touch_bit is the lowest-level function for devices that really
-	 * support the 1-wire protocol.
-	 * touch_bit(0) = write-0 cycle
-	 * touch_bit(1) = write-1 / read cycle
-	 * @return the bit read (0 or 1)
-	 */
 	u8		(*touch_bit)(void *, u8);
 
-	/**
-	 * Reads a bytes. Same as 8 touch_bit(1) calls.
-	 * @return the byte read
-	 */
 	u8		(*read_byte)(void *);
 
-	/**
-	 * Writes a byte. Same as 8 touch_bit(x) calls.
-	 */
 	void		(*write_byte)(void *, u8);
 
-	/**
-	 * Same as a series of read_byte() calls
-	 * @return the number of bytes read
-	 */
 	u8		(*read_block)(void *, u8 *, int);
 
-	/** Same as a series of write_byte() calls */
 	void		(*write_block)(void *, const u8 *, int);
 
-	/**
-	 * Combines two reads and a smart write for ROM searches
-	 * @return bit0=Id bit1=comp_id bit2=dir_taken
-	 */
 	u8		(*triplet)(void *, u8);
 
-	/**
-	 * long write-0 with a read for the presence pulse detection
-	 * @return -1=Error, 0=Device present, 1=No device present
-	 */
 	u8		(*reset_bus)(void *);
 
-	/**
-	 * Put out a strong pull-up pulse of the specified duration.
-	 * @return -1=Error, 0=completed
-	 */
 	u8		(*set_pullup)(void *, int);
 
-	/** Really nice hardware can handles the different types of ROM search
-	 *  w1_master* is passed to the slave found callback.
-	 *  u8 is search_type, W1_SEARCH or W1_ALARM_SEARCH
-	 */
 	void		(*search)(void *, struct w1_master *,
 		u8, w1_slave_found_callback);
 };
@@ -165,6 +185,37 @@ enum w1_master_flags {
 	W1_WARN_MAX_COUNT = 1,
 };
 
+/**
+ * struct w1_master - one per bus master
+ * @w1_master_entry:	master linked list
+ * @owner:		module owner
+ * @name:		dynamically allocate bus name
+ * @list_mutex:		protect slist and async_list
+ * @slist:		linked list of slaves
+ * @async_list:		linked list of netlink commands to execute
+ * @max_slave_count:	maximum number of slaves to search for at a time
+ * @slave_count:	current number of slaves known
+ * @attempts:		number of searches ran
+ * @slave_ttl:		number of searches before a slave is timed out
+ * @initialized:	prevent init/removal race conditions
+ * @id:			w1 bus number
+ * @search_count:	number of automatic searches to run, -1 unlimited
+ * @search_id:		allows continuing a search
+ * @refcnt:		reference count
+ * @priv:		private data storage
+ * @priv_size:		size allocated
+ * @enable_pullup:	allows a strong pullup
+ * @pullup_duration:	time for the next strong pullup
+ * @flags:		one of w1_master_flags
+ * @thread:		thread for bus search and netlink commands
+ * @mutex:		protect most of w1_master
+ * @bus_mutex:		pretect concurrent bus access
+ * @driver:		sysfs driver
+ * @dev:		sysfs device
+ * @bus_master:		io operations available
+ * @seq:		sequence number used for netlink broadcasts
+ * @portid:		destination for the current netlink command
+ */
 struct w1_master
 {
 	struct list_head	w1_master_entry;
@@ -173,7 +224,7 @@ struct w1_master
 	/* list_mutex protects just slist and async_list so slaves can be
 	 * searched for and async commands added while the master has
 	 * w1_master.mutex locked and is operating on the bus.
-	 * lock order w1_mlock, w1_master.mutex, w1_master_list_mutex
+	 * lock order w1_mlock, w1_master.mutex, w1_master.list_mutex
 	 */
 	struct mutex		list_mutex;
 	struct list_head	slist;
@@ -290,7 +341,6 @@ extern int w1_max_slave_ttl;
 extern struct list_head w1_masters;
 extern struct mutex w1_mlock;
 
-/* returns 1 if there were commands to executed 0 otherwise */
 extern int w1_process_callbacks(struct w1_master *dev);
 extern int w1_process(void *);
 
diff --git a/drivers/w1/w1_family.c b/drivers/w1/w1_family.c
index e9309778..3bff6b3 100644
--- a/drivers/w1/w1_family.c
+++ b/drivers/w1/w1_family.c
@@ -31,6 +31,10 @@
 DEFINE_SPINLOCK(w1_flock);
 static LIST_HEAD(w1_families);
 
+/**
+ * w1_register_family() - register a device family driver
+ * @newf:	family to register
+ */
 int w1_register_family(struct w1_family *newf)
 {
 	struct list_head *ent, *n;
@@ -59,6 +63,10 @@ int w1_register_family(struct w1_family *newf)
 	return ret;
 }
 
+/**
+ * w1_unregister_family() - unregister a device family driver
+ * @fent:	family to unregister
+ */
 void w1_unregister_family(struct w1_family *fent)
 {
 	struct list_head *ent, *n;
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 4ad0e81..26ca134 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -48,6 +48,12 @@
 
 struct w1_slave;
 
+/**
+ * struct w1_family_ops - operations for a family type
+ * @add_slave: add_slave
+ * @remove_slave: remove_slave
+ * @groups: sysfs group
+ */
 struct w1_family_ops
 {
 	int  (* add_slave)(struct w1_slave *);
@@ -55,6 +61,13 @@ struct w1_family_ops
 	const struct attribute_group **groups;
 };
 
+/**
+ * struct w1_family - reference counted family structure.
+ * @family_entry:	family linked list
+ * @fid:		8 bit family identifier
+ * @fops:		operations for this family
+ * @refcnt:		reference counter
+ */
 struct w1_family
 {
 	struct list_head	family_entry;
diff --git a/drivers/w1/w1_int.c b/drivers/w1/w1_int.c
index ae3b595..6badf2b 100644
--- a/drivers/w1/w1_int.c
+++ b/drivers/w1/w1_int.c
@@ -105,6 +105,10 @@ static void w1_free_dev(struct w1_master *dev)
 	device_unregister(&dev->dev);
 }
 
+/**
+ * w1_add_master_device() - registers a new master device
+ * @master:	master bus device to register
+ */
 int w1_add_master_device(struct w1_bus_master *master)
 {
 	struct w1_master *dev, *entry;
@@ -239,6 +243,10 @@ void __w1_remove_master_device(struct w1_master *dev)
 	w1_free_dev(dev);
 }
 
+/**
+ * w1_remove_master_device() - unregister a master device
+ * @bm:	master bus device to remove
+ */
 void w1_remove_master_device(struct w1_bus_master *bm)
 {
 	struct w1_master *dev, *found = NULL;
diff --git a/drivers/w1/w1_io.c b/drivers/w1/w1_io.c
index e10acc2..2820924 100644
--- a/drivers/w1/w1_io.c
+++ b/drivers/w1/w1_io.c
@@ -62,7 +62,9 @@ static void w1_write_bit(struct w1_master *dev, int bit);
 static u8 w1_read_bit(struct w1_master *dev);
 
 /**
- * Generates a write-0 or write-1 cycle and samples the level.
+ * w1_touch_bit() - Generates a write-0 or write-1 cycle and samples the level.
+ * @dev:	the master device
+ * @bit:	0 - write a 0, 1 - write a 0 read the level
  */
 static u8 w1_touch_bit(struct w1_master *dev, int bit)
 {
@@ -77,7 +79,10 @@ static u8 w1_touch_bit(struct w1_master *dev, int bit)
 }
 
 /**
- * Generates a write-0 or write-1 cycle.
+ * w1_write_bit() - Generates a write-0 or write-1 cycle.
+ * @dev:	the master device
+ * @bit:	bit to write
+ *
  * Only call if dev->bus_master->touch_bit is NULL
  */
 static void w1_write_bit(struct w1_master *dev, int bit)
@@ -102,11 +107,12 @@ static void w1_write_bit(struct w1_master *dev, int bit)
 }
 
 /**
+ * w1_pre_write() - pre-write operations
+ * @dev:	the master device
+ *
  * Pre-write operation, currently only supporting strong pullups.
  * Program the hardware for a strong pullup, if one has been requested and
  * the hardware supports it.
- *
- * @param dev     the master device
  */
 static void w1_pre_write(struct w1_master *dev)
 {
@@ -118,11 +124,12 @@ static void w1_pre_write(struct w1_master *dev)
 }
 
 /**
+ * w1_post_write() - post-write options
+ * @dev:	the master device
+ *
  * Post-write operation, currently only supporting strong pullups.
  * If a strong pullup was requested, clear it if the hardware supports
  * them, or execute the delay otherwise, in either case clear the request.
- *
- * @param dev     the master device
  */
 static void w1_post_write(struct w1_master *dev)
 {
@@ -136,10 +143,9 @@ static void w1_post_write(struct w1_master *dev)
 }
 
 /**
- * Writes 8 bits.
- *
- * @param dev     the master device
- * @param byte    the byte to write
+ * w1_write_8() - Writes 8 bits.
+ * @dev:	the master device
+ * @byte:	the byte to write
  */
 void w1_write_8(struct w1_master *dev, u8 byte)
 {
@@ -161,7 +167,9 @@ EXPORT_SYMBOL_GPL(w1_write_8);
 
 
 /**
- * Generates a write-1 cycle and samples the level.
+ * w1_read_bit() - Generates a write-1 cycle and samples the level.
+ * @dev:	the master device
+ *
  * Only call if dev->bus_master->touch_bit is NULL
  */
 static u8 w1_read_bit(struct w1_master *dev)
@@ -185,16 +193,17 @@ static u8 w1_read_bit(struct w1_master *dev)
 }
 
 /**
- * Does a triplet - used for searching ROM addresses.
+ * w1_triplet() - * Does a triplet - used for searching ROM addresses.
+ * @dev:	the master device
+ * @bdir:	the bit to write if both id_bit and comp_bit are 0
+ *
  * Return bits:
  *  bit 0 = id_bit
  *  bit 1 = comp_bit
  *  bit 2 = dir_taken
  * If both bits 0 & 1 are set, the search should be restarted.
  *
- * @param dev     the master device
- * @param bdir    the bit to write if both id_bit and comp_bit are 0
- * @return        bit fields - see above
+ * Return:        bit fields - see above
  */
 u8 w1_triplet(struct w1_master *dev, int bdir)
 {
@@ -226,10 +235,10 @@ u8 w1_triplet(struct w1_master *dev, int bdir)
 }
 
 /**
- * Reads 8 bits.
+ * w1_read_8() - Reads 8 bits.
+ * @dev:	the master device
  *
- * @param dev     the master device
- * @return        the byte read
+ * Return:        the byte read
  */
 u8 w1_read_8(struct w1_master *dev)
 {
@@ -247,11 +256,10 @@ u8 w1_read_8(struct w1_master *dev)
 EXPORT_SYMBOL_GPL(w1_read_8);
 
 /**
- * Writes a series of bytes.
- *
- * @param dev     the master device
- * @param buf     pointer to the data to write
- * @param len     the number of bytes to write
+ * w1_write_block() - Writes a series of bytes.
+ * @dev:	the master device
+ * @buf:	pointer to the data to write
+ * @len:	the number of bytes to write
  */
 void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 {
@@ -269,11 +277,10 @@ void w1_write_block(struct w1_master *dev, const u8 *buf, int len)
 EXPORT_SYMBOL_GPL(w1_write_block);
 
 /**
- * Touches a series of bytes.
- *
- * @param dev     the master device
- * @param buf     pointer to the data to write
- * @param len     the number of bytes to write
+ * w1_touch_block() - Touches a series of bytes.
+ * @dev:	the master device
+ * @buf:	pointer to the data to write
+ * @len:	the number of bytes to write
  */
 void w1_touch_block(struct w1_master *dev, u8 *buf, int len)
 {
@@ -294,12 +301,11 @@ void w1_touch_block(struct w1_master *dev, u8 *buf, int len)
 EXPORT_SYMBOL_GPL(w1_touch_block);
 
 /**
- * Reads a series of bytes.
- *
- * @param dev     the master device
- * @param buf     pointer to the buffer to fill
- * @param len     the number of bytes to read
- * @return        the number of bytes read
+ * w1_read_block() - Reads a series of bytes.
+ * @dev:	the master device
+ * @buf:	pointer to the buffer to fill
+ * @len:	the number of bytes to read
+ * Return:	the number of bytes read
  */
 u8 w1_read_block(struct w1_master *dev, u8 *buf, int len)
 {
@@ -319,10 +325,9 @@ u8 w1_read_block(struct w1_master *dev, u8 *buf, int len)
 EXPORT_SYMBOL_GPL(w1_read_block);
 
 /**
- * Issues a reset bus sequence.
- *
- * @param  dev The bus master pointer
- * @return     0=Device present, 1=No device present or error
+ * w1_reset_bus() - Issues a reset bus sequence.
+ * @dev:	the master device
+ * Return:	0=Device present, 1=No device present or error
  */
 int w1_reset_bus(struct w1_master *dev)
 {
@@ -383,12 +388,15 @@ void w1_search_devices(struct w1_master *dev, u8 search_type, w1_slave_found_cal
 }
 
 /**
+ * w1_reset_select_slave() - reset and select a slave
+ * @sl:		the slave to select
+ *
  * Resets the bus and then selects the slave by sending either a skip rom
- * or a rom match.
+ * or a rom match.  A skip rom is issued if there is only one device
+ * registered on the bus.
  * The w1 master lock must be held.
  *
- * @param sl	the slave to select
- * @return 	0=success, anything else=error
+ * Return:	0=success, anything else=error
  */
 int w1_reset_select_slave(struct w1_slave *sl)
 {
@@ -409,6 +417,9 @@ int w1_reset_select_slave(struct w1_slave *sl)
 EXPORT_SYMBOL_GPL(w1_reset_select_slave);
 
 /**
+ * w1_reset_resume_command() - resume instead of another match ROM
+ * @dev:	the master device
+ *
  * When the workflow with a slave amongst many requires several
  * successive commands a reset between each, this function is similar
  * to doing a reset then a match ROM for the last matched ROM. The
@@ -420,8 +431,6 @@ EXPORT_SYMBOL_GPL(w1_reset_select_slave);
  * doesn't work of course, but the resume command is the next best thing.
  *
  * The w1 master lock must be held.
- *
- * @param dev     the master device
  */
 int w1_reset_resume_command(struct w1_master *dev)
 {
@@ -435,6 +444,10 @@ int w1_reset_resume_command(struct w1_master *dev)
 EXPORT_SYMBOL_GPL(w1_reset_resume_command);
 
 /**
+ * w1_next_pullup() - register for a strong pullup
+ * @dev:	the master device
+ * @delay:	time in milliseconds
+ *
  * Put out a strong pull-up of the specified duration after the next write
  * operation.  Not all hardware supports strong pullups.  Hardware that
  * doesn't support strong pullups will sleep for the given time after the
@@ -442,8 +455,7 @@ EXPORT_SYMBOL_GPL(w1_reset_resume_command);
  * the next write, specifying zero will clear a previous request.
  * The w1 master lock must be held.
  *
- * @param delay	time in milliseconds
- * @return	0=success, anything else=error
+ * Return:	0=success, anything else=error
  */
 void w1_next_pullup(struct w1_master *dev, int delay)
 {
diff --git a/drivers/w1/w1_netlink.h b/drivers/w1/w1_netlink.h
index ea9f3e4..1e9504e 100644
--- a/drivers/w1/w1_netlink.h
+++ b/drivers/w1/w1_netlink.h
@@ -27,7 +27,8 @@
 
 #include "w1.h"
 
-/** enum w1_netlink_message_types - message type
+/**
+ * enum w1_netlink_message_types - message type
  *
  * @W1_SLAVE_ADD: notification that a slave device was added
  * @W1_SLAVE_REMOVE: notification that a slave device was removed
@@ -63,7 +64,8 @@ struct w1_netlink_msg
 	__u8				data[0];
 };
 
-/** enum w1_commands - commands available for master or slave operations
+/**
+ * enum w1_commands - commands available for master or slave operations
  * @W1_CMD_READ: read len bytes
  * @W1_CMD_WRITE: write len bytes
  * @W1_CMD_SEARCH: initiate a standard search, returns only the slave
-- 
1.7.10.4

