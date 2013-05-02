Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab3EBAiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 20:38:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33329 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3EBAiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 20:38:19 -0400
Date: Wed, 1 May 2013 19:26:37 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 3/8] rsxx: Fixes incorrect stats calculation.
Message-ID: <20130502002637.GA29955@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050200-2876-0000-0000-00000833A1C1
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

