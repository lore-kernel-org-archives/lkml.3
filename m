Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaG2XMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:12:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:29589 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaG2XMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:12:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,760,1400050800"; 
   d="scan'208";a="550957854"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] Kbuild: Add a option to enable dwarf4
Date: Wed, 30 Jul 2014 01:11:33 +0200
Message-Id: <1406675493-2539-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
References: <1406675493-2539-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I found that a lot of unresolvable variables when using gdb on the kernel
become resolvable when dwarf4 is enabled. So add a Kconfig flag to enable it.

It definitely increases the debug information size, but on the other
hand this isn't so bad when debug fusion is used.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Makefile          | 3 +++
 lib/Kconfig.debug | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/Makefile b/Makefile
index 6a717cd..6cdf3f0 100644
--- a/Makefile
+++ b/Makefile
@@ -696,6 +696,9 @@ KBUILD_CFLAGS	+= -g
 endif
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
+ifdef CONFIG_DEBUG_INFO_DWARF4
+KBUILD_CFLAGS	+= -gdwarf-4
+endif
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
 KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 0360468..a2dcf97 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -158,6 +158,15 @@ config DEBUG_INFO_SPLIT
 	  to know about the .dwo files and include them.
 	  Incompatible with older versions of ccache.
 
+config DEBUG_INFO_DWARF4
+	bool "Generate dwarf4 debuginfo"
+	depends on DEBUG_INFO
+	help
+	  Generate dwarf4 debug info. This requires recent versions
+	  of gcc and gdb. It makes the debug information larger.
+	  But it significantly improves the success of resolving
+	  variables in gdb on optimized code.
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
 	default y
-- 
1.8.5.2

