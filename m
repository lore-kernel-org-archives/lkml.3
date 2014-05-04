Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaEDPpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:45:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbaEDPnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:43:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Kees Cook <keescook@chromium.org>, Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 36/43] sh: fix format string bug in stack tracer
Date: Sun,  4 May 2014 11:42:30 -0400
Message-Id: <20140504154229.161131534@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/sh/kernel/dumpstack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sh/kernel/dumpstack.c
+++ b/arch/sh/kernel/dumpstack.c
@@ -80,7 +80,7 @@ static int print_trace_stack(void *data,
  */
 static void print_trace_address(void *data, unsigned long addr, int reliable)
 {
-	printk(data);
+	printk("%s", (char *)data);
 	printk_address(addr, reliable);
 }
 


