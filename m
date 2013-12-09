Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3LIJVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:21:25 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33970 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932230Ab3LIJVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:21:24 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: willy@linux.intel.com
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] NVMe: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:21:19 +0100
Message-Id: <1386580879-4337-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381551809-6236-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381551809-6236-1-git-send-email-michael.opdenacker@free-electrons.com>
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
index 26d03fa0bf26..ab76e530686f 100644
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
1.8.3.2

