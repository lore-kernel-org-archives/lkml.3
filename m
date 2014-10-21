Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbaJUV47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 17:56:59 -0400
Received: from down.free-electrons.com ([37.187.137.238]:52084 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933936AbaJUV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 17:56:12 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Sebastian Reichel <sre@kernel.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 7/8] ARM: at91: sam9g45/sam9rl: remove useless resources for rstc
Date: Tue, 21 Oct 2014 23:55:39 +0200
Message-Id: <1413928540-27099-8-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1413928540-27099-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAMC resources are now unnecessary in the reset driver, remove them.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-at91/at91sam9g45.c | 10 ----------
 arch/arm/mach-at91/at91sam9rl.c  |  5 -----
 2 files changed, 15 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 202d9438e1d9..2e1aae8152b7 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -397,16 +397,6 @@ static struct resource rstc_resources[] = {
 		.end    = AT91SAM9G45_BASE_RSTC + SZ_16 - 1,
 		.flags  = IORESOURCE_MEM,
 	},
-	[1] = {
-		.start  = AT91SAM9G45_BASE_DDRSDRC1,
-		.end    = AT91SAM9G45_BASE_DDRSDRC1 + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
-	[2] = {
-		.start  = AT91SAM9G45_BASE_DDRSDRC0,
-		.end    = AT91SAM9G45_BASE_DDRSDRC0 + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
 };
 
 static struct platform_device rstc_device = {
diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
index 0e2cb3361b15..0b00b9c7bd82 100644
--- a/arch/arm/mach-at91/at91sam9rl.c
+++ b/arch/arm/mach-at91/at91sam9rl.c
@@ -335,11 +335,6 @@ static struct resource rstc_resources[] = {
 		.end    = AT91SAM9RL_BASE_RSTC + SZ_16 - 1,
 		.flags  = IORESOURCE_MEM,
 	},
-	[1] = {
-		.start  = AT91SAM9RL_BASE_SDRAMC,
-		.end    = AT91SAM9RL_BASE_SDRAMC + SZ_512 - 1,
-		.flags  = IORESOURCE_MEM,
-	},
 };
 
 static struct platform_device rstc_device = {
-- 
1.9.1

