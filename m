Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab3HZPRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:17:37 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:39048 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3HZPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:14 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/24] Staging: winbond: mto: avoided use of extern functions
Date: Mon, 26 Aug 2013 17:10:01 +0200
Message-Id: <1377529823-5116-3-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prototype of two functions added to the header to avoid the use of extern.

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/mto.c | 4 +---
 drivers/staging/winbond/mto.h | 4 ++--
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/mto.c b/drivers/staging/winbond/mto.c
index 0d0f9fb..b031ecd 100644
--- a/drivers/staging/winbond/mto.c
+++ b/drivers/staging/winbond/mto.c
@@ -21,6 +21,7 @@
 #include "wbhal.h"
 #include "wb35reg_f.h"
 #include "core.h"
+#include "mto.h"
 
 /* Declare SQ3 to rate and fragmentation threshold table */
 /* Declare fragmentation threshold table */
@@ -45,9 +46,6 @@ static int retryrate_rec[MTO_MAX_DATA_RATE_LEVELS];
 
 static u8 boSparseTxTraffic;
 
-void MTO_Init(struct wbsoft_priv *adapter);
-void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
-
 /*
  * ===========================================================================
  * MTO_Init --
diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index a0f659c..22bb264 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -127,12 +127,12 @@ extern u16 MTO_Frag_Th_Tbl[];
 #define MTO_DATA_RATE()			MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
 #define MTO_FRAG_TH()			MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
 
-extern void MTO_Init(struct wbsoft_priv *);
+void MTO_Init(struct wbsoft_priv *);
+void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
 extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
 extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);
 extern u8 MTO_GetTxRate(struct wbsoft_priv *adapter, u32 fpdu_len);
 extern u8 MTO_GetTxFallbackRate(struct wbsoft_priv *adapter);
-extern void MTO_SetTxCount(struct wbsoft_priv *adapter, u8 t0, u8 index);
 
 #endif /* __MTO_H__ */
 
-- 
1.8.1.2

