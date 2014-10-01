Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaJAKLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:11:55 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33336 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751063AbaJAKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:11:54 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] rsxx: Remove deprecated IRQF_DISABLED
Date: Wed,  1 Oct 2014 12:11:48 +0200
Message-Id: <1412158308-7171-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <drivers/block/rsxx-remove-irqf-disabled>
References: <drivers/block/rsxx-remove-irqf-disabled>
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
index 820b4009d5f7..9f913087cb81 100644
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
1.9.1

