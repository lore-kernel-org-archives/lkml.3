Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760616AbaCURRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 13:17:21 -0400
Received: from smtp.adetelgroup.com ([94.247.26.71]:21609 "EHLO
	hbg-pa71.hmc-pa.adm" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751620AbaCURRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 13:17:16 -0400
X-Greylist: delayed 509 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Mar 2014 13:17:16 EDT
From: Hubert Chaumette <hchaumette@adeneo-embedded.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Hubert Chaumette <hchaumette@adeneo-embedded.com>, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: i.MX6: update KSZ9031 phy fixup
Date: Fri, 21 Mar 2014 18:08:07 +0100
Message-Id: <1395421687-12934-1-git-send-email-hchaumette@adeneo-embedded.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update KSZ9031RN phy fixup for Congatec conga-QEVAL and conga-QMX6 combo :
set RGMII GTX_CLK and RX_CLK pad skew to +0.96ns.

Signed-off-by: Hubert Chaumette <hchaumette@adeneo-embedded.com>
---
 arch/arm/mach-imx/mach-imx6q.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-imx/mach-imx6q.c b/arch/arm/mach-imx/mach-imx6q.c
index 76e5db4..db307c2 100644
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -77,6 +77,9 @@ static int ksz9031rn_phy_fixup(struct phy_device *dev)
 	mmd_write_reg(dev, 2, 5, 0);
 	mmd_write_reg(dev, 2, 8, 0x003ff);
 
+	/* For Congatec conga-QMX6 board */
+	mmd_write_reg(dev, 0x02, 0x06, 0xffff);
+
 	return 0;
 }
 
-- 
1.9.0

