Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaC2UPu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 16:15:50 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47224 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaC2UPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 16:15:45 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86: Fix the symbol versions on the 32-bit vDSO
Date: Sat, 29 Mar 2014 13:15:35 -0700
Message-Id: <0a869bce03d25619565b1eee7d69a4fd15fd203a.1396124118.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new symbols provide the same API as the 64-bit variants, so they
should have the same symbol version name.  This can't break
userspace, since these symbols are new for 32-bit Linux.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
-- 
1.9.0

