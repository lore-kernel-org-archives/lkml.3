Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbbAYTBM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:01:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490AbbAYSJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 009/183] in6: fix conflict with glibc
Date: Sun, 25 Jan 2015 10:05:31 -0800
Message-Id: <20150125180810.596277408@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/in6.h         |    3 ++-
 include/uapi/linux/libc-compat.h |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

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


