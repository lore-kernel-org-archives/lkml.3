Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbaHGODU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:03:20 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:51554 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757788AbaHGODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:03:17 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org, sam@ravnborg.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kbuild: kselftest - new make target to build and run kernel selftests
Date: Thu,  7 Aug 2014 08:03:12 -0600
Message-Id: <1407420192-4928-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new make target "kselftest" to enable kernel testing. This
new target builds and runs kernel selftests. Running as root is
recommended for a complete test run as some tests don't run when
run by non-root user.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index d0901b4..7eda9fb 100644
--- a/Makefile
+++ b/Makefile
@@ -1036,6 +1036,13 @@ headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
+# Kernel selftest
+
+PHONY += kselftest
+kselftest:
+	$(Q)$(MAKE) -C tools/testing/selftests run_tests
+
+# ---------------------------------------------------------------------------
 # Modules
 
 ifdef CONFIG_MODULES
@@ -1238,6 +1245,9 @@ help:
 	@echo  '  headerdep       - Detect inclusion cycles in headers'
 	@$(MAKE) -f $(srctree)/scripts/Makefile.help checker-help
 	@echo  ''
+	@echo  'Kernel selftest'
+	@echo  '  kselftest       - Build and run kernel selftest (run as root)'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
-- 
1.9.1

