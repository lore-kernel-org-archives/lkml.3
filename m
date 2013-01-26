Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3AZBby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:54 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55848 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3AZBbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:32 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 08/14] rpmsg: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:06 -0800
Message-Id: <1359163872-1949-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 drivers/rpmsg/virtio_rpmsg_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index f1e3239..aa334b6 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1036,7 +1036,6 @@ static void rpmsg_remove(struct virtio_device *vdev)
 	if (vrp->ns_ept)
 		__rpmsg_destroy_ept(vrp, vrp->ns_ept);
 
-	idr_remove_all(&vrp->endpoints);
 	idr_destroy(&vrp->endpoints);
 
 	vdev->config->del_vqs(vrp->vdev);
-- 
1.8.1

