Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab3FDOXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:23:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46724 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab3FDOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 23/70] ARM: plat-orion: Fix num_resources and id for ge10 and ge11
Date: Tue,  4 Jun 2013 15:06:39 +0100
Message-Id: <1370354846-14213-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

commit 2b8b2797142c7951e635c6eec5d1705ee9bc45c5 upstream.

When platform data were moved from arch/arm/mach-mv78xx0/common.c to
arch/arm/plat-orion/common.c with the commit "7e3819d ARM: orion:
Consolidate ethernet platform data", there were few typo made on
gigabit Ethernet interface ge10 and ge11. This commit writes back
their initial value, which allows to use this interfaces again.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/plat-orion/common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index c179378..895cdaf 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -368,7 +368,7 @@ static struct resource orion_ge10_shared_resources[] = {
 
 static struct platform_device orion_ge10_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 2,
 	.dev		= {
 		.platform_data	= &orion_ge10_shared_data,
 	},
@@ -383,8 +383,8 @@ static struct resource orion_ge10_resources[] = {
 
 static struct platform_device orion_ge10 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 2,
+	.num_resources	= 1,
 	.resource	= orion_ge10_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
@@ -420,7 +420,7 @@ static struct resource orion_ge11_shared_resources[] = {
 
 static struct platform_device orion_ge11_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 3,
 	.dev		= {
 		.platform_data	= &orion_ge11_shared_data,
 	},
@@ -435,8 +435,8 @@ static struct resource orion_ge11_resources[] = {
 
 static struct platform_device orion_ge11 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 3,
+	.num_resources	= 1,
 	.resource	= orion_ge11_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
-- 
1.8.1.2

