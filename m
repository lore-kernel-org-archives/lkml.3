Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301Ab3IEKcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:32:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965236Ab3IEKcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:32:20 -0400
X-IronPort-AV: E=Sophos;i="4.90,846,1371052800"; 
   d="scan'208";a="8423206"
Message-ID: <52285D8B.3050106@cn.fujitsu.com>
Date: Thu, 05 Sep 2013 18:31:39 +0800
From: Duan Jiong <duanj.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: driver.c: casting (void *)value returned by
 kzalloc is useless
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 18:30:07,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/05 18:30:08,
	Serialize complete at 2013/09/05 18:30:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=GB2312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

Casting (void *) value returned by kzalloc is useless
as mentioned in Documentation/CodingStyle, Chap 14.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
---
 drivers/staging/dgnc/dgnc_driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index f8c1e22..ac64181 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -499,7 +499,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* get the board structure and prep it */
 	brd = dgnc_Board[dgnc_NumBoards] =
-	(struct board_t *) kzalloc(sizeof(struct board_t), GFP_KERNEL);
+			kzalloc(sizeof(struct board_t), GFP_KERNEL);
 	if (!brd) {
 		APR(("memory allocation for board structure failed\n"));
 		return(-ENOMEM);
@@ -507,7 +507,7 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 	/* make a temporary message buffer for the boot messages */
 	brd->msgbuf = brd->msgbuf_head =
-		(char *) kzalloc(sizeof(char) * 8192, GFP_KERNEL);
+			kzalloc(sizeof(char) * 8192, GFP_KERNEL);
 	if (!brd->msgbuf) {
 		kfree(brd);
 		APR(("memory allocation for board msgbuf failed\n"));
-- 
1.8.3.1
