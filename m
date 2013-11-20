Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3KTWA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 17:00:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3KTWAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 17:00:53 -0500
Date: Wed, 20 Nov 2013 14:00:32 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-661c80192d21269c7fc566f1d547510b0c867677@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, fenghua.yu@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64, copy_user:
  Use leal to produce 32-bit results
Git-Commit-ID: 661c80192d21269c7fc566f1d547510b0c867677
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 14:00:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  661c80192d21269c7fc566f1d547510b0c867677
Gitweb:     http://git.kernel.org/tip/661c80192d21269c7fc566f1d547510b0c867677
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 20 Nov 2013 12:50:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Nov 2013 13:57:07 -0800

x86-64, copy_user: Use leal to produce 32-bit results

When we are using lea to produce a 32-bit result, we can use the leal
form, rather than using leaq and worry about truncation elsewhere.

Make the leal explicit, both to be more obvious and since that is what
gcc generates and thus is less likely to trigger obscure gas bugs.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1384634221-6006-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/copy_user_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index ffe4eb9..dee945d 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -186,7 +186,7 @@ ENTRY(copy_user_generic_unrolled)
 30:	shll $6,%ecx
 	addl %ecx,%edx
 	jmp 60f
-40:	lea (%rdx,%rcx,8),%rdx
+40:	leal (%rdx,%rcx,8),%edx
 	jmp 60f
 50:	movl %ecx,%edx
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
@@ -252,7 +252,7 @@ ENTRY(copy_user_generic_string)
 	ret
 
 	.section .fixup,"ax"
-11:	lea (%rdx,%rcx,8),%rcx
+11:	leal (%rdx,%rcx,8),%ecx
 12:	movl %ecx,%edx		/* ecx is zerorest also */
 	jmp copy_user_handle_tail
 	.previous
