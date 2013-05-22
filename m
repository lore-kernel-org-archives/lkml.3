Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3EVKN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:13:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab3EVKNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:13:23 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v4 3/6] staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
Date: Wed, 22 May 2013 11:12:58 +0100
Message-Id: <1369217581-16285-4-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
References: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change will fix the BINDER_SET_MAX_THREADS ioctl to use __u32
instead of size_t for setting the max threads. Thus using the same
handler for 32 and 64bit kernels.

This value is stored internally in struct binder_proc and set to 15
on open_binder() in the libbinder API(thus no need for a 64bit size_t
on 64bit platforms).

The change does not affect existing 32bit ABI.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index 2f94d16..1761541 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -86,7 +86,7 @@ struct binder_version {
 
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
 #define	BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
-#define	BINDER_SET_MAX_THREADS		_IOW('b', 5, size_t)
+#define	BINDER_SET_MAX_THREADS		_IOW('b', 5, __u32)
 #define	BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
 #define	BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
 #define	BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
-- 
1.7.9.5

