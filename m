Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3H3H5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 03:57:31 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31082 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab3H3H53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 03:57:29 -0400
X-Spam-Score: -100.9
Message-ID: <52205027.6070704@asianux.com>
Date: Fri, 30 Aug 2013 15:56:23 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] h8300: include: asm: add default 'ioremap_wc' definition
 in "io.h"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

h8300 does not implement ioremap_wc(), but implement ioremap(), need
define ioremap_wc() just like "asm-generic/io.h" to pass compiling.

The related error (allmodconfig for h8300):

  drivers/video/uvesafb.c: In function 'uvesafb_ioremap':
  drivers/video/uvesafb.c:1563:2: error: implicit declaration of function 'ioremap_wc' [-Werror=implicit-function-declaration]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/h8300/include/asm/io.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/h8300/include/asm/io.h b/arch/h8300/include/asm/io.h
index c1a8df2..0bf4577 100644
--- a/arch/h8300/include/asm/io.h
+++ b/arch/h8300/include/asm/io.h
@@ -262,6 +262,14 @@ static inline void *ioremap_fullcache(unsigned long physaddr, unsigned long size
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
+#ifndef ioremap_nocache
+#define ioremap_nocache ioremap
+#endif
+
+#ifndef ioremap_wc
+#define ioremap_wc ioremap_nocache
+#endif
+
 extern void iounmap(void *addr);
 
 /* H8/300 internal I/O functions */
-- 
1.7.7.6
