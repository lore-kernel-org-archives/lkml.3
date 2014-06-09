Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbaFIXAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:00:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933974AbaFIWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 08/40] Documentation: fix DOCBOOKS=... building
Date: Mon,  9 Jun 2014 15:48:39 -0700
Message-Id: <20140609224839.477044912@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/DocBook/media/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -195,7 +195,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@


