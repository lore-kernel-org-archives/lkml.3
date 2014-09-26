Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbaIZJqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:46:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbaIZJqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Shilovsky <pshilovsky@samba.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <smfrench@gmail.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 112/142] CIFS: Fix wrong restart readdir for SMB1
Date: Fri, 26 Sep 2014 11:45:23 +0200
Message-Id: <825196496f0fb1f575fcff42b5923cdc68333d0f.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Shilovsky <pshilovsky@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f736906a7669a77cf8cabdcbcf1dc8cb694e12ef upstream.

The existing code calls server->ops->close() that is not
right. This causes XFS test generic/310 to fail. Fix this
by using server->ops->closedir() function.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pavel Shilovsky <pshilovsky@samba.org>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/cifs/readdir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5940ecabbe6a..59edb8fd33aa 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -596,8 +596,8 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
 			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			if (server->ops->close)
-				server->ops->close(xid, tcon, &cfile->fid);
+			if (server->ops->close_dir)
+				server->ops->close_dir(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
 		if (cfile->srch_inf.ntwrk_buf_start) {
-- 
2.1.0

