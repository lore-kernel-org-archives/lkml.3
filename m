Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaANFJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 00:09:50 -0500
Received: from smtprelay0005.hostedemail.com ([216.40.44.5]:33436 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750751AbaANFJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 00:09:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:69:355:379:541:960:966:968:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2693:2771:2828:2895:2897:2902:2904:2924:2926:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4423:4605:5007:6691:7652:7875:7903:7904:8603:8660:8957:9010:10226:10394:10848:11026:11232:11233:11876:11914:12043:12294:12296:12438:12517:12519:12555:12683:13148:13161:13229:13230:13868:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:
X-HE-Tag: lamp13_1a81c128b151f
X-Filterd-Recvd-Size: 53530
Message-ID: <1389676179.24849.33.camel@joe-AO722>
Subject: [PATCH] staging: ced1401: Fix dev_<level> messages
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pol Eyschen <poleyschen@gmail.com>, sachin.kamat@linaro.org, jack@suse.cz,
        ufimtseva@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Pol Eyschen <poleyschen@hotmail.com>
Date: Mon, 13 Jan 2014 21:09:39 -0800
In-Reply-To: <1389665978.24849.27.camel@joe-AO722>
References: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
	 <20140113235650.GA23380@kroah.com> <1389665978.24849.27.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing newline to each message.
Standardize style to "%s: ...", __func__.

Signed-off-by: Joe Perches <joe@perches.com>
---

There are a _lot_ of function tracing style
uses of dev_dbg that could/should be deleted.

This patch doesn't attempt to delete them.

 drivers/staging/ced1401/ced_ioc.c | 151 +++++++++++++++---------------
 drivers/staging/ced1401/usb1401.c | 188 +++++++++++++++++++-------------------
 2 files changed, 171 insertions(+), 168 deletions(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index bf532b1..573a283 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -38,8 +38,8 @@
 ****************************************************************************/
 static void FlushOutBuff(DEVICE_EXTENSION *pdx)
 {
-	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
-		pdx->sCurrentState);
+	dev_dbg(&pdx->interface->dev, "%s: currentState=%d\n",
+		__func__, pdx->sCurrentState);
 	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
 		return;
 	/* Kill off any pending I/O */
@@ -59,8 +59,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
 ****************************************************************************/
 static void FlushInBuff(DEVICE_EXTENSION *pdx)
 {
-	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
-		pdx->sCurrentState);
+	dev_dbg(&pdx->interface->dev, "%s: currentState=%d\n",
+		__func__, pdx->sCurrentState);
 	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
 		return;
 	/* Kill off any pending I/O */
@@ -118,8 +118,8 @@ int SendString(DEVICE_EXTENSION *pdx, const char __user *pData,
 
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	if (n > 0) {		/*  do nothing if nowt to do! */
-		dev_dbg(&pdx->interface->dev, "%s n=%d>%s<", __func__, n,
-			buffer);
+		dev_dbg(&pdx->interface->dev, "%s: n=%d>%s<\n",
+			__func__, n, buffer);
 		iReturn = PutChars(pdx, buffer, n);
 	}
 
@@ -139,7 +139,7 @@ int SendChar(DEVICE_EXTENSION *pdx, char c)
 	int iReturn;
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	iReturn = PutChars(pdx, &c, 1);
-	dev_dbg(&pdx->interface->dev, "SendChar >%c< (0x%02x)", c, c);
+	dev_dbg(&pdx->interface->dev, "SendChar >%c< (0x%02x)\n", c, c);
 	Allowi(pdx);	/*  Make sure char reads are running */
 	mutex_unlock(&pdx->io_mutex);
 	return iReturn;
@@ -174,7 +174,7 @@ int SendChar(DEVICE_EXTENSION *pdx, char c)
 int Get1401State(DEVICE_EXTENSION *pdx, __u32 *state, __u32 *error)
 {
 	int nGot;
-	dev_dbg(&pdx->interface->dev, "Get1401State() entry");
+	dev_dbg(&pdx->interface->dev, "%s: entry\n", __func__);
 
 	*state = 0xFFFFFFFF;	/*  Start off with invalid state */
 	nGot = usb_control_msg(pdx->udev, usb_rcvctrlpipe(pdx->udev, 0),
@@ -182,15 +182,15 @@ int Get1401State(DEVICE_EXTENSION *pdx, __u32 *state, __u32 *error)
 			       pdx->statBuf, sizeof(pdx->statBuf), HZ);
 	if (nGot != sizeof(pdx->statBuf)) {
 		dev_err(&pdx->interface->dev,
-			"Get1401State() FAILED, return code %d", nGot);
+			"%s: FAILED, return code %d\n", __func__, nGot);
 		pdx->sCurrentState = U14ERR_TIME;	/*  Indicate that things are very wrong indeed */
 		*state = 0;	/*  Force status values to a known state */
 		*error = 0;
 	} else {
 		int nDevice;
 		dev_dbg(&pdx->interface->dev,
-			"Get1401State() Success, state: 0x%x, 0x%x",
-			pdx->statBuf[0], pdx->statBuf[1]);
+			"%s: Success, state: 0x%x, 0x%x\n",
+			__func__, pdx->statBuf[0], pdx->statBuf[1]);
 
 		*state = pdx->statBuf[0];	/*  Return the state values to the calling code */
 		*error = pdx->statBuf[1];
@@ -220,8 +220,8 @@ int Get1401State(DEVICE_EXTENSION *pdx, __u32 *state, __u32 *error)
 ****************************************************************************/
 int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 {
-	dev_dbg(&pdx->interface->dev, "ReadWrite_Cancel entry %d",
-		pdx->bStagedUrbPending);
+	dev_dbg(&pdx->interface->dev, "%s: entry %d\n",
+		__func__, pdx->bStagedUrbPending);
 #ifdef NOT_WRITTEN_YET
 	int ntStatus = STATUS_SUCCESS;
 	bool bResult = false;
@@ -231,7 +231,7 @@ int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 
 	if (pdx->bStagedUrbPending) {	/*  anything to be cancelled? May need more... */
 		dev_info(&pdx->interface - dev,
-			 "ReadWrite_Cancel about to cancel Urb");
+			 "ReadWrite_Cancel about to cancel Urb\n");
 		/* Clear the staging done flag */
 		/* KeClearEvent(&pdx->StagingDoneEvent); */
 		USB_ASSERT(pdx->pStagedIrp != NULL);
@@ -244,14 +244,14 @@ int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 			LARGE_INTEGER timeout;
 			timeout.QuadPart = -10000000;	/*  Use a timeout of 1 second */
 			dev_info(&pdx->interface - dev,
-				 "ReadWrite_Cancel about to wait till done");
+				 "%s: about to wait till done\n", __func__);
 			ntStatus =
 			    KeWaitForSingleObject(&pdx->StagingDoneEvent,
 						  Executive, KernelMode, FALSE,
 						  &timeout);
 		} else {
 			dev_info(&pdx->interface - dev,
-				 "ReadWrite_Cancel, cancellation failed");
+				 "%s: cancellation failed\n", __func__);
 			ntStatus = U14ERR_FAIL;
 		}
 		USB_KdPrint(DBGLVL_DEFAULT,
@@ -260,7 +260,7 @@ int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 	} else
 		spin_unlock_irq(&pdx->stagedLock);
 
-	dev_info(&pdx->interface - dev, "ReadWrite_Cancel  done");
+	dev_info(&pdx->interface - dev, "%s: done\n", __func__);
 	return ntStatus;
 #else
 	return U14ERR_NOERROR;
@@ -304,7 +304,7 @@ static int InSelfTest(DEVICE_EXTENSION *pdx, unsigned int *pState)
 bool Is1401(DEVICE_EXTENSION *pdx)
 {
 	int iReturn;
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	ced_draw_down(pdx);	/*  wait for, then kill outstanding Urbs */
 	FlushInBuff(pdx);	/*  Clear out input buffer & pipe */
@@ -368,7 +368,7 @@ bool QuickCheck(DEVICE_EXTENSION *pdx, bool bTestBuff, bool bCanReset)
 		      (pdx->sCurrentState >= U14ERR_STD));	/*  No 1401 errors stored */
 
 	dev_dbg(&pdx->interface->dev,
-		"%s DMAFlag:%d, state:%d, force:%d, testBuff:%d, short:%d",
+		"%s: DMAFlag:%d, state:%d, force:%d, testBuff:%d, short:%d\n",
 		__func__, pdx->dwDMAFlag, pdx->sCurrentState, pdx->bForceReset,
 		bTestBuff, bShortTest);
 
@@ -376,13 +376,13 @@ bool QuickCheck(DEVICE_EXTENSION *pdx, bool bTestBuff, bool bCanReset)
 	    (pdx->dwNumInput || pdx->dwNumOutput)) {	/*  ...characters were in the buffer? */
 		bShortTest = false;	/*  Then do the full test */
 		dev_dbg(&pdx->interface->dev,
-			"%s will reset as buffers not empty", __func__);
+			"%s: will reset as buffers not empty\n", __func__);
 	}
 
 	if (bShortTest || !bCanReset) {	/*  Still OK to try the short test? */
 				/*  Always test if no reset - we want state update */
 		unsigned int state, error;
-		dev_dbg(&pdx->interface->dev, "%s->Get1401State", __func__);
+		dev_dbg(&pdx->interface->dev, "%s: Get1401State\n", __func__);
 		if (Get1401State(pdx, &state, &error) == U14ERR_NOERROR) {	/*  Check on the 1401 state */
 			if ((state & 0xFF) == 0)	/*  If call worked, check the status value */
 				bRet = true;	/*  If that was zero, all is OK, no reset needed */
@@ -390,7 +390,7 @@ bool QuickCheck(DEVICE_EXTENSION *pdx, bool bTestBuff, bool bCanReset)
 	}
 
 	if (!bRet && bCanReset)	{ /*  If all not OK, then */
-		dev_info(&pdx->interface->dev, "%s->Is1401 %d %d %d %d",
+		dev_info(&pdx->interface->dev, "%s: Is1401 %d %d %d %d\n",
 			 __func__, bShortTest, pdx->sCurrentState, bTestBuff,
 			 pdx->bForceReset);
 		bRet = Is1401(pdx);	/*   do full test */
@@ -407,7 +407,8 @@ bool QuickCheck(DEVICE_EXTENSION *pdx, bool bTestBuff, bool bCanReset)
 int Reset1401(DEVICE_EXTENSION *pdx)
 {
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
-	dev_dbg(&pdx->interface->dev, "ABout to call QuickCheck");
+	dev_dbg(&pdx->interface->dev, "%s: About to call QuickCheck\n",
+		__func__);
 	QuickCheck(pdx, true, true);	/*  Check 1401, reset if not OK */
 	mutex_unlock(&pdx->io_mutex);
 	return U14ERR_NOERROR;
@@ -423,7 +424,7 @@ int GetChar(DEVICE_EXTENSION *pdx)
 	int iReturn = U14ERR_NOIN;	/*  assume we will get  nothing */
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 
-	dev_dbg(&pdx->interface->dev, "GetChar");
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	Allowi(pdx);	/*  Make sure char reads are running */
 	SendChars(pdx);	/*  and send any buffered chars */
@@ -497,8 +498,8 @@ int GetString(DEVICE_EXTENSION *pdx, char __user *pUser, int n)
 		pdx->dwNumInput -= nGot;
 		spin_unlock_irq(&pdx->charInLock);
 
-		dev_dbg(&pdx->interface->dev,
-			"GetString read %d characters >%s<", nGot, buffer);
+		dev_dbg(&pdx->interface->dev, "%s: read %d characters >%s<\n",
+			__func__, nGot, buffer);
 		if (copy_to_user(pUser, buffer, nCopyToUser))
 			iReturn = -EFAULT;
 		else
@@ -555,7 +556,7 @@ int LineCount(DEVICE_EXTENSION *pdx)
 	}
 
 	spin_unlock_irq(&pdx->charInLock);
-	dev_dbg(&pdx->interface->dev, "LineCount returned %d", iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: returned %d\n", __func__, iReturn);
 	mutex_unlock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	return iReturn;
 }
@@ -571,7 +572,7 @@ int GetOutBufSpace(DEVICE_EXTENSION *pdx)
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	SendChars(pdx);		/*  send any buffered chars */
 	iReturn = (int)(OUTBUF_SZ - pdx->dwNumOutput);	/*  no lock needed for single read */
-	dev_dbg(&pdx->interface->dev, "OutBufSpace %d", iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: %d\n", __func__, iReturn);
 	mutex_unlock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	return iReturn;
 }
@@ -589,7 +590,7 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 
 	if ((nArea < 0) || (nArea >= MAX_TRANSAREAS)) {
 		iReturn = U14ERR_BADAREA;
-		dev_err(&pdx->interface->dev, "%s Attempt to clear area %d",
+		dev_err(&pdx->interface->dev, "%s: Attempt to clear area %d\n",
 			__func__, nArea);
 	} else {
 		TRANSAREA *pTA = &pdx->rTransDef[nArea];	/*  to save typing */
@@ -602,14 +603,14 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 			int nPages = 0;	/*  and number of pages */
 			int np;
 
-			dev_dbg(&pdx->interface->dev, "%s area %d", __func__,
-				nArea);
+			dev_dbg(&pdx->interface->dev, "%s: area %d\n",
+				__func__, nArea);
 			spin_lock_irq(&pdx->stagedLock);
 			if ((pdx->StagedId == nArea)
 			    && (pdx->dwDMAFlag > MODE_CHAR)) {
 				iReturn = U14ERR_UNLOCKFAIL;	/*  cannot delete as in use */
 				dev_err(&pdx->interface->dev,
-					"%s call on area %d while active",
+					"%s: call on area %d while active\n",
 					__func__, nArea);
 			} else {
 				pPages = pTA->pPages;	/*  save page address list */
@@ -633,7 +634,7 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 				/*  Now we must undo the pinning down of the pages. We will assume the worst and mark */
 				/*  all the pages as dirty. Don't be tempted to move this up above as you must not be */
 				/*  holding a spin lock to do this stuff as it is not atomic. */
-				dev_dbg(&pdx->interface->dev, "%s nPages=%d",
+				dev_dbg(&pdx->interface->dev, "%s: nPages=%d\n",
 					__func__, nPages);
 
 				for (np = 0; np < nPages; ++np) {
@@ -645,7 +646,7 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 
 				kfree(pPages);
 				dev_dbg(&pdx->interface->dev,
-					"%s kfree(pPages) done", __func__);
+					"%s: kfree(pPages) done\n", __func__);
 			}
 		}
 	}
@@ -687,12 +688,12 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 		iReturn = U14ERR_NOMEMORY;
 		goto error;
 	}
-	dev_dbg(&pdx->interface->dev, "%s %p, length=%06x, circular %d",
+	dev_dbg(&pdx->interface->dev, "%s: %p, length=%06x, circular %d\n",
 		__func__, puBuf, dwLength, bCircular);
 
 	/*  To pin down user pages we must first acquire the mapping semaphore. */
 	nPages = get_user_pages_fast(ulStart, len, 1, pPages);
-	dev_dbg(&pdx->interface->dev, "%s nPages = %d", __func__, nPages);
+	dev_dbg(&pdx->interface->dev, "%s: nPages = %d\n", __func__, nPages);
 
 	if (nPages > 0) {		/*  if we succeeded */
 		/*  If you are tempted to use page_address (form LDD3), forget it. You MUST use */
@@ -744,8 +745,8 @@ int SetTransfer(DEVICE_EXTENSION *pdx, TRANSFERDESC __user *pTD)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s area:%d, size:%08x", __func__,
-		td.wAreaNum, td.dwLength);
+	dev_dbg(&pdx->interface->dev, "%s: area:%d, size:%08x\n",
+		__func__, td.wAreaNum, td.dwLength);
 	/*  The strange cast is done so that we don't get warnings in 32-bit linux about the size of the */
 	/*  pointer. The pointer is always passed as a 64-bit object so that we don't have problems using */
 	/*  a 32-bit program on a 64-bit system. unsigned long is 64-bits on a 64-bit system. */
@@ -922,7 +923,7 @@ int GetTransfer(DEVICE_EXTENSION *pdx, TGET_TX_BLOCK __user *pTX)
 ****************************************************************************/
 int KillIO1401(DEVICE_EXTENSION *pdx)
 {
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	mutex_lock(&pdx->io_mutex);
 	FlushOutBuff(pdx);
 	FlushInBuff(pdx);
@@ -938,7 +939,7 @@ int KillIO1401(DEVICE_EXTENSION *pdx)
 int BlkTransState(DEVICE_EXTENSION *pdx)
 {
 	int iReturn = pdx->dwDMAFlag != MODE_CHAR;
-	dev_dbg(&pdx->interface->dev, "%s = %d", __func__, iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: %d\n", __func__, iReturn);
 	return iReturn;
 }
 
@@ -956,7 +957,7 @@ int StateOf1401(DEVICE_EXTENSION *pdx)
 	iReturn = pdx->sCurrentState;
 
 	mutex_unlock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s = %d", __func__, iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: %d\n", __func__, iReturn);
 
 	return iReturn;
 }
@@ -971,7 +972,7 @@ int StartSelfTest(DEVICE_EXTENSION *pdx)
 {
 	int nGot;
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	ced_draw_down(pdx);	/*  wait for, then kill outstanding Urbs */
 	FlushInBuff(pdx);	/*  Clear out input buffer & pipe */
@@ -987,7 +988,7 @@ int StartSelfTest(DEVICE_EXTENSION *pdx)
 
 	mutex_unlock(&pdx->io_mutex);
 	if (nGot < 0)
-		dev_err(&pdx->interface->dev, "%s err=%d", __func__, nGot);
+		dev_err(&pdx->interface->dev, "%s: err=%d\n", __func__, nGot);
 	return nGot < 0 ? U14ERR_FAIL : U14ERR_NOERROR;
 }
 
@@ -1005,7 +1006,7 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 
 	mutex_lock(&pdx->io_mutex);
 
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	iReturn = Get1401State(pdx, &state, &error);
 	if (iReturn == U14ERR_NOERROR)	/*  Only accept zero if it happens twice */
 		iReturn = Get1401State(pdx, &state, &error);
@@ -1013,8 +1014,8 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 	if (iReturn != U14ERR_NOERROR) {	/*  Self-test can cause comms errors */
 				/*  so we assume still testing */
 		dev_err(&pdx->interface->dev,
-			"%s Get1401State=%d, assuming still testing", __func__,
-			iReturn);
+			"%s: Get1401State=%d, assuming still testing\n",
+			__func__, iReturn);
 		state = 0x80;	/*  Force still-testing, no error */
 		error = 0;
 		iReturn = U14ERR_NOERROR;
@@ -1022,7 +1023,7 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 
 	if ((state == -1) && (error == -1)) {	/*  If Get1401State had problems */
 		dev_err(&pdx->interface->dev,
-			"%s Get1401State failed, assuming still testing",
+			"%s: Get1401State failed, assuming still testing\n",
 			__func__);
 		state = 0x80;	/*  Force still-testing, no error */
 		error = 0;
@@ -1033,21 +1034,21 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 			gst.code = (state & 0x00FF0000) >> 16;	/*  read the error code */
 			gst.x = error & 0x0000FFFF;	/*  Error data X */
 			gst.y = (error & 0xFFFF0000) >> 16;	/*  and data Y */
-			dev_dbg(&pdx->interface->dev, "Self-test error code %d",
-				gst.code);
+			dev_dbg(&pdx->interface->dev,
+				"Self-test error code %d\n", gst.code);
 		} else {		/*  No error, check for timeout */
 			unsigned long ulNow = jiffies;	/*  get current time */
 			if (time_after(ulNow, pdx->ulSelfTestTime)) {
 				gst.code = -2;	/*  Flag the timeout */
 				dev_dbg(&pdx->interface->dev,
-					"Self-test timed-out");
+					"Self-test timed-out\n");
 			} else
 				dev_dbg(&pdx->interface->dev,
-					"Self-test on-going");
+					"Self-test on-going\n");
 		}
 	} else {
 		gst.code = -1;	/*  Flag the test is done */
-		dev_dbg(&pdx->interface->dev, "Self-test done");
+		dev_dbg(&pdx->interface->dev, "Self-test done\n");
 	}
 
 	if (gst.code < 0) {	/*  If we have a problem or finished */
@@ -1074,7 +1075,7 @@ int TypeOf1401(DEVICE_EXTENSION *pdx)
 {
 	int iReturn = TYPEUNKNOWN;
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	switch (pdx->s1401Type) {
 	case TYPE1401:
@@ -1092,7 +1093,7 @@ int TypeOf1401(DEVICE_EXTENSION *pdx)
 		else		/*   for up-coming 1401 designs */
 			iReturn = TYPEUNKNOWN;	/*  Don't know or not there */
 	}
-	dev_dbg(&pdx->interface->dev, "%s %d", __func__, iReturn);
+	dev_dbg(&pdx->interface->dev, "%s %d\n", __func__, iReturn);
 	mutex_unlock(&pdx->io_mutex);
 
 	return iReturn;
@@ -1107,7 +1108,7 @@ int TransferFlags(DEVICE_EXTENSION *pdx)
 {
 	int iReturn = U14TF_MULTIA | U14TF_DIAG |	/*  we always have multiple DMA area */
 	    U14TF_NOTIFY | U14TF_CIRCTH;	/*  diagnostics, notify and circular */
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	mutex_lock(&pdx->io_mutex);
 	if (pdx->bIsUSB2)	/*  Set flag for USB2 if appropriate */
 		iReturn |= U14TF_USB2;
@@ -1125,15 +1126,15 @@ static int DbgCmd1401(DEVICE_EXTENSION *pdx, unsigned char cmd,
 		      unsigned int data)
 {
 	int iReturn;
-	dev_dbg(&pdx->interface->dev, "%s entry", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: entry\n", __func__);
 	iReturn = usb_control_msg(pdx->udev, usb_sndctrlpipe(pdx->udev, 0), cmd,
 				  (H_TO_D | VENDOR | DEVREQ),
 				  (unsigned short)data,
 				  (unsigned short)(data >> 16), NULL, 0, HZ);
 						/* allow 1 second timeout */
 	if (iReturn < 0)
-		dev_err(&pdx->interface->dev, "%s fail code=%d", __func__,
-			iReturn);
+		dev_err(&pdx->interface->dev, "%s: fail code=%d\n",
+			__func__, iReturn);
 
 	return iReturn;
 }
@@ -1152,7 +1153,7 @@ int DbgPeek(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s @ %08x", __func__, db.iAddr);
+	dev_dbg(&pdx->interface->dev, "%s: @ %08x\n", __func__, db.iAddr);
 
 	iReturn = DbgCmd1401(pdx, DB_SETADD, db.iAddr);
 	if (iReturn == U14ERR_NOERROR)
@@ -1181,7 +1182,7 @@ int DbgPoke(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s @ %08x", __func__, db.iAddr);
+	dev_dbg(&pdx->interface->dev, "%s: @ %08x\n", __func__, db.iAddr);
 
 	iReturn = DbgCmd1401(pdx, DB_SETADD, db.iAddr);
 	if (iReturn == U14ERR_NOERROR)
@@ -1210,7 +1211,7 @@ int DbgRampData(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s @ %08x", __func__, db.iAddr);
+	dev_dbg(&pdx->interface->dev, "%s: @ %08x\n", __func__, db.iAddr);
 
 	iReturn = DbgCmd1401(pdx, DB_SETADD, db.iAddr);
 	if (iReturn == U14ERR_NOERROR)
@@ -1242,7 +1243,7 @@ int DbgRampAddr(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	iReturn = DbgCmd1401(pdx, DB_SETDEF, db.iDefault);
 	if (iReturn == U14ERR_NOERROR)
@@ -1270,7 +1271,7 @@ int DbgGetData(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 	memset(&db, 0, sizeof(db));	/*  fill returned block with 0s */
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	/*  Read back the last peeked value from the 1401. */
 	iReturn = usb_control_msg(pdx->udev, usb_rcvctrlpipe(pdx->udev, 0),
@@ -1282,8 +1283,8 @@ int DbgGetData(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 		else
 			iReturn = U14ERR_NOERROR;
 	} else
-		dev_err(&pdx->interface->dev, "%s failed, code %d", __func__,
-			iReturn);
+		dev_err(&pdx->interface->dev, "%s: failed, code %d\n",
+			__func__, iReturn);
 
 	mutex_unlock(&pdx->io_mutex);
 
@@ -1302,7 +1303,7 @@ int DbgStopLoop(DEVICE_EXTENSION *pdx)
 	unsigned int uState, uErr;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	iReturn = Get1401State(pdx, &uState, &uErr);
 	mutex_unlock(&pdx->io_mutex);
 
@@ -1327,8 +1328,8 @@ int SetCircular(DEVICE_EXTENSION *pdx, TRANSFERDESC __user *pTD)
 		return -EFAULT;
 
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s area:%d, size:%08x", __func__,
-		td.wAreaNum, td.dwLength);
+	dev_dbg(&pdx->interface->dev, "%s: area:%d, size:%08x\n",
+		__func__, td.wAreaNum, td.dwLength);
 	bToHost = td.eSize != 0;	/*  this is used as the tohost flag */
 
 	/*  The strange cast is done so that we don't get warnings in 32-bit linux about the size of the */
@@ -1353,7 +1354,7 @@ int GetCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 	unsigned int nArea;
 	TCIRCBLOCK cb;
 
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	if (copy_from_user(&cb, pCB, sizeof(cb)))
 		return -EFAULT;
@@ -1374,7 +1375,7 @@ int GetCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 				cb.dwOffset = pArea->aBlocks[0].dwOffset;
 				cb.dwSize = pArea->aBlocks[0].dwSize;
 				dev_dbg(&pdx->interface->dev,
-					"%s return block 0: %d bytes at %d",
+					"%s: return block 0: %d bytes at %d\n",
 					__func__, cb.dwSize, cb.dwOffset);
 			}
 		} else
@@ -1402,7 +1403,7 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 	unsigned int nArea, uStart, uSize;
 	TCIRCBLOCK cb;
 
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	if (copy_from_user(&cb, pCB, sizeof(cb)))
 		return -EFAULT;
@@ -1437,7 +1438,7 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 				}
 
 				dev_dbg(&pdx->interface->dev,
-					"%s free %d bytes at %d, return %d bytes at %d, wait=%d",
+					"%s: free %d bytes at %d, return %d bytes at %d, wait=%d\n",
 					__func__, uSize, uStart,
 					pArea->aBlocks[0].dwSize,
 					pArea->aBlocks[0].dwOffset,
@@ -1453,13 +1454,13 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 				bWaiting = pdx->bXFerWaiting;
 				if (bWaiting && pdx->bStagedUrbPending) {
 					dev_err(&pdx->interface->dev,
-						"%s ERROR: waiting xfer and staged Urb pending!",
+						"%s: ERROR: waiting xfer and staged Urb pending!\n",
 						__func__);
 					bWaiting = false;
 				}
 			} else {
 				dev_err(&pdx->interface->dev,
-					"%s ERROR: freeing %d bytes at %d, block 0 is %d bytes at %d",
+					"%s: ERROR: freeing %d bytes at %d, block 0 is %d bytes at %d\n",
 					__func__, uSize, uStart,
 					pArea->aBlocks[0].dwSize,
 					pArea->aBlocks[0].dwOffset);
@@ -1475,7 +1476,7 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 						 pdx->rDMAInfo.dwSize);
 				if (RWMStat != U14ERR_NOERROR)
 					dev_err(&pdx->interface->dev,
-						"%s rw setup failed %d",
+						"%s: rw setup failed %d\n",
 						__func__, RWMStat);
 			}
 		} else
diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index efc310c..f441e33 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -166,7 +166,7 @@ static int ced_open(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	dev_dbg(&interface->dev, "%s got pdx", __func__);
+	dev_dbg(&interface->dev, "%s: got pdx\n", __func__);
 
 	/* increment our usage count for the device */
 	kref_get(&pdx->kref);
@@ -184,7 +184,7 @@ static int ced_open(struct inode *inode, struct file *file)
 			goto exit;
 		}
 	} else {		/* uncomment this block if you want exclusive open */
-		dev_err(&interface->dev, "%s fail: already open", __func__);
+		dev_err(&interface->dev, "%s: fail: already open\n", __func__);
 		retval = -EBUSY;
 		pdx->open_count--;
 		mutex_unlock(&pdx->io_mutex);
@@ -207,7 +207,7 @@ static int ced_release(struct inode *inode, struct file *file)
 	if (pdx == NULL)
 		return -ENODEV;
 
-	dev_dbg(&pdx->interface->dev, "%s called", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: called\n", __func__);
 	mutex_lock(&pdx->io_mutex);
 	if (!--pdx->open_count && pdx->interface)	/*  Allow autosuspend */
 		usb_autopm_put_interface(pdx->interface);
@@ -224,12 +224,12 @@ static int ced_flush(struct file *file, fl_owner_t id)
 	if (pdx == NULL)
 		return -ENODEV;
 
-	dev_dbg(&pdx->interface->dev, "%s char in pend=%d", __func__,
-		pdx->bReadCharsPending);
+	dev_dbg(&pdx->interface->dev, "%s: char in pend=%d\n",
+		__func__, pdx->bReadCharsPending);
 
 	/* wait for io to stop */
 	mutex_lock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s got io_mutex", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: got io_mutex\n", __func__);
 	ced_draw_down(pdx);
 
 	/* read out errors, leave subsequent opens a clean slate */
@@ -239,7 +239,7 @@ static int ced_flush(struct file *file, fl_owner_t id)
 	spin_unlock_irq(&pdx->err_lock);
 
 	mutex_unlock(&pdx->io_mutex);
-	dev_dbg(&pdx->interface->dev, "%s exit reached", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: exit reached\n", __func__);
 
 	return res;
 }
@@ -270,7 +270,7 @@ static void ced_writechar_callback(struct urb *pUrb)
 		    (pUrb->status == -ENOENT || pUrb->status == -ECONNRESET
 		     || pUrb->status == -ESHUTDOWN)) {
 			dev_err(&pdx->interface->dev,
-				"%s - nonzero write bulk status received: %d",
+				"%s: nonzero write bulk status received: %d\n",
 				__func__, pUrb->status);
 		}
 
@@ -287,10 +287,10 @@ static void ced_writechar_callback(struct urb *pUrb)
 		pdx->bSendCharsPending = false;	/*  Allow other threads again */
 		spin_unlock(&pdx->charOutLock);	/*  already at irq level */
 		dev_dbg(&pdx->interface->dev,
-			"%s - char out done, 0 chars sent", __func__);
+			"%s: char out done, 0 chars sent\n", __func__);
 	} else {
 		dev_dbg(&pdx->interface->dev,
-			"%s - char out done, %d chars sent", __func__, nGot);
+			"%s: char out done, %d chars sent\n", __func__, nGot);
 		spin_lock(&pdx->charOutLock);	/*  already at irq level */
 		pdx->dwNumOutput -= nGot;	/*  Now adjust the char send buffer */
 		pdx->dwOutBuffGet += nGot;	/*  to match what we did */
@@ -315,15 +315,15 @@ static void ced_writechar_callback(struct urb *pUrb)
 			    URB_NO_TRANSFER_DMA_MAP;
 			usb_anchor_urb(pdx->pUrbCharOut, &pdx->submitted);	/*  in case we need to kill it */
 			iReturn = usb_submit_urb(pdx->pUrbCharOut, GFP_ATOMIC);
-			dev_dbg(&pdx->interface->dev, "%s n=%d>%s<", __func__,
-				dwCount, pDat);
+			dev_dbg(&pdx->interface->dev, "%s: n=%d>%s<\n",
+				__func__, dwCount, pDat);
 			spin_lock(&pdx->charOutLock);	/*  grab lock for errors */
 			if (iReturn) {
 				pdx->bPipeError[nPipe] = 1;	/*  Flag an error to be handled later */
 				pdx->bSendCharsPending = false;	/*  Allow other threads again */
 				usb_unanchor_urb(pdx->pUrbCharOut);
 				dev_err(&pdx->interface->dev,
-					"%s usb_submit_urb() returned %d",
+					"%s: usb_submit_urb() returned %d\n",
 					__func__, iReturn);
 			}
 		} else
@@ -350,8 +350,8 @@ int SendChars(DEVICE_EXTENSION *pdx)
 		pdx->bSendCharsPending = true;	/*  Set flag to lock out other threads */
 
 		dev_dbg(&pdx->interface->dev,
-			"Send %d chars to 1401, EP0 flag %d\n", dwCount,
-			pdx->nPipes == 3);
+			"Send %d chars to 1401, EP0 flag %d\n",
+			dwCount, pdx->nPipes == 3);
 		/*  If we have only 3 end points we must send the characters to the 1401 using EP0. */
 		if (pdx->nPipes == 3) {
 			/*  For EP0 character transmissions to the 1401, we have to hang about until they */
@@ -375,11 +375,11 @@ int SendChars(DEVICE_EXTENSION *pdx)
 				if (nSent <= 0) {
 					iReturn = nSent ? nSent : -ETIMEDOUT;	/*  if 0 chars says we timed out */
 					dev_err(&pdx->interface->dev,
-						"Send %d chars by EP0 failed: %d",
+						"Send %d chars by EP0 failed: %d\n",
 						n, iReturn);
 				} else {
 					dev_dbg(&pdx->interface->dev,
-						"Sent %d chars by EP0", n);
+						"Sent %d chars by EP0\n", n);
 					count -= nSent;
 					index += nSent;
 				}
@@ -416,9 +416,9 @@ int SendChars(DEVICE_EXTENSION *pdx)
 		}
 	} else if (pdx->bSendCharsPending && (pdx->dwNumOutput > 0))
 		dev_dbg(&pdx->interface->dev,
-			"SendChars bSendCharsPending:true");
+			"%s: bSendCharsPending:true\n", __func__);
 
-	dev_dbg(&pdx->interface->dev, "SendChars exit code: %d", iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: exit code: %d\n", __func__, iReturn);
 	spin_unlock_irq(&pdx->charOutLock);	/*  Now let go of the spinlock */
 	return iReturn;
 }
@@ -446,7 +446,7 @@ static void CopyUserSpace(DEVICE_EXTENSION *pdx, int n)
 		    pdx->StagedDone + pdx->StagedOffset + pArea->dwBaseOffset;
 		char *pCoherBuf = pdx->pCoherStagedIO;	/*  coherent buffer */
 		if (!pArea->bUsed) {
-			dev_err(&pdx->interface->dev, "%s area %d unused",
+			dev_err(&pdx->interface->dev, "%s: area %d unused\n",
 				__func__, nArea);
 			return;
 		}
@@ -474,21 +474,21 @@ static void CopyUserSpace(DEVICE_EXTENSION *pdx, int n)
 					n -= uiXfer;
 				} else {
 					dev_err(&pdx->interface->dev,
-						"%s did not map page %d",
+						"%s: did not map page %d\n",
 						__func__, nPage);
 					return;
 				}
 
 			} else {
 				dev_err(&pdx->interface->dev,
-					"%s exceeded pages %d", __func__,
-					nPage);
+					"%s: exceeded pages %d\n",
+					__func__, nPage);
 				return;
 			}
 		}
 	} else
-		dev_err(&pdx->interface->dev, "%s bad area %d", __func__,
-			nArea);
+		dev_err(&pdx->interface->dev, "%s: bad area %d\n",
+			__func__, nArea);
 }
 
 /*  Forward declarations for stuff used circularly */
@@ -513,11 +513,11 @@ static void staged_callback(struct urb *pUrb)
 		    (pUrb->status == -ENOENT || pUrb->status == -ECONNRESET
 		     || pUrb->status == -ESHUTDOWN)) {
 			dev_err(&pdx->interface->dev,
-				"%s - nonzero write bulk status received: %d",
+				"%s: nonzero write bulk status received: %d\n",
 				__func__, pUrb->status);
 		} else
 			dev_info(&pdx->interface->dev,
-				 "%s - staged xfer cancelled", __func__);
+				 "%s: staged xfer cancelled\n", __func__);
 
 		spin_lock(&pdx->err_lock);
 		pdx->errors = pUrb->status;
@@ -525,26 +525,26 @@ static void staged_callback(struct urb *pUrb)
 		nGot = 0;	/*   and tidy up again if so */
 		bCancel = true;
 	} else {
-		dev_dbg(&pdx->interface->dev, "%s %d chars xferred", __func__,
-			nGot);
+		dev_dbg(&pdx->interface->dev, "%s: %d chars xferred\n",
+			__func__, nGot);
 		if (pdx->StagedRead)	/*  if reading, save to user space */
 			CopyUserSpace(pdx, nGot);	/*  copy from buffer to user */
 		if (nGot == 0)
-			dev_dbg(&pdx->interface->dev, "%s ZLP", __func__);
+			dev_dbg(&pdx->interface->dev, "%s: ZLP\n", __func__);
 	}
 
 	/*  Update the transfer length based on the TransferBufferLength value in the URB */
 	pdx->StagedDone += nGot;
 
-	dev_dbg(&pdx->interface->dev, "%s, done %d bytes of %d", __func__,
-		pdx->StagedDone, pdx->StagedLength);
+	dev_dbg(&pdx->interface->dev, "%s: done %d bytes of %d\n",
+		__func__, pdx->StagedDone, pdx->StagedLength);
 
 	if ((pdx->StagedDone == pdx->StagedLength) ||	/*  If no more to do */
 	    (bCancel)) {		/*  or this IRP was cancelled */
 		TRANSAREA *pArea = &pdx->rTransDef[pdx->StagedId];	/*  Transfer area info */
 		dev_dbg(&pdx->interface->dev,
-			"%s transfer done, bytes %d, cancel %d", __func__,
-			pdx->StagedDone, bCancel);
+			"%s: transfer done, bytes %d, cancel %d\n",
+			__func__, pdx->StagedDone, bCancel);
 
 		/*  Here is where we sort out what to do with this transfer if using a circular buffer. We have */
 		/*   a completed transfer that can be assumed to fit into the transfer area. We should be able to */
@@ -559,7 +559,7 @@ static void staged_callback(struct urb *pUrb)
 					pArea->aBlocks[1].dwSize +=
 					    pdx->StagedLength;
 					dev_dbg(&pdx->interface->dev,
-						"RWM_Complete, circ block 1 now %d bytes at %d",
+						"RWM_Complete, circ block 1 now %d bytes at %d\n",
 						pArea->aBlocks[1].dwSize,
 						pArea->aBlocks[1].dwOffset);
 				} else {
@@ -569,7 +569,7 @@ static void staged_callback(struct urb *pUrb)
 					pArea->aBlocks[1].dwSize =
 					    pdx->StagedLength;
 					dev_err(&pdx->interface->dev,
-						"%s ERROR, circ block 1 re-started %d bytes at %d",
+						"%s: ERROR, circ block 1 re-started %d bytes at %d\n",
 						__func__,
 						pArea->aBlocks[1].dwSize,
 						pArea->aBlocks[1].dwOffset);
@@ -582,7 +582,7 @@ static void staged_callback(struct urb *pUrb)
 					     pArea->aBlocks[0].dwSize)) {
 						pArea->aBlocks[0].dwSize += pdx->StagedLength;	/*  Just add this transfer in */
 						dev_dbg(&pdx->interface->dev,
-							"RWM_Complete, circ block 0 now %d bytes at %d",
+							"RWM_Complete, circ block 0 now %d bytes at %d\n",
 							pArea->aBlocks[0].
 							dwSize,
 							pArea->aBlocks[0].
@@ -593,7 +593,7 @@ static void staged_callback(struct urb *pUrb)
 						pArea->aBlocks[1].dwSize =
 						    pdx->StagedLength;
 						dev_dbg(&pdx->interface->dev,
-							"RWM_Complete, circ block 1 started %d bytes at %d",
+							"RWM_Complete, circ block 1 started %d bytes at %d\n",
 							pArea->aBlocks[1].
 							dwSize,
 							pArea->aBlocks[1].
@@ -605,7 +605,7 @@ static void staged_callback(struct urb *pUrb)
 					pArea->aBlocks[0].dwSize =
 					    pdx->StagedLength;
 					dev_dbg(&pdx->interface->dev,
-						"RWM_Complete, circ block 0 started %d bytes at %d",
+						"RWM_Complete, circ block 0 started %d bytes at %d\n",
 						pArea->aBlocks[0].dwSize,
 						pArea->aBlocks[0].dwOffset);
 				}
@@ -614,7 +614,7 @@ static void staged_callback(struct urb *pUrb)
 
 		if (!bCancel) { /*  Don't generate an event if cancelled */
 			dev_dbg(&pdx->interface->dev,
-				"RWM_Complete,  bCircular %d, bToHost %d, eStart %d, eSize %d",
+				"RWM_Complete,  bCircular %d, bToHost %d, eStart %d, eSize %d\n",
 				pArea->bCircular, pArea->bEventToHost,
 				pArea->dwEventSt, pArea->dwEventSz);
 			if ((pArea->dwEventSz) &&	/*  Set a user-mode event... */
@@ -641,7 +641,7 @@ static void staged_callback(struct urb *pUrb)
 
 				if (iWakeUp) {
 					dev_dbg(&pdx->interface->dev,
-						"About to set event to notify app");
+						"About to set event to notify app\n");
 					wake_up_interruptible(&pArea->wqEvent);	/*  wake up waiting processes */
 					++pArea->iWakeUp;	/*  increment wakeup count */
 				}
@@ -655,7 +655,7 @@ static void staged_callback(struct urb *pUrb)
 			if (pdx->bXFerWaiting) {	/*  Got a block xfer waiting? */
 				int iReturn;
 				dev_info(&pdx->interface->dev,
-					 "*** RWM_Complete *** pending transfer will now be set up!!!");
+					 "*** RWM_Complete *** pending transfer will now be set up!!!\n");
 				iReturn =
 				    ReadWriteMem(pdx, !pdx->rDMAInfo.bOutWard,
 						 pdx->rDMAInfo.wIdent,
@@ -664,7 +664,7 @@ static void staged_callback(struct urb *pUrb)
 
 				if (iReturn)
 					dev_err(&pdx->interface->dev,
-						"RWM_Complete rw setup failed %d",
+						"RWM_Complete rw setup failed %d\n",
 						iReturn);
 			}
 		}
@@ -685,7 +685,7 @@ static void staged_callback(struct urb *pUrb)
 	/*  not be upset by char input during DMA... sigh. Needs sorting out. */
 	if (bRestartCharInput)	/*  may be out of date, but... */
 		Allowi(pdx);	/*  ...Allowi tests a lock too. */
-	dev_dbg(&pdx->interface->dev, "%s done", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: done\n", __func__);
 }
 
 /****************************************************************************
@@ -707,7 +707,7 @@ static int StageChunk(DEVICE_EXTENSION *pdx)
 		return U14ERR_FAIL;
 
 	if (!CanAcceptIoRequests(pdx)) {	/*  got sudden remove? */
-		dev_info(&pdx->interface->dev, "%s sudden remove, giving up",
+		dev_info(&pdx->interface->dev, "%s: sudden remove, giving up\n",
 			 __func__);
 		return U14ERR_FAIL;	/*  could do with a better error */
 	}
@@ -731,11 +731,11 @@ static int StageChunk(DEVICE_EXTENSION *pdx)
 	if (iReturn) {
 		usb_unanchor_urb(pdx->pStagedUrb);	/*  kill it */
 		pdx->bPipeError[nPipe] = 1;	/*  Flag an error to be handled later */
-		dev_err(&pdx->interface->dev, "%s submit urb failed, code %d",
+		dev_err(&pdx->interface->dev, "%s: submit urb failed, code %d\n",
 			__func__, iReturn);
 	} else
 		pdx->bStagedUrbPending = true;	/*  Set the flag for staged URB pending */
-	dev_dbg(&pdx->interface->dev, "%s done so far:%d, this size:%d",
+	dev_dbg(&pdx->interface->dev, "%s: done so far:%d, this size:%d\n",
 		__func__, pdx->StagedDone, ChunkSize);
 
 	return iReturn;
@@ -764,28 +764,28 @@ int ReadWriteMem(DEVICE_EXTENSION *pdx, bool Read, unsigned short wIdent,
 	TRANSAREA *pArea = &pdx->rTransDef[wIdent];	/*  Transfer area info */
 
 	if (!CanAcceptIoRequests(pdx)) {	/*  Are we in a state to accept new requests? */
-		dev_err(&pdx->interface->dev, "%s can't accept requests",
+		dev_err(&pdx->interface->dev, "%s: can't accept requests\n",
 			__func__);
 		return U14ERR_FAIL;
 	}
 
 	dev_dbg(&pdx->interface->dev,
-		"%s xfer %d bytes to %s, offset %d, area %d", __func__, dwLen,
-		Read ? "host" : "1401", dwOffs, wIdent);
+		"%s: xfer %d bytes to %s, offset %d, area %d\n",
+		__func__, dwLen, Read ? "host" : "1401", dwOffs, wIdent);
 
 	/*  Amazingly, we can get an escape sequence back before the current staged Urb is done, so we */
 	/*   have to check for this situation and, if so, wait until all is OK. */
 	if (pdx->bStagedUrbPending) {
 		pdx->bXFerWaiting = true;	/*  Flag we are waiting */
 		dev_info(&pdx->interface->dev,
-			 "%s xfer is waiting, as previous staged pending",
+			 "%s: xfer is waiting, as previous staged pending\n",
 			 __func__);
 		return U14ERR_NOERROR;
 	}
 
 	if (dwLen == 0) {		/*  allow 0-len read or write; just return success */
 		dev_dbg(&pdx->interface->dev,
-			"%s OK; zero-len read/write request", __func__);
+			"%s: OK; zero-len read/write request\n", __func__);
 		return U14ERR_NOERROR;
 	}
 
@@ -795,7 +795,7 @@ int ReadWriteMem(DEVICE_EXTENSION *pdx, bool Read, unsigned short wIdent,
 		bool bWait = false;	/*  Flag for transfer having to wait */
 
 		dev_dbg(&pdx->interface->dev,
-			"Circular buffers are %d at %d and %d at %d",
+			"Circular buffers are %d at %d and %d at %d\n",
 			pArea->aBlocks[0].dwSize, pArea->aBlocks[0].dwOffset,
 			pArea->aBlocks[1].dwSize, pArea->aBlocks[1].dwOffset);
 		if (pArea->aBlocks[1].dwSize > 0) {	/*  Using the second block already? */
@@ -819,14 +819,14 @@ int ReadWriteMem(DEVICE_EXTENSION *pdx, bool Read, unsigned short wIdent,
 		if (bWait) {	/*  This transfer will have to wait? */
 			pdx->bXFerWaiting = true;	/*  Flag we are waiting */
 			dev_dbg(&pdx->interface->dev,
-				"%s xfer waiting for circular buffer space",
+				"%s: xfer waiting for circular buffer space\n",
 				__func__);
 			return U14ERR_NOERROR;
 		}
 
 		dev_dbg(&pdx->interface->dev,
-			"%s circular xfer, %d bytes starting at %d", __func__,
-			dwLen, dwOffs);
+			"%s: circular xfer, %d bytes starting at %d\n",
+			__func__, dwLen, dwOffs);
 	}
 	/*  Save the parameters for the read\write transfer */
 	pdx->StagedRead = Read;	/*  Save the parameters for this read */
@@ -948,7 +948,7 @@ static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 	unsigned char ucData;
 	unsigned int dDone = 0;	/*  We haven't parsed anything so far */
 
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	if (ReadChar(&ucData, pBuf, &dDone, dwCount)) {
 		unsigned char ucTransCode = (ucData & 0x0F);	/*  get code for transfer type */
@@ -960,8 +960,8 @@ static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 		pDmaDesc->dwSize = 0;	/*  initialise other bits */
 		pDmaDesc->dwOffset = 0;
 
-		dev_dbg(&pdx->interface->dev, "%s type: %d ident: %d", __func__,
-			pDmaDesc->wTransType, pDmaDesc->wIdent);
+		dev_dbg(&pdx->interface->dev, "%s: type: %d ident: %d\n",
+			__func__, pDmaDesc->wTransType, pDmaDesc->wIdent);
 
 		pDmaDesc->bOutWard = (ucTransCode != TM_EXTTOHOST);	/*  set transfer direction */
 
@@ -976,7 +976,7 @@ static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 						&dDone, dwCount);
 				if (bResult) {
 					dev_dbg(&pdx->interface->dev,
-						"%s xfer offset & size %d %d",
+						"%s: xfer offset & size %d %d\n",
 						__func__, pDmaDesc->dwOffset,
 						pDmaDesc->dwSize);
 
@@ -989,7 +989,7 @@ static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 					      dwLength))) {
 						bResult = false;	/*  bad parameter(s) */
 						dev_dbg(&pdx->interface->dev,
-							"%s bad param - id %d, bUsed %d, offset %d, size %d, area length %d",
+							"%s: bad param - id %d, bUsed %d, offset %d, size %d, area length %d\n",
 							__func__, wIdent,
 							pdx->rTransDef[wIdent].
 							bUsed,
@@ -1008,7 +1008,7 @@ static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 		bResult = false;
 
 	if (!bResult)		/*  now check parameters for validity */
-		dev_err(&pdx->interface->dev, "%s error reading Esc sequence",
+		dev_err(&pdx->interface->dev, "%s: error reading Esc sequence\n",
 			__func__);
 
 	return bResult;
@@ -1045,14 +1045,15 @@ static int Handle1401Esc(DEVICE_EXTENSION *pdx, char *pCh,
 			unsigned short wTransType = pdx->rDMAInfo.wTransType;	/*  check transfer type */
 
 			dev_dbg(&pdx->interface->dev,
-				"%s xfer to %s, offset %d, length %d", __func__,
+				"%s: xfer to %s, offset %d, length %d\n",
+				__func__,
 				pdx->rDMAInfo.bOutWard ? "1401" : "host",
 				pdx->rDMAInfo.dwOffset, pdx->rDMAInfo.dwSize);
 
 			if (pdx->bXFerWaiting) { /*  Check here for badly out of kilter... */
 				/*  This can never happen, really */
 				dev_err(&pdx->interface->dev,
-					"ERROR: DMA setup while transfer still waiting");
+					"ERROR: DMA setup while transfer still waiting\n");
 				spin_unlock(&pdx->stagedLock);
 			} else {
 				if ((wTransType == TM_EXTTOHOST)
@@ -1066,21 +1067,21 @@ static int Handle1401Esc(DEVICE_EXTENSION *pdx, char *pCh,
 							 pdx->rDMAInfo.dwSize);
 					if (iReturn != U14ERR_NOERROR)
 						dev_err(&pdx->interface->dev,
-							"%s ReadWriteMem() failed %d",
+							"%s: ReadWriteMem() failed %d\n",
 							__func__, iReturn);
 				} else	/*  This covers non-linear transfer setup */
 					dev_err(&pdx->interface->dev,
-						"%s Unknown block xfer type %d",
+						"%s: Unknown block xfer type %d\n",
 						__func__, wTransType);
 			}
 		} else		/*  Failed to read parameters */
-			dev_err(&pdx->interface->dev, "%s ReadDMAInfo() fail",
+			dev_err(&pdx->interface->dev, "%s: ReadDMAInfo() fail\n",
 				__func__);
 
 		spin_unlock(&pdx->stagedLock);	/*  OK here */
 	}
 
-	dev_dbg(&pdx->interface->dev, "%s returns %d", __func__, iReturn);
+	dev_dbg(&pdx->interface->dev, "%s: returns %d\n", __func__, iReturn);
 
 	return iReturn;
 }
@@ -1100,11 +1101,11 @@ static void ced_readchar_callback(struct urb *pUrb)
 		    (pUrb->status == -ENOENT || pUrb->status == -ECONNRESET
 		     || pUrb->status == -ESHUTDOWN)) {
 			dev_err(&pdx->interface->dev,
-				"%s - nonzero write bulk status received: %d",
+				"%s: nonzero write bulk status received: %d\n",
 				__func__, pUrb->status);
 		} else
 			dev_dbg(&pdx->interface->dev,
-				"%s - 0 chars pUrb->status=%d (shutdown?)",
+				"%s: 0 chars pUrb->status=%d (shutdown?)\n",
 				__func__, pUrb->status);
 
 		spin_lock(&pdx->err_lock);
@@ -1125,7 +1126,7 @@ static void ced_readchar_callback(struct urb *pUrb)
 				if (nGot < INBUF_SZ) {
 					pdx->pCoherCharIn[nGot] = 0;	/*  tidy the string */
 					dev_dbg(&pdx->interface->dev,
-						"%s got %d chars >%s<",
+						"%s: got %d chars >%s<\n",
 						__func__, nGot,
 						pdx->pCoherCharIn);
 				}
@@ -1140,7 +1141,7 @@ static void ced_readchar_callback(struct urb *pUrb)
 				if ((pdx->dwNumInput + nGot) <= INBUF_SZ)
 					pdx->dwNumInput += nGot;	/*  Adjust the buffer count accordingly */
 			} else
-				dev_dbg(&pdx->interface->dev, "%s read ZLP",
+				dev_dbg(&pdx->interface->dev, "%s: read ZLP\n",
 					__func__);
 		}
 	}
@@ -1178,7 +1179,7 @@ int Allowi(DEVICE_EXTENSION *pdx)
 		unsigned int nMax = INBUF_SZ - pdx->dwNumInput;	/*  max we could read */
 		int nPipe = pdx->nPipes == 4 ? 1 : 0;	/*  The pipe number to use */
 
-		dev_dbg(&pdx->interface->dev, "%s %d chars in input buffer",
+		dev_dbg(&pdx->interface->dev, "%s: %d chars in input buffer\n",
 			__func__, pdx->dwNumInput);
 
 		usb_fill_int_urb(pdx->pUrbCharIn, pdx->udev,
@@ -1192,7 +1193,8 @@ int Allowi(DEVICE_EXTENSION *pdx)
 			usb_unanchor_urb(pdx->pUrbCharIn);	/*  remove from list of active Urbs */
 			pdx->bPipeError[nPipe] = 1;	/*  Flag an error to be handled later */
 			dev_err(&pdx->interface->dev,
-				"%s submit urb failed: %d", __func__, iReturn);
+				"%s: submit urb failed: %d\n",
+				__func__, iReturn);
 		} else
 			pdx->bReadCharsPending = true;	/*  Flag that we are active here */
 	}
@@ -1397,7 +1399,7 @@ static int ced_probe(struct usb_interface *interface,
 	else if ((i >= 1) && (i <= 23))
 		pdx->s1401Type = i + 2;
 	else {
-		dev_err(&interface->dev, "%s Unknown device. bcdDevice = %d",
+		dev_err(&interface->dev, "%s: Unknown device. bcdDevice = %d\n",
 			__func__, bcdDevice);
 		goto error;
 	}
@@ -1405,7 +1407,7 @@ static int ced_probe(struct usb_interface *interface,
 	/*  we know that we are dealing with a 1401 device. */
 	iface_desc = interface->cur_altsetting;
 	pdx->nPipes = iface_desc->desc.bNumEndpoints;
-	dev_info(&interface->dev, "1401Type=%d with %d End Points",
+	dev_info(&interface->dev, "1401Type=%d with %d End Points\n",
 		 pdx->s1401Type, pdx->nPipes);
 	if ((pdx->nPipes < 3) || (pdx->nPipes > 4))
 		goto error;
@@ -1415,7 +1417,7 @@ static int ced_probe(struct usb_interface *interface,
 	pdx->pUrbCharIn = usb_alloc_urb(0, GFP_KERNEL);	/*  character input URB */
 	pdx->pStagedUrb = usb_alloc_urb(0, GFP_KERNEL);	/*  block transfer URB */
 	if (!pdx->pUrbCharOut || !pdx->pUrbCharIn || !pdx->pStagedUrb) {
-		dev_err(&interface->dev, "%s URB alloc failed", __func__);
+		dev_err(&interface->dev, "%s: URB alloc failed\n", __func__);
 		goto error;
 	}
 
@@ -1429,7 +1431,7 @@ static int ced_probe(struct usb_interface *interface,
 	    usb_alloc_coherent(pdx->udev, INBUF_SZ, GFP_KERNEL,
 			       &pdx->pUrbCharIn->transfer_dma);
 	if (!pdx->pCoherCharOut || !pdx->pCoherCharIn || !pdx->pCoherStagedIO) {
-		dev_err(&interface->dev, "%s Coherent buffer alloc failed",
+		dev_err(&interface->dev, "%s: Coherent buffer alloc failed\n",
 			__func__);
 		goto error;
 	}
@@ -1437,19 +1439,19 @@ static int ced_probe(struct usb_interface *interface,
 	for (i = 0; i < pdx->nPipes; ++i) {
 		endpoint = &iface_desc->endpoint[i].desc;
 		pdx->epAddr[i] = endpoint->bEndpointAddress;
-		dev_info(&interface->dev, "Pipe %d, ep address %02x", i,
-			 pdx->epAddr[i]);
+		dev_info(&interface->dev, "Pipe %d, ep address %02x\n",
+			 i, pdx->epAddr[i]);
 		if (((pdx->nPipes == 3) && (i == 0)) ||	/*  if char input end point */
 		    ((pdx->nPipes == 4) && (i == 1))) {
 			pdx->bInterval = endpoint->bInterval;	/*  save the endpoint interrupt interval */
-			dev_info(&interface->dev, "Pipe %d, bInterval = %d", i,
-				 pdx->bInterval);
+			dev_info(&interface->dev, "Pipe %d, bInterval = %d\n",
+				 i, pdx->bInterval);
 		}
 		/*  Detect USB2 by checking last ep size (64 if USB1) */
 		if (i == pdx->nPipes - 1) {	/*  if this is the last ep (bulk) */
 			pdx->bIsUSB2 =
 			    le16_to_cpu(endpoint->wMaxPacketSize) > 64;
-			dev_info(&pdx->interface->dev, "USB%d",
+			dev_info(&pdx->interface->dev, "USB%d\n",
 				 pdx->bIsUSB2 + 1);
 		}
 	}
@@ -1462,14 +1464,14 @@ static int ced_probe(struct usb_interface *interface,
 	if (retval) {
 		/* something prevented us from registering this driver */
 		dev_err(&interface->dev,
-			"Not able to get a minor for this device.\n");
+			"Not able to get a minor for this device\n");
 		usb_set_intfdata(interface, NULL);
 		goto error;
 	}
 
 	/* let the user know what node this device is now attached to */
 	dev_info(&interface->dev,
-		 "USB CEDUSB device now attached to cedusb #%d",
+		 "USB CEDUSB device now attached to cedusb #%d\n",
 		 interface->minor);
 	return 0;
 
@@ -1493,7 +1495,7 @@ static void ced_disconnect(struct usb_interface *interface)
 	for (i = 0; i < MAX_TRANSAREAS; ++i) {
 		int iErr = ClearArea(pdx, i);	/*  ...release any used memory */
 		if (iErr == U14ERR_UNLOCKFAIL)
-			dev_err(&pdx->interface->dev, "%s Area %d was in used",
+			dev_err(&pdx->interface->dev, "%s: Area %d was in used\n",
 				__func__, i);
 	}
 	pdx->interface = NULL;	/*  ...we kill off link to interface */
@@ -1503,7 +1505,7 @@ static void ced_disconnect(struct usb_interface *interface)
 
 	kref_put(&pdx->kref, ced_delete);	/*  decrement our usage count */
 
-	dev_info(&interface->dev, "USB cedusb #%d now disconnected", minor);
+	dev_info(&interface->dev, "USB cedusb #%d now disconnected\n", minor);
 }
 
 /*  Wait for all the urbs we know of to be done with, then kill off any that */
@@ -1513,13 +1515,13 @@ static void ced_disconnect(struct usb_interface *interface)
 void ced_draw_down(DEVICE_EXTENSION *pdx)
 {
 	int time;
-	dev_dbg(&pdx->interface->dev, "%s called", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: called\n", __func__);
 
 	pdx->bInDrawDown = true;
 	time = usb_wait_anchor_empty_timeout(&pdx->submitted, 3000);
 	if (!time) {		/*  if we timed out we kill the urbs */
 		usb_kill_anchored_urbs(&pdx->submitted);
-		dev_err(&pdx->interface->dev, "%s timed out", __func__);
+		dev_err(&pdx->interface->dev, "%s: timed out\n", __func__);
 	}
 	pdx->bInDrawDown = false;
 }
@@ -1531,7 +1533,7 @@ static int ced_suspend(struct usb_interface *intf, pm_message_t message)
 		return 0;
 	ced_draw_down(pdx);
 
-	dev_dbg(&pdx->interface->dev, "%s called", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: called\n", __func__);
 	return 0;
 }
 
@@ -1540,14 +1542,14 @@ static int ced_resume(struct usb_interface *intf)
 	DEVICE_EXTENSION *pdx = usb_get_intfdata(intf);
 	if (!pdx)
 		return 0;
-	dev_dbg(&pdx->interface->dev, "%s called", __func__);
+	dev_dbg(&pdx->interface->dev, "%s: called\n", __func__);
 	return 0;
 }
 
 static int ced_pre_reset(struct usb_interface *intf)
 {
 	DEVICE_EXTENSION *pdx = usb_get_intfdata(intf);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	mutex_lock(&pdx->io_mutex);
 	ced_draw_down(pdx);
 	return 0;
@@ -1556,7 +1558,7 @@ static int ced_pre_reset(struct usb_interface *intf)
 static int ced_post_reset(struct usb_interface *intf)
 {
 	DEVICE_EXTENSION *pdx = usb_get_intfdata(intf);
-	dev_dbg(&pdx->interface->dev, "%s", __func__);
+	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	/* we are sure no URBs are active - no locking needed */
 	pdx->errors = -EPIPE;


