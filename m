Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3FDXAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:00:18 -0400
Received: from 1wt.eu ([62.212.114.60]:35693 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab3FDWnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:16 -0400
Message-Id: <20130604172135.943740578@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>, Steve French <smfrench@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 136/184] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/cifs/cifs_dfs_ref.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index fea9e89..b36a8aa 100644
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
1.7.12.2.21.g234cd45.dirty



