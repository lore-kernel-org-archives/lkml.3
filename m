Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbaEMKTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:19:49 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933563AbaEMKLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 105/182] sh: fix format string bug in stack tracer
Date: Tue, 13 May 2014 11:27:37 +0200
Message-Id: <6171fefa1fc525b9d4a6465ce852126d416295ab.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a0c32761e73c9999cbf592b702f284221fea8040 upstream.

Kees reported the following error:

   arch/sh/kernel/dumpstack.c: In function 'print_trace_address':
   arch/sh/kernel/dumpstack.c:118:2: error: format not a string literal and no format arguments [-Werror=format-security]

Use the "%s" format so that it's impossible to interpret 'data' as a
format string.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Reported-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sh/kernel/dumpstack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/kernel/dumpstack.c b/arch/sh/kernel/dumpstack.c
index b959f5592604..8dfe645bcc4b 100644
--- a/arch/sh/kernel/dumpstack.c
+++ b/arch/sh/kernel/dumpstack.c
@@ -115,7 +115,7 @@ static int print_trace_stack(void *data, char *name)
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk(data);
+	printk("%s", (char *)data);
 	printk_address(addr, reliable);
 }
 
-- 
1.9.3

