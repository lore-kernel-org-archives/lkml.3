Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaL3J5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 04:57:49 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:40253 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaL3J5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 04:57:47 -0500
Date: Tue, 30 Dec 2014 04:57:44 -0500
From: Nicholas Parkanyi <n.parkanyi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: Replace C99 comments in power.c and upc.h.
Message-ID: <20141230095744.GA5619@nickChromebook.no-domain-set.bellcanada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warnings:

ERROR: do not use C99 // comments
+//

ERROR: do not use C99 // comments
+//  For memory mapped IO

ERROR: do not use C99 // comments
+//

ERROR: do not use C99 // comments
+#endif // __UPC_H__

ERROR: do not use C99 // comments
+	// set period of power up before TBTT

ERROR: do not use C99 // comments
+		// set AID

ERROR: do not use C99 // comments
+		// set ATIM Window

ERROR: do not use C99 // comments
+	// Set AutoSleep

ERROR: do not use C99 // comments
+	// Set HWUTSF

ERROR: do not use C99 // comments
+		// clear always listen beacon

ERROR: do not use C99 // comments
+		// first time set listen next beacon

ERROR: do not use C99 // comments
+		// always listen beacon

ERROR: do not use C99 // comments
+	// enable power saving hw function

ERROR: do not use C99 // comments
+	// disable power saving hw function

ERROR: do not use C99 // comments
+	//clear AutoSleep

ERROR: do not use C99 // comments
+	//clear HWUTSF

ERROR: do not use C99 // comments
+	// set always listen beacon

Signed-off-by: Nicholas Parkanyi <n.parkanyi@gmail.com>
---
 drivers/staging/vt6655/power.c | 26 +++++++++++++-------------
 drivers/staging/vt6655/upc.h   |  8 ++++----
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6655/power.c b/drivers/staging/vt6655/power.c
index e826f07..be3c4e9 100644
--- a/drivers/staging/vt6655/power.c
+++ b/drivers/staging/vt6655/power.c
@@ -71,33 +71,33 @@ PSvEnablePowerSaving(
 	struct vnt_private *pDevice = hDeviceContext;
 	u16 wAID = pDevice->current_aid | BIT(14) | BIT(15);
 
-	// set period of power up before TBTT
+	/* set period of power up before TBTT */
 	VNSvOutPortW(pDevice->PortOffset + MAC_REG_PWBT, C_PWBT);
 	if (pDevice->op_mode != NL80211_IFTYPE_ADHOC) {
-		// set AID
+		/* set AID */
 		VNSvOutPortW(pDevice->PortOffset + MAC_REG_AIDATIM, wAID);
 	} else {
-		// set ATIM Window
+		/* set ATIM Window */
 #if 0 /* TODO atim window */
 		MACvWriteATIMW(pDevice->PortOffset, pMgmt->wCurrATIMWindow);
 #endif
 	}
-	// Set AutoSleep
+	/* Set AutoSleep */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
-	// Set HWUTSF
+	/* Set HWUTSF */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
 
 	if (wListenInterval >= 2) {
-		// clear always listen beacon
+		/* clear always listen beacon */
 		MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
-		// first time set listen next beacon
+		/* first time set listen next beacon */
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_LNBCN);
 	} else {
-		// always listen beacon
+		/* always listen beacon */
 		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 	}
 
-	// enable power saving hw function
+	/* enable power saving hw function */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_PSEN);
 	pDevice->bEnablePSMode = true;
 
@@ -122,13 +122,13 @@ PSvDisablePowerSaving(
 {
 	struct vnt_private *pDevice = hDeviceContext;
 
-	// disable power saving hw function
+	/* disable power saving hw function */
 	MACbPSWakeup(pDevice->PortOffset);
-	//clear AutoSleep
+	/* clear AutoSleep */
 	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_PSCFG, PSCFG_AUTOSLEEP);
-	//clear HWUTSF
+	/* clear HWUTSF */
 	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_HWUTSF);
-	// set always listen beacon
+	/* set always listen beacon */
 	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_PSCTL, PSCTL_ALBCN);
 
 	pDevice->bEnablePSMode = false;
diff --git a/drivers/staging/vt6655/upc.h b/drivers/staging/vt6655/upc.h
index c53703a..cc63dc8 100644
--- a/drivers/staging/vt6655/upc.h
+++ b/drivers/staging/vt6655/upc.h
@@ -33,9 +33,9 @@
 
 /*---------------------  Export Definitions -------------------------*/
 
-//
-//  For memory mapped IO
-//
+
+/* For memory mapped IO */
+
 
 #define VNSvInPortB(dwIOAddress, pbyData)				\
 do {									\
@@ -86,4 +86,4 @@ do {								\
 
 /*---------------------  Export Functions  --------------------------*/
 
-#endif // __UPC_H__
+#endif /* __UPC_H__ */
-- 
1.9.3

