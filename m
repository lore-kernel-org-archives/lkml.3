Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaETNMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:12:20 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:37170 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaETNMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:12:19 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Documentation: fix DOCBOOKS=... building
Date: Tue, 20 May 2014 15:12:07 +0200
Message-Id: <1400591527-16685-1-git-send-email-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Prior to
commit 4266129964b8238526936d723de65b419d8069c6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Tue May 31 16:27:44 2011 -0300

    [media] DocBook: Move all media docbook stuff into its own directory

it was possible to build only a single (or more)
book(s) by calling, for example
	make htmldocs DOCBOOKS=80211.xml

This now fails:
cp: target `.../Documentation/DocBook//media_api' is not a directory

Ignore errors from that copy to make this possible again.

Fixes: 4266129964b8 ("[media] DocBook: Move all media docbook stuff into its own directory")
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Both Rand and I sent this patch almost a year ago, but it didn't stick.
Can somebody please take it? :-)

Thanks,
johannes
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
2.0.0.rc0

