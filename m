Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3KYVpS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:45:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49091 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab3KYVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:45:09 -0500
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 1/7] ARM: OMAP: hwmod: Add SYSC offsets for AES IP
Date: Mon, 25 Nov 2013 15:44:30 -0600
Message-ID: <1385415876-12387-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385415876-12387-1-git-send-email-joelf@ti.com>
References: <1385415876-12387-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AES IP has the SIDLE offset by 2 and not 3, to allow SIDLE modes
to work for AES, we add a new SYSC type to hwmod.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod.h             | 11 +++++++++++
 arch/arm/mach-omap2/omap_hwmod_common_data.c | 10 ++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/mach-omap2/omap_hwmod.h b/arch/arm/mach-omap2/omap_hwmod.h
index 0f97d63..b2efcc8 100644
--- a/arch/arm/mach-omap2/omap_hwmod.h
+++ b/arch/arm/mach-omap2/omap_hwmod.h
@@ -41,6 +41,7 @@ struct omap_device;
 extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type1;
 extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type2;
 extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type3;
+extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type4;
 
 /*
  * OCP SYSCONFIG bit shifts/masks TYPE1. These are for IPs compliant
@@ -81,6 +82,16 @@ extern struct omap_hwmod_sysc_fields omap_hwmod_sysc_type3;
 #define SYSC_TYPE3_MIDLEMODE_SHIFT	2
 #define SYSC_TYPE3_MIDLEMODE_MASK	(0x3 << SYSC_TYPE3_MIDLEMODE_SHIFT)
 
+/*
+ * OCP SYSCONFIG bit shifts/masks TYPE4.
+ */
+#define SYSC_TYPE4_SIDLEMODE_SHIFT	2
+#define SYSC_TYPE4_SIDLEMODE_MASK	(0x3 << SYSC_TYPE4_SIDLEMODE_SHIFT)
+#define SYSC_TYPE4_SOFTRESET_SHIFT	1
+#define SYSC_TYPE4_SOFTRESET_MASK	(1 << SYSC_TYPE4_SOFTRESET_SHIFT)
+#define SYSC_TYPE4_AUTOIDLE_SHIFT	0
+#define SYSC_TYPE4_AUTOIDLE_MASK	(1 << SYSC_TYPE4_AUTOIDLE_SHIFT)
+
 /* OCP SYSSTATUS bit shifts/masks */
 #define SYSS_RESETDONE_SHIFT		0
 #define SYSS_RESETDONE_MASK		(1 << SYSS_RESETDONE_SHIFT)
diff --git a/arch/arm/mach-omap2/omap_hwmod_common_data.c b/arch/arm/mach-omap2/omap_hwmod_common_data.c
index 79d623b..7443dc0 100644
--- a/arch/arm/mach-omap2/omap_hwmod_common_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_common_data.c
@@ -59,6 +59,16 @@ struct omap_hwmod_sysc_fields omap_hwmod_sysc_type3 = {
 	.sidle_shift	= SYSC_TYPE3_SIDLEMODE_SHIFT,
 };
 
+/**
+ * struct omap_hwmod_sysc_type4 - TYPE4 sysconfig scheme.
+ * Used by some IPs on AM33xx
+ */
+struct omap_hwmod_sysc_fields omap_hwmod_sysc_type4 = {
+	.sidle_shift	= SYSC_TYPE4_SIDLEMODE_SHIFT,
+	.srst_shift	= SYSC_TYPE4_SOFTRESET_SHIFT,
+	.autoidle_shift	= SYSC_TYPE4_AUTOIDLE_SHIFT,
+};
+
 struct omap_dss_dispc_dev_attr omap2_3_dss_dispc_dev_attr = {
 	.manager_count		= 2,
 	.has_framedonetv_irq	= 0
-- 
1.8.1.2

