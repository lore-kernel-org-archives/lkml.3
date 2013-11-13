Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362Ab3KMOsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:48:47 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39667 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992Ab3KMOso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:48:44 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: davinci: Fix McASP mem resource names
Date: Wed, 13 Nov 2013 16:48:17 +0200
Message-ID: <1384354097-1163-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ASoC McASP driver looks for the mem resources by name and:
"mpu" and "dat" regions.
Change/add the needed name for the mem resources so the driver can pick the
correct resource.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
Hi,

This is needed for 3.13.

Regards,
Peter

 arch/arm/mach-davinci/devices-da8xx.c | 4 ++--
 arch/arm/mach-davinci/dm355.c         | 1 +
 arch/arm/mach-davinci/dm365.c         | 1 +
 arch/arm/mach-davinci/dm644x.c        | 1 +
 arch/arm/mach-davinci/dm646x.c        | 4 ++--
 5 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index c46eccb..78829c5 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -487,7 +487,7 @@ int __init da8xx_register_emac(void)
 
 static struct resource da830_mcasp1_resources[] = {
 	{
-		.name	= "mcasp1",
+		.name	= "mpu",
 		.start	= DAVINCI_DA830_MCASP1_REG_BASE,
 		.end	= DAVINCI_DA830_MCASP1_REG_BASE + (SZ_1K * 12) - 1,
 		.flags	= IORESOURCE_MEM,
@@ -515,7 +515,7 @@ static struct platform_device da830_mcasp1_device = {
 
 static struct resource da850_mcasp_resources[] = {
 	{
-		.name	= "mcasp",
+		.name	= "mpu",
 		.start	= DAVINCI_DA8XX_MCASP0_REG_BASE,
 		.end	= DAVINCI_DA8XX_MCASP0_REG_BASE + (SZ_1K * 12) - 1,
 		.flags	= IORESOURCE_MEM,
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index ef9ff1f..d4baf4f 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -641,6 +641,7 @@ static struct platform_device dm355_edma_device = {
 
 static struct resource dm355_asp1_resources[] = {
 	{
+		.name	= "mpu",
 		.start	= DAVINCI_ASP1_BASE,
 		.end	= DAVINCI_ASP1_BASE + SZ_8K - 1,
 		.flags	= IORESOURCE_MEM,
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 1511a06..9c68e3f 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -942,6 +942,7 @@ static struct platform_device dm365_edma_device = {
 
 static struct resource dm365_asp_resources[] = {
 	{
+		.name	= "mpu",
 		.start	= DAVINCI_DM365_ASP0_BASE,
 		.end	= DAVINCI_DM365_ASP0_BASE + SZ_8K - 1,
 		.flags	= IORESOURCE_MEM,
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 143a321..79847d0 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -572,6 +572,7 @@ static struct platform_device dm644x_edma_device = {
 /* DM6446 EVM uses ASP0; line-out is a pair of RCA jacks */
 static struct resource dm644x_asp_resources[] = {
 	{
+		.name	= "mpu",
 		.start	= DAVINCI_ASP0_BASE,
 		.end	= DAVINCI_ASP0_BASE + SZ_8K - 1,
 		.flags	= IORESOURCE_MEM,
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 2a73f29..45de58c 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -621,7 +621,7 @@ static struct platform_device dm646x_edma_device = {
 
 static struct resource dm646x_mcasp0_resources[] = {
 	{
-		.name	= "mcasp0",
+		.name	= "mpu",
 		.start 	= DAVINCI_DM646X_MCASP0_REG_BASE,
 		.end 	= DAVINCI_DM646X_MCASP0_REG_BASE + (SZ_1K << 1) - 1,
 		.flags 	= IORESOURCE_MEM,
@@ -641,7 +641,7 @@ static struct resource dm646x_mcasp0_resources[] = {
 
 static struct resource dm646x_mcasp1_resources[] = {
 	{
-		.name	= "mcasp1",
+		.name	= "mpu",
 		.start	= DAVINCI_DM646X_MCASP1_REG_BASE,
 		.end	= DAVINCI_DM646X_MCASP1_REG_BASE + (SZ_1K << 1) - 1,
 		.flags	= IORESOURCE_MEM,
-- 
1.8.4.2

