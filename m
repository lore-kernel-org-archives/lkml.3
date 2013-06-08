Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab3FHCSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 22:18:44 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:35606 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751052Ab3FHCSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 22:18:43 -0400
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux@arm.linux.org.uk>, <linux@maxim.org.za>, <nicolas.ferre@atmel.com>,
        <plagnioj@jcrosoft.com>, <linux-kernel@vger.kernel.org>,
        <wenyou.yang@atmel.com>
Subject: [PATCH] Change the internal SRAM memory type MT_MEMORY_NONCACHED
Date: Sat, 8 Jun 2013 10:17:43 +0800
Message-ID: <1370657863-8725-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
References: <1369011911-21282-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because MT_DEVICE is not executable in armv7, we change
the internal SRAM memory type to MT_MEMORY_NONCACHED.
As it seems that caching this internal SRAM memory is not necessary,
we chose the this memory type.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index a33d4b5..98d55ef 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -84,7 +84,7 @@ void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
 
 	desc->pfn = __phys_to_pfn(base);
 	desc->length = length;
-	desc->type = MT_DEVICE;
+	desc->type = MT_MEMORY_NONCACHED;
 
 	pr_info("AT91: sram at 0x%lx of 0x%x mapped at 0x%lx\n",
 		base, length, desc->virtual);
-- 
1.7.9.5

