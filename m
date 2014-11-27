Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaK0M5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:57:15 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:56596 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbaK0M5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:57:13 -0500
Message-ID: <1417093031.29407.102.camel@x220>
Subject: [PATCH next-20141127] mm: Fix comment typo "CONFIG_TRANSPARNTE_HUGE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 13:57:11 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2014 12:57:11.0383 (UTC) FILETIME=[A8BC9E70:01D00A41]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "mm: don't split THP page when syscall is called" added a
reference to CONFIG_TRANSPARNTE_HUGE in a comment. Use
CONFIG_TRANSPARENT_HUGEPAGE instead, as was probably intended.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested.

If commit "mm: don't split THP page when syscall is called" is not yet
set in stone, I would prefer if this trivial fix would be squashed into
that commit.

 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d2a6e136b08d..95d394bbb6ab 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -708,7 +708,7 @@ static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
 		/*
 		 * Use pmd_freeable instead of raw pmd_dirty because in some
 		 * of architecture, pmd_dirty is not defined unless
-		 * CONFIG_TRANSPARNTE_HUGE is enabled
+		 * CONFIG_TRANSPARENT_HUGEPAGE is enabled
 		 */
 		if (!pmd_freeable(*pmd))
 			dirty++;
-- 
1.9.3

