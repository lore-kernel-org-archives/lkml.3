Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbaD2OIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:08:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54669 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933600AbaD2OI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:27 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] kbuild: Use relative path when building in the source tree
Date: Tue, 29 Apr 2014 16:08:12 +0200
Message-Id: <1398780493-15391-5-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When not using O=, $(srctree) refers to the same directory as
$(objtree), so we can set it to '.' as well. This makes the default
include path more compact and results in more readable messages from the
compiler.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 7273a3b..7ae9e9d 100644
--- a/Makefile
+++ b/Makefile
@@ -153,7 +153,7 @@ else
 _all: modules
 endif
 
-srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
+srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),.)
 objtree		:= .
 src		:= $(srctree)
 obj		:= $(objtree)
-- 
1.9.2

