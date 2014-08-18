Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaHROd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:33:27 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59614 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaHROd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:33:26 -0400
Date: Mon, 18 Aug 2014 23:31:46 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: dgap: remove redundant setting a variable
Message-ID: <20140818143145.GA21818@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brd(board_t) is initialized with zero, so "intr_used"
is not needed to set zero when request_irq() is failed.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 45f20b4..ff95376 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -846,14 +846,9 @@ static int dgap_request_irq(struct board_t *brd)
 
 		rc = request_irq(brd->irq, dgap_intr, IRQF_SHARED, "DGAP", brd);
 
-		if (rc)
-			brd->intr_used = 0;
-		else
+		if (!rc)
 			brd->intr_used = 1;
-	} else {
-		brd->intr_used = 0;
 	}
-
 	return 0;
 }
 
-- 
1.7.1

