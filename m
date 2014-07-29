Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaG2PT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:19:58 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57251 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbaG2PTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:19:54 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459213"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c: use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:43 +0200
Message-Id: <1406647011-8543-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Correct typo in the name of the type given to sizeof.  Because it is the
size of a pointer that is wanted, the typo has no impact on compilation or
execution.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
semantic patch used can be found in message 0 of this patch series.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index cda8388..255590f 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -227,7 +227,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
 		return 0;
 
 	vpfe_dev->clks = kzalloc(vpfe_cfg->num_clocks *
-				   sizeof(struct clock *), GFP_KERNEL);
+				   sizeof(struct clk *), GFP_KERNEL);
 	if (vpfe_dev->clks == NULL) {
 		v4l2_err(vpfe_dev->pdev->driver, "Memory allocation failed\n");
 		return -ENOMEM;

