Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762262AbaGRUok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 16:44:40 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:45553
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756032AbaGRUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 16:44:39 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: mmarek@suse.cz, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: devtest - new make target for build all and run tests
Date: Fri, 18 Jul 2014 14:44:34 -0600
Message-Id: <1405716274-24420-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new devtest make target to enable developer testing. This
new target does full build (make all) and then runs selftests.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 Makefile | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Makefile b/Makefile
index f3c543d..1ef3128 100644
--- a/Makefile
+++ b/Makefile
@@ -1034,6 +1034,14 @@ headers_check: headers_install
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(hdr-arch)/include/uapi/asm $(hdr-dst) HDRCHECK=1
 
 # ---------------------------------------------------------------------------
+# Kernel devtest
+
+PHONY += devtest
+devtest:
+	make all
+	make -C tools/testing/selftests run_tests
+
+# ---------------------------------------------------------------------------
 # Modules
 
 ifdef CONFIG_MODULES
@@ -1236,6 +1244,9 @@ help:
 	@echo  '  headerdep       - Detect inclusion cycles in headers'
 	@$(MAKE) -f $(srctree)/scripts/Makefile.help checker-help
 	@echo  ''
+	@echo  'Developer test'
+	@echo  '  devtest      - Build all and run tests'
+	@echo  ''
 	@echo  'Kernel packaging:'
 	@$(MAKE) $(build)=$(package-dir) help
 	@echo  ''
-- 
1.9.1

