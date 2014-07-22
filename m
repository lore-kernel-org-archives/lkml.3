Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaGVHmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:42:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50788 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaGVHl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:41:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f0-53ce15a55113
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
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
Subject: [RESEND PATCH v3 4/6] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Tue, 22 Jul 2014 09:41:04 +0200
Message-id: <1406014866-17744-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1406014866-17744-1-git-send-email-k.kozlowski@samsung.com>
References: <1406014866-17744-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7pLRc8FG3xcLGxxcKumxcYZ61kt
	pj58wmYx6cl7ZouJKyczW/S/Wchqce7VSkaL1y8MLc42vWG3uP/1KKPFtysdTBabv3ewWVze
	NYfNYu2Ru+wWS69fZLKYMH0ti0Xr3iPsFqe7WR2EPNbMW8Pocbmvl8ljQv8nRo+ds+6ye6xc
	/oXNY/MKLY9NqzrZPO5c28PmMe9koEffllWMHp83yQVwR3HZpKTmZJalFunbJXBlvDi3n71g
	L3vF/NOv2BsYN7F1MXJySAiYSMzb+oMVwhaTuHBvPVCci0NIYCmjxIznHUwQTh+TxMbff8Gq
	2ASMJTYvXwJWJSIwjVFi8YaJjCAOs8AeFonTm3+AzRUWCJNYPmU+E4jNIqAq8WfnTzCbV8Bd
	4nbzL2aIfXISJ49NBpvKKeAh0bmgAaiGA2idu8SSpeETGHkXMDKsYhRNLU0uKE5KzzXUK07M
	LS7NS9dLzs/dxAgJ/C87GBcfszrEKMDBqMTDy/DwVLAQa2JZcWXuIUYJDmYlEd72PWeDhXhT
	EiurUovy44tKc1KLDzEycXBKNTButTph3XE1UkKU8e/bsxtmZf1R+iDi0tDM4vroudoJB9NI
	Ne5ucZ+X+RFm814JMcjdFt25eWPzFcGnZ+Re2Gk5GxQwVvhIHvs+/UiPXj7j7bWvEr9qfH4k
	GG+s+j+g3Z5nZ/VzC8aCuOlTFCT3ZOVfnHGrSapvsn3ZE0ux+VUJ38SiXuWHRiqxFGckGmox
	FxUnAgBSnrlsWgIAAA==
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

