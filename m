Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbbABWAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 17:00:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39262 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbbABWAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 17:00:35 -0500
From: Thomas Graf <tgraf@suug.ch>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, paulmck@linux.vnet.ibm.com,
        edumazet@google.com, john.r.fastabend@intel.com, josh@joshtriplett.org
Subject: [PATCH 2/9] rhashtable: Use rht_obj() instead of manual offset calculation
Date: Fri,  2 Jan 2015 23:00:15 +0100
Message-Id: <e0551897609b19939d03fe607507bc37e7551699.1420230585.git.tgraf@suug.ch>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1420230585.git.tgraf@suug.ch>
References: <cover.1420230585.git.tgraf@suug.ch>
In-Reply-To: <cover.1420230585.git.tgraf@suug.ch>
References: <cover.1420230585.git.tgraf@suug.ch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@suug.ch> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Graf <tgraf@suug.ch>
---
 lib/rhashtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 1ee0eb6..b658245 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -427,7 +427,7 @@ void *rhashtable_lookup(const struct rhashtable *ht, const void *key)
 		if (memcmp(rht_obj(ht, he) + ht->p.key_offset, key,
 			   ht->p.key_len))
 			continue;
-		return (void *) he - ht->p.head_offset;
+		return rht_obj(ht, he);
 	}
 
 	return NULL;
@@ -460,7 +460,7 @@ void *rhashtable_lookup_compare(const struct rhashtable *ht, const void *key,
 	rht_for_each_rcu(he, tbl->buckets[hash], ht) {
 		if (!compare(rht_obj(ht, he), arg))
 			continue;
-		return (void *) he - ht->p.head_offset;
+		return rht_obj(ht, he);
 	}
 
 	return NULL;
-- 
1.9.3

