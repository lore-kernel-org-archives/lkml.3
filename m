Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab3JaQLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:11:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39394 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab3JaQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:11:17 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/6] arm: zynq: headsmp: Move .glbl out of actual code
Date: Thu, 31 Oct 2013 09:10:19 -0700
Message-Id: <1383235819-2552-7-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the .glbl lines exporting symbols to the top of the file and out of
the actual code, in order to make the code more readable.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 arch/arm/mach-zynq/headsmp.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-zynq/headsmp.S b/arch/arm/mach-zynq/headsmp.S
index 57a32869f0aa..12d1b40c7d78 100644
--- a/arch/arm/mach-zynq/headsmp.S
+++ b/arch/arm/mach-zynq/headsmp.S
@@ -9,14 +9,15 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 
+.globl zynq_secondary_trampoline_jump
+.globl zynq_secondary_trampoline_end
+
 ENTRY(zynq_secondary_trampoline)
 	ldr	r0, [pc]
 	bx	r0
-.globl zynq_secondary_trampoline_jump
 zynq_secondary_trampoline_jump:
 	/* Space for jumping address */
 	.word	/* cpu 1 */
-.globl zynq_secondary_trampoline_end
 zynq_secondary_trampoline_end:
 ENDPROC(zynq_secondary_trampoline)
 
-- 
1.8.4.1

