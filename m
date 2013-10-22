Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab3JVQNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:13:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:61569 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab3JVQNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:13:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="396828249"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/11] asmlinkage: Make main_extable_sort_needed visible
Date: Tue, 22 Oct 2013 09:12:24 -0700
Message-Id: <1382458346-24811-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
References: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

main_extable_sort_needed is used by the build system and needs
to be a normal ELF symbol. Make it visible so that LTO
does not remove or mangle it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/extable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/extable.c b/kernel/extable.c
index 832cb28..829afaa 100644
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
1.8.3.1

