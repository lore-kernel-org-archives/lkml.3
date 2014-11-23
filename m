Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaKWUvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:51:24 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:40427 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaKWUvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:51:23 -0500
From: Giedrius Statkevicius <giedriuswork@gmail.com>
To: oleg.drokin@intel.com
Cc: andreas.dilger@intel.com, gregkh@linuxfoundation.org, bergwolf@gmail.com,
        vitaly.osipov@gmail.com, doug.s.oucharek@intel.com,
        Julia.Lawall@lip6.fr, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Giedrius Statkevicius <giedriuswork@gmail.com>
Subject: [PATCH] staging: lustre: Fix sparse warnings for lnet/lnet/router.c
Date: Sun, 23 Nov 2014 22:50:14 +0200
Message-Id: <1416775814-18420-1-git-send-email-giedriuswork@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse errors:
drivers/staging/lustre/lnet/lnet/router.c:756:1: warning: symbol 'lnet_wait_known_routerstate' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:788:1: warning: symbol 'lnet_update_ni_status_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:828:1: warning: symbol 'lnet_destroy_rc_data' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:848:16: warning: symbol 'lnet_create_rc_data_locked' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:1228:1: warning: symbol 'lnet_destroy_rtrbuf' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:1238:15: warning: symbol 'lnet_new_rtrbuf' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:1274:1: warning: symbol 'lnet_rtrpool_free_bufs' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:1303:1: warning: symbol 'lnet_rtrpool_alloc_bufs' was not declared. Should it be static?
drivers/staging/lustre/lnet/lnet/router.c:1337:1: warning: symbol 'lnet_rtrpool_init' was not declared. Should it be static?

Signed-off-by: Giedrius Statkevicius <giedriuswork@gmail.com>
---
 drivers/staging/lustre/lnet/lnet/router.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lnet/lnet/router.c b/drivers/staging/lustre/lnet/lnet/router.c
index b5b8fb5..778aa77 100644
--- a/drivers/staging/lustre/lnet/lnet/router.c
+++ b/drivers/staging/lustre/lnet/lnet/router.c
@@ -752,7 +752,7 @@ lnet_router_checker_event(lnet_event_t *event)
 	lnet_net_unlock(lp->lp_cpt);
 }
 
-void
+static void
 lnet_wait_known_routerstate(void)
 {
 	lnet_peer_t	 *rtr;
@@ -784,7 +784,7 @@ lnet_wait_known_routerstate(void)
 	}
 }
 
-void
+static void
 lnet_update_ni_status_locked(void)
 {
 	lnet_ni_t	*ni;
@@ -824,7 +824,7 @@ lnet_update_ni_status_locked(void)
 	}
 }
 
-void
+static void
 lnet_destroy_rc_data(lnet_rc_data_t *rcd)
 {
 	LASSERT(list_empty(&rcd->rcd_list));
@@ -845,7 +845,7 @@ lnet_destroy_rc_data(lnet_rc_data_t *rcd)
 	LIBCFS_FREE(rcd, sizeof(*rcd));
 }
 
-lnet_rc_data_t *
+static lnet_rc_data_t *
 lnet_create_rc_data_locked(lnet_peer_t *gateway)
 {
 	lnet_rc_data_t		*rcd = NULL;
@@ -1224,7 +1224,7 @@ rescan:
 	return 0;
 }
 
-void
+static void
 lnet_destroy_rtrbuf(lnet_rtrbuf_t *rb, int npages)
 {
 	int sz = offsetof(lnet_rtrbuf_t, rb_kiov[npages]);
@@ -1235,7 +1235,7 @@ lnet_destroy_rtrbuf(lnet_rtrbuf_t *rb, int npages)
 	LIBCFS_FREE(rb, sz);
 }
 
-lnet_rtrbuf_t *
+static lnet_rtrbuf_t *
 lnet_new_rtrbuf(lnet_rtrbufpool_t *rbp, int cpt)
 {
 	int	    npages = rbp->rbp_npages;
@@ -1270,7 +1270,7 @@ lnet_new_rtrbuf(lnet_rtrbufpool_t *rbp, int cpt)
 	return rb;
 }
 
-void
+static void
 lnet_rtrpool_free_bufs(lnet_rtrbufpool_t *rbp)
 {
 	int		npages = rbp->rbp_npages;
@@ -1299,7 +1299,7 @@ lnet_rtrpool_free_bufs(lnet_rtrbufpool_t *rbp)
 	rbp->rbp_nbuffers = rbp->rbp_credits = 0;
 }
 
-int
+static int
 lnet_rtrpool_alloc_bufs(lnet_rtrbufpool_t *rbp, int nbufs, int cpt)
 {
 	lnet_rtrbuf_t *rb;
@@ -1333,7 +1333,7 @@ lnet_rtrpool_alloc_bufs(lnet_rtrbufpool_t *rbp, int nbufs, int cpt)
 	return 0;
 }
 
-void
+static void
 lnet_rtrpool_init(lnet_rtrbufpool_t *rbp, int npages)
 {
 	INIT_LIST_HEAD(&rbp->rbp_msgs);
-- 
2.1.3

