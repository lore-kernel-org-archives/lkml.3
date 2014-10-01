Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaJARMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:12:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46532 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaJARML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:12:11 -0400
From: Rahul Bedarkar <rahulbedarkar89@gmail.com>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>
Subject: [PATCH] staging: dgap: remove unused variable 'orig_count'
Date: Wed,  1 Oct 2014 22:41:36 +0530
Message-Id: <1412183496-12238-1-git-send-email-rahulbedarkar89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes sparse warning
warning: variable ‘orig_count’ set but not used [-Wunused-but-set-variable]

Signed-off-by: Rahul Bedarkar <rahulbedarkar89@gmail.com>
---
 drivers/staging/dgap/dgap.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 06c55cb..30723c3 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -2669,7 +2669,6 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 	char __iomem *vaddr;
 	u16 head, tail, tmask, remain;
 	int bufcount, n;
-	int orig_count;
 	ulong lock_flags;
 
 	if (!tty)
@@ -2690,13 +2689,6 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 	if (!count)
 		return 0;
 
-	/*
-	 * Store original amount of characters passed in.
-	 * This helps to figure out if we should ask the FEP
-	 * to send us an event when it has more space available.
-	 */
-	orig_count = count;
-
 	spin_lock_irqsave(&ch->ch_lock, lock_flags);
 
 	/* Get our space available for the channel from the board */
-- 
1.8.3.2

