Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab3HEWDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:48791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3HEWC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="357994048"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/16] x86, asmlinkage: Make _*_start_kernel visible
Date: Mon,  5 Aug 2013 15:02:38 -0700
Message-Id: <1375740170-7446-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Obviously these functions have to be visible, otherwise
the whole kernel could be optimized away.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/setup.h | 8 +++++---
 arch/x86/kernel/head32.c     | 2 +-
 arch/x86/kernel/head64.c     | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..3475554 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -6,6 +6,8 @@
 
 #define COMMAND_LINE_SIZE 2048
 
+#include <linux/linkage.h>
+
 #ifdef __i386__
 
 #include <linux/pfn.h>
@@ -108,11 +110,11 @@ void *extend_brk(size_t size, size_t align);
 extern void probe_roms(void);
 #ifdef __i386__
 
-void __init i386_start_kernel(void);
+asmlinkage void __init i386_start_kernel(void);
 
 #else
-void __init x86_64_start_kernel(char *real_mode);
-void __init x86_64_start_reservations(char *real_mode_data);
+asmlinkage void __init x86_64_start_kernel(char *real_mode);
+asmlinkage void __init x86_64_start_reservations(char *real_mode_data);
 
 #endif /* __i386__ */
 #endif /* _SETUP */
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 138463a..06f87be 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,7 +29,7 @@ static void __init i386_default_early_setup(void)
 	reserve_ebda_region();
 }
 
-void __init i386_start_kernel(void)
+asmlinkage void __init i386_start_kernel(void)
 {
 	sanitize_boot_params(&boot_params);
 
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 55b6761..1be8e43 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -137,7 +137,7 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-void __init x86_64_start_kernel(char * real_mode_data)
+asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
 {
 	int i;
 
-- 
1.8.3.1

