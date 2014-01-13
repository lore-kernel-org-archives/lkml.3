Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaAMPVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:21:49 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3675 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbaAMPVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:21:44 -0500
X-IronPort-AV: E=Sophos;i="4.95,653,1384297200"; 
   d="scan'208";a="44621452"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Antonino Daplas <adaplas@gmail.com>
Cc: kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] i810: delete useless variable
Date: Mon, 13 Jan 2014 17:17:25 +0100
Message-Id: <1389629847-5330-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1389629847-5330-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete a variable that is at most only assigned to a constant, but never
used otherwise.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
identifier i;
constant c;
@@

-T i;
<... when != i
-i = c;
...>
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/i810/i810_main.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/i810/i810_main.c b/drivers/video/i810/i810_main.c
index 038192a..bb674e4 100644
--- a/drivers/video/i810/i810_main.c
+++ b/drivers/video/i810/i810_main.c
@@ -2011,9 +2011,7 @@ static int i810fb_init_pci(struct pci_dev *dev,
 	struct fb_info    *info;
 	struct i810fb_par *par = NULL;
 	struct fb_videomode mode;
-	int i, err = -1, vfreq, hfreq, pixclock;
-
-	i = 0;
+	int err = -1, vfreq, hfreq, pixclock;
 
 	info = framebuffer_alloc(sizeof(struct i810fb_par), &dev->dev);
 	if (!info)

