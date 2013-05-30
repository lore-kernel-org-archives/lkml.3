Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968138Ab3E3KVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:21:20 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:39589 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030289Ab3E3KVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:21:08 -0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: OMAP2: TI81XX: id: Add cpu id for TI816x ES2.0 and ES2.1
Date: Thu, 30 May 2013 14:21:01 +0400
Message-Id: <1369909261-23750-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently omap3xxx_check_revision() detects ES1.0 and ES1.1 only,
this patch extends it by adding ES2.0 and ES2.1 versions support.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/id.c  |   11 +++++++++--
 arch/arm/mach-omap2/soc.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 1272c41..8b762a3 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -405,11 +405,18 @@ void __init omap3xxx_check_revision(void)
 			cpu_rev = "1.0";
 			break;
 		case 1:
-		/* FALLTHROUGH */
-		default:
 			omap_revision = TI8168_REV_ES1_1;
 			cpu_rev = "1.1";
 			break;
+		case 2:
+			omap_revision = TI8168_REV_ES2_0;
+			cpu_rev = "2.0";
+			break;
+		case 3:
+			/* FALLTHROUGH */
+		default:
+			omap_revision = TI8168_REV_ES2_1;
+			cpu_rev = "2.1";
 		}
 		break;
 	case 0xb944:
diff --git a/arch/arm/mach-omap2/soc.h b/arch/arm/mach-omap2/soc.h
index 197cc16..8e00226 100644
--- a/arch/arm/mach-omap2/soc.h
+++ b/arch/arm/mach-omap2/soc.h
@@ -383,6 +383,8 @@ IS_OMAP_TYPE(3430, 0x3430)
 #define TI816X_CLASS		0x81600034
 #define TI8168_REV_ES1_0	TI816X_CLASS
 #define TI8168_REV_ES1_1	(TI816X_CLASS | (0x1 << 8))
+#define TI8168_REV_ES2_0	(TI816X_CLASS | (0x2 << 8))
+#define TI8168_REV_ES2_1	(TI816X_CLASS | (0x3 << 8))
 
 #define TI814X_CLASS		0x81400034
 #define TI8148_REV_ES1_0	TI814X_CLASS
-- 
1.7.10.4

