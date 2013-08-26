Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3HZPLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:11:32 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:45571 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab3HZPLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:11:30 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com,
        justinmattock@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/24] Staging: winbond: reg: fixed some lines over 80 characters
Date: Mon, 26 Aug 2013 17:10:08 +0200
Message-Id: <1377529823-5116-10-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index 61916f5..b1d977a 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -809,12 +809,12 @@ u32 w89rf242_txvga_data[][5] = {
 	{(0x05 << 24) | 0x24C7CA, 34, 0x00292315, 0x0800FEFF, 0x72724242}
 };
 
-/* ================================================================================================== */
+/* ========================================================================= */
 
 
 
 /*
- * =============================================================================================================
+ * ============================================================================
  *  Uxx_ReadEthernetAddress --
  *
  *  Routine Description:
@@ -826,15 +826,16 @@ u32 w89rf242_txvga_data[][5] = {
  *  Return Value:
  *
  *    The address is stored in EthernetIDAddr.
- * =============================================================================================================
+ * ============================================================================
  */
 void Uxx_ReadEthernetAddress(struct hw_data *pHwData)
 {
 	u32	ltmp;
 
 	/*
-	 * Reading Ethernet address from EEPROM and set into hardware due to MAC address maybe change.
-	 * Only unplug and plug again can make hardware read EEPROM again.
+	 * Reading Ethernet address from EEPROM and set into hardware due to
+	 * MAC address maybe change. Only unplug and plug again can make
+	 * hardware read EEPROM again.
 	 */
 	Wb35Reg_WriteSync(pHwData, 0x03b4, 0x08000000); /* Start EEPROM access + Read + address(0x0d) */
 	Wb35Reg_ReadSync(pHwData, 0x03b4, &ltmp);
@@ -852,18 +853,19 @@ void Uxx_ReadEthernetAddress(struct hw_data *pHwData)
 
 
 /*
- * ===============================================================================================================
+ * ============================================================================
  *  CardGetMulticastBit --
  *  Description:
- *    For a given multicast address, returns the byte and bit in the card multicast registers that it hashes to.
- *    Calls CardComputeCrc() to determine the CRC value.
+ *    For a given multicast address, returns the byte and bit in the card
+ *    multicast registers that it hashes to. Calls CardComputeCrc() to
+ *    determine the CRC value.
  *  Arguments:
  *    Address - the address
  *    Byte - the byte that it hashes to
  *    Value - will have a 1 in the relevant bit
  *  Return Value:
  *    None.
- * ==============================================================================================================
+ * ============================================================================
  */
 void CardGetMulticastBit(u8 Address[ETH_ALEN], u8 *Byte, u8 *Value)
 {
@@ -926,7 +928,8 @@ static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp,
 	u8	i;
 	for (i = 0; i < number; i++) {
 		pHwData->phy_para[i] = al7230_rf_data_24[i];
-		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) | (al7230_rf_data_24[i] & 0xffffff);
+		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24)
+				   | (al7230_rf_data_24[i] & 0xffffff);
 	}
 }
 
@@ -936,15 +939,16 @@ static void Set_ChanIndep_RfData_al7230_50(struct hw_data *pHwData, u32 *pltmp,
 	u8	i;
 	for (i = 0; i < number; i++) {
 		pHwData->phy_para[i] = al7230_rf_data_50[i];
-		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) | (al7230_rf_data_50[i] & 0xffffff);
+		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24)
+				   | (al7230_rf_data_50[i] & 0xffffff);
 	}
 }
 
 
 /*
- * =============================================================================================================
+ * ============================================================================
  * RFSynthesizer_initial --
- * =============================================================================================================
+ * ============================================================================
  */
 void RFSynthesizer_initial(struct hw_data *pHwData)
 {
-- 
1.8.1.2

