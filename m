Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaJWFHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 01:07:31 -0400
Received: from ozlabs.org ([103.22.144.67]:47929 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaJWFHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 01:07:24 -0400
From: Michael Ellerman <mpe@ellerman.id.au>
To: <linux-kernel@vger.kernel.org>
Cc: shuahkh@osg.samsung.com, linux-api@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>, gorcunov@openvz.org
Subject: [PATCH 3/3] selftests/kcmp: Always try to build the test
Date: Thu, 23 Oct 2014 16:07:14 +1100
Message-Id: <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't prevent the test building on non-x86. Just try and build it and
let the chips fall where they may.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 tools/testing/selftests/kcmp/Makefile | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 4f00c0524501..cda9cc4004c9 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,21 +1,7 @@
-uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
-ifeq ($(ARCH),i386)
-        ARCH := x86
-	CFLAGS := -DCONFIG_X86_32 -D__i386__
-endif
-ifeq ($(ARCH),x86_64)
-	ARCH := x86
-	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
-endif
 CFLAGS += -I../../../../usr/include/
 
 all:
-ifeq ($(ARCH),x86)
 	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
-else
-	echo "Not an x86 target, can't build kcmp selftest"
-endif
 
 run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
-- 
1.9.1

