Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaE2DKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 23:10:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaE2DKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 23:10:31 -0400
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/2] audit: do not select HAVE_ARCH_AUDITSYSCALL on x32
Date: Wed, 28 May 2014 23:09:59 -0400
Message-Id: <1401332999-15167-2-git-send-email-eparis@redhat.com>
In-Reply-To: <1401332999-15167-1-git-send-email-eparis@redhat.com>
References: <1401332999-15167-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When x32 was introduced it assumed that it would get syscall audit for
free (since it works for x86 and x86_64).  However, the audit system
assumed that the syscall table has less that 2048 entries.  This is not
the case for x32 (or it is, kinda sorta)

Since audit syscall does not work on x32 stop selecting it.

Signed-off-by: Eric Paris <eparis@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 56f47ca..e11c4da 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -125,7 +125,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
-	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_AUDITSYSCALL if !X86_X32
 
 config INSTRUCTION_DECODER
 	def_bool y
-- 
1.9.0

