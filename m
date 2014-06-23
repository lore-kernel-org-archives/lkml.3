Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaFWIvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:51:03 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55552 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/111] net: tunnels - enable module autoloading
Date: Mon, 23 Jun 2014 10:32:11 +0200
Message-Id: <fe2fe574d1e2c377bbfe641a34935db9d76be539.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit f98f89a0104454f35a62d681683c844f6dbf4043 ]

Enable the module alias hookup to allow tunnel modules to be autoloaded on demand.

This is in line with how most other netdev kinds work, and will allow userspace
to create tunnels without having CAP_SYS_MODULE.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/ipip.c       | 1 +
 net/ipv6/ip6_tunnel.c | 1 +
 net/ipv6/sit.c        | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 7f80fb4b82d3..a72a97f52954 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -485,4 +485,5 @@ static void __exit ipip_fini(void)
 module_init(ipip_init);
 module_exit(ipip_fini);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_RTNL_LINK("ipip");
 MODULE_ALIAS_NETDEV("tunl0");
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index aac89c3c6af4..7c26d8a3fa1b 100644
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
index b43388452bf8..20a446ffa44b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1770,4 +1770,5 @@ xfrm_tunnel_failed:
 module_init(sit_init);
 module_exit(sit_cleanup);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_RTNL_LINK("sit");
 MODULE_ALIAS_NETDEV("sit0");
-- 
2.0.0

