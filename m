Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab3BEWJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47955 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358Ab3BEWJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Ding <dinggnu@gmail.com>, Steve French <smfrench@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 29/93] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
Date: Tue,  5 Feb 2013 20:06:18 -0200
Message-Id: <1360102042-10732-30-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Ding <dinggnu@gmail.com>

commit 10b8c7dff5d3633b69e77f57d404dab54ead3787 upstream.

When it goes to error through line 144, the memory allocated to *devname is
not freed, and the caller doesn't free it either in line 250. So we free the
memroy of *devname in function cifs_compose_mount_options() when it goes to
error.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/cifs/cifs_dfs_ref.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 6873bb6..2263144 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -226,6 +226,8 @@ compose_mount_options_out:
 compose_mount_options_err:
 	kfree(mountdata);
 	mountdata = ERR_PTR(rc);
+	kfree(*devname);
+	*devname = NULL;
 	goto compose_mount_options_out;
 }
 
-- 
1.7.9.5

