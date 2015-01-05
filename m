Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbbAEJG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:06:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32186 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbbAEJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:06:36 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-71-54aa54195220
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] rtc: isl12057: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:06:26 +0100
Message-id: <1420448786-9878-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448786-9878-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448786-9878-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7qSIatCDM6+tLFYcvEqu8XrF4YW
	l3fNYbPY39nB6MDisWfiSTaPvi2rGD2mz/vJ5PF5k1wASxSXTUpqTmZZapG+XQJXxp71Z9kK
	mtkqZk47wdjA2M7axcjBISFgIvH0bm0XIyeQKSZx4d56ti5GLg4hgaWMElO3nGKHcPqYJGa/
	P84OUsUmYCyxefkSNhBbRCBdYtG0K0wgNrOAocTPd3/AaoQFHCW23bwFFmcRUJU42NcBVs8r
	4Cax+sYmVohtchInj00GszkF3CU+LbjEAmILAdUs/TKDaQIj7wJGhlWMoqmlyQXFSem5RnrF
	ibnFpXnpesn5uZsYIaHydQfj0mNWhxgFOBiVeHg9TqwMEWJNLCuuzD3EKMHBrCTCu+4WUIg3
	JbGyKrUoP76oNCe1+BAjEwenVAPjWU8XofXGDFGnkzZNUGuxPjrZQ3LFWdHKuN3523uvu8x4
	mjZh/lLdxsOl/89NXcz0/FubjVuHycqgzcs8D13wua3bY8M0d+alglup8wSSGWNSRXveL35U
	vOJb2OJTXy23KX+xrWW9MkNrxrRLf3+xdaX79el5brp/SnDXoQSJTAXWPN8LW4unKLEUZyQa
	ajEXFScCAFiumZ7zAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-isl12057.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-isl12057.c b/drivers/rtc/rtc-isl12057.c
index b94b6225576f..5e67e2293e30 100644
--- a/drivers/rtc/rtc-isl12057.c
+++ b/drivers/rtc/rtc-isl12057.c
@@ -501,7 +501,7 @@ static const struct rtc_class_ops rtc_ops = {
 	.alarm_irq_enable = isl12057_rtc_alarm_irq_enable,
 };
 
-static struct regmap_config isl12057_rtc_regmap_config = {
+static const struct regmap_config isl12057_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

