Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbaLGWAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:00:08 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51180 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaLGWAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:00:06 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Malcolm Priestley <tvboxspy@gmail.com>,
        Guillaume Clement <gclement@baobob.org>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: mac.c:  Remove unused function
Date: Sun,  7 Dec 2014 23:02:44 +0100
Message-Id: <1417989764-18481-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function MACbCompareContext() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/vt6655/mac.c |   42 ------------------------------------------
 drivers/staging/vt6655/mac.h |    1 -
 2 files changed, 43 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index e3b0b7f..8254879 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -49,7 +49,6 @@
  *      MACvSetPacketFilter - Set MAC Address Filter
  *      MACvSaveContext - Save Context of MAC Registers
  *      MACvRestoreContext - Restore Context of MAC Registers
- *      MACbCompareContext - Compare if values of MAC Registers same as Context
  *      MACbSoftwareReset - Software Reset MAC
  *      MACbSafeRxOff - Turn Off MAC Rx
  *      MACbSafeTxOff - Turn Off MAC Tx
@@ -702,47 +701,6 @@ void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
 
 /*
  * Description:
- *      Compare if MAC registers same as context buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase    - Base Address for MAC
- *      pbyCxtBuf   - Context buffer
- *  Out:
- *      none
- *
- * Return Value: true if all values are the same; otherwise false
- *
- */
-bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf)
-{
-	unsigned long dwData;
-
-	// compare MAC context to determine if this is a power lost init,
-	// return true for power remaining init, return false for power lost init
-
-	// compare CURR_RX_DESC_ADDR, CURR_TX_DESC_ADDR
-	VNSvInPortD(dwIoBase + MAC_REG_TXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_TXDMAPTR0))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_AC0DMAPTR, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_AC0DMAPTR))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR0, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR0))
-		return false;
-
-	VNSvInPortD(dwIoBase + MAC_REG_RXDMAPTR1, &dwData);
-	if (dwData != *(unsigned long *)(pbyCxtBuf + MAC_REG_RXDMAPTR1))
-		return false;
-
-	return true;
-}
-
-/*
- * Description:
  *      Software Reset MAC
  *
  * Parameters:
diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 0bf9375..811c459 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -1006,7 +1006,6 @@ void MACvSetPacketFilter(void __iomem *dwIoBase, unsigned short wFilterType);
 
 void MACvSaveContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 void MACvRestoreContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
-bool MACbCompareContext(void __iomem *dwIoBase, unsigned char *pbyCxtBuf);
 
 bool MACbSoftwareReset(void __iomem *dwIoBase);
 bool MACbSafeSoftwareReset(void __iomem *dwIoBase);
-- 
1.7.10.4

