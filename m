Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaKFXYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58445 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaKFWha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Benc <jbenc@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 002/162] rtnetlink: fix VF info size
Date: Thu,  6 Nov 2014 14:34:26 -0800
Message-Id: <1415313426-9622-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 945a36761fd7877660f630bbdeb4ff9ff80d1935 ]

Commit 1d8faf48c74b8 ("net/core: Add VF link state control") added new
attribute to IFLA_VF_INFO group in rtnl_fill_ifinfo but did not adjust size
of the allocated memory in if_nlmsg_size/rtnl_vfinfo_size. As the result, we
may trigger warnings in rtnl_getlink and similar functions when many VF
links are enabled, as the information does not fit into the allocated skb.

Fixes: 1d8faf48c74b8 ("net/core: Add VF link state control")
Reported-by: Yulong Pei <ypei@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/rtnetlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a7b6520..8463178 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -739,7 +739,8 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 			(nla_total_size(sizeof(struct ifla_vf_mac)) +
 			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
 			 nla_total_size(sizeof(struct ifla_vf_tx_rate)) +
-			 nla_total_size(sizeof(struct ifla_vf_spoofchk)));
+			 nla_total_size(sizeof(struct ifla_vf_spoofchk)) +
+			 nla_total_size(sizeof(struct ifla_vf_link_state)));
 		return size;
 	} else
 		return 0;
-- 
1.9.1

