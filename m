Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaLKM0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:26:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbaLKM0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:26:46 -0500
Date: Thu, 11 Dec 2014 04:26:28 -0800
From: tip-bot for Xishi Qiu <tipbot@zytor.com>
Message-ID: <tip-29258cf49eb794f00989fc47da8700759a42778b@git.kernel.org>
Cc: mingo@kernel.org, riel@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dave@sr71.net,
        tglx@linutronix.de, qiuxishi@huawei.com, linux-mm@kvack.org
Reply-To: mingo@kernel.org, riel@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, dave@sr71.net,
        tglx@linutronix.de, linux-mm@kvack.org, qiuxishi@huawei.com
In-Reply-To: <5487AB3F.7050807@huawei.com>
References: <5487AB3F.7050807@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm: Use min() instead of min_t()
  in the e820 printout code
Git-Commit-ID: 29258cf49eb794f00989fc47da8700759a42778b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29258cf49eb794f00989fc47da8700759a42778b
Gitweb:     http://git.kernel.org/tip/29258cf49eb794f00989fc47da8700759a42778b
Author:     Xishi Qiu <qiuxishi@huawei.com>
AuthorDate: Wed, 10 Dec 2014 10:09:03 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 11 Dec 2014 11:35:02 +0100

x86/mm: Use min() instead of min_t() in the e820 printout code

The type of "MAX_DMA_PFN" and "xXx_pfn" are both unsigned long
now, so use min() instead of min_t().

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Linux MM <linux-mm@kvack.org>
Cc: <dave@sr71.net>
Cc: Rik van Riel <riel@redhat.com>
Link: http://lkml.kernel.org/r/5487AB3F.7050807@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/e820.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 49f8864..dd2f07a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1114,8 +1114,8 @@ void __init memblock_find_dma_reserve(void)
 	 * at first, and assume boot_mem will not take below MAX_DMA_PFN
 	 */
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
-		start_pfn = min_t(unsigned long, start_pfn, MAX_DMA_PFN);
-		end_pfn = min_t(unsigned long, end_pfn, MAX_DMA_PFN);
+		start_pfn = min(start_pfn, MAX_DMA_PFN);
+		end_pfn = min(end_pfn, MAX_DMA_PFN);
 		nr_pages += end_pfn - start_pfn;
 	}
 
