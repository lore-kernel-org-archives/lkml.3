Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbaKYLVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:21:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaKYKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 144/254] rbd: avoid format-security warning inside alloc_workqueue()
Date: Tue, 25 Nov 2014 10:38:14 +0000
Message-Id: <1416912004-5928-145-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 58d1362b50dc87ebf18cd137e7a879fd99b7e721 upstream.

drivers/block/rbd.c: In function ‘rbd_dev_device_setup’:
drivers/block/rbd.c:5090:19: warning: format not a string literal and no format arguments [-Wformat-security]

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a15500662f4c..453afd257530 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5103,7 +5103,7 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
 	set_disk_ro(rbd_dev->disk, rbd_dev->mapping.read_only);
 
-	rbd_dev->rq_wq = alloc_workqueue(rbd_dev->disk->disk_name, 0, 0);
+	rbd_dev->rq_wq = alloc_workqueue("%s", 0, 0, rbd_dev->disk->disk_name);
 	if (!rbd_dev->rq_wq)
 		goto err_out_mapping;
 
-- 
2.1.0

