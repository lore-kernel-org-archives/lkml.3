Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaJYSc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 14:32:56 -0400
Received: from eddie.linux-mips.org ([148.251.95.138]:44491 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJYScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 14:32:53 -0400
Date: Sat, 25 Oct 2014 17:03:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] doc: kernel-parameters.txt: Add ide-generic.probe-mask
Message-ID: <alpine.LFD.2.11.1410251638230.21390@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Not much to say beyond the subject.  Noticed while fiddling with a plain 
ISA multi-I/O card (remember those?) having a single IDE channel only, as 
usually with them, to avoid errors like:

ide1: unexpected interrupt, status=0xff, count=11

popping up in the kernel log -- presumably coming from noise on the 
floating IRQ15 line or maybe spurious interrupts triggered by another 
device (the slave 8259A delivers them like IRQ15 and they can be told 
apart by internal PIC status, but we don't check it if the line is 
enabled, for performance reasons).

 Please apply.

  Maciej

linux-doc-ide-generic.patch
Index: linux-3.16-dolch/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.16-dolch.orig/Documentation/kernel-parameters.txt
+++ linux-3.16-dolch/Documentation/kernel-parameters.txt
@@ -1263,6 +1263,17 @@ bytes respectively. Such letter suffixes
 			.cdrom .chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
+	ide-generic.probe-mask= [HW] (E)IDE subsystem
+			Format: <int>
+			Probe mask for legacy ISA IDE ports.  Depending on
+			platform up to 6 ports are supported, enabled by
+			setting corresponding bits in the mask to 1.  The
+			default value is 0x0, that is special and on systems
+			that have PCI triggers scanning the PCI bus for the
+			first and the second port, which are then probed.
+			On systems without PCI the value of 0x0 enables
+			probing the two first ports as if it was 0x3.
+
 	ide-pci-generic.all-generic-ide [HW] (E)IDE subsystem
 			Claim all unknown PCI IDE storage controllers.
 
