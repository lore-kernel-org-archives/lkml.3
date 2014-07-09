Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaGILLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:11:48 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52164 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256AbaGILK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:27 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-43-53bd231d72a0
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 18/21] arm: mm: reserve shadow memory for kasan
Date: Wed, 09 Jul 2014 15:01:15 +0400
Message-id: <1404903678-8257-19-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7qyynuDDWY281ps+/WIzeLyrjls
	DkwefVtWMXp83iQXwBTFZZOSmpNZllqkb5fAlfFkanzBXdaK5S8+MTcwvmDpYuTkkBAwkfjU
	MgPKFpO4cG89WxcjF4eQwFJGic+HZ0A5fUwSn7Y9ZAapYhPQk/g3azsbiC0ioCCxufcZK4jN
	LKAjsfFaKxOILSzgKdE28zEjiM0ioCrx7G4TmM0r4CbRcG0m1DYFiWXLZ4L1cgLFe3oWgPUK
	CbhKrP68jXECI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFB8HUH49JjVocYBTgY
	lXh4X+zeEyzEmlhWXJl7iFGCg1lJhNdWdG+wEG9KYmVValF+fFFpTmrxIUYmDk6pBsYmReFZ
	GS8PHJyyZ9khi6w1WWVNRccvcvVVx90Lvb6Zz+BQBf+7yVmFz3bP+r4k/uE7/5ClbHU2jUov
	Pgi2hu3SYTpq2phxKE426f/pPdGMlaIqJ+1uR6055fRYd0bYz4DnUls+dEbc63quLirRbpk7
	7WqKd+D3zM22ky9MMJer/RuwX/ifS6ISS3FGoqEWc1FxIgCpKj1W4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/mm/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 659c75d..02fce2c 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/memblock.h>
 #include <linux/dma-contiguous.h>
 #include <linux/sizes.h>
+#include <linux/kasan.h>
 
 #include <asm/cp15.h>
 #include <asm/mach-types.h>
@@ -324,6 +325,8 @@ void __init arm_memblock_init(const struct machine_desc *mdesc)
 	 */
 	dma_contiguous_reserve(min(arm_dma_limit, arm_lowmem_limit));
 
+	kasan_alloc_shadow();
+
 	arm_memblock_steal_permitted = false;
 	memblock_dump_all();
 }
-- 
1.8.5.5

