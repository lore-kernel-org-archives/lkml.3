Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3IUW3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:29:18 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:52174 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3IUW3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:29:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net
Cc: gregkh@linuxfoundation.org, more.andres@gmail.com, tvboxspy@gmail.com,
        dan.carpenter@oracle.com, peter.senna@gmail.com, hemaklnce@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 16/19] staging: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:48 +0200
Message-Id: <1379802471-30252-16-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variables bMultiBand and bKeyTableFull are only assigned the
values true and false. Change its type to bool.

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
 drivers/staging/vt6656/channel.c | 2 +-
 drivers/staging/vt6656/hostap.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 5158ff4..e430b35 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -403,7 +403,7 @@ exit:
 
 void CHvInitChannelTable(struct vnt_private *pDevice)
 {
-	int bMultiBand = false;
+	bool bMultiBand = false;
 	int ii;
 
     for (ii = 1; ii <= CB_MAX_CHANNEL; ii++)
diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index c699a30..7d96fe7 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -414,7 +414,7 @@ static int hostap_set_encryption(struct vnt_private *pDevice,
 	int ret = 0;
 	s32 iNodeIndex = -1;
 	int ii;
-	int bKeyTableFull = false;
+	bool bKeyTableFull = false;
 	u16 wKeyCtl = 0;
 
 	param->u.crypt.err = 0;
-- 
1.8.3.1

