Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3JCLgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:36:52 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41032 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3JCLgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:36:50 -0400
Message-ID: <524D56CB.9080205@gmail.com>
Date: Thu, 03 Oct 2013 19:36:43 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/early_iounmap: Let the compiler enter the function name
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

To be consistent with early_ioremap which had a change in
commit 4f4319a ("x86/ioremap: Correct function name output"),
let the complier enter the function name too.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 arch/x86/mm/ioremap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 799580c..577bd8e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -585,21 +585,21 @@ void __init early_iounmap(void __iomem *addr, unsigned long size)
 	}
 
 	if (slot < 0) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) not found slot\n",
+		printk(KERN_INFO "%s(%p, %08lx) not found slot\n", __func__,
 			 addr, size);
 		WARN_ON(1);
 		return;
 	}
 
 	if (prev_size[slot] != size) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d] size not consistent %08lx\n",
-			 addr, size, slot, prev_size[slot]);
+		printk(KERN_INFO "%s(%p, %08lx) [%d] size not consistent %08lx\n",
+			 __func__, addr, size, slot, prev_size[slot]);
 		WARN_ON(1);
 		return;
 	}
 
 	if (early_ioremap_debug) {
-		printk(KERN_INFO "early_iounmap(%p, %08lx) [%d]\n", addr,
+		printk(KERN_INFO "%s(%p, %08lx) [%d]\n", __func__, addr,
 		       size, slot);
 		dump_stack();
 	}
-- 
1.7.1
