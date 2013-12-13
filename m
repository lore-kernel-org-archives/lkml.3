Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3LMWbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:31:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57700 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3LMW2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:28:11 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rom Lemarchand <romlem@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 080/115] ion: change ion_user_handle_t definition to int
Date: Fri, 13 Dec 2013 14:24:54 -0800
Message-Id: <1386973529-4884-81-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rom Lemarchand <romlem@google.com>

Turn ion_user_handle_t to int. This change reflects the underlying type
returned by the ion driver.

Signed-off-by: Rom Lemarchand <romlem@google.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion.c | 8 ++++----
 drivers/staging/android/ion/ion.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index e2a3033..1c40b74 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1139,7 +1139,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle))
 			return PTR_ERR(handle);
 
-		data.handle = (ion_user_handle_t)handle->id;
+		data.handle = handle->id;
 
 		if (copy_to_user((void __user *)arg, &data, sizeof(data))) {
 			ion_free(client, handle);
@@ -1156,7 +1156,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 				   sizeof(struct ion_handle_data)))
 			return -EFAULT;
 		mutex_lock(&client->lock);
-		handle = ion_uhandle_get(client, (int)data.handle);
+		handle = ion_uhandle_get(client, data.handle);
 		mutex_unlock(&client->lock);
 		if (!handle)
 			return -EINVAL;
@@ -1171,7 +1171,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		if (copy_from_user(&data, (void __user *)arg, sizeof(data)))
 			return -EFAULT;
-		handle = ion_uhandle_get(client, (int)data.handle);
+		handle = ion_uhandle_get(client, data.handle);
 		data.fd = ion_share_dma_buf_fd(client, handle);
 		if (copy_to_user((void __user *)arg, &data, sizeof(data)))
 			return -EFAULT;
@@ -1191,7 +1191,7 @@ static long ion_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		if (IS_ERR(handle))
 			ret = PTR_ERR(handle);
 		else
-			data.handle = (ion_user_handle_t)handle->id;
+			data.handle = handle->id;
 
 		if (copy_to_user((void __user *)arg, &data,
 				 sizeof(struct ion_fd_data)))
diff --git a/drivers/staging/android/ion/ion.h b/drivers/staging/android/ion/ion.h
index 244f085..d979890 100644
--- a/drivers/staging/android/ion/ion.h
+++ b/drivers/staging/android/ion/ion.h
@@ -19,8 +19,7 @@
 
 #include <linux/types.h>
 
-struct ion_handle;
-typedef struct ion_handle *ion_user_handle_t;
+typedef int ion_user_handle_t;
 
 /**
  * enum ion_heap_types - list of all possible types of heaps
@@ -65,6 +64,7 @@ enum ion_heap_type {
 					   caches must be managed manually */
 
 #ifdef __KERNEL__
+struct ion_handle;
 struct ion_device;
 struct ion_heap;
 struct ion_mapper;
-- 
1.8.3.2

