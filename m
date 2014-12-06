Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaLFAID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 19:08:03 -0500
Received: from ns.horizon.com ([71.41.210.147]:14084 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751183AbaLFAIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 19:08:01 -0500
Date: 5 Dec 2014 19:07:59 -0500
Message-ID: <20141206000759.14606.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: rusty@rustcorp.com.au
Subject: [PATCH] VERIFY_OCTAL_PERMISSIONS needs <linux/bug.h>
Cc: akpm@linux-foundation.org, linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to include <linux/kernel.h> and try to use
VERIFY_OCTAL_PERMISSIONS, then puke because BUILD_BUG_ON_ZERO
isn't defined.

I hit this via:

#include <linux/moduleparam.h>
module_param(verbose, bool, 0);

IMHO, except in documented special cases, header files should
#include their own macros' dependencies.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 include/linux/kernel.h | 1 +
 1 file changed, 1 insertion(+)

I'm not quite sure who to send this via.  Rusty, you touched
VERIFY_OCTAL_PERMISSIONS last.  Should I send this via you, or collect
acks and include it in the patch series I'm working on that wants this?

The workaround is easy enough, but I'd rather fix it than let cruft
like this accumulate.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f55..afb81c1a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -12,6 +12,7 @@
 #include <linux/typecheck.h>
 #include <linux/printk.h>
 #include <linux/dynamic_debug.h>
+#include <linux/bug.h>
 #include <asm/byteorder.h>
 #include <uapi/linux/kernel.h>
 
-- 
2.1.3

