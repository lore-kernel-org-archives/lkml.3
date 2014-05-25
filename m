Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbaEYRcu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 13:32:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:50467 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbaEYRcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 13:32:48 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: kevin.curtis@farsite.co.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
Subject: [PATCH] wan: time_before()
Date: Sun, 25 May 2014 19:32:43 +0200
Message-Id: <1401039163-10727-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:pgFama+E9+1bDvNsKh27SUeQPxyzrdYhLvbcOt7OW7M0wAqY40i
 LodvvjF7FANbA1RtulITz5u5pVLBZMCvh6YwYsFEXrc+ngEzeYtyy2sTHl3XdyxYiLIWDXL
 KnxNnJr8mDBekDcxVz4tqK+R89qo8Z6A8SKff3eWldwotaFAml44+qxg/DLtHx+ri1upJWW
 SKqfgmXfey5oX0ZvkgdJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be future-proof and for better readability the time comparisons are
modified to use time_before() instead of plain, error-prone math.

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/net/wan/farsync.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index bcfff0d..d007f60 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -697,14 +697,14 @@ fst_cpureset(struct fst_card_info *card)
 		 * We are delaying here to allow the 9054 to reset itself
 		 */
 		j = jiffies + 1;
-		while (jiffies < j)
+		while (time_before(jiffies, j))
 			/* Do nothing */ ;
 		outw(0x240f, card->pci_conf + CNTRL_9054 + 2);
 		/*
 		 * We are delaying here to allow the 9054 to reload its eeprom
 		 */
 		j = jiffies + 1;
-		while (jiffies < j)
+		while (time_before(jiffies, j))
 			/* Do nothing */ ;
 		outw(0x040f, card->pci_conf + CNTRL_9054 + 2);
 
-- 
1.7.10.4

