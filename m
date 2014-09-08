Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaIHM54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:57:56 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44560 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbaIHM5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:57:54 -0400
X-Greylist: delayed 527 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 08:57:54 EDT
X-Sasl-enc: a+rbTYi3X1tE5b3vKWB8lcuJPmfbXsnbtbGNaPmfclJJ 1410180546
From: Ilja Sidoroff <ilja.sidoroff@iki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Ilja Sidoroff <ilja.sidoroff@iki.fi>
Subject: [PATCH] Staging: wlan-ng: Remove redundant break/goto statements in hfa384x_usb.c
Date: Mon,  8 Sep 2014 15:48:09 +0300
Message-Id: <1410180489-12140-1-git-send-email-ilja.sidoroff@iki.fi>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes redundant goto or break statements in hfa384x_usb.c as found by checkpatch.pl

Signed-off-by: Ilja Sidoroff <ilja.sidoroff@iki.fi>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 2f63e0c..7f4ca1b 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3528,7 +3528,6 @@ static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 		netdev_warn(hw->wlandev->netdev, "Received frame on unsupported port=%d\n",
 			    HFA384x_RXSTATUS_MACPORT_GET(
 				    usbin->rxfrm.desc.status));
-		goto done;
 		break;
 	}
 
@@ -4127,7 +4126,6 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 	case HFA384x_PDR_HFA3861_MANF_TESTI:
 		/* code is OK */
 		return 1;
-		break;
 	default:
 		if (pdrcode < 0x1000) {
 			/* code is OK, but we don't know exactly what it is */
@@ -4140,7 +4138,6 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 				 pdrcode);
 			return 0;
 		}
-		break;
 	}
 	return 0;		/* avoid compiler warnings */
 }
-- 
1.9.1

