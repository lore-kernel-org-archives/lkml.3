Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaCGBBy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 20:01:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53397 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaCGBBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 20:01:50 -0500
Date: Thu, 6 Mar 2014 17:00:42 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-2432e1364bbee83cb6e63e026c91785031704ba5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        brgerst@gmail.com, peterz@infradead.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, peterz@infradead.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20140206144321.203619611@goodmis.org>
References: <20110806012353.546183789@goodmis.org>
	<20140206144321.203619611@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/threadinfo] x86:
  Nuke the supervisor_stack field in i386 thread_info
Git-Commit-ID: 2432e1364bbee83cb6e63e026c91785031704ba5
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

Commit-ID:  2432e1364bbee83cb6e63e026c91785031704ba5
Gitweb:     http://git.kernel.org/tip/2432e1364bbee83cb6e63e026c91785031704ba5
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Thu, 6 Feb 2014 09:41:28 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 6 Mar 2014 16:56:54 -0800

x86: Nuke the supervisor_stack field in i386 thread_info

Nothing references the supervisor_stack in the thread_info field,
and it does not exist in x86_64. To make the two more the same,
it is being removed.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20110806012353.546183789@goodmis.org
Link: http://lkml.kernel.org/r/20140206144321.203619611@goodmis.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e1940c0..b7aa975 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -36,7 +36,6 @@ struct thread_info {
 	unsigned long           previous_esp;   /* ESP of the previous stack in
 						   case of nested (IRQ) stacks
 						*/
-	__u8			supervisor_stack[0];
 #endif
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
