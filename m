Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbaCDV0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:26:19 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44545 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757334AbaCDV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:26:16 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] rsxx: Remove deprecated IRQF_DISABLED
Date: Tue,  4 Mar 2014 22:25:40 +0100
Message-Id: <1393968340-18136-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386580990-4391-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386580990-4391-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the use of the IRQF_DISABLED flag
from drivers/block/rsxx/core.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Acked-by Philip Kelleher <pjk1939@linux.vnet.ibm.com>
---
 drivers/block/rsxx/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index a8de2eec6ff3..ddb6b2b2f451 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -886,7 +886,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 				"Failed to enable MSI\n");
 	}
 
-	st = request_irq(dev->irq, rsxx_isr, IRQF_DISABLED | IRQF_SHARED,
+	st = request_irq(dev->irq, rsxx_isr, IRQF_SHARED,
 			 DRIVER_NAME, card);
 	if (st) {
 		dev_err(CARD_TO_DEV(card),
-- 
1.8.3.2

