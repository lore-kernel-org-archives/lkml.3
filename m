Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaCGBBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:01:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaCGBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:01:13 -0500
Date: Thu, 6 Mar 2014 17:00:54 -0800
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-b807902a88c470eb06d0acdf3b6590f27f5dce81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20140206144321.409045251@goodmis.org>
References: <20140206144321.409045251@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/threadinfo] x86: Nuke GET_THREAD_INFO_WITH_ESP()
  macro for i386
Git-Commit-ID: b807902a88c470eb06d0acdf3b6590f27f5dce81
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b807902a88c470eb06d0acdf3b6590f27f5dce81
Gitweb:     http://git.kernel.org/tip/b807902a88c470eb06d0acdf3b6590f27f5dce81
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Thu, 6 Feb 2014 09:41:29 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 16:56:54 -0800

x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386

According to a git log -p, GET_THREAD_INFO_WITH_ESP() has only been defined
and never been used. Get rid of it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140206144321.409045251@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index b7aa975..1cb3501 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -182,10 +182,6 @@ static inline struct thread_info *current_thread_info(void)
 	movl $-THREAD_SIZE, reg; \
 	andl %esp, reg
 
-/* use this one if reg already contains %esp */
-#define GET_THREAD_INFO_WITH_ESP(reg) \
-	andl $-THREAD_SIZE, reg
-
 #endif
 
 #else /* X86_32 */
