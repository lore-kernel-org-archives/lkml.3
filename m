Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaBGMtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:49:09 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:34798 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaBGMtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:49:06 -0500
Date: Fri, 7 Feb 2014 18:18:58 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 25/26] drivers: isdn: Move prototype declaration to header
 file dadapter.h
Message-ID: <fa09a161cd57206bfac7f3ea2817fb6d535c727c.1390408520.git.rashika.kheria@gmail.com>
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
hardware/eicon/dadapter.h because they are used by more than one file.

This eliminates the following warning in hardware/eicon/dadapter.c:
drivers/isdn/hardware/eicon/dadapter.c:361:22: warning: no previous prototype for ‘DIVA_DIDD_Read’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/capifunc.c  |    3 +--
 drivers/isdn/hardware/eicon/dadapter.h  |    1 +
 drivers/isdn/hardware/eicon/diddfunc.c  |    1 -
 drivers/isdn/hardware/eicon/diva_didd.c |    2 --
 drivers/isdn/hardware/eicon/divasfunc.c |    3 +--
 drivers/isdn/hardware/eicon/idifunc.c   |    3 +--
 drivers/isdn/hardware/eicon/mntfunc.c   |    3 +--
 7 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/capifunc.c b/drivers/isdn/hardware/eicon/capifunc.c
index 639d70f..3bcb602 100644
--- a/drivers/isdn/hardware/eicon/capifunc.c
+++ b/drivers/isdn/hardware/eicon/capifunc.c
@@ -18,6 +18,7 @@
 #include "divacapi.h"
 #include "divasync.h"
 #include "capifunc.h"
+#include "dadapter.h"
 
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
@@ -55,8 +56,6 @@ static char *diva_procinfo(struct capi_ctr *);
 static u16 diva_send_message(struct capi_ctr *,
 			     diva_os_message_buffer_s *);
 
-extern void DIVA_DIDD_Read(DESCRIPTOR *, int);
-
 /*
  * debug
  */
diff --git a/drivers/isdn/hardware/eicon/dadapter.h b/drivers/isdn/hardware/eicon/dadapter.h
index 5540f46..f6cdebf 100644
--- a/drivers/isdn/hardware/eicon/dadapter.h
+++ b/drivers/isdn/hardware/eicon/dadapter.h
@@ -28,6 +28,7 @@
 
 void diva_didd_load_time_init(void);
 void diva_didd_load_time_finit(void);
+void IDI_CALL_LINK_T DIVA_DIDD_Read(void IDI_CALL_ENTITY_T *buffer, int length);
 
 #define NEW_MAX_DESCRIPTORS     64
 
diff --git a/drivers/isdn/hardware/eicon/diddfunc.c b/drivers/isdn/hardware/eicon/diddfunc.c
index b0b23ed..a8a229f 100644
--- a/drivers/isdn/hardware/eicon/diddfunc.c
+++ b/drivers/isdn/hardware/eicon/diddfunc.c
@@ -20,7 +20,6 @@
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
 
-extern void DIVA_DIDD_Read(void *, int);
 extern char *DRIVERRELEASE_DIDD;
 static dword notify_handle;
 static DESCRIPTOR _DAdapter;
diff --git a/drivers/isdn/hardware/eicon/diva_didd.c b/drivers/isdn/hardware/eicon/diva_didd.c
index 56d32a7..b8e525f 100644
--- a/drivers/isdn/hardware/eicon/diva_didd.c
+++ b/drivers/isdn/hardware/eicon/diva_didd.c
@@ -39,8 +39,6 @@ MODULE_LICENSE("GPL");
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
-extern void DIVA_DIDD_Read(void *, int);
-
 static struct proc_dir_entry *proc_didd;
 struct proc_dir_entry *proc_net_eicon = NULL;
 
diff --git a/drivers/isdn/hardware/eicon/divasfunc.c b/drivers/isdn/hardware/eicon/divasfunc.c
index 4be5f88..a5d44d0 100644
--- a/drivers/isdn/hardware/eicon/divasfunc.c
+++ b/drivers/isdn/hardware/eicon/divasfunc.c
@@ -17,14 +17,13 @@
 #include "divasync.h"
 #include "diva.h"
 #include "xdi_vers.h"
+#include "dadapter.h"
 
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
 static int debugmask;
 
-extern void DIVA_DIDD_Read(void *, int);
-
 extern PISDN_ADAPTER IoAdapters[MAX_ADAPTER];
 
 extern char *DRIVERRELEASE_DIVAS;
diff --git a/drivers/isdn/hardware/eicon/idifunc.c b/drivers/isdn/hardware/eicon/idifunc.c
index bacab74..dc79095 100644
--- a/drivers/isdn/hardware/eicon/idifunc.c
+++ b/drivers/isdn/hardware/eicon/idifunc.c
@@ -15,14 +15,13 @@
 #include "divasync.h"
 #include "um_xdi.h"
 #include "um_idi.h"
+#include "dadapter.h"
 
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
 extern char *DRIVERRELEASE_IDI;
 
-extern void DIVA_DIDD_Read(void *, int);
-
 static dword notify_handle;
 static DESCRIPTOR DAdapter;
 static DESCRIPTOR MAdapter;
diff --git a/drivers/isdn/hardware/eicon/mntfunc.c b/drivers/isdn/hardware/eicon/mntfunc.c
index e304a1d..be47431 100644
--- a/drivers/isdn/hardware/eicon/mntfunc.c
+++ b/drivers/isdn/hardware/eicon/mntfunc.c
@@ -15,14 +15,13 @@
 #include "di_defs.h"
 #include "divasync.h"
 #include "debug_if.h"
+#include "dadapter.h"
 
 extern char *DRIVERRELEASE_MNT;
 
 #define DBG_MINIMUM  (DL_LOG + DL_FTL + DL_ERR)
 #define DBG_DEFAULT  (DBG_MINIMUM + DL_XLOG + DL_REG)
 
-extern void DIVA_DIDD_Read(void *, int);
-
 static dword notify_handle;
 static DESCRIPTOR DAdapter;
 static DESCRIPTOR MAdapter;
-- 
1.7.9.5

