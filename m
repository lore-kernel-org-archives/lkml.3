Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab3FSBCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 21:02:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:60111 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FSBCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 21:02:31 -0400
X-AuditID: 9c93016f-b7b6cae000007078-dd-51c103242ad2
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 2/3] tools lib lk: Fix for cross build
Date: Wed, 19 Jun 2013 10:02:29 +0900
Message-Id: <1371603750-15053-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1371603750-15053-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, lib lk doesn't use CROSS_COMPILE environment variable,
so cross build is always failed. This is a quick fix for this problem.

Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 926cbf3..91e5174 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -1,5 +1,20 @@
 include ../../scripts/Makefile.include
 
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
-- 
1.7.9.5

