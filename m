Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbaEEWco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:32:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:58940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933070AbaEEW0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:26:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="506357930"
From: Andi Kleen <andi@firstfloor.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/24] net, diet: Default to small TCP hash tables on small kernels
Date: Mon,  5 May 2014 15:25:54 -0700
Message-Id: <1399328773-6531-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 net/ipv4/tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4bd6d52..3fd48421 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3127,7 +3127,11 @@ EXPORT_SYMBOL_GPL(tcp_done);
 
 extern struct tcp_congestion_ops tcp_reno;
 
+#ifdef CONFIG_BASE_SMALL
+static __initdata unsigned long thash_entries = 16;
+#else
 static __initdata unsigned long thash_entries;
+#endif
 static int __init set_thash_entries(char *str)
 {
 	ssize_t ret;
-- 
1.9.0

