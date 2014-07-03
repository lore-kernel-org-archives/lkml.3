Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbaGCKNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:13:14 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53525 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaGCKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:13:10 -0400
Date: Thu, 3 Jul 2014 19:12:01 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: dgnc: remove redundant null check for kfree()
Message-ID: <20140703101201.GA18954@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 4135cb0..8081621 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -417,10 +417,8 @@ int dgnc_tty_init(struct dgnc_board *brd)
  */
 void dgnc_tty_post_uninit(void)
 {
-	if (dgnc_TmpWriteBuf) {
-		kfree(dgnc_TmpWriteBuf);
-		dgnc_TmpWriteBuf = NULL;
-	}
+	kfree(dgnc_TmpWriteBuf);
+	dgnc_TmpWriteBuf = NULL;
 }
 
 
@@ -456,14 +454,10 @@ void dgnc_tty_uninit(struct dgnc_board *brd)
 		brd->dgnc_Major_TransparentPrint_Registered = FALSE;
 	}
 
-	if (brd->SerialDriver.ttys) {
-		kfree(brd->SerialDriver.ttys);
-		brd->SerialDriver.ttys = NULL;
-	}
-	if (brd->PrintDriver.ttys) {
-		kfree(brd->PrintDriver.ttys);
-		brd->PrintDriver.ttys = NULL;
-	}
+	kfree(brd->SerialDriver.ttys);
+	brd->SerialDriver.ttys = NULL;
+	kfree(brd->PrintDriver.ttys);
+	brd->PrintDriver.ttys = NULL;
 }
 
 
-- 
1.7.1

