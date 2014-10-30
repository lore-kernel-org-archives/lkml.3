Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbaJ3Lkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:40:40 -0400
Received: from down.free-electrons.com ([37.187.137.238]:50034 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759455AbaJ3Ljw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:39:52 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] ARM: mvebu: Fix the secondary startup for Cortex A9 SoC
Date: Thu, 30 Oct 2014 12:39:43 +0100
Message-Id: <1414669184-16785-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414669184-16785-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the secondary startup the SCU was assumed to be in normal
mode. It is not always the case, and especially after a kexec. This
commit adds the needed sequence to put the SCU in normal mode.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/headsmp-a9.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mvebu/headsmp-a9.S b/arch/arm/mach-mvebu/headsmp-a9.S
index be51c998c0cd..08d5ed46b996 100644
--- a/arch/arm/mach-mvebu/headsmp-a9.S
+++ b/arch/arm/mach-mvebu/headsmp-a9.S
@@ -22,5 +22,6 @@
 ENTRY(mvebu_cortex_a9_secondary_startup)
 ARM_BE8(setend	be)
 	bl      v7_invalidate_l1
+	bl	armada_38x_scu_power_up
 	b	secondary_startup
 ENDPROC(mvebu_cortex_a9_secondary_startup)
-- 
1.9.1

