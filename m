Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaJTA5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:57:14 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:57394 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaJTA5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:57:12 -0400
From: Jerry Stralko <gerb.stralko@gmail.com>
To: gregkh@linuxfoundation.org, oleg.drokin@intel.com,
        andreas.dilger@intel.com, linux-kernel@vger.kernel.org
Cc: Jerry Stralko <gerb.stralko@gmail.com>
Subject: [PATCH] staging : lustre : Fixed static symbol sparse warnings
Date: Sun, 19 Oct 2014 20:56:44 -0400
Message-Id: <1413766604-3658-1-git-send-email-gerb.stralko@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jerry Stralko <gerb.stralko@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/lib-move.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/lib-move.c b/drivers/staging/lustre/lnet/lnet/lib-move.c
index 4b9567d..5754725 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-move.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-move.c
@@ -561,7 +561,7 @@ lnet_extract_kiov(int dst_niov, lnet_kiov_t *dst,
 }
 EXPORT_SYMBOL(lnet_extract_kiov);
 
-void
+static void
 lnet_ni_recv(lnet_ni_t *ni, void *private, lnet_msg_t *msg, int delayed,
 	     unsigned int offset, unsigned int mlen, unsigned int rlen)
 {
@@ -599,7 +599,7 @@ lnet_ni_recv(lnet_ni_t *ni, void *private, lnet_msg_t *msg, int delayed,
 		lnet_finalize(ni, msg, rc);
 }
 
-void
+static void
 lnet_setpayloadbuffer(lnet_msg_t *msg)
 {
 	lnet_libmd_t *md = msg->msg_md;
@@ -639,7 +639,7 @@ lnet_prep_send(lnet_msg_t *msg, int type, lnet_process_id_t target,
 	msg->msg_hdr.payload_length = cpu_to_le32(len);
 }
 
-void
+static void
 lnet_ni_send(lnet_ni_t *ni, lnet_msg_t *msg)
 {
 	void   *priv = msg->msg_private;
@@ -654,7 +654,7 @@ lnet_ni_send(lnet_ni_t *ni, lnet_msg_t *msg)
 		lnet_finalize(ni, msg, rc);
 }
 
-int
+static int
 lnet_ni_eager_recv(lnet_ni_t *ni, lnet_msg_t *msg)
 {
 	int	rc;
@@ -679,7 +679,7 @@ lnet_ni_eager_recv(lnet_ni_t *ni, lnet_msg_t *msg)
 }
 
 /* NB: caller shall hold a ref on 'lp' as I'd drop lnet_net_lock */
-void
+static void
 lnet_ni_query_locked(lnet_ni_t *ni, lnet_peer_t *lp)
 {
 	unsigned long last_alive = 0;
@@ -731,7 +731,7 @@ lnet_peer_is_alive(lnet_peer_t *lp, unsigned long now)
 
 /* NB: returns 1 when alive, 0 when dead, negative when error;
  *     may drop the lnet_net_lock */
-int
+static int
 lnet_peer_alive_locked(lnet_peer_t *lp)
 {
 	unsigned long now = cfs_time_current();
@@ -871,7 +871,7 @@ lnet_post_send_locked(lnet_msg_t *msg, int do_send)
 }
 
 
-lnet_rtrbufpool_t *
+static lnet_rtrbufpool_t *
 lnet_msg2bufpool(lnet_msg_t *msg)
 {
 	lnet_rtrbufpool_t	*rbp;
@@ -891,7 +891,7 @@ lnet_msg2bufpool(lnet_msg_t *msg)
 	return rbp;
 }
 
-int
+static int
 lnet_post_routed_recv_locked(lnet_msg_t *msg, int do_recv)
 {
 	/* lnet_parse is going to lnet_net_unlock immediately after this, so it
-- 
1.9.3

