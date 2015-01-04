Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbbADTKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 14:10:30 -0500
Received: from khitomer.mortis.eu ([185.27.175.75]:11412 "EHLO
	khitomer.mortis.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbADTK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 14:10:27 -0500
From: Giel van Schijndel <me@mortis.eu>
To: linux-kernel@vger.kernel.org
Cc: Giel van Schijndel <me@mortis.eu>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        linux-driver@qlogic.com (supporter:QLOGIC QLA3XXX NE...),
        netdev@vger.kernel.org (open list:QLOGIC QLA3XXX NE...)
Subject: [PATCH] Fix an infinite retry-loop
Date: Sun,  4 Jan 2015 19:04:55 +0100
Message-Id: <1420394696-20099-1-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was clearly intended as a retry-10-times loop, but due to the
absence of code incrementing the loop-counter it was practically a
retry-forever loop.

Rewritten it as a for-loop as well to make the loop-counter increment
(as well as its potential absence) easier to spot.
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index c2f09af..35a26c9 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -144,9 +144,9 @@ static int ql_sem_lock(struct ql3_adapter *qdev, u32 sem_mask, u32 sem_bits)
  */
 static int ql_wait_for_drvr_lock(struct ql3_adapter *qdev)
 {
-	int i = 0;
+	int i;
 
-	while (i < 10) {
+	for (i = 0; i < 10; ++i) {
 		if (i)
 			ssleep(1);
 
-- 
2.1.4

