Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965808AbaDJJjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:39:35 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37075 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965725AbaDJJh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:37:59 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-e2-53466674b1fc
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to initialize gic
 from dt
Date: Thu, 10 Apr 2014 18:37:18 +0900
Message-id: <1397122658-16013-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42JZI2JSrFuS5hZs8PuOnsX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLDZvmspssXfnZEYH
	Ho93586xe2xeUu/Rt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGXcfTWMuWMVe8XtdK0sD4y62
	LkZODgkBE4mpP2YzQdhiEhfurQeKc3EICSxllPj+ayJjFyMHWNH85YYQ8emMEve7N7FAOE1M
	Esu7XoN1swloSex/cQNsqohAgMSP4+/AJjELNDJJ9N79xA6SEBYIlzi34j1YEYuAqsSh91dZ
	QGxeAVeJx9t/Q50hJ/FhzyOwek4BN4mZi06C1QsB1fQ8usgMMlRCYBe7xPEXbxkhBglIfJt8
	iAXiVFmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiB8XD6
	37OJOxjvH7A+xJgMNG4is5Rocj4wnvJK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgXF1ysWIqYbmXizXnr95d/KR2LNvU/dUdluxKh39sI7n5+aH
	IX39FTYZCnWh+jtOLjy54+0SvsaO4+vN3io3pR8/+rVik+CJ6uOpe2/Ln9dU3rFM7d/dX34P
	11xn8ukQ2euvOCO9+/Od9dPZJD2vXD99iJl/so9UgoGIGfsuy0e3f7xw2DHRRO66EktxRqKh
	FnNRcSIAls1xY50CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQd2SNLdgg5X/1Cyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF501Rmi707JzM6
	8Hi8O3eO3WPzknqPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1
	tLQwV1LIS8xNtVVy8QnQdcvMATpNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EB
	GkhYw5hx99E05oJV7BW/17WyNDDuYuti5OCQEDCRmL/csIuRE8gUk7hwbz1QmItDSGA6o8T9
	7k0sEE4Tk8TyrtdMIFVsAloS+1/cYAOxRQQCJH4cfwfWwSzQyCTRe/cTO0hCWCBc4tyK92BF
	LAKqEofeX2UBsXkFXCUeb//NBLFOTuLDnkdg9ZwCbhIzF50EqxcCqul5dJF5AiPvAkaGVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjB0fZMegfjqgaLQ4wCHIxKPLwHlrkGC7EmlhVX5h5i
	lOBgVhLhvRbsFizEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cBEkFcSb2hsYmZkaWRuaGFk
	bE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFLAmE8omeag/aYu0EWoR/Bgu/lab0nz/bzP
	Z6xtbF52mKuoOPvAfeuD5fmlbzc9Z5ZMWR7+rCWlIeeJpx/7pEl/F54vD5L6ZSSuGqnZce/C
	fBtztcXxO1/yz/3bI7oo/GLtvg11h24WWne15HhlbGrKuBfXWVz6Ylu+0r/Dc7vKbys8ux9V
	Z9ugxFKckWioxVxUnAgAaT1F+/oCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch declare coretex-a7's irqchip to initialze gic from dt
with "arm,cortex-a7-gic" data.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/irqchip/irq-gic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 4300b66..8e906e4 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1069,6 +1069,7 @@ gic_of_init(struct device_node *node, struct device_node *parent)
 }
 IRQCHIP_DECLARE(cortex_a15_gic, "arm,cortex-a15-gic", gic_of_init);
 IRQCHIP_DECLARE(cortex_a9_gic, "arm,cortex-a9-gic", gic_of_init);
+IRQCHIP_DECLARE(cortex_a7_gic, "arm,cortex-a7-gic", gic_of_init);
 IRQCHIP_DECLARE(msm_8660_qgic, "qcom,msm-8660-qgic", gic_of_init);
 IRQCHIP_DECLARE(msm_qgic2, "qcom,msm-qgic2", gic_of_init);
 
-- 
1.8.0

