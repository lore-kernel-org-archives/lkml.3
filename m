Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbaFETSD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:18:03 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:33082 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbaFETSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:18:00 -0400
X-Greylist: delayed 391 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 15:18:00 EDT
X-Sasl-enc: CRmIi6CBHeBj49WavHG/RvoWjsRy0kHLB1Gt8qNI6b+k 1401995484
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: linux-arm-kernel@lists.infradead.org
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH] arm: pxa: correct errata number for PXA270
Date: Thu,  5 Jun 2014 14:10:56 -0500
Message-Id: <1401995457-24721-1-git-send-email-andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comment incorrectly cites errata 39
    E39. SDIO: SDIO Devices Not Working at 19.5 Mbps

Should be errata 38
    E38. MEMC: Memory Controller hangs when entering Self Refresh Mode.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 arch/arm/mach-pxa/sleep.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/sleep.S b/arch/arm/mach-pxa/sleep.S
index 1e544be..6c5b3ff 100644
--- a/arch/arm/mach-pxa/sleep.S
+++ b/arch/arm/mach-pxa/sleep.S
@@ -157,7 +157,7 @@ pxa_cpu_do_suspend:
 	@ Do not reorder...
 	@ Intel PXA270 Specification Update notes problems performing
 	@ external accesses after SDRAM is put in self-refresh mode
-	@ (see Errata 39 ...hangs when entering self-refresh mode)
+	@ (see Errata 38 ...hangs when entering self-refresh mode)
 
 	@ force address lines low by reading at physical address 0
 	ldr	r3, [r2]
-- 
1.9.0.rc3.12.gbc97e2d

