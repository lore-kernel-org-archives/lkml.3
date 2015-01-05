Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbbAEJGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:06:37 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31686 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbbAEJGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:06:33 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-6f-54aa541912b6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] rtc: at91sam9: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:06:25 +0100
Message-id: <1420448786-9878-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBJMWRmVeSWpSXmKPExsVy+t/xK7qSIatCDNYf0bFYcvEqu8XrF4YW
	l3fNYbPY39nB6MDisWfiSTaPvi2rGD2mz/vJ5PF5k1wASxSXTUpqTmZZapG+XQJXxvnH15gL
	Wtkq7k9uYW5gbGPtYuTkkBAwkVg4YQcLhC0mceHeerYuRi4OIYGljBJbZ6xihnD6mCRmvz/O
	DlLFJmAssXn5EjYQW0QgXWLRtCtMIDazgKHEz3d/wGqEBRwl9s9dDmazCKhK7L5/Baieg4NX
	wE3iVWM+xDI5iZPHJrNOYORewMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyPE9193MC49
	ZnWIUYCDUYmH1+PEyhAh1sSy4srcQ4wSHMxKIrzrbgGFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MPpXMlRJKUg73s7vLZtbfWVrb6KtrYWO85xT8xh+3FCZI+zb/S+kmMfugdDi++yxL1K99qo9
	fH5gAwf73turzf45S+lxvRdYqS17eau9nPCNY1dXtBlOWLEs6uLysK933t61uOcnbTxteU3+
	3Fm7dFl3PkuIfyT1b519R2JD9kHR5SsfRU7OD1ViKc5INNRiLipOBABlwkdJ2wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-at91sam9.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 6b9aaf1afc72..2183fd2750ab 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -313,7 +313,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 	.alarm_irq_enable = at91_rtc_alarm_irq_enable,
 };
 
-static struct regmap_config gpbr_regmap_config = {
+static const struct regmap_config gpbr_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-- 
1.9.1

