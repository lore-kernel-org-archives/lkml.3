Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbbAWHqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:46:19 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55484 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbbAWHqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:46:15 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: Provide definitions for GNU libc 2.8 and later
Date: Fri, 23 Jan 2015 08:46:12 +0100
Message-Id: <1421999172-27138-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Starting with GNU libc 2.8 and later, the definitions of the in6_pktinfo
and ip6_mtuinfo structures is guarded by __USE_GNU. Make sure to provide
the structures in the linux/ipv6.h when building against GNU libc 2.8 or
later and __USE_GNU is undefined to avoid breaking build issues.

One example where such failure to build can be observed is dhcpcd 6.6.7.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
This is based on next-20150122.

 include/uapi/linux/libc-compat.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/libc-compat.h b/include/uapi/linux/libc-compat.h
index fa673e9cc040..40bd54df06e3 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -70,8 +70,17 @@
 #define __UAPI_DEF_IPV6_MREQ		0
 #define __UAPI_DEF_IPPROTO_V6		0
 #define __UAPI_DEF_IPV6_OPTIONS		0
+/*
+ * The GNU C library 2.8 and later define the in6_pktinfo and ip6_mtuinfo
+ * structures only for __USE_GNU.
+ */
+#if __GLIBC_PREREQ(2, 8) && !defined(__USE_GNU)
+#define __UAPI_DEF_IN6_PKTINFO		1
+#define __UAPI_DEF_IP6_MTUINFO		1
+#else
 #define __UAPI_DEF_IN6_PKTINFO		0
 #define __UAPI_DEF_IP6_MTUINFO		0
+#endif
 
 #else
 
-- 
2.1.3

