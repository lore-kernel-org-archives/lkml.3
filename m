Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3AYGmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:42:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:17770 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab3AYGmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:42:15 -0500
Date: Fri, 25 Jan 2013 09:42:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] video/kyro: delete some dead code
Message-ID: <20130125064205.GC4882@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_OLDCODE is never defined.  Delete it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/video/kyro/STG4000OverlayDevice.c b/drivers/video/kyro/STG4000OverlayDevice.c
index 0aeeaa1..84b6ea8 100644
--- a/drivers/video/kyro/STG4000OverlayDevice.c
+++ b/drivers/video/kyro/STG4000OverlayDevice.c
@@ -430,10 +430,7 @@ int SetOverlayViewPort(volatile STG4000REG __iomem *pSTGReg,
 	 */
 	ulSrc = srcDest.ulSrcX2 - srcDest.ulSrcX1;
 	ulDest = srcDest.lDstX2 - srcDest.lDstX1;
-#ifdef _OLDCODE
-	ulLeft = srcDest.ulDstX1;
-	ulRight = srcDest.ulDstX2;
-#else
+
 	if (srcDest.ulDstX1 > 2) {
 		ulLeft = srcDest.ulDstX1 + 2;
 		ulRight = srcDest.ulDstX2 + 1;
@@ -441,7 +438,7 @@ int SetOverlayViewPort(volatile STG4000REG __iomem *pSTGReg,
 		ulLeft = srcDest.ulDstX1;
 		ulRight = srcDest.ulDstX2 + 1;
 	}
-#endif
+
 	/* first work out the position we are to display as offset from the source of the buffer */
 	bResult = 1;
 
