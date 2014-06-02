Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbaFBNbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:31:18 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37566 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbaFBNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:31:17 -0400
From: John Church <sleeveroller@gmail.com>
To: gregkh@linuxfoundation.org, lisa@xenapiadmin.com, bergwolf@gmail.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        doug.s.oucharek@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: John Church <sleeveroller@gmail.com>
Subject: [PATCH] staging: lustre: fix sparse warnings for undeclared symbols
Date: Mon,  2 Jun 2014 14:31:10 +0100
Message-Id: <1401715870-14690-1-git-send-email-sleeveroller@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings for drivers/staging/lustre/lnet/lnet/router.c:

router.c:139:1: warning: symbol 'lnet_ni_notify_locked' was not declared. Should it be static?
router.c:277:1: warning: symbol 'lnet_add_route_to_rnet' was not declared. Should it be static?

Signed-off-by: John Church <sleeveroller@gmail.com>

---
 drivers/staging/lustre/lnet/lnet/router.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index 995f509..87e0c3b 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -135,7 +135,7 @@ lnet_notify_locked(lnet_peer_t *lp, int notifylnd, int alive, cfs_time_t when)
 	CDEBUG(D_NET, "set %s %d\n", libcfs_nid2str(lp->lp_nid), alive);
 }
 
-void
+static void
 lnet_ni_notify_locked(lnet_ni_t *ni, lnet_peer_t *lp)
 {
 	int	alive;
@@ -273,7 +273,7 @@ static void lnet_shuffle_seed(void)
 }
 
 /* NB expects LNET_LOCK held */
-void
+static void
 lnet_add_route_to_rnet (lnet_remotenet_t *rnet, lnet_route_t *route)
 {
 	unsigned int      len = 0;
-- 
1.7.10.4

