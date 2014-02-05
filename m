Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaBEAKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:10:10 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48356 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbaBEAJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:24 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 7/7] staging: ion: Fix build warning
Date: Tue,  4 Feb 2014 16:08:40 -0800
Message-Id: <1391558920-31590-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add #include <linux/device.h> to fix the following warning seen
with gcc 4.7.3:

In file included from drivers/staging/android/ion/ion_heap.c:26:0:
drivers/staging/android/ion/ion_priv.h:358:21: warning: ‘struct device’ declared inside parameter list [enabled by default]
drivers/staging/android/ion/ion_priv.h:358:21: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_priv.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/ion_priv.h b/drivers/staging/android/ion/ion_priv.h
index d986739..fc2e4fc 100644
--- a/drivers/staging/android/ion/ion_priv.h
+++ b/drivers/staging/android/ion/ion_priv.h
@@ -17,6 +17,7 @@
 #ifndef _ION_PRIV_H
 #define _ION_PRIV_H
 
+#include <linux/device.h>
 #include <linux/dma-direction.h>
 #include <linux/kref.h>
 #include <linux/mm_types.h>
-- 
1.8.3.2

