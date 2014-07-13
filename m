Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaGMO7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:59:50 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaGMO7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:59:15 -0400
From: Richard Weinberger <richard@nod.at>
To: tony.luck@intel.com, fenghua.yu@intel.com, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] ia64: Remove Linux/x86 domain support
Date: Sun, 13 Jul 2014 16:58:58 +0200
Message-Id: <1405263538-27589-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405263538-27589-1-git-send-email-richard@nod.at>
References: <1405263538-27589-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64 exec domain support seems to be incomplete and unused.
It has no custom handler nor a custom signal map.
All it does is showing up in /proc/execdomains.
Let's rip it out.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/ia64/mm/init.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 25c3502..d4a6b79 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -660,31 +660,6 @@ int arch_remove_memory(u64 start, u64 size)
 #endif
 #endif
 
-/*
- * Even when CONFIG_IA32_SUPPORT is not enabled it is
- * useful to have the Linux/x86 domain registered to
- * avoid an attempted module load when emulators call
- * personality(PER_LINUX32). This saves several milliseconds
- * on each such call.
- */
-static struct exec_domain ia32_exec_domain;
-
-static int __init
-per_linux32_init(void)
-{
-	ia32_exec_domain.name = "Linux/x86";
-	ia32_exec_domain.handler = NULL;
-	ia32_exec_domain.pers_low = PER_LINUX32;
-	ia32_exec_domain.pers_high = PER_LINUX32;
-	ia32_exec_domain.signal_map = default_exec_domain.signal_map;
-	ia32_exec_domain.signal_invmap = default_exec_domain.signal_invmap;
-	register_exec_domain(&ia32_exec_domain);
-
-	return 0;
-}
-
-__initcall(per_linux32_init);
-
 /**
  * show_mem - give short summary of memory stats
  *
-- 
2.0.1

