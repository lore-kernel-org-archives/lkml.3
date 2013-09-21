Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3IUW3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:29:23 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:40666 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab3IUW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:29:18 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, peter.senna@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 17/19] staging: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:49 +0200
Message-Id: <1379802471-30252-17-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable Trigger is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/staging/winbond/wb35tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 30a77cc..708c5b0 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -180,7 +180,7 @@ void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 {
 	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
-	unsigned char Trigger = false;
+	bool Trigger = false;
 
 	if (pWb35Tx->TxTimer > TimeCount)
 		Trigger = true;
-- 
1.8.3.1

