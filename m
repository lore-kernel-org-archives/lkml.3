Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3GBLA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:00:56 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41807 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab3GBLAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:00:41 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 6/7] ARM: kirkwood: remove legacy clk alias for mv643xx_eth
Date: Tue,  2 Jul 2013 13:00:23 +0200
Message-Id: <1372762824-12202-7-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372762824-12202-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1372762824-12202-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With all boards converted to DT enabled mv643xx_eth we can now
remove the clock alias for gbe clocks.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v5->v6:
- rebase for v3.11-rc1

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 arch/arm/mach-kirkwood/board-dt.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-kirkwood/board-dt.c b/arch/arm/mach-kirkwood/board-dt.c
index a3271f6..881f37e 100644
--- a/arch/arm/mach-kirkwood/board-dt.c
+++ b/arch/arm/mach-kirkwood/board-dt.c
@@ -60,12 +60,10 @@ static void __init kirkwood_legacy_clk_init(void)
 	 */
 	clkspec.args[0] = CGC_BIT_GE0;
 	clk = of_clk_get_from_provider(&clkspec);
-	orion_clkdev_add(NULL, "mv643xx_eth_port.0", clk);
 	clk_prepare_enable(clk);
 
 	clkspec.args[0] = CGC_BIT_GE1;
 	clk = of_clk_get_from_provider(&clkspec);
-	orion_clkdev_add(NULL, "mv643xx_eth_port.1", clk);
 	clk_prepare_enable(clk);
 }
 
-- 
1.7.2.5

