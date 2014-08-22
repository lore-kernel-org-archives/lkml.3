Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaHVN6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:58:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58441 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaHVN5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:57:15 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/3] ARM: OMAP5: use pdata quirks for pinctrl information
Date: Fri, 22 Aug 2014 08:55:23 -0500
Message-ID: <1408715725-25919-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715725-25919-1-git-send-email-nm@ti.com>
References: <1408715725-25919-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide pdata-quirks for OMAP5 processor family.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/pdata-quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 90c88d4..edacfed 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -352,6 +352,10 @@ struct of_dev_auxdata omap_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("ti,omap4-padconf", 0x4a100040, "4a100040.pinmux", &pcs_pdata),
 	OF_DEV_AUXDATA("ti,omap4-padconf", 0x4a31e040, "4a31e040.pinmux", &pcs_pdata),
 #endif
+#ifdef CONFIG_SOC_OMAP5
+	OF_DEV_AUXDATA("ti,omap5-padconf", 0x4a002840, "4a002840.pinmux", &pcs_pdata),
+	OF_DEV_AUXDATA("ti,omap5-padconf", 0x4ae0c840, "4ae0c840.pinmux", &pcs_pdata),
+#endif
 #if defined(CONFIG_ARCH_OMAP4) || defined(CONFIG_SOC_OMAP5)
 	OF_DEV_AUXDATA("ti,omap4-iommu", 0x4a066000, "4a066000.mmu",
 		       &omap4_iommu_pdata),
-- 
1.7.9.5

