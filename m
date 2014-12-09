Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbaLIKTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:19:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52396 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbaLIKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:19:17 -0500
Date: Tue, 9 Dec 2014 02:18:51 -0800
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-e10abb2f770eeb673d23c19980216b0fb62b4f50@git.kernel.org>
Cc: oleg@redhat.com, tglx@linutronix.de, luto@amacapital.net,
        dan.carpenter@oracle.com, dave.hansen@linux.intel.com,
        mingo@kernel.org, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org
Reply-To: hpa@zytor.com, masami.hiramatsu.pt@hitachi.com, mingo@kernel.org,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, oleg@redhat.com, tglx@linutronix.de,
        luto@amacapital.net
In-Reply-To: <20141125172114.GA24535@mwanda>
References: <20141125172114.GA24535@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] x86_64/traps: Fix always true condition
Git-Commit-ID: e10abb2f770eeb673d23c19980216b0fb62b4f50
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

Commit-ID:  e10abb2f770eeb673d23c19980216b0fb62b4f50
Gitweb:     http://git.kernel.org/tip/e10abb2f770eeb673d23c19980216b0fb62b4f50
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Tue, 25 Nov 2014 20:21:14 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Dec 2014 12:06:59 +0100

x86_64/traps: Fix always true condition

We should be checking IS_ERR() here.  PTR_ERR() is always true.

Fixes: fe3d197f8431 ('x86, mpx: On-demand kernel allocation of
bounds tables')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20141125172114.GA24535@mwanda
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/traps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 651d5d4..f73fc4a 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -323,7 +323,7 @@ dotraplinkage void do_bounds(struct pt_regs *regs, long error_code)
 		break; /* Success, it was handled */
 	case 1: /* Bound violation. */
 		info = mpx_generate_siginfo(regs, xsave_buf);
-		if (PTR_ERR(info)) {
+		if (IS_ERR(info)) {
 			/*
 			 * We failed to decode the MPX instruction.  Act as if
 			 * the exception was not caused by MPX.
