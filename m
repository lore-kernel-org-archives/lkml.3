Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3LQFIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:08:05 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:62300 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3LQFIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:08:01 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH 1/3] staging: ion: Add HAVE_MEMBLOCK config dependency
Date: Mon, 16 Dec 2013 21:07:51 -0800
Message-Id: <1387256873-21350-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
References: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kbuild test robot reported a build issue w/ ION on m68k:

drivers/staging/android/ion/ion.c: In function 'ion_reserve':
drivers/staging/android/ion/ion.c:1526:4: error: implicit declaration of function 'memblock_alloc_base' [-Werror=implicit-function-declaration]
drivers/staging/android/ion/ion.c:1528:11: error: 'MEMBLOCK_ALLOC_ANYWHERE' undeclared (first use in this function)
drivers/staging/android/ion/ion.c:1528:11: note: each undeclared identifier is reported only once for each function it appears in
drivers/staging/android/ion/ion.c:1537:4: error: implicit declaration of function 'memblock_reserve' [-Werror=implicit-function-declaration]
   cc1: some warnings being treated as errors

This is caused by ION using memblock functionality which m68k doesn't support.

This patch adds a HAVE_MEMBLOCK dependency to the ION config.

Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index b95281e..a9a64ea 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ION
 	bool "Ion Memory Manager"
+	depends on HAVE_MEMBLOCK
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
 	---help---
-- 
1.8.3.2

