Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161747AbaKNSdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:33:08 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:25543 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161422AbaKNSdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:33:06 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4SALtJZlRXQzQ2/2dsb2JhbABbgw6BLrlDBQF1mg8EAoEdFwEBAQEBfYRfI4EaN4hFAcFxkCcshj6KZB2ENQWeTI0SiWiBRwGCNTwwgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Pravin Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/1 net-next] openvswitch: use PTR_ERR_OR_ZERO
Date: Fri, 14 Nov 2014 19:32:58 +0100
Message-Id: <1415989978-28559-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 net/openvswitch/flow_netlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index c0d066d..c8fccdd 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -1425,10 +1425,8 @@ static int add_action(struct sw_flow_actions **sfa, int attrtype,
 	struct nlattr *a;
 
 	a = __add_action(sfa, attrtype, data, len, log);
-	if (IS_ERR(a))
-		return PTR_ERR(a);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(a);
 }
 
 static inline int add_nested_action_start(struct sw_flow_actions **sfa,
-- 
1.9.3

