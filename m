Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaHWSj1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:39:27 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48310
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbaHWShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:37:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200903"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antonino Daplas <adaplas@gmail.com>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] video: fbdev: riva: delete double assignment
Date: Sat, 23 Aug 2014 20:33:22 +0200
Message-Id: <1408818808-18850-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/video/fbdev/riva/riva_hw.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/riva/riva_hw.c b/drivers/video/fbdev/riva/riva_hw.c
index 78fdbf5..8bdf37f 100644
--- a/drivers/video/fbdev/riva/riva_hw.c
+++ b/drivers/video/fbdev/riva/riva_hw.c
@@ -430,7 +430,6 @@ static char nv3_arb(nv3_fifo_info * res_info, nv3_sim_state * state,  nv3_arb_in
     int mmisses, gmisses, vmisses, eburst_size, mburst_size;
     int refresh_cycle;
 
-    refresh_cycle = 0;
     refresh_cycle = 2*(state->mclk_khz/state->pclk_khz) + 5;
     mmisses = 2;
     if (state->mem_aligned) gmisses = 2;

