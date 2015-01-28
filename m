Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbbA2KMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:12:17 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44741 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757447AbbA2JBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        stephen hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 059/176] in6: fix conflict with glibc
Date: Wed, 28 Jan 2015 15:28:09 +0100
Message-Id: <ef260858f4bdef913410e825b1f9590a0b9db213.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: stephen hemminger <stephen@networkplumber.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 6d08acd2d32e3e877579315dc3202d7a5f336d98 ]

Resolve conflicts between glibc definition of IPV6 socket options
and those defined in Linux headers. Looks like earlier efforts to
solve this did not cover all the definitions.

It resolves warnings during iproute2 build.
Please consider for stable as well.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/uapi/linux/in6.h         | 3 ++-
 include/uapi/linux/libc-compat.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 440d5c479145..599b0d4c2d1c 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -156,7 +156,7 @@ enum {
 /*
  *	IPV6 socket options
  */
-
+#if __UAPI_DEF_IPV6_OPTIONS
 #define IPV6_ADDRFORM		1
 #define IPV6_2292PKTINFO	2
 #define IPV6_2292HOPOPTS	3
@@ -195,6 +195,7 @@ enum {
 
 #define IPV6_IPSEC_POLICY	34
 #define IPV6_XFRM_POLICY	35
+#endif
 
 /*
  * Multicast:
diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index c140620dad92..e28807ad17fa 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -69,6 +69,7 @@
 #define __UAPI_DEF_SOCKADDR_IN6		0
 #define __UAPI_DEF_IPV6_MREQ		0
 #define __UAPI_DEF_IPPROTO_V6		0
+#define __UAPI_DEF_IPV6_OPTIONS		0
 
 #else
 
@@ -82,6 +83,7 @@
 #define __UAPI_DEF_SOCKADDR_IN6		1
 #define __UAPI_DEF_IPV6_MREQ		1
 #define __UAPI_DEF_IPPROTO_V6		1
+#define __UAPI_DEF_IPV6_OPTIONS		1
 
 #endif /* _NETINET_IN_H */
 
@@ -103,6 +105,7 @@
 #define __UAPI_DEF_SOCKADDR_IN6		1
 #define __UAPI_DEF_IPV6_MREQ		1
 #define __UAPI_DEF_IPPROTO_V6		1
+#define __UAPI_DEF_IPV6_OPTIONS		1
 
 /* Definitions for xattr.h */
 #define __UAPI_DEF_XATTR		1
-- 
2.2.2

