Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3CAArd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:47:33 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:42410 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab3CAAoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:12 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 20/30] staging: sync: Improve timeout dump messages
Date: Thu, 28 Feb 2013 16:43:16 -0800
Message-Id: <1362098606-26469-21-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Improve the output of the timeout dumps, including
the fence pointer.

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
[jstultz: Added commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index d54fa8d..92cdfe8 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -576,6 +576,8 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 		return fence->status;
 
 	if (fence->status == 0) {
+		pr_info("fence timeout on [%p] after %dms\n", fence,
+			jiffies_to_msecs(timeout));
 		sync_dump();
 		return -ETIME;
 	}
@@ -849,7 +851,8 @@ static void sync_print_fence(struct seq_file *s, struct sync_fence *fence)
 	struct list_head *pos;
 	unsigned long flags;
 
-	seq_printf(s, "%s: %s\n", fence->name, sync_status_str(fence->status));
+	seq_printf(s, "[%p] %s: %s\n", fence, fence->name,
+		   sync_status_str(fence->status));
 
 	list_for_each(pos, &fence->pt_list_head) {
 		struct sync_pt *pt =
-- 
1.7.10.4

