Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab3HFVfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:35:06 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:43523 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3HFVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:35:05 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Mathias Krause <minipli@googlemail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: fix typo in is_gate_vma() macro
Date: Tue,  6 Aug 2013 23:34:35 +0200
Message-Id: <1375824875-1934-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a5463cd3 "ARM: make vectors page inaccessible from userspace"
introduced a typo making arch_vma_name() always return "[vectors]".
Fix up that regression (of the hush-hush security fix).

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/arm/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 16ed3f7..34fe52d 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -462,7 +462,7 @@ int in_gate_area_no_mm(unsigned long addr)
 {
 	return in_gate_area(NULL, addr);
 }
-#define is_gate_vma(vma)	((vma) = &gate_vma)
+#define is_gate_vma(vma)	((vma) == &gate_vma)
 #else
 #define is_gate_vma(vma)	0
 #endif
-- 
1.7.10.4

