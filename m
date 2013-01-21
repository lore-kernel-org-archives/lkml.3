Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab3AUMPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:15:34 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:41316
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078Ab3AUMDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:12 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187834"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/15] drivers/staging/omap-thermal/omap-bandgap.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:47 +0100
Message-Id: <1358773378-4700-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  There was a previous test on
ret and it has not been updated since then.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
    when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Perhaps it was intended to test somthing, but I am not sure what.

 drivers/staging/omap-thermal/omap-bandgap.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index 8346e34..89f7180 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -568,8 +568,6 @@ int omap_bandgap_read_update_interval(struct omap_bandgap *bg_ptr, int id,
 
 	tsr = bg_ptr->conf->sensors[id].registers;
 	time = omap_bandgap_readl(bg_ptr, tsr->bgap_counter);
-	if (ret)
-		return ret;
 	time = (time & tsr->counter_mask) >> __ffs(tsr->counter_mask);
 	time = time * 1000 / bg_ptr->clk_rate;
 
