Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162547AbaDCHNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:13:39 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33250 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162443AbaDCHNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:13:34 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 7/9] driver: staging: wlan-ng: Fixed white spaces issues
Date: Thu,  3 Apr 2014 09:13:29 +0200
Message-Id: <1396509209-3074-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hfa384x_usb.c:
Fixed allignment issues after open braces
Moved Logical continuations to the correct lines
Removed unnecessary blank lines

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 4b11ed7..64b51b7 100644
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
@@ -657,7 +656,6 @@ usbctlx_get_rridresult(const hfa384x_usb_rridresp_t *rridresp,
 	result->rid = le16_to_cpu(rridresp->rid);
 	result->riddata = rridresp->data;
 	result->riddata_len = ((le16_to_cpu(rridresp->frmlen) - 1) * 2);
-
 }
 
 /*----------------------------------------------------------------
@@ -676,7 +674,7 @@ static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
 {
 	struct usbctlx_cmd_completor *complete;
 
-	complete = (struct usbctlx_cmd_completor *) head;
+	complete = (struct usbctlx_cmd_completor *)head;
 	return usbctlx_get_status(complete->cmdresp, complete->result);
 }
 
@@ -711,7 +709,7 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 	struct usbctlx_rrid_completor *complete;
 	hfa384x_rridresult_t rridresult;
 
-	complete = (struct usbctlx_rrid_completor *) head;
+	complete = (struct usbctlx_rrid_completor *)head;
 	usbctlx_get_rridresult(complete->rridresp, &rridresult);
 
 	/* Validate the length, note body len calculation in bytes */
@@ -2827,7 +2825,7 @@ void hfa384x_tx_timeout(wlandevice_t *wlandev)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reaper_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -2846,7 +2844,6 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 	}
 
 	spin_unlock_irqrestore(&hw->ctlxq.lock, flags);
-
 }
 
 /*----------------------------------------------------------------
@@ -2865,7 +2862,7 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_completion_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -3137,7 +3134,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 {
 	wlandevice_t *wlandev = urb->context;
 	hfa384x_t *hw;
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) urb->transfer_buffer;
+	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *)urb->transfer_buffer;
 	struct sk_buff *skb = NULL;
 	int result;
 	int urb_status;
@@ -3465,7 +3462,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 ----------------------------------------------------------------*/
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 {
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) skb->data;
+	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *)skb->data;
 	hfa384x_t *hw = wlandev->priv;
 	int hdrlen;
 	struct p80211_rxmeta *rxmeta;
@@ -3610,7 +3607,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		struct p80211_caphdr *caphdr;
 		/* The NEW header format! */
 		datap = skb_put(skb, sizeof(struct p80211_caphdr));
-		caphdr = (struct p80211_caphdr *) datap;
+		caphdr = (struct p80211_caphdr *)datap;
 
 		caphdr->version = htonl(P80211CAPTURE_VERSION);
 		caphdr->length = htonl(sizeof(struct p80211_caphdr));
@@ -3707,7 +3704,6 @@ static void hfa384x_usbout_callback(struct urb *urb)
 #endif
 
 	if (wlandev && wlandev->netdev) {
-
 		switch (urb->status) {
 		case 0:
 			hfa384x_usbout_tx(wlandev, usbout);
@@ -3733,8 +3729,8 @@ static void hfa384x_usbout_callback(struct urb *urb)
 				hfa384x_t *hw = wlandev->priv;
 
 				if (!test_and_set_bit
-				    (THROTTLE_TX, &hw->usb_flags)
-				    && !timer_pending(&hw->throttle)) {
+				    (THROTTLE_TX, &hw->usb_flags) &&
+				     !timer_pending(&hw->throttle)) {
 					mod_timer(&hw->throttle,
 						  jiffies + THROTTLE_JIFFIES);
 				}
@@ -3906,7 +3902,7 @@ delresp:
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -3964,7 +3960,7 @@ static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -4003,7 +3999,7 @@ static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usb_throttlefn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
-- 
1.7.9.5

