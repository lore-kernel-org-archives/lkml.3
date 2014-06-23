Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaFWIoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:44:21 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55582 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752623AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 021/111] Documentation: fix DOCBOOKS=... building
Date: Mon, 23 Jun 2014 10:30:56 +0200
Message-Id: <4552eb241957702f9bc1309dba4d936629c5f0c7.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e60cbeedc48d80689c249ab5dcc3c31ad0452dea upstream.

Prior to commit 4266129964b8 ("[media] DocBook: Move all media docbook
stuff into its own directory") it was possible to build only a single
(or more) book(s) by calling, for example

    make htmldocs DOCBOOKS=80211.xml

This now fails:

    cp: target `.../Documentation/DocBook//media_api' is not a directory

Ignore errors from that copy to make this possible again.

Fixes: 4266129964b8 ("[media] DocBook: Move all media docbook stuff into its own directory")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 Documentation/DocBook/media/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index f9fd615427fb..1d27f0a1abd1 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -195,7 +195,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@
-- 
2.0.0

