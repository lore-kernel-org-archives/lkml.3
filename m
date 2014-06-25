Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaFYSLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:11:37 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:11027 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757986AbaFYSLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:11:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMHABUQq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZk6gQ4XdYRgI4EaN4hGAap0mC2FY4kZHYQtBY90il2Ta4NEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steve French <sfrench@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cifs/smb2file.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:11:28 +0200
Message-Id: <1403719888-18966-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/smb2file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3f17b45..e5100b8 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -111,7 +111,7 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 		return -EINVAL;
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
@@ -247,7 +247,7 @@ smb2_push_mandatory_locks(struct cifsFileInfo *cfile)
 	}
 
 	max_num = max_buf / sizeof(struct smb2_lock_element);
-	buf = kzalloc(max_num * sizeof(struct smb2_lock_element), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(struct smb2_lock_element), GFP_KERNEL);
 	if (!buf) {
 		free_xid(xid);
 		return -ENOMEM;
-- 
1.9.1

