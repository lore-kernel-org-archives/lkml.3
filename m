Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaETKgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:36:17 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37308 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaETKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:34:01 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Henk de Groot <pe1dnn@amsat.org>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] staging: wlags49_h2: wl_priv: Remove useless return variables
Date: Tue, 20 May 2014 12:33:42 +0200
Message-Id: <1400582028-24990-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
- return ret;
+ return C;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/staging/wlags49_h2/wl_priv.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 41f3324..aff9273 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -179,8 +179,6 @@ int wvlan_uil(struct uilreq *urq, struct wl_private *lp)
  ******************************************************************************/
 int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
 {
-	int result = 0;
-
 	if (!(lp->flags & WVLAN2_UIL_CONNECTED)) {
 		lp->flags |= WVLAN2_UIL_CONNECTED;
 		urq->hcfCtx = &(lp->hcfCtx);
@@ -190,7 +188,7 @@ int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
 		urq->result = UIL_ERR_IN_USE;
 	}
 
-	return result;
+	return 0;
 } /* wvlan_uil_connect */
 /*============================================================================*/
 
@@ -218,8 +216,6 @@ int wvlan_uil_connect(struct uilreq *urq, struct wl_private *lp)
  ******************************************************************************/
 int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp)
 {
-	int result = 0;
-
 	if (urq->hcfCtx == &(lp->hcfCtx)) {
 		if (lp->flags & WVLAN2_UIL_CONNECTED) {
 			lp->flags &= ~WVLAN2_UIL_CONNECTED;
@@ -238,7 +234,7 @@ int wvlan_uil_disconnect(struct uilreq *urq, struct wl_private *lp)
 		urq->result = UIL_ERR_WRONG_IFB;
 	}
 
-	return result;
+	return 0;
 } /* wvlan_uil_disconnect */
 /*============================================================================*/
 
@@ -1580,7 +1576,6 @@ int wvlan_set_netname(struct net_device *dev,
 {
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
-	int ret = 0;
 
 	wl_lock(lp, &flags);
 
@@ -1591,7 +1586,7 @@ int wvlan_set_netname(struct net_device *dev,
 	wl_apply(lp);
 	wl_unlock(lp, &flags);
 
-	return ret;
+	return 0;
 } /* wvlan_set_netname */
 /*============================================================================*/
 
@@ -1683,7 +1678,6 @@ int wvlan_set_station_nickname(struct net_device *dev,
 	struct wl_private *lp = wl_priv(dev);
 	unsigned long flags;
 	size_t len;
-	int         ret = 0;
 
 	wl_lock(lp, &flags);
 
@@ -1695,7 +1689,7 @@ int wvlan_set_station_nickname(struct net_device *dev,
 	wl_apply(lp);
 	wl_unlock(lp, &flags);
 
-	return ret;
+	return 0;
 } /* wvlan_set_station_nickname */
 /*============================================================================*/
 

