Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3LMWp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:45:28 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53892 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3LMW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:26:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 024/115] gpu: ion: Only map as much of the vma as the user requested
Date: Fri, 13 Dec 2013 14:23:58 -0800
Message-Id: <1386973529-4884-25-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 3f607df..7397bc4 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -192,6 +192,8 @@ int ion_system_heap_map_user(struct ion_heap *heap, struct ion_buffer *buffer,
 		remap_pfn_range(vma, addr, page_to_pfn(sg_page(sg)),
 				sg_dma_len(sg), vma->vm_page_prot);
 		addr += sg_dma_len(sg);
+		if (addr >= vma->vm_end)
+			return 0;
 	}
 	return 0;
 }
-- 
1.8.3.2

