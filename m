Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3LIJXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 04:23:17 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33977 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932351Ab3LIJXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 04:23:14 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: josh.h.morris@us.ibm.com, pjk1939@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] rsxx: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 10:23:10 +0100
Message-Id: <1386580990-4391-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381551572-6172-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381551572-6172-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
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

