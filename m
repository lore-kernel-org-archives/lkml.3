Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3CAAoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:39 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:38031 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3CAAo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:27 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jamie Gennis <jgennis@google.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Erik Gilling <konkers@android.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 30/30] staging: sync: Fix timeout = 0 wait behavior
Date: Thu, 28 Feb 2013 16:43:26 -0800
Message-Id: <1362098606-26469-31-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jamie Gennis <jgennis@google.com>

Fix wait behavior on timeout == 0 case

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Jamie Gennis <jgennis@google.com>
[jstultz: Added commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 9b8b0e9..b9bb974 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -616,10 +616,12 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 		return fence->status;
 	}
 
-	if (fence->status == 0 && timeout > 0) {
-		pr_info("fence timeout on [%p] after %dms\n", fence,
-			jiffies_to_msecs(timeout));
-		sync_dump();
+	if (fence->status == 0) {
+		if (timeout > 0) {
+			pr_info("fence timeout on [%p] after %dms\n", fence,
+				jiffies_to_msecs(timeout));
+			sync_dump();
+		}
 		return -ETIME;
 	}
 
-- 
1.7.10.4

