Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaKXSFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:05:20 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28052 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbaKXSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:02:45 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8d-547372c023c6
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Subject: [PATCH v7 05/12] mm: slub: introduce virt_to_obj function.
Date: Mon, 24 Nov 2014 21:02:18 +0300
Message-id: <1416852146-9781-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1416852146-9781-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t/xK7oHiopDDP5u07fY9usRm8XvvTNZ
	LeasX8NmceTad3aL69/eMFp8evmA0WLL9SYmi+cPH7JbTHjYxm4xbaO4xcruZjaL7c/eMlms
	7HzAanF51xw2i3tr/rNatH3+BySWbGSyWHzkNrPFu2eTmS2urjrIbvFjw2NWB1GP+Ts/Mnrs
	nHWX3WPBplKPxXteMnlsWtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xeLzfd5XNo2/L
	KkaPz5vkPE60fGEN4IvisklJzcksSy3St0vgypjad4W94D5rRc+eOywNjI9Yuhg5OSQETCTm
	L25jhbDFJC7cW8/WxcjFISSwlFFi9puf7BBOH5PEp01fGUGq2AT0JP7N2s4GYosI6Eqser6L
	GaSIWeACq0Rf1xx2kISwgLPEkv1bmEFsFgFVidaVp8AaeAVcJT60bwOKcwCtk5PYus4bxOQU
	cJP48bQMYlcjo0TPrM1sExh5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQIiZyvOxiX
	HrM6xCjAwajEw1uhWRwixJpYVlyZe4hRgoNZSYQ3LR8oxJuSWFmVWpQfX1Sak1p8iJGJg1Oq
	gfH04fDcFw4rp/I9uezHva1/dUPu7OOt7y837Kx+uWSiVuBV0b6y9y432nvlj2e8/LJMc4m7
	rkCV9UQLlmdvfQz6t9yZwmjMv4P3xNIKlesT2dfPEo/isY/69/HWqRl8Fe+3/36kIlPts8TL
	8Pf335pllVvlNvrvqppj/tXB9ab12tZvx2urZRYosRRnJBpqMRcVJwIAbbP1V3oCAAA=
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

