Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbaIWTz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:55:27 -0400
Received: from mail-oi0-f73.google.com ([209.85.218.73]:63221 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWTzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:55:23 -0400
From: Peter Feiner <pfeiner@google.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickens <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH v2 2/3] tools: adding clean target to user selftest
Date: Tue, 23 Sep 2014 12:55:19 -0700
Message-Id: <1411502120-28219-3-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1411502120-28219-1-git-send-email-pfeiner@google.com>
References: <1411499027-17801-1-git-send-email-pfeiner@google.com>
 <1411502120-28219-1-git-send-email-pfeiner@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of this error when running 'make clean' in the selftests
directory:

make[1]: Entering directory `.../tools/testing/selftests/user'
make[1]: *** No rule to make target `clean'.  Stop.

---

v1 -> v2:
	Separated this from the parallel build patch.
---
 tools/testing/selftests/user/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/user/Makefile b/tools/testing/selftests/user/Makefile
index 396255b..8eb6583 100644
--- a/tools/testing/selftests/user/Makefile
+++ b/tools/testing/selftests/user/Makefile
@@ -3,6 +3,8 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
+clean:
+
 run_tests: all
 	@if /sbin/modprobe test_user_copy ; then \
 		rmmod test_user_copy; \
-- 
2.1.0.rc2.206.gedb03e5

