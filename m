Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab3HSIwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:52:07 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:59236 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab3HSIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:52:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="29716860"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Felipe Balbi <balbi@ti.com>
Cc: kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] usb: musb: dsps: simplify platform_get_resource_byname/devm_ioremap_resource
Date: Mon, 19 Aug 2013 10:51:54 +0200
Message-Id: <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource_byname when the value is passed to devm_ioremap_resource.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,e,e1;
expression ret != 0;
identifier l;
@@

  res = platform_get_resource_byname(...);
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/usb/musb/musb_dsps.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 4ffbaac..f2f9710 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -357,9 +357,6 @@ static int dsps_musb_init(struct musb *musb)
 	u32 rev, val;
 
 	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
-	if (!r)
-		return -EINVAL;
-
 	reg_base = devm_ioremap_resource(dev, r);
 	if (!musb->ctrl_base)
 		return -EINVAL;

