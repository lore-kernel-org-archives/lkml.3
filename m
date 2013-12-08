Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab3LHVJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 16:09:45 -0500
Received: from mail.tpi.com ([74.45.170.26]:59116 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759922Ab3LHVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 16:09:09 -0500
From: Tim Gardner <timg@tpi.com>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Cc: Tim Gardner <timg@tpi.com>, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@redhat.com>, Dean Gehnert <deang@tpi.com>
Subject: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count check
Date: Sun,  8 Dec 2013 14:08:43 -0700
Message-Id: <1386536924-51726-4-git-send-email-timg@tpi.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386536924-51726-1-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference count on tlink can only be decremented if
cifs_sb_tlink(cifs_sb) was used to acquire it. That only
happens if open_file==NULL.

Cc: Steve French <sfrench@samba.org>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Dean Gehnert <deang@tpi.com>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

V2 - this is a new patch in the V2 series.

 fs/cifs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3f710c6..e332038 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 			CIFSSMBClose(xid, tcon, netfid);
 		}
 	}
-	if (tlink)
+	if (!open_file)
 		cifs_put_tlink(tlink);
 
 set_size_out:
-- 
1.7.9.5

