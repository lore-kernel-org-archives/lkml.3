Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967349Ab3E3CpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:45:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56457 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978Ab3E3Co6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:44:58 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-5e-51a6bd28ef8f
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Jungseok Lee'" <jays.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] ARM: EXYNOS: fix software reset logic for
 EXYNOS5440 SOC
Date: Thu, 30 May 2013 11:44:56 +0900
Message-id: <000101ce5cdf$abbdd410$03397c30$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMACauT0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zQ12NvcsCDU71mlncv/qd0WJJM7dF
	74KrbBaXd81hs1iw8RGjA6tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVwZUzbeoy5oJG7ouVU
	VgNjC2cXIweHhICJxK4Dhl2MnECmmMSFe+vZuhi5OIQEljFKbPt4jR0iYSIx70AjO0RiOqPE
	/v4VLBDOX0aJ69dfMYNUsQnoShxbv4UVxBYR8JY4NeUXWJxZIFOif+dNNpBtQgLcEqubg0DC
	nAI8Euv+dIKVCAuESdw78hHMZhFQlfj5bAsLiM0rYCfRtvw2E4QtKPFj8j0WiJFaEut3HmeC
	sOUlNq95ywzxjLrEo7+6IKeJCLQwSnScaWSEqBGR2PfiHSNIQkLgGLvE4dnnGCGWCUh8m3yI
	BaJZVmLTAWaIhyUlDq64wTKBUWIWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0u
	zUvXS87P3cQIicMJOxjvHbA+xJgMtH4is5Rocj4wjvNK4g2NzYwsTE1MjY3MLc1IE1YS51Vv
	sQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwKiiWT1TmM/sSq+q8MqSncmTnqad0nhd1y2+
	lFfJLLCt5P8Pgcx2pVtHmvsSt277vkZ8u2m8/45pbhtO/ro6QyTNjGeq6Eap2knehh7FvodV
	JOJurr7vo//0i+hmd0vNPN+gKRx9h7q3xt6fveyNcE+KxpzfNz+s7llwc4/pTV3bxQpPug8I
	n1NiKc5INNRiLipOBADKyaHb2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQV2NvcsCDTZ9M7S4f/U7o8WSZm6L
	3gVX2Swu75rDZrFg4yNGB1aPvi2rGD0+b5ILYIpqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8yYtvUYc0Ejd0XLqawGxhbOLkZODgkBE4l5BxrZIWwxiQv31rN1MXJxCAlM
	Z5TY37+CBcL5yyhx/forZpAqNgFdiWPrt7CC2CIC3hKnpvwCizMLZEr077wJ1M0B1MAtsbo5
	CCTMKcAjse5PJ1iJsECYxL0jH8FsFgFViZ/PtrCA2LwCdhJty28zQdiCEj8m32OBGKklsX7n
	cSYIW15i85q3zCDjJQTUJR791QU5TUSghVGi40wjI0SNiMS+F+8YJzAKzUIyahaSUbOQjJqF
	pGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOA4fya1g3Flg8UhRgEORiUe3g1aywKF
	WBPLiitzDzFKcDArifCu0QYK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4wBeWVxBsam5gZ
	WRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Ogy1LXz4cLpyhq/94/PdDq
	4xuDukccGmGqRv+fLI74M8v4hPznfRpLps/g2ab+zfB9QC1z26mpxW1rL6le9y0uL2faJag/
	x4QzdLr7o9aPd/JnRDbMPXE6k23my116bY43wz5bJb+/UaVeE98Vv01hRRDLnCqNLzZyO6b3
	mNrt+n6i4eqm/KdKLMUZiYZazEXFiQDkApRYNwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jungseok Lee <jays.lee@samsung.com>"

commit 1ba830c9997214a7fbe4d91cf238793764620e3b upstream

This patch fixes software reset logic. Software reset applies only to
powered-on domains in SOC because software reset to all domains causes
reboot failure.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/mach-exynos/common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index d63d399..4d962ec 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -308,9 +308,16 @@ void exynos5_restart(char mode, const char *cmd)
 		val = 0x1;
 		addr = EXYNOS_SWRESET;
 	} else if (of_machine_is_compatible("samsung,exynos5440")) {
+		u32 status;
 		np = of_find_compatible_node(NULL, NULL,
"samsung,exynos5440-clock");
+
+		addr = of_iomap(np, 0) + 0xbc;
+		status = __raw_readl(addr);
+
 		addr = of_iomap(np, 0) + 0xcc;
-		val = (0xfff << 20) | (0x1 << 16);
+		val = __raw_readl(addr);
+
+		val = (val & 0xffff0000) | (status & 0xffff);
 	} else {
 		pr_err("%s: cannot support non-DT\n", __func__);
 		return;
-- 
1.7.9.5

