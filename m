Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbaCQNhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:37:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290AbaCQNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:36 -0400
Message-Id: <20140317133136.569692646@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 34/39] scsi: partially stub out scsi_adjust_queue_depth when using blk-mq
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0034-scsi-partially-stub-out-scsi_adjust_queue_depth-when.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will have to be funnelled to blk-mq directly, but skip it for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 7672371..22af3d3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -833,7 +833,7 @@ void scsi_adjust_queue_depth(struct scsi_device *sdev, int tagged, int tags)
 	 * is more IO than the LLD's can_queue (so there are not enuogh
 	 * tags) request_fn's host queue ready check will handle it.
 	 */
-	if (!sdev->host->bqt) {
+	if (!sdev->host->hostt->use_blk_mq && !sdev->host->bqt) {
 		if (blk_queue_tagged(sdev->request_queue) &&
 		    blk_queue_resize_tags(sdev->request_queue, tags) != 0)
 			goto out;
-- 
1.7.10.4


