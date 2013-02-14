Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962Ab3BNVDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:03:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761666Ab3BNVDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:03:12 -0500
Date: Thu, 14 Feb 2013 13:01:58 -0800
From: tip-bot for Paul Gortmaker <paul.gortmaker@windriver.com>
Message-ID: <tip-19348e749e9515c429f5d561d2f2c724862a4bee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        trivial@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        paul.gortmaker@windriver.com
In-Reply-To: <1360872842-28417-1-git-send-email-paul.gortmaker@windriver.com>
References: <1360872842-28417-1-git-send-email-paul.gortmaker@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86:
  ptrace.c only needs export.h and not the full module.h
Git-Commit-ID: 19348e749e9515c429f5d561d2f2c724862a4bee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 14 Feb 2013 13:02:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19348e749e9515c429f5d561d2f2c724862a4bee
Gitweb:     http://git.kernel.org/tip/19348e749e9515c429f5d561d2f2c724862a4bee
Author:     Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate: Thu, 14 Feb 2013 15:14:02 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Feb 2013 12:56:12 -0800

x86: ptrace.c only needs export.h and not the full module.h

Commit cb57a2b4cff7edf2a4e32c0163200e9434807e0a ("x86-32: Export
kernel_stack_pointer() for modules") added an include of the
module.h header in conjunction with adding an EXPORT_SYMBOL_GPL
of kernel_stack_pointer.

But module.h should be avoided for simple exports, since it in turn
includes the world.  Swap the module.h for export.h instead.

Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Link: http://lkml.kernel.org/r/1360872842-28417-1-git-send-email-paul.gortmaker@windriver.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
