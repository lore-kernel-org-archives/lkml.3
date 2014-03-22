Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751482AbaCVPru (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 11:47:50 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34922 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaCVPrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 11:47:47 -0400
Date: Sat, 22 Mar 2014 08:47:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Sanjay Lal <sanjayl@kymasys.com>,
        John Crispin <blogic@openwrt.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mips: export icache_flush_range
Message-ID: <20140322154720.GA23863@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lkdtm module performs tests against executable memory ranges, so
it needs to flush the icache for proper behaviors. Other architectures
already export this, so do the same for MIPS.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is currently untested! I'm building a MIPS cross-compiler now...
If someone can validate this fixes the build when lkdtm is a module,
that would be appreciated. :)
---
 arch/mips/mm/cache.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index fde7e56d13fe..b3f1df13d9f6 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -38,6 +38,7 @@ void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
 void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
 
 EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
+EXPORT_SYMBOL_GPL(flush_icache_range);
 
 /* MIPS specific cache operations */
 void (*flush_cache_sigtramp)(unsigned long addr);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
