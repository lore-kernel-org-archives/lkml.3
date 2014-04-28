Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaD1LEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 07:04:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41997 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbaD1LEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 07:04:10 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: roland@redhat.com, hpa@zytor.com, suresh.b.siddha@intel.com,
        palves@redhat.com, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH] ptrace: Fix PTRACE_GETREGSET/PTRACE_SETREGSET in code documentation
Date: Mon, 28 Apr 2014 16:30:53 +0530
Message-Id: <1398682853-7541-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042811-3864-0000-0000-00000DE707AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current documentation is bit misleading and does not explicitly
specify that iov.len need to be initialized failing which kernel
may just ignore the ptrace request and never read from/write into
the user specified buffer. This patch fixes the documentation.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 include/uapi/linux/ptrace.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index cf1019e..e9d6b37 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -43,8 +43,12 @@
  *
  *	ret = ptrace(PTRACE_GETREGSET/PTRACE_SETREGSET, pid, NT_XXX_TYPE, &iov);
  *
- * On the successful completion, iov.len will be updated by the kernel,
- * specifying how much the kernel has written/read to/from the user's iov.buf.
+ * A non-zero value upto the max size of data expected to be written/read by the
+ * kernel in response to any NT_XXX_TYPE request type must be assigned to iov.len
+ * before initiating the ptrace call. If iov.len is 0, then kernel will neither
+ * read from or write into the user buffer specified. On successful completion,
+ * iov.len will be updated by the kernel, specifying how much the kernel has
+ * written/read to/from the user's iov.buf.
  */
 #define PTRACE_GETREGSET	0x4204
 #define PTRACE_SETREGSET	0x4205
-- 
1.7.11.7

