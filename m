Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaLYFby (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 00:31:54 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:55093 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbaLYFbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 00:31:49 -0500
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Michal Marek <mmarek@suse.cz>,
        Masahiro Yamada <yamada.m@jp.panasonic.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] kbuild,gcov: remove unnecessary workaround
Date: Thu, 25 Dec 2014 14:31:25 +0900
Message-Id: <1419485488-22336-4-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1419485488-22336-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 371fdc77af44 (kbuild: collect shorthands into
scripts/Kbuild.include), scripts/Makefile.clean includes
scripts/Kbuild.include.

The workaround and the comment block in kernel/gcov/Makefile
are no longer necessary.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---

 kernel/gcov/Makefile | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index 6f01fa3..42323c7 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -10,18 +10,7 @@ ifeq ($(CONFIG_GCOV_FORMAT_3_4),y)
 else ifeq ($(CONFIG_GCOV_FORMAT_4_7),y)
   cc-ver := 0407
 else
-# Use cc-version if available, otherwise set 0
-#
-# scripts/Kbuild.include, which contains cc-version function, is not included
-# during make clean "make -f scripts/Makefile.clean obj=kernel/gcov"
-# Meaning cc-ver is empty causing if-lt test to fail with
-# "/bin/sh: line 0: [: -lt: unary operator expected" error mesage.
-# This has no affect on the clean phase, but the error message could be
-# confusing/annoying. So this dummy workaround sets cc-ver to zero if cc-version
-# is not available. We can probably move if-lt to Kbuild.include, so it's also
-# not defined during clean or to include Kbuild.include in
-# scripts/Makefile.clean. But the following workaround seems least invasive.
-  cc-ver := $(if $(cc-version),$(cc-version),0)
+  cc-ver := $(cc-version)
 endif
 
 obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o
-- 
1.9.1

