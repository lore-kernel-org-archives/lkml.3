Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3LMW2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:28:09 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50415 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab3LMW2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:02 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 073/115] ion: add free list size to heap debug files
Date: Fri, 13 Dec 2013 14:24:47 -0800
Message-Id: <1386973529-4884-74-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Cross <ccross@android.com>

Signed-off-by: Colin Cross <ccross@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 38d65c2..93b84a9 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1286,6 +1286,9 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 	seq_printf(s, "%16.s %16u\n", "total orphaned",
 		   total_orphaned_size);
 	seq_printf(s, "%16.s %16u\n", "total ", total_size);
+	if (heap->flags & ION_HEAP_FLAG_DEFER_FREE)
+		seq_printf(s, "%16.s %16u\n", "deferred free",
+				heap->free_list_size);
 	seq_printf(s, "----------------------------------------------------\n");
 
 	if (heap->debug_show)
-- 
1.8.3.2

