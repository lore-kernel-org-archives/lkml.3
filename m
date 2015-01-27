Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbbA0MSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:18:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbbA0MSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 060/126] in6: fix conflict with glibc
Date: Tue, 27 Jan 2015 12:16:05 +0000
Message-Id: <1422361031-19364-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

commit 6d08acd2d32e3e877579315dc3202d7a5f336d98 upstream.

Resolve conflicts between glibc definition of IPV6 socket options
and those defined in Linux headers. Looks like earlier efforts to
solve this did not cover all the definitions.

It resolves warnings during iproute2 build.
Please consider for stable as well.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/uapi/linux/in6.h         | 3 ++-
 include/uapi/linux/libc-compat.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 0d8e0f0342dc..1a663d83d765 100644
--- a/include/uapi/linux/in6.h
+++ b/include/uapi/linux/in6.h
@@ -149,7 +149,7 @@ struct in6_flowlabel_req {
 /*
  *	IPV6 socket options
  */
-
+#if __UAPI_DEF_IPV6_OPTIONS
 #define IPV6_ADDRFORM		1
 #define IPV6_2292PKTINFO	2
 #define IPV6_2292HOPOPTS	3
@@ -196,6 +196,7 @@ struct in6_flowlabel_req {
 
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
2.1.4

