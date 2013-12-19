Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3LSJss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:48:48 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63058 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3LSJsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:48:46 -0500
Date: Thu, 19 Dec 2013 15:18:37 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 12/13] drivers: block: Mark function as static in drbd_state.c
Message-ID: <2850430f20d631a56978de8884341521d2c3016a.1387445397.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions conn_old_common_state() and conn_set_state() as static in
drbd/drbd_state.c because they are not used outside this file.

This eliminates the following warnings in drbd/drbd_state.c:
drivers/block/drbd/drbd_state.c:1585:6: warning: no previous prototype for ‘conn_old_common_state’ [-Wmissing-prototypes]
drivers/block/drbd/drbd_state.c:1674:1: warning: no previous prototype for ‘conn_set_state’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_state.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 120e1c0..9c20c34 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1579,7 +1579,8 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 	return 0;
 }
 
-void conn_old_common_state(struct drbd_tconn *tconn, union drbd_state *pcs, enum chg_state_flags *pf)
+static void conn_old_common_state(struct drbd_tconn *tconn,
+		union drbd_state *pcs, enum chg_state_flags *pf)
 {
 	enum chg_state_flags flags = ~0;
 	struct drbd_conf *mdev;
@@ -1667,7 +1668,7 @@ conn_is_valid_transition(struct drbd_tconn *tconn, union drbd_state mask, union
 	return rv;
 }
 
-void
+static void
 conn_set_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_state val,
 	       union drbd_state *pns_min, union drbd_state *pns_max, enum chg_state_flags flags)
 {
-- 
1.7.9.5

