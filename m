Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaKLBWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:22:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbaKLBWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:22:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilya Dryomov <idryomov@redhat.com>, Micha Krause <micha@krausam.de>,
        Sage Weil <sage@redhat.com>
Subject: [PATCH 3.17 066/319] rbd: rbd workqueues need a resque worker
Date: Wed, 12 Nov 2014 10:13:24 +0900
Message-Id: <20141112011003.554135655@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@redhat.com>

commit 792c3a914910bd34302c5345578f85cfcb5e2c01 upstream.

Need to use WQ_MEM_RECLAIM for our workqueues to prevent I/O lockups
under memory pressure - we sit on the memory reclaim path.

Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Tested-by: Micha Krause <micha@krausam.de>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5087,7 +5087,8 @@ static int rbd_dev_device_setup(struct r
 	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
 	set_disk_ro(rbd_dev->disk, rbd_dev->mapping.read_only);
 
-	rbd_dev->rq_wq = alloc_workqueue("%s", 0, 0, rbd_dev->disk->disk_name);
+	rbd_dev->rq_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
+					 rbd_dev->disk->disk_name);
 	if (!rbd_dev->rq_wq) {
 		ret = -ENOMEM;
 		goto err_out_mapping;


