Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3IKEjW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:39:22 -0400
Received: from smtp.outflux.net ([198.145.64.163]:38433 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274Ab3IKEjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:39:18 -0400
Date: Tue, 10 Sep 2013 21:39:11 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH] xen-netback: fix possible format string flaw
Message-ID: <20130911043911.GA17237@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure a format string cannot accidentally leak into the
kthread_run() call.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/xen-netback/interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 625c6f4..77fee1d 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -406,7 +406,7 @@ int xenvif_connect(struct xenvif *vif, unsigned long tx_ring_ref,
 
 	init_waitqueue_head(&vif->wq);
 	vif->task = kthread_create(xenvif_kthread,
-				   (void *)vif, vif->dev->name);
+				   (void *)vif, "%s", vif->dev->name);
 	if (IS_ERR(vif->task)) {
 		pr_warn("Could not allocate kthread for %s\n", vif->dev->name);
 		err = PTR_ERR(vif->task);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
