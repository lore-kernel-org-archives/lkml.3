Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbaGILTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:19:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:43665 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaGILKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:17 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-90-53bd23167c8d
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 02/21] init: main: initialize kasan's shadow area on
 boot
Date: Wed, 09 Jul 2014 15:00:59 +0400
Message-id: <1404903678-8257-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7piynuDDQ68NbLY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK6Ph5TXmgrPsFRdnvGZtYJzB1sXIySEhYCJx
	ZPkxZghbTOLCvfVAcS4OIYGljBK/lm5ignD6mCQufNvOBFLFJqAn8W/WdrBuEQEFic29z1hB
	bGYBHYmN11qBajg4hAVCJXZttwQJswioSjTd/sECYvMKuEosfHwMarGCxLLlM8FaOQXcJHp6
	FoCNFwKqWf15G+MERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKC4MsOxsXHrA4x
	CnAwKvHwatTuDhZiTSwrrsw9xCjBwawkwmsrujdYiDclsbIqtSg/vqg0J7X4ECMTB6dUA2P8
	XLWCpKLMP3/Xii2xrN6t+H+Xk4BS4KPHVjO/uf8R7GYL6zTdJyEbY/vhm0+ZGYda5IH0tfy1
	1zd8Clifly5+7uGSo60xiz47vn2ruC7pzYc1dpn5H/w69Pa2nwmVPCxqxP31zirL3w8k2Jeo
	6LZv2iBtIlt658dMY6sN4jvr6yX9EwLjjymxFGckGmoxFxUnAgDzOyMz4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes shadow area after it was allocated by arch code.
All low memory marked as accessible except shadow area itself.
Later free_all_bootmem() will release pages to buddy allocator
and these pages will be marked as unaccessible, untill somebody
will allocate them.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 init/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index bb1aed9..d06a636 100644
--- a/init/main.c
+++ b/init/main.c
@@ -78,6 +78,7 @@
 #include <linux/context_tracking.h>
 #include <linux/random.h>
 #include <linux/list.h>
+#include <linux/kasan.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -549,7 +550,7 @@ asmlinkage __visible void __init start_kernel(void)
 			   set_init_arg);
 
 	jump_label_init();
-
+	kasan_init_shadow();
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
-- 
1.8.5.5

