Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaIILCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:02:31 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:64535 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbaIILCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:02:30 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] kbuild: fake the "Entering directory ..." message more simply
Date: Tue,  9 Sep 2014 20:02:22 +0900
Message-Id: <1410260544-22657-2-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c2e28dc975ea87feed84415006ae143424912ac7
(kbuild: Print the name of the build directory)
added a gimmick to show the "Entering directory ...".

Instead of echoing the hard-coded message (that is, we need to know
the exact message), moving --no-print-directory would be easier.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 Makefile | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/Makefile b/Makefile
index f7b9174..c1bd5a4 100644
--- a/Makefile
+++ b/Makefile
@@ -10,11 +10,9 @@ NAME = Shuffling Zombie Juror
 # Comments in this file are targeted only to the developer, do not
 # expect to learn how to build the kernel reading this file.
 
-# Do not:
-# o  use make's built-in rules and variables
-#    (this increases performance and avoids hard-to-debug behaviour);
-# o  print "Entering directory ...";
-MAKEFLAGS += -rR --no-print-directory
+# Do not use make's built-in rules and variables
+# (this increases performance and avoids hard-to-debug behaviour);
+MAKEFLAGS += -rR
 
 # Avoid funny character set dependencies
 unexport LC_ALL
@@ -172,13 +170,7 @@ PHONY += $(MAKECMDGOALS) sub-make
 $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
 	@:
 
-# Fake the "Entering directory" message once, so that IDEs/editors are
-# able to understand relative filenames.
-       echodir := @echo
- quiet_echodir := @echo
-silent_echodir := @:
 sub-make: FORCE
-	$($(quiet)echodir) "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
 	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
 	KBUILD_SRC=$(CURDIR) \
 	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
@@ -192,6 +184,11 @@ endif # ifeq ($(KBUILD_SRC),)
 # We process the rest of the Makefile if this is the final invocation of make
 ifeq ($(skip-makefile),)
 
+# Do not print "Entering directory ...",
+# but we want to display it when entering to the output directory
+# so that IDEs/editors are able to understand relative filenames.
+MAKEFLAGS += --no-print-directory
+
 # If building an external module we do not care about the all: rule
 # but instead _all depend on modules
 PHONY += all
-- 
1.9.1

