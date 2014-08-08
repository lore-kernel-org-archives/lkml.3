Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbaHHKLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:11:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48276 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756317AbaHHKLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:11:14 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88704755"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 3/14] powerpc: gamecube/wii: delete unneeded test before of_node_put
Date: Fri,  8 Aug 2014 12:07:48 +0200
Message-Id: <1407492475-26283-7-git-send-email-Julia.Lawall@lip6.fr>
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
 arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c b/arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c
index 20a8ed9..7feb325 100644
--- a/arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c
+++ b/arch/powerpc/platforms/embedded6xx/usbgecko_udbg.c
@@ -247,7 +247,7 @@ void __init ug_udbg_init(void)
 	np = of_find_compatible_node(NULL, NULL, "nintendo,flipper-exi");
 	if (!np) {
 		udbg_printf("%s: EXI node not found\n", __func__);
-		goto done;
+		goto out;
 	}
 
 	exi_io_base = ug_udbg_setup_exi_io_base(np);
@@ -267,8 +267,8 @@ void __init ug_udbg_init(void)
 	}
 
 done:
-	if (np)
-		of_node_put(np);
+	of_node_put(np);
+out:
 	return;
 }
 

