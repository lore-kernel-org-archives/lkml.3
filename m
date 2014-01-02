Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaABRNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:13:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaABRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:10:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "H. J. Lu" <hjl.tools@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 90/91] x86-64, build: Always pass in -mno-sse
Date: Thu,  2 Jan 2014 09:05:05 -0800
Message-Id: <1388682306-30859-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 5551a34e5aeab868f8d37f70d8754868921b4ee5 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/Makefile | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e71fc42..8c2ad4e 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -27,6 +27,9 @@ ifeq ($(CONFIG_X86_32),y)
 
         KBUILD_CFLAGS += -msoft-float -mregparm=3 -freg-struct-return
 
+        # Don't autogenerate SSE instructions
+	KBUILD_CFLAGS += -mno-sse
+
         # Never want PIC in a 32-bit kernel, prevent breakage with GCC built
         # with nonstandard options
         KBUILD_CFLAGS += -fno-pic
@@ -53,8 +56,11 @@ else
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
-- 
1.8.3.2

