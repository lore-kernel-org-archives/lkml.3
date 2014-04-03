Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161100AbaDCAUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:20:05 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50374 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161049AbaDCAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:20:03 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH] driver: staging: wlan-ng: Removed unnecessary typedefs from hfa384x_usb.c
Date: Thu,  3 Apr 2014 02:19:57 +0200
Message-Id: <1396484397-32434-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary typedefs from hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5b8b094..4cfd074 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -745,14 +745,12 @@ static inline struct usbctlx_completor *init_rrid_completor(
 * Completor object:
 * Interprets the results of a synchronous RID-write
 ----------------------------------------------------------------*/
-typedef struct usbctlx_cmd_completor usbctlx_wrid_completor_t;
 #define init_wrid_completor  init_cmd_completor

 /*----------------------------------------------------------------
 * Completor object:
 * Interprets the results of a synchronous memory-write
 ----------------------------------------------------------------*/
-typedef struct usbctlx_cmd_completor usbctlx_wmem_completor_t;
 #define init_wmem_completor  init_cmd_completor

 /*----------------------------------------------------------------
@@ -766,11 +764,10 @@ struct usbctlx_rmem_completor {
 	void *data;
 	unsigned int len;
 };
-typedef struct usbctlx_rmem_completor usbctlx_rmem_completor_t;

 static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 {
-	usbctlx_rmem_completor_t *complete = (usbctlx_rmem_completor_t *) head;
+	struct usbctlx_rmem_completor *complete = (struct usbctlx_rmem_completor *) head;

 	pr_debug("rmemresp:len=%d\n", complete->rmemresp->frmlen);
 	memcpy(complete->data, complete->rmemresp->data, complete->len);
@@ -778,7 +775,7 @@ static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 }

 static inline struct usbctlx_completor *init_rmem_completor(
-						usbctlx_rmem_completor_t
+						struct usbctlx_rmem_completor
 							*completor,
 						hfa384x_usb_rmemresp_t
 							*rmemresp,
@@ -1566,7 +1563,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wrid_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		hfa384x_cmdresult_t wridresult;

 		result = hfa384x_usbctlx_complete_sync(hw,
@@ -1658,7 +1655,7 @@ hfa384x_dormem(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_rmem_completor_t completor;
+		struct usbctlx_rmem_completor completor;

 		result =
 		    hfa384x_usbctlx_complete_sync(hw, ctlx,
@@ -1748,7 +1745,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wmem_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		hfa384x_cmdresult_t wmemresult;

 		result = hfa384x_usbctlx_complete_sync(hw,
--
1.7.9.5

