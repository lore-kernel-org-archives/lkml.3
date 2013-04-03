Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3DCASw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:18:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59665 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab3DCASu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:18:50 -0400
Date: Tue, 2 Apr 2013 17:18:24 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-8e3c2a8cf647e2f3a1e9d38009b0d1c02145822f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, bp@alien8.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@alien8.de, hpa@linux.intel.com
In-Reply-To: <1362428180-8865-3-git-send-email-bp@alien8.de>
References: <1362428180-8865-3-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Drop KERNEL_IMAGE_START
Git-Commit-ID: 8e3c2a8cf647e2f3a1e9d38009b0d1c02145822f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 17:18:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e3c2a8cf647e2f3a1e9d38009b0d1c02145822f
Gitweb:     http://git.kernel.org/tip/8e3c2a8cf647e2f3a1e9d38009b0d1c02145822f
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 4 Mar 2013 21:16:17 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Apr 2013 16:03:29 -0700

x86: Drop KERNEL_IMAGE_START

We have KERNEL_IMAGE_START and __START_KERNEL_map which both contain the
start of the kernel text mapping's virtual address. Remove the prior one
which has been replicated a lot less times around the tree.

No functionality change.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1362428180-8865-3-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page_64_types.h | 1 -
 arch/x86/kernel/head64.c             | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 8b491e6..6c896fb 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -48,6 +48,5 @@
  * arch/x86/kernel/head_64.S), and it is mapped here:
  */
 #define KERNEL_IMAGE_SIZE	(512 * 1024 * 1024)
-#define KERNEL_IMAGE_START	_AC(0xffffffff80000000, UL)
 
 #endif /* _ASM_X86_PAGE_64_DEFS_H */
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index c5e403f..101ac1a9 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -144,10 +144,10 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	 * Build-time sanity checks on the kernel image and module
 	 * area mappings. (these are purely build-time and produce no code)
 	 */
-	BUILD_BUG_ON(MODULES_VADDR < KERNEL_IMAGE_START);
-	BUILD_BUG_ON(MODULES_VADDR-KERNEL_IMAGE_START < KERNEL_IMAGE_SIZE);
+	BUILD_BUG_ON(MODULES_VADDR < __START_KERNEL_map);
+	BUILD_BUG_ON(MODULES_VADDR - __START_KERNEL_map < KERNEL_IMAGE_SIZE);
 	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
-	BUILD_BUG_ON((KERNEL_IMAGE_START & ~PMD_MASK) != 0);
+	BUILD_BUG_ON((__START_KERNEL_map & ~PMD_MASK) != 0);
 	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
