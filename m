Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbaHGRVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:21:43 -0400
Received: from mx02.posteo.de ([89.146.194.165]:38028 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932263AbaHGRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:21:39 -0400
From: Andreas Schlick <ninox@posteo.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, Andreas Schlick <ninox@posteo.net>
Subject: [PATCH 1/2] staging: rtl8723au: Move open braces to the previous line.
Date: Thu,  7 Aug 2014 19:20:49 +0200
Message-Id: <1407432050-5624-2-git-send-email-ninox@posteo.net>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1407432050-5624-1-git-send-email-ninox@posteo.net>
References: <1407432050-5624-1-git-send-email-ninox@posteo.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct coding style errors in rtw_efuse.c. checkpatch.pl reported:
ERROR: that open brace { should be on the previous line

Signed-off-by: Andreas Schlick <ninox@posteo.net>
---
 drivers/staging/rtl8723au/core/rtw_efuse.c | 33 ++++++++++--------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
index fe092c5..0bec131 100644
--- a/drivers/staging/rtl8723au/core/rtw_efuse.c
+++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
@@ -157,8 +157,7 @@ ReadEFuseByte23a(struct rtw_adapter *Adapter, u16 _offset, u8 *pbuf)
 	retry = 0;
 	value32 = rtl8723au_read32(Adapter, EFUSE_CTRL);
 	/* while(!(((value32 >> 24) & 0xff) & 0x80)  && (retry<10)) */
-	while(!(((value32 >> 24) & 0xff) & 0x80)  && (retry<10000))
-	{
+	while (!(((value32 >> 24) & 0xff) & 0x80) && (retry<10000)) {
 		value32 = rtl8723au_read32(Adapter, EFUSE_CTRL);
 		retry++;
 	}
@@ -285,8 +284,7 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
 				 TYPE_EFUSE_REAL_CONTENT_LEN,
 				 (void *)&contentLen);
 
-	if (Address < contentLen)	/* E-fuse 512Byte */
-	{
+	if (Address < contentLen) { /* E-fuse 512Byte */
 		/* Write E-fuse Register address bit0~7 */
 		temp = Address & 0xFF;
 		rtl8723au_write8(Adapter, EFUSE_CTRL+1, temp);
@@ -302,12 +300,10 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
 
 		/* Wait Write-ready (0x30[31]= 1) */
 		Bytetemp = rtl8723au_read8(Adapter, EFUSE_CTRL+3);
-		while(!(Bytetemp & 0x80))
-		{
+		while (!(Bytetemp & 0x80)) {
 			Bytetemp = rtl8723au_read8(Adapter, EFUSE_CTRL+3);
 			k++;
-			if (k == 1000)
-			{
+			if (k == 1000) {
 				k = 0;
 				break;
 			}
@@ -357,8 +353,7 @@ EFUSE_Write1Byte(
 				 TYPE_EFUSE_REAL_CONTENT_LEN,
 				 (void *)&contentLen);
 
-	if (Address < contentLen)	/* E-fuse 512Byte */
-	{
+	if (Address < contentLen) { /* E-fuse 512Byte */
 		rtl8723au_write8(Adapter, EFUSE_CTRL, Value);
 
 		/* Write E-fuse Register address bit0~7 */
@@ -377,12 +372,10 @@ EFUSE_Write1Byte(
 
 		/* Wait Write-ready (0x30[31]= 0) */
 		Bytetemp = rtl8723au_read8(Adapter, EFUSE_CTRL+3);
-		while(Bytetemp & 0x80)
-		{
+		while (Bytetemp & 0x80) {
 			Bytetemp = rtl8723au_read8(Adapter, EFUSE_CTRL+3);
 			k++;
-			if (k == 100)
-			{
+			if (k == 100) {
 				k = 0;
 				break;
 			}
@@ -472,23 +465,19 @@ efuse_WordEnableDataRead23a(u8	word_en,
 			 u8	*sourdata,
 			 u8	*targetdata)
 {
-	if (!(word_en&BIT(0)))
-	{
+	if (!(word_en&BIT(0))) {
 		targetdata[0] = sourdata[0];
 		targetdata[1] = sourdata[1];
 	}
-	if (!(word_en&BIT(1)))
-	{
+	if (!(word_en&BIT(1))) {
 		targetdata[2] = sourdata[2];
 		targetdata[3] = sourdata[3];
 	}
-	if (!(word_en&BIT(2)))
-	{
+	if (!(word_en&BIT(2))) {
 		targetdata[4] = sourdata[4];
 		targetdata[5] = sourdata[5];
 	}
-	if (!(word_en&BIT(3)))
-	{
+	if (!(word_en&BIT(3))) {
 		targetdata[6] = sourdata[6];
 		targetdata[7] = sourdata[7];
 	}
-- 
2.0.4

