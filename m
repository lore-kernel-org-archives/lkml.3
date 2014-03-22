Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaCVGnC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:43:02 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36478 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaCVGnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:43:00 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, pageexec@freemail.hu,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] unwind_support
Date: Fri, 21 Mar 2014 23:42:54 -0700
Message-Id: <1395470574-17056-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

Patch to prevent warning of a buggy compiler when using clang and
the ARM_UNWIND option.

Clang defines (at least on the current trunk) GNUC, GNUC_MINOR, and
GNUC_PATCHLEVEL to 4, 2, and 1 respectively.

This version of GCC gets flagged as buggy, but it isn't actually an
issue with clang so the patch will do what it did before unless clang
is defined and then it will not report the GCC version as an issue.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 arch/arm/kernel/unwind.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 00df012..321c4f9 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -31,7 +31,7 @@
 #warning Your compiler does not have EABI support.
 #warning    ARM unwind is known to compile only with EABI compilers.
 #warning    Change compiler or disable ARM_UNWIND option.
-#elif (__GNUC__ == 4 && __GNUC_MINOR__ <= 2)
+#elif (__GNUC__ == 4 && __GNUC_MINOR__ <= 2) && !defined(__clang__)
 #warning Your compiler is too buggy; it is known to not compile ARM unwind support.
 #warning    Change compiler or disable ARM_UNWIND option.
 #endif
-- 
1.8.3.2

