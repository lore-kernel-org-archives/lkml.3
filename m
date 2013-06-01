Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab3FAA25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 20:28:57 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:40481 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab3FAA2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 20:28:51 -0400
Date: Fri, 31 May 2013 19:28:45 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] rsxx: Fixes incorrect stats calculation.
Message-ID: <20130601002845.GC3051@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060100-5518-0000-0000-00000F3CE5A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Fixing incorrect stats calculation during read retries.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-05-31 14:57:49.410326601 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-05-31 15:46:43.828260076 -0500
@@ -253,6 +253,7 @@ static void rsxx_requeue_dma(struct rsxx
 	 * first.
 	 */
 	spin_lock(&ctrl->queue_lock);
+	ctrl->stats.sw_q_depth++;
 	list_add(&dma->list, &ctrl->queue);
 	spin_unlock(&ctrl->queue_lock);
 }

