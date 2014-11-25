Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaKYLUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:20:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58738 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaKYKmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 145/254] rbd: fix error return code in rbd_dev_device_setup()
Date: Tue, 25 Nov 2014 10:38:15 +0000
Message-Id: <1416912004-5928-146-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 255939e783d8f45f8c58487dfc18957c44ea9871 upstream.

Fix to return -ENOMEM from the workqueue alloc error handling
case instead of 0, as done elsewhere in this function.

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 453afd257530..5c38fe1f4b85 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5104,8 +5104,10 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 	set_disk_ro(rbd_dev->disk, rbd_dev->mapping.read_only);
 
 	rbd_dev->rq_wq = alloc_workqueue("%s", 0, 0, rbd_dev->disk->disk_name);
-	if (!rbd_dev->rq_wq)
+	if (!rbd_dev->rq_wq) {
+		ret = -ENOMEM;
 		goto err_out_mapping;
+	}
 
 	ret = rbd_bus_add_dev(rbd_dev);
 	if (ret)
-- 
2.1.0

