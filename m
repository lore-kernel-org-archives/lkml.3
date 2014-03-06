Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaCFGRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:17:54 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:47636 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaCFGRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:17:52 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: remove useless cast on kzalloc()
Date: Thu, 06 Mar 2014 15:17:47 +0900
Message-ID: <5148119.7kyCp0YkBT@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


coccinelle warning:
drivers/staging/dgap/dgap.c:782:3-7: WARNING:
 casting value returned by k[cmz]alloc to (char *) is useless.
drivers/staging/dgap/dgap.c:776:2-16: WARNING:
 casting value returned by k[cmz]alloc to (struct board_t *) is useless.

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index cbce457..1adcd13 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -773,13 +773,13 @@ static int dgap_found_board(struct pci_dev *pdev, int id)
 
 	/* get the board structure and prep it */
 	brd = dgap_Board[dgap_NumBoards] =
-	(struct board_t *) kzalloc(sizeof(struct board_t), GFP_KERNEL);
+		kzalloc(sizeof(struct board_t), GFP_KERNEL);
 	if (!brd)
 		return -ENOMEM;
 
 	/* make a temporary message buffer for the boot messages */
 	brd->msgbuf = brd->msgbuf_head =
-		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
+		kzalloc(sizeof(char) * 8192, GFP_KERNEL);
 	if (!brd->msgbuf) {
 		kfree(brd);
 		return -ENOMEM;
-- 
1.7.4.4


