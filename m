Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbaEPMCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:02:53 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:59575 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756097AbaEPMCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:02:51 -0400
Message-ID: <1400241769.20342.39.camel@x220>
Subject: [PATCH] ARM: S3C24XX: remove checks for CONFIG_CPU_S3C2413
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 16 May 2014 14:02:49 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2014 12:02:49.0355 (UTC) FILETIME=[C1DD65B0:01CF70FE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a number of checks for CONFIG_CPU_S3C2413. But there's no
Kconfig symbol CPU_S3C2413. That symbol is not needed, as CPU_S3C2412 is
documented to support both the S3C2412 and the S3C2413 SoCs.

Luckily, all these checks for CONFIG_CPU_S3C2413 are in places were we
also checks for CONFIG_CPU_S3C2412. So these checks can safely be
removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with git grep only.

I hope the ARM/SAMSUNG maintainers are allowed to touch s3c-i2s-v2.c in
this case.

Fun fact: the first checks for CONFIG_CPU_S3C2413 were added in commit
68d9ab394f06 ("[ARM] 3635/1: S3C24XX: Add S3C2412 core cpu support").
Perhaps it were leftovers of a preceding version of that patch.

 arch/arm/mach-s3c24xx/common.c                  | 2 +-
 arch/arm/mach-s3c24xx/include/mach/regs-clock.h | 4 ++--
 arch/arm/plat-samsung/include/plat/map-s3c.h    | 2 +-
 sound/soc/samsung/s3c-i2s-v2.c                  | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
index 1bc8e73c94f9..137eea8b156a 100644
--- a/arch/arm/mach-s3c24xx/common.c
+++ b/arch/arm/mach-s3c24xx/common.c
@@ -184,7 +184,7 @@ static unsigned long s3c24xx_read_idcode_v5(void)
 		return gs;
 #endif
 
-#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413)
+#if defined(CONFIG_CPU_S3C2412)
 	return __raw_readl(S3C2412_GSTATUS1);
 #else
 	return 1UL;	/* don't look like an 2400 */
diff --git a/arch/arm/mach-s3c24xx/include/mach/regs-clock.h b/arch/arm/mach-s3c24xx/include/mach/regs-clock.h
index 3415b60082d7..c143319c0396 100644
--- a/arch/arm/mach-s3c24xx/include/mach/regs-clock.h
+++ b/arch/arm/mach-s3c24xx/include/mach/regs-clock.h
@@ -95,7 +95,7 @@
 
 #endif /* CONFIG_CPU_S3C2440 or CONFIG_CPU_S3C2442 */
 
-#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413)
+#if defined(CONFIG_CPU_S3C2412)
 
 #define S3C2412_OSCSET		S3C2410_CLKREG(0x18)
 #define S3C2412_CLKSRC		S3C2410_CLKREG(0x1C)
@@ -159,7 +159,7 @@
 #define S3C2412_CLKSRC_UREFCLK_EXTCLK	(1<<12)
 #define S3C2412_CLKSRC_EREFCLK_EXTCLK	(1<<14)
 
-#endif /* CONFIG_CPU_S3C2412 | CONFIG_CPU_S3C2413 */
+#endif /* CONFIG_CPU_S3C2412 */
 
 #define S3C2416_CLKDIV2		S3C2410_CLKREG(0x28)
 
diff --git a/arch/arm/plat-samsung/include/plat/map-s3c.h b/arch/arm/plat-samsung/include/plat/map-s3c.h
index c0c70a895ca8..612c2a71fffd 100644
--- a/arch/arm/plat-samsung/include/plat/map-s3c.h
+++ b/arch/arm/plat-samsung/include/plat/map-s3c.h
@@ -65,7 +65,7 @@
 
 /* deal with the registers that move under the 2412/2413 */
 
-#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413)
+#if defined(CONFIG_CPU_S3C2412)
 #ifndef __ASSEMBLY__
 extern void __iomem *s3c24xx_va_gpio2;
 #endif
diff --git a/sound/soc/samsung/s3c-i2s-v2.c b/sound/soc/samsung/s3c-i2s-v2.c
index 79e7efb9283c..9eea58382ab3 100644
--- a/sound/soc/samsung/s3c-i2s-v2.c
+++ b/sound/soc/samsung/s3c-i2s-v2.c
@@ -30,8 +30,8 @@
 
 #undef S3C_IIS_V2_SUPPORTED
 
-#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413) \
-	|| defined(CONFIG_ARCH_S3C64XX) || defined(CONFIG_CPU_S5PV210)
+#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_ARCH_S3C64XX) \
+	|| defined(CONFIG_CPU_S5PV210)
 #define S3C_IIS_V2_SUPPORTED
 #endif
 
-- 
1.9.0

