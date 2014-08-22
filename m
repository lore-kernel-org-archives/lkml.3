Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbaHVNuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:50:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58068 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756262AbaHVNuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:50:16 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 7/7] ARM: OMAP4+: PM: Use only valid low power state for CPU hotplug
Date: Fri, 22 Aug 2014 08:49:33 -0500
Message-ID: <1408715373-25791-8-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all SoCs support OFF mode - for example DRA74/72. So, use valid
power state during CPU hotplug.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 4001325..e9cdacf 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -298,6 +298,10 @@ int omap4_hotplug_cpu(unsigned int cpu, unsigned int power_state)
 	if (omap_rev() == OMAP4430_REV_ES1_0)
 		return -ENXIO;
 
+	/* Use the achievable power state for the domain */
+	power_state = pwrdm_get_valid_lp_state(pm_info->pwrdm,
+					       false, power_state);
+
 	if (power_state == PWRDM_POWER_OFF)
 		cpu_state = 1;
 
-- 
1.7.9.5

