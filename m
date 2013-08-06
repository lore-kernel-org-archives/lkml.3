Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab3HFVn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:43:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43489 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3HFVnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:43:23 -0400
Date: Tue, 6 Aug 2013 14:43:13 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a1ed4ddfb780910c1bb1e9df9cfc87454b607489@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1375740170-7446-5-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] x86, asmlinkage:
  Make _*_start_kernel visible
Git-Commit-ID: a1ed4ddfb780910c1bb1e9df9cfc87454b607489
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 06 Aug 2013 14:43:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1ed4ddfb780910c1bb1e9df9cfc87454b607489
Gitweb:     http://git.kernel.org/tip/a1ed4ddfb780910c1bb1e9df9cfc87454b607489
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Mon, 5 Aug 2013 15:02:38 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 6 Aug 2013 14:18:26 -0700

x86, asmlinkage: Make _*_start_kernel visible

Obviously these functions have to be visible, otherwise
the whole kernel could be optimized away.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1375740170-7446-5-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
