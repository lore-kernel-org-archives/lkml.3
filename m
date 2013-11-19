Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3KSOnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:43:01 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41053 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3KSOmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:42:55 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 11/13] staging/lustre: get_cpu is always defined
Date: Tue, 19 Nov 2013 22:38:45 +0800
Message-Id: <1384871927-8553-12-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
References: <1384871927-8553-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/kp30.h       |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 44f490c..e6f03c7 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -206,18 +206,6 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 
 /* compat macroses */
 
-
-#ifndef get_cpu
-# ifdef CONFIG_PREEMPT
-#  define get_cpu()  ({ preempt_disable(); smp_processor_id(); })
-#  define put_cpu()  preempt_enable()
-# else
-#  define get_cpu()  smp_processor_id()
-#  define put_cpu()
-# endif
-#else
-#endif /* get_cpu & put_cpu */
-
 #define INIT_CTL_NAME(a)
 #define INIT_STRATEGY(a)
 
-- 
1.7.9.5

