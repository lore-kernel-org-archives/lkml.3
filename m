Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaL2Gt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:49:26 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:64117 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaL2GtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:49:24 -0500
From: Chen Yucong <slaoub@gmail.com>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86/hw-breakpoints: eliminate a compiler warning for hw_breakpoint.c
Date: Mon, 29 Dec 2014 14:49:23 +0800
Message-Id: <1419835763-13241-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a warning message when we compile the linux-next tree.

arch/x86/kernel/hw_breakpoint.c: In function ‘arch_validate_hwbkpt_settings’:
arch/x86/kernel/hw_breakpoint.c:329:20: warning: ‘align’ may be used uninitialized in this function [-Wuninitialized]

This patch aims to eliminate the above compiler warning.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 7114ba2..302eab3 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -293,7 +293,7 @@ static int arch_build_bp_info(struct perf_event *bp)
 int arch_validate_hwbkpt_settings(struct perf_event *bp)
 {
 	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned int align;
+	unsigned int align = ~0x0U;
 	int ret;
 
 
-- 
1.7.10.4

