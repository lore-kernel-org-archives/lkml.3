Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbaHETOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:14:12 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44605 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaHETOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:14:10 -0400
From: fernando.apesteguia@gmail.com
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fernando Apesteguia <fernando.apesteguia@gmail.com>
Subject: [PATCH] staging: rtl8192u: remove unused function.
Date: Tue,  5 Aug 2014 21:10:19 +0200
Message-Id: <1407265820-13547-1-git-send-email-fernando.apesteguia@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Apesteguia <fernando.apesteguia@gmail.com>

Remove ComputeTxTime since it is not used.

Signed-off-by: Fernando Apesteguia <fernando.apesteguia@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..1a9f526 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1486,28 +1486,6 @@ inline u8 rtl8192_IsWirelessBMode(u16 rate)
 
 u16 N_DBPSOfRate(u16 DataRate);
 
-u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
-		  u8 bShortPreamble)
-{
-	u16	FrameTime;
-	u16	N_DBPS;
-	u16	Ceiling;
-
-	if (rtl8192_IsWirelessBMode(DataRate)) {
-		if (bManagementFrame || !bShortPreamble || DataRate == 10) /* long preamble */
-			FrameTime = (u16)(144+48+(FrameLength*8/(DataRate/10)));
-		else // Short preamble
-			FrameTime = (u16)(72+24+(FrameLength*8/(DataRate/10)));
-		if ((FrameLength*8 % (DataRate/10)) != 0) /* Get the Ceilling */
-			FrameTime++;
-	} else {	//802.11g DSSS-OFDM PLCP length field calculation.
-		N_DBPS = N_DBPSOfRate(DataRate);
-		Ceiling = (16 + 8*FrameLength + 6) / N_DBPS
-			+ (((16 + 8*FrameLength + 6) % N_DBPS) ? 1 : 0);
-		FrameTime = (u16)(16 + 4 + 4*Ceiling + 6);
-	}
-	return FrameTime;
-}
 
 u16 N_DBPSOfRate(u16 DataRate)
 {
-- 
1.7.9.5

