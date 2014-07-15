Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbaGOXRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:17:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:13406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755932AbaGOXRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:17:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,668,1400050800"; 
   d="scan'208";a="573734246"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] Kbuild: Add a option to enable dwarf4
Date: Wed, 16 Jul 2014 01:16:12 +0200
Message-Id: <1405466172-17055-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
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
index 953659e..9c4080b 100644
--- a/Makefile
+++ b/Makefile
@@ -690,6 +690,9 @@ KBUILD_CFLAGS	+= -g
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 endif
+ifdef CONFIG_DEBUG_INFO_DWARF4
+KBUILD_CFLAGS	+= -gdwarf-4
+endif
 
 ifdef CONFIG_DEBUG_INFO_REDUCED
 KBUILD_CFLAGS 	+= $(call cc-option, -femit-struct-debug-baseonly) \
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index fb07c33..1af4d96 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -156,6 +156,15 @@ config DEBUG_INFO_SPLIT
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

