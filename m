Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985AbbAARPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 12:15:34 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:63013 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbAARPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 12:15:33 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: mib.c:  Remove some unused functions
Date: Thu,  1 Jan 2015 18:18:32 +0100
Message-Id: <1420132712-32285-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
STAvClearAllCounter() STAvClear802_11Counter()
STAvUpdateTDStatCounterEx() STAvUpdateRDStatCounterEx()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/vt6655/mib.c |  113 ------------------------------------------
 drivers/staging/vt6655/mib.h |   14 ------
 2 files changed, 127 deletions(-)

diff --git a/drivers/staging/vt6655/mib.c b/drivers/staging/vt6655/mib.c
index 111c018..805198f 100644
--- a/drivers/staging/vt6655/mib.c
+++ b/drivers/staging/vt6655/mib.c
@@ -25,12 +25,9 @@
  * Date: May 21, 1996
  *
  * Functions:
- *      STAvClearAllCounter - Clear All MIB Counter
  *      STAvUpdateIstStatCounter - Update ISR statistic counter
  *      STAvUpdateRDStatCounter - Update Rx statistic counter
- *      STAvUpdateRDStatCounterEx - Update Rx statistic counter and copy rcv data
  *      STAvUpdateTDStatCounter - Update Tx statistic counter
- *      STAvUpdateTDStatCounterEx - Update Tx statistic counter and copy tx data
  *      STAvUpdate802_11Counter - Update 802.11 mib counter
  *
  * Revision History:
@@ -55,24 +52,6 @@
 /*---------------------  Export Functions  --------------------------*/
 
 /*
- * Description: Clear All Statistic Counter
- *
- * Parameters:
- *  In:
- *      pStatistic  - Pointer to Statistic Counter Data Structure
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void STAvClearAllCounter(PSStatCounter pStatistic)
-{
-	// set memory to zero
-	memset(pStatistic, 0, sizeof(SStatCounter));
-}
-
-/*
  * Description: Update Isr Statistic Counter
  *
  * Parameters:
@@ -348,48 +327,6 @@ void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 }
 
 /*
- * Description: Update Rx Statistic Counter and copy Rx buffer
- *
- * Parameters:
- *  In:
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      byRSR           - Rx Status
- *      byNewRSR        - Rx Status
- *      pbyBuffer       - Rx Buffer
- *      cbFrameLength   - Rx Length
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-
-void
-STAvUpdateRDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char byRSR,
-	unsigned char byNewRSR,
-	unsigned char byRxRate,
-	unsigned char *pbyBuffer,
-	unsigned int cbFrameLength
-)
-{
-	STAvUpdateRDStatCounter(
-		pStatistic,
-		byRSR,
-		byNewRSR,
-		byRxRate,
-		pbyBuffer,
-		cbFrameLength
-);
-
-	// rx length
-	pStatistic->dwCntRxFrmLength = cbFrameLength;
-	// rx pattern, we just see 10 bytes for sample
-	memcpy(pStatistic->abyCntRxPattern, (unsigned char *)pbyBuffer, 10);
-}
-
-/*
  * Description: Update Tx Statistic Counter
  *
  * Parameters:
@@ -475,37 +412,6 @@ STAvUpdateTDStatCounter(
 }
 
 /*
- * Description: Update Tx Statistic Counter and copy Tx buffer
- *
- * Parameters:
- *  In:
- *      pStatistic      - Pointer to Statistic Counter Data Structure
- *      pbyBuffer       - Tx Buffer
- *      cbFrameLength   - Tx Length
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvUpdateTDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char *pbyBuffer,
-	unsigned long cbFrameLength
-)
-{
-	unsigned int uPktLength;
-
-	uPktLength = (unsigned int)cbFrameLength;
-
-	// tx length
-	pStatistic->dwCntTxBufLength = uPktLength;
-	// tx pattern, we just see 16 bytes for sample
-	memcpy(pStatistic->abyCntTxPattern, pbyBuffer, 16);
-}
-
-/*
  * Description: Update 802.11 mib counter
  *
  * Parameters:
@@ -541,22 +447,3 @@ STAvUpdate802_11Counter(
 	p802_11Counter->MulticastReceivedFrameCount = (unsigned long long) (pStatistic->dwRsrBroadcast +
 									    pStatistic->dwRsrMulticast);
 }
-
-/*
- * Description: Clear 802.11 mib counter
- *
- * Parameters:
- *  In:
- *      p802_11Counter  - Pointer to 802.11 mib counter
- *  Out:
- *      none
- *
- * Return Value: none
- *
- */
-void
-STAvClear802_11Counter(PSDot11Counters p802_11Counter)
-{
-	// set memory to zero
-	memset(p802_11Counter, 0, sizeof(SDot11Counters));
-}
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 732bdda..9b98773 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -311,33 +311,19 @@ typedef struct tagSStatCounter {
 #endif
 } SStatCounter, *PSStatCounter;
 
-void STAvClearAllCounter(PSStatCounter pStatistic);
-
 void STAvUpdateIsrStatCounter(PSStatCounter pStatistic, unsigned long dwIsr);
 
 void STAvUpdateRDStatCounter(PSStatCounter pStatistic,
 			     unsigned char byRSR, unsigned char byNewRSR, unsigned char byRxRate,
 			     unsigned char *pbyBuffer, unsigned int cbFrameLength);
 
-void STAvUpdateRDStatCounterEx(PSStatCounter pStatistic,
-			       unsigned char byRSR, unsigned char byNewRsr, unsigned char byRxRate,
-			       unsigned char *pbyBuffer, unsigned int cbFrameLength);
-
 void STAvUpdateTDStatCounter(PSStatCounter pStatistic, unsigned char byTSR0, unsigned char byTSR1,
 			     unsigned char *pbyBuffer, unsigned int cbFrameLength, unsigned int uIdx);
 
-void STAvUpdateTDStatCounterEx(
-	PSStatCounter   pStatistic,
-	unsigned char *pbyBuffer,
-	unsigned long cbFrameLength
-);
-
 void STAvUpdate802_11Counter(
 	PSDot11Counters p802_11Counter,
 	PSStatCounter   pStatistic,
 	unsigned long dwCounter
 );
 
-void STAvClear802_11Counter(PSDot11Counters p802_11Counter);
-
 #endif // __MIB_H__
-- 
1.7.10.4

