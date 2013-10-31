Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3JaRhh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 13:37:37 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36708 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3JaRhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 13:37:36 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm: zynq: platsmp: Remove CPU presence check
Date: Thu, 31 Oct 2013 10:37:09 -0700
Message-Id: <1383241029-32018-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <20131031161739.GE16735@n2100.arm.linux.org.uk>
References: <20131031161739.GE16735@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic code already checks that the CPU being requested is legal if
the cpu possible/present masks are set correctly.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
As per Russel's suggestion, consider this alternative for 1/6.

	Sören

 arch/arm/mach-zynq/platsmp.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index bc730eb38f00..8021499e7b70 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -39,11 +39,6 @@ int zynq_cpun_start(u32 address, int cpu)
 	u32 trampoline_code_size = &zynq_secondary_trampoline_end -
 						&zynq_secondary_trampoline;
 
-	if (cpu > ncores) {
-		pr_warn("CPU No. is not available in the system\n");
-		return -1;
-	}
-
 	/* MS: Expectation that SLCR are directly map and accessible */
 	/* Not possible to jump to non aligned address */
 	if (!(address & 3) && (!address || (address >= trampoline_code_size))) {
-- 
1.8.4.1

