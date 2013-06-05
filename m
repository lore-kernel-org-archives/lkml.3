Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3FEVCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:02:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608Ab3FEUxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:53:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: [ 02/33] ARM: plat-orion: Fix num_resources and id for ge10 and ge11
Date: Wed,  5 Jun 2013 13:52:40 -0700
Message-Id: <20130605204702.967107427@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605204702.359510786@linuxfoundation.org>
References: <20130605204702.359510786@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/plat-orion/common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -343,7 +343,7 @@ static struct resource orion_ge10_shared
 
 static struct platform_device orion_ge10_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 2,
 	.dev		= {
 		.platform_data	= &orion_ge10_shared_data,
 	},
@@ -358,8 +358,8 @@ static struct resource orion_ge10_resour
 
 static struct platform_device orion_ge10 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 2,
+	.num_resources	= 1,
 	.resource	= orion_ge10_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),
@@ -397,7 +397,7 @@ static struct resource orion_ge11_shared
 
 static struct platform_device orion_ge11_shared = {
 	.name		= MV643XX_ETH_SHARED_NAME,
-	.id		= 1,
+	.id		= 3,
 	.dev		= {
 		.platform_data	= &orion_ge11_shared_data,
 	},
@@ -412,8 +412,8 @@ static struct resource orion_ge11_resour
 
 static struct platform_device orion_ge11 = {
 	.name		= MV643XX_ETH_NAME,
-	.id		= 1,
-	.num_resources	= 2,
+	.id		= 3,
+	.num_resources	= 1,
 	.resource	= orion_ge11_resources,
 	.dev		= {
 		.coherent_dma_mask	= DMA_BIT_MASK(32),


