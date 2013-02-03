Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3BCPKM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:10:12 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34397 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530Ab3BCO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:49 -0500
Message-Id: <20130203144651.016788660@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Ding <dinggnu@gmail.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 078/128] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifs_dfs_ref.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index ce5cbd7..210fce2 100644
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
 


