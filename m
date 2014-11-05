Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaKEOyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:54:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25026 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379AbaKEOy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:28 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-e1-545a3a23b400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v6 05/11] mm: slub: introduce virt_to_obj function.
Date: Wed, 05 Nov 2014 17:53:55 +0300
Message-id: <1415199241-5121-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1415199241-5121-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rKVlEhBv27+Cy2/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtNhyvYnJ4vnDh+wWEx62sVtM2yhusbK7mc1i+7O3TBYr
	Ox+wWlzeNYfN4t6a/6wWbZ//AYklG5ksFh+5zWzx7tlkZourqw6yW/zY8JjVQdRj/s6PjB47
	Z91l91iwqdRj8Z6XTB6bVnWyeWz6NIndo+vtFSaPEzN+s3g8uTKdyePj01ssHu/3XWXz6Nuy
	itHj8yY5jxMtX1gD+KK4bFJSczLLUov07RK4Mqb2XWEvuM9a0bPnDksD4yOWLkZODgkBE4mu
	k4vZIWwxiQv31rN1MXJxCAksZZRYsPsbI4TTxyTx4M8ENpAqNgE9iX+ztoPZIgKyElP/nmcB
	KWIWuMAq0dc1B2yUsICzxMW365hAbBYBVYlZf76D2bwCrhLXb91j7WLkAFonJ7F1nTdImFPA
	TeJI/yIWiGWNjBKfb3WyTGDkXcDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJHa+7GBc
	fMzqEKMAB6MSD69HU2SIEGtiWXFl7iFGCQ5mJRHeJu2oECHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2Mqg5rz1/c9SF0/Z3FT/Se8jiFHVtlVhD5gaP/L/9l142ccaIHlI8KNv1dbBzffzi94E+f
	opN1ROn+9cs52B9dbQi7t/JA1UKTSpcQla/yHPI/FWQntTYVnqxzOqC1OM5hwc1L91av645K
	EowLUo7a9C2A6fi5Q5XFl6OC3okKbrfusSy9e7VOiaU4I9FQi7moOBEAcgdqIXsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_obj takes kmem_cache address, address of slab page,
address x pointing somewhere inside slab object,
and returns address of the begging of object.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 include/linux/slub_def.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index d82abd4..c75bc1d 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -110,4 +110,9 @@ static inline void sysfs_slab_remove(struct kmem_cache *s)
 }
 #endif
 
+static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
+{
+	return x - ((x - slab_page) % s->size);
+}
+
 #endif /* _LINUX_SLUB_DEF_H */
-- 
2.1.3

