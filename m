Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaHHKNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:13:18 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7447 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756345AbaHHKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:11:15 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88704759"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Brian Norris <computersforpeace@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 11/14] ARM: brcmstb: delete unneeded test before of_node_put
Date: Fri,  8 Aug 2014 12:07:52 +0200
Message-Id: <1407492475-26283-11-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Simplify the error path to avoid calling of_node_put when it is not needed.

The semantic patch that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

-if (e)
   of_node_put(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/mach-bcm/platsmp-brcmstb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
index af780e9..c515ea1 100644
--- a/arch/arm/mach-bcm/platsmp-brcmstb.c
+++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
@@ -227,7 +227,7 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
 	if (!syscon_np) {
 		pr_err("can't find phandle %s\n", name);
 		rc = -EINVAL;
-		goto cleanup;
+		goto out;
 	}
 
 	cpubiuctrl_block = of_iomap(syscon_np, 0);
@@ -256,9 +256,8 @@ static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
 	}
 
 cleanup:
-	if (syscon_np)
-		of_node_put(syscon_np);
-
+	of_node_put(syscon_np);
+out:
 	return rc;
 }
 
@@ -274,7 +273,7 @@ static int __init setup_hifcont_regs(struct device_node *np)
 	if (!syscon_np) {
 		pr_err("can't find phandle %s\n", name);
 		rc = -EINVAL;
-		goto cleanup;
+		goto out;
 	}
 
 	hif_cont_block = of_iomap(syscon_np, 0);
@@ -288,9 +287,8 @@ static int __init setup_hifcont_regs(struct device_node *np)
 	hif_cont_reg = 0;
 
 cleanup:
-	if (syscon_np)
-		of_node_put(syscon_np);
-
+	of_node_put(syscon_np);
+out:
 	return rc;
 }
 

