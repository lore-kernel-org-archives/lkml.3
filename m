Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423035Ab3FUCql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:46:41 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:56344 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422818Ab3FUCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:46:40 -0400
MIME-Version: 1.0
Date: Fri, 21 Jun 2013 10:46:38 +0800
Message-ID: <CAPgLHd8cSqV_+bqNq7d8HedKL5BXdqC5-sqqkOM7kVZJK7cumg@mail.gmail.com>
Subject: [PATCH -next] rsxx: fix error return code in rsxx_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: josh.h.morris@us.ibm.com, axboe@kernel.dk, pjk1939@linux.vnet.ibm.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the create_singlethread_workqueue() error handling
case instead of 0, as done elsewhere in this function.

Introduced by commit a3299ab18591d36ad5622f5064619123c439b779.
(rsxx: Individual workqueues for interruptible events.)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/block/rsxx/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/rsxx/core.c b/drivers/block/rsxx/core.c
index 6e85e21..11eb897 100644
--- a/drivers/block/rsxx/core.c
+++ b/drivers/block/rsxx/core.c
@@ -946,6 +946,7 @@ static int rsxx_pci_probe(struct pci_dev *dev,
 	card->event_wq = create_singlethread_workqueue(DRIVER_NAME"_event");
 	if (!card->event_wq) {
 		dev_err(CARD_TO_DEV(card), "Failed card event setup.\n");
+		st = -ENOMEM;
 		goto failed_event_handler;
 	}
 

