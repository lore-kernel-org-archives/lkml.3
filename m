Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbaGCKNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:13:43 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59973 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965015AbaGCKNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:13:40 -0400
Date: Thu, 3 Jul 2014 19:12:31 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] staging: dgnc: Fix unsigned value for less than zero
Message-ID: <20140703101231.GA18962@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "un->un_open_count" is unsigned variable, so it cannot
be less than zero.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 8081621..f7409d9 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -1636,10 +1636,10 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		un->un_open_count = 1;
 	}
 
-	if (--un->un_open_count < 0) {
+	if (un->un_open_count)
+		un->un_open_count--;
+	else
 		APR(("bad serial port open count of %d\n", un->un_open_count));
-		un->un_open_count = 0;
-	}
 
 	ch->ch_open_count--;
 
-- 
1.7.1

