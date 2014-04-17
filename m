Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161168AbaDQIxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:53:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54417 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754268AbaDQIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:50:12 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, andriy.shevchenko@intel.com,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v6 5/8] ARM: sun6i: Protect SDRAM gating bit
Date: Thu, 17 Apr 2014 10:46:16 +0200
Message-Id: <1397724379-15398-6-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent the SDRAM controller from being gated by force-enabling it in the
machine code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/sun6i.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mach-sunxi/sun6i.c b/arch/arm/mach-sunxi/sun6i.c
index 6b3905505fe0..1ccb27524a9e 100644
--- a/arch/arm/mach-sunxi/sun6i.c
+++ b/arch/arm/mach-sunxi/sun6i.c
@@ -34,6 +34,11 @@ static void __init sun6i_dt_init(void)
 	clk = clk_get(NULL, "cpu");
 	if (!IS_ERR(clk))
 		clk_prepare_enable(clk);
+
+	/* DDR gating clock */
+	clk = clk_get(NULL, "ahb1_sdram");
+	if (!IS_ERR(clk))
+		clk_prepare_enable(clk);
 }
 
 extern void __init sun6i_reset_init(void);
-- 
1.9.1

