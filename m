Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaCLREk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:04:40 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:56255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751168AbaCLREf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:04:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rice91_7eff117898f57
X-Filterd-Recvd-Size: 2122
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] 8021q: Convert uses of __constant_<foo> to <foo>
Date: Wed, 12 Mar 2014 10:04:15 -0700
Message-Id: <c44725e4804d6e64f44263bfcb4d4c3d2d057db4.1394643455.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1394643455.git.joe@perches.com>
References: <cover.1394643455.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of __constant_<foo> has been unnecessary for quite awhile now.

Make these uses consistent with the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/8021q/vlan.h         | 4 ++--
 net/8021q/vlan_netlink.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5704ed9..9d010a09 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -38,9 +38,9 @@ struct vlan_info {
 static inline unsigned int vlan_proto_idx(__be16 proto)
 {
 	switch (proto) {
-	case __constant_htons(ETH_P_8021Q):
+	case htons(ETH_P_8021Q):
 		return VLAN_PROTO_8021Q;
-	case __constant_htons(ETH_P_8021AD):
+	case htons(ETH_P_8021AD):
 		return VLAN_PROTO_8021AD;
 	default:
 		BUG();
diff --git a/net/8021q/vlan_netlink.c b/net/8021q/vlan_netlink.c
index c7e634a..8ac8a5c 100644
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -56,8 +56,8 @@ static int vlan_validate(struct nlattr *tb[], struct nlattr *data[])
 
 	if (data[IFLA_VLAN_PROTOCOL]) {
 		switch (nla_get_be16(data[IFLA_VLAN_PROTOCOL])) {
-		case __constant_htons(ETH_P_8021Q):
-		case __constant_htons(ETH_P_8021AD):
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
 			break;
 		default:
 			return -EPROTONOSUPPORT;
-- 
1.8.1.2.459.gbcd45b4.dirty

