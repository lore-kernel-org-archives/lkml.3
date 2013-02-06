Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3BFRtC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:49:02 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47281 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3BFRtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:49:00 -0500
Subject: [RFC][PATCH] PAGE_OWNER now depends on STACKTRACE_SUPPORT
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2013 09:47:48 -0800
Message-Id: <20130206174748.467A1FFD@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020617-9360-0000-0000-0000103B2ABF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One of the enhancements I made to the PAGE_OWNER code was to make
it use the generic stack trace support.  However, there are some
architectures that do not support it, like m68k.  So, make
PAGE_OWNER also depend on having STACKTRACE_SUPPORT.

This isn't ideal since it restricts the number of places
PAGE_OWNER runs now, but it at least hits all the major
architectures.

tree:   git://git.cmpxchg.org/linux-mmotm.git master
head:   83b324c5ff5cca85bbeb2ba913d465f108afe472
commit: 2a561c9d47c295ed91984c2b916a4dd450ee0279 [484/499] debugging-keep-track-of-page-owners-fix
config: make ARCH=m68k allmodconfig

All warnings:

warning: (PAGE_OWNER && STACK_TRACER && BLK_DEV_IO_TRACE && KMEMCHECK) selects STACKTRACE which has unmet direct dependencies (STACKTRACE_SUPPORT)

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~now-depends-on-STACKTRACE_SUPPORT lib/Kconfig.debug
--- linux-2.6.git/lib/Kconfig.debug~now-depends-on-STACKTRACE_SUPPORT	2013-02-06 09:44:01.372619511 -0800
+++ linux-2.6.git-dave/lib/Kconfig.debug	2013-02-06 09:44:10.648711604 -0800
@@ -101,7 +101,7 @@ config UNUSED_SYMBOLS
 
 config PAGE_OWNER
 	bool "Track page owner"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
 	select DEBUG_FS
 	select STACKTRACE
 	help
_

