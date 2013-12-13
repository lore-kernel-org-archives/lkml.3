Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3LMWj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:39:57 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53438 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab3LMW1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 048/115] gpu: ion: fix compilation warning
Date: Fri, 13 Dec 2013 14:24:22 -0800
Message-Id: <1386973529-4884-49-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@linaro.org>

use atomic_read to get the refcount value to avoid compilation warning

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index ef8f132..e0eb2de 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1233,7 +1233,8 @@ static int ion_debug_heap_show(struct seq_file *s, void *unused)
 		total_size += buffer->size;
 		if (!buffer->handle_count) {
 			seq_printf(s, "%16.s %16u %16u %d %d\n", buffer->task_comm,
-				   buffer->pid, buffer->size, buffer->kmap_cnt, buffer->ref);
+				   buffer->pid, buffer->size, buffer->kmap_cnt,
+				   atomic_read(&buffer->ref.refcount));
 			total_orphaned_size += buffer->size;
 		}
 	}
-- 
1.8.3.2

