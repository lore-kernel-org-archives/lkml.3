Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbaKRAgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:36:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:42547 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433AbaKRAgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,406,1413270000"; 
   d="scan'208";a="623906435"
Subject: [PATCH] do not include mpx.h in exec.c
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Mon, 17 Nov 2014 16:36:08 -0800
Message-Id: <20141118003608.837015B3@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

We no longer need mpx.h in exec.c.  This will obviously also
break the build for non-x86 builds.  We get the MPX includes that
we need from mmu_context.h now.

This applies on top of the MPX patches currently in the -tip
branch.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/fs/exec.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/exec.c~no-mpx-in fs/exec.c
--- a/fs/exec.c~no-mpx-in	2014-11-17 16:22:33.935154876 -0800
+++ b/fs/exec.c	2014-11-17 16:22:39.466404410 -0800
@@ -60,7 +60,6 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
-#include <asm/mpx.h>
 
 #include <trace/events/task.h>
 #include "internal.h"
_
