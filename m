Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965296Ab3BNNtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:49:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64554 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965196Ab3BNNtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:49:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 06/11] ARM: integrator/versatile: fix NOMMU warnings
Date: Thu, 14 Feb 2013 14:49:22 +0100
Message-Id: <1360849767-1463135-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
References: <1360849767-1463135-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:raZ1lAXw5S05z//XT/sjt3C/i0mGI6XUGGpUpKZOAiB
 xyDNPshSMZczRTGoNt8saCf9aC4hWagjLPSaDYzgf/ZoXxK1MA
 oYbFFjDodHcCIA62v50pBlqsX2TOFxuHQ4MEGGfUAhfeu2/s3I
 lZfG2d72KADmRoPloTAVCyntTYnN7GNscuScHNKB6kR2nqyMvh
 7ug3OOZvzo+VmnqdjPRJOyax1dZeoE83js5tYcLAF1W6fk71C8
 cdUy++LtYuqc+DGgJsW/wXR+vlzDDSV/TTydPdA8SkKwomBP2w
 ddwYxjxBkiL0G3kRpLgmPOCN90p7aHnfSF6dqDqMfEmfrqNTZV
 wW6YlUhBsSRdOPIxtnPcV8fVX17DWdDNDAwk0t/kV
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NOMMU kernels, the io_desc variables are unused
because we don't use the MMU to remap the MMIO
areas.

Marking these variables as __maybe_unused easily
avoids the otherwise harmless warnings like

warning: 'versatile_io_desc' defined but not used

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mach-integrator/integrator_ap.c | 2 +-
 arch/arm/mach-integrator/integrator_cp.c | 2 +-
 arch/arm/mach-versatile/core.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-integrator/integrator_ap.c b/arch/arm/mach-integrator/integrator_ap.c
index 11e2a41..11b1d21 100644
--- a/arch/arm/mach-integrator/integrator_ap.c
+++ b/arch/arm/mach-integrator/integrator_ap.c
@@ -94,7 +94,7 @@ void __iomem *ap_syscon_base;
  * f1b00000	1b000000	GPIO
  */
 
-static struct map_desc ap_io_desc[] __initdata = {
+static struct map_desc ap_io_desc[] __initdata __maybe_unused = {
 	{
 		.virtual	= IO_ADDRESS(INTEGRATOR_HDR_BASE),
 		.pfn		= __phys_to_pfn(INTEGRATOR_HDR_BASE),
diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 7322838..01a888d 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -78,7 +78,7 @@ static void __iomem *intcp_con_base;
  * fcb00000	cb000000	CP system control
  */
 
-static struct map_desc intcp_io_desc[] __initdata = {
+static struct map_desc intcp_io_desc[] __initdata __maybe_unused = {
 	{
 		.virtual	= IO_ADDRESS(INTEGRATOR_HDR_BASE),
 		.pfn		= __phys_to_pfn(INTEGRATOR_HDR_BASE),
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 5d59294..60c092c 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -114,7 +114,7 @@ void __init versatile_init_irq(void)
 	writel(PIC_MASK, VA_SIC_BASE + SIC_INT_PIC_ENABLE);
 }
 
-static struct map_desc versatile_io_desc[] __initdata = {
+static struct map_desc versatile_io_desc[] __initdata __maybe_unused = {
 	{
 		.virtual	=  IO_ADDRESS(VERSATILE_SYS_BASE),
 		.pfn		= __phys_to_pfn(VERSATILE_SYS_BASE),
-- 
1.8.1.2

