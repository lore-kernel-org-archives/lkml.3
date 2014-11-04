Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaKDRYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:24:39 -0500
Received: from mailout.easymail.ca ([64.68.201.169]:50548 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaKDRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:18:19 -0500
X-Quarantine-ID: <SVHlRjC-MGty>
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
Subject: [PATCH 12/20] selftests/memory-hotplug: add install target to enable installing test
Date: Tue,  4 Nov 2014 10:11:08 -0700
Message-Id: <cb8e21ac88a65469be34aa1d41117cb6ee6f328a.1415117102.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1415117102.git.shuahkh@osg.samsung.com>
References: <cover.1415117102.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to enable installing test. This target
installs test in the kselftest install location and add to the
kselftest script to run the test.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/memory-hotplug/Makefile | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/memory-hotplug/Makefile b/tools/testing/selftests/memory-hotplug/Makefile
index d46b8d4..3c32820 100644
--- a/tools/testing/selftests/memory-hotplug/Makefile
+++ b/tools/testing/selftests/memory-hotplug/Makefile
@@ -1,5 +1,14 @@
+TEST_STR="/bin/bash ./mem-on-off-test.sh -r 2 || echo \"memory-hotplug selftests: [FAIL]\""
+
 all:
 
+install:
+	install ./on-off-test.sh $(INSTALL_KSFT_PATH)/mem-on-off-test.sh
+	echo "\necho \"Start memory hotplug test ....\"" >> $(KSELFTEST)
+	echo $(TEST_STR) >> $(KSELFTEST)
+	echo "echo \"End memory hotplug test ....\"" >> $(KSELFTEST)
+	echo "echo \"==============================\"" >> $(KSELFTEST)
+
 run_tests:
 	@/bin/bash ./on-off-test.sh -r 2 || echo "memory-hotplug selftests: [FAIL]"
 
-- 
1.9.1

