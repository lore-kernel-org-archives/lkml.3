Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbaGAHC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:02:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32666 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916AbaGAHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:02:25 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-d2-53b25cfad69f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [RESEND PATCH 4/5] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Tue, 01 Jul 2014 09:01:59 +0200
Message-id: <1404198121-22989-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t/xq7q/YjYFG8z7qW5xcKumxcYZ61kt
	pj58wmYx6cl7ZouJKyczW/S/Wchqce7VSkaL1y8MLc42vWG3uP/1KKPFtysdTBaXd81hs1h7
	5C67xdLrF5ksJkxfy2LRuvcIu8XpblYHQY8189Ywelzu62XymND/idFj56y77B4rl39h89i8
	Qstj06pONo871/awecw7GejRt2UVo8fnTXIB3FFcNimpOZllqUX6dglcGS/O7Wcv2MteMf/0
	K/YGxk1sXYycHBICJhK3Zv+EssUkLtxbD2RzcQgJLGWUWP7nPjOE08ckMf3ne1aQKjYBY4nN
	y5eAdYgIVEp8O32CBaSIWWAPi8TpzT/AEsICwRLTL/eC2SwCqhLvztwCa+YVcJeYv3ghE8Q6
	OYmTxyaDxTkFPCRO9j9lBLGFgGou3PnDOIGRdwEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT8
	3E2MkHD/soNx8TGrQ4wCHIxKPLyNKzYEC7EmlhVX5h5ilOBgVhLh5fTbFCzEm5JYWZValB9f
	VJqTWnyIkYmDU6qBkYG9k+lmlfjU7StX2sXParvSYsoXoO4j160lKKl+7vwbdXfPNEH57IfJ
	5+8+j8w7q/bayY0l1aFV9kq2zdGoqLKvz1TcL2XtsKlhycqK3THlyptdzjOOxhlVz3xp37bc
	SvpDUZXk7Zx/b7bf7Di/41X2sYyIqsfVeSu5t34uMJNz+lWXyz1BiaU4I9FQi7moOBEAEgHC
	G1UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040/17048. The max17040 driver
can be safely re-used. The patch adds MAX77836 ID to array of
i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.9.1

