Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaE0AIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:08:12 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49960 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaE0AIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:08:10 -0400
Message-ID: <5383D766.7070106@gmail.com>
Date: Tue, 27 May 2014 08:08:06 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] arch: unicore32: ksyms: export '__cpuc_coherent_kern_range'
 to avoid compiling failure
References: <5383D5F5.2000303@gmail.com>
In-Reply-To: <5383D5F5.2000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_icache_range() is '__cpuc_coherent_kern_range' under unicore32,
and lkdtm.ko needs it. At present, '__cpuc_coherent_kern_range' is
still used by unicore32, so export it to avoid compiling failure.

The related error (with allmodconfig under unicore32):

  ERROR: "__cpuc_coherent_kern_range" [drivers/misc/lkdtm.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/mm/proc-syms.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/unicore32/mm/proc-syms.c b/arch/unicore32/mm/proc-syms.c
index f30071e..21c00fc 100644
--- a/arch/unicore32/mm/proc-syms.c
+++ b/arch/unicore32/mm/proc-syms.c
@@ -19,5 +19,7 @@
 EXPORT_SYMBOL(cpu_dcache_clean_area);
 EXPORT_SYMBOL(cpu_set_pte);
 
+EXPORT_SYMBOL(__cpuc_coherent_kern_range);
+
 EXPORT_SYMBOL(__cpuc_dma_flush_range);
 EXPORT_SYMBOL(__cpuc_dma_clean_range);
-- 
1.9.2.459.g68773ac
