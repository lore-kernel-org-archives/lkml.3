Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbaGODCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:02:01 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40862 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaGODCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:02:00 -0400
Date: Tue, 15 Jul 2014 12:00:43 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com
Cc: markh@compro.net, daeseok.youn@gmail.com, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] staging: dgap: remove redundant error value check
Message-ID: <20140715030043.GA14349@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The retval in dgap_block_til_ready() is initialized to zero,
and if no error has occurred in this function, the retval has a zero.
So it doesn't need to check "retval" itself.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 32988a8..10bd0f2 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -2181,10 +2181,7 @@ static int dgap_block_til_ready(struct tty_struct *tty, struct file *file,
 
 	spin_unlock_irqrestore(&ch->ch_lock, lock_flags);
 
-	if (retval)
-		return retval;
-
-	return 0;
+	return retval;
 }
 
 /*
-- 
1.7.1

