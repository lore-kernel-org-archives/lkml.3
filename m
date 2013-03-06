Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3CFXBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:01:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35834 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3CFXBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:01:40 -0500
From: Suman Anna <s-anna@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Suman Anna <s-anna@ti.com>, Tejun Heo <tj@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] remoteproc: fix the error check for idr_alloc
Date: Wed, 6 Mar 2013 16:56:48 -0600
Message-ID: <1362610608-64885-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new idr_alloc interface returns the allocated id back
on success, so fix the error path to check for negative
values. This was missed out in the newer idr interface
adoption patch, 15fc611 "remoteproc: convert to idr_alloc()".

Signed-off-by: Suman Anna <s-anna@ti.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/remoteproc/remoteproc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 29387df..fb0fb34 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -217,7 +217,7 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	 * TODO: support predefined notifyids (via resource table)
 	 */
 	ret = idr_alloc(&rproc->notifyids, rvring, 0, 0, GFP_KERNEL);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "idr_alloc failed: %d\n", ret);
 		dma_free_coherent(dev->parent, size, va, dma);
 		return ret;
-- 
1.8.1.2

