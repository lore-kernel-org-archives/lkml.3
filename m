Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbbAFToL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:44:11 -0500
Received: from resqmta-ch2-04v.sys.comcast.net ([69.252.207.36]:49461 "EHLO
	resqmta-ch2-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932715AbbAFToG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:44:06 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        keescook@chromium.org, tranmanphong@gmail.com, mpe@ellerman.id.au,
        cov@codeaurora.org, dh.herrmann@gmail.com, hughd@google.com,
        bobby.prani@gmail.com, serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        tim.bird@sonymobile.com, josh@joshtriplett.org, koct9i@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 20/20] kbuild: add a new kselftest_install make target to install selftests
Date: Tue,  6 Jan 2015 12:43:34 -0700
Message-Id: <2c5a28faaa79d9c2415854a08817ada509fcb943.1420571615.git.shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1420571615.git.shuahkh@osg.samsung.com>
References: <cover.1420571615.git.shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target to install to install kernel selftests.
This new target will build and install selftests. kselftest
target now depends on kselftest_install and runs the generated
kselftest script to reduce duplicate work and for common look
and feel when running tests.

make kselftest_target:
-- exports kselftest INSTALL_KSFT_PATH
   default $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
-- exports INSTALL_KSFT_PATH
-- runs selftests make install target

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 Makefile | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index b1c3254..99fac47 100644
--- a/Makefile
+++ b/Makefile
@@ -1072,12 +1072,21 @@ headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
-# Kernel selftest
+# Kernel selftest targets
+
+# Default base path for kselftest install
+INSTALL_KSFT_PATH = $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)
+export INSTALL_KSFT_PATH
 
 PHONY += kselftest
 kselftest:
 	$(Q)$(MAKE) -C tools/testing/selftests run_tests
 
+# Kernel selftest install
+PHONY += kselftest_install
+kselftest_install:
+	$(Q)$(MAKE) -C tools/testing/selftests install
+
 # ---------------------------------------------------------------------------
 # Modules
 
@@ -1286,6 +1295,9 @@ help:
 	@echo  '                    Build, install, and boot kernel before'
 	@echo  '                    running kselftest on it'
 	@echo  ''
+	@echo  '  kselftest_install - Install Kselftests to INSTALL_KSFT_PATH'
+	@echo  '                      default: $(INSTALL_MOD_PATH)/lib/kselftest/$(KERNELRELEASE)'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
-- 
2.1.0

