Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbaGRFZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 01:25:12 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:51328 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaGRFZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:25:10 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: Fix me add register r8
Date: Fri, 18 Jul 2014 01:25:02 -0400
Message-Id: <1405661102-11967-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function user_stack_pointer was not returning the correct value \
as stated by a Fix Me message before the function declaration. I
fixed the return value to add register r8 as that register stores
dirty pages.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 arch/ia64/include/asm/ptrace.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/ia64/include/asm/ptrace.h b/arch/ia64/include/asm/ptrace.h
index 8451439..eaef692 100644
--- a/arch/ia64/include/asm/ptrace.h
+++ b/arch/ia64/include/asm/ptrace.h
@@ -53,8 +53,7 @@
 
 static inline unsigned long user_stack_pointer(struct pt_regs *regs)
 {
-	/* FIXME: should this be bspstore + nr_dirty regs? */
-	return regs->ar_bspstore;
+	return regs->ar_bspstore + regs->r8;
 }
 
 static inline int is_syscall_success(struct pt_regs *regs)
-- 
1.9.1

