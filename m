Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279Ab3LVKcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 05:32:10 -0500
Received: from shell.v3.sk ([195.168.3.45]:57479 "EHLO shell.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab3LVKcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 05:32:08 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Rob Landley <rob@landley.net>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Bernhard Kaindl <bk@suse.de>
Subject: [PATCH] docs: Update FireWire debugging documentation
Date: Sun, 22 Dec 2013 11:31:41 +0100
Message-Id: <1387708301-12048-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old firewire stack is long dead now and a new version firescope has been
released with support for current kernels.

Cc: Rob Landley <rob@landley.net>
Cc: Justin P. Mattock <justinmattock@gmail.com>
Cc: Bernhard Kaindl <bk@suse.de>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 Documentation/debugging-via-ohci1394.txt   | 24 +++++++++---------------
 Documentation/power/basic-pm-debugging.txt |  2 +-
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/Documentation/debugging-via-ohci1394.txt b/Documentation/debugging-via-ohci1394.txt
index 611f5a5..14d1944 100644
--- a/Documentation/debugging-via-ohci1394.txt
+++ b/Documentation/debugging-via-ohci1394.txt
@@ -36,17 +36,13 @@ available (notebooks) or too slow for extensive debug information (like ACPI).
 Drivers
 -------
 
-The ohci1394 driver in drivers/ieee1394 initializes the OHCI-1394 controllers
-to a working state and enables physical DMA by default for all remote nodes.
-This can be turned off by ohci1394's module parameter phys_dma=0.
-
-The alternative firewire-ohci driver in drivers/firewire uses filtered physical
+The firewire-ohci driver in drivers/firewire uses filtered physical
 DMA by default, which is more secure but not suitable for remote debugging.
 Compile the driver with CONFIG_FIREWIRE_OHCI_REMOTE_DMA (Kernel hacking menu:
 Remote debugging over FireWire with firewire-ohci) to get unfiltered physical
 DMA.
 
-Because ohci1394 and firewire-ohci depend on the PCI enumeration to be
+Because the firewire-ohci driver depends on the PCI enumeration to be
 completed, an initialization routine which runs pretty early has been
 implemented for x86.  This routine runs long before console_init() can be
 called, i.e. before the printk buffer appears on the console.
@@ -64,7 +60,7 @@ be used to view the printk buffer of a remote machine, even with live update.
 
 Bernhard Kaindl enhanced firescope to support accessing 64-bit machines
 from 32-bit firescope and vice versa:
-- http://halobates.de/firewire/firescope-0.2.2.tar.bz2
+- http://v3.sk/~lkundrak/firescope/
 
 and he implemented fast system dump (alpha version - read README.txt):
 - http://halobates.de/firewire/firedump-0.1.tar.bz2
@@ -92,11 +88,11 @@ Step-by-step instructions for using firescope with early OHCI initialization:
 
 1) Verify that your hardware is supported:
 
-   Load the ohci1394 or the fw-ohci module and check your kernel logs.
+   Load the firewire-ohci module and check your kernel logs.
    You should see a line similar to
 
-   ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[18]  MMIO=[fe9ff800-fe9fffff]
-   ... Max Packet=[2048]  IR/IT contexts=[4/8]
+   firewire_ohci 0000:15:00.1: added OHCI v1.0 device as card 2, 4 IR + 4 IT
+   ... contexts, quirks 0x11
 
    when loading the driver. If you have no supported controller, many PCI,
    CardBus and even some Express cards which are fully compliant to OHCI-1394
@@ -113,20 +109,18 @@ Step-by-step instructions for using firescope with early OHCI initialization:
 
    If an driver is running on both machines you should see a line like
 
-   ieee1394: Node added: ID:BUS[0-01:1023]  GUID[0090270001b84bba]
+   firewire_core 0000:15:00.1: created device fw1: GUID 00061b0020105917, S400
 
    on both machines in the kernel log when the cable is plugged in
    and connects the two machines.
 
 3) Test physical DMA using firescope:
 
-   On the debug host,
-	- load the raw1394 module,
-	- make sure that /dev/raw1394 is accessible,
+   On the debug host, make sure that /dev/fw* is accessible,
    then start firescope:
 
 	$ firescope
-	Port 0 (ohci1394) opened, 2 nodes detected
+	Port 0 (/dev/fw1) opened, 2 nodes detected
 
 	FireScope
 	---------
diff --git a/Documentation/power/basic-pm-debugging.txt b/Documentation/power/basic-pm-debugging.txt
index e9b54de8..edeecd4 100644
--- a/Documentation/power/basic-pm-debugging.txt
+++ b/Documentation/power/basic-pm-debugging.txt
@@ -172,7 +172,7 @@ you can boot the kernel with the 'no_console_suspend' parameter and try to log
 kernel messages using the serial console.  This may provide you with some
 information about the reasons of the suspend (resume) failure.  Alternatively,
 it may be possible to use a FireWire port for debugging with firescope
-(ftp://ftp.firstfloor.org/pub/ak/firescope/).  On x86 it is also possible to
+(http://v3.sk/~lkundrak/firescope/).  On x86 it is also possible to
 use the PM_TRACE mechanism documented in Documentation/power/s2ram.txt .
 
 2. Testing suspend to RAM (STR)
-- 
1.8.4.2

