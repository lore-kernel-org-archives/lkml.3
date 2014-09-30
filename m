Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaI3BgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 21:36:07 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38009 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbaI3BgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 21:36:00 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: <linux-arm-kernel@lists.infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org
Subject: [PATCH 3/5] ARM: rockchip: drop unnecessary include
Date: Mon, 29 Sep 2014 18:35:28 -0700
Message-Id: <1412040930-16864-4-git-send-email-computersforpeace@gmail.com>
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
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-rockchip@lists.infradead.org
---
 arch/arm/mach-rockchip/platsmp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-rockchip/platsmp.c b/arch/arm/mach-rockchip/platsmp.c
index 189684f55927..9b72e84e6494 100644
--- a/arch/arm/mach-rockchip/platsmp.c
+++ b/arch/arm/mach-rockchip/platsmp.c
@@ -21,7 +21,6 @@
 #include <linux/of_address.h>
 
 #include <asm/cacheflush.h>
-#include <asm/cp15.h>
 #include <asm/smp_scu.h>
 #include <asm/smp_plat.h>
 #include <asm/mach/map.h>
-- 
1.9.1

