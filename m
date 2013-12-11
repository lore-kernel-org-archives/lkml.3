Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076Ab3LKG3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:29:36 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39130 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3LKG3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:29:23 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: linux-kernel@vger.kernel.org, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@alien8.de>,
        <keescook@chromium.org>, <zhangyanfei@cn.fujitsu.com>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [RFC PATCH] x86_64: double the x86_64 kernel stack size?
Date: Wed, 11 Dec 2013 14:28:52 +0800
Message-Id: <1386743332-32171-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somethings I compiled the Linux network modules (especially bridge and netfilter)
without optimization, the kernel always crashes because of exhausted kernel stack.

The similar problem has been discussed in
http://lists.linuxfoundation.org/pipermail/bridge/2005-January/004402.html

Is it OK the double the x86_64 kernel stack size?
 

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Tested-by: Zhouyi Zhou  <yizhouzhou@ict.ac.cn>
---
 arch/x86/include/asm/page_64_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd80..dc4c629 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_X86_PAGE_64_DEFS_H
 #define _ASM_X86_PAGE_64_DEFS_H
 
-#define THREAD_SIZE_ORDER	1
+#define THREAD_SIZE_ORDER	2
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 #define CURRENT_MASK (~(THREAD_SIZE - 1))
 
-- 
1.7.10.4

