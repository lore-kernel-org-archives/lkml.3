Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3HZPLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:49 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65256 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab3HZPLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:43 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:14 +0200
Message-Id: <1377529823-5116-16-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seventh of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 50ca7dd..6cafd69 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -2070,7 +2070,8 @@ u8 RFSynthesizer_SetWinbond242Power(struct hw_data *pHwData, u8 index)
 		i--;
 
 	/* Set TxVga into RF */
-	PowerData = (1 << 31) | (0 << 30) | (24 << 24) | BitReverse(w89rf242_txvga_data[i][0], 24);
+	PowerData = (1 << 31) | (0 << 30) | (24 << 24)
+			    | BitReverse(w89rf242_txvga_data[i][0], 24);
 	Wb35Reg_Write(pHwData, 0x0864, PowerData);
 
 	/* Update BB48 BB4C BB58 for high precision txvga */
@@ -2146,11 +2147,15 @@ void Mxx_initial(struct hw_data *pHwData)
 	pltmp[4] = tmp;
 
 	/* M38 */
-	reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) | (DEFAULT_LONG_RETRY_LIMIT << 4) | DEFAULT_SHORT_RETRY_LIMIT;
+	reg->M38_MacControl = (DEFAULT_RATE_RETRY_LIMIT << 8) |
+				       (DEFAULT_LONG_RETRY_LIMIT << 4) |
+				       DEFAULT_SHORT_RETRY_LIMIT;
 	pltmp[5] = reg->M38_MacControl;
 
 	/* M3C */
-	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) | (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) | DEFAULT_OSIFST;
+	tmp = (DEFAULT_PIFST << 26) | (DEFAULT_EIFST << 16) |
+		       (DEFAULT_DIFST << 8) | (DEFAULT_SIFST << 4) |
+		       DEFAULT_OSIFST;
 	reg->M3C_MacControl = tmp;
 	pltmp[6] = tmp;
 
@@ -2173,7 +2178,9 @@ void Mxx_initial(struct hw_data *pHwData)
 	pltmp[9] = tmp;
 
 	/* M4C */
-	reg->M4C_MacStatus = (DEFAULT_PROTOCOL_VERSION << 30) | (DEFAULT_MAC_POWER_STATE << 28) | (DEFAULT_DTIM_ALERT_TIME << 24);
+	reg->M4C_MacStatus = (DEFAULT_PROTOCOL_VERSION << 30) |
+				      (DEFAULT_MAC_POWER_STATE << 28) |
+				      (DEFAULT_DTIM_ALERT_TIME << 24);
 	pltmp[10] = reg->M4C_MacStatus;
 
 	for (i = 0; i < 11; i++)
@@ -2245,10 +2252,11 @@ void GetTxVgaFromEEPROM(struct hw_data *pHwData)
 }
 
 /*
- * This function will affect the TxVga parameter in HAL. If hal_set_current_channel
- * or RFSynthesizer_SetPowerIndex be called, new TxVga will take effect.
- * TxVgaSettingInEEPROM of sHwData is an u8 array point to EEPROM contain for IS89C35
- * This function will use default TxVgaSettingInEEPROM data to calculate new TxVga.
+ * This function will affect the TxVga parameter in HAL. If
+ * hal_set_current_channel or RFSynthesizer_SetPowerIndex be called, new TxVga
+ * will take effect. TxVgaSettingInEEPROM of sHwData is an u8 array point to
+ * EEPROM contain for IS89C35. This function will use default
+ * TxVgaSettingInEEPROM data to calculate new TxVga.
  */
 void EEPROMTxVgaAdjust(struct hw_data *pHwData)
 {
-- 
1.8.1.2

