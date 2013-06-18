Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3FRVcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:32:09 -0400
Received: from longford.logfs.org ([213.229.74.203]:59580 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604Ab3FRVcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:32:07 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>
Subject: [PATCH 2/3] self-test: fix make clean
Date: Tue, 18 Jun 2013 16:02:00 -0400
Message-Id: <1371585721-28087-3-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371585721-28087-1-git-send-email-joern@logfs.org>
References: <1371585721-28087-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thuge-gen was forgotten.  Fix it by removing the duplication, so we
don't get too many repeats.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 tools/testing/selftests/vm/Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 7d47927..cb3f5f2 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -2,8 +2,9 @@
 
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall
+BINARIES = hugepage-mmap hugepage-shm map_hugetlb thuge-gen
 
-all: hugepage-mmap hugepage-shm  map_hugetlb thuge-gen
+all: $(BINARIES)
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
@@ -11,4 +12,4 @@ run_tests: all
 	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
 
 clean:
-	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
+	$(RM) $(BINARIES)
-- 
1.7.10.4

