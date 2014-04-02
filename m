Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbaDBXcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:32:15 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60929 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbaDBXcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:32:14 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH] driver: staging: wlan-ng: Fixed Breaking long lines and strings style rule
Date: Thu,  3 Apr 2014 01:32:08 +0200
Message-Id: <1396481528-32144-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style rule "Breaking long lines and strings" for hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   52 ++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 5b8b094..4c828c2 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -642,9 +642,9 @@ usbctlx_get_status(const hfa384x_usb_cmdresp_t *cmdresp,
 	result->resp1 = le16_to_cpu(cmdresp->resp1);
 	result->resp2 = le16_to_cpu(cmdresp->resp2);
 
-	pr_debug("cmdresult:status=0x%04x "
-		 "resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
-		 result->status, result->resp0, result->resp1, result->resp2);
+	pr_debug("cmdresult:status=0x%04x resp0=0x%04x resp1=0x%04x resp2=0x%04x\n",
+		 result->status, result->resp0,
+		 result->resp1, result->resp2);
 
 	return result->status & HFA384x_STATUS_RESULT;
 }
@@ -991,9 +991,7 @@ int hfa384x_cmd_initialize(hfa384x_t *hw)
 
 	result = hfa384x_docmd_wait(hw, &cmd);
 
-	pr_debug("cmdresp.init: "
-		 "status=0x%04x, resp0=0x%04x, "
-		 "resp1=0x%04x, resp2=0x%04x\n",
+	pr_debug("cmdresp.init: status=0x%04x, resp0=0x%04x, resp1=0x%04x, resp2=0x%04x\n",
 		 cmd.result.status,
 		 cmd.result.resp0, cmd.result.resp1, cmd.result.resp2);
 	if (result == 0) {
@@ -1381,9 +1379,8 @@ hfa384x_docmd(hfa384x_t *hw,
 
 	ctlx->outbufsize = sizeof(ctlx->outbuf.cmdreq);
 
-	pr_debug("cmdreq: cmd=0x%04x "
-		 "parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
-		 cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
+	pr_debug("cmdreq: cmd=0x%04x parm0=0x%04x parm1=0x%04x parm2=0x%04x\n",
+		 cmd->cmd, cmd->parm0, cmd->parm1, cmd->parm2);
 
 	ctlx->reapable = mode;
 	ctlx->cmdcb = cmdcb;
@@ -2018,7 +2015,8 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_FLASHENABLED)
 		return -EINVAL;
 
-	netdev_info(hw->wlandev->netdev, "Download %d bytes to flash @0x%06x\n", len, daddr);
+	netdev_info(hw->wlandev->netdev,
+		    "Download %d bytes to flash @0x%06x\n", len, daddr);
 
 	/* Convert to flat address for arithmetic */
 	/* NOTE: dlbuffer RID stores the address in AUX format */
@@ -2028,8 +2026,9 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		 hw->bufinfo.page, hw->bufinfo.offset, dlbufaddr);
 
 #if 0
-	netdev_warn(hw->wlandev->netdev, "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
-	       hw->bufinfo.len, hw->dltimeout);
+	netdev_warn(hw->wlandev->netdev,
+		    "dlbuf@0x%06lx len=%d to=%d\n", dlbufaddr,
+		    hw->bufinfo.len, hw->dltimeout);
 #endif
 	/* Calculations to determine how many fills of the dlbuffer to do
 	 * and how many USB wmemreq's to do for each fill.  At this point
@@ -2062,9 +2061,9 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		result = hfa384x_cmd_download(hw, HFA384x_PROGMODE_NV,
 					      burnlo, burnhi, burnlen);
 		if (result) {
-			netdev_err(hw->wlandev->netdev, "download(NV,lo=%x,hi=%x,len=%x) "
-			       "cmd failed, result=%d. Aborting d/l\n",
-			       burnlo, burnhi, burnlen, result);
+			netdev_err(hw->wlandev->netdev,
+				   "download(NV,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
+					burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
 
@@ -2095,8 +2094,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      0, 0, 0);
 		if (result) {
 			netdev_err(hw->wlandev->netdev,
-			       "download(NVWRITE,lo=%x,hi=%x,len=%x) "
-			       "cmd failed, result=%d. Aborting d/l\n",
+			       "download(NVWRITE,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
 			       burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
@@ -2352,7 +2350,8 @@ int hfa384x_drvr_ramdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 	if (hw->dlstate != HFA384x_DLSTATE_RAMENABLED)
 		return -EINVAL;
 
-	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n", len, daddr);
+	netdev_info(hw->wlandev->netdev, "Writing %d bytes to ram @0x%06x\n",
+		    len, daddr);
 
 	/* How many dowmem calls?  */
 	nwrites = len / HFA384x_USB_RWMEM_MAXLEN;
@@ -2462,7 +2461,8 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			pdrcode = le16_to_cpu(pda[currpdr + 1]);
 			/* Test the record length */
 			if (pdrlen > HFA384x_PDR_LEN_MAX || pdrlen == 0) {
-				netdev_err(hw->wlandev->netdev, "pdrlen invalid=%d\n", pdrlen);
+				netdev_err(hw->wlandev->netdev,
+					   "pdrlen invalid=%d\n", pdrlen);
 				pdaok = 0;
 				break;
 			}
@@ -2784,7 +2784,8 @@ int hfa384x_drvr_txframe(hfa384x_t *hw, struct sk_buff *skb,
 	result = 1;
 	ret = submit_tx_urb(hw, &hw->tx_urb, GFP_ATOMIC);
 	if (ret != 0) {
-		netdev_err(hw->wlandev->netdev, "submit_tx_urb() failed, error=%d\n", ret);
+		netdev_err(hw->wlandev->netdev,
+			   "submit_tx_urb() failed, error=%d\n", ret);
 		result = 3;
 	}
 
@@ -3397,8 +3398,7 @@ retry:
 			 * Throw this CTLX away ...
 			 */
 			netdev_err(hw->wlandev->netdev,
-			       "Matched IN URB, CTLX[%d] in invalid state(%s)."
-			       " Discarded.\n",
+			       "Matched IN URB, CTLX[%d] in invalid state(%s). Discarded.\n",
 			       le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state));
 			if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0)
@@ -4139,13 +4139,13 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 	default:
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
-			pr_debug("Encountered unknown PDR#=0x%04x, "
-				 "assuming it's ok.\n", pdrcode);
+			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
+				 pdrcode);
 			return 1;
 		} else {
 			/* bad code */
-			pr_debug("Encountered unknown PDR#=0x%04x, "
-				 "(>=0x1000), assuming it's bad.\n", pdrcode);
+			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+				 pdrcode);
 			return 0;
 		}
 		break;
-- 
1.7.9.5

