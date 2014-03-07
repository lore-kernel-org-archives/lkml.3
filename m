Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaCGWlN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:41:13 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34244 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaCGWlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:41:11 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, boot: Correct max ramdisk size name
Date: Fri,  7 Mar 2014 23:40:57 +0100
Message-Id: <1394232057-31359-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The name in struct bootparam is ->initrd_addr_max and not ramdisk_max.
Fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 Documentation/x86/boot.txt | 4 ++--
 arch/x86/boot/header.S     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index cb81741d3b0b..a75e3adaa39d 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -182,7 +182,7 @@ Offset	Proto	Name		Meaning
 0226/1	2.02+(3 ext_loader_ver	Extended boot loader version
 0227/1	2.02+(3	ext_loader_type	Extended boot loader ID
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
-022C/4	2.03+	ramdisk_max	Highest legal initrd address
+022C/4	2.03+	initrd_addr_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
 0235/1	2.10+	min_alignment	Minimum alignment, as a power of two
@@ -534,7 +534,7 @@ Protocol:	2.02+
   zero, the kernel will assume that your boot loader does not support
   the 2.02+ protocol.
 
-Field name:	ramdisk_max
+Field name:	initrd_addr_max
 Type:		read
 Offset/size:	0x22c/4
 Protocol:	2.03+
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index ec3b8ba68096..46f5a220b0ad 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -350,7 +350,7 @@ cmd_line_ptr:	.long	0		# (Header version 0x0202 or later)
 					# can be located anywhere in
 					# low memory 0x10000 or higher.
 
-ramdisk_max:	.long 0x7fffffff
+initrd_addr_max: .long 0x7fffffff
 					# (Header version 0x0203 or later)
 					# The highest safe address for
 					# the contents of an initrd
-- 
1.9.0

