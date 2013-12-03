Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3LCOEr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:04:47 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:45080 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3LCOEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:04:40 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 08/15] staging/lustre/build: fix compilation issue with is_compat_task
Date: Tue,  3 Dec 2013 21:58:46 +0800
Message-Id: <1386079133-6459-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

After removing LIBCFS_HAVE_IS_COMPAT_TASK test we have a
compilation issue with kernels configured without CONFIG_COMPAT.

Lustre-change: http://review.whamcloud.com/7118
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/lustre/llite/llite_internal.h   |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index c326ff2..b6a22b6 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -650,7 +650,12 @@ static inline int ll_need_32bit_api(struct ll_sb_info *sbi)
 #if BITS_PER_LONG == 32
 	return 1;
 #else
-	return unlikely(is_compat_task() || (sbi->ll_flags & LL_SBI_32BIT_API));
+	return unlikely(
+#ifdef CONFIG_COMPAT
+		is_compat_task() ||
+#endif
+		(sbi->ll_flags & LL_SBI_32BIT_API)
+	);
 #endif
 }
 
-- 
1.7.9.5

