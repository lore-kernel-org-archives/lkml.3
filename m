Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaBHHxB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:53:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:13411 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbaBHHw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:52:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="477987522"
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/14] asmlinkage: Make main_extable_sort_needed visible
Date: Sat,  8 Feb 2014 08:52:04 +0100
Message-Id: <1391845930-28580-8-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

main_extable_sort_needed is used by the build system and needs
to be a normal ELF symbol. Make it visible so that LTO
does not remove or mangle it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/extable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 763faf0..d8a6446 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -36,7 +36,7 @@ extern struct exception_table_entry __start___ex_table[];
 extern struct exception_table_entry __stop___ex_table[];
 
 /* Cleared by build time tools if the table is already sorted. */
-u32 __initdata main_extable_sort_needed = 1;
+u32 __initdata __visible main_extable_sort_needed = 1;
 
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
-- 
1.8.5.2

