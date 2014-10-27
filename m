Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaJ0Qrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:47:52 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52388 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaJ0Qrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:47:48 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-ef-544e7731ae7d
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
Subject: [PATCH v5 06/12] mm: slub: introduce virt_to_obj function.
Date: Mon, 27 Oct 2014 19:46:53 +0300
Message-id: <1414428419-17860-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1414428419-17860-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7qG5X4hBrveSFts+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaLHlehOTxfOHD9ktJjxsY7eYtlHcYmV3M5vF9mdvmSxW
	dj5gtbi8aw6bxb01/1kt2j7/AxJLNjJZLD5ym9ni3bPJzBZXVx1kt/ix4TGrg6jH/J0fGT12
	zrrL7rFgU6nH4j0vmTw2repk89j0aRK7R9fbK0weJ2b8ZvF4cmU6k8fHp7dYPN7vu8rm0bdl
	FaPH501yHidavrAG8EVx2aSk5mSWpRbp2yVwZRx/fIi94D5rRcf/4AbGRyxdjBwcEgImEidW
	+3UxcgKZYhIX7q1nA7GFBJYySszc597FyAVk9zFJdG3fxgSSYBPQk/g3aztYkYiArsSq57uY
	QYqYBS6wSvR1zWEHSQgLOEvsfbWWFcRmEVCVaNp8iBnE5hVwk5hz4hczxDY5iel777KA2JwC
	7hI9l6axQGxrYpTom7KceQIj7wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIXHzZQfj
	4mNWhxgFOBiVeHh3TPMNEWJNLCuuzD3EKMHBrCTCeyDNL0SINyWxsiq1KD++qDQntfgQIxMH
	p1QD46LnGgHfvs83Ol7yvOXzMrbwtuLZ7bNPeRssUg221LKxurx5iUHw+oI1cZUTelVS53td
	qJSLvhtpJrJr60lfs2tpjf1hiesWyD19+Vvhh6fjhdcPHHmVH2yWlf3DY93tPqWurirkbGrS
	eplvn21PRl9UYjfY8DFh981V3xTc3h+vN20OlFr5WomlOCPRUIu5qDgRABy8zVZ5AgAA
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
2.1.2

