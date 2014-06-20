Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbaFTUhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:37:05 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:22710 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754556AbaFTUhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:37:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAMGapFNXQzOZ/2dsb2JhbABZgw2rRwUBAQEBAQEFAZkqgQ4XdYQxLyOBGjeIRgHKLReFYogpax2ELQSaRIswiCqDRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, netdev@vger.kernel.org
Subject: [PATCH 1/1] net/netfilter/ipvs/ip_vs_sync.c: remove null test before kfree
Date: Fri, 20 Jun 2014 22:35:42 +0200
Message-Id: <1403296542-5992-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: netdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/netfilter/ipvs/ip_vs_sync.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index db80126..eadffb2 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -886,8 +886,7 @@ static void ip_vs_proc_conn(struct net *net, struct ip_vs_conn_param *param,
 		cp = ip_vs_conn_new(param, daddr, dport, flags, dest, fwmark);
 		rcu_read_unlock();
 		if (!cp) {
-			if (param->pe_data)
-				kfree(param->pe_data);
+			kfree(param->pe_data);
 			IP_VS_DBG(2, "BACKUP, add new conn. failed\n");
 			return;
 		}
-- 
1.8.4.5

