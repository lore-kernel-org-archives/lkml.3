Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaBGMZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:25:27 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49976 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaBGMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:25:23 -0500
Date: Fri, 7 Feb 2014 17:55:17 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 06/26] drivers: isdn: Move prototype declarations to header
 file capifunc.h from capifunc.c and message.c
Message-ID: <a242d4be13086d396f9aff364021d096e4e966ba.1390408515.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declarations of function to header file
hardware/eicon/capifunc.h because they are used by more than one file.

Also, remove prototype declaration of the same function from
hardware/eicon/capifunc.c.

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/capifunc.c |    1 -
 drivers/isdn/hardware/eicon/capifunc.h |    1 +
 drivers/isdn/hardware/eicon/message.c  |    1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/capifunc.c b/drivers/isdn/hardware/eicon/capifunc.c
index 8991b0c..639d70f 100644
--- a/drivers/isdn/hardware/eicon/capifunc.c
+++ b/drivers/isdn/hardware/eicon/capifunc.c
@@ -28,7 +28,6 @@ byte max_appl = MAX_APPL;
 byte max_adapter = 0;
 static CAPI_MSG *mapped_msg = (CAPI_MSG *) NULL;
 
-byte UnMapController(byte);
 char DRIVERRELEASE_CAPI[32];
 
 extern void AutomaticLaw(DIVA_CAPI_ADAPTER *);
diff --git a/drivers/isdn/hardware/eicon/capifunc.h b/drivers/isdn/hardware/eicon/capifunc.h
index fb7091e..56dbde1 100644
--- a/drivers/isdn/hardware/eicon/capifunc.h
+++ b/drivers/isdn/hardware/eicon/capifunc.h
@@ -37,6 +37,7 @@ typedef struct _diva_card {
 int init_capifunc(void);
 void finit_capifunc(void);
 byte MapController(byte);
+byte UnMapController(byte);
 void *TransmitBufferSet(APPL *appl, dword ref);
 void *TransmitBufferGet(APPL *appl, void *p);
 void TransmitBufferFree(APPL *appl, void *p);
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 062cb7b..cd9fca1 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -224,7 +224,6 @@ static void diva_free_dma_descriptor(PLCI *plci, int nr);
 /* external function prototypes                                     */
 /*------------------------------------------------------------------*/
 
-extern byte UnMapController(byte);
 #define MapId(Id)(((Id) & 0xffffff00L) | MapController((byte)(Id)))
 #define UnMapId(Id)(((Id) & 0xffffff00L) | UnMapController((byte)(Id)))
 
-- 
1.7.9.5

