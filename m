Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaH1NGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:06:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11671 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaH1NGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:06:11 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-a2-53ff29408d84
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 2/8] mfd: max14577: Map charger device to its own of_node
Date: Thu, 28 Aug 2014 15:05:44 +0200
Message-id: <1409231150-2701-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
References: <1409231150-2701-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oOmv+DDVbPMLfYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJYvP3DjaLy7vmsFl8
	7j3CaLH2yF12i6XXLzJZTJi+lsWide8RdovT3awWp3eXOAh7rJm3htHjcl8vk8fOWXfZPVYu
	/8LmsXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5AK4orhsUlJzMstSi/TtErgyzq25x1jw
	nr3ixpKdrA2MR9m6GDk5JARMJHpWTmaHsMUkLtxbDxTn4hASWMoo8WXRRSYIp49J4vW8Eywg
	VWwCxhKbly8B6xYRWMAkcXFdLojNLHCGWWLqag4QW1jAR2LnrbWMIDaLgKrE645+sA28Am4S
	p+dtY4XYJidx8thkMJtTwF3iQ9M+IJsDaJmbxOaekAmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YW
	l+al6yXn525ihAT91x2MS49ZHWIU4GBU4uFVOP0nWIg1say4MvcQowQHs5II7ybJ/8FCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGHcKi3KE3rLlndbbkLm4vGfqxJN5b3TjL72PW2ohnq6w7i+3
	WEJjU/6klmcrNz08fCV3gc3X15OPVWa675o+SYjnlFteUpTa7O3n5gf2Pkg6fv180K4r81x+
	z4p33iR7NLB93arAyEA5b4t70/6Ily6Vvsu6ybzIsvcKl/GS93MufTgmY3vmvb4SS3FGoqEW
	c1FxIgBSqWi+WAIAAA==
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

