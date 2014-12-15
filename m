Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaLOOb4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaLOO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 158/168] rtnetlink: release net refcnt on error in do_setlink()
Date: Mon, 15 Dec 2014 14:26:52 +0000
Message-Id: <1418653622-21105-159-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit e0ebde0e131b529fd721b24f62872def5ec3718c upstream.

rtnl_link_get_net() holds a reference on the 'struct net', we need to release
it in case of error.

CC: Eric W. Biederman <ebiederm@xmission.com>
Fixes: b51642f6d77b ("net: Enable a userns root rtnl calls that are safe for unprivilged users")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e0b5ca349049..48c2be43f856 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1490,6 +1490,7 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 		if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+			put_net(net);
 			err = -EPERM;
 			goto errout;
 		}
-- 
2.1.3

