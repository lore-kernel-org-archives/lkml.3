Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaDVOW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:22:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13064 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752201AbaDVOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:22:56 -0400
Date: Tue, 22 Apr 2014 07:22:45 -0700
From: Drew Richardson <drew.richardson@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michel Lespinasse <walken@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        William Roberts <bill.c.roberts@gmail.com>,
        Gideon Israel Dsouza <gidisrael@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] Export kmem tracepoints for use by kernel modules
Message-ID: <20140422142244.GA21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
Use struct pointer instead of name hash for reg/unreg tracepoints"),
any tracepoints used in a kernel module must be exported.

Signed-off-by: Drew Richardson <drew.richardson@arm.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
---
 mm/util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/util.c b/mm/util.c
index f380af7ea779..379e8db560b3 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -502,3 +502,9 @@ EXPORT_TRACEPOINT_SYMBOL(kmalloc_node);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc_node);
 EXPORT_TRACEPOINT_SYMBOL(kfree);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_free);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_free);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_free_batched);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_alloc);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_alloc_zone_locked);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_pcpu_drain);
+EXPORT_TRACEPOINT_SYMBOL_GPL(mm_page_alloc_extfrag);
-- 
1.8.3.2

