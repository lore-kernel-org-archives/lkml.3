Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab3JPQCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:02:13 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45076 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3JPQCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:02:12 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: lidza.louina@gmail.com
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com, "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] drivers: staging: dgnc: Remove useless casting in dgnc_driver.c
Date: Wed, 16 Oct 2013 12:57:35 -0300
Message-Id: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casting (void *) value returned by kzalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 71d2b83..7f31ab5 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -498,16 +498,14 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	unsigned long flags;
 
 	/* get the board structure and prep it */
-	brd = dgnc_Board[dgnc_NumBoards] =
-	(struct board_t *) kzalloc(sizeof(struct board_t), GFP_KERNEL);
+	brd = dgnc_Board[dgnc_NumBoards] = kzalloc(sizeof(struct board_t), GFP_KERNEL);
 	if (!brd) {
 		APR(("memory allocation for board structure failed\n"));
 		return(-ENOMEM);
 	}
 
 	/* make a temporary message buffer for the boot messages */
-	brd->msgbuf = brd->msgbuf_head =
-		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
+	brd->msgbuf = brd->msgbuf_head = kzalloc(sizeof(char) * 8192, GFP_KERNEL);
 	if (!brd->msgbuf) {
 		kfree(brd);
 		APR(("memory allocation for board msgbuf failed\n"));
-- 
1.8.4

