Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbbALS5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:57:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbbALSaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 144/216] ceph: do_sync is never initialized
Date: Mon, 12 Jan 2015 18:28:42 +0000
Message-Id: <1421087394-2712-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 021b77bee210843bed1ea91b5cad58235ff9c8e5 upstream.

Probably this code was syncing a lot more often then intended because
the do_sync variable wasn't set to zero.

Fixes: c62988ec0910 ('ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/addr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 90b3954d48ed..9bfd1af53b08 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -673,7 +673,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	int rc = 0;
 	unsigned wsize = 1 << inode->i_blkbits;
 	struct ceph_osd_request *req = NULL;
-	int do_sync;
+	int do_sync = 0;
 	u64 truncate_size, snap_size;
 	u32 truncate_seq;
 
-- 
2.1.4

