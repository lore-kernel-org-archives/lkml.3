Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3CAAoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59172 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537Ab3CAAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:44:26 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 29/30] staging: sync: Don't log wait timeouts when timeout = 0
Date: Thu, 28 Feb 2013 16:43:25 -0800
Message-Id: <1362098606-26469-30-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

If the timeout is zero, don't trip the timeout debugging

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
 drivers/staging/android/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index bd18c75..9b8b0e9 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -616,7 +616,7 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 		return fence->status;
 	}
 
-	if (fence->status == 0) {
+	if (fence->status == 0 && timeout > 0) {
 		pr_info("fence timeout on [%p] after %dms\n", fence,
 			jiffies_to_msecs(timeout));
 		sync_dump();
-- 
1.7.10.4

