Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbaKLDkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:40:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25696 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788AbaKLDkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 22:40:32 -0500
X-AuditID: cbfee61a-f79c06d000004e71-e5-5462d6aca7af
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Johannes Weiner'" <hannes@cmpxchg.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, mgorman@suse.de,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: mincore: add hwpoison page handle
Date: Wed, 12 Nov 2014 11:39:29 +0800
Message-id: <000001cffe2a$66a95a50$33fc0ef0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/+KkOAZZDPQdctThiXDX46vtKXRg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd0115JCDNr2iljMWb+GzWL1Jl+L
	y7vmsFncW/Of1WLyu2eMFn+vrGexeHLiP4sDu8fhN++ZPXbOusvusenTJHaPEzN+s3i833eV
	zWPz6WqPz5vkAtijuGxSUnMyy1KL9O0SuDI2/zzJUrCAvWLLrT+sDYx3WLsYOTkkBEwkZj59
	wgRhi0lcuLeeDcQWEpjOKHHnokoXIxeQ/YdRYsPDU+wgCTYBbYm7/RvBmkUEtCTW3z3GCFLE
	LPCAUeL8x99gCWEBM4lF266DTWIRUJVYc/MzWJxXwE5iz/QjULagxI/J91hAbGYBdYlJ8xYx
	Q9jyEpvXvAWyOYAuUpd49FcXYpeexNv139ggSsQlNh65xTKBUWAWkkmzkEyahWTSLCQtCxhZ
	VjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER8MzqR2MKxssDjEKcDAq8fAmrkkKEWJNLCuu
	zD3EKMHBrCTC+2ApUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvgVbrQCGB9MSS1OzU1ILUIpgs
	EwenVAOjeMrvY6vPPVx8+61Ek8syA6GIr557WrkrbZQiVx88v/PNgn01lbX176Y+Pr311jct
	QabgF8sl9hRI7OoN+NAncFOy+JNLtVK1v8ZufW7JWwt/Lrz4PvTEDj/P7Yy7KhRvXT+9et4N
	m5U8qU4sAtv5+q64Rv682eYQ8afou5XFqX6HFGux517aSizFGYmGWsxFxYkABSwur4ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When encounter pte is a swap entry, the current code handles two cases:
migration and normal swapentry, but we have a third case: hwpoison page.

This patch adds hwpoison page handle, consider hwpoison page incore as
same as migration.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/mincore.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 725c809..3545f13 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -137,8 +137,8 @@ static void mincore_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		} else { /* pte is a swap entry */
 			swp_entry_t entry = pte_to_swp_entry(pte);
 
-			if (is_migration_entry(entry)) {
-				/* migration entries are always uptodate */
+			if (non_swap_entry(entry)) {
+			/* migration or hwpoison entries are always uptodate */
 				*vec = 1;
 			} else {
 #ifdef CONFIG_SWAP
-- 
1.7.0.4


