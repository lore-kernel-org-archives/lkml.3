Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab3IPNsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:48:52 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48410 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3IPNoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:44:14 -0400
From: Iker Pedrosa <ikerpedrosam@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, ikerpedrosam@gmail.com, harsh1kumar@gmail.com,
        dan.carpenter@oracle.com, mujeeb.adil@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/24] Staging: winbond: reg: first of the patches that fixes lines over 80 characters
Date: Mon, 16 Sep 2013 15:43:29 +0200
Message-Id: <1379339024-12157-10-git-send-email-ikerpedrosam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
References: <1379339024-12157-1-git-send-email-ikerpedrosam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First of the patches that fixes the lines over 80 characters in reg.c

Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
---
 drivers/staging/winbond/reg.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/winbond/reg.c b/drivers/staging/winbond/reg.c
index c023fda..429c28e 100644
--- a/drivers/staging/winbond/reg.c
+++ b/drivers/staging/winbond/reg.c
@@ -809,12 +809,7 @@ u32 w89rf242_txvga_data[][5] = {
 	{(0x05 << 24) | 0x24C7CA, 34, 0x00292315, 0x0800FEFF, 0x72724242}
 };
 
-/* ================================================================================================== */
-
-
-
 /*
- * =============================================================================================================
  *  Uxx_ReadEthernetAddress --
  *
  *  Routine Description:
@@ -826,15 +821,15 @@ u32 w89rf242_txvga_data[][5] = {
  *  Return Value:
  *
  *    The address is stored in EthernetIDAddr.
- * =============================================================================================================
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
@@ -852,18 +847,17 @@ void Uxx_ReadEthernetAddress(struct hw_data *pHwData)
 
 
 /*
- * ===============================================================================================================
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
  */
 void CardGetMulticastBit(u8 Address[ETH_ALEN], u8 *Byte, u8 *Value)
 {
@@ -926,7 +920,8 @@ static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp,
 	u8	i;
 	for (i = 0; i < number; i++) {
 		pHwData->phy_para[i] = al7230_rf_data_24[i];
-		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) | (al7230_rf_data_24[i] & 0xffffff);
+		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) |
+			   (al7230_rf_data_24[i] & 0xffffff);
 	}
 }
 
@@ -936,15 +931,14 @@ static void Set_ChanIndep_RfData_al7230_50(struct hw_data *pHwData, u32 *pltmp,
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
  * RFSynthesizer_initial --
- * =============================================================================================================
  */
 void RFSynthesizer_initial(struct hw_data *pHwData)
 {
-- 
1.8.1.2

