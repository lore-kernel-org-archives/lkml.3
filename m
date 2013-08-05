Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3HEWDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:03:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab3HEWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,821,1367996400"; 
   d="scan'208";a="357994049"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/16] x86, asmlinkage, kexec: Drop bogus asmlinkage in machine_kexec_32
Date: Mon,  5 Aug 2013 15:02:42 -0700
Message-Id: <1375740170-7446-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
References: <1375740170-7446-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

A function pointer cannot be asmlinkage. Just drop it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/machine_kexec_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 5b19e4d..7048960 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -184,7 +184,7 @@ void machine_kexec(struct kimage *image)
 	unsigned long page_list[PAGES_NR];
 	void *control_page;
 	int save_ftrace_enabled;
-	asmlinkage unsigned long
+	unsigned long
 		(*relocate_kernel_ptr)(unsigned long indirection_page,
 				       unsigned long control_page,
 				       unsigned long start_address,
-- 
1.8.3.1

