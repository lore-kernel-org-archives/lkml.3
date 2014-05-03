Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaECUAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:00:39 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:34068 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaECUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:00:38 -0400
Message-ID: <53654AE3.9040702@gmail.com>
Date: Sat, 03 May 2014 23:00:35 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: keucr: smilmain.c: Fix sparse warning
References: <53555897.10409@gmail.com> <20140425222459.GA25868@kroah.com>
In-Reply-To: <20140425222459.GA25868@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014.04.26. 01:24, Greg KH wrote:
> On Mon, Apr 21, 2014 at 08:42:47PM +0300, Tair wrote:
>> From: Tair Rzayev <tair.rzayev@gmail.com>
>>
>> Fix "Should be static" sparse warning:
>> * Add Check_D_MediaFmt() declaration to smil.h;
>> * Move Check_D_MediaFmt() implementation up in smilmain.c to keep
>>   all the non-static functions at the top of the file;
>> * Include "init.h" into "smil.h", remove externs from "smil.h"
>>   which are no longer needed;
>> * SM_Init[] and SM_Rdwr[] are renamed because otherwise SM_Init[]
>>   collides with SM_Init() from "smil.h".
> 
> That's a lot of things to do all at once.
> 
> In fact, it doesn't apply to my tree anymore because someone else just
> did a part of what you did, so this might not be needed anymore.  Can
> you please rebase your patch on top of my staging-next branch on the
> staging.git tree on git.kernel.org and resend it?
> 
> thanks,
> 
> greg k-h
> 

Rebased against suggested tree and branch.

Most of the changes were already applied by another developer so leaving only 
cosmetic stuff from my original patch:
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


