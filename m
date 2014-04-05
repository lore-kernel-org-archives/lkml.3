Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaDEVe4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:34:56 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:57969 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaDEVew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:34:52 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 07/10] driver: staging: wlan-ng: Fixed white spaces issues
Date: Sat,  5 Apr 2014 23:34:48 +0200
Message-Id: <1396733688-15976-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hfa384x_usb.c:
Moved Logical continuations to the correct lines
Removed unnecessary blank lines

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index a6684b6..1a6116a 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -398,9 +398,8 @@ static int submit_tx_urb(hfa384x_t *hw, struct urb *tx_urb, gfp_t memflags)
 
 	result = -ENOLINK;
 	if (netif_running(netdev)) {
-
-		if (!hw->wlandev->hwremoved
-		    && !test_bit(WORK_TX_HALT, &hw->usb_flags)) {
+		if (!hw->wlandev->hwremoved &&
+		    !test_bit(WORK_TX_HALT, &hw->usb_flags)) {
 			result = SUBMIT_URB(tx_urb, memflags);
 
 			/* Test whether we need to reset the TX pipe */
@@ -656,7 +655,6 @@ usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
 	result->rid = le16_to_cpu(rridresp->rid);
 	result->riddata = rridresp->data;
 	result->riddata_len = ((le16_to_cpu(rridresp->frmlen) - 1) * 2);
-
 }
 
 /*----------------------------------------------------------------
@@ -2845,7 +2843,6 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 	}
 
 	spin_unlock_irqrestore(&hw->ctlxq.lock, flags);
-
 }
 
 /*----------------------------------------------------------------
@@ -3706,7 +3703,6 @@ static void hfa384x_usbout_callback(struct urb *urb)
 #endif
 
 	if (wlandev && wlandev->netdev) {
-
 		switch (urb->status) {
 		case 0:
 			hfa384x_usbout_tx(wlandev, usbout);
@@ -3732,8 +3728,8 @@ static void hfa384x_usbout_callback(struct urb *urb)
 				hfa384x_t *hw = wlandev->priv;
 
 				if (!test_and_set_bit
-				    (THROTTLE_TX, &hw->usb_flags)
-				    && !timer_pending(&hw->throttle)) {
+				    (THROTTLE_TX, &hw->usb_flags) &&
+				    !timer_pending(&hw->throttle)) {
 					mod_timer(&hw->throttle,
 						  jiffies + THROTTLE_JIFFIES);
 				}
-- 
1.7.9.5

