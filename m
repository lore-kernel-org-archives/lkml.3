Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3JLEXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:23:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54066 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750705Ab3JLEXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:23:32 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: willy@linux.intel.com
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] NVMe: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:23:29 +0200
Message-Id: <1381551809-6236-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/block/nvme-core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index da52092..c6699af 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1134,11 +1134,10 @@ static int queue_request_irq(struct nvme_dev *dev, struct nvme_queue *nvmeq,
 {
 	if (use_threaded_interrupts)
 		return request_threaded_irq(dev->entry[nvmeq->cq_vector].vector,
-					nvme_irq_check, nvme_irq,
-					IRQF_DISABLED | IRQF_SHARED,
+					nvme_irq_check, nvme_irq, IRQF_SHARED,
 					name, nvmeq);
 	return request_irq(dev->entry[nvmeq->cq_vector].vector, nvme_irq,
-				IRQF_DISABLED | IRQF_SHARED, name, nvmeq);
+				IRQF_SHARED, name, nvmeq);
 }
 
 static void nvme_init_queue(struct nvme_queue *nvmeq, u16 qid)
-- 
1.8.1.2

