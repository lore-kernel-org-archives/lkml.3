Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab3DJVIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:08:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:42053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3DJVIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:08:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="284474554"
Subject: [PATCH] update earlyprintk documentation (and kill x86 copy)
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org, x86@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 10 Apr 2013 14:03:38 -0700
Message-Id: <20130410210338.E2930E98@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Documentation/kernel-parameters.txt and
Documentation/x86/x86_64/boot-options.txt contain virtually identical
text describing earlyprintk.

This consolidates the two copies and updates the documentation a
bit.  No one ever documented the:

	earlyprintk=serial,0x1008,115200

syntax, nor mentioned that ARM is now a supported earlyprintk arch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 linux.git-davehans/Documentation/kernel-parameters.txt       |   16 +++++++++--
 linux.git-davehans/Documentation/x86/x86_64/boot-options.txt |   14 ---------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff -puN Documentation/kernel-parameters.txt~early-printk-morettys Documentation/kernel-parameters.txt
--- linux.git/Documentation/kernel-parameters.txt~early-printk-morettys	2013-04-10 13:30:37.422949520 -0700
+++ linux.git-davehans/Documentation/kernel-parameters.txt	2013-04-10 13:30:37.428949526 -0700
@@ -757,19 +757,31 @@ bytes respectively. Such letter suffixes
 			(mmio) or 32-bit (mmio32).
 			The options are the same as for ttyS, above.
 
-	earlyprintk=	[X86,SH,BLACKFIN]
+	earlyprintk=	[X86,SH,BLACKFIN,ARM]
 			earlyprintk=vga
 			earlyprintk=xen
 			earlyprintk=serial[,ttySn[,baudrate]]
+			earlyprintk=serial[,0x...[,baudrate]]
 			earlyprintk=ttySn[,baudrate]
 			earlyprintk=dbgp[debugController#]
 
+			earlyprintk is useful when the kernel crashes before
+			the normal console is initialized. It is not enabled by
+			default because it has some cosmetic problems.
+
 			Append ",keep" to not disable it when the real console
 			takes over.
 
 			Only vga or serial or usb debug port at a time.
 
-			Currently only ttyS0 and ttyS1 are supported.
+			Currently only ttyS0 and ttyS1 may be specified by
+			name.  Other I/O ports may be explicitly specified
+			on some architectures (x86 and arm at least) by
+			replacing ttySn with an I/O port address, like this:
+				earlyprintk=serial,0x1008,115200
+			You can find the port for a given device in
+			/proc/tty/driver/serial:
+				2: uart:ST16650V2 port:00001008 irq:18 ...
 
 			Interaction with the standard serial driver is not
 			very good.
diff -puN Documentation/x86/x86_64/boot-options.txt~early-printk-morettys Documentation/x86/x86_64/boot-options.txt
--- linux.git/Documentation/x86/x86_64/boot-options.txt~early-printk-morettys	2013-04-10 13:30:37.424949522 -0700
+++ linux.git-davehans/Documentation/x86/x86_64/boot-options.txt	2013-04-10 13:30:37.428949526 -0700
@@ -91,20 +91,6 @@ APICs
 		 apicmaintimer. Useful when your PIT timer is totally
 		 broken.
 
-Early Console
-
-   syntax: earlyprintk=vga
-           earlyprintk=serial[,ttySn[,baudrate]]
-
-   The early console is useful when the kernel crashes before the
-   normal console is initialized. It is not enabled by
-   default because it has some cosmetic problems.
-   Append ,keep to not disable it when the real console takes over.
-   Only vga or serial at a time, not both.
-   Currently only ttyS0 and ttyS1 are supported.
-   Interaction with the standard serial driver is not very good.
-   The VGA output is eventually overwritten by the real console.
-
 Timing
 
   notsc
_
