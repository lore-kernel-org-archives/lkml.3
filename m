Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab3DDMcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:32:50 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64422 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759780Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 2/8] staging: android: binder: replace IOCTL types with user-exportable types
Date: Thu,  4 Apr 2013 13:32:32 +0100
Message-Id: <1365078758-28674-3-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the IOCTL macros to use user-exportable data types,
as they are the referred kernel types for the user/kernel interface.

The patch does not change in any way the functionality of the binder driver.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index f240464..dbe81ce 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -85,11 +85,11 @@ struct binder_version {
 #define BINDER_CURRENT_PROTOCOL_VERSION 7
 
 #define BINDER_WRITE_READ		_IOWR('b', 1, struct binder_write_read)
-#define	BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, int64_t)
+#define	BINDER_SET_IDLE_TIMEOUT		_IOW('b', 3, __s64)
 #define	BINDER_SET_MAX_THREADS		_IOW('b', 5, size_t)
-#define	BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, int)
-#define	BINDER_SET_CONTEXT_MGR		_IOW('b', 7, int)
-#define	BINDER_THREAD_EXIT		_IOW('b', 8, int)
+#define	BINDER_SET_IDLE_PRIORITY	_IOW('b', 6, __s32)
+#define	BINDER_SET_CONTEXT_MGR		_IOW('b', 7, __s32)
+#define	BINDER_THREAD_EXIT		_IOW('b', 8, __s32)
 #define BINDER_VERSION			_IOWR('b', 9, struct binder_version)
 
 /*
-- 
1.7.9.5

