Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbaESNld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:41:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40390 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaESNlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:41:31 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v4 3/6] usb: musb: dsps: Call usb_phy(_shutdown/_init) during musb_platform_reset()
Date: Mon, 19 May 2014 19:09:33 +0530
Message-ID: <1400506776-2816-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400506776-2816-1-git-send-email-george.cherian@ti.com>
References: <1400506776-2816-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For DSPS platform usb_phy_vbus(_off/_on) are NOPs.
So during musb_platform_reset() call usb_phy(_shutdown/_init)

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 51beb13..74c4193 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -543,7 +543,11 @@ static void dsps_musb_reset(struct musb *musb)
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
 
 	dsps_writel(musb->ctrl_base, wrp->control, (1 << wrp->reset));
-	udelay(100);
+	usleep_range(100, 200);
+	usb_phy_shutdown(musb->xceiv);
+	usleep_range(100, 200);
+	usb_phy_init(musb->xceiv);
+
 }
 
 static struct musb_platform_ops dsps_ops = {
-- 
1.8.3.1

