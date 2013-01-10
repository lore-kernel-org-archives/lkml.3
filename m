Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3AJTKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:10:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:51462 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab3AJTKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:10:34 -0500
Date: Thu, 10 Jan 2013 11:10:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Bill Pemberton <wfp5p@virginia.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Remove __dev* markings from init.h
Message-ID: <20130110191032.GA3786@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, the below patch is now in my driver-core.next tree, and should go
to Linus before 3.8-final is out.  Just a heads-up for anyone who is
wondering what happened to the __dev* markings in the kernel.

----------------------------
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] Remove __dev* markings from init.h

Now that all in-kernel users of __dev* are gone, let's remove them from
init.h to keep them from popping up again and again.

Thanks to Bill Pemberton for doing all of the hard work to make removal
of this possible.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/init.h | 20 --------------------
 1 file changed, 20 deletions(-)



diff --git a/include/linux/init.h b/include/linux/init.h
index a799273..10ed4f4 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -93,14 +93,6 @@
 
 #define __exit          __section(.exit.text) __exitused __cold notrace
 
-/* Used for HOTPLUG, but that is always enabled now, so just make them noops */
-#define __devinit
-#define __devinitdata
-#define __devinitconst
-#define __devexit
-#define __devexitdata
-#define __devexitconst
-
 /* Used for HOTPLUG_CPU */
 #define __cpuinit        __section(.cpuinit.text) __cold notrace
 #define __cpuinitdata    __section(.cpuinit.data)
@@ -337,18 +329,6 @@ void __init parse_early_options(char *cmdline);
 #define __INITRODATA_OR_MODULE __INITRODATA
 #endif /*CONFIG_MODULES*/
 
-/* Functions marked as __devexit may be discarded at kernel link time, depending
-   on config options.  Newer versions of binutils detect references from
-   retained sections to discarded sections and flag an error.  Pointers to
-   __devexit functions must use __devexit_p(function_name), the wrapper will
-   insert either the function_name or NULL, depending on the config options.
- */
-#if defined(MODULE) || defined(CONFIG_HOTPLUG)
-#define __devexit_p(x) x
-#else
-#define __devexit_p(x) NULL
-#endif
-
 #ifdef MODULE
 #define __exit_p(x) x
 #else
-- 
1.8.1.rc1.5.g7e0651a

