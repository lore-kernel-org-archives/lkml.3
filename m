Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3GDNvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:51:33 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:57608 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3GDNvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:51:32 -0400
MIME-Version: 1.0
Date: Thu, 4 Jul 2013 21:51:31 +0800
Message-ID: <CAPgLHd9cUJtF7WXmY4Sy+53MxjKJRe8RVNNtbfdYLzh6OwbNzg@mail.gmail.com>
Subject: [PATCH] ARM: u300: fix return value check in __u300_init_boardpower()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, linux@arm.linux.org.uk, grant.likely@linaro.org,
        rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function syscon_node_to_regmap() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-u300/regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-u300/regulator.c b/arch/arm/mach-u300/regulator.c
index bf40cd4..0493a84 100644
--- a/arch/arm/mach-u300/regulator.c
+++ b/arch/arm/mach-u300/regulator.c
@@ -69,9 +69,9 @@ static int __init __u300_init_boardpower(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	regmap = syscon_node_to_regmap(syscon_np);
-	if (!regmap) {
+	if (IS_ERR(regmap)) {
 		pr_crit("U300: could not locate syscon regmap\n");
-		return -ENODEV;
+		return PTR_ERR(regmap);
 	}
 
 	main_power_15 = regulator_get(&pdev->dev, "vana15");

