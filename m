Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaAFMpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:45:30 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56627 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaAFMp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:45:29 -0500
Date: Mon, 6 Jan 2014 15:42:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -next] e820: use NUMA_NO_NODE in memblock_find_dma_reserve()
Message-ID: <20140106124239.GB2247@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 68abcdf54742a ("mm/memblock: use WARN_ONCE when MAX_NUMNODES
passed as input parameter") has deprecated usage of MAX_NUMNODES
in __next_free_mem_range(). Pass NUMA_NO_NODE to for_each_free_mem_range().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 arch/x86/kernel/e820.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 174da5f..988c00a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1120,7 +1120,7 @@ void __init memblock_find_dma_reserve(void)
 		nr_pages += end_pfn - start_pfn;
 	}
 
-	for_each_free_mem_range(u, MAX_NUMNODES, &start, &end, NULL) {
+	for_each_free_mem_range(u, NUMA_NO_NODE, &start, &end, NULL) {
 		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
 		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
 		if (start_pfn < end_pfn)

