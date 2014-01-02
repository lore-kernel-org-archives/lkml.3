Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaABVxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:53:48 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33108 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaABVxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:53:40 -0500
From: Laura Abbott <lauraa@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kyungmin Park <kmpark@infradead.org>, Dave Hansen <dave@sr71.net>,
        linux-mm@kvack.org, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Laura Abbott <lauraa@codeaurora.org>
Subject: [RFC PATCHv3 03/11] percpu: use VMALLOC_TOTAL instead of VMALLOC_END - VMALLOC_START
Date: Thu,  2 Jan 2014 13:53:21 -0800
Message-Id: <1388699609-18214-4-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
References: <1388699609-18214-1-git-send-email-lauraa@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc already gives a useful macro to calculate the total vmalloc
size. Use it.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 mm/percpu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 0d10def..afbf352 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1686,10 +1686,10 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 	max_distance += ai->unit_size;
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
-	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
+	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
 		pr_warning("PERCPU: max_distance=0x%zx too large for vmalloc "
 			   "space 0x%lx\n", max_distance,
-			   (unsigned long)(VMALLOC_END - VMALLOC_START));
+			   VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
 		/* and fail if we have fallback */
 		rc = -EINVAL;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

