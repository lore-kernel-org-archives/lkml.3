Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab3AYXg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:36:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:54373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863Ab3AYXgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:36:55 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19nNH1puOVn+GotCde3Qmg4jqyy0WCoBT1LYkrRU+
	DOXnHaSoIJ4GT/
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rob Clark <rob@ti.com>, Andy Gross <andy.gross@ti.com>,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        "Vincent Penquerc'h" <vincent.penquerch@collabora.co.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] staging/omapdrm: Use kmemdup rather than duplicating its implementation
Date: Sat, 26 Jan 2013 00:40:13 +0100
Message-Id: <1359157213-626-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with coccicheck.
The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/omapdrm/omap_gem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index 08f1e292..f9297eb 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -1267,12 +1267,12 @@ int omap_gem_set_sync_object(struct drm_gem_object *obj, void *syncobj)
 
 	if ((omap_obj->flags & OMAP_BO_EXT_SYNC) && !syncobj) {
 		/* clearing a previously set syncobj */
-		syncobj = kzalloc(sizeof(*omap_obj->sync), GFP_ATOMIC);
+		syncobj = kmemdup(omap_obj->sync, sizeof(*omap_obj->sync),
+				  GFP_ATOMIC);
 		if (!syncobj) {
 			ret = -ENOMEM;
 			goto unlock;
 		}
-		memcpy(syncobj, omap_obj->sync, sizeof(*omap_obj->sync));
 		omap_obj->flags &= ~OMAP_BO_EXT_SYNC;
 		omap_obj->sync = syncobj;
 	} else if (syncobj && !(omap_obj->flags & OMAP_BO_EXT_SYNC)) {
-- 
1.7.8.6

