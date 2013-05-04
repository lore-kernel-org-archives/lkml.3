Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844Ab3EDSYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:24:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32868 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427Ab3EDSYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:24:14 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <tony@atomide.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH] ARM: OMAP2: AM33XX: id: Add support for new AM335x PG2.1 Si
Date: Sat, 4 May 2013 23:53:40 +0530
Message-ID: <1367691820-11875-1-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for chip id detection of AM335x PG2.1 Silicon.

Currently omap3xxx_check_revision() detects PG1.0 and PG2.0 only,
this patch extends it by adding PG2.1 Si support.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-omap2/id.c  |    8 ++++++--
 arch/arm/mach-omap2/soc.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 0f4c18e..9bc5a18 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -419,11 +419,15 @@ void __init omap3xxx_check_revision(void)
 			cpu_rev = "1.0";
 			break;
 		case 1:
-		/* FALLTHROUGH */
-		default:
 			omap_revision = AM335X_REV_ES2_0;
 			cpu_rev = "2.0";
 			break;
+		case 2:
+		/* FALLTHROUGH */
+		default:
+			omap_revision = AM335X_REV_ES2_1;
+			cpu_rev = "2.1";
+			break;
 		}
 		break;
 	case 0xb8f2:
diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index 18fdeeb..ccef2dd 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -396,6 +396,7 @@ IS_OMAP_TYPE(3430, 0x3430)
 #define AM335X_CLASS		0x33500033
 #define AM335X_REV_ES1_0	AM335X_CLASS
 #define AM335X_REV_ES2_0	(AM335X_CLASS | (0x1 << 8))
+#define AM335X_REV_ES2_1	(AM335X_CLASS | (0x2 << 8))

 #define OMAP443X_CLASS		0x44300044
 #define OMAP4430_REV_ES1_0	(OMAP443X_CLASS | (0x10 << 8))
--
1.7.0.4

