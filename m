Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaD0VRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:17:43 -0400
Received: from linuxhacker.ru ([217.76.32.60]:49636 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaD0VRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:17:41 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 1/5] staging/lustre/lnet: fix potential null pointer dereference
Date: Sun, 27 Apr 2014 17:17:22 -0400
Message-Id: <1398633446-16719-2-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
References: <1398633446-16719-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Null pointer 'best_iface' that comes from line 802 may be
dereferenced at line 832.
found by Klocwork Insight tool

Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9386
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4629
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Isaac Huang <he.huang@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..516f623 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -829,14 +829,14 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 				best_npeers = iface->ksni_npeers;
 			}
 
+			LASSERT(best_iface != NULL);
+
 			best_iface->ksni_npeers++;
 			ip = best_iface->ksni_ipaddr;
 			peer->ksnp_passive_ips[i] = ip;
 			peer->ksnp_n_passive_ips = i+1;
 		}
 
-		LASSERT (best_iface != NULL);
-
 		/* mark the best matching peer IP used */
 		j = ksocknal_match_peerip(best_iface, peerips, n_peerips);
 		peerips[j] = 0;
-- 
1.9.0

