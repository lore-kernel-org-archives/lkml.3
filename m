Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbaEIMwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 08:52:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755778AbaEIMwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 08:52:41 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2 3/5] kbuild: Use relative path for $(objtree)
Date: Fri,  9 May 2014 14:52:22 +0200
Message-Id: <1399639944-20551-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
References: <1399639944-20551-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main Makefile sets its working directory to the object tree and
never changes it again. Therefore, we can use '.' instead of the
absolute path. The only case where we need the absolute path is when
creating the 'build' symlink in /lib/modules.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v1->v2: Fix the 'build' symlink

 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 60ccbfe..480503a 100644
--- a/Makefile
+++ b/Makefile
@@ -154,7 +154,7 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+objtree		:= .
 src		:= $(srctree)
 obj		:= $(objtree)
 
@@ -1057,7 +1057,7 @@ _modinst_:
 	@ln -s $(srctree) $(MODLIB)/source
 	@if [ ! $(objtree) -ef  $(MODLIB)/build ]; then \
 		rm -f $(MODLIB)/build ; \
-		ln -s $(objtree) $(MODLIB)/build ; \
+		ln -s $(CURDIR) $(MODLIB)/build ; \
 	fi
 	@cp -f $(objtree)/modules.order $(MODLIB)/
 	@cp -f $(objtree)/modules.builtin $(MODLIB)/
-- 
1.8.4.5

