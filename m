Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbaGPIhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:37:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39170 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbaGPIg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:36:59 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <j-keerthy@ti.com>, <nm@ti.com>, <rogerq@ti.com>,
        <lokeshvutla@ti.com>
Subject: [PATCH 1/2] ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() varients
Date: Wed, 16 Jul 2014 14:06:13 +0530
Message-ID: <1405499774-19770-2-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

Use the corresponding compatibles to identify the devices.

Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 arch/arm/mach-omap2/soc.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index 01ca808..5e1be94 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -245,6 +245,8 @@ IS_AM_SUBCLASS(437x, 0x437)
 #define soc_is_omap54xx()		0
 #define soc_is_omap543x()		0
 #define soc_is_dra7xx()			0
+#define soc_is_dra74x()			0
+#define soc_is_dra72x()			0
 
 #if defined(MULTI_OMAP2)
 # if defined(CONFIG_ARCH_OMAP2)
@@ -393,7 +395,12 @@ IS_OMAP_TYPE(3430, 0x3430)
 
 #if defined(CONFIG_SOC_DRA7XX)
 #undef soc_is_dra7xx
+#undef soc_is_dra74x
+#undef soc_is_dra72x
 #define soc_is_dra7xx()	(of_machine_is_compatible("ti,dra7"))
+#define soc_is_dra74x()	(of_machine_is_compatible("ti,dra74"))
+#define soc_is_dra72x()	(of_machine_is_compatible("ti,dra72"))
+
 #endif
 
 /* Various silicon revisions for omap2 */
-- 
1.7.9.5

