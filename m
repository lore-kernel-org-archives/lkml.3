Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab3LMWsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:48:18 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:33802 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514Ab3LMW00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:26 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 013/115] gpu: ion: ion_system_heap: Change allocations to GFP_HIGHUSER
Date: Fri, 13 Dec 2013 14:23:47 -0800
Message-Id: <1386973529-4884-14-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Previously the ion_system_heap was using GFP_KERNEL, forcing all allocations
to be in lowmem.  This quickly causes us to run out of lowmem.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3383a88..35b3726 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -40,7 +40,7 @@ static int ion_system_heap_allocate(struct ion_heap *heap,
 		goto err0;
 	for_each_sg(table->sgl, sg, table->nents, i) {
 		struct page *page;
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
 		if (!page)
 			goto err1;
 		sg_set_page(sg, page, PAGE_SIZE, 0);
-- 
1.8.3.2

