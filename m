Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LQAs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:48:28 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:57491 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3LQAs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:48:26 -0500
From: Colin Cross <ccross@android.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Colin Cross <ccross@android.com>
Subject: [PATCH] ion: remove ion_user_handle_t from ion_test.h
Date: Mon, 16 Dec 2013 16:48:17 -0800
Message-Id: <1387241297-22280-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ion_test.h should not define ion_user_handle_t, and defining it
causes a warning:
In file included from drivers/staging/android/ion/ion_test.c:31:
drivers/staging/android/ion/../uapi/ion_test.h:23: error: redefinition of typedef 'ion_user_handle_t'
drivers/staging/android/ion/../uapi/ion.h:23: note: previous declaration of 'ion_user_handle_t' was here

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Colin Cross <ccross@android.com>
---
 drivers/staging/android/uapi/ion_test.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/android/uapi/ion_test.h b/drivers/staging/android/uapi/ion_test.h
index 352379a02690..614d1e36f72c 100644
--- a/drivers/staging/android/uapi/ion_test.h
+++ b/drivers/staging/android/uapi/ion_test.h
@@ -20,8 +20,6 @@
 #include <linux/ioctl.h>
 #include <linux/types.h>
 
-typedef int ion_user_handle_t;
-
 /**
  * struct ion_test_rw_data - metadata passed to the kernel to read handle
  * @ptr:	a pointer to an area at least as large as size
-- 
1.8.5.1

