Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030326AbaGCKOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:14:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54149 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbaGCKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:14:47 -0400
Date: Thu, 3 Jul 2014 19:13:39 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] staging: dgnc: remove redundant memset call
Message-ID: <20140703101339.GA18974@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brd is allocated by kzalloc() in dgnc_found_board()
so do not need to set 0 to member variable.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index c07ec74..714a069 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -200,9 +200,6 @@ int dgnc_tty_register(struct dgnc_board *brd)
 
 	DPR_INIT(("tty_register start\n"));
 
-	memset(&brd->SerialDriver, 0, sizeof(brd->SerialDriver));
-	memset(&brd->PrintDriver, 0, sizeof(brd->PrintDriver));
-
 	brd->SerialDriver.magic = TTY_DRIVER_MAGIC;
 
 	snprintf(brd->SerialName, MAXTTYNAMELEN, "tty_dgnc_%d_", brd->boardnum);
-- 
1.7.1

