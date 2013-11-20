Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3KTUy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:54:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40944 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027Ab3KTUyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:54:54 -0500
Date: Wed, 20 Nov 2013 12:54:35 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-372474e12a858807f03f73cb30e830a76fd1ae07@git.kernel.org>
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
Git-Commit-ID: 372474e12a858807f03f73cb30e830a76fd1ae07
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 12:54:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  372474e12a858807f03f73cb30e830a76fd1ae07
Gitweb:     http://git.kernel.org/tip/372474e12a858807f03f73cb30e830a76fd1ae07
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 20 Nov 2013 12:50:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 20 Nov 2013 12:50:51 -0800

x86-64, copy_user: Use leal to produce 32-bit results

When we are using lea to produce a 32-bit result, we can use the leal
form, rather than using leaq and worry about truncation elsewhere.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1384634221-6006-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/lib/copy_user_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index ffe4eb9..f00a87c 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -186,7 +186,7 @@ ENTRY(copy_user_generic_unrolled)
 30:	shll $6,%ecx
 	addl %ecx,%edx
 	jmp 60f
-40:	lea (%rdx,%rcx,8),%rdx
+40:	lea (%rdx,%rcx,8),%edx
 	jmp 60f
 50:	movl %ecx,%edx
 60:	jmp copy_user_handle_tail /* ecx is zerorest also */
@@ -252,7 +252,7 @@ ENTRY(copy_user_generic_string)
 	ret
 
 	.section .fixup,"ax"
-11:	lea (%rdx,%rcx,8),%rcx
+11:	lea (%rdx,%rcx,8),%ecx
 12:	movl %ecx,%edx		/* ecx is zerorest also */
 	jmp copy_user_handle_tail
 	.previous
