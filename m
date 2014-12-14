Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaLNUXC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:23:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaLNUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 16/24] rtnetlink: release net refcnt on error in do_setlink()
Date: Sun, 14 Dec 2014 12:20:36 -0800
Message-Id: <20141214201801.163912452@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/rtnetlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1318,6 +1318,7 @@ static int do_setlink(const struct sk_bu
 			goto errout;
 		}
 		if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN)) {
+			put_net(net);
 			err = -EPERM;
 			goto errout;
 		}


