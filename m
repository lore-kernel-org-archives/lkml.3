Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaHWLZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:28 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:1746 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752517AbaHWLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829922"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] OMAPDSS: DSI: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:29 +0200
Message-Id: <1408792831-25615-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

Not compiled.

 drivers/video/fbdev/omap2/dss/dsi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/dsi.c b/drivers/video/fbdev/omap2/dss/dsi.c
index 56b9244..b6f6ae1 100644
--- a/drivers/video/fbdev/omap2/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/dss/dsi.c
@@ -2571,7 +2571,10 @@ static int dsi_sync_vc_vp(struct platform_device *dsidev, int channel)
 {
 	struct dsi_data *dsi = dsi_get_dsidrv_data(dsidev);
 	DECLARE_COMPLETION_ONSTACK(completion);
-	struct dsi_packet_sent_handler_data vp_data = { dsidev, &completion };
+	struct dsi_packet_sent_handler_data vp_data = {
+		.dsidev = dsidev,
+		.completion = &completion
+	};
 	int r = 0;
 	u8 bit;
 
@@ -2617,7 +2620,10 @@ static void dsi_packet_sent_handler_l4(void *data, u32 mask)
 static int dsi_sync_vc_l4(struct platform_device *dsidev, int channel)
 {
 	DECLARE_COMPLETION_ONSTACK(completion);
-	struct dsi_packet_sent_handler_data l4_data = { dsidev, &completion };
+	struct dsi_packet_sent_handler_data l4_data = {
+		.dsidev = dsidev,
+		.completion = &completion
+	};
 	int r = 0;
 
 	r = dsi_register_isr_vc(dsidev, channel, dsi_packet_sent_handler_l4,

