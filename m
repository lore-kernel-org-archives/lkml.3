Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162537AbaDCHNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:13:30 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:32905 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162443AbaDCHNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:13:24 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 6/9] driver: staging: wlan-ng: Fixed Alignment to match open parenthesis
Date: Thu,  3 Apr 2014 09:13:19 +0200
Message-Id: <1396509199-3038-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed Alignment to match open parenthesis in hfa384x_usb.c

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |  113 +++++++++++++++++----------------
 1 file changed, 59 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 26289c6..4b11ed7 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -350,14 +350,14 @@ static int submit_rx_urb(hfa384x_t *hw, gfp_t memflags)
 
 	result = -ENOLINK;
 	if (!hw->wlandev->hwremoved &&
-			!test_bit(WORK_RX_HALT, &hw->usb_flags)) {
+	    !test_bit(WORK_RX_HALT, &hw->usb_flags)) {
 		result = SUBMIT_URB(&hw->rx_urb, memflags);
 
 		/* Check whether we need to reset the RX pipe */
 		if (result == -EPIPE) {
 			netdev_warn(hw->wlandev->netdev,
-			       "%s rx pipe stalled: requesting reset\n",
-			       hw->wlandev->netdev->name);
+				    "%s rx pipe stalled: requesting reset\n",
+				    hw->wlandev->netdev->name);
 			if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 				schedule_work(&hw->usb_work);
 		}
@@ -406,8 +406,8 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 			/* Test whether we need to reset the TX pipe */
 			if (result == -EPIPE) {
 				netdev_warn(hw->wlandev->netdev,
-				       "%s tx pipe stalled: requesting reset\n",
-				       netdev->name);
+					    "%s tx pipe stalled: requesting reset\n",
+					    netdev->name);
 				set_bit(WORK_TX_HALT, &hw->usb_flags);
 				schedule_work(&hw->usb_work);
 			} else if (result == 0) {
@@ -455,11 +455,11 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		ret = usb_clear_halt(hw->usb, hw->endp_in);
 		if (ret != 0) {
 			netdev_err(hw->wlandev->netdev,
-			       "Failed to clear rx pipe for %s: err=%d\n",
-			       netdev->name, ret);
+				   "Failed to clear rx pipe for %s: err=%d\n",
+				   netdev->name, ret);
 		} else {
 			netdev_info(hw->wlandev->netdev, "%s rx pipe reset complete.\n",
-			       netdev->name);
+				    netdev->name);
 			clear_bit(WORK_RX_HALT, &hw->usb_flags);
 			set_bit(WORK_RX_RESUME, &hw->usb_flags);
 		}
@@ -472,7 +472,8 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		ret = submit_rx_urb(hw, GFP_KERNEL);
 		if (ret != 0) {
 			netdev_err(hw->wlandev->netdev,
-			       "Failed to resume %s rx pipe.\n", netdev->name);
+				   "Failed to resume %s rx pipe.\n",
+				   netdev->name);
 		} else {
 			clear_bit(WORK_RX_RESUME, &hw->usb_flags);
 		}
@@ -486,11 +487,11 @@ static void hfa384x_usb_defer(struct work_struct *data)
 		ret = usb_clear_halt(hw->usb, hw->endp_out);
 		if (ret != 0) {
 			netdev_err(hw->wlandev->netdev,
-			       "Failed to clear tx pipe for %s: err=%d\n",
-			       netdev->name, ret);
+				   "Failed to clear tx pipe for %s: err=%d\n",
+				   netdev->name, ret);
 		} else {
 			netdev_info(hw->wlandev->netdev, "%s tx pipe reset complete.\n",
-			       netdev->name);
+				    netdev->name);
 			clear_bit(WORK_TX_HALT, &hw->usb_flags);
 			set_bit(WORK_TX_RESUME, &hw->usb_flags);
 
@@ -1207,7 +1208,7 @@ int hfa384x_corereset(hfa384x_t *hw, int holdtime, int settletime, int genesis)
 	result = usb_reset_device(hw->usb);
 	if (result < 0) {
 		netdev_err(hw->wlandev->netdev, "usb_reset_device() failed, result=%d.\n",
-		       result);
+			   result);
 	}
 
 	return result;
@@ -1307,7 +1308,7 @@ cleanup:
 			result = completor->complete(completor);
 		} else {
 			netdev_warn(hw->wlandev->netdev, "CTLX[%d] error: state(%s)\n",
-			       le16_to_cpu(ctlx->outbuf.type),
+				    le16_to_cpu(ctlx->outbuf.type),
 			       ctlxstr(ctlx->state));
 			result = -EIO;
 		}
@@ -2052,7 +2053,7 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 		burnhi = HFA384x_ADDR_CMD_MKPAGE(burndaddr);
 
 		netdev_info(hw->wlandev->netdev, "Writing %d bytes to flash @0x%06x\n",
-		       burnlen, burndaddr);
+			    burnlen, burndaddr);
 
 		/* Set the download mode */
 		result = hfa384x_cmd_download(hw, HFA384x_PROGMODE_NV,
@@ -2091,8 +2092,8 @@ int hfa384x_drvr_flashdl_write(hfa384x_t *hw, u32 daddr, void *buf, u32 len)
 					      0, 0, 0);
 		if (result) {
 			netdev_err(hw->wlandev->netdev,
-			       "download(NVWRITE,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
-			       burnlo, burnhi, burnlen, result);
+				   "download(NVWRITE,lo=%x,hi=%x,len=%x) cmd failed, result=%d. Aborting d/l\n",
+				   burnlo, burnhi, burnlen, result);
 			goto exit_proc;
 		}
 
@@ -2275,7 +2276,7 @@ int hfa384x_drvr_ramdl_enable(hfa384x_t *hw, u32 exeaddr)
 	for (i = 0; i < HFA384x_PORTID_MAX; i++) {
 		if (hw->port_enabled[i]) {
 			netdev_err(hw->wlandev->netdev,
-			       "Can't download with a macport enabled.\n");
+				   "Can't download with a macport enabled.\n");
 			return -EINVAL;
 		}
 	}
@@ -2446,7 +2447,8 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 
 		if (result) {
 			netdev_warn(hw->wlandev->netdev,
-			       "Read from index %zd failed, continuing\n", i);
+				    "Read from index %zd failed, continuing\n",
+				    i);
 			continue;
 		}
 
@@ -2466,7 +2468,7 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 			/* Test the code */
 			if (!hfa384x_isgood_pdrcode(pdrcode)) {
 				netdev_err(hw->wlandev->netdev, "pdrcode invalid=%d\n",
-				       pdrcode);
+					   pdrcode);
 				pdaok = 0;
 				break;
 			}
@@ -2482,13 +2484,13 @@ int hfa384x_drvr_readpda(hfa384x_t *hw, void *buf, unsigned int len)
 		}
 		if (pdaok) {
 			netdev_info(hw->wlandev->netdev,
-			       "PDA Read from 0x%08x in %s space.\n",
-			       pdaloc[i].cardaddr,
-			       pdaloc[i].auxctl == 0 ? "EXTDS" :
-			       pdaloc[i].auxctl == 1 ? "NV" :
-			       pdaloc[i].auxctl == 2 ? "PHY" :
-			       pdaloc[i].auxctl == 3 ? "ICSRAM" :
-			       "<bogus auxctl>");
+				    "PDA Read from 0x%08x in %s space.\n",
+				    pdaloc[i].cardaddr,
+				    pdaloc[i].auxctl == 0 ? "EXTDS" :
+				    pdaloc[i].auxctl == 1 ? "NV" :
+				    pdaloc[i].auxctl == 2 ? "PHY" :
+				    pdaloc[i].auxctl == 3 ? "ICSRAM" :
+				    "<bogus auxctl>");
 			break;
 		}
 	}
@@ -2583,7 +2585,8 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	result = submit_rx_urb(hw, GFP_KERNEL);
 	if (result != 0) {
 		netdev_err(hw->wlandev->netdev,
-		       "Fatal, failed to submit RX URB, result=%d\n", result);
+			   "Fatal, failed to submit RX URB, result=%d\n",
+			   result);
 		goto done;
 	}
 
@@ -2603,8 +2606,8 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 	if (result1 != 0) {
 		if (result2 != 0) {
 			netdev_err(hw->wlandev->netdev,
-				"cmd_initialize() failed on two attempts, results %d and %d\n",
-				result1, result2);
+				   "cmd_initialize() failed on two attempts, results %d and %d\n",
+				   result1, result2);
 			usb_kill_urb(&hw->rx_urb);
 			goto done;
 		} else {
@@ -2614,9 +2617,9 @@ int hfa384x_drvr_start(hfa384x_t *hw)
 		}
 	} else if (result2 != 0) {
 		netdev_warn(hw->wlandev->netdev, "First cmd_initialize() succeeded, but second attempt failed (result=%d)\n",
-			result2);
+			    result2);
 		netdev_warn(hw->wlandev->netdev,
-		       "Most likely the card will be functional\n");
+			    "Most likely the card will be functional\n");
 		goto done;
 	}
 
@@ -3008,7 +3011,8 @@ static void unlocked_usbctlx_complete(hfa384x_t *hw, hfa384x_usbctlx_t *ctlx)
 
 	default:
 		netdev_err(hw->wlandev->netdev, "CTLX[%d] not in a terminating state(%s)\n",
-		       le16_to_cpu(ctlx->outbuf.type), ctlxstr(ctlx->state));
+			   le16_to_cpu(ctlx->outbuf.type),
+			   ctlxstr(ctlx->state));
 		break;
 	}			/* switch */
 }
@@ -3090,8 +3094,8 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 			 * and schedule a reset ...
 			 */
 			netdev_warn(hw->wlandev->netdev,
-			       "%s tx pipe stalled: requesting reset\n",
-			       hw->wlandev->netdev->name);
+				    "%s tx pipe stalled: requesting reset\n",
+				    hw->wlandev->netdev->name);
 			list_move(&head->list, &hw->ctlxq.pending);
 			set_bit(WORK_TX_HALT, &hw->usb_flags);
 			schedule_work(&hw->usb_work);
@@ -3100,12 +3104,12 @@ static void hfa384x_usbctlxq_run(hfa384x_t *hw)
 
 		if (result == -ESHUTDOWN) {
 			netdev_warn(hw->wlandev->netdev, "%s urb shutdown!\n",
-			       hw->wlandev->netdev->name);
+				    hw->wlandev->netdev->name);
 			break;
 		}
 
 		netdev_err(hw->wlandev->netdev, "Failed to submit CTLX[%d]: error=%d\n",
-		       le16_to_cpu(head->outbuf.type), result);
+			   le16_to_cpu(head->outbuf.type), result);
 		unlocked_usbctlx_complete(hw, head);
 	}			/* while */
 
@@ -3172,7 +3176,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 
 	case -EPIPE:
 		netdev_warn(hw->wlandev->netdev, "%s rx pipe stalled: requesting reset\n",
-		       wlandev->netdev->name);
+			    wlandev->netdev->name);
 		if (!test_and_set_bit(WORK_RX_HALT, &hw->usb_flags))
 			schedule_work(&hw->usb_work);
 		++(wlandev->linux_stats.rx_errors);
@@ -3223,8 +3227,8 @@ static void hfa384x_usbin_callback(struct urb *urb)
 
 		if (result != 0) {
 			netdev_err(hw->wlandev->netdev,
-			       "Fatal, failed to resubmit rx_urb. error=%d\n",
-			       result);
+				   "Fatal, failed to resubmit rx_urb. error=%d\n",
+				   result);
 		}
 	}
 
@@ -3359,9 +3363,9 @@ retry:
 		 */
 		if (ctlx->outbuf.type != intype) {
 			netdev_warn(hw->wlandev->netdev,
-			       "Expected IN[%d], received IN[%d] - ignored.\n",
-			       le16_to_cpu(ctlx->outbuf.type),
-			       le16_to_cpu(intype));
+				    "Expected IN[%d], received IN[%d] - ignored.\n",
+				    le16_to_cpu(ctlx->outbuf.type),
+				    le16_to_cpu(intype));
 			goto unlock;
 		}
 
@@ -3395,9 +3399,9 @@ retry:
 			 * Throw this CTLX away ...
 			 */
 			netdev_err(hw->wlandev->netdev,
-			       "Matched IN URB, CTLX[%d] in invalid state(%s). Discarded.\n",
-			       le16_to_cpu(ctlx->outbuf.type),
-			       ctlxstr(ctlx->state));
+				   "Matched IN URB, CTLX[%d] in invalid state(%s). Discarded.\n",
+				   le16_to_cpu(ctlx->outbuf.type),
+				   ctlxstr(ctlx->state));
 			if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0)
 				run_queue = 1;
 			break;
@@ -3532,7 +3536,8 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 
 	default:
 		netdev_warn(hw->wlandev->netdev, "Received frame on unsupported port=%d\n",
-		       HFA384x_RXSTATUS_MACPORT_GET(usbin->rxfrm.desc.status));
+			    HFA384x_RXSTATUS_MACPORT_GET(
+				    usbin->rxfrm.desc.status));
 		goto done;
 		break;
 	}
@@ -3594,8 +3599,8 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 	skb = dev_alloc_skb(skblen);
 	if (skb == NULL) {
 		netdev_err(hw->wlandev->netdev,
-		       "alloc_skb failed trying to allocate %d bytes\n",
-		       skblen);
+			   "alloc_skb failed trying to allocate %d bytes\n",
+			   skblen);
 		return;
 	}
 
@@ -3712,8 +3717,8 @@ static void hfa384x_usbout_callback(struct urb *urb)
 			{
 				hfa384x_t *hw = wlandev->priv;
 				netdev_warn(hw->wlandev->netdev,
-				       "%s tx pipe stalled: requesting reset\n",
-				       wlandev->netdev->name);
+					    "%s tx pipe stalled: requesting reset\n",
+					    wlandev->netdev->name);
 				if (!test_and_set_bit
 				    (WORK_TX_HALT, &hw->usb_flags))
 					schedule_work(&hw->usb_work);
@@ -3745,7 +3750,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
 
 		default:
 			netdev_info(wlandev->netdev, "unknown urb->status=%d\n",
-			       urb->status);
+				    urb->status);
 			++(wlandev->linux_stats.tx_errors);
 			break;
 		}		/* switch */
@@ -3839,7 +3844,7 @@ retry:
 		default:
 			/* This is NOT a valid CTLX "success" state! */
 			netdev_err(hw->wlandev->netdev,
-				"Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
+				   "Illegal CTLX[%d] success state(%s, %d) in OUT URB\n",
 				le16_to_cpu(ctlx->outbuf.type),
 				ctlxstr(ctlx->state), urb->status);
 			break;
@@ -3849,7 +3854,7 @@ retry:
 		if ((urb->status == -EPIPE) &&
 		    !test_and_set_bit(WORK_TX_HALT, &hw->usb_flags)) {
 			netdev_warn(hw->wlandev->netdev,
-			       "%s tx pipe stalled: requesting reset\n",
+				    "%s tx pipe stalled: requesting reset\n",
 			       hw->wlandev->netdev->name);
 			schedule_work(&hw->usb_work);
 		}
-- 
1.7.9.5

