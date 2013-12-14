Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995Ab3LND2C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:28:02 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41008 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3LND1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:27:15 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 111/115] ion: add alignment check to chunk heap
Date: Fri, 13 Dec 2013 19:26:31 -0800
Message-Id: <1386991595-6251-19-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386991595-6251-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Signed-off-by: Colin Cross <ccross@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_chunk_heap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion_chunk_heap.c b/drivers/staging/android/ion/ion_chunk_heap.c
index f21530f..a072089 100644
--- a/drivers/staging/android/ion/ion_chunk_heap.c
+++ b/drivers/staging/android/ion/ion_chunk_heap.c
@@ -47,6 +47,9 @@ static int ion_chunk_heap_allocate(struct ion_heap *heap,
 	unsigned long num_chunks;
 	unsigned long allocated_size;
 
+	if (align > chunk_heap->chunk_size)
+		return -EINVAL;
+
 	allocated_size = ALIGN(size, chunk_heap->chunk_size);
 	num_chunks = allocated_size / chunk_heap->chunk_size;
 
-- 
1.8.3.2

