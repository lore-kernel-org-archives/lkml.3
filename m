Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaCMWhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:37:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaCMWhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:37:00 -0400
Date: Thu, 13 Mar 2014 15:36:41 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-3e920b532a0f49d05e4c0f7d1b46b0ab8f471e09@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com
In-Reply-To: <1394633584-5509-2-git-send-email-bp@alien8.de>
References: <1394633584-5509-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86, boot: Correct max ramdisk size name
Git-Commit-ID: 3e920b532a0f49d05e4c0f7d1b46b0ab8f471e09
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e920b532a0f49d05e4c0f7d1b46b0ab8f471e09
Gitweb:     http://git.kernel.org/tip/3e920b532a0f49d05e4c0f7d1b46b0ab8f471e09
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 12 Mar 2014 15:13:02 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Mar 2014 15:32:42 -0700

x86, boot: Correct max ramdisk size name

The name in struct bootparam is ->initrd_addr_max and not ramdisk_max.
Fix that.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1394633584-5509-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/x86/boot.txt | 4 ++--
 arch/x86/boot/header.S     | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index cb81741d..a75e3ad 100644
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
index ec3b8ba..46f5a22 100644
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
