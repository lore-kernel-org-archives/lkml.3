Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965908AbaFQVrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:47:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965220AbaFQVrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Susant Sahani <susant@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 051/212] ip6_tunnel: fix potential NULL pointer dereference
Date: Tue, 17 Jun 2014 14:42:25 -0700
Message-Id: <1403041506-13646-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Susant Sahani <susant@redhat.com>

[ Upstream commit c8965932a2e3b70197ec02c6741c29460279e2a8 ]

The function ip6_tnl_validate assumes that the rtnl
attribute IFLA_IPTUN_PROTO always be filled . If this
attribute is not filled by  the userspace application
kernel get crashed with NULL pointer dereference. This
patch fixes the potential kernel crash when
IFLA_IPTUN_PROTO is missing .

Signed-off-by: Susant Sahani <susant@redhat.com>
Acked-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 7881965..41d97be 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1567,7 +1567,7 @@ static int ip6_tnl_validate(struct nlattr *tb[], struct nlattr *data[])
 {
 	u8 proto;
 
-	if (!data)
+	if (!data || !data[IFLA_IPTUN_PROTO])
 		return 0;
 
 	proto = nla_get_u8(data[IFLA_IPTUN_PROTO]);
-- 
1.9.1

