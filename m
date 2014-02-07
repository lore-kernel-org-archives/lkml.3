Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaBGMYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:24:19 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39554 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbaBGMYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:24:13 -0500
Date: Fri, 7 Feb 2014 17:54:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 05/26] drivers: isdn: Move prototype declarations to header
 file capifunc.h from message.c
Message-ID: <1f531b30ed44af6d6c8c65e6b16dbfa204c48d9e.1390408514.git.rashika.kheria@gmail.com>
References: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3cb4d7892ba5a0c0936b3a1e2c9c991a6dbc3229.1390408513.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of functions to header file
hardware/eicon/capifunc.h because they are used by more than one file.

This eliminates the following warnings in hardware/eicon/capifunc.c:
drivers/isdn/hardware/eicon/capifunc.c:113:6: warning: no previous prototype for ‘MapController’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:188:7: warning: no previous prototype for ‘TransmitBufferSet’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:195:7: warning: no previous prototype for ‘TransmitBufferGet’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:203:6: warning: no previous prototype for ‘TransmitBufferFree’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:209:7: warning: no previous prototype for ‘ReceiveBufferGet’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:217:6: warning: no previous prototype for ‘api_remove_complete’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:225:6: warning: no previous prototype for ‘sendf’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/capifunc.c:1115:5: warning: no previous prototype for ‘fax_head_line_time’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/capifunc.h |    8 ++++++++
 drivers/isdn/hardware/eicon/message.c  |   12 +-----------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/capifunc.h b/drivers/isdn/hardware/eicon/capifunc.h
index e96c45b..fb7091e 100644
--- a/drivers/isdn/hardware/eicon/capifunc.h
+++ b/drivers/isdn/hardware/eicon/capifunc.h
@@ -36,5 +36,13 @@ typedef struct _diva_card {
  */
 int init_capifunc(void);
 void finit_capifunc(void);
+byte MapController(byte);
+void *TransmitBufferSet(APPL *appl, dword ref);
+void *TransmitBufferGet(APPL *appl, void *p);
+void TransmitBufferFree(APPL *appl, void *p);
+void *ReceiveBufferGet(APPL *appl, int Num);
+void api_remove_complete(void);
+void sendf(APPL *, word, dword, word, byte *, ...);
+int fax_head_line_time(char *buffer);
 
 #endif /* __CAPIFUNC_H__ */
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index a82e542..062cb7b 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -32,6 +32,7 @@
 #include "pc.h"
 #include "capi20.h"
 #include "divacapi.h"
+#include "capifunc.h"
 #include "mdm_msg.h"
 #include "divasync.h"
 
@@ -84,7 +85,6 @@ static void api_save_msg(API_PARSE *in, byte *format, API_SAVE *out);
 static void api_load_msg(API_SAVE *in, API_PARSE *out);
 
 word api_remove_start(void);
-void api_remove_complete(void);
 
 static void plci_remove(PLCI *);
 static void diva_get_extended_adapter_features(DIVA_CAPI_ADAPTER *a);
@@ -224,20 +224,10 @@ static void diva_free_dma_descriptor(PLCI *plci, int nr);
 /* external function prototypes                                     */
 /*------------------------------------------------------------------*/
 
-extern byte MapController(byte);
 extern byte UnMapController(byte);
 #define MapId(Id)(((Id) & 0xffffff00L) | MapController((byte)(Id)))
 #define UnMapId(Id)(((Id) & 0xffffff00L) | UnMapController((byte)(Id)))
 
-void sendf(APPL *, word, dword, word, byte *, ...);
-void *TransmitBufferSet(APPL *appl, dword ref);
-void *TransmitBufferGet(APPL *appl, void *p);
-void TransmitBufferFree(APPL *appl, void *p);
-void *ReceiveBufferGet(APPL *appl, int Num);
-
-int fax_head_line_time(char *buffer);
-
-
 /*------------------------------------------------------------------*/
 /* Global data definitions                                          */
 /*------------------------------------------------------------------*/
-- 
1.7.9.5

