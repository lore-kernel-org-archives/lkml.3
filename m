Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaDKIkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:40:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7959 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755531AbaDKIkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:40:11 -0400
X-IronPort-AV: E=Sophos;i="4.97,840,1389715200"; 
   d="scan'208";a="29141581"
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
To: <yehuda@inktank.com>, <sage@inktank.com>, <elder@kernel.org>,
        <ceph-devel@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Duan Jiong <duanj.fnst@cn.fujitsu.com>
Subject: [PATCH] rbd: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO
Date: Fri, 11 Apr 2014 16:38:12 +0800
Message-ID: <1397205492-24447-1-git-send-email-duanj.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.86]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coccinelle error regarding usage of IS_ERR and
PTR_ERR instead of PTR_ERR_OR_ZERO.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 4c95b50..552a2ed 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4752,7 +4752,7 @@ static int rbd_dev_image_id(struct rbd_device *rbd_dev)
 
 		image_id = ceph_extract_encoded_string(&p, p + ret,
 						NULL, GFP_NOIO);
-		ret = IS_ERR(image_id) ? PTR_ERR(image_id) : 0;
+		ret = PTR_ERR_OR_ZERO(image_id);
 		if (!ret)
 			rbd_dev->image_format = 2;
 	} else {
-- 
1.8.3.1

