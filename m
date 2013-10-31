Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3JaQKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:10:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:43369 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3JaQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:10:32 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Subject: [PATCH 1/6] arm: zynq: platsmp: Fix CPU presence check
Date: Thu, 31 Oct 2013 09:10:14 -0700
Message-Id: <1383235819-2552-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

Fix an off-by-one error in the logic that checks if a CPU is present.
The ncores variable is a count of cores while the cpu variable is a
0 based index. So if ncores == cpu, cpu is out of range. Fix this
comparison so non-existent CPUs are not probed.

Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 arch/arm/mach-zynq/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
index 689fbbc3d9c8..2512624e657d 100644
--- a/arch/arm/mach-zynq/platsmp.c
+++ b/arch/arm/mach-zynq/platsmp.c
@@ -39,7 +39,7 @@ int zynq_cpun_start(u32 address, int cpu)
 	u32 trampoline_code_size = &zynq_secondary_trampoline_end -
 						&zynq_secondary_trampoline;
 
-	if (cpu > ncores) {
+	if (cpu >= ncores) {
 		pr_warn("CPU No. is not available in the system\n");
 		return -1;
 	}
-- 
1.8.4.1

