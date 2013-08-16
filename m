Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961Ab3HPWsa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:48:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:51533 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881Ab3HPWs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,897,1367996400"; 
   d="scan'208";a="387551636"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, peterz@infradead.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] x86: Include linux/sched.h in asm/uaccess.h
Date: Fri, 16 Aug 2013 14:17:20 -0700
Message-Id: <1376687844-19857-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
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

