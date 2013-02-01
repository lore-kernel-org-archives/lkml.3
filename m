Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab3BAUoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 15:44:05 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:21482 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549Ab3BAUni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 15:43:38 -0500
Message-ID: <201302012043.r11Khb3F024380@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 1 Feb 2013 15:31:25 -0500
Subject: [PATCH] tile: tag some code with #ifdef CONFIG_COMPAT
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to disable COMPAT mode without a link error.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/intvec_64.S |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
index 54bc9a6..4ea0809 100644
--- a/arch/tile/kernel/intvec_64.S
+++ b/arch/tile/kernel/intvec_64.S
@@ -1035,7 +1035,9 @@ handle_syscall:
 	/* Ensure that the syscall number is within the legal range. */
 	{
 	 moveli r20, hw2(sys_call_table)
+#ifdef CONFIG_COMPAT
 	 blbs   r30, .Lcompat_syscall
+#endif
 	}
 	{
 	 cmpltu r21, TREG_SYSCALL_NR_NAME, r21
@@ -1093,6 +1095,7 @@ handle_syscall:
 	 j      .Lresume_userspace   /* jump into middle of interrupt_return */
 	}
 
+#ifdef CONFIG_COMPAT
 .Lcompat_syscall:
 	/*
 	 * Load the base of the compat syscall table in r20, and
@@ -1117,6 +1120,7 @@ handle_syscall:
 	{ move r15, r4; addxi r4, r4, 0 }
 	{ move r16, r5; addxi r5, r5, 0 }
 	j .Lload_syscall_pointer
+#endif
 
 .Linvalid_syscall:
 	/* Report an invalid syscall back to the user program */
-- 
1.7.10.3

