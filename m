Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3EZGo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:44:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:45672 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab3EZGo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:44:26 -0400
Message-ID: <51A1AF3E.6000707@gmail.com>
Date: Sun, 26 May 2013 14:44:14 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Simon Horman <horms@verge.net.au>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH v2 6/7] ia64: Remove setting for saved_max_pfn
References: <51A1AC4A.60506@gmail.com>
In-Reply-To: <51A1AC4A.60506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The only user of saved_max_pfn in ia64 is read_oldmem interface but we
have removed that interface, so saved_max_pfn is now unneeded in ia64,
and we needn't set it anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/kernel/efi.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index f034563..51bce59 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -1116,11 +1116,6 @@ efi_memmap_init(u64 *s, u64 *e)
 		if (!is_memory_available(md))
 			continue;
 
-#ifdef CONFIG_CRASH_DUMP
-		/* saved_max_pfn should ignore max_addr= command line arg */
-		if (saved_max_pfn < (efi_md_end(md) >> PAGE_SHIFT))
-			saved_max_pfn = (efi_md_end(md) >> PAGE_SHIFT);
-#endif
 		/*
 		 * Round ends inward to granule boundaries
 		 * Give trimmings to uncached allocator
-- 
1.7.1

