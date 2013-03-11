Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3CKHO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:61178 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3CKHOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:23 -0400
Message-ID: <513D842F.40205@huawei.com>
Date: Mon, 11 Mar 2013 15:13:51 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 05/13] tracing: change unclear comments on arch_syscall_match_sym_name
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ppc64 have its own syscall prefix like ".SyS" or ".sys",
make this clear in comments of arch_syscall_match_sym_name.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_syscalls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 7a809e3..d24a84c 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -41,7 +41,7 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 	/*
 	 * Only compare after the "sys" prefix. Archs that use
 	 * syscall wrappers may have syscalls symbols aliases prefixed
-	 * with "SyS" instead of "sys", leading to an unwanted
+	 * with ".SyS" or ".sys" instead of "sys", leading to an unwanted
 	 * mismatch.
 	 */
 	return !strcmp(sym + 3, name + 3);
-- 
1.7.9.7


