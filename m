Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918AbaCaCbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:31:20 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62418 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaCaCbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:31:19 -0400
From: zhouzhouyi@gmail.com
To: <len.brown@intel.com>, <pavel@ucw.cz>, <rjw@rjwysocki.net>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH RFC] ACPI: (x86) remove useless initial assignment in gsi_to_irq
Date: Mon, 31 Mar 2014 10:30:55 +0800
Message-Id: <5338d375.45ac440a.2163.3105@mx.google.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhouyi Zhou <zhouzhouyi@gmail.com>

I think in function gsi_to_irq, initial assignment to irq is useless although compiler
may eliminate it during the compilng. 

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 1dac942..b93d61e 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -103,7 +103,7 @@ static u32 isa_irq_to_gsi[NR_IRQS_LEGACY] __read_mostly = {
 
 static unsigned int gsi_to_irq(unsigned int gsi)
 {
-	unsigned int irq = gsi + NR_IRQS_LEGACY;
+	unsigned int irq;
 	unsigned int i;
 
 	for (i = 0; i < NR_IRQS_LEGACY; i++) {
-- 
1.7.10.4

