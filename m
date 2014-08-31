Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaHaI1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:27:31 -0400
Received: from leviathan.tchmachines.com ([208.76.85.180]:50033 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHaI1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:27:07 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2014 04:27:07 EDT
From: Eli Billauer <eli.billauer@gmail.com>
To: gregkh@linuxfoundation.org, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH] staging: xillybus: Move out of staging
Date: Sun, 31 Aug 2014 10:57:01 +0300
Message-Id: <1409471821-11809-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver has been functional and stable throughout the year it has spent
in the staging area. It has been patched for minor bugs, coding style issues
and improvements during this period, so I suppose its time has come.

I shall continue being responsible for its maintenance.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 .../devicetree/bindings/staging/xillybus.txt       |   20 -
 .../devicetree/bindings/xillybus/xillybus.txt      |   20 +
 Documentation/xillybus.txt                         |  380 ++++
 drivers/char/Kconfig                               |    2 +
 drivers/char/Makefile                              |    1 +
 drivers/char/xillybus/Kconfig                      |   33 +
 drivers/char/xillybus/Makefile                     |    7 +
 drivers/char/xillybus/xillybus.h                   |  161 ++
 drivers/char/xillybus/xillybus_core.c              | 2160 ++++++++++++++++++++
 drivers/char/xillybus/xillybus_of.c                |  186 ++
 drivers/char/xillybus/xillybus_pcie.c              |  230 +++
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/xillybus/Kconfig                   |   33 -
 drivers/staging/xillybus/Makefile                  |    7 -
 drivers/staging/xillybus/README                    |  380 ----
 drivers/staging/xillybus/TODO                      |    5 -
 drivers/staging/xillybus/xillybus.h                |  161 --
 drivers/staging/xillybus/xillybus_core.c           | 2160 --------------------
 drivers/staging/xillybus/xillybus_of.c             |  186 --
 drivers/staging/xillybus/xillybus_pcie.c           |  230 ---
 21 files changed, 3180 insertions(+), 3185 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/staging/xillybus.txt
 create mode 100644 Documentation/devicetree/bindings/xillybus/xillybus.txt
 create mode 100644 Documentation/xillybus.txt
 create mode 100644 drivers/char/xillybus/Kconfig
 create mode 100644 drivers/char/xillybus/Makefile
 create mode 100644 drivers/char/xillybus/xillybus.h
 create mode 100644 drivers/char/xillybus/xillybus_core.c
 create mode 100644 drivers/char/xillybus/xillybus_of.c
 create mode 100644 drivers/char/xillybus/xillybus_pcie.c
 delete mode 100644 drivers/staging/xillybus/Kconfig
 delete mode 100644 drivers/staging/xillybus/Makefile
 delete mode 100644 drivers/staging/xillybus/README
 delete mode 100644 drivers/staging/xillybus/TODO
 delete mode 100644 drivers/staging/xillybus/xillybus.h
 delete mode 100644 drivers/staging/xillybus/xillybus_core.c
 delete mode 100644 drivers/staging/xillybus/xillybus_of.c
 delete mode 100644 drivers/staging/xillybus/xillybus_pcie.c

diff --git a/Documentation/devicetree/bindings/staging/xillybus.txt b/Documentation/devicetree/bindings/staging/xillybus.txt
deleted file mode 100644
index 9e316dc..0000000
--- a/Documentation/devicetree/bindings/staging/xillybus.txt
+++ /dev/null
@@ -1,20 +0,0 @@
-* Xillybus driver for generic FPGA interface
-
-Required properties:
-- compatible: Should be "xillybus,xillybus-1.00.a"
-- reg: Address and length of the register set for the device
-- interrupts: Contains one interrupt node, typically consisting of three cells.
-- interrupt-parent: the phandle for the interrupt controller that
-                    services interrupts for this device.
-
-Optional properties:
-- dma-coherent: Present if DMA operations are coherent
-
-Example:
-
-	xillybus@ff200400 {
-		compatible = "xillybus,xillybus-1.00.a";
-		reg = < 0xff200400 0x00000080 >;
-		interrupts = < 0 40 1 >;
-		interrupt-parent = <&intc>;
-	} ;
diff --git a/Documentation/devicetree/bindings/xillybus/xillybus.txt b/Documentation/devicetree/bindings/xillybus/xillybus.txt
new file mode 100644
index 0000000..9e316dc
--- /dev/null
+++ b/Documentation/devicetree/bindings/xillybus/xillybus.txt
@@ -0,0 +1,20 @@
+* Xillybus driver for generic FPGA interface
+
+Required properties:
+- compatible: Should be "xillybus,xillybus-1.00.a"
+- reg: Address and length of the register set for the device
+- interrupts: Contains one interrupt node, typically consisting of three cells.
+- interrupt-parent: the phandle for the interrupt controller that
+                    services interrupts for this device.
+
+Optional properties:
+- dma-coherent: Present if DMA operations are coherent
+
+Example:
+
+	xillybus@ff200400 {
+		compatible = "xillybus,xillybus-1.00.a";
+		reg = < 0xff200400 0x00000080 >;
+		interrupts = < 0 40 1 >;
+		interrupt-parent = <&intc>;
+	} ;
diff --git a/Documentation/xillybus.txt b/Documentation/xillybus.txt
new file mode 100644
index 0000000..81d111b
--- /dev/null
+++ b/Documentation/xillybus.txt
@@ -0,0 +1,380 @@
+
+               ==========================================
+               Xillybus driver for generic FPGA interface
+               ==========================================
+
+Author: Eli Billauer, Xillybus Ltd. (http://xillybus.com)
+Email:  eli.billauer@gmail.com or as advertised on Xillybus' site.
+
+Contents:
+
+ - Introduction
+  -- Background
+  -- Xillybus Overview
+
+ - Usage
+  -- User interface
+  -- Synchronization
+  -- Seekable pipes
+
+- Internals
+  -- Source code organization
+  -- Pipe attributes
+  -- Host never reads from the FPGA
+  -- Channels, pipes, and the message channel
+  -- Data streaming
+  -- Data granularity
+  -- Probing
+  -- Buffer allocation
+  -- The "nonempty" message (supporting poll)
+
+
+INTRODUCTION
+============
+
+Background
+----------
+
+An FPGA (Field Programmable Gate Array) is a piece of logic hardware, which
+can be programmed to become virtually anything that is usually found as a
+dedicated chipset: For instance, a display adapter, network interface card,
+or even a processor with its peripherals. FPGAs are the LEGO of hardware:
+Based upon certain building blocks, you make your own toys the way you like
+them. It's usually pointless to reimplement something that is already
+available on the market as a chipset, so FPGAs are mostly used when some
+special functionality is needed, and the production volume is relatively low
+(hence not justifying the development of an ASIC).
+
+The challenge with FPGAs is that everything is implemented at a very low
+level, even lower than assembly language. In order to allow FPGA designers to
+focus on their specific project, and not reinvent the wheel over and over
+again, pre-designed building blocks, IP cores, are often used. These are the
+FPGA parallels of library functions. IP cores may implement certain
+mathematical functions, a functional unit (e.g. a USB interface), an entire
+processor (e.g. ARM) or anything that might come handy. Think of them as a
+building block, with electrical wires dangling on the sides for connection to
+other blocks.
+
+One of the daunting tasks in FPGA design is communicating with a fullblown
+operating system (actually, with the processor running it): Implementing the
+low-level bus protocol and the somewhat higher-level interface with the host
+(registers, interrupts, DMA etc.) is a project in itself. When the FPGA's
+function is a well-known one (e.g. a video adapter card, or a NIC), it can
+make sense to design the FPGA's interface logic specifically for the project.
+A special driver is then written to present the FPGA as a well-known interface
+to the kernel and/or user space. In that case, there is no reason to treat the
+FPGA differently than any device on the bus.
+
+It's however common that the desired data communication doesn't fit any well-
+known peripheral function. Also, the effort of designing an elegant
+abstraction for the data exchange is often considered too big. In those cases,
+a quicker and possibly less elegant solution is sought: The driver is
+effectively written as a user space program, leaving the kernel space part
+with just elementary data transport. This still requires designing some
+interface logic for the FPGA, and write a simple ad-hoc driver for the kernel.
+
+Xillybus Overview
+-----------------
+
+Xillybus is an IP core and a Linux driver. Together, they form a kit for
+elementary data transport between an FPGA and the host, providing pipe-like
+data streams with a straightforward user interface. It's intended as a low-
+effort solution for mixed FPGA-host projects, for which it makes sense to
+have the project-specific part of the driver running in a user-space program.
+
+Since the communication requirements may vary significantly from one FPGA
+project to another (the number of data pipes needed in each direction and
+their attributes), there isn't one specific chunk of logic being the Xillybus
+IP core. Rather, the IP core is configured and built based upon a
+specification given by its end user.
+
+Xillybus presents independent data streams, which resemble pipes or TCP/IP
+communication to the user. At the host side, a character device file is used
+just like any pipe file. On the FPGA side, hardware FIFOs are used to stream
+the data. This is contrary to a common method of communicating through fixed-
+sized buffers (even though such buffers are used by Xillybus under the hood).
+There may be more than a hundred of these streams on a single IP core, but
+also no more than one, depending on the configuration.
+
+In order to ease the deployment of the Xillybus IP core, it contains a simple
+data structure which completely defines the core's configuration. The Linux
+driver fetches this data structure during its initialization process, and sets
+up the DMA buffers and character devices accordingly. As a result, a single
+driver is used to work out of the box with any Xillybus IP core.
+
+The data structure just mentioned should not be confused with PCI's
+configuration space or the Flattened Device Tree.
+
+USAGE
+=====
+
+User interface
+--------------
+
+On the host, all interface with Xillybus is done through /dev/xillybus_*
+device files, which are generated automatically as the drivers loads. The
+names of these files depend on the IP core that is loaded in the FPGA (see
+Probing below). To communicate with the FPGA, open the device file that
+corresponds to the hardware FIFO you want to send data or receive data from,
+and use plain write() or read() calls, just like with a regular pipe. In
+particular, it makes perfect sense to go:
+
+$ cat mydata > /dev/xillybus_thisfifo
+
+$ cat /dev/xillybus_thatfifo > hisdata
+
+possibly pressing CTRL-C as some stage, even though the xillybus_* pipes have
+the capability to send an EOF (but may not use it).
+
+The driver and hardware are designed to behave sensibly as pipes, including:
+
+* Supporting non-blocking I/O (by setting O_NONBLOCK on open() ).
+
+* Supporting poll() and select().
+
+* Being bandwidth efficient under load (using DMA) but also handle small
+  pieces of data sent across (like TCP/IP) by autoflushing.
+
+A device file can be read only, write only or bidirectional. Bidirectional
+device files are treated like two independent pipes (except for sharing a
+"channel" structure in the implementation code).
+
+Synchronization
+---------------
+
+Xillybus pipes are configured (on the IP core) to be either synchronous or
+asynchronous. For a synchronous pipe, write() returns successfully only after
+some data has been submitted and acknowledged by the FPGA. This slows down
+bulk data transfers, and is nearly impossible for use with streams that
+require data at a constant rate: There is no data transmitted to the FPGA
+between write() calls, in particular when the process loses the CPU.
+
+When a pipe is configured asynchronous, write() returns if there was enough
+room in the buffers to store any of the data in the buffers.
+
+For FPGA to host pipes, asynchronous pipes allow data transfer from the FPGA
+as soon as the respective device file is opened, regardless of if the data
+has been requested by a read() call. On synchronous pipes, only the amount
+of data requested by a read() call is transmitted.
+
+In summary, for synchronous pipes, data between the host and FPGA is
+transmitted only to satisfy the read() or write() call currently handled
+by the driver, and those calls wait for the transmission to complete before
+returning.
+
+Note that the synchronization attribute has nothing to do with the possibility
+that read() or write() completes less bytes than requested. There is a
+separate configuration flag ("allowpartial") that determines whether such a
+partial completion is allowed.
+
+Seekable pipes
+--------------
+
+A synchronous pipe can be configured to have the stream's position exposed
+to the user logic at the FPGA. Such a pipe is also seekable on the host API.
+With this feature, a memory or register interface can be attached on the
+FPGA side to the seekable stream. Reading or writing to a certain address in
+the attached memory is done by seeking to the desired address, and calling
+read() or write() as required.
+
+
+INTERNALS
+=========
+
+Source code organization
+------------------------
+
+The Xillybus driver consists of a core module, xillybus_core.c, and modules
+that depend on the specific bus interface (xillybus_of.c and xillybus_pcie.c).
+
+The bus specific modules are those probed when a suitable device is found by
+the kernel. Since the DMA mapping and synchronization functions, which are bus
+dependent by their nature, are used by the core module, a
+xilly_endpoint_hardware structure is passed to the core module on
+initialization. This structure is populated with pointers to wrapper functions
+which execute the DMA-related operations on the bus.
+
+Pipe attributes
+---------------
+
+Each pipe has a number of attributes which are set when the FPGA component
+(IP core) is built. They are fetched from the IDT (the data structure which
+defines the core's configuration, see Probing below) by xilly_setupchannels()
+in xillybus_core.c as follows:
+
+* is_writebuf: The pipe's direction. A non-zero value means it's an FPGA to
+  host pipe (the FPGA "writes").
+
+* channelnum: The pipe's identification number in communication between the
+  host and FPGA.
+
+* format: The underlying data width. See Data Granularity below.
+
+* allowpartial: A non-zero value means that a read() or write() (whichever
+  applies) may return with less than the requested number of bytes. The common
+  choice is a non-zero value, to match standard UNIX behavior.
+
+* synchronous: A non-zero value means that the pipe is synchronous. See
+  Syncronization above.
+
+* bufsize: Each DMA buffer's size. Always a power of two.
+
+* bufnum: The number of buffers allocated for this pipe. Always a power of two.
+
+* exclusive_open: A non-zero value forces exclusive opening of the associated
+  device file. If the device file is bidirectional, and already opened only in
+  one direction, the opposite direction may be opened once.
+
+* seekable: A non-zero value indicates that the pipe is seekable. See
+  Seekable pipes above.
+
+* supports_nonempty: A non-zero value (which is typical) indicates that the
+  hardware will send the messages that are necessary to support select() and
+  poll() for this pipe.
+
+Host never reads from the FPGA
+------------------------------
+
+Even though PCI Express is hotpluggable in general, a typical motherboard
+doesn't expect a card to go away all of the sudden. But since the PCIe card
+is based upon reprogrammable logic, a sudden disappearance from the bus is
+quite likely as a result of an accidental reprogramming of the FPGA while the
+host is up. In practice, nothing happens immediately in such a situation. But
+if the host attempts to read from an address that is mapped to the PCI Express
+device, that leads to an immediate freeze of the system on some motherboards,
+even though the PCIe standard requires a graceful recovery.
+
+In order to avoid these freezes, the Xillybus driver refrains completely from
+reading from the device's register space. All communication from the FPGA to
+the host is done through DMA. In particular, the Interrupt Service Routine
+doesn't follow the common practice of checking a status register when it's
+invoked. Rather, the FPGA prepares a small buffer which contains short
+messages, which inform the host what the interrupt was about.
+
+This mechanism is used on non-PCIe buses as well for the sake of uniformity.
+
+
+Channels, pipes, and the message channel
+----------------------------------------
+
+Each of the (possibly bidirectional) pipes presented to the user is allocated
+a data channel between the FPGA and the host. The distinction between channels
+and pipes is necessary only because of channel 0, which is used for interrupt-
+related messages from the FPGA, and has no pipe attached to it.
+
+Data streaming
+--------------
+
+Even though a non-segmented data stream is presented to the user at both
+sides, the implementation relies on a set of DMA buffers which is allocated
+for each channel. For the sake of illustration, let's take the FPGA to host
+direction: As data streams into the respective channel's interface in the
+FPGA, the Xillybus IP core writes it to one of the DMA buffers. When the
+buffer is full, the FPGA informs the host about that (appending a
+XILLYMSG_OPCODE_RELEASEBUF message channel 0 and sending an interrupt if
+necessary). The host responds by making the data available for reading through
+the character device. When all data has been read, the host writes on the
+the FPGA's buffer control register, allowing the buffer's overwriting. Flow
+control mechanisms exist on both sides to prevent underflows and overflows.
+
+This is not good enough for creating a TCP/IP-like stream: If the data flow
+stops momentarily before a DMA buffer is filled, the intuitive expectation is
+that the partial data in buffer will arrive anyhow, despite the buffer not
+being completed. This is implemented by adding a field in the
+XILLYMSG_OPCODE_RELEASEBUF message, through which the FPGA informs not just
+which buffer is submitted, but how much data it contains.
+
+But the FPGA will submit a partially filled buffer only if directed to do so
+by the host. This situation occurs when the read() method has been blocking
+for XILLY_RX_TIMEOUT jiffies (currently 10 ms), after which the host commands
+the FPGA to submit a DMA buffer as soon as it can. This timeout mechanism
+balances between bus bandwidth efficiency (preventing a lot of partially
+filled buffers being sent) and a latency held fairly low for tails of data.
+
+A similar setting is used in the host to FPGA direction. The handling of
+partial DMA buffers is somewhat different, though. The user can tell the
+driver to submit all data it has in the buffers to the FPGA, by issuing a
+write() with the byte count set to zero. This is similar to a flush request,
+but it doesn't block. There is also an autoflushing mechanism, which triggers
+an equivalent flush roughly XILLY_RX_TIMEOUT jiffies after the last write().
+This allows the user to be oblivious about the underlying buffering mechanism
+and yet enjoy a stream-like interface.
+
+Note that the issue of partial buffer flushing is irrelevant for pipes having
+the "synchronous" attribute nonzero, since synchronous pipes don't allow data
+to lay around in the DMA buffers between read() and write() anyhow.
+
+Data granularity
+----------------
+
+The data arrives or is sent at the FPGA as 8, 16 or 32 bit wide words, as
+configured by the "format" attribute. Whenever possible, the driver attempts
+to hide this when the pipe is accessed differently from its natural alignment.
+For example, reading single bytes from a pipe with 32 bit granularity works
+with no issues. Writing single bytes to pipes with 16 or 32 bit granularity
+will also work, but the driver can't send partially completed words to the
+FPGA, so the transmission of up to one word may be held until it's fully
+occupied with user data.
+
+This somewhat complicates the handling of host to FPGA streams, because
+when a buffer is flushed, it may contain up to 3 bytes don't form a word in
+the FPGA, and hence can't be sent. To prevent loss of data, these leftover
+bytes need to be moved to the next buffer. The parts in xillybus_core.c
+that mention "leftovers" in some way are related to this complication.
+
+Probing
+-------
+
+As mentioned earlier, the number of pipes that are created when the driver
+loads and their attributes depend on the Xillybus IP core in the FPGA. During
+the driver's initialization, a blob containing configuration info, the
+Interface Description Table (IDT), is sent from the FPGA to the host. The
+bootstrap process is done in three phases:
+
+1. Acquire the length of the IDT, so a buffer can be allocated for it. This
+   is done by sending a quiesce command to the device, since the acknowledge
+   for this command contains the IDT's buffer length.
+
+2. Acquire the IDT itself.
+
+3. Create the interfaces according to the IDT.
+
+Buffer allocation
+-----------------
+
+In order to simplify the logic that prevents illegal boundary crossings of
+PCIe packets, the following rule applies: If a buffer is smaller than 4kB,
+it must not cross a 4kB boundary. Otherwise, it must be 4kB aligned. The
+xilly_setupchannels() functions allocates these buffers by requesting whole
+pages from the kernel, and diving them into DMA buffers as necessary. Since
+all buffers' sizes are powers of two, it's possible to pack any set of such
+buffers, with a maximal waste of one page of memory.
+
+All buffers are allocated when the driver is loaded. This is necessary,
+since large continuous physical memory segments are sometimes requested,
+which are more likely to be available when the system is freshly booted.
+
+The allocation of buffer memory takes place in the same order they appear in
+the IDT. The driver relies on a rule that the pipes are sorted with decreasing
+buffer size in the IDT. If a requested buffer is larger or equal to a page,
+the necessary number of pages is requested from the kernel, and these are
+used for this buffer. If the requested buffer is smaller than a page, one
+single page is requested from the kernel, and that page is partially used.
+Or, if there already is a partially used page at hand, the buffer is packed
+into that page. It can be shown that all pages requested from the kernel
+(except possibly for the last) are 100% utilized this way.
+
+The "nonempty" message (supporting poll)
+---------------------------------------
+
+In order to support the "poll" method (and hence select() ), there is a small
+catch regarding the FPGA to host direction: The FPGA may have filled a DMA
+buffer with some data, but not submitted that buffer. If the host waited for
+the buffer's submission by the FPGA, there would be a possibility that the
+FPGA side has sent data, but a select() call would still block, because the
+host has not received any notification about this. This is solved with
+XILLYMSG_OPCODE_NONEMPTY messages sent by the FPGA when a channel goes from
+completely empty to containing some data.
+
+These messages are used only to support poll() and select(). The IP core can
+be configured not to send them for a slight reduction of bandwidth.
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6e9f74a..efefd12 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -600,5 +600,7 @@ config TILE_SROM
 	  device appear much like a simple EEPROM, and knows
 	  how to partition a single ROM for multiple purposes.
 
+source "drivers/char/xillybus/Kconfig"
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index a324f93..d06cde26 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
+obj-$(CONFIG_XILLYBUS)		+= xillybus/
diff --git a/drivers/char/xillybus/Kconfig b/drivers/char/xillybus/Kconfig
new file mode 100644
index 0000000..b53bdf1
--- /dev/null
+++ b/drivers/char/xillybus/Kconfig
@@ -0,0 +1,33 @@
+#
+# Xillybus devices
+#
+
+config XILLYBUS
+	tristate "Xillybus generic FPGA interface"
+	depends on PCI || (OF_ADDRESS && OF_IRQ)
+	select CRC32
+	help
+	  Xillybus is a generic interface for peripherals designed on
+	  programmable logic (FPGA). The driver probes the hardware for
+	  its capabilities, and creates device files accordingly.
+
+	  If unsure, say N.
+
+if XILLYBUS
+
+config XILLYBUS_PCIE
+	tristate "Xillybus over PCIe"
+	depends on PCI_MSI
+	help
+	  Set to M if you want Xillybus to use PCI Express for communicating
+	  with the FPGA.
+
+config XILLYBUS_OF
+	tristate "Xillybus over Device Tree"
+	depends on OF_ADDRESS && OF_IRQ
+	help
+	  Set to M if you want Xillybus to find its resources from the
+	  Open Firmware Flattened Device Tree. If the target is an embedded
+	  system, say M.
+
+endif # if XILLYBUS
diff --git a/drivers/char/xillybus/Makefile b/drivers/char/xillybus/Makefile
new file mode 100644
index 0000000..b68b7eb
--- /dev/null
+++ b/drivers/char/xillybus/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for Xillybus driver
+#
+
+obj-$(CONFIG_XILLYBUS)		+= xillybus_core.o
+obj-$(CONFIG_XILLYBUS_PCIE)	+= xillybus_pcie.o
+obj-$(CONFIG_XILLYBUS_OF)	+= xillybus_of.o
diff --git a/drivers/char/xillybus/xillybus.h b/drivers/char/xillybus/xillybus.h
new file mode 100644
index 0000000..a0806b5
--- /dev/null
+++ b/drivers/char/xillybus/xillybus.h
@@ -0,0 +1,161 @@
+/*
+ * linux/drivers/misc/xillybus.h
+ *
+ * Copyright 2011 Xillybus Ltd, http://xillybus.com
+ *
+ * Header file for the Xillybus FPGA/host framework.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#ifndef __XILLYBUS_H
+#define __XILLYBUS_H
+
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/cdev.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+
+struct xilly_endpoint_hardware;
+
+struct xilly_buffer {
+	void *addr;
+	dma_addr_t dma_addr;
+	int end_offset; /* Counting elements, not bytes */
+};
+
+struct xilly_idt_handle {
+	unsigned char *chandesc;
+	unsigned char *idt;
+	int entries;
+};
+
+/*
+ * Read-write confusion: wr_* and rd_* notation sticks to FPGA view, so
+ * wr_* buffers are those consumed by read(), since the FPGA writes to them
+ * and vice versa.
+ */
+
+struct xilly_channel {
+	struct xilly_endpoint *endpoint;
+	int chan_num;
+	int log2_element_size;
+	int seekable;
+
+	struct xilly_buffer **wr_buffers; /* FPGA writes, driver reads! */
+	int num_wr_buffers;
+	unsigned int wr_buf_size; /* In bytes */
+	int wr_fpga_buf_idx;
+	int wr_host_buf_idx;
+	int wr_host_buf_pos;
+	int wr_empty;
+	int wr_ready; /* Significant only when wr_empty == 1 */
+	int wr_sleepy;
+	int wr_eof;
+	int wr_hangup;
+	spinlock_t wr_spinlock;
+	struct mutex wr_mutex;
+	wait_queue_head_t wr_wait;
+	wait_queue_head_t wr_ready_wait;
+	int wr_ref_count;
+	int wr_synchronous;
+	int wr_allow_partial;
+	int wr_exclusive_open;
+	int wr_supports_nonempty;
+
+	struct xilly_buffer **rd_buffers; /* FPGA reads, driver writes! */
+	int num_rd_buffers;
+	unsigned int rd_buf_size; /* In bytes */
+	int rd_fpga_buf_idx;
+	int rd_host_buf_pos;
+	int rd_host_buf_idx;
+	int rd_full;
+	spinlock_t rd_spinlock;
+	struct mutex rd_mutex;
+	wait_queue_head_t rd_wait;
+	int rd_ref_count;
+	int rd_allow_partial;
+	int rd_synchronous;
+	int rd_exclusive_open;
+	struct delayed_work rd_workitem;
+	unsigned char rd_leftovers[4];
+};
+
+struct xilly_endpoint {
+	/*
+	 * One of pdev and dev is always NULL, and the other is a valid
+	 * pointer, depending on the type of device
+	 */
+	struct pci_dev *pdev;
+	struct device *dev;
+	struct xilly_endpoint_hardware *ephw;
+
+	struct list_head ep_list;
+	int dma_using_dac; /* =1 if 64-bit DMA is used, =0 otherwise. */
+	__iomem void *registers;
+	int fatal_error;
+
+	struct mutex register_mutex;
+	wait_queue_head_t ep_wait;
+
+	/* Channels and message handling */
+	struct cdev cdev;
+
+	int major;
+	int lowest_minor; /* Highest minor = lowest_minor + num_channels - 1 */
+
+	int num_channels; /* EXCLUDING message buffer */
+	struct xilly_channel **channels;
+	int msg_counter;
+	int failed_messages;
+	int idtlen;
+
+	u32 *msgbuf_addr;
+	dma_addr_t msgbuf_dma_addr;
+	unsigned int msg_buf_size;
+};
+
+struct xilly_endpoint_hardware {
+	struct module *owner;
+	void (*hw_sync_sgl_for_cpu)(struct xilly_endpoint *,
+				    dma_addr_t,
+				    size_t,
+				    int);
+	void (*hw_sync_sgl_for_device)(struct xilly_endpoint *,
+				       dma_addr_t,
+				       size_t,
+				       int);
+	int (*map_single)(struct xilly_endpoint *,
+			  void *,
+			  size_t,
+			  int,
+			  dma_addr_t *);
+};
+
+struct xilly_mapping {
+	void *device;
+	dma_addr_t dma_addr;
+	size_t size;
+	int direction;
+};
+
+
+irqreturn_t xillybus_isr(int irq, void *data);
+
+struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
+					      struct device *dev,
+					      struct xilly_endpoint_hardware
+					      *ephw);
+
+int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint);
+
+void xillybus_endpoint_remove(struct xilly_endpoint *endpoint);
+
+#endif /* __XILLYBUS_H */
diff --git a/drivers/char/xillybus/xillybus_core.c b/drivers/char/xillybus/xillybus_core.c
new file mode 100644
index 0000000..d5a7202
--- /dev/null
+++ b/drivers/char/xillybus/xillybus_core.c
@@ -0,0 +1,2160 @@
+/*
+ * linux/drivers/misc/xillybus_core.c
+ *
+ * Copyright 2011 Xillybus Ltd, http://xillybus.com
+ *
+ * Driver for the Xillybus FPGA/host framework.
+ *
+ * This driver interfaces with a special IP core in an FPGA, setting up
+ * a pipe between a hardware FIFO in the programmable logic and a device
+ * file in the host. The number of such pipes and their attributes are
+ * set up on the logic. This driver detects these automatically and
+ * creates the device files accordingly.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/crc32.h>
+#include <linux/poll.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/workqueue.h>
+#include "xillybus.h"
+
+MODULE_DESCRIPTION("Xillybus core functions");
+MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
+MODULE_VERSION("1.07");
+MODULE_ALIAS("xillybus_core");
+MODULE_LICENSE("GPL v2");
+
+/* General timeout is 100 ms, rx timeout is 10 ms */
+#define XILLY_RX_TIMEOUT (10*HZ/1000)
+#define XILLY_TIMEOUT (100*HZ/1000)
+
+#define fpga_msg_ctrl_reg              0x0008
+#define fpga_dma_control_reg           0x0020
+#define fpga_dma_bufno_reg             0x0024
+#define fpga_dma_bufaddr_lowaddr_reg   0x0028
+#define fpga_dma_bufaddr_highaddr_reg  0x002c
+#define fpga_buf_ctrl_reg              0x0030
+#define fpga_buf_offset_reg            0x0034
+#define fpga_endian_reg                0x0040
+
+#define XILLYMSG_OPCODE_RELEASEBUF 1
+#define XILLYMSG_OPCODE_QUIESCEACK 2
+#define XILLYMSG_OPCODE_FIFOEOF 3
+#define XILLYMSG_OPCODE_FATAL_ERROR 4
+#define XILLYMSG_OPCODE_NONEMPTY 5
+
+static const char xillyname[] = "xillybus";
+
+static struct class *xillybus_class;
+
+/*
+ * ep_list_lock is the last lock to be taken; No other lock requests are
+ * allowed while holding it. It merely protects list_of_endpoints, and not
+ * the endpoints listed in it.
+ */
+
+static LIST_HEAD(list_of_endpoints);
+static struct mutex ep_list_lock;
+static struct workqueue_struct *xillybus_wq;
+
+/*
+ * Locking scheme: Mutexes protect invocations of character device methods.
+ * If both locks are taken, wr_mutex is taken first, rd_mutex second.
+ *
+ * wr_spinlock protects wr_*_buf_idx, wr_empty, wr_sleepy, wr_ready and the
+ * buffers' end_offset fields against changes made by IRQ handler (and in
+ * theory, other file request handlers, but the mutex handles that). Nothing
+ * else.
+ * They are held for short direct memory manipulations. Needless to say,
+ * no mutex locking is allowed when a spinlock is held.
+ *
+ * rd_spinlock does the same with rd_*_buf_idx, rd_empty and end_offset.
+ *
+ * register_mutex is endpoint-specific, and is held when non-atomic
+ * register operations are performed. wr_mutex and rd_mutex may be
+ * held when register_mutex is taken, but none of the spinlocks. Note that
+ * register_mutex doesn't protect against sporadic buf_ctrl_reg writes
+ * which are unrelated to buf_offset_reg, since they are harmless.
+ *
+ * Blocking on the wait queues is allowed with mutexes held, but not with
+ * spinlocks.
+ *
+ * Only interruptible blocking is allowed on mutexes and wait queues.
+ *
+ * All in all, the locking order goes (with skips allowed, of course):
+ * wr_mutex -> rd_mutex -> register_mutex -> wr_spinlock -> rd_spinlock
+ */
+
+static void malformed_message(struct xilly_endpoint *endpoint, u32 *buf)
+{
+	int opcode;
+	int msg_channel, msg_bufno, msg_data, msg_dir;
+
+	opcode = (buf[0] >> 24) & 0xff;
+	msg_dir = buf[0] & 1;
+	msg_channel = (buf[0] >> 1) & 0x7ff;
+	msg_bufno = (buf[0] >> 12) & 0x3ff;
+	msg_data = buf[1] & 0xfffffff;
+
+	dev_warn(endpoint->dev,
+		 "Malformed message (skipping): opcode=%d, channel=%03x, dir=%d, bufno=%03x, data=%07x\n",
+		 opcode, msg_channel, msg_dir, msg_bufno, msg_data);
+}
+
+/*
+ * xillybus_isr assumes the interrupt is allocated exclusively to it,
+ * which is the natural case MSI and several other hardware-oriented
+ * interrupts. Sharing is not allowed.
+ */
+
+irqreturn_t xillybus_isr(int irq, void *data)
+{
+	struct xilly_endpoint *ep = data;
+	u32 *buf;
+	unsigned int buf_size;
+	int i;
+	int opcode;
+	unsigned int msg_channel, msg_bufno, msg_data, msg_dir;
+	struct xilly_channel *channel;
+
+	buf = ep->msgbuf_addr;
+	buf_size = ep->msg_buf_size/sizeof(u32);
+
+	ep->ephw->hw_sync_sgl_for_cpu(ep,
+				      ep->msgbuf_dma_addr,
+				      ep->msg_buf_size,
+				      DMA_FROM_DEVICE);
+
+	for (i = 0; i < buf_size; i += 2)
+		if (((buf[i+1] >> 28) & 0xf) != ep->msg_counter) {
+			malformed_message(ep, &buf[i]);
+			dev_warn(ep->dev,
+				 "Sending a NACK on counter %x (instead of %x) on entry %d\n",
+				((buf[i+1] >> 28) & 0xf),
+				ep->msg_counter,
+				i/2);
+
+			if (++ep->failed_messages > 10) {
+				dev_err(ep->dev,
+					"Lost sync with interrupt messages. Stopping.\n");
+			} else {
+				ep->ephw->hw_sync_sgl_for_device(
+					ep,
+					ep->msgbuf_dma_addr,
+					ep->msg_buf_size,
+					DMA_FROM_DEVICE);
+
+				iowrite32(0x01,  /* Message NACK */
+					  ep->registers + fpga_msg_ctrl_reg);
+			}
+			return IRQ_HANDLED;
+		} else if (buf[i] & (1 << 22)) /* Last message */
+			break;
+
+	if (i >= buf_size) {
+		dev_err(ep->dev, "Bad interrupt message. Stopping.\n");
+		return IRQ_HANDLED;
+	}
+
+	buf_size = i;
+
+	for (i = 0; i <= buf_size; i += 2) { /* Scan through messages */
+		opcode = (buf[i] >> 24) & 0xff;
+
+		msg_dir = buf[i] & 1;
+		msg_channel = (buf[i] >> 1) & 0x7ff;
+		msg_bufno = (buf[i] >> 12) & 0x3ff;
+		msg_data = buf[i+1] & 0xfffffff;
+
+		switch (opcode) {
+		case XILLYMSG_OPCODE_RELEASEBUF:
+
+			if ((msg_channel > ep->num_channels) ||
+			    (msg_channel == 0)) {
+				malformed_message(ep, &buf[i]);
+				break;
+			}
+
+			channel = ep->channels[msg_channel];
+
+			if (msg_dir) { /* Write channel */
+				if (msg_bufno >= channel->num_wr_buffers) {
+					malformed_message(ep, &buf[i]);
+					break;
+				}
+				spin_lock(&channel->wr_spinlock);
+				channel->wr_buffers[msg_bufno]->end_offset =
+					msg_data;
+				channel->wr_fpga_buf_idx = msg_bufno;
+				channel->wr_empty = 0;
+				channel->wr_sleepy = 0;
+				spin_unlock(&channel->wr_spinlock);
+
+				wake_up_interruptible(&channel->wr_wait);
+
+			} else {
+				/* Read channel */
+
+				if (msg_bufno >= channel->num_rd_buffers) {
+					malformed_message(ep, &buf[i]);
+					break;
+				}
+
+				spin_lock(&channel->rd_spinlock);
+				channel->rd_fpga_buf_idx = msg_bufno;
+				channel->rd_full = 0;
+				spin_unlock(&channel->rd_spinlock);
+
+				wake_up_interruptible(&channel->rd_wait);
+				if (!channel->rd_synchronous)
+					queue_delayed_work(
+						xillybus_wq,
+						&channel->rd_workitem,
+						XILLY_RX_TIMEOUT);
+			}
+
+			break;
+		case XILLYMSG_OPCODE_NONEMPTY:
+			if ((msg_channel > ep->num_channels) ||
+			    (msg_channel == 0) || (!msg_dir) ||
+			    !ep->channels[msg_channel]->wr_supports_nonempty) {
+				malformed_message(ep, &buf[i]);
+				break;
+			}
+
+			channel = ep->channels[msg_channel];
+
+			if (msg_bufno >= channel->num_wr_buffers) {
+				malformed_message(ep, &buf[i]);
+				break;
+			}
+			spin_lock(&channel->wr_spinlock);
+			if (msg_bufno == channel->wr_host_buf_idx)
+				channel->wr_ready = 1;
+			spin_unlock(&channel->wr_spinlock);
+
+			wake_up_interruptible(&channel->wr_ready_wait);
+
+			break;
+		case XILLYMSG_OPCODE_QUIESCEACK:
+			ep->idtlen = msg_data;
+			wake_up_interruptible(&ep->ep_wait);
+
+			break;
+		case XILLYMSG_OPCODE_FIFOEOF:
+			if ((msg_channel > ep->num_channels) ||
+			    (msg_channel == 0) || (!msg_dir) ||
+			    !ep->channels[msg_channel]->num_wr_buffers) {
+				malformed_message(ep, &buf[i]);
+				break;
+			}
+			channel = ep->channels[msg_channel];
+			spin_lock(&channel->wr_spinlock);
+			channel->wr_eof = msg_bufno;
+			channel->wr_sleepy = 0;
+
+			channel->wr_hangup = channel->wr_empty &&
+				(channel->wr_host_buf_idx == msg_bufno);
+
+			spin_unlock(&channel->wr_spinlock);
+
+			wake_up_interruptible(&channel->wr_wait);
+
+			break;
+		case XILLYMSG_OPCODE_FATAL_ERROR:
+			ep->fatal_error = 1;
+			wake_up_interruptible(&ep->ep_wait); /* For select() */
+			dev_err(ep->dev,
+				"FPGA reported a fatal error. This means that the low-level communication with the device has failed. This hardware problem is most likely unrelated to Xillybus (neither kernel module nor FPGA core), but reports are still welcome. All I/O is aborted.\n");
+			break;
+		default:
+			malformed_message(ep, &buf[i]);
+			break;
+		}
+	}
+
+	ep->ephw->hw_sync_sgl_for_device(ep,
+					 ep->msgbuf_dma_addr,
+					 ep->msg_buf_size,
+					 DMA_FROM_DEVICE);
+
+	ep->msg_counter = (ep->msg_counter + 1) & 0xf;
+	ep->failed_messages = 0;
+	iowrite32(0x03, ep->registers + fpga_msg_ctrl_reg); /* Message ACK */
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL(xillybus_isr);
+
+/*
+ * A few trivial memory management functions.
+ * NOTE: These functions are used only on probe and remove, and therefore
+ * no locks are applied!
+ */
+
+static void xillybus_autoflush(struct work_struct *work);
+
+struct xilly_alloc_state {
+	void *salami;
+	int left_of_salami;
+	int nbuffer;
+	enum dma_data_direction direction;
+	u32 regdirection;
+};
+
+static int xilly_get_dma_buffers(struct xilly_endpoint *ep,
+				 struct xilly_alloc_state *s,
+				 struct xilly_buffer **buffers,
+				 int bufnum, int bytebufsize)
+{
+	int i, rc;
+	dma_addr_t dma_addr;
+	struct device *dev = ep->dev;
+	struct xilly_buffer *this_buffer = NULL; /* Init to silence warning */
+
+	if (buffers) { /* Not the message buffer */
+		this_buffer = devm_kzalloc(
+			dev, bufnum * sizeof(struct xilly_buffer),
+			GFP_KERNEL);
+
+		if (!this_buffer)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < bufnum; i++) {
+		/*
+		 * Buffers are expected in descending size order, so there
+		 * is either enough space for this buffer or none at all.
+		 */
+
+		if ((s->left_of_salami < bytebufsize) &&
+		    (s->left_of_salami > 0)) {
+			dev_err(ep->dev,
+				"Corrupt buffer allocation in IDT. Aborting.\n");
+			return -ENODEV;
+		}
+
+		if (s->left_of_salami == 0) {
+			int allocorder, allocsize;
+
+			allocsize = PAGE_SIZE;
+			allocorder = 0;
+			while (bytebufsize > allocsize) {
+				allocsize *= 2;
+				allocorder++;
+			}
+
+			s->salami = (void *) devm_get_free_pages(
+				dev,
+				GFP_KERNEL | __GFP_DMA32 | __GFP_ZERO,
+				allocorder);
+
+			if (!s->salami)
+				return -ENOMEM;
+			s->left_of_salami = allocsize;
+		}
+
+		rc = ep->ephw->map_single(ep, s->salami,
+					  bytebufsize, s->direction,
+					  &dma_addr);
+
+		if (rc)
+			return rc;
+
+		iowrite32((u32) (dma_addr & 0xffffffff),
+			  ep->registers + fpga_dma_bufaddr_lowaddr_reg);
+		iowrite32(((u32) ((((u64) dma_addr) >> 32) & 0xffffffff)),
+			  ep->registers + fpga_dma_bufaddr_highaddr_reg);
+
+		if (buffers) { /* Not the message buffer */
+			this_buffer->addr = s->salami;
+			this_buffer->dma_addr = dma_addr;
+			buffers[i] = this_buffer++;
+
+			iowrite32(s->regdirection | s->nbuffer++,
+				  ep->registers + fpga_dma_bufno_reg);
+		} else {
+			ep->msgbuf_addr = s->salami;
+			ep->msgbuf_dma_addr = dma_addr;
+			ep->msg_buf_size = bytebufsize;
+
+			iowrite32(s->regdirection,
+				  ep->registers + fpga_dma_bufno_reg);
+		}
+
+		s->left_of_salami -= bytebufsize;
+		s->salami += bytebufsize;
+	}
+	return 0; /* Success */
+}
+
+static int xilly_setupchannels(struct xilly_endpoint *ep,
+			       unsigned char *chandesc,
+			       int entries
+	)
+{
+	struct device *dev = ep->dev;
+	int i, entry, rc;
+	struct xilly_channel *channel;
+	int channelnum, bufnum, bufsize, format, is_writebuf;
+	int bytebufsize;
+	int synchronous, allowpartial, exclusive_open, seekable;
+	int supports_nonempty;
+	int msg_buf_done = 0;
+
+	struct xilly_alloc_state rd_alloc = {
+		.salami = NULL,
+		.left_of_salami = 0,
+		.nbuffer = 1,
+		.direction = DMA_TO_DEVICE,
+		.regdirection = 0,
+	};
+
+	struct xilly_alloc_state wr_alloc = {
+		.salami = NULL,
+		.left_of_salami = 0,
+		.nbuffer = 1,
+		.direction = DMA_FROM_DEVICE,
+		.regdirection = 0x80000000,
+	};
+
+	channel = devm_kzalloc(dev, ep->num_channels *
+			       sizeof(struct xilly_channel), GFP_KERNEL);
+
+	if (!channel)
+		goto memfail;
+
+	ep->channels = devm_kzalloc(dev, (ep->num_channels + 1) *
+				    sizeof(struct xilly_channel *),
+				    GFP_KERNEL);
+
+	if (!ep->channels)
+		goto memfail;
+
+	ep->channels[0] = NULL; /* Channel 0 is message buf. */
+
+	/* Initialize all channels with defaults */
+
+	for (i = 1; i <= ep->num_channels; i++) {
+		channel->wr_buffers = NULL;
+		channel->rd_buffers = NULL;
+		channel->num_wr_buffers = 0;
+		channel->num_rd_buffers = 0;
+		channel->wr_fpga_buf_idx = -1;
+		channel->wr_host_buf_idx = 0;
+		channel->wr_host_buf_pos = 0;
+		channel->wr_empty = 1;
+		channel->wr_ready = 0;
+		channel->wr_sleepy = 1;
+		channel->rd_fpga_buf_idx = 0;
+		channel->rd_host_buf_idx = 0;
+		channel->rd_host_buf_pos = 0;
+		channel->rd_full = 0;
+		channel->wr_ref_count = 0;
+		channel->rd_ref_count = 0;
+
+		spin_lock_init(&channel->wr_spinlock);
+		spin_lock_init(&channel->rd_spinlock);
+		mutex_init(&channel->wr_mutex);
+		mutex_init(&channel->rd_mutex);
+		init_waitqueue_head(&channel->rd_wait);
+		init_waitqueue_head(&channel->wr_wait);
+		init_waitqueue_head(&channel->wr_ready_wait);
+
+		INIT_DELAYED_WORK(&channel->rd_workitem, xillybus_autoflush);
+
+		channel->endpoint = ep;
+		channel->chan_num = i;
+
+		channel->log2_element_size = 0;
+
+		ep->channels[i] = channel++;
+	}
+
+	for (entry = 0; entry < entries; entry++, chandesc += 4) {
+		struct xilly_buffer **buffers = NULL;
+
+		is_writebuf = chandesc[0] & 0x01;
+		channelnum = (chandesc[0] >> 1) | ((chandesc[1] & 0x0f) << 7);
+		format = (chandesc[1] >> 4) & 0x03;
+		allowpartial = (chandesc[1] >> 6) & 0x01;
+		synchronous = (chandesc[1] >> 7) & 0x01;
+		bufsize = 1 << (chandesc[2] & 0x1f);
+		bufnum = 1 << (chandesc[3] & 0x0f);
+		exclusive_open = (chandesc[2] >> 7) & 0x01;
+		seekable = (chandesc[2] >> 6) & 0x01;
+		supports_nonempty = (chandesc[2] >> 5) & 0x01;
+
+		if ((channelnum > ep->num_channels) ||
+		    ((channelnum == 0) && !is_writebuf)) {
+			dev_err(ep->dev,
+				"IDT requests channel out of range. Aborting.\n");
+			return -ENODEV;
+		}
+
+		channel = ep->channels[channelnum]; /* NULL for msg channel */
+
+		if (!is_writebuf || channelnum > 0) {
+			channel->log2_element_size = ((format > 2) ?
+						      2 : format);
+
+			bytebufsize = channel->rd_buf_size = bufsize *
+				(1 << channel->log2_element_size);
+
+			buffers = devm_kzalloc(dev,
+				bufnum * sizeof(struct xilly_buffer *),
+				GFP_KERNEL);
+
+			if (!buffers)
+				goto memfail;
+		} else {
+			bytebufsize = bufsize << 2;
+		}
+
+		if (!is_writebuf) {
+			channel->num_rd_buffers = bufnum;
+			channel->rd_allow_partial = allowpartial;
+			channel->rd_synchronous = synchronous;
+			channel->rd_exclusive_open = exclusive_open;
+			channel->seekable = seekable;
+
+			channel->rd_buffers = buffers;
+			rc = xilly_get_dma_buffers(ep, &rd_alloc, buffers,
+						   bufnum, bytebufsize);
+		} else if (channelnum > 0) {
+			channel->num_wr_buffers = bufnum;
+
+			channel->seekable = seekable;
+			channel->wr_supports_nonempty = supports_nonempty;
+
+			channel->wr_allow_partial = allowpartial;
+			channel->wr_synchronous = synchronous;
+			channel->wr_exclusive_open = exclusive_open;
+
+			channel->wr_buffers = buffers;
+			rc = xilly_get_dma_buffers(ep, &wr_alloc, buffers,
+						   bufnum, bytebufsize);
+		} else {
+			rc = xilly_get_dma_buffers(ep, &wr_alloc, NULL,
+						   bufnum, bytebufsize);
+			msg_buf_done++;
+		}
+
+		if (rc)
+			goto memfail;
+	}
+
+	if (!msg_buf_done) {
+		dev_err(ep->dev,
+			"Corrupt IDT: No message buffer. Aborting.\n");
+		return -ENODEV;
+	}
+	return 0;
+
+memfail:
+	dev_err(ep->dev,
+		"Failed to assign DMA buffer memory. Aborting.\n");
+	return -ENOMEM;
+}
+
+static void xilly_scan_idt(struct xilly_endpoint *endpoint,
+			   struct xilly_idt_handle *idt_handle)
+{
+	int count = 0;
+	unsigned char *idt = endpoint->channels[1]->wr_buffers[0]->addr;
+	unsigned char *end_of_idt = idt + endpoint->idtlen - 4;
+	unsigned char *scan;
+	int len;
+
+	scan = idt;
+	idt_handle->idt = idt;
+
+	scan++; /* Skip version number */
+
+	while ((scan <= end_of_idt) && *scan) {
+		while ((scan <= end_of_idt) && *scan++)
+			/* Do nothing, just scan thru string */;
+		count++;
+	}
+
+	scan++;
+
+	if (scan > end_of_idt) {
+		dev_err(endpoint->dev,
+			"IDT device name list overflow. Aborting.\n");
+		idt_handle->chandesc = NULL;
+		return;
+	}
+	idt_handle->chandesc = scan;
+
+	len = endpoint->idtlen - (3 + ((int) (scan - idt)));
+
+	if (len & 0x03) {
+		idt_handle->chandesc = NULL;
+
+		dev_err(endpoint->dev,
+			"Corrupt IDT device name list. Aborting.\n");
+	}
+
+	idt_handle->entries = len >> 2;
+
+	endpoint->num_channels = count;
+}
+
+static int xilly_obtain_idt(struct xilly_endpoint *endpoint)
+{
+	int rc = 0;
+	struct xilly_channel *channel;
+	unsigned char *version;
+
+	channel = endpoint->channels[1]; /* This should be generated ad-hoc */
+
+	channel->wr_sleepy = 1;
+
+	iowrite32(1 |
+		   (3 << 24), /* Opcode 3 for channel 0 = Send IDT */
+		   endpoint->registers + fpga_buf_ctrl_reg);
+
+	wait_event_interruptible_timeout(channel->wr_wait,
+					 (!channel->wr_sleepy),
+					 XILLY_TIMEOUT);
+
+	if (channel->wr_sleepy) {
+		dev_err(endpoint->dev, "Failed to obtain IDT. Aborting.\n");
+
+		if (endpoint->fatal_error)
+			return -EIO;
+
+		rc = -ENODEV;
+		return rc;
+	}
+
+	endpoint->ephw->hw_sync_sgl_for_cpu(
+		channel->endpoint,
+		channel->wr_buffers[0]->dma_addr,
+		channel->wr_buf_size,
+		DMA_FROM_DEVICE);
+
+	if (channel->wr_buffers[0]->end_offset != endpoint->idtlen) {
+		dev_err(endpoint->dev,
+			"IDT length mismatch (%d != %d). Aborting.\n",
+		       channel->wr_buffers[0]->end_offset, endpoint->idtlen);
+		rc = -ENODEV;
+		return rc;
+	}
+
+	if (crc32_le(~0, channel->wr_buffers[0]->addr,
+		     endpoint->idtlen+1) != 0) {
+		dev_err(endpoint->dev, "IDT failed CRC check. Aborting.\n");
+		rc = -ENODEV;
+		return rc;
+	}
+
+	version = channel->wr_buffers[0]->addr;
+
+	/* Check version number. Accept anything below 0x82 for now. */
+	if (*version > 0x82) {
+		dev_err(endpoint->dev,
+			"No support for IDT version 0x%02x. Maybe the xillybus driver needs an upgarde. Aborting.\n",
+		       (int) *version);
+		rc = -ENODEV;
+		return rc;
+	}
+
+	return 0; /* Success */
+}
+
+static ssize_t xillybus_read(struct file *filp, char __user *userbuf,
+			     size_t count, loff_t *f_pos)
+{
+	ssize_t rc;
+	unsigned long flags;
+	int bytes_done = 0;
+	int no_time_left = 0;
+	long deadline, left_to_sleep;
+	struct xilly_channel *channel = filp->private_data;
+
+	int empty, reached_eof, exhausted, ready;
+	/* Initializations are there only to silence warnings */
+
+	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
+	int waiting_bufidx;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	deadline = jiffies + 1 + XILLY_RX_TIMEOUT;
+
+	rc = mutex_lock_interruptible(&channel->wr_mutex);
+
+	if (rc)
+		return rc;
+
+	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
+
+	while (1) { /* Note that we may drop mutex within this loop */
+		int bytes_to_do = count - bytes_done;
+
+		spin_lock_irqsave(&channel->wr_spinlock, flags);
+
+		empty = channel->wr_empty;
+		ready = !empty || channel->wr_ready;
+
+		if (!empty) {
+			bufidx = channel->wr_host_buf_idx;
+			bufpos = channel->wr_host_buf_pos;
+			howmany = ((channel->wr_buffers[bufidx]->end_offset
+				    + 1) << channel->log2_element_size)
+				- bufpos;
+
+			/* Update wr_host_* to its post-operation state */
+			if (howmany > bytes_to_do) {
+				bufferdone = 0;
+
+				howmany = bytes_to_do;
+				channel->wr_host_buf_pos += howmany;
+			} else {
+				bufferdone = 1;
+
+				channel->wr_host_buf_pos = 0;
+
+				if (bufidx == channel->wr_fpga_buf_idx) {
+					channel->wr_empty = 1;
+					channel->wr_sleepy = 1;
+					channel->wr_ready = 0;
+				}
+
+				if (bufidx >= (channel->num_wr_buffers - 1))
+					channel->wr_host_buf_idx = 0;
+				else
+					channel->wr_host_buf_idx++;
+			}
+		}
+
+		/*
+		 * Marking our situation after the possible changes above,
+		 * for use after releasing the spinlock.
+		 *
+		 * empty = empty before change
+		 * exhasted = empty after possible change
+		 */
+
+		reached_eof = channel->wr_empty &&
+			(channel->wr_host_buf_idx == channel->wr_eof);
+		channel->wr_hangup = reached_eof;
+		exhausted = channel->wr_empty;
+		waiting_bufidx = channel->wr_host_buf_idx;
+
+		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+
+		if (!empty) { /* Go on, now without the spinlock */
+
+			if (bufpos == 0) /* Position zero means it's virgin */
+				channel->endpoint->ephw->hw_sync_sgl_for_cpu(
+					channel->endpoint,
+					channel->wr_buffers[bufidx]->dma_addr,
+					channel->wr_buf_size,
+					DMA_FROM_DEVICE);
+
+			if (copy_to_user(
+				    userbuf,
+				    channel->wr_buffers[bufidx]->addr
+				    + bufpos, howmany))
+				rc = -EFAULT;
+
+			userbuf += howmany;
+			bytes_done += howmany;
+
+			if (bufferdone) {
+				channel->endpoint->ephw->
+					hw_sync_sgl_for_device
+					(
+						channel->endpoint,
+						channel->wr_buffers[bufidx]->
+						dma_addr,
+						channel->wr_buf_size,
+						DMA_FROM_DEVICE);
+
+				/*
+				 * Tell FPGA the buffer is done with. It's an
+				 * atomic operation to the FPGA, so what
+				 * happens with other channels doesn't matter,
+				 * and the certain channel is protected with
+				 * the channel-specific mutex.
+				 */
+
+				iowrite32(1 | (channel->chan_num << 1)
+					   | (bufidx << 12),
+					   channel->endpoint->registers +
+					   fpga_buf_ctrl_reg);
+			}
+
+			if (rc) {
+				mutex_unlock(&channel->wr_mutex);
+				return rc;
+			}
+		}
+
+		/* This includes a zero-count return = EOF */
+		if ((bytes_done >= count) || reached_eof)
+			break;
+
+		if (!exhausted)
+			continue; /* More in RAM buffer(s)? Just go on. */
+
+		if ((bytes_done > 0) &&
+		    (no_time_left ||
+		     (channel->wr_synchronous && channel->wr_allow_partial)))
+			break;
+
+		/*
+		 * Nonblocking read: The "ready" flag tells us that the FPGA
+		 * has data to send. In non-blocking mode, if it isn't on,
+		 * just return. But if there is, we jump directly to the point
+		 * where we ask for the FPGA to send all it has, and wait
+		 * until that data arrives. So in a sense, we *do* block in
+		 * nonblocking mode, but only for a very short time.
+		 */
+
+		if (!no_time_left && (filp->f_flags & O_NONBLOCK)) {
+			if (bytes_done > 0)
+				break;
+
+			if (ready)
+				goto desperate;
+
+			bytes_done = -EAGAIN;
+			break;
+		}
+
+		if (!no_time_left || (bytes_done > 0)) {
+			/*
+			 * Note that in case of an element-misaligned read
+			 * request, offsetlimit will include the last element,
+			 * which will be partially read from.
+			 */
+			int offsetlimit = ((count - bytes_done) - 1) >>
+				channel->log2_element_size;
+			int buf_elements = channel->wr_buf_size >>
+				channel->log2_element_size;
+
+			/*
+			 * In synchronous mode, always send an offset limit.
+			 * Just don't send a value too big.
+			 */
+
+			if (channel->wr_synchronous) {
+				/* Don't request more than one buffer */
+				if (channel->wr_allow_partial &&
+				    (offsetlimit >= buf_elements))
+					offsetlimit = buf_elements - 1;
+
+				/* Don't request more than all buffers */
+				if (!channel->wr_allow_partial &&
+				    (offsetlimit >=
+				     (buf_elements * channel->num_wr_buffers)))
+					offsetlimit = buf_elements *
+						channel->num_wr_buffers - 1;
+			}
+
+			/*
+			 * In asynchronous mode, force early flush of a buffer
+			 * only if that will allow returning a full count. The
+			 * "offsetlimit < ( ... )" rather than "<=" excludes
+			 * requesting a full buffer, which would obviously
+			 * cause a buffer transmission anyhow
+			 */
+
+			if (channel->wr_synchronous ||
+			    (offsetlimit < (buf_elements - 1))) {
+
+				mutex_lock(&channel->endpoint->register_mutex);
+
+				iowrite32(offsetlimit,
+					  channel->endpoint->registers +
+					  fpga_buf_offset_reg);
+
+				iowrite32(1 | (channel->chan_num << 1) |
+					   (2 << 24) |  /* 2 = offset limit */
+					   (waiting_bufidx << 12),
+					   channel->endpoint->registers +
+					   fpga_buf_ctrl_reg);
+
+				mutex_unlock(&channel->endpoint->
+					     register_mutex);
+			}
+
+		}
+
+		/*
+		 * If partial completion is disallowed, there is no point in
+		 * timeout sleeping. Neither if no_time_left is set and
+		 * there's no data.
+		 */
+
+		if (!channel->wr_allow_partial ||
+		    (no_time_left && (bytes_done == 0))) {
+
+			/*
+			 * This do-loop will run more than once if another
+			 * thread reasserted wr_sleepy before we got the mutex
+			 * back, so we try again.
+			 */
+
+			do {
+				mutex_unlock(&channel->wr_mutex);
+
+				if (wait_event_interruptible(
+					    channel->wr_wait,
+					    (!channel->wr_sleepy)))
+					goto interrupted;
+
+				if (mutex_lock_interruptible(
+					    &channel->wr_mutex))
+					goto interrupted;
+			} while (channel->wr_sleepy);
+
+			continue;
+
+interrupted: /* Mutex is not held if got here */
+			if (channel->endpoint->fatal_error)
+				return -EIO;
+			if (bytes_done)
+				return bytes_done;
+			if (filp->f_flags & O_NONBLOCK)
+				return -EAGAIN; /* Don't admit snoozing */
+			return -EINTR;
+		}
+
+		left_to_sleep = deadline - ((long) jiffies);
+
+		/*
+		 * If our time is out, skip the waiting. We may miss wr_sleepy
+		 * being deasserted but hey, almost missing the train is like
+		 * missing it.
+		 */
+
+		if (left_to_sleep > 0) {
+			left_to_sleep =
+				wait_event_interruptible_timeout(
+					channel->wr_wait,
+					(!channel->wr_sleepy),
+					left_to_sleep);
+
+			if (!channel->wr_sleepy)
+				continue;
+
+			if (left_to_sleep < 0) { /* Interrupt */
+				mutex_unlock(&channel->wr_mutex);
+				if (channel->endpoint->fatal_error)
+					return -EIO;
+				if (bytes_done)
+					return bytes_done;
+				return -EINTR;
+			}
+		}
+
+desperate:
+		no_time_left = 1; /* We're out of sleeping time. Desperate! */
+
+		if (bytes_done == 0) {
+			/*
+			 * Reaching here means that we allow partial return,
+			 * that we've run out of time, and that we have
+			 * nothing to return.
+			 * So tell the FPGA to send anything it has or gets.
+			 */
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				   (3 << 24) |  /* Opcode 3, flush it all! */
+				   (waiting_bufidx << 12),
+				   channel->endpoint->registers +
+				   fpga_buf_ctrl_reg);
+		}
+
+		/*
+		 * Formally speaking, we should block for data at this point.
+		 * But to keep the code cleaner, we'll just finish the loop,
+		 * make the unlikely check for data, and then block at the
+		 * usual place.
+		 */
+	}
+
+	mutex_unlock(&channel->wr_mutex);
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return bytes_done;
+}
+
+/*
+ * The timeout argument takes values as follows:
+ *  >0 : Flush with timeout
+ * ==0 : Flush, and wait idefinitely for the flush to complete
+ *  <0 : Autoflush: Flush only if there's a single buffer occupied
+ */
+
+static int xillybus_myflush(struct xilly_channel *channel, long timeout)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	int end_offset_plus1;
+	int bufidx, bufidx_minus1;
+	int i;
+	int empty;
+	int new_rd_host_buf_pos;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+	rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+	if (rc)
+		return rc;
+
+	/*
+	 * Don't flush a closed channel. This can happen when the work queued
+	 * autoflush thread fires off after the file has closed. This is not
+	 * an error, just something to dismiss.
+	 */
+
+	if (!channel->rd_ref_count)
+		goto done;
+
+	bufidx = channel->rd_host_buf_idx;
+
+	bufidx_minus1 = (bufidx == 0) ? channel->num_rd_buffers - 1 : bufidx-1;
+
+	end_offset_plus1 = channel->rd_host_buf_pos >>
+		channel->log2_element_size;
+
+	new_rd_host_buf_pos = channel->rd_host_buf_pos -
+		(end_offset_plus1 << channel->log2_element_size);
+
+	/* Submit the current buffer if it's nonempty */
+	if (end_offset_plus1) {
+		unsigned char *tail = channel->rd_buffers[bufidx]->addr +
+			(end_offset_plus1 << channel->log2_element_size);
+
+		/* Copy  unflushed data, so we can put it in next buffer */
+		for (i = 0; i < new_rd_host_buf_pos; i++)
+			channel->rd_leftovers[i] = *tail++;
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		/* Autoflush only if a single buffer is occupied */
+
+		if ((timeout < 0) &&
+		    (channel->rd_full ||
+		     (bufidx_minus1 != channel->rd_fpga_buf_idx))) {
+			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+			/*
+			 * A new work item may be queued by the ISR exactly
+			 * now, since the execution of a work item allows the
+			 * queuing of a new one while it's running.
+			 */
+			goto done;
+		}
+
+		/* The 4th element is never needed for data, so it's a flag */
+		channel->rd_leftovers[3] = (new_rd_host_buf_pos != 0);
+
+		/* Set up rd_full to reflect a certain moment's state */
+
+		if (bufidx == channel->rd_fpga_buf_idx)
+			channel->rd_full = 1;
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (bufidx >= (channel->num_rd_buffers - 1))
+			channel->rd_host_buf_idx = 0;
+		else
+			channel->rd_host_buf_idx++;
+
+		channel->endpoint->ephw->hw_sync_sgl_for_device(
+			channel->endpoint,
+			channel->rd_buffers[bufidx]->dma_addr,
+			channel->rd_buf_size,
+			DMA_TO_DEVICE);
+
+		mutex_lock(&channel->endpoint->register_mutex);
+
+		iowrite32(end_offset_plus1 - 1,
+			  channel->endpoint->registers + fpga_buf_offset_reg);
+
+		iowrite32((channel->chan_num << 1) | /* Channel ID */
+			   (2 << 24) |  /* Opcode 2, submit buffer */
+			   (bufidx << 12),
+			   channel->endpoint->registers + fpga_buf_ctrl_reg);
+
+		mutex_unlock(&channel->endpoint->register_mutex);
+	} else if (bufidx == 0)
+		bufidx = channel->num_rd_buffers - 1;
+	else
+		bufidx--;
+
+	channel->rd_host_buf_pos = new_rd_host_buf_pos;
+
+	if (timeout < 0)
+		goto done; /* Autoflush */
+
+
+	/*
+	 * bufidx is now the last buffer written to (or equal to
+	 * rd_fpga_buf_idx if buffer was never written to), and
+	 * channel->rd_host_buf_idx the one after it.
+	 *
+	 * If bufidx == channel->rd_fpga_buf_idx we're either empty or full.
+	 */
+
+	rc = 0;
+
+	while (1) { /* Loop waiting for draining of buffers */
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		if (bufidx != channel->rd_fpga_buf_idx)
+			channel->rd_full = 1; /*
+					       * Not really full,
+					       * but needs waiting.
+					       */
+
+		empty = !channel->rd_full;
+
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (empty)
+			break;
+
+		/*
+		 * Indefinite sleep with mutex taken. With data waiting for
+		 * flushing user should not be surprised if open() for write
+		 * sleeps.
+		 */
+		if (timeout == 0)
+			wait_event_interruptible(channel->rd_wait,
+						 (!channel->rd_full));
+
+		else if (wait_event_interruptible_timeout(
+				 channel->rd_wait,
+				 (!channel->rd_full),
+				 timeout) == 0) {
+			dev_warn(channel->endpoint->dev,
+				"Timed out while flushing. Output data may be lost.\n");
+
+			rc = -ETIMEDOUT;
+			break;
+		}
+
+		if (channel->rd_full) {
+			rc = -EINTR;
+			break;
+		}
+	}
+
+done:
+	mutex_unlock(&channel->rd_mutex);
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return rc;
+}
+
+static int xillybus_flush(struct file *filp, fl_owner_t id)
+{
+	if (!(filp->f_mode & FMODE_WRITE))
+		return 0;
+
+	return xillybus_myflush(filp->private_data, HZ); /* 1 second timeout */
+}
+
+static void xillybus_autoflush(struct work_struct *work)
+{
+	struct delayed_work *workitem = container_of(
+		work, struct delayed_work, work);
+	struct xilly_channel *channel = container_of(
+		workitem, struct xilly_channel, rd_workitem);
+	int rc;
+
+	rc = xillybus_myflush(channel, -1);
+
+	if (rc == -EINTR)
+		dev_warn(channel->endpoint->dev,
+			 "Autoflush failed because work queue thread got a signal.\n");
+	else if (rc)
+		dev_err(channel->endpoint->dev,
+			"Autoflush failed under weird circumstances.\n");
+}
+
+static ssize_t xillybus_write(struct file *filp, const char __user *userbuf,
+			      size_t count, loff_t *f_pos)
+{
+	ssize_t rc;
+	unsigned long flags;
+	int bytes_done = 0;
+	struct xilly_channel *channel = filp->private_data;
+
+	int full, exhausted;
+	/* Initializations are there only to silence warnings */
+
+	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
+	int end_offset_plus1 = 0;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+	if (rc)
+		return rc;
+
+	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
+
+	while (1) {
+		int bytes_to_do = count - bytes_done;
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+
+		full = channel->rd_full;
+
+		if (!full) {
+			bufidx = channel->rd_host_buf_idx;
+			bufpos = channel->rd_host_buf_pos;
+			howmany = channel->rd_buf_size - bufpos;
+
+			/*
+			 * Update rd_host_* to its state after this operation.
+			 * count=0 means committing the buffer immediately,
+			 * which is like flushing, but not necessarily block.
+			 */
+
+			if ((howmany > bytes_to_do) &&
+			    (count ||
+			     ((bufpos >> channel->log2_element_size) == 0))) {
+				bufferdone = 0;
+
+				howmany = bytes_to_do;
+				channel->rd_host_buf_pos += howmany;
+			} else {
+				bufferdone = 1;
+
+				if (count) {
+					end_offset_plus1 =
+						channel->rd_buf_size >>
+						channel->log2_element_size;
+					channel->rd_host_buf_pos = 0;
+				} else {
+					unsigned char *tail;
+					int i;
+
+					end_offset_plus1 = bufpos >>
+						channel->log2_element_size;
+
+					channel->rd_host_buf_pos -=
+						end_offset_plus1 <<
+						channel->log2_element_size;
+
+					tail = channel->
+						rd_buffers[bufidx]->addr +
+						(end_offset_plus1 <<
+						 channel->log2_element_size);
+
+					for (i = 0;
+					     i < channel->rd_host_buf_pos;
+					     i++)
+						channel->rd_leftovers[i] =
+							*tail++;
+				}
+
+				if (bufidx == channel->rd_fpga_buf_idx)
+					channel->rd_full = 1;
+
+				if (bufidx >= (channel->num_rd_buffers - 1))
+					channel->rd_host_buf_idx = 0;
+				else
+					channel->rd_host_buf_idx++;
+			}
+		}
+
+		/*
+		 * Marking our situation after the possible changes above,
+		 * for use  after releasing the spinlock.
+		 *
+		 * full = full before change
+		 * exhasted = full after possible change
+		 */
+
+		exhausted = channel->rd_full;
+
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+		if (!full) { /* Go on, now without the spinlock */
+			unsigned char *head =
+				channel->rd_buffers[bufidx]->addr;
+			int i;
+
+			if ((bufpos == 0) || /* Zero means it's virgin */
+			    (channel->rd_leftovers[3] != 0)) {
+				channel->endpoint->ephw->hw_sync_sgl_for_cpu(
+					channel->endpoint,
+					channel->rd_buffers[bufidx]->dma_addr,
+					channel->rd_buf_size,
+					DMA_TO_DEVICE);
+
+				/* Virgin, but leftovers are due */
+				for (i = 0; i < bufpos; i++)
+					*head++ = channel->rd_leftovers[i];
+
+				channel->rd_leftovers[3] = 0; /* Clear flag */
+			}
+
+			if (copy_from_user(
+				    channel->rd_buffers[bufidx]->addr + bufpos,
+				    userbuf, howmany))
+				rc = -EFAULT;
+
+			userbuf += howmany;
+			bytes_done += howmany;
+
+			if (bufferdone) {
+				channel->endpoint->ephw->
+					hw_sync_sgl_for_device(
+						channel->endpoint,
+						channel->rd_buffers[bufidx]->
+						dma_addr,
+						channel->rd_buf_size,
+						DMA_TO_DEVICE);
+
+				mutex_lock(&channel->endpoint->register_mutex);
+
+				iowrite32(end_offset_plus1 - 1,
+					  channel->endpoint->registers +
+					  fpga_buf_offset_reg);
+
+				iowrite32((channel->chan_num << 1) |
+					   (2 << 24) |  /* 2 = submit buffer */
+					   (bufidx << 12),
+					   channel->endpoint->registers +
+					   fpga_buf_ctrl_reg);
+
+				mutex_unlock(&channel->endpoint->
+					     register_mutex);
+
+				channel->rd_leftovers[3] =
+					(channel->rd_host_buf_pos != 0);
+			}
+
+			if (rc) {
+				mutex_unlock(&channel->rd_mutex);
+
+				if (channel->endpoint->fatal_error)
+					return -EIO;
+
+				if (!channel->rd_synchronous)
+					queue_delayed_work(
+						xillybus_wq,
+						&channel->rd_workitem,
+						XILLY_RX_TIMEOUT);
+
+				return rc;
+			}
+		}
+
+		if (bytes_done >= count)
+			break;
+
+		if (!exhausted)
+			continue; /* If there's more space, just go on */
+
+		if ((bytes_done > 0) && channel->rd_allow_partial)
+			break;
+
+		/*
+		 * Indefinite sleep with mutex taken. With data waiting for
+		 * flushing, user should not be surprised if open() for write
+		 * sleeps.
+		 */
+
+		if (filp->f_flags & O_NONBLOCK) {
+			bytes_done = -EAGAIN;
+			break;
+		}
+
+		wait_event_interruptible(channel->rd_wait,
+					 (!channel->rd_full));
+
+		if (channel->rd_full) {
+			mutex_unlock(&channel->rd_mutex);
+
+			if (channel->endpoint->fatal_error)
+				return -EIO;
+
+			if (bytes_done)
+				return bytes_done;
+			return -EINTR;
+		}
+	}
+
+	mutex_unlock(&channel->rd_mutex);
+
+	if (!channel->rd_synchronous)
+		queue_delayed_work(xillybus_wq,
+				   &channel->rd_workitem,
+				   XILLY_RX_TIMEOUT);
+
+	if ((channel->rd_synchronous) && (bytes_done > 0)) {
+		rc = xillybus_myflush(filp->private_data, 0); /* No timeout */
+
+		if (rc && (rc != -EINTR))
+			return rc;
+	}
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	return bytes_done;
+}
+
+static int xillybus_open(struct inode *inode, struct file *filp)
+{
+	int rc = 0;
+	unsigned long flags;
+	int minor = iminor(inode);
+	int major = imajor(inode);
+	struct xilly_endpoint *ep_iter, *endpoint = NULL;
+	struct xilly_channel *channel;
+
+	mutex_lock(&ep_list_lock);
+
+	list_for_each_entry(ep_iter, &list_of_endpoints, ep_list) {
+		if ((ep_iter->major == major) &&
+		    (minor >= ep_iter->lowest_minor) &&
+		    (minor < (ep_iter->lowest_minor +
+			      ep_iter->num_channels))) {
+			endpoint = ep_iter;
+			break;
+		}
+	}
+	mutex_unlock(&ep_list_lock);
+
+	if (!endpoint) {
+		pr_err("xillybus: open() failed to find a device for major=%d and minor=%d\n",
+		       major, minor);
+		return -ENODEV;
+	}
+
+	if (endpoint->fatal_error)
+		return -EIO;
+
+	channel = endpoint->channels[1 + minor - endpoint->lowest_minor];
+	filp->private_data = channel;
+
+
+	/*
+	 * It gets complicated because:
+	 * 1. We don't want to take a mutex we don't have to
+	 * 2. We don't want to open one direction if the other will fail.
+	 */
+
+	if ((filp->f_mode & FMODE_READ) && (!channel->num_wr_buffers))
+		return -ENODEV;
+
+	if ((filp->f_mode & FMODE_WRITE) && (!channel->num_rd_buffers))
+		return -ENODEV;
+
+	if ((filp->f_mode & FMODE_READ) && (filp->f_flags & O_NONBLOCK) &&
+	    (channel->wr_synchronous || !channel->wr_allow_partial ||
+	     !channel->wr_supports_nonempty)) {
+		dev_err(endpoint->dev,
+			"open() failed: O_NONBLOCK not allowed for read on this device\n");
+		return -ENODEV;
+	}
+
+	if ((filp->f_mode & FMODE_WRITE) && (filp->f_flags & O_NONBLOCK) &&
+	    (channel->rd_synchronous || !channel->rd_allow_partial)) {
+		dev_err(endpoint->dev,
+			"open() failed: O_NONBLOCK not allowed for write on this device\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Note: open() may block on getting mutexes despite O_NONBLOCK.
+	 * This shouldn't occur normally, since multiple open of the same
+	 * file descriptor is almost always prohibited anyhow
+	 * (*_exclusive_open is normally set in real-life systems).
+	 */
+
+	if (filp->f_mode & FMODE_READ) {
+		rc = mutex_lock_interruptible(&channel->wr_mutex);
+		if (rc)
+			return rc;
+	}
+
+	if (filp->f_mode & FMODE_WRITE) {
+		rc = mutex_lock_interruptible(&channel->rd_mutex);
+		if (rc)
+			goto unlock_wr;
+	}
+
+	if ((filp->f_mode & FMODE_READ) &&
+	    (channel->wr_ref_count != 0) &&
+	    (channel->wr_exclusive_open)) {
+		rc = -EBUSY;
+		goto unlock;
+	}
+
+	if ((filp->f_mode & FMODE_WRITE) &&
+	    (channel->rd_ref_count != 0) &&
+	    (channel->rd_exclusive_open)) {
+		rc = -EBUSY;
+		goto unlock;
+	}
+
+
+	if (filp->f_mode & FMODE_READ) {
+		if (channel->wr_ref_count == 0) { /* First open of file */
+			/* Move the host to first buffer */
+			spin_lock_irqsave(&channel->wr_spinlock, flags);
+			channel->wr_host_buf_idx = 0;
+			channel->wr_host_buf_pos = 0;
+			channel->wr_fpga_buf_idx = -1;
+			channel->wr_empty = 1;
+			channel->wr_ready = 0;
+			channel->wr_sleepy = 1;
+			channel->wr_eof = -1;
+			channel->wr_hangup = 0;
+
+			spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				  (4 << 24) |  /* Opcode 4, open channel */
+				  ((channel->wr_synchronous & 1) << 23),
+				  channel->endpoint->registers +
+				  fpga_buf_ctrl_reg);
+		}
+
+		channel->wr_ref_count++;
+	}
+
+	if (filp->f_mode & FMODE_WRITE) {
+		if (channel->rd_ref_count == 0) { /* First open of file */
+			/* Move the host to first buffer */
+			spin_lock_irqsave(&channel->rd_spinlock, flags);
+			channel->rd_host_buf_idx = 0;
+			channel->rd_host_buf_pos = 0;
+			channel->rd_leftovers[3] = 0; /* No leftovers. */
+			channel->rd_fpga_buf_idx = channel->num_rd_buffers - 1;
+			channel->rd_full = 0;
+
+			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+
+			iowrite32((channel->chan_num << 1) |
+				  (4 << 24),   /* Opcode 4, open channel */
+				  channel->endpoint->registers +
+				  fpga_buf_ctrl_reg);
+		}
+
+		channel->rd_ref_count++;
+	}
+
+unlock:
+	if (filp->f_mode & FMODE_WRITE)
+		mutex_unlock(&channel->rd_mutex);
+unlock_wr:
+	if (filp->f_mode & FMODE_READ)
+		mutex_unlock(&channel->wr_mutex);
+
+	if (!rc && (!channel->seekable))
+		return nonseekable_open(inode, filp);
+
+	return rc;
+}
+
+static int xillybus_release(struct inode *inode, struct file *filp)
+{
+	int rc;
+	unsigned long flags;
+	struct xilly_channel *channel = filp->private_data;
+
+	int buf_idx;
+	int eof;
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	if (filp->f_mode & FMODE_WRITE) {
+		rc = mutex_lock_interruptible(&channel->rd_mutex);
+
+		if (rc) {
+			dev_warn(channel->endpoint->dev,
+				 "Failed to close file. Hardware left in messy state.\n");
+			return rc;
+		}
+
+		channel->rd_ref_count--;
+
+		if (channel->rd_ref_count == 0) {
+
+			/*
+			 * We rely on the kernel calling flush()
+			 * before we get here.
+			 */
+
+			iowrite32((channel->chan_num << 1) | /* Channel ID */
+				  (5 << 24),  /* Opcode 5, close channel */
+				  channel->endpoint->registers +
+				  fpga_buf_ctrl_reg);
+		}
+		mutex_unlock(&channel->rd_mutex);
+	}
+
+	if (filp->f_mode & FMODE_READ) {
+		rc = mutex_lock_interruptible(&channel->wr_mutex);
+		if (rc) {
+			dev_warn(channel->endpoint->dev,
+				 "Failed to close file. Hardware left in messy state.\n");
+			return rc;
+		}
+
+		channel->wr_ref_count--;
+
+		if (channel->wr_ref_count == 0) {
+
+			iowrite32(1 | (channel->chan_num << 1) |
+				   (5 << 24),  /* Opcode 5, close channel */
+				   channel->endpoint->registers +
+				   fpga_buf_ctrl_reg);
+
+			/*
+			 * This is crazily cautious: We make sure that not
+			 * only that we got an EOF (be it because we closed
+			 * the channel or because of a user's EOF), but verify
+			 * that it's one beyond the last buffer arrived, so
+			 * we have no leftover buffers pending before wrapping
+			 * up (which can only happen in asynchronous channels,
+			 * BTW)
+			 */
+
+			while (1) {
+				spin_lock_irqsave(&channel->wr_spinlock,
+						  flags);
+				buf_idx = channel->wr_fpga_buf_idx;
+				eof = channel->wr_eof;
+				channel->wr_sleepy = 1;
+				spin_unlock_irqrestore(&channel->wr_spinlock,
+						       flags);
+
+				/*
+				 * Check if eof points at the buffer after
+				 * the last one the FPGA submitted. Note that
+				 * no EOF is marked by negative eof.
+				 */
+
+				buf_idx++;
+				if (buf_idx == channel->num_wr_buffers)
+					buf_idx = 0;
+
+				if (buf_idx == eof)
+					break;
+
+				/*
+				 * Steal extra 100 ms if awaken by interrupt.
+				 * This is a simple workaround for an
+				 * interrupt pending when entering, which would
+				 * otherwise result in declaring the hardware
+				 * non-responsive.
+				 */
+
+				if (wait_event_interruptible(
+					    channel->wr_wait,
+					    (!channel->wr_sleepy)))
+					msleep(100);
+
+				if (channel->wr_sleepy) {
+					mutex_unlock(&channel->wr_mutex);
+					dev_warn(channel->endpoint->dev,
+						 "Hardware failed to respond to close command, therefore left in messy state.\n");
+					return -EINTR;
+				}
+			}
+		}
+
+		mutex_unlock(&channel->wr_mutex);
+	}
+
+	return 0;
+}
+static loff_t xillybus_llseek(struct file *filp, loff_t offset, int whence)
+{
+	struct xilly_channel *channel = filp->private_data;
+	loff_t pos = filp->f_pos;
+	int rc = 0;
+
+	/*
+	 * Take both mutexes not allowing interrupts, since it seems like
+	 * common applications don't expect an -EINTR here. Besides, multiple
+	 * access to a single file descriptor on seekable devices is a mess
+	 * anyhow.
+	 */
+
+	if (channel->endpoint->fatal_error)
+		return -EIO;
+
+	mutex_lock(&channel->wr_mutex);
+	mutex_lock(&channel->rd_mutex);
+
+	switch (whence) {
+	case 0:
+		pos = offset;
+		break;
+	case 1:
+		pos += offset;
+		break;
+	case 2:
+		pos = offset; /* Going to the end => to the beginning */
+		break;
+	default:
+		rc = -EINVAL;
+		goto end;
+	}
+
+	/* In any case, we must finish on an element boundary */
+	if (pos & ((1 << channel->log2_element_size) - 1)) {
+		rc = -EINVAL;
+		goto end;
+	}
+
+	mutex_lock(&channel->endpoint->register_mutex);
+
+	iowrite32(pos >> channel->log2_element_size,
+		  channel->endpoint->registers + fpga_buf_offset_reg);
+
+	iowrite32((channel->chan_num << 1) |
+		  (6 << 24),  /* Opcode 6, set address */
+		  channel->endpoint->registers + fpga_buf_ctrl_reg);
+
+	mutex_unlock(&channel->endpoint->register_mutex);
+
+end:
+	mutex_unlock(&channel->rd_mutex);
+	mutex_unlock(&channel->wr_mutex);
+
+	if (rc) /* Return error after releasing mutexes */
+		return rc;
+
+	filp->f_pos = pos;
+
+	/*
+	 * Since seekable devices are allowed only when the channel is
+	 * synchronous, we assume that there is no data pending in either
+	 * direction (which holds true as long as no concurrent access on the
+	 * file descriptor takes place).
+	 * The only thing we may need to throw away is leftovers from partial
+	 * write() flush.
+	 */
+
+	channel->rd_leftovers[3] = 0;
+
+	return pos;
+}
+
+static unsigned int xillybus_poll(struct file *filp, poll_table *wait)
+{
+	struct xilly_channel *channel = filp->private_data;
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(filp, &channel->endpoint->ep_wait, wait);
+
+	/*
+	 * poll() won't play ball regarding read() channels which
+	 * aren't asynchronous and support the nonempty message. Allowing
+	 * that will create situations where data has been delivered at
+	 * the FPGA, and users expecting select() to wake up, which it may
+	 * not.
+	 */
+
+	if (!channel->wr_synchronous && channel->wr_supports_nonempty) {
+		poll_wait(filp, &channel->wr_wait, wait);
+		poll_wait(filp, &channel->wr_ready_wait, wait);
+
+		spin_lock_irqsave(&channel->wr_spinlock, flags);
+		if (!channel->wr_empty || channel->wr_ready)
+			mask |= POLLIN | POLLRDNORM;
+
+		if (channel->wr_hangup)
+			/*
+			 * Not POLLHUP, because its behavior is in the
+			 * mist, and POLLIN does what we want: Wake up
+			 * the read file descriptor so it sees EOF.
+			 */
+			mask |=  POLLIN | POLLRDNORM;
+		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
+	}
+
+	/*
+	 * If partial data write is disallowed on a write() channel,
+	 * it's pointless to ever signal OK to write, because is could
+	 * block despite some space being available.
+	 */
+
+	if (channel->rd_allow_partial) {
+		poll_wait(filp, &channel->rd_wait, wait);
+
+		spin_lock_irqsave(&channel->rd_spinlock, flags);
+		if (!channel->rd_full)
+			mask |= POLLOUT | POLLWRNORM;
+		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
+	}
+
+	if (channel->endpoint->fatal_error)
+		mask |= POLLERR;
+
+	return mask;
+}
+
+static const struct file_operations xillybus_fops = {
+	.owner      = THIS_MODULE,
+	.read       = xillybus_read,
+	.write      = xillybus_write,
+	.open       = xillybus_open,
+	.flush      = xillybus_flush,
+	.release    = xillybus_release,
+	.llseek     = xillybus_llseek,
+	.poll       = xillybus_poll,
+};
+
+static int xillybus_init_chrdev(struct xilly_endpoint *endpoint,
+				const unsigned char *idt)
+{
+	int rc;
+	dev_t dev;
+	int devnum, i, minor, major;
+	char devname[48];
+	struct device *device;
+
+	rc = alloc_chrdev_region(&dev, 0, /* minor start */
+				 endpoint->num_channels,
+				 xillyname);
+
+	if (rc) {
+		dev_warn(endpoint->dev, "Failed to obtain major/minors");
+		goto error1;
+	}
+
+	endpoint->major = major = MAJOR(dev);
+	endpoint->lowest_minor = minor = MINOR(dev);
+
+	cdev_init(&endpoint->cdev, &xillybus_fops);
+	endpoint->cdev.owner = endpoint->ephw->owner;
+	rc = cdev_add(&endpoint->cdev, MKDEV(major, minor),
+		      endpoint->num_channels);
+	if (rc) {
+		dev_warn(endpoint->dev, "Failed to add cdev. Aborting.\n");
+		goto error2;
+	}
+
+	idt++;
+
+	for (i = minor, devnum = 0;
+	     devnum < endpoint->num_channels;
+	     devnum++, i++) {
+		snprintf(devname, sizeof(devname)-1, "xillybus_%s", idt);
+
+		devname[sizeof(devname)-1] = 0; /* Should never matter */
+
+		while (*idt++)
+			/* Skip to next */;
+
+		device = device_create(xillybus_class,
+				       NULL,
+				       MKDEV(major, i),
+				       NULL,
+				       "%s", devname);
+
+		if (IS_ERR(device)) {
+			dev_warn(endpoint->dev,
+				 "Failed to create %s device. Aborting.\n",
+				 devname);
+			goto error3;
+		}
+	}
+
+	dev_info(endpoint->dev, "Created %d device files.\n",
+		 endpoint->num_channels);
+	return 0; /* succeed */
+
+error3:
+	devnum--; i--;
+	for (; devnum >= 0; devnum--, i--)
+		device_destroy(xillybus_class, MKDEV(major, i));
+
+	cdev_del(&endpoint->cdev);
+error2:
+	unregister_chrdev_region(MKDEV(major, minor), endpoint->num_channels);
+error1:
+
+	return rc;
+}
+
+static void xillybus_cleanup_chrdev(struct xilly_endpoint *endpoint)
+{
+	int minor;
+
+	for (minor = endpoint->lowest_minor;
+	     minor < (endpoint->lowest_minor + endpoint->num_channels);
+	     minor++)
+		device_destroy(xillybus_class, MKDEV(endpoint->major, minor));
+	cdev_del(&endpoint->cdev);
+	unregister_chrdev_region(MKDEV(endpoint->major,
+				       endpoint->lowest_minor),
+				 endpoint->num_channels);
+
+	dev_info(endpoint->dev, "Removed %d device files.\n",
+		 endpoint->num_channels);
+}
+
+
+struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
+					      struct device *dev,
+					      struct xilly_endpoint_hardware
+					      *ephw)
+{
+	struct xilly_endpoint *endpoint;
+
+	endpoint = devm_kzalloc(dev, sizeof(*endpoint), GFP_KERNEL);
+	if (!endpoint)
+		return NULL;
+
+	endpoint->pdev = pdev;
+	endpoint->dev = dev;
+	endpoint->ephw = ephw;
+	endpoint->msg_counter = 0x0b;
+	endpoint->failed_messages = 0;
+	endpoint->fatal_error = 0;
+
+	init_waitqueue_head(&endpoint->ep_wait);
+	mutex_init(&endpoint->register_mutex);
+
+	return endpoint;
+}
+EXPORT_SYMBOL(xillybus_init_endpoint);
+
+static int xilly_quiesce(struct xilly_endpoint *endpoint)
+{
+	endpoint->idtlen = -1;
+
+	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
+		  endpoint->registers + fpga_dma_control_reg);
+
+	wait_event_interruptible_timeout(endpoint->ep_wait,
+					 (endpoint->idtlen >= 0),
+					 XILLY_TIMEOUT);
+
+	if (endpoint->idtlen < 0) {
+		dev_err(endpoint->dev,
+			"Failed to quiesce the device on exit.\n");
+		return -ENODEV;
+	}
+	return 0; /* Success */
+}
+
+int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
+{
+	int rc = 0;
+
+	void *bootstrap_resources;
+	int idtbuffersize = (1 << PAGE_SHIFT);
+	struct device *dev = endpoint->dev;
+
+	/*
+	 * The bogus IDT is used during bootstrap for allocating the initial
+	 * message buffer, and then the message buffer and space for the IDT
+	 * itself. The initial message buffer is of a single page's size, but
+	 * it's soon replaced with a more modest one (and memory is freed).
+	 */
+
+	unsigned char bogus_idt[8] = { 1, 224, (PAGE_SHIFT)-2, 0,
+				       3, 192, PAGE_SHIFT, 0 };
+	struct xilly_idt_handle idt_handle;
+
+	/*
+	 * Writing the value 0x00000001 to Endianness register signals which
+	 * endianness this processor is using, so the FPGA can swap words as
+	 * necessary.
+	 */
+
+	iowrite32(1, endpoint->registers + fpga_endian_reg);
+
+	/* Bootstrap phase I: Allocate temporary message buffer */
+
+	bootstrap_resources = devres_open_group(dev, NULL, GFP_KERNEL);
+	if (!bootstrap_resources)
+		return -ENOMEM;
+
+	endpoint->num_channels = 0;
+
+	rc = xilly_setupchannels(endpoint, bogus_idt, 1);
+
+	if (rc)
+		return rc;
+
+	/* Clear the message subsystem (and counter in particular) */
+	iowrite32(0x04, endpoint->registers + fpga_msg_ctrl_reg);
+
+	endpoint->idtlen = -1;
+
+	/*
+	 * Set DMA 32/64 bit mode, quiesce the device (?!) and get IDT
+	 * buffer size.
+	 */
+	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
+		   endpoint->registers + fpga_dma_control_reg);
+
+	wait_event_interruptible_timeout(endpoint->ep_wait,
+					 (endpoint->idtlen >= 0),
+					 XILLY_TIMEOUT);
+
+	if (endpoint->idtlen < 0) {
+		dev_err(endpoint->dev, "No response from FPGA. Aborting.\n");
+		return -ENODEV;
+	}
+
+	/* Enable DMA */
+	iowrite32((u32) (0x0002 | (endpoint->dma_using_dac & 0x0001)),
+		   endpoint->registers + fpga_dma_control_reg);
+
+	/* Bootstrap phase II: Allocate buffer for IDT and obtain it */
+	while (endpoint->idtlen >= idtbuffersize) {
+		idtbuffersize *= 2;
+		bogus_idt[6]++;
+	}
+
+	endpoint->num_channels = 1;
+
+	rc = xilly_setupchannels(endpoint, bogus_idt, 2);
+
+	if (rc)
+		goto failed_idt;
+
+	rc = xilly_obtain_idt(endpoint);
+
+	if (rc)
+		goto failed_idt;
+
+	xilly_scan_idt(endpoint, &idt_handle);
+
+	if (!idt_handle.chandesc) {
+		rc = -ENODEV;
+		goto failed_idt;
+	}
+
+	devres_close_group(dev, bootstrap_resources);
+
+	/* Bootstrap phase III: Allocate buffers according to IDT */
+
+	rc = xilly_setupchannels(endpoint,
+				 idt_handle.chandesc,
+				 idt_handle.entries);
+
+	if (rc)
+		goto failed_idt;
+
+	/*
+	 * endpoint is now completely configured. We put it on the list
+	 * available to open() before registering the char device(s)
+	 */
+
+	mutex_lock(&ep_list_lock);
+	list_add_tail(&endpoint->ep_list, &list_of_endpoints);
+	mutex_unlock(&ep_list_lock);
+
+	rc = xillybus_init_chrdev(endpoint, idt_handle.idt);
+
+	if (rc)
+		goto failed_chrdevs;
+
+	devres_release_group(dev, bootstrap_resources);
+
+	return 0;
+
+failed_chrdevs:
+	mutex_lock(&ep_list_lock);
+	list_del(&endpoint->ep_list);
+	mutex_unlock(&ep_list_lock);
+
+failed_idt:
+	xilly_quiesce(endpoint);
+	flush_workqueue(xillybus_wq);
+
+	return rc;
+}
+EXPORT_SYMBOL(xillybus_endpoint_discovery);
+
+void xillybus_endpoint_remove(struct xilly_endpoint *endpoint)
+{
+	xillybus_cleanup_chrdev(endpoint);
+
+	mutex_lock(&ep_list_lock);
+	list_del(&endpoint->ep_list);
+	mutex_unlock(&ep_list_lock);
+
+	xilly_quiesce(endpoint);
+
+	/*
+	 * Flushing is done upon endpoint release to prevent access to memory
+	 * just about to be released. This makes the quiesce complete.
+	 */
+	flush_workqueue(xillybus_wq);
+}
+EXPORT_SYMBOL(xillybus_endpoint_remove);
+
+static int __init xillybus_init(void)
+{
+	int rc = 0;
+
+	mutex_init(&ep_list_lock);
+
+	xillybus_class = class_create(THIS_MODULE, xillyname);
+	if (IS_ERR(xillybus_class)) {
+		rc = PTR_ERR(xillybus_class);
+		pr_warn("Failed to register class xillybus\n");
+
+		return rc;
+	}
+
+	xillybus_wq = alloc_workqueue(xillyname, 0, 0);
+	if (!xillybus_wq) {
+		class_destroy(xillybus_class);
+		rc = -ENOMEM;
+	}
+
+	return rc;
+}
+
+static void __exit xillybus_exit(void)
+{
+	/* flush_workqueue() was called for each endpoint released */
+	destroy_workqueue(xillybus_wq);
+
+	class_destroy(xillybus_class);
+}
+
+module_init(xillybus_init);
+module_exit(xillybus_exit);
diff --git a/drivers/char/xillybus/xillybus_of.c b/drivers/char/xillybus/xillybus_of.c
new file mode 100644
index 0000000..e0ae234
--- /dev/null
+++ b/drivers/char/xillybus/xillybus_of.c
@@ -0,0 +1,186 @@
+/*
+ * linux/drivers/misc/xillybus_of.c
+ *
+ * Copyright 2011 Xillybus Ltd, http://xillybus.com
+ *
+ * Driver for the Xillybus FPGA/host framework using Open Firmware.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_address.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/err.h>
+#include "xillybus.h"
+
+MODULE_DESCRIPTION("Xillybus driver for Open Firmware");
+MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
+MODULE_VERSION("1.06");
+MODULE_ALIAS("xillybus_of");
+MODULE_LICENSE("GPL v2");
+
+static const char xillyname[] = "xillybus_of";
+
+/* Match table for of_platform binding */
+static struct of_device_id xillybus_of_match[] = {
+	{ .compatible = "xillybus,xillybus-1.00.a", },
+	{ .compatible = "xlnx,xillybus-1.00.a", }, /* Deprecated */
+	{}
+};
+
+MODULE_DEVICE_TABLE(of, xillybus_of_match);
+
+static void xilly_dma_sync_single_for_cpu_of(struct xilly_endpoint *ep,
+					     dma_addr_t dma_handle,
+					     size_t size,
+					     int direction)
+{
+	dma_sync_single_for_cpu(ep->dev, dma_handle, size, direction);
+}
+
+static void xilly_dma_sync_single_for_device_of(struct xilly_endpoint *ep,
+						dma_addr_t dma_handle,
+						size_t size,
+						int direction)
+{
+	dma_sync_single_for_device(ep->dev, dma_handle, size, direction);
+}
+
+static void xilly_dma_sync_single_nop(struct xilly_endpoint *ep,
+				      dma_addr_t dma_handle,
+				      size_t size,
+				      int direction)
+{
+}
+
+static void xilly_of_unmap(void *ptr)
+{
+	struct xilly_mapping *data = ptr;
+
+	dma_unmap_single(data->device, data->dma_addr,
+			 data->size, data->direction);
+
+	kfree(ptr);
+}
+
+static int xilly_map_single_of(struct xilly_endpoint *ep,
+			       void *ptr,
+			       size_t size,
+			       int direction,
+			       dma_addr_t *ret_dma_handle
+	)
+{
+	dma_addr_t addr;
+	struct xilly_mapping *this;
+	int rc;
+
+	this = kzalloc(sizeof(*this), GFP_KERNEL);
+	if (!this)
+		return -ENOMEM;
+
+	addr = dma_map_single(ep->dev, ptr, size, direction);
+
+	if (dma_mapping_error(ep->dev, addr)) {
+		kfree(this);
+		return -ENODEV;
+	}
+
+	this->device = ep->dev;
+	this->dma_addr = addr;
+	this->size = size;
+	this->direction = direction;
+
+	*ret_dma_handle = addr;
+
+	rc = devm_add_action(ep->dev, xilly_of_unmap, this);
+
+	if (rc) {
+		dma_unmap_single(ep->dev, addr, size, direction);
+		kfree(this);
+	}
+
+	return rc;
+}
+
+static struct xilly_endpoint_hardware of_hw = {
+	.owner = THIS_MODULE,
+	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_of,
+	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_of,
+	.map_single = xilly_map_single_of,
+};
+
+static struct xilly_endpoint_hardware of_hw_coherent = {
+	.owner = THIS_MODULE,
+	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_nop,
+	.hw_sync_sgl_for_device = xilly_dma_sync_single_nop,
+	.map_single = xilly_map_single_of,
+};
+
+static int xilly_drv_probe(struct platform_device *op)
+{
+	struct device *dev = &op->dev;
+	struct xilly_endpoint *endpoint;
+	int rc = 0;
+	int irq;
+	struct resource res;
+	struct xilly_endpoint_hardware *ephw = &of_hw;
+
+	if (of_property_read_bool(dev->of_node, "dma-coherent"))
+		ephw = &of_hw_coherent;
+
+	endpoint = xillybus_init_endpoint(NULL, dev, ephw);
+
+	if (!endpoint)
+		return -ENOMEM;
+
+	dev_set_drvdata(dev, endpoint);
+
+	rc = of_address_to_resource(dev->of_node, 0, &res);
+	endpoint->registers = devm_ioremap_resource(dev, &res);
+
+	if (IS_ERR(endpoint->registers))
+		return PTR_ERR(endpoint->registers);
+
+	irq = irq_of_parse_and_map(dev->of_node, 0);
+
+	rc = devm_request_irq(dev, irq, xillybus_isr, 0, xillyname, endpoint);
+
+	if (rc) {
+		dev_err(endpoint->dev,
+			"Failed to register IRQ handler. Aborting.\n");
+		return -ENODEV;
+	}
+
+	return xillybus_endpoint_discovery(endpoint);
+}
+
+static int xilly_drv_remove(struct platform_device *op)
+{
+	struct device *dev = &op->dev;
+	struct xilly_endpoint *endpoint = dev_get_drvdata(dev);
+
+	xillybus_endpoint_remove(endpoint);
+
+	return 0;
+}
+
+static struct platform_driver xillybus_platform_driver = {
+	.probe = xilly_drv_probe,
+	.remove = xilly_drv_remove,
+	.driver = {
+		.name = xillyname,
+		.owner = THIS_MODULE,
+		.of_match_table = xillybus_of_match,
+	},
+};
+
+module_platform_driver(xillybus_platform_driver);
diff --git a/drivers/char/xillybus/xillybus_pcie.c b/drivers/char/xillybus/xillybus_pcie.c
new file mode 100644
index 0000000..96c2c9f
--- /dev/null
+++ b/drivers/char/xillybus/xillybus_pcie.c
@@ -0,0 +1,230 @@
+/*
+ * linux/drivers/misc/xillybus_pcie.c
+ *
+ * Copyright 2011 Xillybus Ltd, http://xillybus.com
+ *
+ * Driver for the Xillybus FPGA/host framework using PCI Express.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the smems of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci-aspm.h>
+#include <linux/slab.h>
+#include "xillybus.h"
+
+MODULE_DESCRIPTION("Xillybus driver for PCIe");
+MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
+MODULE_VERSION("1.06");
+MODULE_ALIAS("xillybus_pcie");
+MODULE_LICENSE("GPL v2");
+
+#define PCI_DEVICE_ID_XILLYBUS		0xebeb
+
+#define PCI_VENDOR_ID_ALTERA		0x1172
+#define PCI_VENDOR_ID_ACTEL		0x11aa
+#define PCI_VENDOR_ID_LATTICE		0x1204
+
+static const char xillyname[] = "xillybus_pcie";
+
+static const struct pci_device_id xillyids[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ALTERA, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_ACTEL, PCI_DEVICE_ID_XILLYBUS)},
+	{PCI_DEVICE(PCI_VENDOR_ID_LATTICE, PCI_DEVICE_ID_XILLYBUS)},
+	{ /* End: all zeroes */ }
+};
+
+static int xilly_pci_direction(int direction)
+{
+	switch (direction) {
+	case DMA_TO_DEVICE:
+		return PCI_DMA_TODEVICE;
+	case DMA_FROM_DEVICE:
+		return PCI_DMA_FROMDEVICE;
+	default:
+		return PCI_DMA_BIDIRECTIONAL;
+	}
+}
+
+static void xilly_dma_sync_single_for_cpu_pci(struct xilly_endpoint *ep,
+					      dma_addr_t dma_handle,
+					      size_t size,
+					      int direction)
+{
+	pci_dma_sync_single_for_cpu(ep->pdev,
+				    dma_handle,
+				    size,
+				    xilly_pci_direction(direction));
+}
+
+static void xilly_dma_sync_single_for_device_pci(struct xilly_endpoint *ep,
+						 dma_addr_t dma_handle,
+						 size_t size,
+						 int direction)
+{
+	pci_dma_sync_single_for_device(ep->pdev,
+				       dma_handle,
+				       size,
+				       xilly_pci_direction(direction));
+}
+
+static void xilly_pci_unmap(void *ptr)
+{
+	struct xilly_mapping *data = ptr;
+
+	pci_unmap_single(data->device, data->dma_addr,
+			 data->size, data->direction);
+
+	kfree(ptr);
+}
+
+/*
+ * Map either through the PCI DMA mapper or the non_PCI one. Behind the
+ * scenes exactly the same functions are called with the same parameters,
+ * but that can change.
+ */
+
+static int xilly_map_single_pci(struct xilly_endpoint *ep,
+				void *ptr,
+				size_t size,
+				int direction,
+				dma_addr_t *ret_dma_handle
+	)
+{
+	int pci_direction;
+	dma_addr_t addr;
+	struct xilly_mapping *this;
+	int rc = 0;
+
+	this = kzalloc(sizeof(*this), GFP_KERNEL);
+	if (!this)
+		return -ENOMEM;
+
+	pci_direction = xilly_pci_direction(direction);
+
+	addr = pci_map_single(ep->pdev, ptr, size, pci_direction);
+
+	if (pci_dma_mapping_error(ep->pdev, addr)) {
+		kfree(this);
+		return -ENODEV;
+	}
+
+	this->device = ep->pdev;
+	this->dma_addr = addr;
+	this->size = size;
+	this->direction = pci_direction;
+
+	*ret_dma_handle = addr;
+
+	rc = devm_add_action(ep->dev, xilly_pci_unmap, this);
+
+	if (rc) {
+		pci_unmap_single(ep->pdev, addr, size, pci_direction);
+		kfree(this);
+	}
+
+	return rc;
+}
+
+static struct xilly_endpoint_hardware pci_hw = {
+	.owner = THIS_MODULE,
+	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_pci,
+	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_pci,
+	.map_single = xilly_map_single_pci,
+};
+
+static int xilly_probe(struct pci_dev *pdev,
+				 const struct pci_device_id *ent)
+{
+	struct xilly_endpoint *endpoint;
+	int rc = 0;
+
+	endpoint = xillybus_init_endpoint(pdev, &pdev->dev, &pci_hw);
+
+	if (!endpoint)
+		return -ENOMEM;
+
+	pci_set_drvdata(pdev, endpoint);
+
+	rc = pcim_enable_device(pdev);
+
+	if (rc) {
+		dev_err(endpoint->dev,
+			"pcim_enable_device() failed. Aborting.\n");
+		return rc;
+	}
+
+	/* L0s has caused packet drops. No power saving, thank you. */
+
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
+	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
+		dev_err(endpoint->dev,
+			"Incorrect BAR configuration. Aborting.\n");
+		return -ENODEV;
+	}
+
+	rc = pcim_iomap_regions(pdev, 0x01, xillyname);
+	if (rc) {
+		dev_err(endpoint->dev,
+			"pcim_iomap_regions() failed. Aborting.\n");
+		return rc;
+	}
+
+	endpoint->registers = pcim_iomap_table(pdev)[0];
+
+	pci_set_master(pdev);
+
+	/* Set up a single MSI interrupt */
+	if (pci_enable_msi(pdev)) {
+		dev_err(endpoint->dev,
+			"Failed to enable MSI interrupts. Aborting.\n");
+		return -ENODEV;
+	}
+	rc = devm_request_irq(&pdev->dev, pdev->irq, xillybus_isr, 0,
+			      xillyname, endpoint);
+
+	if (rc) {
+		dev_err(endpoint->dev,
+			"Failed to register MSI handler. Aborting.\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * In theory, an attempt to set the DMA mask to 64 and dma_using_dac=1
+	 * is the right thing. But some unclever PCIe drivers report it's OK
+	 * when the hardware drops those 64-bit PCIe packets. So trust
+	 * nobody and use 32 bits DMA addressing in any case.
+	 */
+
+	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
+		endpoint->dma_using_dac = 0;
+	else {
+		dev_err(endpoint->dev, "Failed to set DMA mask. Aborting.\n");
+		return -ENODEV;
+	}
+
+	return xillybus_endpoint_discovery(endpoint);
+}
+
+static void xilly_remove(struct pci_dev *pdev)
+{
+	struct xilly_endpoint *endpoint = pci_get_drvdata(pdev);
+
+	xillybus_endpoint_remove(endpoint);
+}
+
+MODULE_DEVICE_TABLE(pci, xillyids);
+
+static struct pci_driver xillybus_driver = {
+	.name = xillyname,
+	.id_table = xillyids,
+	.probe = xilly_probe,
+	.remove = xilly_remove,
+};
+
+module_pci_driver(xillybus_driver);
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 7b50a90..ec5e312 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -106,8 +106,6 @@ source "drivers/staging/mt29f_spinand/Kconfig"
 
 source "drivers/staging/lustre/Kconfig"
 
-source "drivers/staging/xillybus/Kconfig"
-
 source "drivers/staging/dgnc/Kconfig"
 
 source "drivers/staging/dgap/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 4addf0b..06380d7 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_DRM_IMX)		+= imx-drm/
 obj-$(CONFIG_FIREWIRE_SERIAL)	+= fwserial/
 obj-$(CONFIG_GOLDFISH)		+= goldfish/
 obj-$(CONFIG_LUSTRE_FS)		+= lustre/
-obj-$(CONFIG_XILLYBUS)		+= xillybus/
 obj-$(CONFIG_DGNC)			+= dgnc/
 obj-$(CONFIG_DGAP)			+= dgap/
 obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
diff --git a/drivers/staging/xillybus/Kconfig b/drivers/staging/xillybus/Kconfig
deleted file mode 100644
index b53bdf1..0000000
--- a/drivers/staging/xillybus/Kconfig
+++ /dev/null
@@ -1,33 +0,0 @@
-#
-# Xillybus devices
-#
-
-config XILLYBUS
-	tristate "Xillybus generic FPGA interface"
-	depends on PCI || (OF_ADDRESS && OF_IRQ)
-	select CRC32
-	help
-	  Xillybus is a generic interface for peripherals designed on
-	  programmable logic (FPGA). The driver probes the hardware for
-	  its capabilities, and creates device files accordingly.
-
-	  If unsure, say N.
-
-if XILLYBUS
-
-config XILLYBUS_PCIE
-	tristate "Xillybus over PCIe"
-	depends on PCI_MSI
-	help
-	  Set to M if you want Xillybus to use PCI Express for communicating
-	  with the FPGA.
-
-config XILLYBUS_OF
-	tristate "Xillybus over Device Tree"
-	depends on OF_ADDRESS && OF_IRQ
-	help
-	  Set to M if you want Xillybus to find its resources from the
-	  Open Firmware Flattened Device Tree. If the target is an embedded
-	  system, say M.
-
-endif # if XILLYBUS
diff --git a/drivers/staging/xillybus/Makefile b/drivers/staging/xillybus/Makefile
deleted file mode 100644
index b68b7eb..0000000
--- a/drivers/staging/xillybus/Makefile
+++ /dev/null
@@ -1,7 +0,0 @@
-#
-# Makefile for Xillybus driver
-#
-
-obj-$(CONFIG_XILLYBUS)		+= xillybus_core.o
-obj-$(CONFIG_XILLYBUS_PCIE)	+= xillybus_pcie.o
-obj-$(CONFIG_XILLYBUS_OF)	+= xillybus_of.o
diff --git a/drivers/staging/xillybus/README b/drivers/staging/xillybus/README
deleted file mode 100644
index 81d111b..0000000
--- a/drivers/staging/xillybus/README
+++ /dev/null
@@ -1,380 +0,0 @@
-
-               ==========================================
-               Xillybus driver for generic FPGA interface
-               ==========================================
-
-Author: Eli Billauer, Xillybus Ltd. (http://xillybus.com)
-Email:  eli.billauer@gmail.com or as advertised on Xillybus' site.
-
-Contents:
-
- - Introduction
-  -- Background
-  -- Xillybus Overview
-
- - Usage
-  -- User interface
-  -- Synchronization
-  -- Seekable pipes
-
-- Internals
-  -- Source code organization
-  -- Pipe attributes
-  -- Host never reads from the FPGA
-  -- Channels, pipes, and the message channel
-  -- Data streaming
-  -- Data granularity
-  -- Probing
-  -- Buffer allocation
-  -- The "nonempty" message (supporting poll)
-
-
-INTRODUCTION
-============
-
-Background
-----------
-
-An FPGA (Field Programmable Gate Array) is a piece of logic hardware, which
-can be programmed to become virtually anything that is usually found as a
-dedicated chipset: For instance, a display adapter, network interface card,
-or even a processor with its peripherals. FPGAs are the LEGO of hardware:
-Based upon certain building blocks, you make your own toys the way you like
-them. It's usually pointless to reimplement something that is already
-available on the market as a chipset, so FPGAs are mostly used when some
-special functionality is needed, and the production volume is relatively low
-(hence not justifying the development of an ASIC).
-
-The challenge with FPGAs is that everything is implemented at a very low
-level, even lower than assembly language. In order to allow FPGA designers to
-focus on their specific project, and not reinvent the wheel over and over
-again, pre-designed building blocks, IP cores, are often used. These are the
-FPGA parallels of library functions. IP cores may implement certain
-mathematical functions, a functional unit (e.g. a USB interface), an entire
-processor (e.g. ARM) or anything that might come handy. Think of them as a
-building block, with electrical wires dangling on the sides for connection to
-other blocks.
-
-One of the daunting tasks in FPGA design is communicating with a fullblown
-operating system (actually, with the processor running it): Implementing the
-low-level bus protocol and the somewhat higher-level interface with the host
-(registers, interrupts, DMA etc.) is a project in itself. When the FPGA's
-function is a well-known one (e.g. a video adapter card, or a NIC), it can
-make sense to design the FPGA's interface logic specifically for the project.
-A special driver is then written to present the FPGA as a well-known interface
-to the kernel and/or user space. In that case, there is no reason to treat the
-FPGA differently than any device on the bus.
-
-It's however common that the desired data communication doesn't fit any well-
-known peripheral function. Also, the effort of designing an elegant
-abstraction for the data exchange is often considered too big. In those cases,
-a quicker and possibly less elegant solution is sought: The driver is
-effectively written as a user space program, leaving the kernel space part
-with just elementary data transport. This still requires designing some
-interface logic for the FPGA, and write a simple ad-hoc driver for the kernel.
-
-Xillybus Overview
------------------
-
-Xillybus is an IP core and a Linux driver. Together, they form a kit for
-elementary data transport between an FPGA and the host, providing pipe-like
-data streams with a straightforward user interface. It's intended as a low-
-effort solution for mixed FPGA-host projects, for which it makes sense to
-have the project-specific part of the driver running in a user-space program.
-
-Since the communication requirements may vary significantly from one FPGA
-project to another (the number of data pipes needed in each direction and
-their attributes), there isn't one specific chunk of logic being the Xillybus
-IP core. Rather, the IP core is configured and built based upon a
-specification given by its end user.
-
-Xillybus presents independent data streams, which resemble pipes or TCP/IP
-communication to the user. At the host side, a character device file is used
-just like any pipe file. On the FPGA side, hardware FIFOs are used to stream
-the data. This is contrary to a common method of communicating through fixed-
-sized buffers (even though such buffers are used by Xillybus under the hood).
-There may be more than a hundred of these streams on a single IP core, but
-also no more than one, depending on the configuration.
-
-In order to ease the deployment of the Xillybus IP core, it contains a simple
-data structure which completely defines the core's configuration. The Linux
-driver fetches this data structure during its initialization process, and sets
-up the DMA buffers and character devices accordingly. As a result, a single
-driver is used to work out of the box with any Xillybus IP core.
-
-The data structure just mentioned should not be confused with PCI's
-configuration space or the Flattened Device Tree.
-
-USAGE
-=====
-
-User interface
---------------
-
-On the host, all interface with Xillybus is done through /dev/xillybus_*
-device files, which are generated automatically as the drivers loads. The
-names of these files depend on the IP core that is loaded in the FPGA (see
-Probing below). To communicate with the FPGA, open the device file that
-corresponds to the hardware FIFO you want to send data or receive data from,
-and use plain write() or read() calls, just like with a regular pipe. In
-particular, it makes perfect sense to go:
-
-$ cat mydata > /dev/xillybus_thisfifo
-
-$ cat /dev/xillybus_thatfifo > hisdata
-
-possibly pressing CTRL-C as some stage, even though the xillybus_* pipes have
-the capability to send an EOF (but may not use it).
-
-The driver and hardware are designed to behave sensibly as pipes, including:
-
-* Supporting non-blocking I/O (by setting O_NONBLOCK on open() ).
-
-* Supporting poll() and select().
-
-* Being bandwidth efficient under load (using DMA) but also handle small
-  pieces of data sent across (like TCP/IP) by autoflushing.
-
-A device file can be read only, write only or bidirectional. Bidirectional
-device files are treated like two independent pipes (except for sharing a
-"channel" structure in the implementation code).
-
-Synchronization
----------------
-
-Xillybus pipes are configured (on the IP core) to be either synchronous or
-asynchronous. For a synchronous pipe, write() returns successfully only after
-some data has been submitted and acknowledged by the FPGA. This slows down
-bulk data transfers, and is nearly impossible for use with streams that
-require data at a constant rate: There is no data transmitted to the FPGA
-between write() calls, in particular when the process loses the CPU.
-
-When a pipe is configured asynchronous, write() returns if there was enough
-room in the buffers to store any of the data in the buffers.
-
-For FPGA to host pipes, asynchronous pipes allow data transfer from the FPGA
-as soon as the respective device file is opened, regardless of if the data
-has been requested by a read() call. On synchronous pipes, only the amount
-of data requested by a read() call is transmitted.
-
-In summary, for synchronous pipes, data between the host and FPGA is
-transmitted only to satisfy the read() or write() call currently handled
-by the driver, and those calls wait for the transmission to complete before
-returning.
-
-Note that the synchronization attribute has nothing to do with the possibility
-that read() or write() completes less bytes than requested. There is a
-separate configuration flag ("allowpartial") that determines whether such a
-partial completion is allowed.
-
-Seekable pipes
---------------
-
-A synchronous pipe can be configured to have the stream's position exposed
-to the user logic at the FPGA. Such a pipe is also seekable on the host API.
-With this feature, a memory or register interface can be attached on the
-FPGA side to the seekable stream. Reading or writing to a certain address in
-the attached memory is done by seeking to the desired address, and calling
-read() or write() as required.
-
-
-INTERNALS
-=========
-
-Source code organization
-------------------------
-
-The Xillybus driver consists of a core module, xillybus_core.c, and modules
-that depend on the specific bus interface (xillybus_of.c and xillybus_pcie.c).
-
-The bus specific modules are those probed when a suitable device is found by
-the kernel. Since the DMA mapping and synchronization functions, which are bus
-dependent by their nature, are used by the core module, a
-xilly_endpoint_hardware structure is passed to the core module on
-initialization. This structure is populated with pointers to wrapper functions
-which execute the DMA-related operations on the bus.
-
-Pipe attributes
----------------
-
-Each pipe has a number of attributes which are set when the FPGA component
-(IP core) is built. They are fetched from the IDT (the data structure which
-defines the core's configuration, see Probing below) by xilly_setupchannels()
-in xillybus_core.c as follows:
-
-* is_writebuf: The pipe's direction. A non-zero value means it's an FPGA to
-  host pipe (the FPGA "writes").
-
-* channelnum: The pipe's identification number in communication between the
-  host and FPGA.
-
-* format: The underlying data width. See Data Granularity below.
-
-* allowpartial: A non-zero value means that a read() or write() (whichever
-  applies) may return with less than the requested number of bytes. The common
-  choice is a non-zero value, to match standard UNIX behavior.
-
-* synchronous: A non-zero value means that the pipe is synchronous. See
-  Syncronization above.
-
-* bufsize: Each DMA buffer's size. Always a power of two.
-
-* bufnum: The number of buffers allocated for this pipe. Always a power of two.
-
-* exclusive_open: A non-zero value forces exclusive opening of the associated
-  device file. If the device file is bidirectional, and already opened only in
-  one direction, the opposite direction may be opened once.
-
-* seekable: A non-zero value indicates that the pipe is seekable. See
-  Seekable pipes above.
-
-* supports_nonempty: A non-zero value (which is typical) indicates that the
-  hardware will send the messages that are necessary to support select() and
-  poll() for this pipe.
-
-Host never reads from the FPGA
-------------------------------
-
-Even though PCI Express is hotpluggable in general, a typical motherboard
-doesn't expect a card to go away all of the sudden. But since the PCIe card
-is based upon reprogrammable logic, a sudden disappearance from the bus is
-quite likely as a result of an accidental reprogramming of the FPGA while the
-host is up. In practice, nothing happens immediately in such a situation. But
-if the host attempts to read from an address that is mapped to the PCI Express
-device, that leads to an immediate freeze of the system on some motherboards,
-even though the PCIe standard requires a graceful recovery.
-
-In order to avoid these freezes, the Xillybus driver refrains completely from
-reading from the device's register space. All communication from the FPGA to
-the host is done through DMA. In particular, the Interrupt Service Routine
-doesn't follow the common practice of checking a status register when it's
-invoked. Rather, the FPGA prepares a small buffer which contains short
-messages, which inform the host what the interrupt was about.
-
-This mechanism is used on non-PCIe buses as well for the sake of uniformity.
-
-
-Channels, pipes, and the message channel
-----------------------------------------
-
-Each of the (possibly bidirectional) pipes presented to the user is allocated
-a data channel between the FPGA and the host. The distinction between channels
-and pipes is necessary only because of channel 0, which is used for interrupt-
-related messages from the FPGA, and has no pipe attached to it.
-
-Data streaming
---------------
-
-Even though a non-segmented data stream is presented to the user at both
-sides, the implementation relies on a set of DMA buffers which is allocated
-for each channel. For the sake of illustration, let's take the FPGA to host
-direction: As data streams into the respective channel's interface in the
-FPGA, the Xillybus IP core writes it to one of the DMA buffers. When the
-buffer is full, the FPGA informs the host about that (appending a
-XILLYMSG_OPCODE_RELEASEBUF message channel 0 and sending an interrupt if
-necessary). The host responds by making the data available for reading through
-the character device. When all data has been read, the host writes on the
-the FPGA's buffer control register, allowing the buffer's overwriting. Flow
-control mechanisms exist on both sides to prevent underflows and overflows.
-
-This is not good enough for creating a TCP/IP-like stream: If the data flow
-stops momentarily before a DMA buffer is filled, the intuitive expectation is
-that the partial data in buffer will arrive anyhow, despite the buffer not
-being completed. This is implemented by adding a field in the
-XILLYMSG_OPCODE_RELEASEBUF message, through which the FPGA informs not just
-which buffer is submitted, but how much data it contains.
-
-But the FPGA will submit a partially filled buffer only if directed to do so
-by the host. This situation occurs when the read() method has been blocking
-for XILLY_RX_TIMEOUT jiffies (currently 10 ms), after which the host commands
-the FPGA to submit a DMA buffer as soon as it can. This timeout mechanism
-balances between bus bandwidth efficiency (preventing a lot of partially
-filled buffers being sent) and a latency held fairly low for tails of data.
-
-A similar setting is used in the host to FPGA direction. The handling of
-partial DMA buffers is somewhat different, though. The user can tell the
-driver to submit all data it has in the buffers to the FPGA, by issuing a
-write() with the byte count set to zero. This is similar to a flush request,
-but it doesn't block. There is also an autoflushing mechanism, which triggers
-an equivalent flush roughly XILLY_RX_TIMEOUT jiffies after the last write().
-This allows the user to be oblivious about the underlying buffering mechanism
-and yet enjoy a stream-like interface.
-
-Note that the issue of partial buffer flushing is irrelevant for pipes having
-the "synchronous" attribute nonzero, since synchronous pipes don't allow data
-to lay around in the DMA buffers between read() and write() anyhow.
-
-Data granularity
-----------------
-
-The data arrives or is sent at the FPGA as 8, 16 or 32 bit wide words, as
-configured by the "format" attribute. Whenever possible, the driver attempts
-to hide this when the pipe is accessed differently from its natural alignment.
-For example, reading single bytes from a pipe with 32 bit granularity works
-with no issues. Writing single bytes to pipes with 16 or 32 bit granularity
-will also work, but the driver can't send partially completed words to the
-FPGA, so the transmission of up to one word may be held until it's fully
-occupied with user data.
-
-This somewhat complicates the handling of host to FPGA streams, because
-when a buffer is flushed, it may contain up to 3 bytes don't form a word in
-the FPGA, and hence can't be sent. To prevent loss of data, these leftover
-bytes need to be moved to the next buffer. The parts in xillybus_core.c
-that mention "leftovers" in some way are related to this complication.
-
-Probing
--------
-
-As mentioned earlier, the number of pipes that are created when the driver
-loads and their attributes depend on the Xillybus IP core in the FPGA. During
-the driver's initialization, a blob containing configuration info, the
-Interface Description Table (IDT), is sent from the FPGA to the host. The
-bootstrap process is done in three phases:
-
-1. Acquire the length of the IDT, so a buffer can be allocated for it. This
-   is done by sending a quiesce command to the device, since the acknowledge
-   for this command contains the IDT's buffer length.
-
-2. Acquire the IDT itself.
-
-3. Create the interfaces according to the IDT.
-
-Buffer allocation
------------------
-
-In order to simplify the logic that prevents illegal boundary crossings of
-PCIe packets, the following rule applies: If a buffer is smaller than 4kB,
-it must not cross a 4kB boundary. Otherwise, it must be 4kB aligned. The
-xilly_setupchannels() functions allocates these buffers by requesting whole
-pages from the kernel, and diving them into DMA buffers as necessary. Since
-all buffers' sizes are powers of two, it's possible to pack any set of such
-buffers, with a maximal waste of one page of memory.
-
-All buffers are allocated when the driver is loaded. This is necessary,
-since large continuous physical memory segments are sometimes requested,
-which are more likely to be available when the system is freshly booted.
-
-The allocation of buffer memory takes place in the same order they appear in
-the IDT. The driver relies on a rule that the pipes are sorted with decreasing
-buffer size in the IDT. If a requested buffer is larger or equal to a page,
-the necessary number of pages is requested from the kernel, and these are
-used for this buffer. If the requested buffer is smaller than a page, one
-single page is requested from the kernel, and that page is partially used.
-Or, if there already is a partially used page at hand, the buffer is packed
-into that page. It can be shown that all pages requested from the kernel
-(except possibly for the last) are 100% utilized this way.
-
-The "nonempty" message (supporting poll)
----------------------------------------
-
-In order to support the "poll" method (and hence select() ), there is a small
-catch regarding the FPGA to host direction: The FPGA may have filled a DMA
-buffer with some data, but not submitted that buffer. If the host waited for
-the buffer's submission by the FPGA, there would be a possibility that the
-FPGA side has sent data, but a select() call would still block, because the
-host has not received any notification about this. This is solved with
-XILLYMSG_OPCODE_NONEMPTY messages sent by the FPGA when a channel goes from
-completely empty to containing some data.
-
-These messages are used only to support poll() and select(). The IP core can
-be configured not to send them for a slight reduction of bandwidth.
diff --git a/drivers/staging/xillybus/TODO b/drivers/staging/xillybus/TODO
deleted file mode 100644
index 95cfe2f..0000000
--- a/drivers/staging/xillybus/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-TODO:
-- have the driver reviewed
-
-Please send any patches and/or comments to Eli Billauer,
-<eli.billauer@gmail.com>.
diff --git a/drivers/staging/xillybus/xillybus.h b/drivers/staging/xillybus/xillybus.h
deleted file mode 100644
index a0806b5..0000000
--- a/drivers/staging/xillybus/xillybus.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * linux/drivers/misc/xillybus.h
- *
- * Copyright 2011 Xillybus Ltd, http://xillybus.com
- *
- * Header file for the Xillybus FPGA/host framework.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#ifndef __XILLYBUS_H
-#define __XILLYBUS_H
-
-#include <linux/list.h>
-#include <linux/device.h>
-#include <linux/dma-mapping.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <linux/cdev.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/workqueue.h>
-
-struct xilly_endpoint_hardware;
-
-struct xilly_buffer {
-	void *addr;
-	dma_addr_t dma_addr;
-	int end_offset; /* Counting elements, not bytes */
-};
-
-struct xilly_idt_handle {
-	unsigned char *chandesc;
-	unsigned char *idt;
-	int entries;
-};
-
-/*
- * Read-write confusion: wr_* and rd_* notation sticks to FPGA view, so
- * wr_* buffers are those consumed by read(), since the FPGA writes to them
- * and vice versa.
- */
-
-struct xilly_channel {
-	struct xilly_endpoint *endpoint;
-	int chan_num;
-	int log2_element_size;
-	int seekable;
-
-	struct xilly_buffer **wr_buffers; /* FPGA writes, driver reads! */
-	int num_wr_buffers;
-	unsigned int wr_buf_size; /* In bytes */
-	int wr_fpga_buf_idx;
-	int wr_host_buf_idx;
-	int wr_host_buf_pos;
-	int wr_empty;
-	int wr_ready; /* Significant only when wr_empty == 1 */
-	int wr_sleepy;
-	int wr_eof;
-	int wr_hangup;
-	spinlock_t wr_spinlock;
-	struct mutex wr_mutex;
-	wait_queue_head_t wr_wait;
-	wait_queue_head_t wr_ready_wait;
-	int wr_ref_count;
-	int wr_synchronous;
-	int wr_allow_partial;
-	int wr_exclusive_open;
-	int wr_supports_nonempty;
-
-	struct xilly_buffer **rd_buffers; /* FPGA reads, driver writes! */
-	int num_rd_buffers;
-	unsigned int rd_buf_size; /* In bytes */
-	int rd_fpga_buf_idx;
-	int rd_host_buf_pos;
-	int rd_host_buf_idx;
-	int rd_full;
-	spinlock_t rd_spinlock;
-	struct mutex rd_mutex;
-	wait_queue_head_t rd_wait;
-	int rd_ref_count;
-	int rd_allow_partial;
-	int rd_synchronous;
-	int rd_exclusive_open;
-	struct delayed_work rd_workitem;
-	unsigned char rd_leftovers[4];
-};
-
-struct xilly_endpoint {
-	/*
-	 * One of pdev and dev is always NULL, and the other is a valid
-	 * pointer, depending on the type of device
-	 */
-	struct pci_dev *pdev;
-	struct device *dev;
-	struct xilly_endpoint_hardware *ephw;
-
-	struct list_head ep_list;
-	int dma_using_dac; /* =1 if 64-bit DMA is used, =0 otherwise. */
-	__iomem void *registers;
-	int fatal_error;
-
-	struct mutex register_mutex;
-	wait_queue_head_t ep_wait;
-
-	/* Channels and message handling */
-	struct cdev cdev;
-
-	int major;
-	int lowest_minor; /* Highest minor = lowest_minor + num_channels - 1 */
-
-	int num_channels; /* EXCLUDING message buffer */
-	struct xilly_channel **channels;
-	int msg_counter;
-	int failed_messages;
-	int idtlen;
-
-	u32 *msgbuf_addr;
-	dma_addr_t msgbuf_dma_addr;
-	unsigned int msg_buf_size;
-};
-
-struct xilly_endpoint_hardware {
-	struct module *owner;
-	void (*hw_sync_sgl_for_cpu)(struct xilly_endpoint *,
-				    dma_addr_t,
-				    size_t,
-				    int);
-	void (*hw_sync_sgl_for_device)(struct xilly_endpoint *,
-				       dma_addr_t,
-				       size_t,
-				       int);
-	int (*map_single)(struct xilly_endpoint *,
-			  void *,
-			  size_t,
-			  int,
-			  dma_addr_t *);
-};
-
-struct xilly_mapping {
-	void *device;
-	dma_addr_t dma_addr;
-	size_t size;
-	int direction;
-};
-
-
-irqreturn_t xillybus_isr(int irq, void *data);
-
-struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
-					      struct device *dev,
-					      struct xilly_endpoint_hardware
-					      *ephw);
-
-int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint);
-
-void xillybus_endpoint_remove(struct xilly_endpoint *endpoint);
-
-#endif /* __XILLYBUS_H */
diff --git a/drivers/staging/xillybus/xillybus_core.c b/drivers/staging/xillybus/xillybus_core.c
deleted file mode 100644
index d5a7202..0000000
--- a/drivers/staging/xillybus/xillybus_core.c
+++ /dev/null
@@ -1,2160 +0,0 @@
-/*
- * linux/drivers/misc/xillybus_core.c
- *
- * Copyright 2011 Xillybus Ltd, http://xillybus.com
- *
- * Driver for the Xillybus FPGA/host framework.
- *
- * This driver interfaces with a special IP core in an FPGA, setting up
- * a pipe between a hardware FIFO in the programmable logic and a device
- * file in the host. The number of such pipes and their attributes are
- * set up on the logic. This driver detects these automatically and
- * creates the device files accordingly.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/list.h>
-#include <linux/device.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/dma-mapping.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
-#include <linux/cdev.h>
-#include <linux/spinlock.h>
-#include <linux/mutex.h>
-#include <linux/crc32.h>
-#include <linux/poll.h>
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
-#include "xillybus.h"
-
-MODULE_DESCRIPTION("Xillybus core functions");
-MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
-MODULE_VERSION("1.07");
-MODULE_ALIAS("xillybus_core");
-MODULE_LICENSE("GPL v2");
-
-/* General timeout is 100 ms, rx timeout is 10 ms */
-#define XILLY_RX_TIMEOUT (10*HZ/1000)
-#define XILLY_TIMEOUT (100*HZ/1000)
-
-#define fpga_msg_ctrl_reg              0x0008
-#define fpga_dma_control_reg           0x0020
-#define fpga_dma_bufno_reg             0x0024
-#define fpga_dma_bufaddr_lowaddr_reg   0x0028
-#define fpga_dma_bufaddr_highaddr_reg  0x002c
-#define fpga_buf_ctrl_reg              0x0030
-#define fpga_buf_offset_reg            0x0034
-#define fpga_endian_reg                0x0040
-
-#define XILLYMSG_OPCODE_RELEASEBUF 1
-#define XILLYMSG_OPCODE_QUIESCEACK 2
-#define XILLYMSG_OPCODE_FIFOEOF 3
-#define XILLYMSG_OPCODE_FATAL_ERROR 4
-#define XILLYMSG_OPCODE_NONEMPTY 5
-
-static const char xillyname[] = "xillybus";
-
-static struct class *xillybus_class;
-
-/*
- * ep_list_lock is the last lock to be taken; No other lock requests are
- * allowed while holding it. It merely protects list_of_endpoints, and not
- * the endpoints listed in it.
- */
-
-static LIST_HEAD(list_of_endpoints);
-static struct mutex ep_list_lock;
-static struct workqueue_struct *xillybus_wq;
-
-/*
- * Locking scheme: Mutexes protect invocations of character device methods.
- * If both locks are taken, wr_mutex is taken first, rd_mutex second.
- *
- * wr_spinlock protects wr_*_buf_idx, wr_empty, wr_sleepy, wr_ready and the
- * buffers' end_offset fields against changes made by IRQ handler (and in
- * theory, other file request handlers, but the mutex handles that). Nothing
- * else.
- * They are held for short direct memory manipulations. Needless to say,
- * no mutex locking is allowed when a spinlock is held.
- *
- * rd_spinlock does the same with rd_*_buf_idx, rd_empty and end_offset.
- *
- * register_mutex is endpoint-specific, and is held when non-atomic
- * register operations are performed. wr_mutex and rd_mutex may be
- * held when register_mutex is taken, but none of the spinlocks. Note that
- * register_mutex doesn't protect against sporadic buf_ctrl_reg writes
- * which are unrelated to buf_offset_reg, since they are harmless.
- *
- * Blocking on the wait queues is allowed with mutexes held, but not with
- * spinlocks.
- *
- * Only interruptible blocking is allowed on mutexes and wait queues.
- *
- * All in all, the locking order goes (with skips allowed, of course):
- * wr_mutex -> rd_mutex -> register_mutex -> wr_spinlock -> rd_spinlock
- */
-
-static void malformed_message(struct xilly_endpoint *endpoint, u32 *buf)
-{
-	int opcode;
-	int msg_channel, msg_bufno, msg_data, msg_dir;
-
-	opcode = (buf[0] >> 24) & 0xff;
-	msg_dir = buf[0] & 1;
-	msg_channel = (buf[0] >> 1) & 0x7ff;
-	msg_bufno = (buf[0] >> 12) & 0x3ff;
-	msg_data = buf[1] & 0xfffffff;
-
-	dev_warn(endpoint->dev,
-		 "Malformed message (skipping): opcode=%d, channel=%03x, dir=%d, bufno=%03x, data=%07x\n",
-		 opcode, msg_channel, msg_dir, msg_bufno, msg_data);
-}
-
-/*
- * xillybus_isr assumes the interrupt is allocated exclusively to it,
- * which is the natural case MSI and several other hardware-oriented
- * interrupts. Sharing is not allowed.
- */
-
-irqreturn_t xillybus_isr(int irq, void *data)
-{
-	struct xilly_endpoint *ep = data;
-	u32 *buf;
-	unsigned int buf_size;
-	int i;
-	int opcode;
-	unsigned int msg_channel, msg_bufno, msg_data, msg_dir;
-	struct xilly_channel *channel;
-
-	buf = ep->msgbuf_addr;
-	buf_size = ep->msg_buf_size/sizeof(u32);
-
-	ep->ephw->hw_sync_sgl_for_cpu(ep,
-				      ep->msgbuf_dma_addr,
-				      ep->msg_buf_size,
-				      DMA_FROM_DEVICE);
-
-	for (i = 0; i < buf_size; i += 2)
-		if (((buf[i+1] >> 28) & 0xf) != ep->msg_counter) {
-			malformed_message(ep, &buf[i]);
-			dev_warn(ep->dev,
-				 "Sending a NACK on counter %x (instead of %x) on entry %d\n",
-				((buf[i+1] >> 28) & 0xf),
-				ep->msg_counter,
-				i/2);
-
-			if (++ep->failed_messages > 10) {
-				dev_err(ep->dev,
-					"Lost sync with interrupt messages. Stopping.\n");
-			} else {
-				ep->ephw->hw_sync_sgl_for_device(
-					ep,
-					ep->msgbuf_dma_addr,
-					ep->msg_buf_size,
-					DMA_FROM_DEVICE);
-
-				iowrite32(0x01,  /* Message NACK */
-					  ep->registers + fpga_msg_ctrl_reg);
-			}
-			return IRQ_HANDLED;
-		} else if (buf[i] & (1 << 22)) /* Last message */
-			break;
-
-	if (i >= buf_size) {
-		dev_err(ep->dev, "Bad interrupt message. Stopping.\n");
-		return IRQ_HANDLED;
-	}
-
-	buf_size = i;
-
-	for (i = 0; i <= buf_size; i += 2) { /* Scan through messages */
-		opcode = (buf[i] >> 24) & 0xff;
-
-		msg_dir = buf[i] & 1;
-		msg_channel = (buf[i] >> 1) & 0x7ff;
-		msg_bufno = (buf[i] >> 12) & 0x3ff;
-		msg_data = buf[i+1] & 0xfffffff;
-
-		switch (opcode) {
-		case XILLYMSG_OPCODE_RELEASEBUF:
-
-			if ((msg_channel > ep->num_channels) ||
-			    (msg_channel == 0)) {
-				malformed_message(ep, &buf[i]);
-				break;
-			}
-
-			channel = ep->channels[msg_channel];
-
-			if (msg_dir) { /* Write channel */
-				if (msg_bufno >= channel->num_wr_buffers) {
-					malformed_message(ep, &buf[i]);
-					break;
-				}
-				spin_lock(&channel->wr_spinlock);
-				channel->wr_buffers[msg_bufno]->end_offset =
-					msg_data;
-				channel->wr_fpga_buf_idx = msg_bufno;
-				channel->wr_empty = 0;
-				channel->wr_sleepy = 0;
-				spin_unlock(&channel->wr_spinlock);
-
-				wake_up_interruptible(&channel->wr_wait);
-
-			} else {
-				/* Read channel */
-
-				if (msg_bufno >= channel->num_rd_buffers) {
-					malformed_message(ep, &buf[i]);
-					break;
-				}
-
-				spin_lock(&channel->rd_spinlock);
-				channel->rd_fpga_buf_idx = msg_bufno;
-				channel->rd_full = 0;
-				spin_unlock(&channel->rd_spinlock);
-
-				wake_up_interruptible(&channel->rd_wait);
-				if (!channel->rd_synchronous)
-					queue_delayed_work(
-						xillybus_wq,
-						&channel->rd_workitem,
-						XILLY_RX_TIMEOUT);
-			}
-
-			break;
-		case XILLYMSG_OPCODE_NONEMPTY:
-			if ((msg_channel > ep->num_channels) ||
-			    (msg_channel == 0) || (!msg_dir) ||
-			    !ep->channels[msg_channel]->wr_supports_nonempty) {
-				malformed_message(ep, &buf[i]);
-				break;
-			}
-
-			channel = ep->channels[msg_channel];
-
-			if (msg_bufno >= channel->num_wr_buffers) {
-				malformed_message(ep, &buf[i]);
-				break;
-			}
-			spin_lock(&channel->wr_spinlock);
-			if (msg_bufno == channel->wr_host_buf_idx)
-				channel->wr_ready = 1;
-			spin_unlock(&channel->wr_spinlock);
-
-			wake_up_interruptible(&channel->wr_ready_wait);
-
-			break;
-		case XILLYMSG_OPCODE_QUIESCEACK:
-			ep->idtlen = msg_data;
-			wake_up_interruptible(&ep->ep_wait);
-
-			break;
-		case XILLYMSG_OPCODE_FIFOEOF:
-			if ((msg_channel > ep->num_channels) ||
-			    (msg_channel == 0) || (!msg_dir) ||
-			    !ep->channels[msg_channel]->num_wr_buffers) {
-				malformed_message(ep, &buf[i]);
-				break;
-			}
-			channel = ep->channels[msg_channel];
-			spin_lock(&channel->wr_spinlock);
-			channel->wr_eof = msg_bufno;
-			channel->wr_sleepy = 0;
-
-			channel->wr_hangup = channel->wr_empty &&
-				(channel->wr_host_buf_idx == msg_bufno);
-
-			spin_unlock(&channel->wr_spinlock);
-
-			wake_up_interruptible(&channel->wr_wait);
-
-			break;
-		case XILLYMSG_OPCODE_FATAL_ERROR:
-			ep->fatal_error = 1;
-			wake_up_interruptible(&ep->ep_wait); /* For select() */
-			dev_err(ep->dev,
-				"FPGA reported a fatal error. This means that the low-level communication with the device has failed. This hardware problem is most likely unrelated to Xillybus (neither kernel module nor FPGA core), but reports are still welcome. All I/O is aborted.\n");
-			break;
-		default:
-			malformed_message(ep, &buf[i]);
-			break;
-		}
-	}
-
-	ep->ephw->hw_sync_sgl_for_device(ep,
-					 ep->msgbuf_dma_addr,
-					 ep->msg_buf_size,
-					 DMA_FROM_DEVICE);
-
-	ep->msg_counter = (ep->msg_counter + 1) & 0xf;
-	ep->failed_messages = 0;
-	iowrite32(0x03, ep->registers + fpga_msg_ctrl_reg); /* Message ACK */
-
-	return IRQ_HANDLED;
-}
-EXPORT_SYMBOL(xillybus_isr);
-
-/*
- * A few trivial memory management functions.
- * NOTE: These functions are used only on probe and remove, and therefore
- * no locks are applied!
- */
-
-static void xillybus_autoflush(struct work_struct *work);
-
-struct xilly_alloc_state {
-	void *salami;
-	int left_of_salami;
-	int nbuffer;
-	enum dma_data_direction direction;
-	u32 regdirection;
-};
-
-static int xilly_get_dma_buffers(struct xilly_endpoint *ep,
-				 struct xilly_alloc_state *s,
-				 struct xilly_buffer **buffers,
-				 int bufnum, int bytebufsize)
-{
-	int i, rc;
-	dma_addr_t dma_addr;
-	struct device *dev = ep->dev;
-	struct xilly_buffer *this_buffer = NULL; /* Init to silence warning */
-
-	if (buffers) { /* Not the message buffer */
-		this_buffer = devm_kzalloc(
-			dev, bufnum * sizeof(struct xilly_buffer),
-			GFP_KERNEL);
-
-		if (!this_buffer)
-			return -ENOMEM;
-	}
-
-	for (i = 0; i < bufnum; i++) {
-		/*
-		 * Buffers are expected in descending size order, so there
-		 * is either enough space for this buffer or none at all.
-		 */
-
-		if ((s->left_of_salami < bytebufsize) &&
-		    (s->left_of_salami > 0)) {
-			dev_err(ep->dev,
-				"Corrupt buffer allocation in IDT. Aborting.\n");
-			return -ENODEV;
-		}
-
-		if (s->left_of_salami == 0) {
-			int allocorder, allocsize;
-
-			allocsize = PAGE_SIZE;
-			allocorder = 0;
-			while (bytebufsize > allocsize) {
-				allocsize *= 2;
-				allocorder++;
-			}
-
-			s->salami = (void *) devm_get_free_pages(
-				dev,
-				GFP_KERNEL | __GFP_DMA32 | __GFP_ZERO,
-				allocorder);
-
-			if (!s->salami)
-				return -ENOMEM;
-			s->left_of_salami = allocsize;
-		}
-
-		rc = ep->ephw->map_single(ep, s->salami,
-					  bytebufsize, s->direction,
-					  &dma_addr);
-
-		if (rc)
-			return rc;
-
-		iowrite32((u32) (dma_addr & 0xffffffff),
-			  ep->registers + fpga_dma_bufaddr_lowaddr_reg);
-		iowrite32(((u32) ((((u64) dma_addr) >> 32) & 0xffffffff)),
-			  ep->registers + fpga_dma_bufaddr_highaddr_reg);
-
-		if (buffers) { /* Not the message buffer */
-			this_buffer->addr = s->salami;
-			this_buffer->dma_addr = dma_addr;
-			buffers[i] = this_buffer++;
-
-			iowrite32(s->regdirection | s->nbuffer++,
-				  ep->registers + fpga_dma_bufno_reg);
-		} else {
-			ep->msgbuf_addr = s->salami;
-			ep->msgbuf_dma_addr = dma_addr;
-			ep->msg_buf_size = bytebufsize;
-
-			iowrite32(s->regdirection,
-				  ep->registers + fpga_dma_bufno_reg);
-		}
-
-		s->left_of_salami -= bytebufsize;
-		s->salami += bytebufsize;
-	}
-	return 0; /* Success */
-}
-
-static int xilly_setupchannels(struct xilly_endpoint *ep,
-			       unsigned char *chandesc,
-			       int entries
-	)
-{
-	struct device *dev = ep->dev;
-	int i, entry, rc;
-	struct xilly_channel *channel;
-	int channelnum, bufnum, bufsize, format, is_writebuf;
-	int bytebufsize;
-	int synchronous, allowpartial, exclusive_open, seekable;
-	int supports_nonempty;
-	int msg_buf_done = 0;
-
-	struct xilly_alloc_state rd_alloc = {
-		.salami = NULL,
-		.left_of_salami = 0,
-		.nbuffer = 1,
-		.direction = DMA_TO_DEVICE,
-		.regdirection = 0,
-	};
-
-	struct xilly_alloc_state wr_alloc = {
-		.salami = NULL,
-		.left_of_salami = 0,
-		.nbuffer = 1,
-		.direction = DMA_FROM_DEVICE,
-		.regdirection = 0x80000000,
-	};
-
-	channel = devm_kzalloc(dev, ep->num_channels *
-			       sizeof(struct xilly_channel), GFP_KERNEL);
-
-	if (!channel)
-		goto memfail;
-
-	ep->channels = devm_kzalloc(dev, (ep->num_channels + 1) *
-				    sizeof(struct xilly_channel *),
-				    GFP_KERNEL);
-
-	if (!ep->channels)
-		goto memfail;
-
-	ep->channels[0] = NULL; /* Channel 0 is message buf. */
-
-	/* Initialize all channels with defaults */
-
-	for (i = 1; i <= ep->num_channels; i++) {
-		channel->wr_buffers = NULL;
-		channel->rd_buffers = NULL;
-		channel->num_wr_buffers = 0;
-		channel->num_rd_buffers = 0;
-		channel->wr_fpga_buf_idx = -1;
-		channel->wr_host_buf_idx = 0;
-		channel->wr_host_buf_pos = 0;
-		channel->wr_empty = 1;
-		channel->wr_ready = 0;
-		channel->wr_sleepy = 1;
-		channel->rd_fpga_buf_idx = 0;
-		channel->rd_host_buf_idx = 0;
-		channel->rd_host_buf_pos = 0;
-		channel->rd_full = 0;
-		channel->wr_ref_count = 0;
-		channel->rd_ref_count = 0;
-
-		spin_lock_init(&channel->wr_spinlock);
-		spin_lock_init(&channel->rd_spinlock);
-		mutex_init(&channel->wr_mutex);
-		mutex_init(&channel->rd_mutex);
-		init_waitqueue_head(&channel->rd_wait);
-		init_waitqueue_head(&channel->wr_wait);
-		init_waitqueue_head(&channel->wr_ready_wait);
-
-		INIT_DELAYED_WORK(&channel->rd_workitem, xillybus_autoflush);
-
-		channel->endpoint = ep;
-		channel->chan_num = i;
-
-		channel->log2_element_size = 0;
-
-		ep->channels[i] = channel++;
-	}
-
-	for (entry = 0; entry < entries; entry++, chandesc += 4) {
-		struct xilly_buffer **buffers = NULL;
-
-		is_writebuf = chandesc[0] & 0x01;
-		channelnum = (chandesc[0] >> 1) | ((chandesc[1] & 0x0f) << 7);
-		format = (chandesc[1] >> 4) & 0x03;
-		allowpartial = (chandesc[1] >> 6) & 0x01;
-		synchronous = (chandesc[1] >> 7) & 0x01;
-		bufsize = 1 << (chandesc[2] & 0x1f);
-		bufnum = 1 << (chandesc[3] & 0x0f);
-		exclusive_open = (chandesc[2] >> 7) & 0x01;
-		seekable = (chandesc[2] >> 6) & 0x01;
-		supports_nonempty = (chandesc[2] >> 5) & 0x01;
-
-		if ((channelnum > ep->num_channels) ||
-		    ((channelnum == 0) && !is_writebuf)) {
-			dev_err(ep->dev,
-				"IDT requests channel out of range. Aborting.\n");
-			return -ENODEV;
-		}
-
-		channel = ep->channels[channelnum]; /* NULL for msg channel */
-
-		if (!is_writebuf || channelnum > 0) {
-			channel->log2_element_size = ((format > 2) ?
-						      2 : format);
-
-			bytebufsize = channel->rd_buf_size = bufsize *
-				(1 << channel->log2_element_size);
-
-			buffers = devm_kzalloc(dev,
-				bufnum * sizeof(struct xilly_buffer *),
-				GFP_KERNEL);
-
-			if (!buffers)
-				goto memfail;
-		} else {
-			bytebufsize = bufsize << 2;
-		}
-
-		if (!is_writebuf) {
-			channel->num_rd_buffers = bufnum;
-			channel->rd_allow_partial = allowpartial;
-			channel->rd_synchronous = synchronous;
-			channel->rd_exclusive_open = exclusive_open;
-			channel->seekable = seekable;
-
-			channel->rd_buffers = buffers;
-			rc = xilly_get_dma_buffers(ep, &rd_alloc, buffers,
-						   bufnum, bytebufsize);
-		} else if (channelnum > 0) {
-			channel->num_wr_buffers = bufnum;
-
-			channel->seekable = seekable;
-			channel->wr_supports_nonempty = supports_nonempty;
-
-			channel->wr_allow_partial = allowpartial;
-			channel->wr_synchronous = synchronous;
-			channel->wr_exclusive_open = exclusive_open;
-
-			channel->wr_buffers = buffers;
-			rc = xilly_get_dma_buffers(ep, &wr_alloc, buffers,
-						   bufnum, bytebufsize);
-		} else {
-			rc = xilly_get_dma_buffers(ep, &wr_alloc, NULL,
-						   bufnum, bytebufsize);
-			msg_buf_done++;
-		}
-
-		if (rc)
-			goto memfail;
-	}
-
-	if (!msg_buf_done) {
-		dev_err(ep->dev,
-			"Corrupt IDT: No message buffer. Aborting.\n");
-		return -ENODEV;
-	}
-	return 0;
-
-memfail:
-	dev_err(ep->dev,
-		"Failed to assign DMA buffer memory. Aborting.\n");
-	return -ENOMEM;
-}
-
-static void xilly_scan_idt(struct xilly_endpoint *endpoint,
-			   struct xilly_idt_handle *idt_handle)
-{
-	int count = 0;
-	unsigned char *idt = endpoint->channels[1]->wr_buffers[0]->addr;
-	unsigned char *end_of_idt = idt + endpoint->idtlen - 4;
-	unsigned char *scan;
-	int len;
-
-	scan = idt;
-	idt_handle->idt = idt;
-
-	scan++; /* Skip version number */
-
-	while ((scan <= end_of_idt) && *scan) {
-		while ((scan <= end_of_idt) && *scan++)
-			/* Do nothing, just scan thru string */;
-		count++;
-	}
-
-	scan++;
-
-	if (scan > end_of_idt) {
-		dev_err(endpoint->dev,
-			"IDT device name list overflow. Aborting.\n");
-		idt_handle->chandesc = NULL;
-		return;
-	}
-	idt_handle->chandesc = scan;
-
-	len = endpoint->idtlen - (3 + ((int) (scan - idt)));
-
-	if (len & 0x03) {
-		idt_handle->chandesc = NULL;
-
-		dev_err(endpoint->dev,
-			"Corrupt IDT device name list. Aborting.\n");
-	}
-
-	idt_handle->entries = len >> 2;
-
-	endpoint->num_channels = count;
-}
-
-static int xilly_obtain_idt(struct xilly_endpoint *endpoint)
-{
-	int rc = 0;
-	struct xilly_channel *channel;
-	unsigned char *version;
-
-	channel = endpoint->channels[1]; /* This should be generated ad-hoc */
-
-	channel->wr_sleepy = 1;
-
-	iowrite32(1 |
-		   (3 << 24), /* Opcode 3 for channel 0 = Send IDT */
-		   endpoint->registers + fpga_buf_ctrl_reg);
-
-	wait_event_interruptible_timeout(channel->wr_wait,
-					 (!channel->wr_sleepy),
-					 XILLY_TIMEOUT);
-
-	if (channel->wr_sleepy) {
-		dev_err(endpoint->dev, "Failed to obtain IDT. Aborting.\n");
-
-		if (endpoint->fatal_error)
-			return -EIO;
-
-		rc = -ENODEV;
-		return rc;
-	}
-
-	endpoint->ephw->hw_sync_sgl_for_cpu(
-		channel->endpoint,
-		channel->wr_buffers[0]->dma_addr,
-		channel->wr_buf_size,
-		DMA_FROM_DEVICE);
-
-	if (channel->wr_buffers[0]->end_offset != endpoint->idtlen) {
-		dev_err(endpoint->dev,
-			"IDT length mismatch (%d != %d). Aborting.\n",
-		       channel->wr_buffers[0]->end_offset, endpoint->idtlen);
-		rc = -ENODEV;
-		return rc;
-	}
-
-	if (crc32_le(~0, channel->wr_buffers[0]->addr,
-		     endpoint->idtlen+1) != 0) {
-		dev_err(endpoint->dev, "IDT failed CRC check. Aborting.\n");
-		rc = -ENODEV;
-		return rc;
-	}
-
-	version = channel->wr_buffers[0]->addr;
-
-	/* Check version number. Accept anything below 0x82 for now. */
-	if (*version > 0x82) {
-		dev_err(endpoint->dev,
-			"No support for IDT version 0x%02x. Maybe the xillybus driver needs an upgarde. Aborting.\n",
-		       (int) *version);
-		rc = -ENODEV;
-		return rc;
-	}
-
-	return 0; /* Success */
-}
-
-static ssize_t xillybus_read(struct file *filp, char __user *userbuf,
-			     size_t count, loff_t *f_pos)
-{
-	ssize_t rc;
-	unsigned long flags;
-	int bytes_done = 0;
-	int no_time_left = 0;
-	long deadline, left_to_sleep;
-	struct xilly_channel *channel = filp->private_data;
-
-	int empty, reached_eof, exhausted, ready;
-	/* Initializations are there only to silence warnings */
-
-	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
-	int waiting_bufidx;
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	deadline = jiffies + 1 + XILLY_RX_TIMEOUT;
-
-	rc = mutex_lock_interruptible(&channel->wr_mutex);
-
-	if (rc)
-		return rc;
-
-	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
-
-	while (1) { /* Note that we may drop mutex within this loop */
-		int bytes_to_do = count - bytes_done;
-
-		spin_lock_irqsave(&channel->wr_spinlock, flags);
-
-		empty = channel->wr_empty;
-		ready = !empty || channel->wr_ready;
-
-		if (!empty) {
-			bufidx = channel->wr_host_buf_idx;
-			bufpos = channel->wr_host_buf_pos;
-			howmany = ((channel->wr_buffers[bufidx]->end_offset
-				    + 1) << channel->log2_element_size)
-				- bufpos;
-
-			/* Update wr_host_* to its post-operation state */
-			if (howmany > bytes_to_do) {
-				bufferdone = 0;
-
-				howmany = bytes_to_do;
-				channel->wr_host_buf_pos += howmany;
-			} else {
-				bufferdone = 1;
-
-				channel->wr_host_buf_pos = 0;
-
-				if (bufidx == channel->wr_fpga_buf_idx) {
-					channel->wr_empty = 1;
-					channel->wr_sleepy = 1;
-					channel->wr_ready = 0;
-				}
-
-				if (bufidx >= (channel->num_wr_buffers - 1))
-					channel->wr_host_buf_idx = 0;
-				else
-					channel->wr_host_buf_idx++;
-			}
-		}
-
-		/*
-		 * Marking our situation after the possible changes above,
-		 * for use after releasing the spinlock.
-		 *
-		 * empty = empty before change
-		 * exhasted = empty after possible change
-		 */
-
-		reached_eof = channel->wr_empty &&
-			(channel->wr_host_buf_idx == channel->wr_eof);
-		channel->wr_hangup = reached_eof;
-		exhausted = channel->wr_empty;
-		waiting_bufidx = channel->wr_host_buf_idx;
-
-		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
-
-		if (!empty) { /* Go on, now without the spinlock */
-
-			if (bufpos == 0) /* Position zero means it's virgin */
-				channel->endpoint->ephw->hw_sync_sgl_for_cpu(
-					channel->endpoint,
-					channel->wr_buffers[bufidx]->dma_addr,
-					channel->wr_buf_size,
-					DMA_FROM_DEVICE);
-
-			if (copy_to_user(
-				    userbuf,
-				    channel->wr_buffers[bufidx]->addr
-				    + bufpos, howmany))
-				rc = -EFAULT;
-
-			userbuf += howmany;
-			bytes_done += howmany;
-
-			if (bufferdone) {
-				channel->endpoint->ephw->
-					hw_sync_sgl_for_device
-					(
-						channel->endpoint,
-						channel->wr_buffers[bufidx]->
-						dma_addr,
-						channel->wr_buf_size,
-						DMA_FROM_DEVICE);
-
-				/*
-				 * Tell FPGA the buffer is done with. It's an
-				 * atomic operation to the FPGA, so what
-				 * happens with other channels doesn't matter,
-				 * and the certain channel is protected with
-				 * the channel-specific mutex.
-				 */
-
-				iowrite32(1 | (channel->chan_num << 1)
-					   | (bufidx << 12),
-					   channel->endpoint->registers +
-					   fpga_buf_ctrl_reg);
-			}
-
-			if (rc) {
-				mutex_unlock(&channel->wr_mutex);
-				return rc;
-			}
-		}
-
-		/* This includes a zero-count return = EOF */
-		if ((bytes_done >= count) || reached_eof)
-			break;
-
-		if (!exhausted)
-			continue; /* More in RAM buffer(s)? Just go on. */
-
-		if ((bytes_done > 0) &&
-		    (no_time_left ||
-		     (channel->wr_synchronous && channel->wr_allow_partial)))
-			break;
-
-		/*
-		 * Nonblocking read: The "ready" flag tells us that the FPGA
-		 * has data to send. In non-blocking mode, if it isn't on,
-		 * just return. But if there is, we jump directly to the point
-		 * where we ask for the FPGA to send all it has, and wait
-		 * until that data arrives. So in a sense, we *do* block in
-		 * nonblocking mode, but only for a very short time.
-		 */
-
-		if (!no_time_left && (filp->f_flags & O_NONBLOCK)) {
-			if (bytes_done > 0)
-				break;
-
-			if (ready)
-				goto desperate;
-
-			bytes_done = -EAGAIN;
-			break;
-		}
-
-		if (!no_time_left || (bytes_done > 0)) {
-			/*
-			 * Note that in case of an element-misaligned read
-			 * request, offsetlimit will include the last element,
-			 * which will be partially read from.
-			 */
-			int offsetlimit = ((count - bytes_done) - 1) >>
-				channel->log2_element_size;
-			int buf_elements = channel->wr_buf_size >>
-				channel->log2_element_size;
-
-			/*
-			 * In synchronous mode, always send an offset limit.
-			 * Just don't send a value too big.
-			 */
-
-			if (channel->wr_synchronous) {
-				/* Don't request more than one buffer */
-				if (channel->wr_allow_partial &&
-				    (offsetlimit >= buf_elements))
-					offsetlimit = buf_elements - 1;
-
-				/* Don't request more than all buffers */
-				if (!channel->wr_allow_partial &&
-				    (offsetlimit >=
-				     (buf_elements * channel->num_wr_buffers)))
-					offsetlimit = buf_elements *
-						channel->num_wr_buffers - 1;
-			}
-
-			/*
-			 * In asynchronous mode, force early flush of a buffer
-			 * only if that will allow returning a full count. The
-			 * "offsetlimit < ( ... )" rather than "<=" excludes
-			 * requesting a full buffer, which would obviously
-			 * cause a buffer transmission anyhow
-			 */
-
-			if (channel->wr_synchronous ||
-			    (offsetlimit < (buf_elements - 1))) {
-
-				mutex_lock(&channel->endpoint->register_mutex);
-
-				iowrite32(offsetlimit,
-					  channel->endpoint->registers +
-					  fpga_buf_offset_reg);
-
-				iowrite32(1 | (channel->chan_num << 1) |
-					   (2 << 24) |  /* 2 = offset limit */
-					   (waiting_bufidx << 12),
-					   channel->endpoint->registers +
-					   fpga_buf_ctrl_reg);
-
-				mutex_unlock(&channel->endpoint->
-					     register_mutex);
-			}
-
-		}
-
-		/*
-		 * If partial completion is disallowed, there is no point in
-		 * timeout sleeping. Neither if no_time_left is set and
-		 * there's no data.
-		 */
-
-		if (!channel->wr_allow_partial ||
-		    (no_time_left && (bytes_done == 0))) {
-
-			/*
-			 * This do-loop will run more than once if another
-			 * thread reasserted wr_sleepy before we got the mutex
-			 * back, so we try again.
-			 */
-
-			do {
-				mutex_unlock(&channel->wr_mutex);
-
-				if (wait_event_interruptible(
-					    channel->wr_wait,
-					    (!channel->wr_sleepy)))
-					goto interrupted;
-
-				if (mutex_lock_interruptible(
-					    &channel->wr_mutex))
-					goto interrupted;
-			} while (channel->wr_sleepy);
-
-			continue;
-
-interrupted: /* Mutex is not held if got here */
-			if (channel->endpoint->fatal_error)
-				return -EIO;
-			if (bytes_done)
-				return bytes_done;
-			if (filp->f_flags & O_NONBLOCK)
-				return -EAGAIN; /* Don't admit snoozing */
-			return -EINTR;
-		}
-
-		left_to_sleep = deadline - ((long) jiffies);
-
-		/*
-		 * If our time is out, skip the waiting. We may miss wr_sleepy
-		 * being deasserted but hey, almost missing the train is like
-		 * missing it.
-		 */
-
-		if (left_to_sleep > 0) {
-			left_to_sleep =
-				wait_event_interruptible_timeout(
-					channel->wr_wait,
-					(!channel->wr_sleepy),
-					left_to_sleep);
-
-			if (!channel->wr_sleepy)
-				continue;
-
-			if (left_to_sleep < 0) { /* Interrupt */
-				mutex_unlock(&channel->wr_mutex);
-				if (channel->endpoint->fatal_error)
-					return -EIO;
-				if (bytes_done)
-					return bytes_done;
-				return -EINTR;
-			}
-		}
-
-desperate:
-		no_time_left = 1; /* We're out of sleeping time. Desperate! */
-
-		if (bytes_done == 0) {
-			/*
-			 * Reaching here means that we allow partial return,
-			 * that we've run out of time, and that we have
-			 * nothing to return.
-			 * So tell the FPGA to send anything it has or gets.
-			 */
-
-			iowrite32(1 | (channel->chan_num << 1) |
-				   (3 << 24) |  /* Opcode 3, flush it all! */
-				   (waiting_bufidx << 12),
-				   channel->endpoint->registers +
-				   fpga_buf_ctrl_reg);
-		}
-
-		/*
-		 * Formally speaking, we should block for data at this point.
-		 * But to keep the code cleaner, we'll just finish the loop,
-		 * make the unlikely check for data, and then block at the
-		 * usual place.
-		 */
-	}
-
-	mutex_unlock(&channel->wr_mutex);
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	return bytes_done;
-}
-
-/*
- * The timeout argument takes values as follows:
- *  >0 : Flush with timeout
- * ==0 : Flush, and wait idefinitely for the flush to complete
- *  <0 : Autoflush: Flush only if there's a single buffer occupied
- */
-
-static int xillybus_myflush(struct xilly_channel *channel, long timeout)
-{
-	int rc = 0;
-	unsigned long flags;
-
-	int end_offset_plus1;
-	int bufidx, bufidx_minus1;
-	int i;
-	int empty;
-	int new_rd_host_buf_pos;
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-	rc = mutex_lock_interruptible(&channel->rd_mutex);
-
-	if (rc)
-		return rc;
-
-	/*
-	 * Don't flush a closed channel. This can happen when the work queued
-	 * autoflush thread fires off after the file has closed. This is not
-	 * an error, just something to dismiss.
-	 */
-
-	if (!channel->rd_ref_count)
-		goto done;
-
-	bufidx = channel->rd_host_buf_idx;
-
-	bufidx_minus1 = (bufidx == 0) ? channel->num_rd_buffers - 1 : bufidx-1;
-
-	end_offset_plus1 = channel->rd_host_buf_pos >>
-		channel->log2_element_size;
-
-	new_rd_host_buf_pos = channel->rd_host_buf_pos -
-		(end_offset_plus1 << channel->log2_element_size);
-
-	/* Submit the current buffer if it's nonempty */
-	if (end_offset_plus1) {
-		unsigned char *tail = channel->rd_buffers[bufidx]->addr +
-			(end_offset_plus1 << channel->log2_element_size);
-
-		/* Copy  unflushed data, so we can put it in next buffer */
-		for (i = 0; i < new_rd_host_buf_pos; i++)
-			channel->rd_leftovers[i] = *tail++;
-
-		spin_lock_irqsave(&channel->rd_spinlock, flags);
-
-		/* Autoflush only if a single buffer is occupied */
-
-		if ((timeout < 0) &&
-		    (channel->rd_full ||
-		     (bufidx_minus1 != channel->rd_fpga_buf_idx))) {
-			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-			/*
-			 * A new work item may be queued by the ISR exactly
-			 * now, since the execution of a work item allows the
-			 * queuing of a new one while it's running.
-			 */
-			goto done;
-		}
-
-		/* The 4th element is never needed for data, so it's a flag */
-		channel->rd_leftovers[3] = (new_rd_host_buf_pos != 0);
-
-		/* Set up rd_full to reflect a certain moment's state */
-
-		if (bufidx == channel->rd_fpga_buf_idx)
-			channel->rd_full = 1;
-		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-
-		if (bufidx >= (channel->num_rd_buffers - 1))
-			channel->rd_host_buf_idx = 0;
-		else
-			channel->rd_host_buf_idx++;
-
-		channel->endpoint->ephw->hw_sync_sgl_for_device(
-			channel->endpoint,
-			channel->rd_buffers[bufidx]->dma_addr,
-			channel->rd_buf_size,
-			DMA_TO_DEVICE);
-
-		mutex_lock(&channel->endpoint->register_mutex);
-
-		iowrite32(end_offset_plus1 - 1,
-			  channel->endpoint->registers + fpga_buf_offset_reg);
-
-		iowrite32((channel->chan_num << 1) | /* Channel ID */
-			   (2 << 24) |  /* Opcode 2, submit buffer */
-			   (bufidx << 12),
-			   channel->endpoint->registers + fpga_buf_ctrl_reg);
-
-		mutex_unlock(&channel->endpoint->register_mutex);
-	} else if (bufidx == 0)
-		bufidx = channel->num_rd_buffers - 1;
-	else
-		bufidx--;
-
-	channel->rd_host_buf_pos = new_rd_host_buf_pos;
-
-	if (timeout < 0)
-		goto done; /* Autoflush */
-
-
-	/*
-	 * bufidx is now the last buffer written to (or equal to
-	 * rd_fpga_buf_idx if buffer was never written to), and
-	 * channel->rd_host_buf_idx the one after it.
-	 *
-	 * If bufidx == channel->rd_fpga_buf_idx we're either empty or full.
-	 */
-
-	rc = 0;
-
-	while (1) { /* Loop waiting for draining of buffers */
-		spin_lock_irqsave(&channel->rd_spinlock, flags);
-
-		if (bufidx != channel->rd_fpga_buf_idx)
-			channel->rd_full = 1; /*
-					       * Not really full,
-					       * but needs waiting.
-					       */
-
-		empty = !channel->rd_full;
-
-		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-
-		if (empty)
-			break;
-
-		/*
-		 * Indefinite sleep with mutex taken. With data waiting for
-		 * flushing user should not be surprised if open() for write
-		 * sleeps.
-		 */
-		if (timeout == 0)
-			wait_event_interruptible(channel->rd_wait,
-						 (!channel->rd_full));
-
-		else if (wait_event_interruptible_timeout(
-				 channel->rd_wait,
-				 (!channel->rd_full),
-				 timeout) == 0) {
-			dev_warn(channel->endpoint->dev,
-				"Timed out while flushing. Output data may be lost.\n");
-
-			rc = -ETIMEDOUT;
-			break;
-		}
-
-		if (channel->rd_full) {
-			rc = -EINTR;
-			break;
-		}
-	}
-
-done:
-	mutex_unlock(&channel->rd_mutex);
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	return rc;
-}
-
-static int xillybus_flush(struct file *filp, fl_owner_t id)
-{
-	if (!(filp->f_mode & FMODE_WRITE))
-		return 0;
-
-	return xillybus_myflush(filp->private_data, HZ); /* 1 second timeout */
-}
-
-static void xillybus_autoflush(struct work_struct *work)
-{
-	struct delayed_work *workitem = container_of(
-		work, struct delayed_work, work);
-	struct xilly_channel *channel = container_of(
-		workitem, struct xilly_channel, rd_workitem);
-	int rc;
-
-	rc = xillybus_myflush(channel, -1);
-
-	if (rc == -EINTR)
-		dev_warn(channel->endpoint->dev,
-			 "Autoflush failed because work queue thread got a signal.\n");
-	else if (rc)
-		dev_err(channel->endpoint->dev,
-			"Autoflush failed under weird circumstances.\n");
-}
-
-static ssize_t xillybus_write(struct file *filp, const char __user *userbuf,
-			      size_t count, loff_t *f_pos)
-{
-	ssize_t rc;
-	unsigned long flags;
-	int bytes_done = 0;
-	struct xilly_channel *channel = filp->private_data;
-
-	int full, exhausted;
-	/* Initializations are there only to silence warnings */
-
-	int howmany = 0, bufpos = 0, bufidx = 0, bufferdone = 0;
-	int end_offset_plus1 = 0;
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	rc = mutex_lock_interruptible(&channel->rd_mutex);
-
-	if (rc)
-		return rc;
-
-	rc = 0; /* Just to be clear about it. Compiler optimizes this out */
-
-	while (1) {
-		int bytes_to_do = count - bytes_done;
-
-		spin_lock_irqsave(&channel->rd_spinlock, flags);
-
-		full = channel->rd_full;
-
-		if (!full) {
-			bufidx = channel->rd_host_buf_idx;
-			bufpos = channel->rd_host_buf_pos;
-			howmany = channel->rd_buf_size - bufpos;
-
-			/*
-			 * Update rd_host_* to its state after this operation.
-			 * count=0 means committing the buffer immediately,
-			 * which is like flushing, but not necessarily block.
-			 */
-
-			if ((howmany > bytes_to_do) &&
-			    (count ||
-			     ((bufpos >> channel->log2_element_size) == 0))) {
-				bufferdone = 0;
-
-				howmany = bytes_to_do;
-				channel->rd_host_buf_pos += howmany;
-			} else {
-				bufferdone = 1;
-
-				if (count) {
-					end_offset_plus1 =
-						channel->rd_buf_size >>
-						channel->log2_element_size;
-					channel->rd_host_buf_pos = 0;
-				} else {
-					unsigned char *tail;
-					int i;
-
-					end_offset_plus1 = bufpos >>
-						channel->log2_element_size;
-
-					channel->rd_host_buf_pos -=
-						end_offset_plus1 <<
-						channel->log2_element_size;
-
-					tail = channel->
-						rd_buffers[bufidx]->addr +
-						(end_offset_plus1 <<
-						 channel->log2_element_size);
-
-					for (i = 0;
-					     i < channel->rd_host_buf_pos;
-					     i++)
-						channel->rd_leftovers[i] =
-							*tail++;
-				}
-
-				if (bufidx == channel->rd_fpga_buf_idx)
-					channel->rd_full = 1;
-
-				if (bufidx >= (channel->num_rd_buffers - 1))
-					channel->rd_host_buf_idx = 0;
-				else
-					channel->rd_host_buf_idx++;
-			}
-		}
-
-		/*
-		 * Marking our situation after the possible changes above,
-		 * for use  after releasing the spinlock.
-		 *
-		 * full = full before change
-		 * exhasted = full after possible change
-		 */
-
-		exhausted = channel->rd_full;
-
-		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-
-		if (!full) { /* Go on, now without the spinlock */
-			unsigned char *head =
-				channel->rd_buffers[bufidx]->addr;
-			int i;
-
-			if ((bufpos == 0) || /* Zero means it's virgin */
-			    (channel->rd_leftovers[3] != 0)) {
-				channel->endpoint->ephw->hw_sync_sgl_for_cpu(
-					channel->endpoint,
-					channel->rd_buffers[bufidx]->dma_addr,
-					channel->rd_buf_size,
-					DMA_TO_DEVICE);
-
-				/* Virgin, but leftovers are due */
-				for (i = 0; i < bufpos; i++)
-					*head++ = channel->rd_leftovers[i];
-
-				channel->rd_leftovers[3] = 0; /* Clear flag */
-			}
-
-			if (copy_from_user(
-				    channel->rd_buffers[bufidx]->addr + bufpos,
-				    userbuf, howmany))
-				rc = -EFAULT;
-
-			userbuf += howmany;
-			bytes_done += howmany;
-
-			if (bufferdone) {
-				channel->endpoint->ephw->
-					hw_sync_sgl_for_device(
-						channel->endpoint,
-						channel->rd_buffers[bufidx]->
-						dma_addr,
-						channel->rd_buf_size,
-						DMA_TO_DEVICE);
-
-				mutex_lock(&channel->endpoint->register_mutex);
-
-				iowrite32(end_offset_plus1 - 1,
-					  channel->endpoint->registers +
-					  fpga_buf_offset_reg);
-
-				iowrite32((channel->chan_num << 1) |
-					   (2 << 24) |  /* 2 = submit buffer */
-					   (bufidx << 12),
-					   channel->endpoint->registers +
-					   fpga_buf_ctrl_reg);
-
-				mutex_unlock(&channel->endpoint->
-					     register_mutex);
-
-				channel->rd_leftovers[3] =
-					(channel->rd_host_buf_pos != 0);
-			}
-
-			if (rc) {
-				mutex_unlock(&channel->rd_mutex);
-
-				if (channel->endpoint->fatal_error)
-					return -EIO;
-
-				if (!channel->rd_synchronous)
-					queue_delayed_work(
-						xillybus_wq,
-						&channel->rd_workitem,
-						XILLY_RX_TIMEOUT);
-
-				return rc;
-			}
-		}
-
-		if (bytes_done >= count)
-			break;
-
-		if (!exhausted)
-			continue; /* If there's more space, just go on */
-
-		if ((bytes_done > 0) && channel->rd_allow_partial)
-			break;
-
-		/*
-		 * Indefinite sleep with mutex taken. With data waiting for
-		 * flushing, user should not be surprised if open() for write
-		 * sleeps.
-		 */
-
-		if (filp->f_flags & O_NONBLOCK) {
-			bytes_done = -EAGAIN;
-			break;
-		}
-
-		wait_event_interruptible(channel->rd_wait,
-					 (!channel->rd_full));
-
-		if (channel->rd_full) {
-			mutex_unlock(&channel->rd_mutex);
-
-			if (channel->endpoint->fatal_error)
-				return -EIO;
-
-			if (bytes_done)
-				return bytes_done;
-			return -EINTR;
-		}
-	}
-
-	mutex_unlock(&channel->rd_mutex);
-
-	if (!channel->rd_synchronous)
-		queue_delayed_work(xillybus_wq,
-				   &channel->rd_workitem,
-				   XILLY_RX_TIMEOUT);
-
-	if ((channel->rd_synchronous) && (bytes_done > 0)) {
-		rc = xillybus_myflush(filp->private_data, 0); /* No timeout */
-
-		if (rc && (rc != -EINTR))
-			return rc;
-	}
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	return bytes_done;
-}
-
-static int xillybus_open(struct inode *inode, struct file *filp)
-{
-	int rc = 0;
-	unsigned long flags;
-	int minor = iminor(inode);
-	int major = imajor(inode);
-	struct xilly_endpoint *ep_iter, *endpoint = NULL;
-	struct xilly_channel *channel;
-
-	mutex_lock(&ep_list_lock);
-
-	list_for_each_entry(ep_iter, &list_of_endpoints, ep_list) {
-		if ((ep_iter->major == major) &&
-		    (minor >= ep_iter->lowest_minor) &&
-		    (minor < (ep_iter->lowest_minor +
-			      ep_iter->num_channels))) {
-			endpoint = ep_iter;
-			break;
-		}
-	}
-	mutex_unlock(&ep_list_lock);
-
-	if (!endpoint) {
-		pr_err("xillybus: open() failed to find a device for major=%d and minor=%d\n",
-		       major, minor);
-		return -ENODEV;
-	}
-
-	if (endpoint->fatal_error)
-		return -EIO;
-
-	channel = endpoint->channels[1 + minor - endpoint->lowest_minor];
-	filp->private_data = channel;
-
-
-	/*
-	 * It gets complicated because:
-	 * 1. We don't want to take a mutex we don't have to
-	 * 2. We don't want to open one direction if the other will fail.
-	 */
-
-	if ((filp->f_mode & FMODE_READ) && (!channel->num_wr_buffers))
-		return -ENODEV;
-
-	if ((filp->f_mode & FMODE_WRITE) && (!channel->num_rd_buffers))
-		return -ENODEV;
-
-	if ((filp->f_mode & FMODE_READ) && (filp->f_flags & O_NONBLOCK) &&
-	    (channel->wr_synchronous || !channel->wr_allow_partial ||
-	     !channel->wr_supports_nonempty)) {
-		dev_err(endpoint->dev,
-			"open() failed: O_NONBLOCK not allowed for read on this device\n");
-		return -ENODEV;
-	}
-
-	if ((filp->f_mode & FMODE_WRITE) && (filp->f_flags & O_NONBLOCK) &&
-	    (channel->rd_synchronous || !channel->rd_allow_partial)) {
-		dev_err(endpoint->dev,
-			"open() failed: O_NONBLOCK not allowed for write on this device\n");
-		return -ENODEV;
-	}
-
-	/*
-	 * Note: open() may block on getting mutexes despite O_NONBLOCK.
-	 * This shouldn't occur normally, since multiple open of the same
-	 * file descriptor is almost always prohibited anyhow
-	 * (*_exclusive_open is normally set in real-life systems).
-	 */
-
-	if (filp->f_mode & FMODE_READ) {
-		rc = mutex_lock_interruptible(&channel->wr_mutex);
-		if (rc)
-			return rc;
-	}
-
-	if (filp->f_mode & FMODE_WRITE) {
-		rc = mutex_lock_interruptible(&channel->rd_mutex);
-		if (rc)
-			goto unlock_wr;
-	}
-
-	if ((filp->f_mode & FMODE_READ) &&
-	    (channel->wr_ref_count != 0) &&
-	    (channel->wr_exclusive_open)) {
-		rc = -EBUSY;
-		goto unlock;
-	}
-
-	if ((filp->f_mode & FMODE_WRITE) &&
-	    (channel->rd_ref_count != 0) &&
-	    (channel->rd_exclusive_open)) {
-		rc = -EBUSY;
-		goto unlock;
-	}
-
-
-	if (filp->f_mode & FMODE_READ) {
-		if (channel->wr_ref_count == 0) { /* First open of file */
-			/* Move the host to first buffer */
-			spin_lock_irqsave(&channel->wr_spinlock, flags);
-			channel->wr_host_buf_idx = 0;
-			channel->wr_host_buf_pos = 0;
-			channel->wr_fpga_buf_idx = -1;
-			channel->wr_empty = 1;
-			channel->wr_ready = 0;
-			channel->wr_sleepy = 1;
-			channel->wr_eof = -1;
-			channel->wr_hangup = 0;
-
-			spin_unlock_irqrestore(&channel->wr_spinlock, flags);
-
-			iowrite32(1 | (channel->chan_num << 1) |
-				  (4 << 24) |  /* Opcode 4, open channel */
-				  ((channel->wr_synchronous & 1) << 23),
-				  channel->endpoint->registers +
-				  fpga_buf_ctrl_reg);
-		}
-
-		channel->wr_ref_count++;
-	}
-
-	if (filp->f_mode & FMODE_WRITE) {
-		if (channel->rd_ref_count == 0) { /* First open of file */
-			/* Move the host to first buffer */
-			spin_lock_irqsave(&channel->rd_spinlock, flags);
-			channel->rd_host_buf_idx = 0;
-			channel->rd_host_buf_pos = 0;
-			channel->rd_leftovers[3] = 0; /* No leftovers. */
-			channel->rd_fpga_buf_idx = channel->num_rd_buffers - 1;
-			channel->rd_full = 0;
-
-			spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-
-			iowrite32((channel->chan_num << 1) |
-				  (4 << 24),   /* Opcode 4, open channel */
-				  channel->endpoint->registers +
-				  fpga_buf_ctrl_reg);
-		}
-
-		channel->rd_ref_count++;
-	}
-
-unlock:
-	if (filp->f_mode & FMODE_WRITE)
-		mutex_unlock(&channel->rd_mutex);
-unlock_wr:
-	if (filp->f_mode & FMODE_READ)
-		mutex_unlock(&channel->wr_mutex);
-
-	if (!rc && (!channel->seekable))
-		return nonseekable_open(inode, filp);
-
-	return rc;
-}
-
-static int xillybus_release(struct inode *inode, struct file *filp)
-{
-	int rc;
-	unsigned long flags;
-	struct xilly_channel *channel = filp->private_data;
-
-	int buf_idx;
-	int eof;
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	if (filp->f_mode & FMODE_WRITE) {
-		rc = mutex_lock_interruptible(&channel->rd_mutex);
-
-		if (rc) {
-			dev_warn(channel->endpoint->dev,
-				 "Failed to close file. Hardware left in messy state.\n");
-			return rc;
-		}
-
-		channel->rd_ref_count--;
-
-		if (channel->rd_ref_count == 0) {
-
-			/*
-			 * We rely on the kernel calling flush()
-			 * before we get here.
-			 */
-
-			iowrite32((channel->chan_num << 1) | /* Channel ID */
-				  (5 << 24),  /* Opcode 5, close channel */
-				  channel->endpoint->registers +
-				  fpga_buf_ctrl_reg);
-		}
-		mutex_unlock(&channel->rd_mutex);
-	}
-
-	if (filp->f_mode & FMODE_READ) {
-		rc = mutex_lock_interruptible(&channel->wr_mutex);
-		if (rc) {
-			dev_warn(channel->endpoint->dev,
-				 "Failed to close file. Hardware left in messy state.\n");
-			return rc;
-		}
-
-		channel->wr_ref_count--;
-
-		if (channel->wr_ref_count == 0) {
-
-			iowrite32(1 | (channel->chan_num << 1) |
-				   (5 << 24),  /* Opcode 5, close channel */
-				   channel->endpoint->registers +
-				   fpga_buf_ctrl_reg);
-
-			/*
-			 * This is crazily cautious: We make sure that not
-			 * only that we got an EOF (be it because we closed
-			 * the channel or because of a user's EOF), but verify
-			 * that it's one beyond the last buffer arrived, so
-			 * we have no leftover buffers pending before wrapping
-			 * up (which can only happen in asynchronous channels,
-			 * BTW)
-			 */
-
-			while (1) {
-				spin_lock_irqsave(&channel->wr_spinlock,
-						  flags);
-				buf_idx = channel->wr_fpga_buf_idx;
-				eof = channel->wr_eof;
-				channel->wr_sleepy = 1;
-				spin_unlock_irqrestore(&channel->wr_spinlock,
-						       flags);
-
-				/*
-				 * Check if eof points at the buffer after
-				 * the last one the FPGA submitted. Note that
-				 * no EOF is marked by negative eof.
-				 */
-
-				buf_idx++;
-				if (buf_idx == channel->num_wr_buffers)
-					buf_idx = 0;
-
-				if (buf_idx == eof)
-					break;
-
-				/*
-				 * Steal extra 100 ms if awaken by interrupt.
-				 * This is a simple workaround for an
-				 * interrupt pending when entering, which would
-				 * otherwise result in declaring the hardware
-				 * non-responsive.
-				 */
-
-				if (wait_event_interruptible(
-					    channel->wr_wait,
-					    (!channel->wr_sleepy)))
-					msleep(100);
-
-				if (channel->wr_sleepy) {
-					mutex_unlock(&channel->wr_mutex);
-					dev_warn(channel->endpoint->dev,
-						 "Hardware failed to respond to close command, therefore left in messy state.\n");
-					return -EINTR;
-				}
-			}
-		}
-
-		mutex_unlock(&channel->wr_mutex);
-	}
-
-	return 0;
-}
-static loff_t xillybus_llseek(struct file *filp, loff_t offset, int whence)
-{
-	struct xilly_channel *channel = filp->private_data;
-	loff_t pos = filp->f_pos;
-	int rc = 0;
-
-	/*
-	 * Take both mutexes not allowing interrupts, since it seems like
-	 * common applications don't expect an -EINTR here. Besides, multiple
-	 * access to a single file descriptor on seekable devices is a mess
-	 * anyhow.
-	 */
-
-	if (channel->endpoint->fatal_error)
-		return -EIO;
-
-	mutex_lock(&channel->wr_mutex);
-	mutex_lock(&channel->rd_mutex);
-
-	switch (whence) {
-	case 0:
-		pos = offset;
-		break;
-	case 1:
-		pos += offset;
-		break;
-	case 2:
-		pos = offset; /* Going to the end => to the beginning */
-		break;
-	default:
-		rc = -EINVAL;
-		goto end;
-	}
-
-	/* In any case, we must finish on an element boundary */
-	if (pos & ((1 << channel->log2_element_size) - 1)) {
-		rc = -EINVAL;
-		goto end;
-	}
-
-	mutex_lock(&channel->endpoint->register_mutex);
-
-	iowrite32(pos >> channel->log2_element_size,
-		  channel->endpoint->registers + fpga_buf_offset_reg);
-
-	iowrite32((channel->chan_num << 1) |
-		  (6 << 24),  /* Opcode 6, set address */
-		  channel->endpoint->registers + fpga_buf_ctrl_reg);
-
-	mutex_unlock(&channel->endpoint->register_mutex);
-
-end:
-	mutex_unlock(&channel->rd_mutex);
-	mutex_unlock(&channel->wr_mutex);
-
-	if (rc) /* Return error after releasing mutexes */
-		return rc;
-
-	filp->f_pos = pos;
-
-	/*
-	 * Since seekable devices are allowed only when the channel is
-	 * synchronous, we assume that there is no data pending in either
-	 * direction (which holds true as long as no concurrent access on the
-	 * file descriptor takes place).
-	 * The only thing we may need to throw away is leftovers from partial
-	 * write() flush.
-	 */
-
-	channel->rd_leftovers[3] = 0;
-
-	return pos;
-}
-
-static unsigned int xillybus_poll(struct file *filp, poll_table *wait)
-{
-	struct xilly_channel *channel = filp->private_data;
-	unsigned int mask = 0;
-	unsigned long flags;
-
-	poll_wait(filp, &channel->endpoint->ep_wait, wait);
-
-	/*
-	 * poll() won't play ball regarding read() channels which
-	 * aren't asynchronous and support the nonempty message. Allowing
-	 * that will create situations where data has been delivered at
-	 * the FPGA, and users expecting select() to wake up, which it may
-	 * not.
-	 */
-
-	if (!channel->wr_synchronous && channel->wr_supports_nonempty) {
-		poll_wait(filp, &channel->wr_wait, wait);
-		poll_wait(filp, &channel->wr_ready_wait, wait);
-
-		spin_lock_irqsave(&channel->wr_spinlock, flags);
-		if (!channel->wr_empty || channel->wr_ready)
-			mask |= POLLIN | POLLRDNORM;
-
-		if (channel->wr_hangup)
-			/*
-			 * Not POLLHUP, because its behavior is in the
-			 * mist, and POLLIN does what we want: Wake up
-			 * the read file descriptor so it sees EOF.
-			 */
-			mask |=  POLLIN | POLLRDNORM;
-		spin_unlock_irqrestore(&channel->wr_spinlock, flags);
-	}
-
-	/*
-	 * If partial data write is disallowed on a write() channel,
-	 * it's pointless to ever signal OK to write, because is could
-	 * block despite some space being available.
-	 */
-
-	if (channel->rd_allow_partial) {
-		poll_wait(filp, &channel->rd_wait, wait);
-
-		spin_lock_irqsave(&channel->rd_spinlock, flags);
-		if (!channel->rd_full)
-			mask |= POLLOUT | POLLWRNORM;
-		spin_unlock_irqrestore(&channel->rd_spinlock, flags);
-	}
-
-	if (channel->endpoint->fatal_error)
-		mask |= POLLERR;
-
-	return mask;
-}
-
-static const struct file_operations xillybus_fops = {
-	.owner      = THIS_MODULE,
-	.read       = xillybus_read,
-	.write      = xillybus_write,
-	.open       = xillybus_open,
-	.flush      = xillybus_flush,
-	.release    = xillybus_release,
-	.llseek     = xillybus_llseek,
-	.poll       = xillybus_poll,
-};
-
-static int xillybus_init_chrdev(struct xilly_endpoint *endpoint,
-				const unsigned char *idt)
-{
-	int rc;
-	dev_t dev;
-	int devnum, i, minor, major;
-	char devname[48];
-	struct device *device;
-
-	rc = alloc_chrdev_region(&dev, 0, /* minor start */
-				 endpoint->num_channels,
-				 xillyname);
-
-	if (rc) {
-		dev_warn(endpoint->dev, "Failed to obtain major/minors");
-		goto error1;
-	}
-
-	endpoint->major = major = MAJOR(dev);
-	endpoint->lowest_minor = minor = MINOR(dev);
-
-	cdev_init(&endpoint->cdev, &xillybus_fops);
-	endpoint->cdev.owner = endpoint->ephw->owner;
-	rc = cdev_add(&endpoint->cdev, MKDEV(major, minor),
-		      endpoint->num_channels);
-	if (rc) {
-		dev_warn(endpoint->dev, "Failed to add cdev. Aborting.\n");
-		goto error2;
-	}
-
-	idt++;
-
-	for (i = minor, devnum = 0;
-	     devnum < endpoint->num_channels;
-	     devnum++, i++) {
-		snprintf(devname, sizeof(devname)-1, "xillybus_%s", idt);
-
-		devname[sizeof(devname)-1] = 0; /* Should never matter */
-
-		while (*idt++)
-			/* Skip to next */;
-
-		device = device_create(xillybus_class,
-				       NULL,
-				       MKDEV(major, i),
-				       NULL,
-				       "%s", devname);
-
-		if (IS_ERR(device)) {
-			dev_warn(endpoint->dev,
-				 "Failed to create %s device. Aborting.\n",
-				 devname);
-			goto error3;
-		}
-	}
-
-	dev_info(endpoint->dev, "Created %d device files.\n",
-		 endpoint->num_channels);
-	return 0; /* succeed */
-
-error3:
-	devnum--; i--;
-	for (; devnum >= 0; devnum--, i--)
-		device_destroy(xillybus_class, MKDEV(major, i));
-
-	cdev_del(&endpoint->cdev);
-error2:
-	unregister_chrdev_region(MKDEV(major, minor), endpoint->num_channels);
-error1:
-
-	return rc;
-}
-
-static void xillybus_cleanup_chrdev(struct xilly_endpoint *endpoint)
-{
-	int minor;
-
-	for (minor = endpoint->lowest_minor;
-	     minor < (endpoint->lowest_minor + endpoint->num_channels);
-	     minor++)
-		device_destroy(xillybus_class, MKDEV(endpoint->major, minor));
-	cdev_del(&endpoint->cdev);
-	unregister_chrdev_region(MKDEV(endpoint->major,
-				       endpoint->lowest_minor),
-				 endpoint->num_channels);
-
-	dev_info(endpoint->dev, "Removed %d device files.\n",
-		 endpoint->num_channels);
-}
-
-
-struct xilly_endpoint *xillybus_init_endpoint(struct pci_dev *pdev,
-					      struct device *dev,
-					      struct xilly_endpoint_hardware
-					      *ephw)
-{
-	struct xilly_endpoint *endpoint;
-
-	endpoint = devm_kzalloc(dev, sizeof(*endpoint), GFP_KERNEL);
-	if (!endpoint)
-		return NULL;
-
-	endpoint->pdev = pdev;
-	endpoint->dev = dev;
-	endpoint->ephw = ephw;
-	endpoint->msg_counter = 0x0b;
-	endpoint->failed_messages = 0;
-	endpoint->fatal_error = 0;
-
-	init_waitqueue_head(&endpoint->ep_wait);
-	mutex_init(&endpoint->register_mutex);
-
-	return endpoint;
-}
-EXPORT_SYMBOL(xillybus_init_endpoint);
-
-static int xilly_quiesce(struct xilly_endpoint *endpoint)
-{
-	endpoint->idtlen = -1;
-
-	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
-		  endpoint->registers + fpga_dma_control_reg);
-
-	wait_event_interruptible_timeout(endpoint->ep_wait,
-					 (endpoint->idtlen >= 0),
-					 XILLY_TIMEOUT);
-
-	if (endpoint->idtlen < 0) {
-		dev_err(endpoint->dev,
-			"Failed to quiesce the device on exit.\n");
-		return -ENODEV;
-	}
-	return 0; /* Success */
-}
-
-int xillybus_endpoint_discovery(struct xilly_endpoint *endpoint)
-{
-	int rc = 0;
-
-	void *bootstrap_resources;
-	int idtbuffersize = (1 << PAGE_SHIFT);
-	struct device *dev = endpoint->dev;
-
-	/*
-	 * The bogus IDT is used during bootstrap for allocating the initial
-	 * message buffer, and then the message buffer and space for the IDT
-	 * itself. The initial message buffer is of a single page's size, but
-	 * it's soon replaced with a more modest one (and memory is freed).
-	 */
-
-	unsigned char bogus_idt[8] = { 1, 224, (PAGE_SHIFT)-2, 0,
-				       3, 192, PAGE_SHIFT, 0 };
-	struct xilly_idt_handle idt_handle;
-
-	/*
-	 * Writing the value 0x00000001 to Endianness register signals which
-	 * endianness this processor is using, so the FPGA can swap words as
-	 * necessary.
-	 */
-
-	iowrite32(1, endpoint->registers + fpga_endian_reg);
-
-	/* Bootstrap phase I: Allocate temporary message buffer */
-
-	bootstrap_resources = devres_open_group(dev, NULL, GFP_KERNEL);
-	if (!bootstrap_resources)
-		return -ENOMEM;
-
-	endpoint->num_channels = 0;
-
-	rc = xilly_setupchannels(endpoint, bogus_idt, 1);
-
-	if (rc)
-		return rc;
-
-	/* Clear the message subsystem (and counter in particular) */
-	iowrite32(0x04, endpoint->registers + fpga_msg_ctrl_reg);
-
-	endpoint->idtlen = -1;
-
-	/*
-	 * Set DMA 32/64 bit mode, quiesce the device (?!) and get IDT
-	 * buffer size.
-	 */
-	iowrite32((u32) (endpoint->dma_using_dac & 0x0001),
-		   endpoint->registers + fpga_dma_control_reg);
-
-	wait_event_interruptible_timeout(endpoint->ep_wait,
-					 (endpoint->idtlen >= 0),
-					 XILLY_TIMEOUT);
-
-	if (endpoint->idtlen < 0) {
-		dev_err(endpoint->dev, "No response from FPGA. Aborting.\n");
-		return -ENODEV;
-	}
-
-	/* Enable DMA */
-	iowrite32((u32) (0x0002 | (endpoint->dma_using_dac & 0x0001)),
-		   endpoint->registers + fpga_dma_control_reg);
-
-	/* Bootstrap phase II: Allocate buffer for IDT and obtain it */
-	while (endpoint->idtlen >= idtbuffersize) {
-		idtbuffersize *= 2;
-		bogus_idt[6]++;
-	}
-
-	endpoint->num_channels = 1;
-
-	rc = xilly_setupchannels(endpoint, bogus_idt, 2);
-
-	if (rc)
-		goto failed_idt;
-
-	rc = xilly_obtain_idt(endpoint);
-
-	if (rc)
-		goto failed_idt;
-
-	xilly_scan_idt(endpoint, &idt_handle);
-
-	if (!idt_handle.chandesc) {
-		rc = -ENODEV;
-		goto failed_idt;
-	}
-
-	devres_close_group(dev, bootstrap_resources);
-
-	/* Bootstrap phase III: Allocate buffers according to IDT */
-
-	rc = xilly_setupchannels(endpoint,
-				 idt_handle.chandesc,
-				 idt_handle.entries);
-
-	if (rc)
-		goto failed_idt;
-
-	/*
-	 * endpoint is now completely configured. We put it on the list
-	 * available to open() before registering the char device(s)
-	 */
-
-	mutex_lock(&ep_list_lock);
-	list_add_tail(&endpoint->ep_list, &list_of_endpoints);
-	mutex_unlock(&ep_list_lock);
-
-	rc = xillybus_init_chrdev(endpoint, idt_handle.idt);
-
-	if (rc)
-		goto failed_chrdevs;
-
-	devres_release_group(dev, bootstrap_resources);
-
-	return 0;
-
-failed_chrdevs:
-	mutex_lock(&ep_list_lock);
-	list_del(&endpoint->ep_list);
-	mutex_unlock(&ep_list_lock);
-
-failed_idt:
-	xilly_quiesce(endpoint);
-	flush_workqueue(xillybus_wq);
-
-	return rc;
-}
-EXPORT_SYMBOL(xillybus_endpoint_discovery);
-
-void xillybus_endpoint_remove(struct xilly_endpoint *endpoint)
-{
-	xillybus_cleanup_chrdev(endpoint);
-
-	mutex_lock(&ep_list_lock);
-	list_del(&endpoint->ep_list);
-	mutex_unlock(&ep_list_lock);
-
-	xilly_quiesce(endpoint);
-
-	/*
-	 * Flushing is done upon endpoint release to prevent access to memory
-	 * just about to be released. This makes the quiesce complete.
-	 */
-	flush_workqueue(xillybus_wq);
-}
-EXPORT_SYMBOL(xillybus_endpoint_remove);
-
-static int __init xillybus_init(void)
-{
-	int rc = 0;
-
-	mutex_init(&ep_list_lock);
-
-	xillybus_class = class_create(THIS_MODULE, xillyname);
-	if (IS_ERR(xillybus_class)) {
-		rc = PTR_ERR(xillybus_class);
-		pr_warn("Failed to register class xillybus\n");
-
-		return rc;
-	}
-
-	xillybus_wq = alloc_workqueue(xillyname, 0, 0);
-	if (!xillybus_wq) {
-		class_destroy(xillybus_class);
-		rc = -ENOMEM;
-	}
-
-	return rc;
-}
-
-static void __exit xillybus_exit(void)
-{
-	/* flush_workqueue() was called for each endpoint released */
-	destroy_workqueue(xillybus_wq);
-
-	class_destroy(xillybus_class);
-}
-
-module_init(xillybus_init);
-module_exit(xillybus_exit);
diff --git a/drivers/staging/xillybus/xillybus_of.c b/drivers/staging/xillybus/xillybus_of.c
deleted file mode 100644
index e0ae234..0000000
--- a/drivers/staging/xillybus/xillybus_of.c
+++ /dev/null
@@ -1,186 +0,0 @@
-/*
- * linux/drivers/misc/xillybus_of.c
- *
- * Copyright 2011 Xillybus Ltd, http://xillybus.com
- *
- * Driver for the Xillybus FPGA/host framework using Open Firmware.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include <linux/device.h>
-#include <linux/slab.h>
-#include <linux/platform_device.h>
-#include <linux/of.h>
-#include <linux/of_irq.h>
-#include <linux/of_address.h>
-#include <linux/of_device.h>
-#include <linux/of_platform.h>
-#include <linux/err.h>
-#include "xillybus.h"
-
-MODULE_DESCRIPTION("Xillybus driver for Open Firmware");
-MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
-MODULE_VERSION("1.06");
-MODULE_ALIAS("xillybus_of");
-MODULE_LICENSE("GPL v2");
-
-static const char xillyname[] = "xillybus_of";
-
-/* Match table for of_platform binding */
-static struct of_device_id xillybus_of_match[] = {
-	{ .compatible = "xillybus,xillybus-1.00.a", },
-	{ .compatible = "xlnx,xillybus-1.00.a", }, /* Deprecated */
-	{}
-};
-
-MODULE_DEVICE_TABLE(of, xillybus_of_match);
-
-static void xilly_dma_sync_single_for_cpu_of(struct xilly_endpoint *ep,
-					     dma_addr_t dma_handle,
-					     size_t size,
-					     int direction)
-{
-	dma_sync_single_for_cpu(ep->dev, dma_handle, size, direction);
-}
-
-static void xilly_dma_sync_single_for_device_of(struct xilly_endpoint *ep,
-						dma_addr_t dma_handle,
-						size_t size,
-						int direction)
-{
-	dma_sync_single_for_device(ep->dev, dma_handle, size, direction);
-}
-
-static void xilly_dma_sync_single_nop(struct xilly_endpoint *ep,
-				      dma_addr_t dma_handle,
-				      size_t size,
-				      int direction)
-{
-}
-
-static void xilly_of_unmap(void *ptr)
-{
-	struct xilly_mapping *data = ptr;
-
-	dma_unmap_single(data->device, data->dma_addr,
-			 data->size, data->direction);
-
-	kfree(ptr);
-}
-
-static int xilly_map_single_of(struct xilly_endpoint *ep,
-			       void *ptr,
-			       size_t size,
-			       int direction,
-			       dma_addr_t *ret_dma_handle
-	)
-{
-	dma_addr_t addr;
-	struct xilly_mapping *this;
-	int rc;
-
-	this = kzalloc(sizeof(*this), GFP_KERNEL);
-	if (!this)
-		return -ENOMEM;
-
-	addr = dma_map_single(ep->dev, ptr, size, direction);
-
-	if (dma_mapping_error(ep->dev, addr)) {
-		kfree(this);
-		return -ENODEV;
-	}
-
-	this->device = ep->dev;
-	this->dma_addr = addr;
-	this->size = size;
-	this->direction = direction;
-
-	*ret_dma_handle = addr;
-
-	rc = devm_add_action(ep->dev, xilly_of_unmap, this);
-
-	if (rc) {
-		dma_unmap_single(ep->dev, addr, size, direction);
-		kfree(this);
-	}
-
-	return rc;
-}
-
-static struct xilly_endpoint_hardware of_hw = {
-	.owner = THIS_MODULE,
-	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_of,
-	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_of,
-	.map_single = xilly_map_single_of,
-};
-
-static struct xilly_endpoint_hardware of_hw_coherent = {
-	.owner = THIS_MODULE,
-	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_nop,
-	.hw_sync_sgl_for_device = xilly_dma_sync_single_nop,
-	.map_single = xilly_map_single_of,
-};
-
-static int xilly_drv_probe(struct platform_device *op)
-{
-	struct device *dev = &op->dev;
-	struct xilly_endpoint *endpoint;
-	int rc = 0;
-	int irq;
-	struct resource res;
-	struct xilly_endpoint_hardware *ephw = &of_hw;
-
-	if (of_property_read_bool(dev->of_node, "dma-coherent"))
-		ephw = &of_hw_coherent;
-
-	endpoint = xillybus_init_endpoint(NULL, dev, ephw);
-
-	if (!endpoint)
-		return -ENOMEM;
-
-	dev_set_drvdata(dev, endpoint);
-
-	rc = of_address_to_resource(dev->of_node, 0, &res);
-	endpoint->registers = devm_ioremap_resource(dev, &res);
-
-	if (IS_ERR(endpoint->registers))
-		return PTR_ERR(endpoint->registers);
-
-	irq = irq_of_parse_and_map(dev->of_node, 0);
-
-	rc = devm_request_irq(dev, irq, xillybus_isr, 0, xillyname, endpoint);
-
-	if (rc) {
-		dev_err(endpoint->dev,
-			"Failed to register IRQ handler. Aborting.\n");
-		return -ENODEV;
-	}
-
-	return xillybus_endpoint_discovery(endpoint);
-}
-
-static int xilly_drv_remove(struct platform_device *op)
-{
-	struct device *dev = &op->dev;
-	struct xilly_endpoint *endpoint = dev_get_drvdata(dev);
-
-	xillybus_endpoint_remove(endpoint);
-
-	return 0;
-}
-
-static struct platform_driver xillybus_platform_driver = {
-	.probe = xilly_drv_probe,
-	.remove = xilly_drv_remove,
-	.driver = {
-		.name = xillyname,
-		.owner = THIS_MODULE,
-		.of_match_table = xillybus_of_match,
-	},
-};
-
-module_platform_driver(xillybus_platform_driver);
diff --git a/drivers/staging/xillybus/xillybus_pcie.c b/drivers/staging/xillybus/xillybus_pcie.c
deleted file mode 100644
index 96c2c9f..0000000
--- a/drivers/staging/xillybus/xillybus_pcie.c
+++ /dev/null
@@ -1,230 +0,0 @@
-/*
- * linux/drivers/misc/xillybus_pcie.c
- *
- * Copyright 2011 Xillybus Ltd, http://xillybus.com
- *
- * Driver for the Xillybus FPGA/host framework using PCI Express.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/pci-aspm.h>
-#include <linux/slab.h>
-#include "xillybus.h"
-
-MODULE_DESCRIPTION("Xillybus driver for PCIe");
-MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
-MODULE_VERSION("1.06");
-MODULE_ALIAS("xillybus_pcie");
-MODULE_LICENSE("GPL v2");
-
-#define PCI_DEVICE_ID_XILLYBUS		0xebeb
-
-#define PCI_VENDOR_ID_ALTERA		0x1172
-#define PCI_VENDOR_ID_ACTEL		0x11aa
-#define PCI_VENDOR_ID_LATTICE		0x1204
-
-static const char xillyname[] = "xillybus_pcie";
-
-static const struct pci_device_id xillyids[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_XILINX, PCI_DEVICE_ID_XILLYBUS)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ALTERA, PCI_DEVICE_ID_XILLYBUS)},
-	{PCI_DEVICE(PCI_VENDOR_ID_ACTEL, PCI_DEVICE_ID_XILLYBUS)},
-	{PCI_DEVICE(PCI_VENDOR_ID_LATTICE, PCI_DEVICE_ID_XILLYBUS)},
-	{ /* End: all zeroes */ }
-};
-
-static int xilly_pci_direction(int direction)
-{
-	switch (direction) {
-	case DMA_TO_DEVICE:
-		return PCI_DMA_TODEVICE;
-	case DMA_FROM_DEVICE:
-		return PCI_DMA_FROMDEVICE;
-	default:
-		return PCI_DMA_BIDIRECTIONAL;
-	}
-}
-
-static void xilly_dma_sync_single_for_cpu_pci(struct xilly_endpoint *ep,
-					      dma_addr_t dma_handle,
-					      size_t size,
-					      int direction)
-{
-	pci_dma_sync_single_for_cpu(ep->pdev,
-				    dma_handle,
-				    size,
-				    xilly_pci_direction(direction));
-}
-
-static void xilly_dma_sync_single_for_device_pci(struct xilly_endpoint *ep,
-						 dma_addr_t dma_handle,
-						 size_t size,
-						 int direction)
-{
-	pci_dma_sync_single_for_device(ep->pdev,
-				       dma_handle,
-				       size,
-				       xilly_pci_direction(direction));
-}
-
-static void xilly_pci_unmap(void *ptr)
-{
-	struct xilly_mapping *data = ptr;
-
-	pci_unmap_single(data->device, data->dma_addr,
-			 data->size, data->direction);
-
-	kfree(ptr);
-}
-
-/*
- * Map either through the PCI DMA mapper or the non_PCI one. Behind the
- * scenes exactly the same functions are called with the same parameters,
- * but that can change.
- */
-
-static int xilly_map_single_pci(struct xilly_endpoint *ep,
-				void *ptr,
-				size_t size,
-				int direction,
-				dma_addr_t *ret_dma_handle
-	)
-{
-	int pci_direction;
-	dma_addr_t addr;
-	struct xilly_mapping *this;
-	int rc = 0;
-
-	this = kzalloc(sizeof(*this), GFP_KERNEL);
-	if (!this)
-		return -ENOMEM;
-
-	pci_direction = xilly_pci_direction(direction);
-
-	addr = pci_map_single(ep->pdev, ptr, size, pci_direction);
-
-	if (pci_dma_mapping_error(ep->pdev, addr)) {
-		kfree(this);
-		return -ENODEV;
-	}
-
-	this->device = ep->pdev;
-	this->dma_addr = addr;
-	this->size = size;
-	this->direction = pci_direction;
-
-	*ret_dma_handle = addr;
-
-	rc = devm_add_action(ep->dev, xilly_pci_unmap, this);
-
-	if (rc) {
-		pci_unmap_single(ep->pdev, addr, size, pci_direction);
-		kfree(this);
-	}
-
-	return rc;
-}
-
-static struct xilly_endpoint_hardware pci_hw = {
-	.owner = THIS_MODULE,
-	.hw_sync_sgl_for_cpu = xilly_dma_sync_single_for_cpu_pci,
-	.hw_sync_sgl_for_device = xilly_dma_sync_single_for_device_pci,
-	.map_single = xilly_map_single_pci,
-};
-
-static int xilly_probe(struct pci_dev *pdev,
-				 const struct pci_device_id *ent)
-{
-	struct xilly_endpoint *endpoint;
-	int rc = 0;
-
-	endpoint = xillybus_init_endpoint(pdev, &pdev->dev, &pci_hw);
-
-	if (!endpoint)
-		return -ENOMEM;
-
-	pci_set_drvdata(pdev, endpoint);
-
-	rc = pcim_enable_device(pdev);
-
-	if (rc) {
-		dev_err(endpoint->dev,
-			"pcim_enable_device() failed. Aborting.\n");
-		return rc;
-	}
-
-	/* L0s has caused packet drops. No power saving, thank you. */
-
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
-
-	if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM)) {
-		dev_err(endpoint->dev,
-			"Incorrect BAR configuration. Aborting.\n");
-		return -ENODEV;
-	}
-
-	rc = pcim_iomap_regions(pdev, 0x01, xillyname);
-	if (rc) {
-		dev_err(endpoint->dev,
-			"pcim_iomap_regions() failed. Aborting.\n");
-		return rc;
-	}
-
-	endpoint->registers = pcim_iomap_table(pdev)[0];
-
-	pci_set_master(pdev);
-
-	/* Set up a single MSI interrupt */
-	if (pci_enable_msi(pdev)) {
-		dev_err(endpoint->dev,
-			"Failed to enable MSI interrupts. Aborting.\n");
-		return -ENODEV;
-	}
-	rc = devm_request_irq(&pdev->dev, pdev->irq, xillybus_isr, 0,
-			      xillyname, endpoint);
-
-	if (rc) {
-		dev_err(endpoint->dev,
-			"Failed to register MSI handler. Aborting.\n");
-		return -ENODEV;
-	}
-
-	/*
-	 * In theory, an attempt to set the DMA mask to 64 and dma_using_dac=1
-	 * is the right thing. But some unclever PCIe drivers report it's OK
-	 * when the hardware drops those 64-bit PCIe packets. So trust
-	 * nobody and use 32 bits DMA addressing in any case.
-	 */
-
-	if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))
-		endpoint->dma_using_dac = 0;
-	else {
-		dev_err(endpoint->dev, "Failed to set DMA mask. Aborting.\n");
-		return -ENODEV;
-	}
-
-	return xillybus_endpoint_discovery(endpoint);
-}
-
-static void xilly_remove(struct pci_dev *pdev)
-{
-	struct xilly_endpoint *endpoint = pci_get_drvdata(pdev);
-
-	xillybus_endpoint_remove(endpoint);
-}
-
-MODULE_DEVICE_TABLE(pci, xillyids);
-
-static struct pci_driver xillybus_driver = {
-	.name = xillyname,
-	.id_table = xillyids,
-	.probe = xilly_probe,
-	.remove = xilly_remove,
-};
-
-module_pci_driver(xillybus_driver);
-- 
1.7.2.3

