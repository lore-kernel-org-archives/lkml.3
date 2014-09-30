Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaI3BgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:36:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38668 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaI3BgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:36:02 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH 5/5] ARM: brcmstb: drop unnecessary include
Date: Mon, 29 Sep 2014 18:35:30 -0700
Message-Id: <1412040930-16864-6-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
References: <1412040930-16864-1-git-send-email-computersforpeace@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<asm/cp15.h> is only being included because of the implicit requirements
of v7_exit_coherency_flush(). Now that the implicit include is provided
for us, we can drop it from our explicit list.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Cc: Marc Carino <marc.ceeeee@gmail.com>
---
This is based on code queued for 3.18

 arch/arm/mach-bcm/platsmp-brcmstb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
index 31c87a284a34..3911ca7a0c3c 100644
--- a/arch/arm/mach-bcm/platsmp-brcmstb.c
+++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
@@ -25,7 +25,6 @@
 #include <linux/mfd/syscon.h>
 
 #include <asm/cacheflush.h>
-#include <asm/cp15.h>
 #include <asm/mach-types.h>
 #include <asm/smp_plat.h>
 
-- 
1.9.1

