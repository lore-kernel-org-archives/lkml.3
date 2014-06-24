Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaFXH4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:56:01 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:41195 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaFXH4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:56:00 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH staging-next] staging: gdm72xx: fix block comment style
Date: Tue, 24 Jun 2014 00:55:58 -0700
Message-Id: <1403596558-16695-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch warnings, which are issued
when the gdm72xx driver is moved out of staging into drivers/net/wimax:

  WARNING: networking block comments don't use an empty /* line, use /* Comment...
  WARNING: networking block comments start with * on subsequent lines
  WARNING: networking block comments put the trailing */ on a separate line

Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_sdio.c  | 7 ++-----
 drivers/staging/gdm72xx/gdm_usb.c   | 6 ++----
 drivers/staging/gdm72xx/gdm_wimax.c | 5 +++--
 drivers/staging/gdm72xx/hci.h       | 4 +---
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 7398d45..0c6a3eb 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -439,9 +439,7 @@ static int gdm_sdio_send(void *priv_dev, void *data, int len,
 	return 0;
 }
 
-/*
- * Handle the HCI, WIMAX_SDU_TX_FLOW.
- */
+/* Handle the HCI, WIMAX_SDU_TX_FLOW. */
 static int control_sdu_tx_flow(struct sdiowm_dev *sdev, u8 *hci_data, int len)
 {
 	struct tx_cxt *tx = &sdev->tx;
@@ -462,8 +460,7 @@ static int control_sdu_tx_flow(struct sdiowm_dev *sdev, u8 *hci_data, int len)
 		tx->stop_sdu_tx = 0;
 		if (tx->can_send)
 			schedule_work(&sdev->ws);
-		/*
-		 * If free buffer for sdu tx doesn't exist, then tx queue
+		/* If free buffer for sdu tx doesn't exist, then tx queue
 		 * should not be woken. For this reason, don't pass the command,
 		 * START_SDU_TX.
 		 */
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 78d6667..2325d41 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -338,8 +338,7 @@ static int gdm_usb_send(void *priv_dev, void *data, int len,
 	t->callback = cb;
 	t->cb_data = cb_data;
 
-	/*
-	 * In some cases, USB Module of WiMax is blocked when data size is
+	/* In some cases, USB Module of WiMax is blocked when data size is
 	 * the multiple of 512. So, increment length by one in that case.
 	 */
 	if ((len % 512) == 0)
@@ -439,8 +438,7 @@ static void gdm_usb_rcv_complete(struct urb *urb)
 				list_for_each_entry(t, &tx->sdu_list, list) {
 					usb_submit_urb(t->urb, GFP_ATOMIC);
 				}
-				/*
-				 * If free buffer for sdu tx doesn't
+				/* If free buffer for sdu tx doesn't
 				 * exist, then tx queue should not be
 				 * woken. For this reason, don't pass
 				 * the command, START_SDU_TX.
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index e5e5115..833d0d4 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -580,8 +580,9 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 				return ret;
 		} else if (req->cmd == SIOCS_DATA) {
 			if (req->data_id == SIOC_DATA_FSM) {
-				/*NOTE: gdm_update_fsm should be called
-				before gdm_wimax_ioctl_set_data is called*/
+				/* NOTE: gdm_update_fsm should be called
+				 * before gdm_wimax_ioctl_set_data is called.
+				 */
 				gdm_update_fsm(dev,
 					       (struct fsm_s *)req->data.buf);
 			}
diff --git a/drivers/staging/gdm72xx/hci.h b/drivers/staging/gdm72xx/hci.h
index 2485a37..059ba00 100644
--- a/drivers/staging/gdm72xx/hci.h
+++ b/drivers/staging/gdm72xx/hci.h
@@ -112,13 +112,11 @@
 #define W_SCAN_ALL_SUBSCRIPTION		1
 #define W_SCAN_SPECIFIED_SUBSCRIPTION	2
 
-/*
- * TLV
+/* TLV
  *
  * [31:31] indicates the type is composite.
  * [30:16] is the length of the type. 0 length means length is variable.
  * [15:0] is the actual type.
- *
  */
 #define TLV_L(x)		(((x) >> 16) & 0xff)
 #define TLV_T(x)		((x) & 0xff)
-- 
2.0.0.526.g5318336

