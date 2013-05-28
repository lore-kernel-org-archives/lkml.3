Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab3E1ERK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:17:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52710 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758956Ab3E1Dyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jason Cooper" <jason@lakedaemon.net>,
        "Gregory CLEMENT" <gregory.clement@free-electrons.com>,
        "Andrew Lunn" <andrew@lunn.ch>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.854395724@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [51/94] ARM: plat-orion: Fix num_resources and id for ge10 and ge11
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-orion/common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -347,7 +347,7 @@ static struct resource orion_ge10_shared
 
 static struct platform_device orion_ge10_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 2,
 	.dev		= {
 		.platform_data	= &orion_ge10_shared_data,
 	},
@@ -362,8 +362,8 @@ static struct resource orion_ge10_resour
 
 static struct platform_device orion_ge10 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 2,
+	.num_resources	= 1,
 	.resource	= orion_ge10_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
@@ -401,7 +401,7 @@ static struct resource orion_ge11_shared
 
 static struct platform_device orion_ge11_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 3,
 	.dev		= {
 		.platform_data	= &orion_ge11_shared_data,
 	},
@@ -416,8 +416,8 @@ static struct resource orion_ge11_resour
 
 static struct platform_device orion_ge11 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 3,
+	.num_resources	= 1,
 	.resource	= orion_ge11_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),

