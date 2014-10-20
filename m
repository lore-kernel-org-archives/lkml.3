Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaJTQeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:34:12 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:53683 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751272AbaJTQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:34:09 -0400
From: Stefan Hengelein <stefan.hengelein@fau.de>
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org, ryazanov.s.a@gmail.com, ralf@linux-mips.org,
        Stefan Hengelein <stefan.hengelein@fau.de>
Subject: [PATCH] MIPS: MSP71xx: remove compilation error when CONFIG_MIPS_MT is present
Date: Mon, 20 Oct 2014 18:33:39 +0200
Message-Id: <1413822819-8827-1-git-send-email-stefan.hengelein@fau.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_MIPS_MT is defined, code is enabled that tries to call
'set_vi_handler()'. This function is declared in <asm/setup.h> but the
header is never included. Therefore, the compilation breaks.

arch/mips/pmcs-msp71xx/msp_irq.c:133: error: implicit declaration of function 'set_vi_handler'

This error was found with vampyr.

Signed-off-by: Stefan Hengelein <stefan.hengelein@fau.de>
---
 arch/mips/pmcs-msp71xx/msp_irq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/pmcs-msp71xx/msp_irq.c b/arch/mips/pmcs-msp71xx/msp_irq.c
index f914c75..8d53d7a 100644
--- a/arch/mips/pmcs-msp71xx/msp_irq.c
+++ b/arch/mips/pmcs-msp71xx/msp_irq.c
@@ -16,6 +16,7 @@
 #include <linux/time.h>
 
 #include <asm/irq_cpu.h>
+#include <asm/setup.h>
 
 #include <msp_int.h>
 
-- 
1.9.1

