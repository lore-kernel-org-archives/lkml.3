Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3KDIaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:30:23 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60963 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752567Ab3KDIaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:30:22 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] microblaze: remove unused NO_MMU Kconfig parameter
Date: Mon,  4 Nov 2013 09:30:18 +0100
Message-Id: <1383553818-3711-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the NO_MMU Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

This also updates a comment refering to this parameter.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/microblaze/Kconfig                       | 5 -----
 arch/microblaze/kernel/hw_exception_handler.S | 4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index b82f82b74319..d8ec74b4d1ee 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -82,11 +82,6 @@ config MMU
 	bool "MMU support"
 	default n
 
-config NO_MMU
-	bool
-	depends on !MMU
-	default y
-
 comment "Boot options"
 
 config CMDLINE_BOOL
diff --git a/arch/microblaze/kernel/hw_exception_handler.S b/arch/microblaze/kernel/hw_exception_handler.S
index 61b3a1fed46f..fc6b89f4dd31 100644
--- a/arch/microblaze/kernel/hw_exception_handler.S
+++ b/arch/microblaze/kernel/hw_exception_handler.S
@@ -193,8 +193,8 @@
  *      -                            W   S   REG   EXC
  *
  *
- * STACK FRAME STRUCTURE (for NO_MMU)
- * ---------------------------------
+ * STACK FRAME STRUCTURE (for CONFIG_MMU=n)
+ * ----------------------------------------
  *
  *      +-------------+         + 0
  *      |     MSR     |
-- 
1.8.1.2

