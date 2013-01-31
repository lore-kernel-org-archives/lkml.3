Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3AaWgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:36:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab3AaWgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:36:03 -0500
Date: Thu, 31 Jan 2013 14:35:52 -0800
From: tip-bot for Fenghua Yu <fenghua.yu@intel.com>
Message-ID: <tip-feddc9de8bf69415da6f96eca0219186b70d145a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1356075872-3054-11-git-send-email-fenghua.yu@intel.com>
References: <1356075872-3054-11-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86/head64.c: Early update ucode in 64-bit
Git-Commit-ID: feddc9de8bf69415da6f96eca0219186b70d145a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 14:35:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  feddc9de8bf69415da6f96eca0219186b70d145a
Gitweb:     http://git.kernel.org/tip/feddc9de8bf69415da6f96eca0219186b70d145a
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Dec 2012 23:44:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jan 2013 13:20:24 -0800

x86/head64.c: Early update ucode in 64-bit

This updates ucode on BSP in 64-bit mode. Paging and virtual address are
working now.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1356075872-3054-11-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head64.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 57334f4..3ff3570 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -26,6 +26,7 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 #include <asm/bootparam_utils.h>
+#include <asm/microcode.h>
 
 /*
  * Manage page tables very early on.
@@ -170,6 +171,11 @@ void __init x86_64_start_kernel(char * real_mode_data)
 
 	copy_bootdata(__va(real_mode_data));
 
+	/*
+	 * Load microcode early on BSP.
+	 */
+	load_ucode_bsp();
+
 	if (console_loglevel == 10)
 		early_printk("Kernel alive\n");
 
