Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaIXMvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:51:41 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25782 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaIXMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:51:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-39-5422be4cd176
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v3 06/13] mm: slub: introduce virt_to_obj function.
Date: Wed, 24 Sep 2014 16:44:02 +0400
Message-id: <1411562649-28231-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.1
In-reply-to: <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1411562649-28231-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xy7o++5RCDN41GVhs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1kt2j7/AxJLNjJZLD5ym9ni3bPJzBZXVx1kt/ix4TGrg6jH/J0fGT12
	zrrL7rFgU6nH4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPN7vu8rm0bdl
	FaPH501yHidavrAG8EVx2aSk5mSWpRbp2yVwZTxct5mp4D5rxfmpJ1gaGB+xdDFyckgImEh0
	rn/DDGGLSVy4t56ti5GLQ0hgKaPEka932SGcPiaJ40tb2EGq2AT0JP7N2s4GYosIKEhs7n3G
	ClLELHCfVWL3grdMIAlhAWeJuaePgTWwCKhKNE0/wgpi8wq4SXTt3coGsU5OYu/k1WBncAq4
	Sxz48QJqWxOjxLK9v5kmMPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESPV92MC4+
	ZnWIUYCDUYmHd4K4UogQa2JZcWXuIUYJDmYlEd6wPUAh3pTEyqrUovz4otKc1OJDjEwcnFIN
	jPOtqj+w6CiGLJ+bwPFjz7Uw58tfhE+Lf51zrCR4l6Wa9NTdfyrW3/u1PPOViilvwKvYw5s/
	BcZX5NbJPQoI2JBokeKdES+3983SjomeEa0n7O2+TYu8rjrD1uFJxObQh3NF6zbIFW+w0nZe
	9zzzZd/PTVxCuyNE/v/ak1Bp+SP3sBJTwJu2eCWW4oxEQy3mouJEAPGavUZ8AgAA
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
2.1.1

