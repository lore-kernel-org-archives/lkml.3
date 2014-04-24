Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaDXJn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:43:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaDXIzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matt Fleming <matt.fleming@intel.com>, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 123/182] sh: fix format string bug in stack tracer
Date: Thu, 24 Apr 2014 09:50:48 +0100
Message-Id: <1398329507-5911-124-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sh/kernel/dumpstack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/kernel/dumpstack.c b/arch/sh/kernel/dumpstack.c
index b959f55..8dfe645 100644
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
1.9.1

