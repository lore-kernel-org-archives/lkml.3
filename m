Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760817AbbA2JLE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:11:04 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44941 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932871AbbA2JI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:57 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ilya Dryomov <idryomov@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 042/176] ceph: do_sync is never initialized
Date: Wed, 28 Jan 2015 15:27:52 +0100
Message-Id: <f844de9aa69cd95c52636e5b4faeaf1353477252.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 021b77bee210843bed1ea91b5cad58235ff9c8e5 upstream.

Probably this code was syncing a lot more often then intended because
the do_sync variable wasn't set to zero.

Fixes: c62988ec0910 ('ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index ec3ba43b9faa..f757dffb715e 100644
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
2.2.2

