Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab3AURzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:55:51 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56231 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab3AURye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:54:34 -0500
Subject: [PATCH 3/5] use new pagetable helpers in try_preserve_large_page()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Mon, 21 Jan 2013 09:52:47 -0800
References: <20130121175244.E5839E06@kernel.stglabs.ibm.com>
In-Reply-To: <20130121175244.E5839E06@kernel.stglabs.ibm.com>
Message-Id: <20130121175247.76641034@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012117-9360-0000-0000-00000F8012A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


try_preserve_large_page() can be slightly simplified by using
the new page_level_*() helpers.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/mm/pageattr.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/pageattr.c~use-new-pagetable-helpers arch/x86/mm/pageattr.c
--- linux-2.6.git/arch/x86/mm/pageattr.c~use-new-pagetable-helpers	2013-01-17 10:22:26.282431407 -0800
+++ linux-2.6.git-dave/arch/x86/mm/pageattr.c	2013-01-17 10:22:26.286431442 -0800
@@ -412,15 +412,12 @@ try_preserve_large_page(pte_t *kpte, uns
 
 	switch (level) {
 	case PG_LEVEL_2M:
-		psize = PMD_PAGE_SIZE;
-		pmask = PMD_PAGE_MASK;
-		break;
 #ifdef CONFIG_X86_64
 	case PG_LEVEL_1G:
-		psize = PUD_PAGE_SIZE;
-		pmask = PUD_PAGE_MASK;
-		break;
 #endif
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+		break;
 	default:
 		do_split = -EINVAL;
 		goto out_unlock;
_

