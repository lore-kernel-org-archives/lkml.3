Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbbAIMFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 07:05:14 -0500
Received: from nautica.notk.org ([91.121.71.147]:35213 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388AbbAIMFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 07:05:12 -0500
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2015 07:05:12 EST
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH] fs/9p: Initialize status in v9fs_file_do_lock.
Date: Fri,  9 Jan 2015 12:56:07 +0100
Message-Id: <1420804567-15371-1-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If p9_client_lock_dotl returns an error, status is possibly never filled
but will be used in the following switch.
Initializing it to P9_LOCK_ERROR makes sur we will return an error and
cleanup (and not hit the default case).

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---
 fs/9p/vfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 5594505..9b02849 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -149,7 +149,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
 	struct p9_flock flock;
 	struct p9_fid *fid;
-	uint8_t status;
+	uint8_t status = P9_LOCK_ERROR;
 	int res = 0;
 	unsigned char fl_type;
 
-- 
1.9.3

