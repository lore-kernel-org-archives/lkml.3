Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaEDIo6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 04:44:58 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:48100 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbaEDIo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 04:44:56 -0400
Message-ID: <5365FE04.3020208@gmail.com>
Date: Sun, 04 May 2014 11:44:52 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] staging: keucr: smilmain.c: cosmetic updates
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move Check_D_MediaFmt() implementation up in smilmain.c to keep all the 
  non-static functions at the top of the file;
* Remove unnecessary extern and newlines from "init.h";

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/keucr/init.h     |  4 ----
 drivers/staging/keucr/smilmain.c | 34 +++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/keucr/init.h b/drivers/staging/keucr/init.h
index 32c724d..d1367e7 100644
--- a/drivers/staging/keucr/init.h
+++ b/drivers/staging/keucr/init.h
@@ -1,9 +1,5 @@
 #include "common.h"
 
-extern u32 MediaChange;
-
-
-
 static u8 SM_Init[] = {
 0x7B, 0x09, 0x7C, 0xF0, 0x7D, 0x10, 0x7E, 0xE9,
 0x7F, 0xCC, 0x12, 0x2F, 0x71, 0x90, 0xE9, 0xCC,
diff --git a/drivers/staging/keucr/smilmain.c b/drivers/staging/keucr/smilmain.c
index fc7cbc6..42ec8a6 100644
--- a/drivers/staging/keucr/smilmain.c
+++ b/drivers/staging/keucr/smilmain.c
@@ -141,23 +141,6 @@ int Media_D_CopySector(struct us_data *us, u32 start, u16 count, u8 *buf)
 	return NO_ERROR;
 }
 
-/* ----- Release_D_CopySector() ------------------------------------------ */
-static int Release_D_CopySector(struct us_data *us)
-{
-	Log2Phy[Media.Zone][Media.LogBlock] = WriteBlock;
-	Media.PhyBlock = ReadBlock;
-
-	if (Media.PhyBlock == NO_ASSIGN) {
-		Media.PhyBlock = WriteBlock;
-		return SMSUCCESS;
-	}
-
-	Clr_D_Bit(Assign[Media.Zone], Media.PhyBlock);
-	Media.PhyBlock = WriteBlock;
-
-	return SMSUCCESS;
-}
-
 /* SmartMedia Physical Format Test Subroutine */
 /* ----- Check_D_MediaFmt() --------------------------------------------- */
 int Check_D_MediaFmt(struct us_data *us)
@@ -184,6 +167,23 @@ int Check_D_MediaFmt(struct us_data *us)
 	return SMSUCCESS;
 }
 
+/* ----- Release_D_CopySector() ------------------------------------------ */
+static int Release_D_CopySector(struct us_data *us)
+{
+	Log2Phy[Media.Zone][Media.LogBlock] = WriteBlock;
+	Media.PhyBlock = ReadBlock;
+
+	if (Media.PhyBlock == NO_ASSIGN) {
+		Media.PhyBlock = WriteBlock;
+		return SMSUCCESS;
+	}
+
+	Clr_D_Bit(Assign[Media.Zone], Media.PhyBlock);
+	Media.PhyBlock = WriteBlock;
+
+	return SMSUCCESS;
+}
+
 /* SmartMedia Physical Address Control Subroutine */
 /* ----- Conv_D_MediaAddr() --------------------------------------------- */
 static int Conv_D_MediaAddr(struct us_data *us, u32 addr)
-- 
1.9.1


