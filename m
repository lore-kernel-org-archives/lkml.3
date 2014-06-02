Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaFBMD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:03:59 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:50329 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaFBMD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:03:57 -0400
From: John Church <sleeveroller@gmail.com>
To: gregkh@linuxfoundation.org, lisa@xenapiadmin.com, bergwolf@gmail.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        doug.s.oucharek@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: John Church <sleeveroller@gmail.com>
Subject: [PATCH] staging: lustre: fix sparse warnings for undeclared symbols
Date: Mon,  2 Jun 2014 13:03:48 +0100
Message-Id: <1401710628-3690-1-git-send-email-sleeveroller@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warnings for drivers/staging/lustre/lnet/lnet/router.c:

router.c:139:1: warning: symbol 'lnet_ni_notify_locked' was not declared. Should it be static?
router.c:277:1: warning: symbol 'lnet_add_route_to_rnet' was not declared. Should it be static?

Signed-off-by: John Church <sleeveroller@gmail.com>

---
 drivers/staging/lustre/include/linux/lnet/lib-lnet.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
index 856fcfa..143bb3a 100644
--- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
+++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
@@ -650,6 +650,8 @@ extern lnet_ni_t *lnet_net2ni(__u32 net);
 
 int lnet_notify(lnet_ni_t *ni, lnet_nid_t peer, int alive, cfs_time_t when);
 void lnet_notify_locked(lnet_peer_t *lp, int notifylnd, int alive, cfs_time_t when);
+void lnet_ni_notify_locked(lnet_ni_t *ni, lnet_peer_t *lp);
+void lnet_add_route_to_rnet(lnet_remotenet_t *rnet, lnet_route_t *route);
 int lnet_add_route(__u32 net, unsigned int hops, lnet_nid_t gateway_nid,
 		   unsigned int priority);
 int lnet_check_routes(void);
-- 
1.7.10.4

