Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3LMWqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:46:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54203 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab3LMW0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:35 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Dima Zavin <dima@android.com>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 019/115] gpu: ion: do not ask for compound pages in system heap
Date: Fri, 13 Dec 2013 14:23:53 -0800
Message-Id: <1386973529-4884-20-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dima Zavin <dima@android.com>

Signed-off-by: Dima Zavin <dima@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 98711ce..3f607df 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -41,7 +41,7 @@ static struct page_info *alloc_largest_available(unsigned long size)
 	for (i = 0; i < ARRAY_SIZE(orders); i++) {
 		if (size < (1 << orders[i]) * PAGE_SIZE)
 			continue;
-		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO | __GFP_COMP |
+		page = alloc_pages(GFP_HIGHUSER | __GFP_ZERO |
 				   __GFP_NOWARN | __GFP_NORETRY, orders[i]);
 		if (!page)
 			continue;
-- 
1.8.3.2

