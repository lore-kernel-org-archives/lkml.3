Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaISP4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:56:47 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:48343 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbaISP4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:56:45 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.debian@gmx.de>,
        Jan Kara <jack@suse.cz>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] inotify.7: describe ambiguous behaviour of IN_DELETE_SELF
Date: Fri, 19 Sep 2014 19:56:13 +0400
Message-Id: <1411142173-3072-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411141516-1918-1-git-send-email-avagin@openvz.org>
References: <1411141516-1918-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since kernel 3.18, IN_DELETE_SELF occurs only if nobody uses an object.
Before, if we have two hardlinks where one of them  is  opened and  we
delete  the opened  file  before  the second one, we receive
IN_DELETE_SELF.  It's wrong, because the file remains opened. If files
are deleted in another order, we don't receive IN_DELETE_SELF as expected.

This patch can be committed only after the kernel patch:
"[PATCH] fs: don't remove inotify watchers from alive inode-s (v2)"

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 man7/inotify.7 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man7/inotify.7 b/man7/inotify.7
index e1cabe2..b7a6e2f 100644
--- a/man7/inotify.7
+++ b/man7/inotify.7
@@ -504,6 +504,19 @@ if the older had not yet been read)
 instead checked if the most recent event could be coalesced with the
 .I oldest
 unread event.
+
+Since kernel 3.18,
+.\" commit XXXXXX
+.B IN_DELETE_SELF
+occurs only if nobody uses an object. Before, if we have two hardlinks where
+one of them is opened and we delete the opened file before the second one, we
+receive
+.B IN_DELETE_SELF.
+It's wrong, because the file remains opened. If files are deleted in another
+order, we don't receive
+.B IN_DELETE_SELF
+as expected.
+
 .SH SEE ALSO
 .BR inotifywait (1),
 .BR inotifywatch (1),
-- 
1.9.3

