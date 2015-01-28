Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbbA2DIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:08:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965138AbbA2ChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 004/139] in6: fix conflict with glibc
Date: Wed, 28 Jan 2015 14:19:07 -0800
Message-Id: <1422483682-15393-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 6d08acd2d32e3e877579315dc3202d7a5f336d98 ]

Resolve conflicts between glibc definition of IPV6 socket options
and those defined in Linux headers. Looks like earlier efforts to
solve this did not cover all the definitions.

It resolves warnings during iproute2 build.
Please consider for stable as well.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/uapi/linux/in6.h         | 3 ++-
 include/uapi/linux/libc-compat.h | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
index 440d5c4..599b0d4 100644
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
index c140620..e28807a 100644
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
1.9.1

