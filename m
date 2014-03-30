Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaC3R30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 13:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaC3R3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 13:29:24 -0400
Date: Sun, 30 Mar 2014 10:28:27 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-37c975545ec63320789962bf307f000f08fabd48@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de
In-Reply-To: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
References: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Fix the symbol versions on the 32-bit vDSO
Git-Commit-ID: 37c975545ec63320789962bf307f000f08fabd48
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

Commit-ID:  37c975545ec63320789962bf307f000f08fabd48
Gitweb:     http://git.kernel.org/tip/37c975545ec63320789962bf307f000f08fabd48
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Sat, 29 Mar 2014 13:15:35 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 30 Mar 2014 10:08:38 -0700

x86, vdso: Fix the symbol versions on the 32-bit vDSO

The new symbols provide the same API as the 64-bit variants, so they
should have the same symbol version name.  This can't break
userspace, since these symbols are new for 32-bit Linux.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Stefani Seibold <stefani@seibold.net>
Link: http://lkml.kernel.org/r/0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/vdso/vdso32/vdso32.lds.S | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/vdso/vdso32/vdso32.lds.S b/arch/x86/vdso/vdso32/vdso32.lds.S
index 28c4607..aadb8b9 100644
--- a/arch/x86/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/vdso/vdso32/vdso32.lds.S
@@ -23,14 +23,18 @@ ENTRY(__kernel_vsyscall);
  */
 VERSION
 {
+	LINUX_2.6 {
+	global:
+		__vdso_clock_gettime;
+		__vdso_gettimeofday;
+		__vdso_time;
+	};
+
 	LINUX_2.5 {
 	global:
 		__kernel_vsyscall;
 		__kernel_sigreturn;
 		__kernel_rt_sigreturn;
-		__vdso_clock_gettime;
-		__vdso_gettimeofday;
-		__vdso_time;
 	local: *;
 	};
 }
