Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3LDBnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 20:43:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3LDBnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 20:43:16 -0500
Date: Tue, 3 Dec 2013 17:42:56 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-j21wzqv790q834n7yc6g80j1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com,
        kevin.b.smith@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, kevin.b.smith@intel.com,
        hjl.tools@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, build: Always pass in -mno-sse
Git-Commit-ID: 5551a34e5aeab868f8d37f70d8754868921b4ee5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 03 Dec 2013 17:43:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5551a34e5aeab868f8d37f70d8754868921b4ee5
Gitweb:     http://git.kernel.org/tip/5551a34e5aeab868f8d37f70d8754868921b4ee5
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 20 Nov 2013 13:31:49 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 3 Dec 2013 17:40:22 -0800

x86-64, build: Always pass in -mno-sse

Always pass in the -mno-sse argument, regardless if
-preferred-stack-boundary is supported.  We never want to generate SSE
instructions in the kernel unless we *really* know what we're doing.

According to H. J. Lu, any version of gcc new enough that we support
it at all should handle the -mno-sse option, so just add it
unconditionally.

Reported-by: Kevin B. Smith <kevin.b.smith@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/n/tip-j21wzqv790q834n7yc6g80j1@git.kernel.org
Cc: <stable@vger.kernel.org> # build fix only
---
 arch/x86/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 41250fb..eda00f9 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -31,6 +31,9 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
+        # Don't autogenerate SSE instructions
+	KBUILD_CFLAGS += -mno-sse
+
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
         KBUILD_CFLAGS += -fno-pic
@@ -57,8 +60,11 @@ else
         KBUILD_AFLAGS += -m64
         KBUILD_CFLAGS += -m64
 
+        # Don't autogenerate SSE instructions
+	KBUILD_CFLAGS += -mno-sse
+
 	# Use -mpreferred-stack-boundary=3 if supported.
-	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
+	KBUILD_CFLAGS += $(call cc-option,-mpreferred-stack-boundary=3)
 
         # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
         cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
