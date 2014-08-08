Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbaHHUwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:52:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41173 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbaHHUwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Gundersen <teg@jklm.no>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 211/259] net: tunnels - enable module autoloading
Date: Fri,  8 Aug 2014 13:40:34 -0700
Message-Id: <1407530482-4483-212-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

[ Upstream commit f98f89a0104454f35a62d681683c844f6dbf4043 ]

Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.

This is in line with how most other netdev kinds work, and will allow userspace
to create tunnels without having CAP_SYS_MODULE.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ipip.c       | 1 +
 net/ipv6/ip6_tunnel.c | 1 +
 net/ipv6/sit.c        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index fe3e9f7..af34bdb 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -486,4 +486,5 @@ static void __exit ipip_fini(void)
 module_init(ipip_init);
 module_exit(ipip_fini);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_RTNL_LINK("ipip");
 MODULE_ALIAS_NETDEV("tunl0");
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 41d97be..5d686b3 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -62,6 +62,7 @@
 MODULE_AUTHOR("Ville Nuorvala");
 MODULE_DESCRIPTION("IPv6 tunneling device");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_RTNL_LINK("ip6tnl");
 MODULE_ALIAS_NETDEV("ip6tnl0");
 
 #ifdef IP6_TNL_DEBUG
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index d3005b3..cd4777e 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1831,4 +1831,5 @@ xfrm_tunnel_failed:
 module_init(sit_init);
 module_exit(sit_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_RTNL_LINK("sit");
 MODULE_ALIAS_NETDEV("sit0");
-- 
1.9.1

