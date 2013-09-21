Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3IUWak (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:30:40 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48891 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab3IUW3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:29:11 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: gregkh@linuxfoundation.org
Cc: maxtram95@gmail.com, yamanetoshi@gmail.com, viro@zeniv.linux.org.uk,
        wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 15/19] staging: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:47 +0200
Message-Id: <1379802471-30252-15-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable ownbit_flag is only assigned the values true and false.
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
 drivers/staging/rtl8187se/r8180_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index 5947a6f..35412d2 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1704,7 +1704,7 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 	u16			RtsDur = 0;
 	u16			ThisFrameTime = 0;
 	u16			TxDescDuration = 0;
-	u8			ownbit_flag = false;
+	bool			ownbit_flag = false;
 
 	switch (priority) {
 	case MANAGE_PRIORITY:
-- 
1.8.3.1

