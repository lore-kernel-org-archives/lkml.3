Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaIHSl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:41:57 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:52033 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaIHSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:41:55 -0400
Date: Mon, 8 Sep 2014 14:41:48 -0400
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, tklauser@distanz.ch
Subject: [PATCH v2 2/4] staging: ozwpan: fix redundant else after break or
 return
Message-ID: <20140908184148.GB17486@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup checkpatch.pl warnings.

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---
 drivers/staging/ozwpan/ozhcd.c |  8 +++-----
 drivers/staging/ozwpan/ozpd.c  | 10 ++++------
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b30c4d87..ba2168f 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1010,10 +1010,9 @@ void oz_hcd_data_ind(void *hport, u8 endpoint, const u8 *data, int data_len)
 			urb->actual_length = copy_len;
 			oz_complete_urb(port->ozhcd->hcd, urb, 0);
 			return;
-		} else {
-			oz_dbg(ON, "buffering frame as URB is not available\n");
-			oz_hcd_buffer_data(ep, data, data_len);
 		}
+		oz_dbg(ON, "buffering frame as URB is not available\n");
+		oz_hcd_buffer_data(ep, data, data_len);
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
 		oz_hcd_buffer_data(ep, data, data_len);
@@ -1903,8 +1902,7 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 	spin_unlock_bh(&ozhcd->hcd_lock);
 	if (buf[0] != 0 || buf[1] != 0)
 		return 2;
-	else
-		return 0;
+	return 0;
 }

 /*
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 26c1049..852c288 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -496,11 +496,10 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
 			oz_dbg(TX_FRAMES, "Sending ISOC Frame, nb_isoc= %d\n",
 			       pd->nb_queued_isoc_frames);
 			return 0;
-		} else {
-			kfree_skb(skb);
-			oz_dbg(TX_FRAMES, "Dropping ISOC Frame>\n");
-			return -1;
 		}
+		kfree_skb(skb);
+		oz_dbg(TX_FRAMES, "Dropping ISOC Frame>\n");
+		return -1;
 	}

 	pd->last_sent_frame = e;
@@ -813,8 +812,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			atomic_inc(&g_submitted_isoc);
 			if (dev_queue_xmit(skb) < 0)
 				return -1;
-			else
-				return 0;
+			return 0;
 		}

 out:	kfree_skb(skb);
--
2.0.1

