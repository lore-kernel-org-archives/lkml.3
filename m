Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CMIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 04:48:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46124 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab3CMIrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 04:47:23 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <notasas@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH 4/5] usb: musb: omap: add usb_phy_init in omap2430_musb_init
Date: Wed, 13 Mar 2013 14:17:09 +0530
Message-ID: <1363164430-19118-5-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363164430-19118-1-git-send-email-kishon@ti.com>
References: <1363164430-19118-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some PHYs load too early (twl4030) making omap glue to miss cable connect events
if the board is booted with cable connected. So adding usb_phy_init in
omap2430_musb_init lets PHYs to report events once glue is ready.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/musb/omap2430.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 28a0220..0786495 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -386,6 +386,8 @@ static int omap2430_musb_init(struct musb *musb)
 	if (glue->status != OMAP_MUSB_UNKNOWN)
 		omap_musb_set_mailbox(glue);
 
+	usb_phy_init(musb->xceiv);
+
 	pm_runtime_put_noidle(musb->controller);
 	return 0;
 
-- 
1.7.10.4

