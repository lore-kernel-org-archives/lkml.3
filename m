Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaLBTUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:20:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46449 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbaLBTUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:20:25 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        ceph-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ilya Dryomov <idryomov@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 018/121] rbd: Fix error recovery in rbd_obj_read_sync()
Date: Tue,  2 Dec 2014 11:18:17 -0800
Message-Id: <1417548000-1794-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a8d4205623ae965e36c68629db306ca0695a2771 upstream.

When we fail to allocate page vector in rbd_obj_read_sync() we just
basically ignore the problem and continue which will result in an oops
later. Fix the problem by returning proper error.

CC: Yehuda Sadeh <yehuda@inktank.com>
CC: Sage Weil <sage@inktank.com>
CC: ceph-devel@vger.kernel.org
Coverity-id: 1226882
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a1455cc..5224f46 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3220,7 +3220,7 @@ static int rbd_obj_read_sync(struct rbd_device *rbd_dev,
 	page_count = (u32) calc_pages_for(offset, length);
 	pages = ceph_alloc_page_vector(page_count, GFP_KERNEL);
 	if (IS_ERR(pages))
-		ret = PTR_ERR(pages);
+		return PTR_ERR(pages);
 
 	ret = -ENOMEM;
 	obj_request = rbd_obj_request_create(object_name, offset, length,
-- 
1.9.1

