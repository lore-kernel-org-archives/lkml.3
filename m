Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3AaWez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:34:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44978 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3AaWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:34:54 -0500
Date: Thu, 31 Jan 2013 14:34:42 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-63b553c68db5a8d4febcd1010b194333d2b02e1c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-10-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-10-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/head_32.S: Early update ucode in 32-bit
Git-Commit-ID: 63b553c68db5a8d4febcd1010b194333d2b02e1c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:34:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  63b553c68db5a8d4febcd1010b194333d2b02e1c
Gitweb:     http://git.kernel.org/tip/63b553c68db5a8d4febcd1010b194333d2b02e1c
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:29 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:19:20 -0800

x86/head_32.S: Early update ucode in 32-bit

This updates ucode in 32-bit kernel on BSP and AP. At this point, there is no
paging and no virtual address yet.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-10-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head_32.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8e7f655..2f70530 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -144,6 +144,11 @@ ENTRY(startup_32)
 	movl %eax, pa(olpc_ofw_pgd)
 #endif
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on BSP. */
+	call load_ucode_bsp
+#endif
+
 /*
  * Initialize page tables.  This creates a PDE and a set of page
  * tables, which are located immediately beyond __brk_base.  The variable
@@ -299,6 +304,12 @@ ENTRY(startup_32_smp)
 	movl %eax,%ss
 	leal -__PAGE_OFFSET(%ecx),%esp
 
+#ifdef CONFIG_MICROCODE_EARLY
+	/* Early load ucode on AP. */
+	call load_ucode_ap
+#endif
+
+
 default_entry:
 /*
  *	New page tables may be in 4Mbyte page mode and may
