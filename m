Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3LND1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:27:39 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45058 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3LND05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:26:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 100/115] ion: add alignment check to carveout heap
Date: Fri, 13 Dec 2013 19:26:20 -0800
Message-Id: <1386991595-6251-8-git-send-email-john.stultz@linaro.org>
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
 drivers/staging/android/ion/ion_carveout_heap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion_carveout_heap.c b/drivers/staging/android/ion/ion_carveout_heap.c
index 1d53e91..b0b08c3 100644
--- a/drivers/staging/android/ion/ion_carveout_heap.c
+++ b/drivers/staging/android/ion/ion_carveout_heap.c
@@ -70,6 +70,9 @@ static int ion_carveout_heap_allocate(struct ion_heap *heap,
 				      unsigned long size, unsigned long align,
 				      unsigned long flags)
 {
+	if (align > PAGE_SIZE)
+		return -EINVAL;
+
 	buffer->priv_phys = ion_carveout_allocate(heap, size, align);
 	return buffer->priv_phys == ION_CARVEOUT_ALLOCATE_FAIL ? -ENOMEM : 0;
 }
-- 
1.8.3.2

