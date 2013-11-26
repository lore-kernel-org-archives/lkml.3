Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3KZNuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:50:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26606 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3KZNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:50:41 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-97-5294a72f4b58
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/5] rtc: s5m: Fix unsuccesful IRQ request during probe
Date: Tue, 26 Nov 2013 14:50:25 +0100
Message-id: <1385473828-31078-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4FV395VOCDI4dVrRYcvEqu8WzW3uZ
	LF6/MLQ42/SG3eL+16OMFpd3zWGzWHvkLrvF/s4ORovT3awWF1d8YXLg8tgz8SSbx51re9g8
	Dh3uYPSYdzLQo2/LKkaP6fN+Mnl83iQXwB7FZZOSmpNZllqkb5fAlXHy2zW2gpUcFVfbv7M2
	ML5n62Lk5JAQMJG4MfEfE4QtJnHh3nqgOBeHkMBSRonN5zcyQTh9TBL/Jr4Fq2ITMJbYvHwJ
	WJWIwFVGiYlLFrODOMwCuxgl3v7cxdjFyMEhLOAu8bKpHKSBRUBVYs+bfywgYV6g8OaDISCm
	hICCxJxJNiAVnAIeEjN7lrGA2EJAFecO7mKawMi7gJFhFaNoamlyQXFSeq6RXnFibnFpXrpe
	cn7uJkZIAH7dwbj0mNUhRgEORiUeXonOyUFCrIllxZW5hxglOJiVRHhjp08JEuJNSaysSi3K
	jy8qzUktPsTIxMEp1cBYwFBz/kpSx7HFxbzJUxpn1C7KW9gSprbh5TKr38t4JxnvKROt+bx9
	7Zas05/+lCqtNFH9tGvWr2v3jSbHzLWf8Eb86NmaqkNG3Y91f7d+TLe4Mf/69bcHeWYmpK/Z
	Z5GxrOJYJlfBgsPmvasy9H7tu5JjeKDCpjR/gcdb61iRjRtPR8mvfsw8RYmlOCPRUIu5qDgR
	AFxiXtQeAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe failed for rtc-s5m:
	s5m-rtc s5m-rtc: Failed to request alarm IRQ: 12: -22
	s5m-rtc: probe of s5m-rtc failed with error -22

Fix rtc-s5m interrupt request by using regmap_irq_get_virq() for mapping
the IRQ.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s5m.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 088cf3a..66686d9 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -548,11 +548,13 @@ static int s5m_rtc_probe(struct platform_device *pdev)
 
 	switch (pdata->device_type) {
 	case S5M8763X:
-		info->irq = s5m87xx->irq_base + S5M8763_IRQ_ALARM0;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8763_IRQ_ALARM0);
 		break;
 
 	case S5M8767X:
-		info->irq = s5m87xx->irq_base + S5M8767_IRQ_RTCA1;
+		info->irq = regmap_irq_get_virq(s5m87xx->irq_data,
+				S5M8767_IRQ_RTCA1);
 		break;
 
 	default:
-- 
1.7.9.5

