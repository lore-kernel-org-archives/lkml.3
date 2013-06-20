Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935708Ab3FTDjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:39:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25815 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935694Ab3FTDgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:36:40 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=YmshgJELKgYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=sRP8MWyoXXQA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=PHpoTpGJIJKG0C60QpcA:9 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=rToyBxrhR2Rdg8mJ:21 a=DocnwUXAyffPZPUT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130620033639.412979188@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 19 Jun 2013 23:35:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [for-next][PATCH 06/12] ftrace: Remove ftrace_regex_lseek()
References: <20130620033516.003166252@goodmis.org>
Content-Disposition: inline; filename=0006-ftrace-Remove-ftrace_regex_lseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

This is a leftover after ftrace_regex_lseek() was renamed to
ftrace_filter_lseek() and then ftrace_filter_lseek() was moved
out side of CONFIG_DYNAMIC_FTRACE.

Link: http://lkml.kernel.org/r/51B1A1BD.40905@huawei.com

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace.h |    4 ----
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
1.7.10.4


