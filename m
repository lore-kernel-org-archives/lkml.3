Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3FGJEt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:04:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:29254 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab3FGJEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:04:46 -0400
Message-ID: <51B1A1BD.40905@huawei.com>
Date: Fri, 7 Jun 2013 17:02:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftrace: Remove ftrace_regex_lseek()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a leftover after ftrace_regex_lseek() was renamed to
ftrace_filter_lseek() and then ftrace_filter_lseek() was moved
out side of CONFIG_DYNAMIC_FTRACE.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/ftrace.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 99d0fbc..e48ed1d 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -566,10 +566,6 @@ static inline ssize_t ftrace_filter_write(struct file *file, const char __user *
 			    size_t cnt, loff_t *ppos) { return -ENODEV; }
 static inline ssize_t ftrace_notrace_write(struct file *file, const char __user *ubuf,
 			     size_t cnt, loff_t *ppos) { return -ENODEV; }
-static inline loff_t ftrace_regex_lseek(struct file *file, loff_t offset, int whence)
-{
-	return -ENODEV;
-}
 static inline int
 ftrace_regex_release(struct inode *inode, struct file *file) { return -ENODEV; }
 #endif /* CONFIG_DYNAMIC_FTRACE */
-- 
1.8.0.2
