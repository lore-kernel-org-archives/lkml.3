Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbaDVP2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:28:45 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:43364 "EHLO
	relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932990AbaDVP2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:28:34 -0400
X-IronPort-AV: E=Sophos;i="4.97,904,1389711600"; 
   d="scan'208";a="158374292"
From: Phil Edworthy <phil.edworthy@renesas.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guido Piasenza <gpiasenza@soft-in.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linux-SH <linux-sh@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Phil Edworthy <phil.edworthy@renesas.com>
X-Mailer: git-send-email 1.9.1
X-TNEFEvaluated: 1
Message-ID: <1398180483-10651-1-git-send-email-phil.edworthy@renesas.com>
Date: Tue, 22 Apr 2014 16:28:03 +0100
Subject: [PATCH] sh-pfc: r8a7790: Fix definition of IPSR5
X-MIMETrack: Itemize by SMTP Server on DU0NOTES13/SERVER/REE(Release 8.5.3 HF466|March
 09, 2012) at 22.04.2014 17:28:30,
	Serialize by Router on DU0NOTES13/SERVER/REE(Release 8.5.3 HF466|March 09, 2012) at
 22.04.2014 17:28:31,
	Serialize complete at 22.04.2014 17:28:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Piasenza <gpiasenza@soft-in.com>

The extra entry in the table makes SCIFA0_B, and all peripherals after it, fail.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
---
 drivers/pinctrl/sh-pfc/pfc-r8a7790.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
index 4809371..dbf2ef9 100644
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7790.c
@@ -4795,7 +4795,7 @@ static const struct pinmux_cfg_reg pinmux_config_regs[] = {
 		/* IP5_23_21 [3] */
 		FN_WE1_N, FN_IERX, FN_CAN1_RX, FN_VI1_G4,
 		FN_VI1_G4_B, FN_VI2_R6, FN_SCIFA0_CTS_N_B,
-		FN_IERX_C, 0,
+		FN_IERX_C,
 		/* IP5_20_18 [3] */
 		FN_WE0_N, FN_IECLK, FN_CAN_CLK,
 		FN_VI2_VSYNC_N, FN_SCIFA0_TXD_B, FN_VI2_VSYNC_N_B, 0, 0,
-- 
1.9.1

