Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaLUSAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 13:00:19 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:36409 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaLUSAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 13:00:18 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Guillaume Clement <gclement@baobob.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: srom.c:  Remove some unused functions
Date: Sun, 21 Dec 2014 19:03:03 +0100
Message-Id: <1419184983-11386-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
SROMbAutoLoad() SROMvReadSubSysVenId() SROMvWriteEtherAddress()
SROMvWriteAllContents() SROMbIsRegBitsOff() SROMbIsRegBitsOn()
SROMvRegBitsOff() SROMvRegBitsOn()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/vt6655/srom.c |  206 -----------------------------------------
 drivers/staging/vt6655/srom.h |   11 ---
 2 files changed, 217 deletions(-)

diff --git a/drivers/staging/vt6655/srom.c b/drivers/staging/vt6655/srom.c
index 5396e58..ba2a2d4 100644
--- a/drivers/staging/vt6655/srom.c
+++ b/drivers/staging/vt6655/srom.c
@@ -27,16 +27,8 @@
  * Functions:
  *      SROMbyReadEmbedded - Embedded read eeprom via MAC
  *      SROMbWriteEmbedded - Embedded write eeprom via MAC
- *      SROMvRegBitsOn - Set Bits On in eeprom
- *      SROMvRegBitsOff - Clear Bits Off in eeprom
- *      SROMbIsRegBitsOn - Test if Bits On in eeprom
- *      SROMbIsRegBitsOff - Test if Bits Off in eeprom
  *      SROMvReadAllContents - Read all contents in eeprom
- *      SROMvWriteAllContents - Write all contents in eeprom
  *      SROMvReadEtherAddress - Read Ethernet Address in eeprom
- *      SROMvWriteEtherAddress - Write Ethernet Address in eeprom
- *      SROMvReadSubSysVenId - Read Sub_VID and Sub_SysId in eeprom
- *      SROMbAutoLoad - Auto Load eeprom to MAC register
  *
  * Revision History:
  *
@@ -160,92 +152,6 @@ bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, un
 }
 
 /*
- * Description: Turn bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn on
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	SROMbWriteEmbedded(dwIoBase, byContntOffset, (unsigned char)(byOrgData | byBits));
-}
-
-/*
- * Description: Turn bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byBits          - bits to turn off
- *  Out:
- *      none
- *
- */
-void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	SROMbWriteEmbedded(dwIoBase, byContntOffset, (unsigned char)(byOrgData & (~byBits)));
-}
-
-/*
- * Description: Test if bits on in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits on; otherwise false
- *
- */
-bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	return (byOrgData & byTestBits) == byTestBits;
-}
-
-/*
- * Description: Test if bits off in eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      byContntOffset  - address of EEPROM
- *      byTestBits      - bits to test
- *  Out:
- *      none
- *
- * Return Value: true if all test bits off; otherwise false
- *
- */
-bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits)
-{
-	unsigned char byOrgData;
-
-	byOrgData = SROMbyReadEmbedded(dwIoBase, byContntOffset);
-	return !(byOrgData & byTestBits);
-}
-
-/*
  * Description: Read all contents of eeprom to buffer
  *
  * Parameters:
@@ -269,30 +175,6 @@ void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
 }
 
 /*
- * Description: Write all contents of buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEepromRegs   - EEPROM content Buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs)
-{
-	int     ii;
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
-		SROMbWriteEmbedded(dwIoBase, (unsigned char)ii, *pbyEepromRegs);
-		pbyEepromRegs++;
-	}
-}
-
-/*
  * Description: Read Ethernet Address from eeprom to buffer
  *
  * Parameters:
@@ -315,91 +197,3 @@ void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddres
 	}
 }
 
-/*
- * Description: Write Ethernet Address from buffer to eeprom
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *      pbyEtherAddress - Ethernet Address buffer
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress)
-{
-	unsigned char ii;
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < ETH_ALEN; ii++) {
-		SROMbWriteEmbedded(dwIoBase, ii, *pbyEtherAddress);
-		pbyEtherAddress++;
-	}
-}
-
-/*
- * Description: Read Sub_VID and Sub_SysId from eeprom to buffer
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      pdwSubSysVenId  - Sub_VID and Sub_SysId read
- *
- * Return Value: none
- *
- */
-void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId)
-{
-	unsigned char *pbyData;
-
-	pbyData = (unsigned char *)pdwSubSysVenId;
-	/* sub vendor */
-	*pbyData = SROMbyReadEmbedded(dwIoBase, 6);
-	*(pbyData+1) = SROMbyReadEmbedded(dwIoBase, 7);
-	/* sub system */
-	*(pbyData+2) = SROMbyReadEmbedded(dwIoBase, 8);
-	*(pbyData+3) = SROMbyReadEmbedded(dwIoBase, 9);
-}
-
-/*
- * Description: Auto Load EEPROM to MAC register
- *
- * Parameters:
- *  In:
- *      dwIoBase        - I/O base address
- *  Out:
- *      none
- *
- * Return Value: true if success; otherwise false
- *
- */
-bool SROMbAutoLoad(void __iomem *dwIoBase)
-{
-	unsigned char byWait;
-	int     ii;
-
-	unsigned char byOrg;
-
-	VNSvInPortB(dwIoBase + MAC_REG_I2MCFG, &byOrg);
-	/* turn on hardware retry */
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, (byOrg | I2MCFG_NORETRY));
-
-	MACvRegBitsOn(dwIoBase, MAC_REG_I2MCSR, I2MCSR_AUTOLD);
-
-	/* ii = Rom Address */
-	for (ii = 0; ii < EEP_MAX_CONTEXT_SIZE; ii++) {
-		MACvTimer0MicroSDelay(dwIoBase, CB_EEPROM_READBYTE_WAIT);
-		VNSvInPortB(dwIoBase + MAC_REG_I2MCSR, &byWait);
-		if (!(byWait & I2MCSR_AUTOLD))
-			break;
-	}
-
-	VNSvOutPortB(dwIoBase + MAC_REG_I2MCFG, byOrg);
-
-	if (ii == EEP_MAX_CONTEXT_SIZE)
-		return false;
-	return true;
-}
diff --git a/drivers/staging/vt6655/srom.h b/drivers/staging/vt6655/srom.h
index 3128e53..8851cc9 100644
--- a/drivers/staging/vt6655/srom.h
+++ b/drivers/staging/vt6655/srom.h
@@ -136,20 +136,9 @@ typedef struct tagSSromReg {
 unsigned char SROMbyReadEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset);
 bool SROMbWriteEmbedded(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byData);
 
-void SROMvRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
-void SROMvRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byBits);
-
-bool SROMbIsRegBitsOn(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
-bool SROMbIsRegBitsOff(void __iomem *dwIoBase, unsigned char byContntOffset, unsigned char byTestBits);
-
 void SROMvReadAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
-void SROMvWriteAllContents(void __iomem *dwIoBase, unsigned char *pbyEepromRegs);
 
 void SROMvReadEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
-void SROMvWriteEtherAddress(void __iomem *dwIoBase, unsigned char *pbyEtherAddress);
-
-void SROMvReadSubSysVenId(void __iomem *dwIoBase, unsigned long *pdwSubSysVenId);
 
-bool SROMbAutoLoad(void __iomem *dwIoBase);
 
 #endif // __EEPROM_H__
-- 
1.7.10.4

