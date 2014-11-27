Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaK0QD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:03:56 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23726 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaK0QBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:01:31 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-87-54774ad82efb
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
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH v8 05/12] mm: slub: introduce virt_to_obj function.
Date: Thu, 27 Nov 2014 19:00:49 +0300
Message-id: <1417104057-20335-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1417104057-20335-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xa7o3vMpDDFr6pCy2/XrEZvF770xW
	iznr17BZHLn2nd3i+rc3jBafXj5gtHj+8CG7xYSHbewW0zaKW6zsbmaz2P7sLZPFys4HrBaX
	d81hs7i35j+rRdvnf0BiyUYmi8VHbjNbvHs2mdnix4bHrA7CHvN3fmT02DnrLrvHgk2lHov3
	vGTy2LSqk81j06dJ7B5db68weZyY8ZvF48mV6UweH5/eYvHo27KK0ePzJjmPEy1fWAN4o7hs
	UlJzMstSi/TtErgydj/bwlLQzVZxbv8z1gbGTtYuRk4OCQETiZsPtrNB2GISF+6tB7K5OIQE
	ljJKTNr2hx3C6WOSmLNhIjNIFZuAnsS/WRAdIgK6Eque72IGKWIWaGOVePqgESwhLOAsMXvn
	YiCbg4NFQFXi9+dkkDCvgJvE0xfTGEHCEgJyElvXeYOEOQXcJdrPf2OE2NXEKNHSfo1lAiPv
	AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghsfF1B+PSY1aHGAU4GJV4eBlulYUIsSaW
	FVfmHmKU4GBWEuFtsi0PEeJNSaysSi3Kjy8qzUktPsTIxMEp1cC4VFTis8vEGZoqp1Sv10wJ
	YL13ay2b57NTvIr9NesdHogsfnpWf53nGt/U5b9WXVkfKH8644FL6rLUqnVxF+oONO6bEVny
	5V++6EI/veO1213t7f0mq1yrOfHd8n9qSs+chhWe3e8ema+VFnlrIhqVkpZU9VXPVtlMdaa7
	agH7/W36ri5s1/yVWIozEg21mIuKEwFxhP/eawIAAA==
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
2.1.3

