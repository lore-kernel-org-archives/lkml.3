Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3HEWKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:10:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:37723 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab3HEWDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="278100322"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/16] x86, asmlinkage: Change dotraplinkage into __visible on 32bit v2
Date: Mon,  5 Aug 2013 15:02:36 -0700
Message-Id: <1375740170-7446-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Mark 32bit dotraplinkage functions as __visible for LTO.
64bit already is using asmlinkage which includes it.

v2: Clean up (M.Marek)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/traps.h | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..7036cb6 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -6,11 +6,7 @@
 #include <asm/debugreg.h>
 #include <asm/siginfo.h>			/* TRAP_TRACE, ... */
 
-#ifdef CONFIG_X86_32
-#define dotraplinkage
-#else
-#define dotraplinkage asmlinkage
-#endif
+#define dotraplinkage __visible
 
 asmlinkage void divide_error(void);
 asmlinkage void debug(void);
-- 
1.8.3.1

