Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab3BXL4B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:56:01 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:61688
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754732Ab3BXLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:55:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,727,1355094000"; 
   d="scan'208";a="3271402"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/gpu/drm/tilcdc/tilcdc_drv.c: adjust duplicate test
Date: Sun, 24 Feb 2013 12:55:33 +0100
Message-Id: <1361706934-15434-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361706934-15434-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1361706934-15434-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.

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
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index c5b592d..3ad0a63 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -192,7 +192,7 @@ static int tilcdc_load(struct drm_device *dev, unsigned long flags)
 	}
 
 	priv->disp_clk = clk_get(dev->dev, "dpll_disp_ck");
-	if (IS_ERR(priv->clk)) {
+	if (IS_ERR(priv->disp_clk)) {
 		dev_err(dev->dev, "failed to get display clock\n");
 		ret = -ENODEV;
 		goto fail;

