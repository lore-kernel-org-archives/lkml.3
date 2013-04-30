Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626Ab3D3Tvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:51:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38117 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab3D3Tve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:51:34 -0400
Date: Tue, 30 Apr 2013 14:51:25 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 3/9] rsxx: Fixes incorrect stats calculation.
Message-ID: <20130430195125.GC22764@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043019-9360-0000-0000-000011F7C446
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Fixing incorrect stats calculation during read retries.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-04-29 11:25:00.596187375 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-04-29 13:58:27.979188201 -0500
@@ -253,6 +253,7 @@ static void rsxx_requeue_dma(struct rsxx
 	 * first.
 	 */
 	spin_lock(&ctrl->queue_lock);
+	ctrl->stats.sw_q_depth++;
 	list_add(&dma->list, &ctrl->queue);
 	spin_unlock(&ctrl->queue_lock);
 }

