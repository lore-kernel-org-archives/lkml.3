Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab3E0Ogi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:36:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38372 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3E0Ogf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:36:35 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 05/14] ARM: OMAP2+: AM437x: SoC revision detection
Date: Mon, 27 May 2013 20:06:01 +0530
Message-ID: <1aa201188d55a4fb5b4d039bff379207321de144.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detect 437x SoC revision.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/id.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 44be835..c9c3f7d 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -209,6 +209,8 @@ static void __init omap3_cpuinfo(void)
 		cpu_name = "TI816X";
 	} else if (soc_is_am335x()) {
 		cpu_name =  "AM335X";
+	} else if (soc_is_am437x()) {
+		cpu_name =  "AM437x";
 	} else if (cpu_is_ti814x()) {
 		cpu_name = "TI814X";
 	} else if (omap3_has_iva() && omap3_has_sgx()) {
@@ -443,6 +445,10 @@ void __init omap3xxx_check_revision(void)
 			break;
 		}
 		break;
+	case 0xb98c:
+		omap_revision = AM437X_REV_ES1_0;
+		cpu_rev = "1.0";
+		break;
 	case 0xb8f2:
 		switch (rev) {
 		case 0:
-- 
1.7.12

