Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaBFOn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:43:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52064 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720AbaBFOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:23 -0500
Message-Id: <20140206144321.409045251@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 09:41:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/5] x86: Nuke GET_THREAD_INFO_WITH_ESP() macro for i386
References: <20140206144127.181568017@goodmis.org>
Content-Disposition: inline; filename=0002-x86-Nuke-GET_THREAD_INFO_WITH_ESP-macro-for-i386.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

According to a git log -p, GET_THREAD_INFO_WITH_ESP() has only been defined
and never been used. Get rid of it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/thread_info.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e012ed0..ee029e4 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -180,10 +180,6 @@ static inline struct thread_info *current_thread_info(void)
 	movl $-THREAD_SIZE, reg; \
 	andl %esp, reg
 
-/* use this one if reg already contains %esp */
-#define GET_THREAD_INFO_WITH_ESP(reg) \
-	andl $-THREAD_SIZE, reg
-
 #endif
 
 #else /* X86_32 */
-- 
1.8.4.3


