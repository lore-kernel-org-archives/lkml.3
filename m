Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaGIIsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:48:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58984 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaGIIsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:48:52 -0400
Message-ID: <53BD01ED.30802@gmail.com>
Date: Wed, 09 Jul 2014 16:48:45 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: score: Export necessary symbols in related files
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'csum_partial_copy_from_user' and 'flush_dcache_page' are also needed by
outside modules, so need export them in the related files.

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "csum_partial_copy_from_user" [net/rxrpc/af-rxrpc.ko] undefined!
  ERROR: "flush_dcache_page" [net/sunrpc/sunrpc.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/lib/checksum_copy.c | 1 +
 arch/score/mm/cache.c          | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/score/lib/checksum_copy.c b/arch/score/lib/checksum_copy.c
index 04565dd..9b770b3 100644
--- a/arch/score/lib/checksum_copy.c
+++ b/arch/score/lib/checksum_copy.c
@@ -50,3 +50,4 @@ unsigned int csum_partial_copy_from_user(const char *src, char *dst,
 
 	return csum_partial(dst, len, sum);
 }
+EXPORT_SYMBOL(csum_partial_copy_from_user);
diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
index f85ec1a..be91041 100644
--- a/arch/score/mm/cache.c
+++ b/arch/score/mm/cache.c
@@ -72,6 +72,7 @@ void flush_dcache_page(struct page *page)
 	addr = (unsigned long) page_address(page);
 	flush_data_cache_page(addr);
 }
+EXPORT_SYMBOL(flush_dcache_page);
 
 /* called by update_mmu_cache. */
 void __update_cache(struct vm_area_struct *vma, unsigned long address,
-- 
1.9.2.459.g68773ac
