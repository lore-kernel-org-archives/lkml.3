Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534Ab3CYWKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:10:54 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36145 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326Ab3CYWKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:10:53 -0400
Date: Mon, 25 Mar 2013 17:10:46 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com
Subject: [PATCH] block: removes dynamic allocation on stack
Message-ID: <20130325221046.GB7136@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032522-7182-0000-0000-000005F15673
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch removes dynamic allocation on the stack error.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-03-25 14:44:40.898978713 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-03-25 14:50:48.054969658 -0500
@@ -986,7 +986,10 @@ void rsxx_eeh_save_issued_dmas(struct rs
 	int j;
 	int cnt;
 	struct rsxx_dma *dma;
-	struct list_head issued_dmas[card->n_targets];
+	struct list_head *issued_dmas;
+
+	issued_dmas = kzalloc(sizeof(*issued_dmas) * card->n_targets,
+			      GFP_KERNEL);
 
 	for (i = 0; i < card->n_targets; i++) {
 		INIT_LIST_HEAD(&issued_dmas[i]);
@@ -1025,6 +1028,8 @@ void rsxx_eeh_save_issued_dmas(struct rs
 		}
 		spin_unlock(&card->ctrl[i].queue_lock);
 	}
+
+	kfree(issued_dmas);
 }
 
 void rsxx_eeh_cancel_dmas(struct rsxx_cardinfo *card)

