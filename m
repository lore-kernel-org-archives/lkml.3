Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaJWSPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:15:12 -0400
Received: from down.free-electrons.com ([37.187.137.238]:34365 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932157AbaJWSPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:15:07 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: mvebu: Fix secondary startup for Cortex A9 SoC
Date: Thu, 23 Oct 2014 20:14:29 +0200
Message-Id: <1414088070-12510-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
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
index be51c998c0cd..2a756ef5c4ba 100644
--- a/arch/arm/mach-mvebu/headsmp-a9.S
+++ b/arch/arm/mach-mvebu/headsmp-a9.S
@@ -22,5 +22,6 @@
 ENTRY(mvebu_cortex_a9_secondary_startup)
 ARM_BE8(setend	be)
 	bl      v7_invalidate_l1
+	bl	power_up_scu
 	b	secondary_startup
 ENDPROC(mvebu_cortex_a9_secondary_startup)
-- 
1.9.1

