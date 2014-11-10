Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaKJMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:09:27 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21245 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaKJMJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:09:26 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-1f-5460aaf30540
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
Date: Mon, 10 Nov 2014 15:06:56 +0300
Message-id: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t/xa7qfVyWEGPw/KGex7dcjNos569ew
	WVz/9obR4vKuOWwW99b8Z7Vo+/wPSCzZyGSxedNUZgcOjwWbSj02repk89j0aRK7x7tz59g9
	Tsz4zeLx5Mp0Jo++LasYPT5vkgvgiOKySUnNySxLLdK3S+DK6Gi4wVbwhK2iubGJpYHxFGsX
	IyeHhICJxPWbH9kgbDGJC/fWA9lcHEICSxkl5v77wQrh9DFJfJ/SxAJSxSagJ/Fv1nawDhEB
	DYmNl24xg9jMAr8YJe7eVgKxhQVcJVoPH2TqYuTgYBFQlXi3Xw0kzAsU/rZ1FztIWEJATmLr
	Ou8JjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE0tcdjEuPWR1iFOBgVOLh9fgS
	HyLEmlhWXJl7iFGCg1lJhHfWsoQQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyRGVM/Sp+99XXD
	IeGvl55fevJF7GNohaxO1JK/557uiPx75rGKcs+uGZOdkqKn5Wyd83KR5opFCf9r17pxzc/b
	fvPQjtx/ggpWzyW+eUkmWl/6y8Ko4mcd8T7RvtIjUlqiO3Oa3zEOm/aWD8c0YpdyHdybnhl2
	P/fCEfEejYYp2Rc5lhQDTVFiKc5INNRiLipOBACJJV12AgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmem_cache_zalloc_node() allocates zeroed memory for a particular
cache from a specified memory node. To be used for struct irq_desc.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slab.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c265bec..b3248fa 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -574,6 +574,12 @@ static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
 	return kmem_cache_alloc(k, flags | __GFP_ZERO);
 }
 
+static inline void *kmem_cache_zalloc_node(struct kmem_cache *k, gfp_t flags,
+					int node)
+{
+	return kmem_cache_alloc_node(k, flags | __GFP_ZERO, node);
+}
+
 /**
  * kzalloc - allocate memory. The memory is set to zero.
  * @size: how many bytes of memory are required.
-- 
2.1.3

