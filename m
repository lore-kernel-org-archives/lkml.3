Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab3C2RuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:50:18 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:46968 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3C2RuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:50:16 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dmitry Pervushin <dmitry.pervushin@linaro.org>,
        Erik Gilling <konkers@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Bernhard=20Rosenkr=C3=A4nzer?= 
	<Bernhard.Rosenkranzer@linaro.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH] staging: sync: Add compat_ioctl handlers to sync drivers
Date: Fri, 29 Mar 2013 10:50:02 -0700
Message-Id: <1364579403-28621-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Pervushin <dmitry.pervushin@linaro.org>

The sync drivers are missing compat_ioctl handlers, so this
patch adds them.

Cc: Erik Gilling <konkers@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Dmitry Pervushin <dmitry.pervushin@linaro.org>
Cc: Bernhard Rosenkränzer <Bernhard.Rosenkranzer@linaro.org>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Dmitry Pervushin <dmitry.pervushin@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
This applies against staging-next.
The same change has been submitted to AOSP:
        https://android-review.googlesource.com/#/c/54901/
        Change-Id: If1a1ecc3952b321c8d64c6a8b050104859efc4b1

 drivers/staging/android/sw_sync.c |    1 +
 drivers/staging/android/sync.c    |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index ec7de30..4928f93 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -239,6 +239,7 @@ static const struct file_operations sw_sync_fops = {
 	.open = sw_sync_open,
 	.release = sw_sync_release,
 	.unlocked_ioctl = sw_sync_ioctl,
+	.compat_ioctl = sw_sync_ioctl,
 };
 
 static struct miscdevice sw_sync_dev = {
diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index bf66c19..3893a35 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -248,6 +248,7 @@ static const struct file_operations sync_fence_fops = {
 	.release = sync_fence_release,
 	.poll = sync_fence_poll,
 	.unlocked_ioctl = sync_fence_ioctl,
+	.compat_ioctl = sync_fence_ioctl,
 };
 
 static struct sync_fence *sync_fence_alloc(const char *name)
-- 
1.7.10.4

