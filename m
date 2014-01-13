Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaAMTl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:41:58 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47583 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaAMTlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:41:53 -0500
From: Pol Eyschen <poleyschen@gmail.com>
To: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, jack@suse.cz,
        ufimtseva@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Pol Eyschen <poleyschen@hotmail.com>,
        Pol Eyschen <poleyschen@gmail.com>
Subject: [PATCH] Staging: ced1401: fix coding style in ced_ioc.c
Date: Mon, 13 Jan 2014 20:41:40 +0100
Message-Id: <1389642100-3601-1-git-send-email-poleyschen@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pol Eyschen <poleyschen@hotmail.com>

All comments fixed to match the kernel coding style.

Signed-off-by: Pol Eyschen <poleyschen@gmail.com>
---
 drivers/staging/ced1401/ced_ioc.c |  382 ++++++++++++++++++++++++-------------
 1 file changed, 249 insertions(+), 133 deletions(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index 62efd74..e5172cb 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -41,7 +41,8 @@ static void FlushOutBuff(DEVICE_EXTENSION *pdx)
 {
 	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
 		pdx->sCurrentState);
-	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
+	if (pdx->sCurrentState == U14ERR_TIME)
+		/* Do nothing if hardware in trouble */
 		return;
 	/* Kill off any pending I/O */
 	/* CharSend_Cancel(pdx);  */
@@ -62,7 +63,8 @@ static void FlushInBuff(DEVICE_EXTENSION *pdx)
 {
 	dev_dbg(&pdx->interface->dev, "%s currentState=%d", __func__,
 		pdx->sCurrentState);
-	if (pdx->sCurrentState == U14ERR_TIME)	/* Do nothing if hardware in trouble */
+	if (pdx->sCurrentState == U14ERR_TIME)
+		/* Do nothing if hardware in trouble */
 		return;
 	/* Kill off any pending I/O */
 	/*     CharRead_Cancel(pDevObject);  */
@@ -93,7 +95,8 @@ static int PutChars(DEVICE_EXTENSION *pdx, const char *pCh,
 		}
 		pdx->dwNumOutput += uCount;
 		spin_unlock_irq(&pdx->charOutLock);
-		iReturn = SendChars(pdx);	/*  ...give a chance to transmit data */
+		/*  ...give a chance to transmit data */
+		iReturn = SendChars(pdx);
 	} else {
 		iReturn = U14ERR_NOOUT;	/*  no room at the out (ha-ha) */
 		spin_unlock_irq(&pdx->charOutLock);
@@ -110,7 +113,8 @@ int SendString(DEVICE_EXTENSION *pdx, const char __user *pData,
 	       unsigned int n)
 {
 	int iReturn = U14ERR_NOERROR;	/*  assume all will be well */
-	char buffer[OUTBUF_SZ + 1];	/*  space in our address space for characters */
+	/*  space in our address space for characters */
+	char buffer[OUTBUF_SZ + 1];
 	if (n > OUTBUF_SZ)	/*  check space in local buffer... */
 		return U14ERR_NOOUT;	/*  ...too many characters */
 	if (copy_from_user(buffer, pData, n))
@@ -184,7 +188,8 @@ int Get1401State(DEVICE_EXTENSION *pdx, __u32 *state, __u32 *error)
 	if (nGot != sizeof(pdx->statBuf)) {
 		dev_err(&pdx->interface->dev,
 			"Get1401State() FAILED, return code %d", nGot);
-		pdx->sCurrentState = U14ERR_TIME;	/*  Indicate that things are very wrong indeed */
+		/*  Indicate that things are very wrong indeed */
+		pdx->sCurrentState = U14ERR_TIME;
 		*state = 0;	/*  Force status values to a known state */
 		*error = 0;
 	} else {
@@ -193,16 +198,19 @@ int Get1401State(DEVICE_EXTENSION *pdx, __u32 *state, __u32 *error)
 			"Get1401State() Success, state: 0x%x, 0x%x",
 			pdx->statBuf[0], pdx->statBuf[1]);
 
-		*state = pdx->statBuf[0];	/*  Return the state values to the calling code */
+		/*  Return the state values to the calling code */
+		*state = pdx->statBuf[0];
 		*error = pdx->statBuf[1];
 
-		nDevice = pdx->udev->descriptor.bcdDevice >> 8;	/*  1401 type code value */
+		/*  1401 type code value */
+		nDevice = pdx->udev->descriptor.bcdDevice >> 8;
 		switch (nDevice) {	/*  so we can clean up current state */
 		case 0:
 			pdx->sCurrentState = U14ERR_U1401;
 			break;
 
-		default:	/*  allow lots of device codes for future 1401s */
+		default:
+		/*  allow lots of device codes for future 1401s */
 			if ((nDevice >= 1) && (nDevice <= 23))
 				pdx->sCurrentState = (short)(nDevice + 6);
 			else
@@ -227,23 +235,33 @@ int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 	int ntStatus = STATUS_SUCCESS;
 	bool bResult = false;
 	unsigned int i;
-	/*  We can fill this in when we know how we will implement the staged transfer stuff */
+	/*
+	 * We can fill this in when we know how
+	 * we will implement the staged transfer stuff
+	 */
 	spin_lock_irq(&pdx->stagedLock);
 
-	if (pdx->bStagedUrbPending) {	/*  anything to be cancelled? May need more... */
+	if (pdx->bStagedUrbPending) {
+		/*  anything to be cancelled? May need more... */
 		dev_info(&pdx->interface - dev,
 			 "ReadWrite_Cancel about to cancel Urb");
 		/* Clear the staging done flag */
 		/* KeClearEvent(&pdx->StagingDoneEvent); */
 		USB_ASSERT(pdx->pStagedIrp != NULL);
 
-		/*  Release the spinlock first otherwise the completion routine may hang */
-		/*   on the spinlock while this function hands waiting for the event. */
+		/*
+		 *Release the spinlock first otherwise the completation
+		 * routine may hang on the spinlock while this function hands
+		 * waiting for the event.
+		 */
+
 		spin_unlock_irq(&pdx->stagedLock);
-		bResult = IoCancelIrp(pdx->pStagedIrp);	/*  Actually do the cancel */
+		/*  Actually do the cancel */
+		bResult = IoCancelIrp(pdx->pStagedIrp);
 		if (bResult) {
 			LARGE_INTEGER timeout;
-			timeout.QuadPart = -10000000;	/*  Use a timeout of 1 second */
+			/*  Use a timeout of 1 second */
+			timeout.QuadPart = -10000000;
 			dev_info(&pdx->interface - dev,
 				 "ReadWrite_Cancel about to wait till done");
 			ntStatus =
@@ -276,10 +294,12 @@ int ReadWrite_Cancel(DEVICE_EXTENSION *pdx)
 static int InSelfTest(DEVICE_EXTENSION *pdx, unsigned int *pState)
 {
 	unsigned int state, error;
-	int iReturn = Get1401State(pdx, &state, &error);	/*  see if in self-test */
+	/*  see if in self-test */
+	int iReturn = Get1401State(pdx, &state, &error);
 	if (iReturn == U14ERR_NOERROR)	/*  if all still OK */
-		iReturn = (state == (unsigned int)-1) ||	/*  TX problem or... */
-		    ((state & 0xff) == 0x80);	/*  ...self test */
+		/*  TX problem or self test */
+		iReturn = (state == (unsigned int)-1) ||
+		    ((state & 0xff) == 0x80);
 	*pState = state;	/*  return actual state */
 	return iReturn;
 }
@@ -311,15 +331,22 @@ bool Is1401(DEVICE_EXTENSION *pdx)
 	FlushInBuff(pdx);	/*  Clear out input buffer & pipe */
 	FlushOutBuff(pdx);	/*  Clear output buffer & pipe */
 
-	/*  The next call returns 0 if OK, but has returned 1 in the past, meaning that */
-	/*  usb_unlock_device() is needed... now it always is */
+	/*
+	 * The next call returns 0 if OK, but has returned 1 in the past,
+	 * meaning that usb_unlock_device() is needed... now it always is
+	 */
 	iReturn = usb_lock_device_for_reset(pdx->udev, pdx->interface);
 
-	/*  release the io_mutex because if we don't, we will deadlock due to system */
-	/*  calls back into the driver. */
-	mutex_unlock(&pdx->io_mutex);	/*  locked, so we will not get system calls */
-	if (iReturn >= 0) {	/*  if we failed */
-		iReturn = usb_reset_device(pdx->udev);	/*  try to do the reset */
+	/*
+	 * release the io_mutex because if we don't, we will deadlock
+	 * due to system calls back into the driver.
+	 */
+
+	mutex_unlock(&pdx->io_mutex);
+	/*  locked, so we will not get system calls */
+	if (iReturn >= 0) {
+		/*  if we failed try to do the reset */
+		iReturn = usb_reset_device(pdx->udev);
 		usb_unlock_device(pdx->udev);	/*  undo the lock */
 	}
 
@@ -327,17 +354,21 @@ bool Is1401(DEVICE_EXTENSION *pdx)
 	pdx->dwDMAFlag = MODE_CHAR;	/*  Clear DMA mode flag regardless! */
 	if (iReturn == 0) {	/*  if all is OK still */
 		unsigned int state;
-		iReturn = InSelfTest(pdx, &state);	/*  see if likely in self test */
+		/*  see if likely in self test */
+		iReturn = InSelfTest(pdx, &state);
 		if (iReturn > 0) {	/*  do we need to wait for self-test? */
-			unsigned long ulTimeOut = jiffies + 30 * HZ;	/*  when to give up */
+			/*  when to give up */
+			unsigned long ulTimeOut = jiffies + 30 * HZ;
 			while ((iReturn > 0) && time_before(jiffies, ulTimeOut)) {
 				schedule();	/*  let other stuff run */
-				iReturn = InSelfTest(pdx, &state);	/*  see if done yet */
+				/*  see if done yet */
+				iReturn = InSelfTest(pdx, &state);
 			}
 		}
 
 		if (iReturn == 0)	/*  if all is OK... */
-			iReturn = state == 0;	/*  then success is that the state is 0 */
+			/*  then success is that the state is 0 */
+			iReturn = state == 0;
 	} else
 		iReturn = 0;	/*  we failed */
 	pdx->bForceReset = false;	/*  Clear forced reset flag now */
@@ -364,29 +395,38 @@ bool QuickCheck(DEVICE_EXTENSION *pdx, bool bTestBuff, bool bCanReset)
 	bool bRet = false;	/*  assume it will fail and we will reset */
 	bool bShortTest;
 
-	bShortTest = ((pdx->dwDMAFlag == MODE_CHAR) &&	/*  no DMA running */
-		      (!pdx->bForceReset) &&	/*  Not had a real reset forced */
-		      (pdx->sCurrentState >= U14ERR_STD));	/*  No 1401 errors stored */
+	/*
+	 * no DMA running, did not have a real reset forced
+	 * and no 1401 errors stored.
+	 */
+
+	bShortTest = ((pdx->dwDMAFlag == MODE_CHAR) &&
+		      (!pdx->bForceReset) &&
+		      (pdx->sCurrentState >= U14ERR_STD));
 
 	dev_dbg(&pdx->interface->dev,
 		"%s DMAFlag:%d, state:%d, force:%d, testBuff:%d, short:%d",
 		__func__, pdx->dwDMAFlag, pdx->sCurrentState, pdx->bForceReset,
 		bTestBuff, bShortTest);
 
-	if ((bTestBuff) &&	/*  Buffer check requested, and... */
-	    (pdx->dwNumInput || pdx->dwNumOutput)) {	/*  ...characters were in the buffer? */
+	/*  Buffer check requested, and characters were in the buffer? */
+	if ((bTestBuff) && (pdx->dwNumInput || pdx->dwNumOutput)) {
 		bShortTest = false;	/*  Then do the full test */
 		dev_dbg(&pdx->interface->dev,
 			"%s will reset as buffers not empty", __func__);
 	}
 
 	if (bShortTest || !bCanReset) {	/*  Still OK to try the short test? */
-				/*  Always test if no reset - we want state update */
+		/*  Always test if no reset - we want state update */
 		unsigned int state, error;
 		dev_dbg(&pdx->interface->dev, "%s->Get1401State", __func__);
-		if (Get1401State(pdx, &state, &error) == U14ERR_NOERROR) {	/*  Check on the 1401 state */
-			if ((state & 0xFF) == 0)	/*  If call worked, check the status value */
-				bRet = true;	/*  If that was zero, all is OK, no reset needed */
+		/*  Check on the 1401 state */
+		if (Get1401State(pdx, &state, &error) == U14ERR_NOERROR) {
+			/*  If call worked, check the status value */
+			if ((state & 0xFF) == 0)
+				/* If that was zero, all is OK,
+				 * no reset needed */
+				bRet = true;
 		}
 	}
 
@@ -473,7 +513,8 @@ int GetString(DEVICE_EXTENSION *pdx, char __user *pUser, int n)
 		nAvailable = n;	/*  ...or input characters */
 
 	if (nAvailable > 0) {	/*  worth looking? */
-		char buffer[INBUF_SZ + 1];	/*  space for a linear copy of data */
+		/*  space for a linear copy of data */
+		char buffer[INBUF_SZ + 1];
 		int nGot = 0;
 		int nCopyToUser;	/*  number to copy to user */
 		char cData;
@@ -483,7 +524,8 @@ int GetString(DEVICE_EXTENSION *pdx, char __user *pUser, int n)
 				cData = (char)0;
 
 			if (pdx->dwInBuffGet >= INBUF_SZ)
-				pdx->dwInBuffGet = 0;	/*  wrap buffer pointer */
+				/*  wrap buffer pointer */
+				pdx->dwInBuffGet = 0;
 
 			buffer[nGot++] = cData;	/*  save the output */
 		} while ((nGot < nAvailable) && cData);
@@ -544,13 +586,16 @@ int LineCount(DEVICE_EXTENSION *pdx)
 	spin_lock_irq(&pdx->charInLock);	/*  Get protection */
 
 	if (pdx->dwNumInput > 0) {	/*  worth looking? */
-		unsigned int dwIndex = pdx->dwInBuffGet;	/*  start at first available */
-		unsigned int dwEnd = pdx->dwInBuffPut;	/*  Position for search end */
+		/*  start at first available */
+		unsigned int dwIndex = pdx->dwInBuffGet;
+		/*  Position for search end */
+		unsigned int dwEnd = pdx->dwInBuffPut;
 		do {
 			if (pdx->inputBuffer[dwIndex++] == CR_CHAR)
 				++iReturn;	/*  inc count if CR */
 
-			if (dwIndex >= INBUF_SZ)	/*  see if we fall off buff */
+			/*  see if we fall off buff */
+			if (dwIndex >= INBUF_SZ)
 				dwIndex = 0;
 		} while (dwIndex != dwEnd);	/*  go to last available */
 	}
@@ -571,7 +616,8 @@ int GetOutBufSpace(DEVICE_EXTENSION *pdx)
 	int iReturn;
 	mutex_lock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	SendChars(pdx);		/*  send any buffered chars */
-	iReturn = (int)(OUTBUF_SZ - pdx->dwNumOutput);	/*  no lock needed for single read */
+	/*  no lock needed for single read */
+	iReturn = (int)(OUTBUF_SZ - pdx->dwNumOutput);
 	dev_dbg(&pdx->interface->dev, "OutBufSpace %d", iReturn);
 	mutex_unlock(&pdx->io_mutex);	/*  Protect disconnect from new i/o */
 	return iReturn;
@@ -593,12 +639,15 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 		dev_err(&pdx->interface->dev, "%s Attempt to clear area %d",
 			__func__, nArea);
 	} else {
-		TRANSAREA *pTA = &pdx->rTransDef[nArea];	/*  to save typing */
-		if (!pTA->bUsed)	/*  if not used... */
-			iReturn = U14ERR_NOTSET;	/*  ...nothing to be done */
+		/*  to save typing */
+		TRANSAREA *pTA = &pdx->rTransDef[nArea];
+		if (!pTA->bUsed)
+			/* if not used, nothing to be done */
+			iReturn = U14ERR_NOTSET;
 		else {
-			/*  We must save the memory we return as we shouldn't mess with memory while */
-			/*  holding a spin lock. */
+			/* We must save the memory we return as
+			 * we shouldn't mess with memory while
+			 * holding a spin lock. */
 			struct page **pPages = NULL; /*save page address list*/
 			int nPages = 0;	/*  and number of pages */
 			int np;
@@ -608,32 +657,44 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 			spin_lock_irq(&pdx->stagedLock);
 			if ((pdx->StagedId == nArea)
 			    && (pdx->dwDMAFlag > MODE_CHAR)) {
-				iReturn = U14ERR_UNLOCKFAIL;	/*  cannot delete as in use */
+				/*  cannot delete as in use */
+				iReturn = U14ERR_UNLOCKFAIL;
 				dev_err(&pdx->interface->dev,
 					"%s call on area %d while active",
 					__func__, nArea);
 			} else {
-				pPages = pTA->pPages;	/*  save page address list */
-				nPages = pTA->nPages;	/*  and page count */
-				if (pTA->dwEventSz)	/*  if events flagging in use */
-					wake_up_interruptible(&pTA->wqEvent);	/*  release anything that was waiting */
+				/*  save page address list and page count */
+				pPages = pTA->pPages;
+				nPages = pTA->nPages;
+				if (pTA->dwEventSz)
+					/* if events flagging in use
+					 * release anything that was waiting */
+					wake_up_interruptible(&pTA->wqEvent);
 
 				if (pdx->bXFerWaiting
 				    && (pdx->rDMAInfo.wIdent == nArea))
-					pdx->bXFerWaiting = false;	/*  Cannot have pending xfer if area cleared */
-
-				/*  Clean out the TRANSAREA except for the wait queue, which is at the end */
-				/*  This sets bUsed to false and dwEventSz to 0 to say area not used and no events. */
+					/* Cannot have pending xfer if
+					 * area cleared */
+					pdx->bXFerWaiting = false;
+
+				/* Clean out the TRANSAREA except for the
+				 * wait queue, which is at the end.
+				 * This sets bUsed to false and dwEventSz
+				 * to 0 to say area not used and no events. */
 				memset(pTA, 0,
 				       sizeof(TRANSAREA) -
 				       sizeof(wait_queue_head_t));
 			}
 			spin_unlock_irq(&pdx->stagedLock);
 
-			if (pPages) { 	/*  if we decided to release the memory */
-				/*  Now we must undo the pinning down of the pages. We will assume the worst and mark */
-				/*  all the pages as dirty. Don't be tempted to move this up above as you must not be */
-				/*  holding a spin lock to do this stuff as it is not atomic. */
+			if (pPages) {
+				/* If we decided to release the memory, we
+				 * must undo the pinning down of the
+				 * pages. We will assume the worst and mark
+				 * all the pages as dirty. Don't be tempted to
+				 * move this up above as you must not be
+				 * holding a spin lock to do this stuff as it
+				 * is not atomic. */
 				dev_dbg(&pdx->interface->dev, "%s nPages=%d",
 					__func__, nPages);
 
@@ -663,9 +724,9 @@ int ClearArea(DEVICE_EXTENSION *pdx, int nArea)
 static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 		   unsigned int dwLength, bool bCircular, bool bCircToHost)
 {
-	/*  Start by working out the page aligned start of the area and the size */
-	/*  of the area in pages, allowing for the start not being aligned and the */
-	/*  end needing to be rounded up to a page boundary. */
+	/* Start by working out the page aligned start of the area and the size
+	 * of the area in pages, allowing for the start not being aligned and
+	 * the end needing to be rounded up to a page boundary. */
 	unsigned long ulStart = ((unsigned long)puBuf) & PAGE_MASK;
 	unsigned int ulOffset = ((unsigned long)puBuf) & (PAGE_SIZE - 1);
 	int len = (dwLength + ulOffset + PAGE_SIZE - 1) >> PAGE_SHIFT;
@@ -674,15 +735,18 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 	struct page **pPages = NULL;	/*  space for page tables */
 	int nPages = 0;		/*  and number of pages */
 
-	int iReturn = ClearArea(pdx, nArea);	/*  see if OK to use this area */
-	if ((iReturn != U14ERR_NOTSET) &&	/*  if not area unused and... */
-	    (iReturn != U14ERR_NOERROR))	/*  ...not all OK, then... */
-		return iReturn;	/*  ...we cannot use this area */
+	int iReturn = ClearArea(pdx, nArea);	/* see if OK to use this area */
+	if ((iReturn != U14ERR_NOTSET) &&	/* if not area unused and... */
+	    (iReturn != U14ERR_NOERROR))	/* ...not all OK, then... */
+		return iReturn;	/* ...we cannot use this area */
 
-	if (!access_ok(VERIFY_WRITE, puBuf, dwLength))	/*  if we cannot access the memory... */
-		return -EFAULT;	/*  ...then we are done */
+	if (!access_ok(VERIFY_WRITE, puBuf, dwLength))
+		/* if we cannot access the memory we are done */
+		return -EFAULT;
 
-	/*  Now allocate space to hold the page pointer and virtual address pointer tables */
+	/* Now allocate space to hold the page pointer and virtual
+	 * address pointer tables
+	 */
 	pPages = kmalloc(len * sizeof(struct page *), GFP_KERNEL);
 	if (!pPages) {
 		iReturn = U14ERR_NOMEMORY;
@@ -691,19 +755,25 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 	dev_dbg(&pdx->interface->dev, "%s %p, length=%06x, circular %d",
 		__func__, puBuf, dwLength, bCircular);
 
-	/*  To pin down user pages we must first acquire the mapping semaphore. */
+	/* To pin down user pages we must first acquire the mapping semaphore.*/
 	nPages = get_user_pages_fast(ulStart, len, 1, pPages);
 	dev_dbg(&pdx->interface->dev, "%s nPages = %d", __func__, nPages);
 
 	if (nPages > 0) {		/*  if we succeeded */
-		/*  If you are tempted to use page_address (form LDD3), forget it. You MUST use */
-		/*  kmap() or kmap_atomic() to get a virtual address. page_address will give you */
-		/*  (null) or at least it does in this context with an x86 machine. */
+		/* If you are tempted to use page_address (form LDD3),
+		 * forget it. You MUST use kmap() or kmap_atomic() to get a
+		 * virtual address. page_address will give you (null) or at
+		 * least it does in this context with an x86 machine.
+		 */
 		spin_lock_irq(&pdx->stagedLock);
-		pTA->lpvBuff = puBuf;	/*  keep start of region (user address) */
-		pTA->dwBaseOffset = ulOffset;	/*  save offset in first page to start of xfer */
-		pTA->dwLength = dwLength;	/*  Size if the region in bytes */
-		pTA->pPages = pPages;	/*  list of pages that are used by buffer */
+		/* keep start of region (user address) */
+		pTA->lpvBuff = puBuf;
+		/* save offset in first page to start of xfer */
+		pTA->dwBaseOffset = ulOffset;
+		/* Size if the region in bytes */
+		pTA->dwLength = dwLength;
+		/*  list of pages that are used by buffer */
+		pTA->pPages = pPages;
 		pTA->nPages = nPages;	/*  number of pages */
 
 		pTA->bCircular = bCircular;
@@ -747,9 +817,11 @@ int SetTransfer(DEVICE_EXTENSION *pdx, TRANSFERDESC __user *pTD)
 	mutex_lock(&pdx->io_mutex);
 	dev_dbg(&pdx->interface->dev, "%s area:%d, size:%08x", __func__,
 		td.wAreaNum, td.dwLength);
-	/*  The strange cast is done so that we don't get warnings in 32-bit linux about the size of the */
-	/*  pointer. The pointer is always passed as a 64-bit object so that we don't have problems using */
-	/*  a 32-bit program on a 64-bit system. unsigned long is 64-bits on a 64-bit system. */
+	/* The strange cast is done so that we don't get warnings in 32-bit
+	 * linux about the size of the pointer. The pointer is always passed as
+	 * a 64-bit object so that we don't have problems using a 32-bit program
+	 * on a 64-bit system. unsigned long is 64-bits on a 64-bit system.
+	 */
 	iReturn =
 	    SetArea(pdx, td.wAreaNum,
 		    (char __user *)((unsigned long)td.lpvBuff), td.dwLength,
@@ -792,12 +864,16 @@ int SetEvent(DEVICE_EXTENSION *pdx, TRANSFEREVENT __user *pTE)
 		return U14ERR_BADAREA;
 	else {
 		TRANSAREA *pTA = &pdx->rTransDef[te.wAreaNum];
-		mutex_lock(&pdx->io_mutex);	/*  make sure we have no competitor */
+		/*  make sure we have no competitor */
+		mutex_lock(&pdx->io_mutex);
 		spin_lock_irq(&pdx->stagedLock);
 		if (pTA->bUsed) {	/*  area must be in use */
-			pTA->dwEventSt = te.dwStart;	/*  set area regions */
-			pTA->dwEventSz = te.dwLength;	/*  set size (0 cancels it) */
-			pTA->bEventToHost = te.wFlags & 1;	/*  set the direction */
+			pTA->dwEventSt = te.dwStart;
+			/* set area regions, set size (0 cancels it) and set
+			 * the direction
+			 */
+			pTA->dwEventSz = te.dwLength;
+			pTA->bEventToHost = te.wFlags & 1;
 			pTA->iWakeUp = 0;	/*  zero the wake up count */
 		} else
 			iReturn = U14ERR_NOTSET;
@@ -822,15 +898,20 @@ int WaitEvent(DEVICE_EXTENSION *pdx, int nArea, int msTimeOut)
 	else {
 		int iWait;
 		TRANSAREA *pTA = &pdx->rTransDef[nArea];
-		msTimeOut = (msTimeOut * HZ + 999) / 1000;	/*  convert timeout to jiffies */
-
-		/*  We cannot wait holding the mutex, but we check the flags while holding */
-		/*  it. This may well be pointless as another thread could get in between */
-		/*  releasing it and the wait call. However, this would have to clear the */
-		/*  iWakeUp flag. However, the !pTA-bUsed may help us in this case. */
-		mutex_lock(&pdx->io_mutex);	/*  make sure we have no competitor */
-		if (!pTA->bUsed || !pTA->dwEventSz)	/*  check something to wait for... */
-			return U14ERR_NOTSET;	/*  ...else we do nothing */
+		/*  convert timeout to jiffies */
+		msTimeOut = (msTimeOut * HZ + 999) / 1000;
+
+		/* We cannot wait holding the mutex, but we check the flags
+		 * while holding it. This may well be pointless as another
+		 * thread could get in between releasing it and the wait call.
+		 * However, this would have to clear the iWakeUp flag.
+		 * However, the !pTA-bUsed may help us in this case.
+		 */
+		/*  make sure we have no competitor */
+		mutex_lock(&pdx->io_mutex);
+		if (!pTA->bUsed || !pTA->dwEventSz)
+			/* if there is nothing to wait for, we do nothing */
+			return U14ERR_NOTSET;
 		mutex_unlock(&pdx->io_mutex);
 
 		if (msTimeOut)
@@ -844,7 +925,8 @@ int WaitEvent(DEVICE_EXTENSION *pdx, int nArea, int msTimeOut)
 			    wait_event_interruptible(pTA->wqEvent, pTA->iWakeUp
 						     || !pTA->bUsed);
 		if (iWait)
-			iReturn = -ERESTARTSYS;	/*  oops - we have had a SIGNAL */
+			/*  oops - we have had a SIGNAL */
+			iReturn = -ERESTARTSYS;
 		else
 			iReturn = pTA->iWakeUp;	/*  else the wakeup count */
 
@@ -868,7 +950,8 @@ int TestEvent(DEVICE_EXTENSION *pdx, int nArea)
 		iReturn = U14ERR_BADAREA;
 	else {
 		TRANSAREA *pTA = &pdx->rTransDef[nArea];
-		mutex_lock(&pdx->io_mutex);	/*  make sure we have no competitor */
+		/*  make sure we have no competitor */
+		mutex_lock(&pdx->io_mutex);
 		spin_lock_irq(&pdx->stagedLock);
 		iReturn = pTA->iWakeUp;	/*  get wakeup count since last call */
 		pTA->iWakeUp = 0;	/*  clear the count */
@@ -892,7 +975,9 @@ int GetTransfer(DEVICE_EXTENSION *pdx, TGET_TX_BLOCK __user *pTX)
 	if (dwIdent >= MAX_TRANSAREAS)
 		iReturn = U14ERR_BADAREA;
 	else {
-		/*  Return the best information we have - we don't have physical addresses */
+		/* Return the best information we have -
+		 * we don't have physical addresses.
+		 */
 		TGET_TX_BLOCK *tx;
 
 		tx = kzalloc(sizeof(*tx), GFP_KERNEL);
@@ -902,7 +987,8 @@ int GetTransfer(DEVICE_EXTENSION *pdx, TGET_TX_BLOCK __user *pTX)
 		}
 		tx->size = pdx->rTransDef[dwIdent].dwLength;
 		tx->linear = (long long)((long)pdx->rTransDef[dwIdent].lpvBuff);
-		tx->avail = GET_TX_MAXENTRIES;	/*  how many blocks we could return */
+		/* how many blocks we could return */
+		tx->avail = GET_TX_MAXENTRIES;
 		tx->used = 1;	/*  number we actually return */
 		tx->entries[0].physical =
 		    (long long)(tx->linear + pdx->StagedOffset);
@@ -984,7 +1070,8 @@ int StartSelfTest(DEVICE_EXTENSION *pdx)
 	nGot = usb_control_msg(pdx->udev, usb_rcvctrlpipe(pdx->udev, 0),
 			       DB_SELFTEST, (H_TO_D | VENDOR | DEVREQ),
 			       0, 0, NULL, 0, HZ); /* allow 1 second timeout */
-	pdx->ulSelfTestTime = jiffies + HZ * 30;	/*  30 seconds into the future */
+	/*  30 seconds into the future */
+	pdx->ulSelfTestTime = jiffies + HZ * 30;
 
 	mutex_unlock(&pdx->io_mutex);
 	if (nGot < 0)
@@ -1008,11 +1095,13 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 
 	dev_dbg(&pdx->interface->dev, "%s", __func__);
 	iReturn = Get1401State(pdx, &state, &error);
-	if (iReturn == U14ERR_NOERROR)	/*  Only accept zero if it happens twice */
+	if (iReturn == U14ERR_NOERROR)
 		iReturn = Get1401State(pdx, &state, &error);
-
-	if (iReturn != U14ERR_NOERROR) {	/*  Self-test can cause comms errors */
-				/*  so we assume still testing */
+	/*  Only accept zero if it happens twice */
+	if (iReturn != U14ERR_NOERROR) {
+		/* Self-test can cause comms errors
+		 *  so we assume still testing
+		 */
 		dev_err(&pdx->interface->dev,
 			"%s Get1401State=%d, assuming still testing", __func__,
 			iReturn);
@@ -1021,7 +1110,8 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 		iReturn = U14ERR_NOERROR;
 	}
 
-	if ((state == -1) && (error == -1)) {	/*  If Get1401State had problems */
+	if ((state == -1) && (error == -1)) {
+		/*  If Get1401State had problems */
 		dev_err(&pdx->interface->dev,
 			"%s Get1401State failed, assuming still testing",
 			__func__);
@@ -1031,9 +1121,10 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 
 	if ((state & 0xFF) == 0x80) {	/*  If we are still in self-test */
 		if (state & 0x00FF0000)	{ /*  Have we got an error? */
-			gst.code = (state & 0x00FF0000) >> 16;	/*  read the error code */
-			gst.x = error & 0x0000FFFF;	/*  Error data X */
-			gst.y = (error & 0xFFFF0000) >> 16;	/*  and data Y */
+			/* read the error code */
+			gst.code = (state & 0x00FF0000) >> 16;
+			gst.x = error & 0x0000FFFF;	/* Error data X */
+			gst.y = (error & 0xFFFF0000) >> 16;	/* and data Y */
 			dev_dbg(&pdx->interface->dev, "Self-test error code %d",
 				gst.code);
 		} else {		/*  No error, check for timeout */
@@ -1052,11 +1143,12 @@ int CheckSelfTest(DEVICE_EXTENSION *pdx, TGET_SELFTEST __user *pGST)
 	}
 
 	if (gst.code < 0) {	/*  If we have a problem or finished */
-				/*  If using the 2890 we should reset properly */
+		/*  If using the 2890 we should reset properly */
 		if ((pdx->nPipes == 4) && (pdx->s1401Type <= TYPEPOWER))
 			Is1401(pdx);	/*  Get 1401 reset and OK */
 		else
-			QuickCheck(pdx, true, true);	/*  Otherwise check without reset unless problems */
+			/*  Otherwise check without reset unless problems */
+			QuickCheck(pdx, true, true);
 	}
 	mutex_unlock(&pdx->io_mutex);
 
@@ -1089,7 +1181,8 @@ int TypeOf1401(DEVICE_EXTENSION *pdx)
 		break;
 	default:
 		if ((pdx->s1401Type >= TYPEPOWER) && (pdx->s1401Type <= 25))
-			iReturn = pdx->s1401Type + 4;	/*  We can calculate types */
+			/* We can calculate types */
+			iReturn = pdx->s1401Type + 4;
 		else		/*   for up-coming 1401 designs */
 			iReturn = TYPEUNKNOWN;	/*  Don't know or not there */
 	}
@@ -1106,8 +1199,11 @@ int TypeOf1401(DEVICE_EXTENSION *pdx)
 ****************************************************************************/
 int TransferFlags(DEVICE_EXTENSION *pdx)
 {
-	int iReturn = U14TF_MULTIA | U14TF_DIAG |	/*  we always have multiple DMA area */
-	    U14TF_NOTIFY | U14TF_CIRCTH;	/*  diagnostics, notify and circular */
+	/* We always have multiple DMA area
+	 * diagnostics, notify and circular
+	 */
+	int iReturn = U14TF_MULTIA | U14TF_DIAG |
+	    U14TF_NOTIFY | U14TF_CIRCTH;
 	dev_dbg(&pdx->interface->dev, "%s", __func__);
 	mutex_lock(&pdx->io_mutex);
 	if (pdx->bIsUSB2)	/*  Set flag for USB2 if appropriate */
@@ -1199,8 +1295,8 @@ int DbgPoke(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 /****************************************************************************
 ** DbgRampData
 **
-** Execute the diagnostic ramp data operation. Parameters are in the CSBLOCK struct
-** in order address, default, enable mask, size and repeats.
+** Execute the diagnostic ramp data operation. Parameters are in the CSBLOCK
+** struct in order address, default, enable mask, size and repeats.
 ****************************************************************************/
 int DbgRampData(DEVICE_EXTENSION *pdx, TDBGBLOCK __user *pDB)
 {
@@ -1332,9 +1428,11 @@ int SetCircular(DEVICE_EXTENSION *pdx, TRANSFERDESC __user *pTD)
 		td.wAreaNum, td.dwLength);
 	bToHost = td.eSize != 0;	/*  this is used as the tohost flag */
 
-	/*  The strange cast is done so that we don't get warnings in 32-bit linux about the size of the */
-	/*  pointer. The pointer is always passed as a 64-bit object so that we don't have problems using */
-	/*  a 32-bit program on a 64-bit system. unsigned long is 64-bits on a 64-bit system. */
+	/* The strange cast is done so that we don't get warnings in 32-bit
+	 * linux about the size of the pointer. The pointer is always passed as
+	 * a 64-bit object so that we don't have problems using a 32-bit program
+	 * on a 64-bit system. unsigned long is 64-bits on a 64-bit system.
+	 */
 	iReturn =
 	    SetArea(pdx, td.wAreaNum,
 		    (char __user *)((unsigned long)td.lpvBuff), td.dwLength,
@@ -1366,12 +1464,16 @@ int GetCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 	cb.dwSize = 0;
 
 	if (nArea < MAX_TRANSAREAS) {	/*  The area number must be OK */
-		TRANSAREA *pArea = &pdx->rTransDef[nArea];	/*  Pointer to relevant info */
+		/*  Pointer to relevant info */
+		TRANSAREA *pArea = &pdx->rTransDef[nArea];
 		spin_lock_irq(&pdx->stagedLock);	/*  Lock others out */
 
-		if ((pArea->bUsed) && (pArea->bCircular) &&	/*  Must be circular area */
-		    (pArea->bCircToHost)) {	/*  For now at least must be to host */
-			if (pArea->aBlocks[0].dwSize > 0) {	/*  Got anything? */
+		/*  Must be circular area */
+		if ((pArea->bUsed) && (pArea->bCircular) &&
+		    (pArea->bCircToHost)) {
+			/*  For now at least must be to host */
+			if (pArea->aBlocks[0].dwSize > 0) {
+				/*  Got anything? */
 				cb.dwOffset = pArea->aBlocks[0].dwOffset;
 				cb.dwSize = pArea->aBlocks[0].dwSize;
 				dev_dbg(&pdx->interface->dev,
@@ -1417,21 +1519,32 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 	cb.dwSize = 0;
 
 	if (nArea < MAX_TRANSAREAS) {	/*  The area number must be OK */
-		TRANSAREA *pArea = &pdx->rTransDef[nArea];	/*  Pointer to relevant info */
+		/*  Pointer to relevant info */
+		TRANSAREA *pArea = &pdx->rTransDef[nArea];
 		spin_lock_irq(&pdx->stagedLock);	/*  Lock others out */
 
-		if ((pArea->bUsed) && (pArea->bCircular) &&	/*  Must be circular area */
-		    (pArea->bCircToHost)) {	/*  For now at least must be to host */
+		/*  Must be circular area */
+		if ((pArea->bUsed) && (pArea->bCircular) &&
+		    (pArea->bCircToHost)) {
+			/*  For now at least must be to host */
 			bool bWaiting = false;
 
-			if ((pArea->aBlocks[0].dwSize >= uSize) &&	/*  Got anything? */
-			    (pArea->aBlocks[0].dwOffset == uStart)) {	/*  Must be legal data */
+			/* Got anything? and must be legal data */
+			if ((pArea->aBlocks[0].dwSize >= uSize) &&
+			    (pArea->aBlocks[0].dwOffset == uStart)) {
 				pArea->aBlocks[0].dwSize -= uSize;
 				pArea->aBlocks[0].dwOffset += uSize;
-				if (pArea->aBlocks[0].dwSize == 0) {	/*  Have we emptied this block? */
-					if (pArea->aBlocks[1].dwSize) {	/*  Is there a second block? */
-						pArea->aBlocks[0] = pArea->aBlocks[1];	/*  Copy down block 2 data */
-						pArea->aBlocks[1].dwSize = 0;	/*  and mark the second block as unused */
+				/*  Have we emptied this block? */
+				if (pArea->aBlocks[0].dwSize == 0) {
+					/*  Is there a second block? */
+					if (pArea->aBlocks[1].dwSize) {
+						/* Copy down block 2 data
+						 * and mark the second block as
+						 * unused.
+						 */
+						pArea->aBlocks[0] =
+							pArea->aBlocks[1];
+						pArea->aBlocks[1].dwSize = 0;
 						pArea->aBlocks[1].dwOffset = 0;
 					} else
 						pArea->aBlocks[0].dwOffset = 0;
@@ -1444,8 +1557,11 @@ int FreeCircBlock(DEVICE_EXTENSION *pdx, TCIRCBLOCK __user *pCB)
 					pArea->aBlocks[0].dwOffset,
 					pdx->bXFerWaiting);
 
-				/*  Return the next available block of memory as well */
-				if (pArea->aBlocks[0].dwSize > 0) {	/*  Got anything? */
+				/* Return the next available block of
+				 * memory as well
+				 */
+				/* Got anything? */
+				if (pArea->aBlocks[0].dwSize > 0) {
 					cb.dwOffset =
 					    pArea->aBlocks[0].dwOffset;
 					cb.dwSize = pArea->aBlocks[0].dwSize;
-- 
1.7.10.4

