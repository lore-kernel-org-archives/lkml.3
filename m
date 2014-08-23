Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaHWSh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:37:27 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:48310
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751988AbaHWShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:37:03 -0400
X-IronPort-AV: E=Sophos;i="5.04,387,1406584800"; 
   d="scan'208";a="76200910"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] video: fbdev: sis: delete double assignment
Date: Sat, 23 Aug 2014 20:33:27 +0200
Message-Id: <1408818808-18850-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive assignments to the same location.  The second assignment
is changed to update a different field, as done in other nearby code.

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

This changes the semantics of the code and is not tested.

 drivers/video/fbdev/sis/init301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sis/init301.c b/drivers/video/fbdev/sis/init301.c
index a89e3ca..295e0de 100644
--- a/drivers/video/fbdev/sis/init301.c
+++ b/drivers/video/fbdev/sis/init301.c
@@ -1714,7 +1714,7 @@ SiS_GetLCDResInfo(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned sh
 			       SiS_Pr->PanelVCLKIdx315 = VCLK81_315; /* ? */
 			    } else {
 			       SiS_Pr->PanelHT   = 1688; SiS_Pr->PanelVT   =  802;
-			       SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRS  =  112;
+			       SiS_Pr->PanelHRS  =   48; SiS_Pr->PanelHRE  =  112;
 			       SiS_Pr->PanelVRS  =    3; SiS_Pr->PanelVRE  =    6;
 			       SiS_Pr->PanelVCLKIdx300 = VCLK81_300;
 			       SiS_Pr->PanelVCLKIdx315 = VCLK81_315;

