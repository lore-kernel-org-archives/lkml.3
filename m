Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933733Ab3FRVcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:32:24 -0400
Received: from longford.logfs.org ([213.229.74.203]:59586 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604Ab3FRVcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:32:19 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joern Engel <joern@logfs.org>
Subject: [PATCH 1/3] selftests: exit 1 on failure
Date: Tue, 18 Jun 2013 16:01:59 -0400
Message-Id: <1371585721-28087-2-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371585721-28087-1-git-send-email-joern@logfs.org>
References: <1371585721-28087-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case this ever gets scripted, it should return 0 on success and 1 on
failure.  Parsing the output should be left to meatbags.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 tools/testing/selftests/vm/Makefile    |    2 +-
 tools/testing/selftests/vm/run_vmtests |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index 436d2e8..7d47927 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -8,7 +8,7 @@ all: hugepage-mmap hugepage-shm  map_hugetlb thuge-gen
 	$(CC) $(CFLAGS) -o $@ $^
 
 run_tests: all
-	@/bin/sh ./run_vmtests || echo "vmtests: [FAIL]"
+	@/bin/sh ./run_vmtests || (echo "vmtests: [FAIL]"; exit 1)
 
 clean:
 	$(RM) hugepage-mmap hugepage-shm  map_hugetlb
diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftests/vm/run_vmtests
index 4c53cae..7a9072d 100644
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -4,6 +4,7 @@
 #we need 256M, below is the size in kB
 needmem=262144
 mnt=./huge
+exitcode=0
 
 #get pagesize and freepages from /proc/meminfo
 while read name size unit; do
@@ -41,6 +42,7 @@ echo "--------------------"
 ./hugepage-mmap
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -55,6 +57,7 @@ echo "--------------------"
 ./hugepage-shm
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -67,6 +70,7 @@ echo "--------------------"
 ./map_hugetlb
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exitcode=1
 else
 	echo "[PASS]"
 fi
@@ -75,3 +79,4 @@ fi
 umount $mnt
 rm -rf $mnt
 echo $nr_hugepgs > /proc/sys/vm/nr_hugepages
+exit $exitcode
-- 
1.7.10.4

