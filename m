Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaLOTdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40936 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbaLOTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:32:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 92/96] rtnetlink: release net refcnt on error in do_setlink()
Date: Mon, 15 Dec 2014 11:26:52 -0800
Message-Id: <1418671616-25482-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e0ebde0e131b529fd721b24f62872def5ec3718c ]

rtnl_link_get_net() holds a reference on the 'struct net', we need to release
it in case of error.

CC: Eric W. Biederman <ebiederm@xmission.com>
Fixes: b51642f6d77b ("net: Enable a userns root rtnl calls that are safe for unprivilged users")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8463178..7dca4b4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1391,6 +1391,7 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 		if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+			put_net(net);
 			err = -EPERM;
 			goto errout;
 		}
-- 
1.9.1

