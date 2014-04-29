Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaD2OI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:08:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbaD2OI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:27 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] kbuild: Use relative path when building in a subdir of the source tree
Date: Tue, 29 Apr 2014 16:08:13 +0200
Message-Id: <1398780493-15391-6-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing make O=<subdir>, use '..' to refer to the source tree. This
allows for more readable compiler messages, and, more importantly, it
sets the VPATH to '..', so filenames in WARN_ON() etc. will be shorter.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7ae9e9d..3d311b6 100644
--- a/Makefile
+++ b/Makefile
@@ -153,7 +153,17 @@ else
 _all: modules
 endif
 
-srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),.)
+ifeq ($(KBUILD_SRC),)
+        # building in the source tree
+        srctree := .
+else
+        ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
+                # building in a subdirectory of the source tree
+                srctree := ..
+        else
+                srctree := $(KBUILD_SRC)
+        endif
+endif
 objtree		:= .
 src		:= $(srctree)
 obj		:= $(objtree)
-- 
1.9.2

