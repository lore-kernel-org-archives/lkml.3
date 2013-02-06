Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3BFN3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:29:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45393 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab3BFN3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:29:19 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <b-cousson@ti.com>,
        <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH v2 3/5] ARM: OMAP2: MUSB: Specify omap4 has mailbox
Date: Wed, 6 Feb 2013 18:58:49 +0530
Message-ID: <1360157331-9048-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360157331-9048-1-git-send-email-kishon@ti.com>
References: <1360157331-9048-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added has_mailbox to the musb platform data to specify that omap uses
an external mailbox (in control module) to communicate with the musb
core during device connect and disconnect.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/usb-musb.c |    3 +++
 include/linux/usb/musb.h       |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm/mach-omap2/usb-musb.c b/arch/arm/mach-omap2/usb-musb.c
index 7b33b37..9d27e3f 100644
--- a/arch/arm/mach-omap2/usb-musb.c
+++ b/arch/arm/mach-omap2/usb-musb.c
@@ -85,6 +85,9 @@ void __init usb_musb_init(struct omap_musb_board_data *musb_board_data)
 	musb_plat.mode = board_data->mode;
 	musb_plat.extvbus = board_data->extvbus;
 
+	if (cpu_is_omap44xx())
+		musb_plat.has_mailbox = true;
+
 	if (soc_is_am35xx()) {
 		oh_name = "am35x_otg_hs";
 		name = "musb-am35x";
diff --git a/include/linux/usb/musb.h b/include/linux/usb/musb.h
index eb50525..053c268 100644
--- a/include/linux/usb/musb.h
+++ b/include/linux/usb/musb.h
@@ -99,6 +99,8 @@ struct musb_hdrc_platform_data {
 	/* MUSB_HOST, MUSB_PERIPHERAL, or MUSB_OTG */
 	u8		mode;
 
+	u8		has_mailbox:1;
+
 	/* for clk_get() */
 	const char	*clock;
 
-- 
1.7.10.4

