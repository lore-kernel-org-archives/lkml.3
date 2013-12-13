Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3LMWk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:40:28 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:34606 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab3LMW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:22 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 047/115] gpu: ion: fix carveout ops
Date: Fri, 13 Dec 2013 14:24:21 -0800
Message-Id: <1386973529-4884-48-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

when using carveout heap ion_buffer_create function failed because
map_dma and unmap_dma operations aren't set by carveout heap.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_carveout_heap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index daa348e..fd64168 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -142,6 +142,8 @@ static struct ion_heap_ops carveout_heap_ops = {
 	.allocate = ion_carveout_heap_allocate,
 	.free = ion_carveout_heap_free,
 	.phys = ion_carveout_heap_phys,
+	.map_dma = ion_carveout_heap_map_dma,
+	.unmap_dma = ion_carveout_heap_unmap_dma,
 	.map_user = ion_carveout_heap_map_user,
 	.map_kernel = ion_carveout_heap_map_kernel,
 	.unmap_kernel = ion_carveout_heap_unmap_kernel,
-- 
1.8.3.2

