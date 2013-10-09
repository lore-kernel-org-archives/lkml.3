Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JIOQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:16:35 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:34195 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3JIOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:16:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: Unbreak build
Date: Wed,  9 Oct 2013 16:14:23 +0200
Message-Id: <1381328067-1593-2-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381328067-1593-1-git-send-email-treding@nvidia.com>
References: <1381328067-1593-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IPv6 specific fields in struct sock_common are accessed in various
places even if IPv6 support is disabled. Fix this by including the
fields unconditionally.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 include/net/sock.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7e50df5..c87a8a1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -192,10 +192,8 @@ struct sock_common {
 	struct net	 	*skc_net;
 #endif
 
-#if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr		skc_v6_daddr;
 	struct in6_addr		skc_v6_rcv_saddr;
-#endif
 
 	/*
 	 * fields between dontcopy_begin/dontcopy_end
-- 
1.8.4

