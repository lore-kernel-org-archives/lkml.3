Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaJSP5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 11:57:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:40799 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaJSP5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 11:57:38 -0400
From: Christoph Hellwig <hch@lst.de>
To: Chandra Seetharaman <sekharan@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>
Cc: Sean Stewart <Sean.Stewart@netapp.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] scsi_dh_hp_sw: fix return value on failed allocation
Date: Sun, 19 Oct 2014 18:00:03 +0200
Message-Id: <1413734404-1426-6-git-send-email-hch@lst.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413734404-1426-1-git-send-email-hch@lst.de>
References: <1413734404-1426-1-git-send-email-hch@lst.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index aa40fcb..471ffd1 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -363,7 +363,7 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (!h) {
 		sdev_printk(KERN_ERR, sdev, "%s: Attach Failed\n",
 			    HP_SW_NAME);
-		return 0;
+		return -ENOMEM;
 	}
 
 	h->dh_data.scsi_dh = &hp_sw_dh;
-- 
1.9.1

