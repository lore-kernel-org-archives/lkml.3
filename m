Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaGII4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:56:48 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:53495 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887AbaGII4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:56:43 -0400
Message-ID: <53BD03C4.3060202@gmail.com>
Date: Wed, 09 Jul 2014 16:56:36 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/mm/cache.c: Export 'flush_icache_range'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The related error (with allmodconfig under score):

    MODPOST 1365 modules
  ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/mm/cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/score/mm/cache.c b/arch/score/mm/cache.c
index be91041..b4bcfd3 100644
--- a/arch/score/mm/cache.c
+++ b/arch/score/mm/cache.c
@@ -278,3 +278,4 @@ void flush_icache_range(unsigned long start, unsigned long end)
 		start += L1_CACHE_BYTES;
 	}
 }
+EXPORT_SYMBOL(flush_icache_range);
-- 
1.9.2.459.g68773ac
