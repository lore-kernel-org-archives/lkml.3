Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763743AbbA2DLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:11:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46976 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054AbbA2Cgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:49 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ilya Dryomov <idryomov@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 134/139] ceph: do_sync is never initialized
Date: Wed, 28 Jan 2015 14:21:17 -0800
Message-Id: <1422483682-15393-135-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 021b77bee210843bed1ea91b5cad58235ff9c8e5 upstream.

Probably this code was syncing a lot more often then intended because
the do_sync variable wasn't set to zero.

Fixes: c62988ec0910 ('ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ec3ba43..f757dff 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -672,7 +672,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	int rc = 0;
 	unsigned wsize = 1 << inode->i_blkbits;
 	struct ceph_osd_request *req = NULL;
-	int do_sync;
+	int do_sync = 0;
 	u64 truncate_size, snap_size;
 	u32 truncate_seq;
 
-- 
1.9.1

