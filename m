Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab3FRTvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:51:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42616 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3FRTvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:51:05 -0400
Date: Tue, 18 Jun 2013 14:50:48 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 10/11] rsxx: Fixes incorrect stats calculation.
Message-ID: <20130618195048.GK6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-7182-0000-0000-00000764467B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Fixing incorrect stats calculation during read retries.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-06-18 09:27:53.702978010 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-06-18 09:50:30.422844487 -0500
@@ -269,6 +269,7 @@ static void rsxx_requeue_dma(struct rsxx
 	 * first.
 	 */
 	spin_lock_bh(&ctrl->queue_lock);
+	ctrl->stats.sw_q_depth++;
 	list_add(&dma->list, &ctrl->queue);
 	spin_unlock_bh(&ctrl->queue_lock);
 }

