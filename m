Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573Ab3DKMTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:19:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3DKMTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:19:49 -0400
Date: Thu, 11 Apr 2013 05:19:23 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-147ea09119e45caf2e8bf57c9e54cc930ccfeda9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        catalin.marinas@arm.com, dave@sr71.net, tglx@linutronix.de,
        dave.hansen@linux.intel.com, rob@landley.net
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, dave@sr71.net, tglx@linutronix.de,
        dave.hansen@linux.intel.com, rob@landley.net
In-Reply-To: <20130410210338.E2930E98@viggo.jf.intel.com>
References: <20130410210338.E2930E98@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, early-printk:
  Update earlyprintk documentation (and kill x86 copy)
Git-Commit-ID: 147ea09119e45caf2e8bf57c9e54cc930ccfeda9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 11 Apr 2013 05:19:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  147ea09119e45caf2e8bf57c9e54cc930ccfeda9
Gitweb:     http://git.kernel.org/tip/147ea09119e45caf2e8bf57c9e54cc930ccfeda9
Author:     Dave Hansen <dave@sr71.net>
AuthorDate: Wed, 10 Apr 2013 14:03:38 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Apr 2013 10:30:40 +0200

x86, early-printk: Update earlyprintk documentation (and kill x86 copy)

Documentation/kernel-parameters.txt and
Documentation/x86/x86_64/boot-options.txt contain virtually
identical text describing earlyprintk.

This consolidates the two copies and updates the documentation a
bit.  No one ever documented the:

	earlyprintk=serial,0x1008,115200

syntax, nor mentioned that ARM is now a supported earlyprintk
arch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rob Landley <rob@landley.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20130410210338.E2930E98@viggo.jf.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/kernel-parameters.txt       | 16 ++++++++++++++--
 Documentation/x86/x86_64/boot-options.txt | 14 --------------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..b5cfd04 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -757,19 +757,31 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index e015a83..e9e8ddb 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
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
