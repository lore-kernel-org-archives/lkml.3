Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaFFRfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:35:12 -0400
Received: from mout.web.de ([212.227.15.3]:61438 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbaFFRfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:35:00 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        linux-s390@vger.kernel.org
Subject: [PATCH 12/13] s390: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:31 +0200
Message-Id: <1402076072-4044-12-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:m/RJ9VTDrErFwNCE2nsYMD8jKltJFE2o58TAUwGXpYC3vpmiPzp
 k2+RCffs5c8+n7AksjoTmjnBWHJdonU1Y4rwOqV5cxXpgSykSGQ+qaU01StahTrRR2iVxXA
 X4/ncO/ysMA3rY2INioBdtjE7DDwqiWGEmFSvI8lNS5xXfNtHH+PGsnQoirLOWbZAnjTBxi
 zY3jnVUTZMkFGRiEKKrTw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/block/dasd_3990_erp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index d261347..2189e45 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2761,7 +2761,7 @@ dasd_3990_erp_action(struct dasd_ccw_req * cqr)
 	if (list_empty(&erp->blocklist)) {
 		cqr->status = DASD_CQR_IN_ERP;
 		/* add erp request before the cqr */
-		list_add_tail(&erp->blocklist, &cqr->blocklist);
+		list_add_before(&erp->blocklist, &cqr->blocklist);
 	}
 
 
-- 
2.0.0

