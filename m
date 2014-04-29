Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841AbaD2OJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:09:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520AbaD2OI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:08:26 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] kbuild: Use relative path for $(objtree)
Date: Tue, 29 Apr 2014 16:08:11 +0200
Message-Id: <1398780493-15391-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
References: <1398780493-15391-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main Makefile sets its working directory to the object tree and
never changes it again. Therefore, we can use '.' instead of the
absolute path.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 60ccbfe..7273a3b 100644
--- a/Makefile
+++ b/Makefile
@@ -154,7 +154,7 @@ _all: modules
 endif
 
 srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
-objtree		:= $(CURDIR)
+objtree		:= .
 src		:= $(srctree)
 obj		:= $(objtree)
 
-- 
1.9.2

