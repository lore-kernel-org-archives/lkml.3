Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab3GXDzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:55:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38343 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3GXDze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:55:34 -0400
Date: Tue, 23 Jul 2013 20:55:24 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-d2475b8ff81ebeed88d8fcbc22876aced5a0807a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        artagnon@gmail.com, tglx@linutronix.de, viro@zeniv.linux.org.uk
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, artagnon@gmail.com, viro@zeniv.linux.org.uk
In-Reply-To: <1373479468-7175-1-git-send-email-artagnon@gmail.com>
References: <1373479468-7175-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/ia32/asm: Remove unused argument in macro
Git-Commit-ID: d2475b8ff81ebeed88d8fcbc22876aced5a0807a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:55:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2475b8ff81ebeed88d8fcbc22876aced5a0807a
Gitweb:     http://git.kernel.org/tip/d2475b8ff81ebeed88d8fcbc22876aced5a0807a
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Wed, 10 Jul 2013 23:34:28 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 11:23:21 +0200

x86/ia32/asm: Remove unused argument in macro

Commit 3fe26fa ("x86: get rid of pt_regs argument in sigreturn variants",
from 2012-11-12) changed the body of PTREGSCALL to drop arg, and
updated the callsites; unfortunately, it forgot to update the
macro argument list, leaving an unused argument.  Fix this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/1373479468-7175-1-git-send-email-artagnon@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/ia32/ia32entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 474dc1b..4299eb0 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -452,7 +452,7 @@ ia32_badsys:
 
 	CFI_ENDPROC
 	
-	.macro PTREGSCALL label, func, arg
+	.macro PTREGSCALL label, func
 	ALIGN
 GLOBAL(\label)
 	leaq \func(%rip),%rax
