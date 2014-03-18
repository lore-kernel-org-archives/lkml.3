Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaCRIbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:31:50 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34536 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753816AbaCRIbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:31:46 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: akpm@linux-foundation.org, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] [SCSI] ibmvstgt: remove deprecated IRQF_DISABLED
Date: Tue, 18 Mar 2014 09:31:40 +0100
Message-Id: <1395131500-18211-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393997325-3927-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1393997325-3927-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from drivers/scsi/ibmvscsi/ibmvstgt.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/ibmvscsi/ibmvstgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index bf9eca845166..56f8a861ed72 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -589,7 +589,7 @@ static int crq_queue_create(struct crq_queue *queue, struct srp_target *target)
 	}
 
 	err = request_irq(vport->dma_dev->irq, &ibmvstgt_interrupt,
-			  IRQF_DISABLED, "ibmvstgt", target);
+			  0, "ibmvstgt", target);
 	if (err)
 		goto req_irq_failed;
 
-- 
1.8.3.2

