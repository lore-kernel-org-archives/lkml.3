Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaIWLnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:43:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61055 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaIWLnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:43:37 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-8e-54215ce6474e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v7 2/8] mfd: max14577: Map charger device to its own of_node
Date: Tue, 23 Sep 2014 13:43:17 +0200
Message-id: <1411472603-11821-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
References: <1411472603-11821-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7rPYhRDDN484LSYs34Nm8XGGetZ
	LaY+fMJmMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY
	/L2DzeLyrjlsFp97jzBarD1yl91i6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUOoh5r5q1h9Ljc
	18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DxOzPjN4jHvZKBH35ZVjB6fN8kFcEdx2aSk
	5mSWpRbp2yVwZXRd38dUcImj4sqCdcwNjPPYuxg5OSQETCRmNi5ghrDFJC7cW8/WxcjFISSw
	lFFi8/Vl7BBOH5NEY08/G0gVm4CxxOblS8CqRAQWMkrMXLISrIpZYAqrxOPfrawgVcICPhJL
	H55g6mLk4GARUJVo6QwDCfMKuEuceLYMap2cxMljk1lBSjgFPCQW7nUECQsBlTz61806gZF3
	ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQqPi6g3HpMatDjAIcjEo8vB5rFEKEWBPL
	iitzDzFKcDArifC+C1MMEeJNSaysSi3Kjy8qzUktPsTIxMEp1cA4c9b8yAilv6yKRz99Xegv
	8nBb+s23Lfsa4+fquabUPXu50l1t1amSnH0nNA5osnu++fxekF/kUlug9Zq+h9f9n9XPL46c
	84op7YfzXAFBb83oV4m7jbyjjH7PaDc/Ln84vGWG7AP+WTlHMqRL7vpPYeyPrhO543rQ+6HG
	k93hqaVb71+0Wq+kxFKckWioxVxUnAgAXyJM02gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a "maxim,max14577-charger" of_compatible to the mfd_cell so the
MFD child device (the charger) will have its own of_node set. This will
be used by the max14577 charger driver in next patches to obtain battery
configuration from DTS.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/mfd/max14577.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 4a5e885383f8..6599407b5624 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -35,7 +35,10 @@ static const struct mfd_cell max14577_devs[] = {
 		.name = "max14577-regulator",
 		.of_compatible = "maxim,max14577-regulator",
 	},
-	{ .name = "max14577-charger", },
+	{
+		.name = "max14577-charger",
+		.of_compatible = "maxim,max14577-charger",
+	},
 };
 
 static const struct mfd_cell max77836_devs[] = {
-- 
1.9.1

