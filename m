Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab3LIKD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:03:59 -0500
Received: from top.free-electrons.com ([176.31.233.9]:34367 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754700Ab3LIKDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:03:22 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] ibmvstgt: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:03:17 +0100
Message-Id: <1386583397-5126-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381039635-12187-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381039635-12187-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

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

