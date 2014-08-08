Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaHHKLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:11:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:7447 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756250AbaHHKLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:11:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,824,1400018400"; 
   d="scan'208";a="88704753"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: =?UTF-8?q?=5BPATCH=205/14=5D=20powerpc/mpc5xxx=3A=20delete=20unneeded=20test=20before=20of=5Fnode=5Fput?=
Date: Fri,  8 Aug 2014 12:07:46 +0200
Message-Id: <1407492475-26283-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Of_node_put supports NULL as its argument, so the initial test is not
necessary.

Suggested by Uwe Kleine-König.

The semantic patch that fixes this problem is as follows:
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
 arch/powerpc/sysdev/mpc5xxx_clocks.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/mpc5xxx_clocks.c b/arch/powerpc/sysdev/mpc5xxx_clocks.c
index 5492dc5..f4f0301 100644
--- a/arch/powerpc/sysdev/mpc5xxx_clocks.c
+++ b/arch/powerpc/sysdev/mpc5xxx_clocks.c
@@ -26,8 +26,7 @@ unsigned long mpc5xxx_get_bus_frequency(struct device_node *node)
 		of_node_put(node);
 		node = np;
 	}
-	if (node)
-		of_node_put(node);
+	of_node_put(node);
 
 	return p_bus_freq ? *p_bus_freq : 0;
 }

