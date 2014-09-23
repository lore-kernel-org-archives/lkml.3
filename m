Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaIWIOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:14:19 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:63060 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbaIWIOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:14:15 -0400
Message-ID: <1411460053.20236.11.camel@x220>
Subject: [PATCH] PM / devfreq: Remove ARCH_HAS_OPP completely
From: Paul Bolle <pebolle@tiscali.nl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 10:14:13 +0200
In-Reply-To: <20140916002333.GI9847@verge.net.au>
References: <1406551632.5397.17.camel@x220> <1410511111.31130.4.camel@x220>
	 <20140916000916.GD9847@verge.net.au> <20140916002333.GI9847@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 08:14:13.0576 (UTC) FILETIME=[5C531C80:01CFD706]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
removed the only dependency that used it. Setting it had no effect
anymore.

So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
some reason that commit did not remove all select statements for that
symbol. These statements are now useless. Remove one from devfreq too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Sent previously as part of the treewide patch "PM / OPP: Remove
ARCH_HAS_OPP completely". But it turns out the changes for omap2 are
already queued in omap-for-v3.18/soc (but not in linux-next!). Besides,
Simon Horman wanted the shmobile change split off. As a result this
change needs to be sent separately.

Done on top of next-20140922. Tested by grepping the tree.

 drivers/devfreq/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 3dced0a9eae3..2227e9bf3884 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -80,7 +80,6 @@ config ARM_EXYNOS4_BUS_DEVFREQ
 config ARM_EXYNOS5_BUS_DEVFREQ
 	bool "ARM Exynos5250 Bus DEVFREQ Driver"
 	depends on SOC_EXYNOS5250
-	select ARCH_HAS_OPP
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select PM_OPP
 	help
-- 
1.9.3

