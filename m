Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3A2Sxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 13:53:42 -0500
Received: from mail-ob0-f202.google.com ([209.85.214.202]:37695 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab3A2Sxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 13:53:39 -0500
From: Simon Que <sque@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Simon Que <sque@chromium.org>, Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH] Add -Werror build option
Date: Tue, 29 Jan 2013 10:51:18 -0800
Message-Id: <1359485478-23639-1-git-send-email-sque@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a config option "ERROR_ON_WARNING" that adds the "-Werror" flag to
gcc, which turns warnings into errors.

This option enables developers to set a stricter level of code checking
for kernel code: all code must be warning-free.

Signed-off-by: Simon Que <sque@chromium.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 Makefile          |    4 ++++
 lib/Kconfig.debug |    9 +++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index a687963..7502f5f 100644
--- a/Makefile
+++ b/Makefile
@@ -620,6 +620,10 @@ endif
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 CHECKFLAGS     += $(NOSTDINC_FLAGS)
 
+ifdef CONFIG_ERROR_ON_WARNING
+KBUILD_CFLAGS += -Werror
+endif
+
 # warn about C99 declaration after statement
 KBUILD_CFLAGS += $(call cc-option,-Wdeclaration-after-statement,)
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 83b2558..28005ff 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1305,3 +1305,12 @@ source "lib/Kconfig.kmemcheck"
 
 config TEST_KSTRTOX
 	tristate "Test kstrto*() family of functions at runtime"
+
+config ERROR_ON_WARNING
+	bool "Treat compiler warnings as errors"
+	help
+	  If you say Y here, the Makefile will pass the "-Werror" option to the
+	  compiler.  This will cause the compiler to fail on any warning, as if
+	  it were an error.
+
+	  If unsure, say N.
-- 
1.7.8.6

