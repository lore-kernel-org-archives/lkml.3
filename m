Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaCHVf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 16:35:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39695 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaCHVf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 16:35:26 -0500
Message-ID: <531B8D32.6000000@gmail.com>
Date: Sun, 09 Mar 2014 05:35:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/avr32/mm/cache.c: export symbol flush_icache_range()
 for module using
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export symbol flush_icache_range() to modules, just like another
platforms have done, or can not pass compiling.

The related error (with allmodconfig under avr32):

  ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/avr32/mm/cache.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
index 6a46ecd..85d635c 100644
--- a/arch/avr32/mm/cache.c
+++ b/arch/avr32/mm/cache.c
@@ -111,6 +111,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
 	__flush_icache_range(start & ~(linesz - 1),
 			     (end + linesz - 1) & ~(linesz - 1));
 }
+EXPORT_SYMBOL(flush_icache_range);
 
 /*
  * This one is called from __do_fault() and do_swap_page().
-- 
1.7.11.7

