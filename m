Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab3FRTtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:49:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59242 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:49:14 -0400
Date: Tue, 18 Jun 2013 14:48:38 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 8/11] rsxx: Adapter address space sanity check.
Message-ID: <20130618194837.GI6492@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061819-5406-0000-0000-000009ABA27A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

Adding a sanity check to guarentee that DMAs outside of the device's
address space will be errored out right away.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-06-18 09:39:43.154903231 -0500
+++ linux-block/drivers/block/rsxx/dev.c	2013-06-18 09:44:02.210841168 -0500
@@ -174,6 +174,9 @@ static void rsxx_make_request(struct req
 	if (!card)
 		goto req_err;
 
+	if (bio->bi_sector + (bio->bi_size >> 9) > get_capacity(card->gendisk))
+		goto req_err;
+
 	if (unlikely(card->halt)) {
 		st = -EFAULT;
 		goto req_err;

