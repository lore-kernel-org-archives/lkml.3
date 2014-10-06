Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaJFQBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:01:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54550 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaJFQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:01:26 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e5-5432bcd3b29a
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
Subject: [PATCH v4 06/13] mm: slub: introduce virt_to_obj function.
Date: Mon, 06 Oct 2014 19:54:00 +0400
Message-id: <1412610847-27671-7-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.2
In-reply-to: <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7qX9xiFGHyeoWyx7dcjNovfe2ey
	WsxZv4bN4si17+wW17+9YbT49PIBo8WW601MFs8fPmS3mPCwjd1i2kZxi5XdzWwW25+9ZbJY
	2fmA1eLyrjlsFvfW/Ge1aPv8D0gs2chksfjIbWaLd88mM1tcXXWQ3eLHhsesDqIe83d+ZPTY
	Oesuu8eCTaUei/e8ZPLYtKqTzWPTp0nsHl1vrzB5nJjxm8XjyZXpTB4fn95i8Xi/7yqbR9+W
	VYwenzfJeZxo+cIawBfFZZOSmpNZllqkb5fAlXH88SH2gvusFR3/gxsYH7F0MXJySAiYSHyc
	854JwhaTuHBvPVsXIxeHkMBSRonNEydBOX1MEr/n3WIFqWIT0JP4N2s7G4gtIqAgsbn3GStI
	EbPAfVaJ3QveAo3i4BAWcJa49tQPpIZFQBWoZi4zSJhXwE1iyltniGVyEtP33gU7glPAXWLa
	lZnsELuaGCUOfdnBNoGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkLj5uoNx6TGr
	Q4wCHIxKPLyROwxDhFgTy4orcw8xSnAwK4nwms8zChHiTUmsrEotyo8vKs1JLT7EyMTBKdXA
	WLzKc4rp74D7CwOu8fkzrl76h6vmRO72q/m7a99M45M5GR2j+WfF3hCVim8dfjMmWb3W/nPP
	bq4dcwuXfkV2/MVi/f6jy2cFfJ/Y1qVVc2ifT790HfOdq+GLfFV/Ff+p+aDK0v3ow8njk6dm
	is6+rFm0rFb4/pGKnca7nklI2W19N/NcyLwADyWW4oxEQy3mouJEAEVg3It5AgAA
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

