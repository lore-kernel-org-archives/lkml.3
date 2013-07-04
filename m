Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab3GDMgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:36:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:18715 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3GDMgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:36:02 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <joe@perches.com>, <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH v2 3/5] staging: ozwpan: Remove old debug macro.
Date: Thu, 4 Jul 2013 13:35:29 +0100
Message-ID: <1372941331-9586-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372255013.2076.4.camel@joe-AO722>
References: <1372255013.2076.4.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/Kbuild          |    6 ++----
 drivers/staging/ozwpan/ozcdev.c        |    2 --
 drivers/staging/ozwpan/ozconfig.h      |   26 -----------------------
 drivers/staging/ozwpan/ozeltbuf.c      |    2 --
 drivers/staging/ozwpan/ozhcd.c         |    7 +------
 drivers/staging/ozwpan/ozmain.c        |    7 +++++--
 drivers/staging/ozwpan/ozpd.c          |    6 ++----
 drivers/staging/ozwpan/ozproto.c       |    4 ++--
 drivers/staging/ozwpan/oztrace.c       |   36 --------------------------------
 drivers/staging/ozwpan/oztrace.h       |   35 -------------------------------
 drivers/staging/ozwpan/ozurbparanoia.c |    5 +++--
 drivers/staging/ozwpan/ozusbsvc.c      |    4 ++--
 drivers/staging/ozwpan/ozusbsvc1.c     |    2 --
 13 files changed, 17 insertions(+), 125 deletions(-)
 delete mode 100644 drivers/staging/ozwpan/ozconfig.h
 delete mode 100644 drivers/staging/ozwpan/oztrace.c
 delete mode 100644 drivers/staging/ozwpan/oztrace.h

diff --git a/drivers/staging/ozwpan/Kbuild b/drivers/staging/ozwpan/Kbuild
index 1766a26..29529c1 100644
--- a/drivers/staging/ozwpan/Kbuild
+++ b/drivers/staging/ozwpan/Kbuild
@@ -2,6 +2,7 @@
 # Copyright (c) 2011 Ozmo Inc
 # Released under the GNU General Public License Version 2 (GPLv2).
 # -----------------------------------------------------------------------------
+
 obj-$(CONFIG_USB_WPAN_HCD) += ozwpan.o
 ozwpan-y := \
 	ozmain.o \
@@ -12,7 +13,4 @@ ozwpan-y := \
 	ozeltbuf.o \
 	ozproto.o \
 	ozcdev.o \
-	ozurbparanoia.o \
-	oztrace.o
-
-
+	ozurbparanoia.o
diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 87c3131..3e29760 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -11,10 +11,8 @@
 #include <linux/etherdevice.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
-#include "ozconfig.h"
 #include "ozdbg.h"
 #include "ozprotocol.h"
-#include "oztrace.h"
 #include "ozappif.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
diff --git a/drivers/staging/ozwpan/ozconfig.h b/drivers/staging/ozwpan/ozconfig.h
deleted file mode 100644
index 087c322..0000000
--- a/drivers/staging/ozwpan/ozconfig.h
+++ /dev/null
@@ -1,26 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * ---------------------------------------------------------------------------*/
-#ifndef _OZCONFIG_H
-#define _OZCONFIG_H
-
-/* #define WANT_TRACE */
-#ifdef WANT_TRACE
-#define WANT_VERBOSE_TRACE
-#endif /* #ifdef WANT_TRACE */
-/* #define WANT_URB_PARANOIA */
-
-/* #define WANT_PRE_2_6_39 */
-
-/* These defines determine what verbose trace is displayed. */
-#ifdef WANT_VERBOSE_TRACE
-/* #define WANT_TRACE_STREAM */
-/* #define WANT_TRACE_URB */
-/* #define WANT_TRACE_CTRL_DETAIL */
-#define WANT_TRACE_HUB
-/* #define WANT_TRACE_RX_FRAMES */
-/* #define WANT_TRACE_TX_FRAMES */
-#endif /* WANT_VERBOSE_TRACE */
-
-#endif /* _OZCONFIG_H */
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index bf280aa..5e98aeb 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -6,12 +6,10 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
-#include "ozconfig.h"
 #include "ozdbg.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
-#include "oztrace.h"
 
 /*------------------------------------------------------------------------------
  */
diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index fece2da..6b16bfc 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -32,9 +32,7 @@
 #include "linux/usb/hcd.h"
 #include <asm/unaligned.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
 #include "ozusbif.h"
-#include "oztrace.h"
 #include "ozurbparanoia.h"
 #include "ozhcd.h"
 /*------------------------------------------------------------------------------
@@ -797,7 +795,6 @@ void oz_hcd_get_desc_cnf(void *hport, u8 req_id, int status, const u8 *desc,
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
-#ifdef WANT_TRACE
 static void oz_display_conf_type(u8 t)
 {
 	switch (t) {
@@ -836,9 +833,7 @@ static void oz_display_conf_type(u8 t)
 		break;
 	}
 }
-#else
-#define oz_display_conf_type(__x)
-#endif /* WANT_TRACE */
+
 /*------------------------------------------------------------------------------
  * Context: softirq
  */
diff --git a/drivers/staging/ozwpan/ozmain.c b/drivers/staging/ozwpan/ozmain.c
index 51fe9e9..e26d6be 100644
--- a/drivers/staging/ozwpan/ozmain.c
+++ b/drivers/staging/ozwpan/ozmain.c
@@ -3,6 +3,7 @@
  * Released under the GNU General Public License Version 2 (GPLv2).
  * -----------------------------------------------------------------------------
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -10,11 +11,13 @@
 #include <linux/netdevice.h>
 #include <linux/errno.h>
 #include <linux/ieee80211.h>
-#include "ozconfig.h"
+#include "ozdbg.h"
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozcdev.h"
-#include "oztrace.h"
+
+unsigned int oz_dbg_mask = OZ_DEFAULT_DBG_MASK;
+
 /*------------------------------------------------------------------------------
  * The name of the 802.11 mac device. Empty string is the default value but a
  * value can be supplied as a parameter to the module. An empty string means
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 28adbb4..8a253ac 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -3,6 +3,7 @@
  * Released under the GNU General Public License Version 2 (GPLv2).
  * -----------------------------------------------------------------------------
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -10,17 +11,16 @@
 #include <linux/netdevice.h>
 #include <linux/errno.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "ozproto.h"
-#include "oztrace.h"
 #include "ozcdev.h"
 #include "ozusbsvc.h"
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
 #include <net/psnap.h>
+
 /*------------------------------------------------------------------------------
  */
 #define OZ_MAX_TX_POOL_SIZE	6
@@ -121,7 +121,6 @@ static void oz_def_app_rx(struct oz_pd *pd, struct oz_elt *elt)
 void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 {
 	pd->state = state;
-#ifdef WANT_TRACE
 	switch (state) {
 	case OZ_PD_S_IDLE:
 		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_IDLE\n");
@@ -136,7 +135,6 @@ void oz_pd_set_state(struct oz_pd *pd, unsigned state)
 		oz_pd_dbg(pd, ON, "PD State: OZ_PD_S_SLEEP\n");
 		break;
 	}
-#endif /* WANT_TRACE */
 }
 /*------------------------------------------------------------------------------
  * Context: softirq or process
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 494236e..760761d 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -3,6 +3,7 @@
  * Released under the GNU General Public License Version 2 (GPLv2).
  * -----------------------------------------------------------------------------
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -11,13 +12,12 @@
 #include <linux/errno.h>
 #include <linux/ieee80211.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozusbsvc.h"
-#include "oztrace.h"
+
 #include "ozappif.h"
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/ozwpan/oztrace.c b/drivers/staging/ozwpan/oztrace.c
deleted file mode 100644
index 353ead2..0000000
--- a/drivers/staging/ozwpan/oztrace.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * -----------------------------------------------------------------------------
- */
-#include "ozconfig.h"
-#include "oztrace.h"
-
-#ifdef WANT_VERBOSE_TRACE
-unsigned long trace_flags =
-	0
-#ifdef WANT_TRACE_STREAM
-	| OZ_TRACE_STREAM
-#endif /* WANT_TRACE_STREAM */
-#ifdef WANT_TRACE_URB
-	| OZ_TRACE_URB
-#endif /* WANT_TRACE_URB */
-
-#ifdef WANT_TRACE_CTRL_DETAIL
-	| OZ_TRACE_CTRL_DETAIL
-#endif /* WANT_TRACE_CTRL_DETAIL */
-
-#ifdef WANT_TRACE_HUB
-	| OZ_TRACE_HUB
-#endif /* WANT_TRACE_HUB */
-
-#ifdef WANT_TRACE_RX_FRAMES
-	| OZ_TRACE_RX_FRAMES
-#endif /* WANT_TRACE_RX_FRAMES */
-
-#ifdef WANT_TRACE_TX_FRAMES
-	| OZ_TRACE_TX_FRAMES
-#endif /* WANT_TRACE_TX_FRAMES */
-	;
-#endif /* WANT_VERBOSE_TRACE */
-
diff --git a/drivers/staging/ozwpan/oztrace.h b/drivers/staging/ozwpan/oztrace.h
deleted file mode 100644
index 8293b24..0000000
--- a/drivers/staging/ozwpan/oztrace.h
+++ /dev/null
@@ -1,35 +0,0 @@
-/* -----------------------------------------------------------------------------
- * Copyright (c) 2011 Ozmo Inc
- * Released under the GNU General Public License Version 2 (GPLv2).
- * -----------------------------------------------------------------------------
- */
-#ifndef _OZTRACE_H_
-#define _OZTRACE_H_
-#include "ozconfig.h"
-
-#define TRACE_PREFIX	KERN_ALERT "OZWPAN: "
-
-#ifdef WANT_TRACE
-#define oz_trace(...) printk(TRACE_PREFIX __VA_ARGS__)
-#ifdef WANT_VERBOSE_TRACE
-extern unsigned long trace_flags;
-#define oz_trace2(_flag, ...) \
-	do { if (trace_flags & _flag) printk(TRACE_PREFIX __VA_ARGS__); \
-	} while (0)
-#else
-#define oz_trace2(...)
-#endif /* #ifdef WANT_VERBOSE_TRACE */
-#else
-#define oz_trace(...)
-#define oz_trace2(...)
-#endif /* #ifdef WANT_TRACE */
-
-#define OZ_TRACE_STREAM		0x1
-#define OZ_TRACE_URB		0x2
-#define OZ_TRACE_CTRL_DETAIL	0x4
-#define OZ_TRACE_HUB		0x8
-#define OZ_TRACE_RX_FRAMES	0x10
-#define OZ_TRACE_TX_FRAMES	0x20
-
-#endif /* Sentry */
-
diff --git a/drivers/staging/ozwpan/ozurbparanoia.c b/drivers/staging/ozwpan/ozurbparanoia.c
index 387d9da..366584b 100644
--- a/drivers/staging/ozwpan/ozurbparanoia.c
+++ b/drivers/staging/ozwpan/ozurbparanoia.c
@@ -5,10 +5,11 @@
  */
 #include <linux/usb.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
+
 #ifdef WANT_URB_PARANOIA
+
 #include "ozurbparanoia.h"
-#include "oztrace.h"
+
 /*-----------------------------------------------------------------------------
  */
 #define OZ_MAX_URBS	1000
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index b4aebdb..816cac9 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -10,6 +10,7 @@
  * The implementation of this service uses ozhcd.c to implement a USB HCD.
  * -----------------------------------------------------------------------------
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
@@ -19,15 +20,14 @@
 #include <linux/input.h>
 #include <asm/unaligned.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozusbif.h"
 #include "ozhcd.h"
-#include "oztrace.h"
 #include "ozusbsvc.h"
+
 /*------------------------------------------------------------------------------
  * This is called once when the driver is loaded to initialise the USB service.
  * Context: process
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index ab2c641..50d21bf 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -14,14 +14,12 @@
 #include <linux/input.h>
 #include <asm/unaligned.h>
 #include "ozdbg.h"
-#include "ozconfig.h"
 #include "ozprotocol.h"
 #include "ozeltbuf.h"
 #include "ozpd.h"
 #include "ozproto.h"
 #include "ozusbif.h"
 #include "ozhcd.h"
-#include "oztrace.h"
 #include "ozusbsvc.h"
 /*------------------------------------------------------------------------------
  */
-- 
1.7.9.5

