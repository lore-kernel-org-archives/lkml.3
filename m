Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3B0GIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:08:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39604 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab3B0GIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:08:04 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 2/5] staging: android: lowmemorykiller: Don't count reserved free memory
Date: Tue, 26 Feb 2013 22:07:35 -0800
Message-Id: <1361945258-24420-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
References: <1361945258-24420-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arve Hjønnevåg <arve@android.com>

The amount of reserved memory varies between devices. Subtract it
here to reduce the amount of devices specific tuning needed for the
minfree values.

Cc: Android Kernel Team <kernel-team@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/lowmemorykiller.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index 7e00bdb..2f28763 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -35,6 +35,7 @@
 #include <linux/mm.h>
 #include <linux/oom.h>
 #include <linux/sched.h>
+#include <linux/swap.h>
 #include <linux/rcupdate.h>
 #include <linux/profile.h>
 #include <linux/notifier.h>
@@ -74,7 +75,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 	int selected_tasksize = 0;
 	short selected_oom_score_adj;
 	int array_size = ARRAY_SIZE(lowmem_adj);
-	int other_free = global_page_state(NR_FREE_PAGES);
+	int other_free = global_page_state(NR_FREE_PAGES) - totalreserve_pages;
 	int other_file = global_page_state(NR_FILE_PAGES) -
 						global_page_state(NR_SHMEM);
 
-- 
1.7.10.4

