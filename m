Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767Ab3IKEon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:44:43 -0400
Received: from smtp.outflux.net ([198.145.64.163]:48220 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab3IKEom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:44:42 -0400
Date: Tue, 10 Sep 2013 21:41:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lidza Louina <lidza.louina@gmail.com>,
        Tushar Behera <tushar.behera@linaro.org>, devel@driverdev.osuosl.org
Subject: [PATCH] staging: dgnc: fix potential format string flaw
Message-ID: <20130911044116.GA17294@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that format strings cannot leak into printk() calls from the
msgbuf string.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/dgnc/dgnc_driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index f8c1e22..71d2b83 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -454,7 +454,7 @@ static void dgnc_cleanup_board(struct board_t *brd)
 
 		DGNC_LOCK(dgnc_global_lock, flags);
 		brd->msgbuf = NULL;
-		printk(brd->msgbuf_head);
+		printk("%s", brd->msgbuf_head);
 		kfree(brd->msgbuf_head);
 		brd->msgbuf_head = NULL;
 		DGNC_UNLOCK(dgnc_global_lock, flags);
@@ -710,7 +710,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	DPR_INIT(("dgnc_scan(%d) - printing out the msgbuf\n", i));
 	DGNC_LOCK(dgnc_global_lock, flags);
 	brd->msgbuf = NULL;
-	printk(brd->msgbuf_head);
+	printk("%s", brd->msgbuf_head);
 	kfree(brd->msgbuf_head);
 	brd->msgbuf_head = NULL;
 	DGNC_UNLOCK(dgnc_global_lock, flags);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
