Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaGWNFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:05:18 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:56699 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbaGWNFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:05:17 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] arm/mach-imximx/iomux-v3: Do not export symbol without public declaration
Date: Wed, 23 Jul 2014 15:02:00 +0200
Message-Id: <1406120520-14390-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mxc_iomux_v3_setup_pad and mxc_iomux_v3_setup_multiple_pads are
declared in iomux-v3.h which can't be used in any module. None of the
objects in this directory is tristate. Neither can the header be included
in out-of-tree modules.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 arch/arm/mach-imx/iomux-v3.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-imx/iomux-v3.c b/arch/arm/mach-imx/iomux-v3.c
index 9dae74bf47fc..d61f9606fc56 100644
--- a/arch/arm/mach-imx/iomux-v3.c
+++ b/arch/arm/mach-imx/iomux-v3.c
@@ -55,7 +55,6 @@ int mxc_iomux_v3_setup_pad(iomux_v3_cfg_t pad)
 
 	return 0;
 }
-EXPORT_SYMBOL(mxc_iomux_v3_setup_pad);
 
 int mxc_iomux_v3_setup_multiple_pads(iomux_v3_cfg_t *pad_list, unsigned count)
 {
@@ -71,7 +70,6 @@ int mxc_iomux_v3_setup_multiple_pads(iomux_v3_cfg_t *pad_list, unsigned count)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mxc_iomux_v3_setup_multiple_pads);
 
 void mxc_iomux_v3_init(void __iomem *iomux_v3_base)
 {
-- 
1.8.5.5

