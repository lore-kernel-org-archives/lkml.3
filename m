Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaKDRSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:18:41 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50543 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaKDRSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:17 -0500
X-Quarantine-ID: <1B-FiB5+DCig>
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
X-Spam-Flag: NO
X-Spam-Score: -4.399
From: Shuah Khan <shuahkh@osg.samsung.com>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org, mmarek@suse.cz,
        davem@davemloft.net, keescook@chromium.org, tranmanphong@gmail.com,
        dh.herrmann@gmail.com, hughd@google.com, bobby.prani@gmail.com,
        ebiederm@xmission.com, serge.hallyn@ubuntu.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 02/20] selftests/net: move test out of Makefile into a shell script
Date: Tue,  4 Nov 2014 10:10:58 -0700
Message-Id: <51d57725e89809806bd8af5555af341296cc4dd7.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently bpf test run from the Makefile. Move it out of the
Makefile to be run from a shell script to allow the test to
be run as stand-alone test, in addition to allowing the test
run from a make target.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/net/Makefile    |  8 +-------
 tools/testing/selftests/net/test_bpf.sh | 10 ++++++++++
 2 files changed, 11 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/test_bpf.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index c7493b8..62f22cc 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -14,12 +14,6 @@ all: $(NET_PROGS)
 run_tests: all
 	@/bin/sh ./run_netsocktests || echo "sockettests: [FAIL]"
 	@/bin/sh ./run_afpackettests || echo "afpackettests: [FAIL]"
-	@if /sbin/modprobe test_bpf ; then \
-		/sbin/rmmod test_bpf; \
-		echo "test_bpf: ok"; \
-	else \
-		echo "test_bpf: [FAIL]"; \
-		exit 1; \
-	fi
+	./test_bpf.sh
 clean:
 	$(RM) $(NET_PROGS)
diff --git a/tools/testing/selftests/net/test_bpf.sh b/tools/testing/selftests/net/test_bpf.sh
new file mode 100755
index 0000000..8b29796
--- /dev/null
+++ b/tools/testing/selftests/net/test_bpf.sh
@@ -0,0 +1,10 @@
+#!/bin/sh
+# Runs bpf test using test_bpf kernel module
+
+if /sbin/modprobe -q test_bpf ; then
+	/sbin/modprobe -q -r test_bpf;
+	echo "test_bpf: ok";
+else
+	echo "test_bpf: [FAIL]";
+	exit 1;
+fi
-- 
1.9.1

