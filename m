Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbaGYQiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:38:00 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64422 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaGYQh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:37:59 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: removed redundant comments from key.h
Date: Fri, 25 Jul 2014 19:37:45 +0300
Message-Id: <1406306265-32611-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed redundant comments from key.h header file.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/key.h |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vt6655/key.h b/drivers/staging/vt6655/key.h
index 4b8b4b6..f0cbd75 100644
--- a/drivers/staging/vt6655/key.h
+++ b/drivers/staging/vt6655/key.h
@@ -34,7 +34,6 @@
 #include "tether.h"
 #include "80211mgr.h"
 
-/*---------------------  Export Definitions -------------------------*/
 #define MAX_GROUP_KEY       4
 #define MAX_KEY_TABLE       11
 #define MAX_KEY_LEN         32
@@ -65,38 +64,27 @@ typedef struct tagSKeyItem
 	unsigned char byReserved0;
 	unsigned long dwKeyIndex;
 	void *pvKeyTable;
-} SKeyItem, *PSKeyItem; //64
+} SKeyItem, *PSKeyItem;
 
 typedef struct tagSKeyTable
 {
-	unsigned char abyBSSID[ETH_ALEN];  //6
-	unsigned char byReserved0[2];              //8
+	unsigned char abyBSSID[ETH_ALEN];
+	unsigned char byReserved0[2];
 	SKeyItem    PairwiseKey;
-	SKeyItem    GroupKey[MAX_GROUP_KEY]; //64*5 = 320, 320+8=328
-	unsigned long dwGTKeyIndex;            // GroupTransmitKey Index
+	SKeyItem    GroupKey[MAX_GROUP_KEY];
+	unsigned long dwGTKeyIndex;
 	bool bInUse;
-	//2006-1116-01,<Modify> by NomadZhao
 	bool bSoftWEP;
-	unsigned short wKeyCtl;      // for address of wKeyCtl at align 4
+	unsigned short wKeyCtl;
 
 	unsigned char byReserved1[6];
-} SKeyTable, *PSKeyTable; //348
+} SKeyTable, *PSKeyTable;
 
 typedef struct tagSKeyManagement
 {
 	SKeyTable   KeyTable[MAX_KEY_TABLE];
 } SKeyManagement, *PSKeyManagement;
 
-/*---------------------  Export Types  ------------------------------*/
-
-/*---------------------  Export Macros ------------------------------*/
-
-/*---------------------  Export Classes  ----------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
-/*---------------------  Export Functions  --------------------------*/
-
 void KeyvInitTable(PSKeyManagement pTable, unsigned long dwIoBase);
 
 bool KeybGetKey(
-- 
1.7.9.5

