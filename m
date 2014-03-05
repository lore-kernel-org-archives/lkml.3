Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaCEHgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:36:50 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:35680 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaCEHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:36:49 -0500
From: jon@ringle.org
To: linux-kernel@vger.kernel.org
Cc: Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH] Add option to build with -O3
Date: Wed,  5 Mar 2014 02:36:35 -0500
Message-Id: <1394004995-27963-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 Makefile     |  2 ++
 init/Kconfig | 19 ++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 78209ee..e7f0b3c 100644
--- a/Makefile
+++ b/Makefile
@@ -581,6 +581,8 @@ all: vmlinux
 
 ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
 KBUILD_CFLAGS	+= -Os $(call cc-disable-warning,maybe-uninitialized,)
+else ifdef CONFIG_CC_OPTIMIZE_FOR_SPEED
+KBUILD_CFLAGS   += -O3
 else
 KBUILD_CFLAGS	+= -O2
 endif
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..17d4c62 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1233,13 +1233,26 @@ source "usr/Kconfig"
 
 endif
 
+choice
+    prompt "Optimize"
+
+config CC_OPTIMIZE_NORMAL
+    bool "Optimize Normal (-O2)"
+    help
+      Enabling this option will pass "-O2" to gcc
 config CC_OPTIMIZE_FOR_SIZE
-	bool "Optimize for size"
+	bool "Optimize for size (-Os)"
 	help
-	  Enabling this option will pass "-Os" instead of "-O2" to gcc
+	  Enabling this option will pass "-Os" to gcc
 	  resulting in a smaller kernel.
 
-	  If unsure, say N.
+config CC_OPTIMIZE_FOR_SPEED
+    bool "Optimze for speed (-O3)"
+    help
+      Enabling this option will pass "-O3" to gcc
+      resulting in a larger kernel (but possibly faster)
+
+endchoice
 
 config SYSCTL
 	bool
-- 
1.8.5.4

