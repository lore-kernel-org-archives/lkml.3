Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaCNPWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:22:13 -0400
Received: from 124-84-246-161.wendulka.net ([84.246.161.124]:53754 "EHLO
	ixit.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754982AbaCNPWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:22:07 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 17:16:29 +0100
From: David Heidelberger <david.heidelberger@ixit.cz>
To: linux-kernel@vger.kernel.org
Cc: maillist-linux@barfooze.de
Subject: [PATCH 4/4] libc-compat.h: prevent redefinition of struct ethhdr
Message-ID: <1259716fc4b4a6666e46f05a0707f481@ixit.cz>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: John Spencer <maillist-linux@barfooze.de>
Tested-by: David Heidelberger <david.heidelberger@ixit.cz>
---
  include/uapi/linux/if_ether.h    | 4 +++-
  include/uapi/linux/libc-compat.h | 6 ++++++
  2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_ether.h 
b/include/uapi/linux/if_ether.h
index 2ce0f6a..18cfb23 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -22,6 +22,7 @@
  #define _UAPI_LINUX_IF_ETHER_H

  #include <linux/types.h>
+#include <linux/libc-compat.h>

  /*
   *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the 
preamble
@@ -131,11 +132,12 @@
   *	This is an Ethernet frame header.
   */

+#if __UAPI_DEF_ETHHDR
  struct ethhdr {
  	unsigned char	h_dest[ETH_ALEN];	/* destination eth addr	*/
  	unsigned char	h_source[ETH_ALEN];	/* source ether addr	*/
  	__be16		h_proto;		/* packet type ID field	*/
  } __attribute__((packed));
-
+#endif

  #endif /* _UAPI_LINUX_IF_ETHER_H */
diff --git a/include/uapi/linux/libc-compat.h 
b/include/uapi/linux/libc-compat.h
index c16c34c..c491d7a 100644
--- a/include/uapi/linux/libc-compat.h
+++ b/include/uapi/linux/libc-compat.h
@@ -50,6 +50,12 @@

  #ifndef __KERNEL__ /* we're used from userspace */

+#ifdef _NETINET_IF_ETHER_H /* musl */
+#define __UAPI_DEF_ETHHDR 0
+#else /* glibc uses __NETINET_IF_ETHER_H, and includes the kernel 
header. */
+#define __UAPI_DEF_ETHHDR 1
+#endif
+
  /* Coordinate with libc netinet/in.h header. */
  #ifdef _NETINET_IN_H

-- 
1.8.4
