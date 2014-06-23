Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFWW5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:57:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaFWW5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:57:46 -0400
Date: Mon, 23 Jun 2014 15:57:34 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-6ba19a670c8b604e9802d30b511e6a4778118592@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net>
References: <1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86_32, signal: Fix vdso rt_sigreturn
Git-Commit-ID: 6ba19a670c8b604e9802d30b511e6a4778118592
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

Commit-ID:  6ba19a670c8b604e9802d30b511e6a4778118592
Gitweb:     http://git.kernel.org/tip/6ba19a670c8b604e9802d30b511e6a4778118592
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Sat, 21 Jun 2014 07:31:55 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 23 Jun 2014 15:54:42 -0700

x86_32, signal: Fix vdso rt_sigreturn

This commit:

    commit 6f121e548f83674ab4920a4e60afb58d4f61b829
    Author: Andy Lutomirski <luto@amacapital.net>
    Date:   Mon May 5 12:19:34 2014 -0700

        x86, vdso: Reimplement vdso.so preparation in build-time C

Contained this obvious typo:

-               restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+               restorer = current->mm->context.vdso +
+                       selected_vdso32->sym___kernel_sigreturn;

Note the missing 'rt_' in the new code.  Fix it.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/1eb40ad923acde2e18357ef2832867432e70ac42.1403361010.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index a0da58d..2851d63 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -363,7 +363,7 @@ static int __setup_rt_frame(int sig, struct ksignal *ksig,
 
 		/* Set up to return from userspace.  */
 		restorer = current->mm->context.vdso +
-			selected_vdso32->sym___kernel_sigreturn;
+			selected_vdso32->sym___kernel_rt_sigreturn;
 		if (ksig->ka.sa.sa_flags & SA_RESTORER)
 			restorer = ksig->ka.sa.sa_restorer;
 		put_user_ex(restorer, &frame->pretcode);
