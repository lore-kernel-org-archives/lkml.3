Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3LNUG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:06:58 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37104 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab3LNUG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:06:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/2] ion: Don't allow building ION as a module.
Date: Sat, 14 Dec 2013 12:06:45 -0800
Message-Id: <1387051606-10440-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20131214170618.GA17461@kroah.com>
References: <20131214170618.GA17461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ION doesn't export the proper symbols for it to be a module. This
causes build issues when ION is configured as a module.

Since Andorid kernels rarely use modules (I think recent policy
requires no modules?), go ahead and set the ION config to a bool
from the tristate option.

If folks decide ION as a module is important, we will have to go
through and export the various needed symbols.

Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index a342d96..b95281e 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -1,5 +1,5 @@
 menuconfig ION
-	tristate "Ion Memory Manager"
+	bool "Ion Memory Manager"
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
 	---help---
-- 
1.8.3.2

