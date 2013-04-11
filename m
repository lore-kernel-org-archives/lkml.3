Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab3DKU0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24786 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3DKUZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:53 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=L-0Blh_sbI4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=nW2SK8sdaUMA:10 a=jmWCE8W1go-RpaolMxwA:9 a=jeBq3FmKZ4MA:10 a=D4g3Wo-3sDB463hv:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202546.428767806@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [ 001/171 ] IP_GRE: Revert "IP_GRE: Fix kernel panic in IP_GRE with GRE csum"
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0001-IP_GRE-Revert-IP_GRE-Fix-kernel-panic-in-IP_GRE-with.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 1bef9ca32aaed714a204a3eceb856a5000328c5b
"IP_GRE: Fix kernel panic in IP_GRE with GRE csum." which was
upstream commit d0a7cc630a337b0f56dc145e7eb6232852b14dd4 was
added to the 3.6.11.1 by mistake. Ben Hutchings reported to me
that this commit fixes a bug introduced by commit 6b78f16e4bdde3936b
which was added in the 3.7-rc cycle, and not needed to be back ported to
3.6.  I removed it from my queue, but the git repo I used to push still
included it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv4/ip_gre.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 3ee08ce..b062a98 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -946,12 +946,8 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 			ptr--;
 		}
 		if (tunnel->parms.o_flags&GRE_CSUM) {
-			int offset = skb_transport_offset(skb);
-
 			*ptr = 0;
-			*(__sum16 *)ptr = csum_fold(skb_checksum(skb, offset,
-								 skb->len - offset,
-								 0));
+			*(__sum16 *)ptr = ip_compute_csum((void *)(iph+1), skb->len - sizeof(struct iphdr));
 		}
 	}
 
-- 
1.7.10.4


