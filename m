Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaHATpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 15:45:25 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:32938 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaHATpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 15:45:23 -0400
From: "Devin J. Pohly" <djpohly@gmail.com>
X-Google-Original-From: "Devin J. Pohly" <djpohly+linux@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Devin J. Pohly" <djpohly+linux@gmail.com>
Subject: [PATCH 1/1] kbuild: use $(srctree) to locate config headers from external modules
Date: Fri,  1 Aug 2014 15:47:23 -0400
Message-Id: <1406922443-22770-1-git-send-email-djpohly+linux@gmail.com>
X-Mailer: git-send-email 2.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When making modules_install for an out-of-tree module, the current
directory is $(KBUILD_OUTPUT), and the Makefile recipe which verifies
the existence of files in include/config is unable to find them using a
relative path.  This leads to a spurious and puzzling "Kernel
configuration is invalid" warning when no configuration is actually
needed.

Since the file check is done in a recipe with `test -e' rather than as a
target or include, the usual search paths provided by VPATH and -I are
not consulted, so an explicit path is needed in this case.

Signed-off-by: Devin J. Pohly <djpohly+linux@gmail.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index f6a7794..60c14a2 100644
--- a/Makefile
+++ b/Makefile
@@ -590,7 +590,7 @@ else
 PHONY += include/config/auto.conf
 
 include/config/auto.conf:
-	$(Q)test -e include/generated/autoconf.h -a -e $@ || (		\
+	$(Q)test -e $(srctree)/include/generated/autoconf.h -a -e $(srctree)/$@ || (		\
 	echo >&2;							\
 	echo >&2 "  ERROR: Kernel configuration is invalid.";		\
 	echo >&2 "         include/generated/autoconf.h or $@ are missing.";\
-- 
2.0.3

