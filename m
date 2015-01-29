Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbbA2EsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:48:22 -0500
Received: from mail-oi0-f53.google.com ([209.85.218.53]:55212 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbA2EsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:48:21 -0500
From: Brian Norris <computersforpeace@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Howells <dhowells@redhat.com>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] tools: unbreak 'make tools/*'
Date: Wed, 28 Jan 2015 20:47:36 -0800
Message-Id: <1422506856-28631-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following targets should be supported from the top-level source
directory, but were broken by commit 7e1c04779efd ("kbuild: Use relative
path for $(objtree)"):

 $ make tools/
 $ make tools/perf
 $ make O=$(BUILDDIR) tools/perf

The tools/ and tools/% targets are passing the top-level build directory
as an O= argument, so we need a full path, not a relative one, as the
$(O) variable will be reinterpreted by the sub-makefile.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 95a0e827ecd3..59033c8bf93a 100644
--- a/Makefile
+++ b/Makefile
@@ -1496,11 +1496,11 @@ image_name:
 # Clear a bunch of variables before executing the submake
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(CURDIR) subdir=tools -C $(src)/tools/
 
 tools/%: FORCE
 	$(Q)mkdir -p $(objtree)/tools
-	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(objtree) subdir=tools -C $(src)/tools/ $*
+	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS="$(filter --j% -j,$(MAKEFLAGS))" O=$(CURDIR) subdir=tools -C $(src)/tools/ $*
 
 # Single targets
 # ---------------------------------------------------------------------------
-- 
2.3.0.rc1

