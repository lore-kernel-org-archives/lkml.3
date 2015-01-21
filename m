Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbbAUQxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:53:03 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41010 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbbAUQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:52:13 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-82-54bfd8aacecd
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
        x86@kernel.org, linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v9 04/17] mm: slub: introduce virt_to_obj function.
Date: Wed, 21 Jan 2015 19:51:32 +0300
Message-id: <1421859105-25253-5-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.1
In-reply-to: <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1421859105-25253-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t/xq7qrbuwPMTjWbmix7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8Xzhw/ZLSY8bGO3WNndzGax/dlbJouVnQ9YLS7vmsNm
	cW/Nf1aLts//gMSSjUwWi4/cZrZ492wys8WPDY9ZHYQ85u/8yOixc9Zddo8Fm0o9Fu95yeSx
	aVUnm8emT5PYPbreXmHyODHjN4vHkyvTmTw+Pr3F4tG3ZRWjx+dNcgE8UVw2Kak5mWWpRfp2
	CVwZm3t+sBd0s1Us6prL1sDYydrFyMkhIWAi8f/gG0YIW0ziwr31bF2MXBxCAksZJVYumMcM
	4fQxSWy6dYUZpIpNQE/i36ztbCC2iICCxObeZ6wgRcwCn1kkHnddA0sICzhLTLr9GWwFi4Cq
	xIHtrUwgNq+Am8TdFXuYIdbJSWy8swKshlPAXWLm+YlMENuaGCU+H9nONoGRdwEjwypG0dTS
	5ILipPRcI73ixNzi0rx0veT83E2MkGj4uoNx6TGrQ4wCHIxKPLwSPvtDhFgTy4orcw8xSnAw
	K4nwzr8OFOJNSaysSi3Kjy8qzUktPsTIxMEp1cAYdOt37cYgLscvzVYFul0SP9QFXlUJSJ8+
	HN3Qo7XnRPDpjUcYtVcsZDDueZO0u1fu/qG627/5/QyVMnunK7SsXWzWs1Aqo37G/v26X07U
	X3ebn/xMckaK0p+VFwp6FU5IrtSPv8U47WmI2jZODuO98zkurfmx9Z7xK57rZx4HFTQe/V+1
	9+ASJZbijERDLeai4kQAy9WSFmQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virt_to_obj takes kmem_cache address, address of slab page,
address x pointing somewhere inside slab object,
and returns address of the begging of object.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Acked-by: Christoph Lameter <cl@linux.com>
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
2.2.1

