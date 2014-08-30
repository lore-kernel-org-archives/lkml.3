Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751080AbaH3Bsl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 21:48:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaH3Bsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 21:48:40 -0400
Message-ID: <54012D74.7010302@infradead.org>
Date: Fri, 29 Aug 2014 18:48:36 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au,
        mhocko@suse.cz, Pekka Enberg <penberg@kernel.org>,
        Vegard Nossum <vegardno@ifi.uio.no>
Subject: [PATCH -mmotm] mm: fix kmemcheck.c build errors
References: <5400fba1.732YclygYZprDXeI%akpm@linux-foundation.org>
In-Reply-To: <5400fba1.732YclygYZprDXeI%akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add header file to fix kmemcheck.c build errors:

../mm/kmemcheck.c:70:7: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:83:15: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:8: error: dereferencing pointer to incomplete type
../mm/kmemcheck.c:95:21: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 mm/kmemcheck.c |    1 +
 1 file changed, 1 insertion(+)

Index: mmotm-2014-0829-1515/mm/kmemcheck.c
===================================================================
--- mmotm-2014-0829-1515.orig/mm/kmemcheck.c
+++ mmotm-2014-0829-1515/mm/kmemcheck.c
@@ -2,6 +2,7 @@
 #include <linux/mm_types.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
+#include <linux/slab_def.h>
 #include <linux/kmemcheck.h>
 
 void kmemcheck_alloc_shadow(struct page *page, int order, gfp_t flags, int node)
