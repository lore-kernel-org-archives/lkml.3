Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935426Ab3DKMFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:05:40 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64950 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935022Ab3DKMFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:05:38 -0400
X-AuditID: 9c93016f-b7b3fae0000004d3-c9-5166a710f734
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmig.org>
Subject: [PATCH 1/6] tools lib traceevent: Remove unused install targets
Date: Thu, 11 Apr 2013 21:04:53 +0900
Message-Id: <1365681898-19897-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The html_install, img_install, install_plugin and install_python are
unused in the Makefile.  Get rid of them.

Cc: Steven Rostedt <rostedt@goodmig.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/Makefile | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 0b0a90787db6..fd7510d99583 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -39,13 +39,8 @@ bindir_relative = bin
 bindir = $(prefix)/$(bindir_relative)
 man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
-html_install = $(prefix)/share/kernelshark/html
-html_install_SQ = '$(subst ','\'',$(html_install))'
-img_install = $(prefix)/share/kernelshark/html/images
-img_install_SQ = '$(subst ','\'',$(img_install))'
 
-export man_dir man_dir_SQ html_install html_install_SQ INSTALL
-export img_install img_install_SQ
+export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
 
 # copy a bit from Linux kbuild
@@ -300,7 +295,7 @@ define do_install
 	$(INSTALL) $1 '$(DESTDIR_SQ)$2'
 endef
 
-install_lib: all_cmd install_plugins install_python
+install_lib: all_cmd
 	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
 
 install: install_lib
-- 
1.7.11.7

