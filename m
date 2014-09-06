Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaIFCTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 22:19:14 -0400
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:50066 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaIFCTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 22:19:11 -0400
X-Greylist: delayed 635 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2014 22:19:11 EDT
Date: Fri, 5 Sep 2014 22:08:23 -0400
From: anicoara <anicoara@uwaterloo.ca>
To: shigekatsu.tateno@atmel.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, adi.nicoara88@gmail.com
Subject: [PATCH] staging: ozwpan: Fix coding style warnings
Message-ID: <20140906020823.GA9645@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The warnings addressed:
1. Missing a blank line after declarations.
2. else is not generally useful after a break or return

Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>
---

Patch submitted as part of the Eudyptula challenge.

 drivers/staging/ozwpan/ozpd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 7726410..852c288 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -106,6 +106,7 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)

 	if (pd) {
 		int i;
+
 		atomic_set(&pd->ref_count, 2);
 		for (i = 0; i < OZ_NB_APPS; i++)
 			spin_lock_init(&pd->app_lock[i]);
@@ -153,6 +154,7 @@ static void oz_pd_free(struct work_struct *work)

 	list_for_each_safe(e, n, &pd->tx_queue) {
 		struct oz_tx_frame *f = list_entry(e, struct oz_tx_frame, link);
+
 		if (f->skb != NULL)
 			kfree_skb(f->skb);
 		oz_retire_frame(pd, f);
@@ -249,6 +251,7 @@ void oz_pd_heartbeat(struct oz_pd *pd, u16 apps)
 		hrtimer_cancel(&pd->heartbeat);
 	if (pd->mode & OZ_F_ISOC_ANYTIME) {
 		int count = 8;
+
 		while (count-- && (oz_send_isoc_frame(pd) >= 0))
 			;
 	}
@@ -493,11 +496,10 @@ static int oz_send_next_queued_frame(struct oz_pd *pd, int more_data)
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
@@ -752,6 +754,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 	} else {
 		struct oz_hdr oz;
 		struct oz_isoc_large iso;
+
 		spin_lock_bh(&pd->stream_lock);
 		iso.frame_number = st->frame_num;
 		st->frame_num += nb_units;
@@ -774,8 +777,10 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 		if (!(pd->mode & OZ_F_ISOC_ANYTIME)) {
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
+
 			if (nb >= pd->isoc_latency) {
 				struct oz_tx_frame *f;
+
 				oz_dbg(TX_FRAMES, "Dropping ISOC Unit nb= %d\n",
 				       nb);
 				spin_lock(&pd->tx_frame_lock);
@@ -807,8 +812,7 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
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

