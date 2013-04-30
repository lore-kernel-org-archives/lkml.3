Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab3D3UCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:02:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34640 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab3D3UCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:02:23 -0400
Date: Tue, 30 Apr 2013 15:01:58 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: [PATCH 9/9] rsxx: Disallows DMA transfer during format.
Message-ID: <20130430200158.GB15930@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043020-7182-0000-0000-0000067980F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Verifies the card is not formatting before DMAs are
transferred.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-04-29 16:06:49.997249172 -0500
+++ linux-block/drivers/block/rsxx/dma.c	2013-04-29 16:10:46.960184429 -0500
@@ -721,7 +721,8 @@ int rsxx_dma_queue_bio(struct rsxx_cardi
 		}
 	}
 
-	if (unlikely(card->halt))
+	if (unlikely(card->halt) ||
+	    unlikely(card->state == CARD_STATE_FORMATTING))
 		goto bvec_err;
 
 	for (i = 0; i < card->n_targets; i++) {

