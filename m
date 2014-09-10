Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaIJOig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:38:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11138 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaIJOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:38:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-ed-54106266b8e2
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [RFC/PATCH v2 04/10] mm: slub: introduce virt_to_obj function.
Date: Wed, 10 Sep 2014 18:31:21 +0400
Message-id: <1410359487-31938-5-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.0
In-reply-to: <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7ppSQIhBhNf81hs+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtpm0Ut1jZ3cxmsf3ZWyaLlZ0PWC0u
	75rDZnFvzX9Wi7bP/4DEko1MFouP3Ga2ePdsMrPF1VUH2S1+bHjM6iDiMX/nR0aPnbPusnss
	2FTqsXjPSyaPTas62Tw2fZrE7tH19gqTx4kZv1k8nlyZzuTx8ektFo++LasYPT5vkvM40fKF
	NYA3issmJTUnsyy1SN8ugSvj+ePFjAVtbBUXOh4yNTD+YOli5OSQEDCReHCrhx3CFpO4cG89
	WxcjF4eQwFJGib6+J4wgCSGBPiaJ3zcUQGw2AT2Jf7O2s4HYIgIKEpt7n7GCNDALHGCV6Dx8
	DSwhLOAu8bOjD2gqBweLgKpE42U7EJNXwE3izhl/iF1yEht2/wcbzwlUferkCiaIvU2MEksu
	bGKfwMi7gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIjHzZwbj4mNUhRgEORiUe3sKL
	/CFCrIllxZW5hxglOJiVRHibHARChHhTEiurUovy44tKc1KLDzEycXBKNTC2NBy6+uOOgdvk
	2/2/D1coXJdgZW1+8agusrBZ7a3qeTVR+cBLF/Z9LDywJSHsZ2rKabGQNacyly9IaeBkvpiv
	8pvV4gbfhC/36wudqxNPbZgoz6dbL1vOOEfT8MSl2JtZW7MuV2pO07zqzxrxJ63OQGJDlkdv
	q0VhQpJrX/80s1k1k9V1VimxFGckGmoxFxUnAgByWygZbwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_obj takes kmem_cache address, address of slab page,
address x pointing somewhere inside slab object,
and returns address of the begging of object.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 mm/slab.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index 026e7c3..3e3a6ae 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -346,4 +346,10 @@ static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 void *slab_next(struct seq_file *m, void *p, loff_t *pos);
 void slab_stop(struct seq_file *m, void *p);
 
+static inline void *virt_to_obj(struct kmem_cache *s, void *slab_page, void *x)
+{
+	return x - ((x - slab_page) % s->size);
+}
+
+
 #endif /* MM_SLAB_H */
-- 
1.8.5.5

