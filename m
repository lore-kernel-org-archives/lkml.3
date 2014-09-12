Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaILG47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:56:59 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42967 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaILGyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:54:17 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-22-541298961303
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
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v6 2/8] mfd: max14577: Map charger device to its own of_node
Date: Fri, 12 Sep 2014 08:53:54 +0200
Message-id: <1410504840-23543-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
References: <1410504840-23543-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsVy+t/xy7rTZgiFGNzu5LWYs34Nm8XGGetZ
	LaY+fMJmMenJe2aL+UfOsVpMXDmZ2aL/zUJWi3OvVjJavH5haHG26Q27xf2vRxktvl3pYLLY
	/L2DzeLyrjlsFp97jzBarD1yl91i6fWLTBYTpq9lsWjde4Td4nQ3q8Xp3SUOoh5r5q1h9Ljc
	18vksXPWXXaPlcu/sHlsXqHlsWlVJ5vHnWt72DxOzPjN4jHvZKBH35ZVjB6fN8kFcEdx2aSk
	5mSWpRbp2yVwZXy6vIG5YAlHxYU395kbGL+ydTFyckgImEjsfzufBcIWk7hwbz1QnItDSGAp
	o8TP9ZuZIJw+Joml66aDVbEJGEtsXr4ErFtEYAGTxMV1uSBFzAJTWSQmrWxh72Lk4BAW8JG4
	ck4QpIZFQFXi3IQVzCA2r4C7xLnVC5ghtslJnDw2mRXE5hTwkNh1eSlYXAioZtOWZqYJjLwL
	GBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoRExZcdjIuPWR1iFOBgVOLh5TgnGCLEmlhW
	XJl7iFGCg1lJhDd1qlCIEG9KYmVValF+fFFpTmrxIUYmDk6pBsbir48E+Z55uk+YPOtkVP7b
	vxPP1D1umFzPPfs/T/gS8+YHLXP/OOjOktpZYr09jWO/wfXjZecCHl61ubh1rvIklsu1r48V
	Sh8+cJFjHy9TuVb/zS18VZ6KRjcD/33aqLx869mPp9yqJipqMP6dovlQcO/XoIfvD6w9uVTG
	btl8/RaZAoubrO5cSizFGYmGWsxFxYkAg1QpkmgCAAA=
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

