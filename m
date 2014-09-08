Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIHOiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:38:25 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56065 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289AbaIHOiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:38:24 -0400
X-Sasl-enc: k+34tBvFY6VRTvMQj1TJ2bJ9gxUqpR00QTB/cwcXRz/W 1410187103
From: Ilja Sidoroff <ilja.sidoroff@iki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ilja Sidoroff <ilja.sidoroff@iki.fi>
Subject: [PATCH v2] Staging: wlan-ng: Remove redundant break/goto statements in hfa384x_usb.c
Date: Mon,  8 Sep 2014 17:37:53 +0300
Message-Id: <1410187073-12576-1-git-send-email-ilja.sidoroff@iki.fi>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410184074.12560.6.camel@joe-AO725>
References: <1410184074.12560.6.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant goto or break statements in hfa384x_usb.c as found by checkpatch.pl

Signed-off-by: Ilja Sidoroff <ilja.sidoroff@iki.fi>
---
Changes in v2:
   * replaced goto with break and so got rid of a label

 drivers/staging/wlan-ng/hfa384x_usb.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 2f63e0c..cac55c6 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3474,7 +3474,7 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		/* If exclude and we receive an unencrypted, drop it */
 		if ((wlandev->hostwep & HOSTWEP_EXCLUDEUNENCRYPTED) &&
 		    !WLAN_GET_FC_ISWEP(fc)) {
-			goto done;
+			break;
 		}
 
 		data_len = le16_to_cpu(usbin->rxfrm.desc.data_len);
@@ -3528,11 +3528,9 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		netdev_warn(hw->wlandev->netdev, "Received frame on unsupported port=%d\n",
 			    HFA384x_RXSTATUS_MACPORT_GET(
 				    usbin->rxfrm.desc.status));
-		goto done;
 		break;
 	}
 
-done:
 	return;
 }
 
@@ -4127,7 +4125,6 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 	case HFA384x_PDR_HFA3861_MANF_TESTI:
 		/* code is OK */
 		return 1;
-		break;
 	default:
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
@@ -4140,7 +4137,6 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 				 pdrcode);
 			return 0;
 		}
-		break;
 	}
 	return 0;		/* avoid compiler warnings */
 }
-- 
1.9.1

