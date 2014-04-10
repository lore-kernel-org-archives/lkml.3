Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427AbaDJJet (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:34:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45458 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaDJJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:28:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-f5-534664519c7d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/27] irqchip: Declare cortex-a7's irqchip to initialize gic
 from dt
Date: Thu, 10 Apr 2014 18:28:24 +0900
Message-id: <1397122124-15690-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
References: <1397122124-15690-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSqBuY4hZssHWzmMX1L89ZLT5/aGG3
	mHR/AotF74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7KYMfklm8X6Ga9ZLDZvmspssXfnZEYH
	Ho93586xe2xeUu/Rt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGXcfTWMuWMVe8XtdK0sD4y62
	LkZODgkBE4mLZw+xQNhiEhfurQeKc3EICSxllNjwqRWu6E3nPKjEdEaJy92tLBBOE5NE86/D
	jCBVbAJaEvtf3ADrEBEIkPhx/B1YB7NAI5NE791P7CAJYYFwiXMr3oMVsQioSnQ+3sEKYvMK
	uEpMeHYYap2cxIc9j8DqOQXcJD59bwWrEQKqafqwD2yohMAmdokTG9rYIQYJSHybDPIEB1BC
	VmLTAWaIOZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmBEnP73bMIO
	xnsHrA8xJgONm8gsJZqcD4yovJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpg9JhRNUnN975hhcKbuB02gTfVjrprndmXXPPmvWbAtHP756rcCjit
	nLUqtuTWyxVpBxUvaSoc33OA8c2vGsa9qxO3SHUUFhvPOhb87eCdwh3eeqlFh6M9Loa2r44W
	XNje+6JU+bzHtK381p7JWQYPmVYeFjqwWGThnS5+cTWz6Trn7nsJdGTeVGIpzkg01GIuKk4E
	AKUEtPyeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQd3AFLdgg55J/BbXvzxntfj8oYXd
	YtL9CSwWvQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8lixuSXbBbrZ7xmsdi8aSqzxd6dkxkd
	eDzenTvH7rF5Sb1H35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoa
	WlqYKynkJeam2iq5+AToumXmAJ2mpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gA
	DSSsYcy4+2gac8Eq9orf61pZGhh3sXUxcnJICJhIvOmcB2WLSVy4tx7I5uIQEpjOKHG5u5UF
	wmlikmj+dZgRpIpNQEti/4sbYB0iAgESP46/A+tgFmhkkui9+4kdJCEsEC5xbsV7sCIWAVWJ
	zsc7WEFsXgFXiQnPDkOtk5P4sOcRWD2ngJvEp++tYDVCQDVNH/axTWDkXcDIsIpRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjON6eSe9gXNVgcYhRgINRiYf3wDLXYCHWxLLiytxDjBIczEoi
	vNeC3YKFeFMSK6tSi/Lji0pzUosPMSYDXTWRWUo0OR+YCvJK4g2NTcyMLI3MDS2MjM1JE1YS
	5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbFaR2nhzndd66acyXPa9ChLK8JBNIiP85a394vA
	9C0SkSUbr8meXeqSuf1VZ5tt0ekclui4P+oLJOW3mWr6ycp8eTE5Qudw4eOAD5b2Gw9O+vHV
	Ir1B7nC4j3HdJcfcUs/IjG0JNb+OzzQWKa8/ulj08d1HHgku3AGKhju4vm3e2GKnOv3eIiWW
	4oxEQy3mouJEACNmFHL7AgAA
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

