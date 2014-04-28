Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaD1CBT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:01:19 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51431 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767AbaD1CBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:01:12 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: linux-kernel@vger.kernel.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH v2 1/4] staging/lustre/lnet: Drop useless LASSERT in ksocknal_select_ips
Date: Sun, 27 Apr 2014 22:00:46 -0400
Message-Id: <1398650449-4587-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398650449-4587-1-git-send-email-green@linuxhacker.ru>
References: <1398650449-4587-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should never be NULL because our interface list is up to date,
and even if it does, we'll just crash anyway so we are no better off.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..a391d13 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -793,8 +793,6 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 			ip = peer->ksnp_passive_ips[i];
 			best_iface = ksocknal_ip2iface(peer->ksnp_ni, ip);
 
-			/* peer passive ips are kept up to date */
-			LASSERT(best_iface != NULL);
 		} else {
 			/* choose a new interface */
 			LASSERT (i == peer->ksnp_n_passive_ips);
@@ -835,8 +833,6 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 			peer->ksnp_n_passive_ips = i+1;
 		}
 
-		LASSERT (best_iface != NULL);
-
 		/* mark the best matching peer IP used */
 		j = ksocknal_match_peerip(best_iface, peerips, n_peerips);
 		peerips[j] = 0;
-- 
1.9.0

