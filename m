Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031545Ab3HIXE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:04:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:48361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031452Ab3HIXEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384685847"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/13] x86: Include linux/sched.h in asm/uaccess.h
Date: Fri,  9 Aug 2013 16:04:09 -0700
Message-Id: <1376089460-5459-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

uaccess.h uses might_sleep, but there is currently no explicit include for this.
Since a upcoming patch moves might_sleep into sched.h include sched.h here.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5ee2687..8fa3bd6 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -3,6 +3,7 @@
 /*
  * User space memory access functions
  */
+#include <linux/sched.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
 #include <linux/thread_info.h>
-- 
1.8.3.1

