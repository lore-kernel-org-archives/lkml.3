Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaFRP22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:28:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaFRP21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:28:27 -0400
From: Michal Marek <mmarek@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH] Documentation: Fix DocBook build with relative $(srctree)
Date: Wed, 18 Jun 2014 17:27:42 +0200
Message-Id: <1403105262-16367-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <539F2926.4020004@infradead.org>
References: <539F2926.4020004@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commits 890676c6 (kbuild: Use relative path when building in the source
tree) and 9da0763b (kbuild: Use relative path when building in a subdir
of the source tree), the $(srctree) variable can be a relative path.
This breaks Documentation/DocBook/media/Makefile, because it tries to
create symlinks from a subdirectory of the object tree to the source
tree. Fix this by using a full path in this case.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Documentation/DocBook/media/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 1d27f0a..639e748 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -202,8 +202,8 @@ $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 
 $(MEDIA_OBJ_DIR)/v4l2.xml: $(OBJIMGFILES)
 	@$($(quiet)gen_xml)
-	@(ln -sf $(MEDIA_SRC_DIR)/v4l/*xml $(MEDIA_OBJ_DIR)/)
-	@(ln -sf $(MEDIA_SRC_DIR)/dvb/*xml $(MEDIA_OBJ_DIR)/)
+	@(ln -sf `cd $(MEDIA_SRC_DIR) && /bin/pwd`/v4l/*xml $(MEDIA_OBJ_DIR)/)
+	@(ln -sf `cd $(MEDIA_SRC_DIR) && /bin/pwd`/dvb/*xml $(MEDIA_OBJ_DIR)/)
 
 $(MEDIA_OBJ_DIR)/videodev2.h.xml: $(srctree)/include/uapi/linux/videodev2.h $(MEDIA_OBJ_DIR)/v4l2.xml
 	@$($(quiet)gen_xml)
-- 
1.9.2

