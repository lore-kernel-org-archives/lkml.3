Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaDDHu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 03:50:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63174 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaDDHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 03:50:52 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-a5-533e6459b8b4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] rtc: 88pm860x: Add missing of_node_put
Date: Fri, 04 Apr 2014 09:50:41 +0200
Message-id: <1396597841-2273-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396597841-2273-1-git-send-email-k.kozlowski@samsung.com>
References: <1396597841-2273-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xy7qRKXbBBheW6VssuXiV3eL1C0OL
	y7vmsFns7+xgdGDx2DPxJJtH35ZVjB7T5/1k8vi8SS6AJYrLJiU1J7MstUjfLoErY8/7X4wF
	X1gqHl5eydrA2MfSxcjJISFgIvFyUyOULSZx4d56ti5GLg4hgaWMEvM+PGGFcPqYJN4uvsMM
	UsUmYCyxefkSNhBbRCBdYtG0K0wgNrOAocTPd3/YQWxhAWuJJX1/gWwODhYBVYn97yxATF4B
	N4lpX7lBTAkBBYk5k2xATE4Bd4kvX5RA+oSACs7N/ccygZF3ASPDKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQIPm6g3HpMatDjAIcjEo8vBzptsFCrIllxZW5hxglOJiVRHj7Au2ChXhT
	EiurUovy44tKc1KLDzEycXBKNTA6C2xzuWDJP2XezqZ/a1If5FvoM85/ZCn2Vazx1W9ZxssP
	ynbZPZn845rs9QiDAOOWLsaqL/dyl4hrZ3LO5gu99SGiSkDtecVWx4utIlJNyQm3JllNtLFi
	f+cVv/O1Yvbjdx98mr122644fXBZoE2i2pndTSvFjn1d4XHXcGes9P6QCwf+X7qvxFKckWio
	xVxUnAgAkHZupvABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing of_node_put to decremente the reference count.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-88pm860x.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index fb9e3c63b4ac..0c6add1a38dc 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -301,6 +301,7 @@ static int pm860x_rtc_dt_init(struct platform_device *pdev,
 	ret = of_property_read_u32(np, "marvell,88pm860x-vrtc", &info->vrtc);
 	if (ret)
 		info->vrtc = 0;
+	of_node_put(np);
 	return 0;
 }
 #else
-- 
1.7.9.5

