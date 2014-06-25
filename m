Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248AbaFYSJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 14:09:31 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:35205 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851AbaFYSJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 14:09:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMHABoPq1NXQ7ge/2dsb2JhbABZgw2rLgsFAZk6gQ4XdYRgI4EaN4hGAapxmBYXhWOJGR2ELQWPdIpdk2uDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Steve French <sfrench@samba.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cifs/file.c: replace count*size kzalloc by kcalloc
Date: Wed, 25 Jun 2014 20:09:24 +0200
Message-Id: <1403719764-18860-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kcalloc manages count*sizeof overflow.

Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e90a1e9..3c1967c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1058,7 +1058,7 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
-	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf) {
 		free_xid(xid);
 		return -ENOMEM;
@@ -1393,7 +1393,7 @@ cifs_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
 
 	max_num = (max_buf - sizeof(struct smb_hdr)) /
 						sizeof(LOCKING_ANDX_RANGE);
-	buf = kzalloc(max_num * sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
+	buf = kcalloc(max_num, sizeof(LOCKING_ANDX_RANGE), GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-- 
1.9.1

