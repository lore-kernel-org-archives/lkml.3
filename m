Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbbA2PQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:16:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19482 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbbA2PM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:12:29 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b2-54ca4d49a914
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
Subject: [PATCH v10 04/17] mm: slub: introduce virt_to_obj function.
Date: Thu, 29 Jan 2015 18:11:48 +0300
Message-id: <1422544321-24232-5-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.2
In-reply-to: <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1422544321-24232-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xy7qevqdCDNpeqlps+/WIzeL33pms
	FnPWr2GzOHLtO7vF9W9vGC0+vXzAaPH84UN2iwkP29gtVnY3s1lsf/aWyWJl5wNWi8u75rBZ
	3Fvzn9Wi7fM/ILFkI5PF4iO3mS3ePZvMbPFjw2NWByGP+Ts/MnrsnHWX3WPBplKPxXteMnls
	WtXJ5rHp0yR2j663V5g8Tsz4zeLx5Mp0Jo+PT2+xePRtWcXo8XmTXABPFJdNSmpOZllqkb5d
	AlfGpAdn2Au62SoePp3N1sDYydrFyMEhIWAisWEVTxcjJ5ApJnHh3no2EFtIYCmjxJrzLl2M
	XEB2H5PE2qvnmUASbAJ6Ev9mbQcrEhFQkNjc+4wVpIhZ4DOLxOOua2AJYQEXiaPvdjCD2CwC
	qhKnZ39mBLF5Bdwkth28zQyxWE7iwsd4kDCngLvEv3uPmSCWNTFKbDw7j20CI+8CRoZVjKKp
	pckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFx8HUH49JjVocYBTgYlXh4Z2w6GSLEmlhWXJl7iFGC
	g1lJhHep5akQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxLZL5rf8ipmxOx1/wH54tXvN7+GQ0m
	v6fdl6n8zBpxh6tjElPSx0t+LTX+Um7m2xL7/tSdmWKkqnJpn2nyk6wjwo+3BWwymXkv93f6
	rKLdXieqDvWnfg4+XRG6wy1iDtvU8y7fPogEBkbzL3jZt/1oSrFRkbTDNZa4xzoGyrzql3Ou
	BTrz1SmxFGckGmoxFxUnAgDoPE5YYQIAAA==
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
index 9abf04e..eca3883 100644
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
2.2.2

