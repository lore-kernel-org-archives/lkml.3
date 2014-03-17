Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbaCQNgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:36:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51821 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293AbaCQNbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:31:37 -0400
Message-Id: <20140317133136.747017596@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 17 Mar 2014 06:28:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 35/39] virtio_scsi: use blk_mq
References: <20140317132733.789623766@bombadil.infradead.org>
Content-Disposition: inline; filename=0035-virtio_scsi-use-blk_mq.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/virtio_scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 5ec4a73..98469cd 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -680,6 +680,7 @@ static struct scsi_host_template virtscsi_host_template_single = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.use_blk_mq = true,
 };
 
 static struct scsi_host_template virtscsi_host_template_multi = {
@@ -697,6 +698,7 @@ static struct scsi_host_template virtscsi_host_template_multi = {
 	.use_clustering = ENABLE_CLUSTERING,
 	.target_alloc = virtscsi_target_alloc,
 	.target_destroy = virtscsi_target_destroy,
+	.use_blk_mq = true,
 };
 
 #define virtscsi_config_get(vdev, fld) \
-- 
1.7.10.4


