Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbaHVNyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:54:52 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43533 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756432AbaHVNyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:54:10 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5/6] ARM: OMAP4+: PRM: Enable wakeup capability for OMAP5, DRA7
Date: Fri, 22 Aug 2014 08:51:52 -0500
Message-ID: <1408715513-25851-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715513-25851-1-git-send-email-nm@ti.com>
References: <1408715513-25851-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP5 and DRA7 can now use pinctrl based I/O daisychain wakeup
capability. So, enable the support.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/prm44xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/prm44xx.c b/arch/arm/mach-omap2/prm44xx.c
index b6bfa6f..0958d07 100644
--- a/arch/arm/mach-omap2/prm44xx.c
+++ b/arch/arm/mach-omap2/prm44xx.c
@@ -693,7 +693,7 @@ static struct prm_ll_data omap44xx_prm_ll_data = {
 
 int __init omap44xx_prm_init(void)
 {
-	if (cpu_is_omap44xx())
+	if (cpu_is_omap44xx() || soc_is_omap54xx() || soc_is_dra7xx())
 		prm_features |= PRM_HAS_IO_WAKEUP;
 
 	return prm_register(&omap44xx_prm_ll_data);
-- 
1.7.9.5

