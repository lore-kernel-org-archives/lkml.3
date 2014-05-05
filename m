Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbaEEWeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:34:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:58945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaEEW0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,992,1389772800"; 
   d="scan'208";a="506357927"
From: Andi Kleen <andi@firstfloor.org>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/24] net, diet: Decrease ip defrag hash tables and max length with BASE_SMALL
Date: Mon,  5 May 2014 15:25:52 -0700
Message-Id: <1399328773-6531-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When CONFIG_BASE_SMALL is set only use 16 entries in the IP defrag
hash table. Also limit the max length of chains to 32 packets.

The sizes are somewhat arbitary and could be changed.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/net/inet_frag.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 6f59de9..a8c5948 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -41,6 +41,10 @@ struct inet_frag_queue {
 	struct netns_frags	*net;
 };
 
+#ifdef CONFIG_BASE_SMALL
+#define INETFRAGS_HASHSZ	16
+#define INETFRAGS_MAXDEPTH	32
+#else
 #define INETFRAGS_HASHSZ	1024
 
 /* averaged:
@@ -50,6 +54,8 @@ struct inet_frag_queue {
  */
 #define INETFRAGS_MAXDEPTH		128
 
+#endif
+
 struct inet_frag_bucket {
 	struct hlist_head	chain;
 	spinlock_t		chain_lock;
-- 
1.9.0

