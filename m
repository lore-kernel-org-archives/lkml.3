Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3KYQwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:52:41 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47913 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3KYQwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:52:38 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Ian Campbell <ian.campbell@citrix.com>, Wei Liu <wei.liu2@citrix.com>,
        xen-devel@lists.xenproject.org
Cc: Andy Whitcroft <apw@canonical.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] xen-netback: include definition of csum_ipv6_magic
Date: Mon, 25 Nov 2013 16:52:34 +0000
Message-Id: <1385398354-21636-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are now using csum_ipv6_magic, include the appropriate header.
Avoids the following error:

    drivers/net/xen-netback/netback.c:1313:4: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
        tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/net/xen-netback/netback.c | 1 +
 1 file changed, 1 insertion(+)

    Found while trying to couple latest kernels for arm64 platforms.
    Looks like it got missed in the transition.

    -apw

diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 919b650..64f0e0d 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -39,6 +39,7 @@
 #include <linux/udp.h>
 
 #include <net/tcp.h>
+#include <net/ip6_checksum.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>
-- 
1.8.3.2

