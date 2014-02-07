Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaBGM3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:29:50 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53826 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbaBGM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:29:44 -0500
Date: Fri, 7 Feb 2014 17:59:36 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Armin Schindler <mac@melware.de>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 10/26] drivers: isdn: Move prototype declaration to
 appropriate header file diva.h
Message-ID: <808e9b029b3ec11a17cb1d4a49e784f71e433875.1390408516.git.rashika.kheria@gmail.com>
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

Move prototype declarations of functions to header file
hardware/eicon/diva.h because they are used by more than one file. Also,
include appropriate header files while adding the prototypes.

This eliminates the following warnings in hardware/eicon/diva.c:
drivers/isdn/hardware/eicon/diva.c:516:13: warning: no previous prototype for ‘diva_os_irq_wrapper’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/diva.c:570:6: warning: no previous prototype for ‘diva_xdi_display_adapter_features’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/diva.c:606:6: warning: no previous prototype for ‘diva_add_slave_adapter’ [-Wmissing-prototypes]
drivers/isdn/hardware/eicon/diva.c:615:5: warning: no previous prototype for ‘diva_card_read_xlog’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/isdn/hardware/eicon/diva.h      |    6 ++++++
 drivers/isdn/hardware/eicon/divasmain.c |    3 +--
 drivers/isdn/hardware/eicon/os_4bri.c   |    5 +----
 drivers/isdn/hardware/eicon/os_bri.c    |    3 +--
 drivers/isdn/hardware/eicon/os_pri.c    |    3 +--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/diva.h b/drivers/isdn/hardware/eicon/diva.h
index e979085..b2c070c 100644
--- a/drivers/isdn/hardware/eicon/diva.h
+++ b/drivers/isdn/hardware/eicon/diva.h
@@ -3,6 +3,8 @@
 #ifndef __DIVA_XDI_OS_PART_H__
 #define __DIVA_XDI_OS_PART_H__
 
+#include "xdi_msg.h"
+#include "xdi_adapter.h"
 
 int divasa_xdi_driver_entry(void);
 void divasa_xdi_driver_unload(void);
@@ -27,5 +29,9 @@ void *diva_xdi_open_adapter(void *os_handle, const void __user *src,
 
 void diva_xdi_close_adapter(void *adapter, void *os_handle);
 
+irqreturn_t diva_os_irq_wrapper(int irq, void *context);
+void diva_xdi_display_adapter_features(int card);
+void diva_add_slave_adapter(diva_os_xdi_adapter_t *a);
+int diva_card_read_xlog(diva_os_xdi_adapter_t *a);
 
 #endif
diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index 83a788f..6b15670 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -27,7 +27,6 @@
 #include "pc.h"
 #include "di_defs.h"
 #include "divasync.h"
-#include "diva.h"
 #include "di.h"
 #include "io.h"
 #include "xdi_msg.h"
@@ -35,6 +34,7 @@
 #include "xdi_vers.h"
 #include "diva_dma.h"
 #include "diva_pci.h"
+#include "diva.h"
 
 static char *main_revision = "$Revision: 1.55.4.6 $";
 
@@ -55,7 +55,6 @@ static char *DRIVERLNAME = "divas";
 static char *DEVNAME = "Divas";
 char *DRIVERRELEASE_DIVAS = "2.0";
 
-extern irqreturn_t diva_os_irq_wrapper(int irq, void *context);
 extern int create_divas_proc(void);
 extern void remove_divas_proc(void);
 
diff --git a/drivers/isdn/hardware/eicon/os_4bri.c b/drivers/isdn/hardware/eicon/os_4bri.c
index 1891246..54f7033 100644
--- a/drivers/isdn/hardware/eicon/os_4bri.c
+++ b/drivers/isdn/hardware/eicon/os_4bri.c
@@ -17,6 +17,7 @@
 #include "mi_pc.h"
 #include "dsrv4bri.h"
 #include "helpers.h"
+#include "diva.h"
 
 static void *diva_xdiLoadFileFile = NULL;
 static dword diva_xdiLoadFileLength = 0;
@@ -26,14 +27,10 @@ static dword diva_xdiLoadFileLength = 0;
 */
 extern void prepare_qBri_functions(PISDN_ADAPTER IoAdapter);
 extern void prepare_qBri2_functions(PISDN_ADAPTER IoAdapter);
-extern void diva_xdi_display_adapter_features(int card);
-extern void diva_add_slave_adapter(diva_os_xdi_adapter_t *a);
 
 extern int qBri_FPGA_download(PISDN_ADAPTER IoAdapter);
 extern void start_qBri_hardware(PISDN_ADAPTER IoAdapter);
 
-extern int diva_card_read_xlog(diva_os_xdi_adapter_t *a);
-
 /*
 **  LOCALS
 */
diff --git a/drivers/isdn/hardware/eicon/os_bri.c b/drivers/isdn/hardware/eicon/os_bri.c
index 20f2653..c7a45e6 100644
--- a/drivers/isdn/hardware/eicon/os_bri.c
+++ b/drivers/isdn/hardware/eicon/os_bri.c
@@ -17,13 +17,12 @@
 #include "mi_pc.h"
 #include "pc_maint.h"
 #include "dsrv_bri.h"
+#include "diva.h"
 
 /*
 **  IMPORTS
 */
 extern void prepare_maestra_functions(PISDN_ADAPTER IoAdapter);
-extern void diva_xdi_display_adapter_features(int card);
-extern int diva_card_read_xlog(diva_os_xdi_adapter_t *a);
 
 /*
 **  LOCALS
diff --git a/drivers/isdn/hardware/eicon/os_pri.c b/drivers/isdn/hardware/eicon/os_pri.c
index da4957a..acc1de6 100644
--- a/drivers/isdn/hardware/eicon/os_pri.c
+++ b/drivers/isdn/hardware/eicon/os_pri.c
@@ -19,6 +19,7 @@
 #include "dsp_tst.h"
 #include "diva_dma.h"
 #include "dsrv_pri.h"
+#include "diva.h"
 
 /* --------------------------------------------------------------------------
    OS Dependent part of XDI driver for DIVA PRI Adapter
@@ -28,14 +29,12 @@
 
 #define DIVA_PRI_NO_PCI_BIOS_WORKAROUND 1
 
-extern int diva_card_read_xlog(diva_os_xdi_adapter_t *a);
 
 /*
 **  IMPORTS
 */
 extern void prepare_pri_functions(PISDN_ADAPTER IoAdapter);
 extern void prepare_pri2_functions(PISDN_ADAPTER IoAdapter);
-extern void diva_xdi_display_adapter_features(int card);
 
 static int diva_pri_cleanup_adapter(diva_os_xdi_adapter_t *a);
 static int diva_pri_cmd_card_proc(struct _diva_os_xdi_adapter *a,
-- 
1.7.9.5

