Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaHQOns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:43:48 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59584 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaHQOnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:43:47 -0400
From: Phong Tran <tranmanphong@gmail.com>
To: dh.herrmann@gmail.com, hughd@google.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, shuah.kh@samsung.com, sam@ravnborg.org,
        mmarek@suse.cz, Phong Tran <tranmanphong@gmail.com>
Subject: [PATCH] tools: selftests: Fixing build issue with make kselftests target
Date: Sun, 17 Aug 2014 21:43:29 +0700
Message-Id: <1408286609-32597-1-git-send-email-tranmanphong@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the typo of ARCH when build with 'make kselftests'
Change the 'X86' to 'x86'. Test by compilation

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
---
 tools/testing/selftests/ipc/Makefile   |  6 +++---
 tools/testing/selftests/kcmp/Makefile  |  6 +++---
 tools/testing/selftests/memfd/Makefile | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/ipc/Makefile b/tools/testing/selftests/ipc/Makefile
index 5386fd7..74bbefd 100644
--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -1,18 +1,18 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := X86
+        ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
 CFLAGS += -I../../../../usr/include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) msgque.c -o msgque_test
 else
 	echo "Not an x86 target, can't build msgque selftest"
diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index d7d6bbe..8aabd82 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,11 +1,11 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-        ARCH := X86
+        ARCH := x86
 	CFLAGS := -DCONFIG_X86_32 -D__i386__
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
@@ -15,7 +15,7 @@ CFLAGS += -I../../../../usr/include/
 CFLAGS += -I../../../../arch/x86/include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
 else
 	echo "Not an x86 target, can't build kcmp selftest"
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index 6816c49..ad4ab01 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -1,10 +1,10 @@
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
 ifeq ($(ARCH),i386)
-	ARCH := X86
+	ARCH := x86
 endif
 ifeq ($(ARCH),x86_64)
-	ARCH := X86
+	ARCH := x86
 endif
 
 CFLAGS += -D_FILE_OFFSET_BITS=64
@@ -14,20 +14,20 @@ CFLAGS += -I../../../../include/uapi/
 CFLAGS += -I../../../../include/
 
 all:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 else
 	echo "Not an x86 target, can't build memfd selftest"
 endif
 
 run_tests: all
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) memfd_test.c -o memfd_test
 endif
 	@./memfd_test || echo "memfd_test: [FAIL]"
 
 build_fuse:
-ifeq ($(ARCH),X86)
+ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) fuse_mnt.c `pkg-config fuse --cflags --libs` -o fuse_mnt
 	gcc $(CFLAGS) fuse_test.c -o fuse_test
 else
-- 
1.9.3

