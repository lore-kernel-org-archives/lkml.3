Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917Ab3BNUPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:15:13 -0500
Received: from mail1.windriver.com ([147.11.146.13]:58561 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3BNUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:15:11 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <x86@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] x86: ptrace.c only needs export.h and not the full module.h
Date: Thu, 14 Feb 2013 15:14:02 -0500
Message-ID: <1360872842-28417-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a ("x86-32: Export
kernel_stack_pointer() for modules") added an include of the
module.h header in conjunction with adding an EXPORT_SYMBOL_GPL
of kernel_stack_pointer.

But module.h should be avoided for simple exports, since it in turn
includes the world.  Swap the module.h for export.h instead.

Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[I didn't see this in tip/auto-latest so vectoring it via trivial]

 arch/x86/kernel/ptrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b629bbe..29a8120 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,7 +22,7 @@
 #include <linux/perf_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/rcupdate.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/context_tracking.h>
 
 #include <asm/uaccess.h>
-- 
1.8.1.2

