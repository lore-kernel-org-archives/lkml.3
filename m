Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162470AbaDCHMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:12:09 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:42759 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162368AbaDCHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:12:04 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 2/9] driver: staging: wlan-ng: Removed unnecessary typedefs from hfa384x_usb.c
Date: Thu,  3 Apr 2014 09:11:59 +0200
Message-Id: <1396509119-2894-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary typedefs from hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   38 ++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 4c828c2..2a44c79 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -643,8 +643,8 @@ usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
 	result->resp2 = le16_to_cpu(cmdresp->resp2);
 
 	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
-			result->status, result->resp0,
-			result->resp1, result->resp2);
+		 result->status, result->resp0,
+		 result->resp1, result->resp2);
 
 	return result->status & HFA384x_STATUS_RESULT;
 }
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
@@ -766,11 +764,11 @@ struct usbctlx_rmem_completor {
 	void *data;
 	unsigned int len;
 };
-typedef struct usbctlx_rmem_completor usbctlx_rmem_completor_t;
 
 static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 {
-	usbctlx_rmem_completor_t *complete = (usbctlx_rmem_completor_t *) head;
+	struct usbctlx_rmem_completor *complete =
+		(struct usbctlx_rmem_completor *)head;
 
 	pr_debug("rmemresp:len=%d\n", complete->rmemresp->frmlen);
 	memcpy(complete->data, complete->rmemresp->data, complete->len);
@@ -778,7 +776,7 @@ static int usbctlx_rmem_completor_fn(struct usbctlx_completor *head)
 }
 
 static inline struct usbctlx_completor *init_rmem_completor(
-						usbctlx_rmem_completor_t
+						struct usbctlx_rmem_completor
 							*completor,
 						hfa384x_usb_rmemresp_t
 							*rmemresp,
@@ -1380,7 +1378,7 @@ hfa384x_docmd(hfa384x_t *hw,
 	ctlx->outbufsize = sizeof(ctlx->outbuf.cmdreq);
 
 	pr_debug("cmdreq: cmd=0x%04x parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
-			cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
+		 cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
 
 	ctlx->reapable = mode;
 	ctlx->cmdcb = cmdcb;
@@ -1563,7 +1561,7 @@ hfa384x_dowrid(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wrid_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		hfa384x_cmdresult_t wridresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
@@ -1655,7 +1653,7 @@ hfa384x_dormem(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_rmem_completor_t completor;
+		struct usbctlx_rmem_completor completor;
 
 		result =
 		    hfa384x_usbctlx_complete_sync(hw, ctlx,
@@ -1745,7 +1743,7 @@ hfa384x_dowmem(hfa384x_t *hw,
 	if (result != 0) {
 		kfree(ctlx);
 	} else if (mode == DOWAIT) {
-		usbctlx_wmem_completor_t completor;
+		struct usbctlx_cmd_completor completor;
 		hfa384x_cmdresult_t wmemresult;
 
 		result = hfa384x_usbctlx_complete_sync(hw,
@@ -2016,7 +2014,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		return -EINVAL;
 
 	netdev_info(hw->wlandev->netdev,
-			"Download %d bytes to flash @0x%06x\n", len, daddr);
+		    "Download %d bytes to flash @0x%06x\n", len, daddr);
 
 	/* Convert to flat address for arithmetic */
 	/* NOTE: dlbuffer RID stores the address in AUX format */
@@ -2027,8 +2025,8 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 
 #if 0
 	netdev_warn(hw->wlandev->netdev,
-			"dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
-			hw->bufinfo.len, hw->dltimeout);
+		    "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
+		    hw->bufinfo.len, hw->dltimeout);
 #endif
 	/* Calculations to determine how many fills of the dlbuffer to do
 	 * and how many USB wmemreq's to do for each fill.  At this point
@@ -2062,7 +2060,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      burnlo, burnhi, burnlen);
 		if (result) {
 			netdev_err(hw->wlandev->netdev,
-					"download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
+				   "download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
 					burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
@@ -2351,7 +2349,7 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		return -EINVAL;
 
 	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n",
-			len, daddr);
+		    len, daddr);
 
 	/* How many dowmem calls?  */
 	nwrites = len / HFA384x_USB_RWMEM_MAXLEN;
@@ -2462,7 +2460,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			/* Test the record length */
 			if (pdrlen > HFA384x_PDR_LEN_MAX || pdrlen == 0) {
 				netdev_err(hw->wlandev->netdev,
-						"pdrlen invalid=%d\n", pdrlen);
+					   "pdrlen invalid=%d\n", pdrlen);
 				pdaok = 0;
 				break;
 			}
@@ -2785,7 +2783,7 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	ret = submit_tx_urb(hw, &hw->tx_urb, GFP_ATOMIC);
 	if (ret != 0) {
 		netdev_err(hw->wlandev->netdev,
-				"submit_tx_urb() failed, error=%d\n", ret);
+			   "submit_tx_urb() failed, error=%d\n", ret);
 		result = 3;
 	}
 
@@ -4140,12 +4138,12 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
 			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
-					pdrcode);
+				 pdrcode);
 			return 1;
 		} else {
 			/* bad code */
 			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
-					pdrcode);
+				 pdrcode);
 			return 0;
 		}
 		break;
-- 
1.7.9.5

