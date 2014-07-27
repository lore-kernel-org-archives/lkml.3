Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaG0HHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 03:07:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65365 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaG0HHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 03:07:54 -0400
Date: Sun, 27 Jul 2014 12:37:46 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Pravin Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] openvswitch: Use IS_ERR_OR_NULL
Message-ID: <20140727070746.GA4825@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of the macro IS_ERR_OR_NULL in place of
tests for NULL and IS_ERR.

The following Coccinelle semantic patch was used for making the change:

@@
expression e;
@@

- e == NULL || IS_ERR(e)
+ IS_ERR_OR_NULL(e)
 || ...

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/openvswitch/datapath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 20f59b6..e3b3c21 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -780,7 +780,7 @@ static struct sk_buff *ovs_flow_cmd_build_info(const struct sw_flow *flow,
 
 	skb = ovs_flow_cmd_alloc_info(ovsl_dereference(flow->sf_acts), info,
 				      always);
-	if (!skb || IS_ERR(skb))
+	if (IS_ERR_OR_NULL(skb))
 		return skb;
 
 	retval = ovs_flow_cmd_fill_info(flow, dp_ifindex, skb,
-- 
1.9.1

