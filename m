Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3LMW1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:25 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53817 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3LMW1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:16 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 043/115] gpu: ion: Clear GFP_WAIT flag on high order allocations
Date: Fri, 13 Dec 2013 14:24:17 -0800
Message-Id: <1386973529-4884-44-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rebecca Schultz Zavin <rebecca@android.com>

This will prevent the kernel from kicking off compaction
when higher order allocations are made.  Instead we will
get these high order allocations only if they are readily
available.

Signed-off-by: Rebecca Schultz Zavin <rebecca@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/ion_system_heap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/ion/ion_system_heap.c b/drivers/staging/android/ion/ion_system_heap.c
index 2204206..ad4933e 100644
--- a/drivers/staging/android/ion/ion_system_heap.c
+++ b/drivers/staging/android/ion/ion_system_heap.c
@@ -28,7 +28,7 @@
 
 static unsigned int high_order_gfp_flags = (GFP_HIGHUSER | __GFP_ZERO |
 					    __GFP_NOWARN | __GFP_NORETRY |
-					    __GFP_NO_KSWAPD);
+					    __GFP_NO_KSWAPD) & ~__GFP_WAIT;
 static unsigned int low_order_gfp_flags  = (GFP_HIGHUSER | __GFP_ZERO |
 					 __GFP_NOWARN);
 static const unsigned int orders[] = {8, 4, 0};
-- 
1.8.3.2

