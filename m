Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbbAGTWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:22:24 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:54923 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbbAGTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:22:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,716,1413270000"; 
   d="scan'208";a="54340620"
From: Ray Jui <rjui@broadcom.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, Ray Jui <rjui@broadcom.com>
Subject: [PATCH v3 3/5] clk: Change bcm clocks build dependency
Date: Wed, 7 Jan 2015 11:22:46 -0800
Message-ID: <1420658568-22879-4-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1420658568-22879-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1420658568-22879-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock code under drivers/clk/bcm now contains code for both the
Broadcom mobile SoCs and the iProc SoCs. Change the the makefile
dependency to be under config flag CONFIG_ARCH_BCM that's enabled for
both families of SoCs

Signed-off-by: Ray Jui <rjui@broadcom.com>
---
 drivers/clk/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index d5fba5b..eff0213 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -41,7 +41,7 @@ obj-$(CONFIG_ARCH_VT8500)		+= clk-vt8500.o
 obj-$(CONFIG_COMMON_CLK_WM831X)		+= clk-wm831x.o
 obj-$(CONFIG_COMMON_CLK_XGENE)		+= clk-xgene.o
 obj-$(CONFIG_COMMON_CLK_AT91)		+= at91/
-obj-$(CONFIG_ARCH_BCM_MOBILE)		+= bcm/
+obj-$(CONFIG_ARCH_BCM)			+= bcm/
 obj-$(CONFIG_ARCH_BERLIN)		+= berlin/
 obj-$(CONFIG_ARCH_HI3xxx)		+= hisilicon/
 obj-$(CONFIG_ARCH_HIP04)		+= hisilicon/
-- 
1.7.9.5

