Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3LJILC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:11:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3LJICV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. J. Lu" <hjl.tools@gmail.com>
Subject: [PATCH 3.12 48/62] x86-64, build: Always pass in -mno-sse
Date: Tue, 10 Dec 2013 00:01:19 -0800
Message-Id: <20131210080100.789539382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/Makefile |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

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


