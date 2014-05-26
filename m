Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaEZHs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:48:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43612 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbaEZHsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:48:24 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-ca-5382f1c1525f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tomasz Figa <t.figa@samsung.com>,
        devicetree@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [RESEND PATCH 4/5] power: max17040: Add ID for MAX77836 Fuel Gauge
 block
Date: Mon, 26 May 2014 09:47:34 +0200
Message-id: <1401090455-28726-5-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1401090455-28726-1-git-send-email-k.kozlowski@samsung.com>
References: <1401090455-28726-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7oHPzYFG6zbaGFxcKumxcYZ61kt
	pj58wmYx6cl7Zov5R86xWkxcOZnZov/NQlaLc69WMlq8fmFocbbpDbvF/a9HGS2+Xelgsri8
	aw6bxdojd9ktll6/yGQxYfpaFovWvUfYLU53s1qsn/GaxUHYY828NYwel/t6mTwm9H9i9Ng5
	6y67x8rlX9g8Nq/Q8ti0qpPN4861PWwe804GevRtWcXo8XmTXAB3FJdNSmpOZllqkb5dAlfG
	i3P72Qv2slfMP/2KvYFxE1sXIyeHhICJxNbP+5ghbDGJC/fWA8W5OIQEljJK/Jh4lAnC6WOS
	eNc/lQmkik3AWGLz8iVg3SIClRLfTp9gASliFvjDInFtXS87SEJYIFhi+uVesCIWAVWJh/+/
	g63gFXCXWNZ+lR1inZzEyWOTWbsYOTg4BTwk5n20BQkLAZV0vt3NPoGRdwEjwypG0dTS5ILi
	pPRcI73ixNzi0rx0veT83E2MkAj4uoNx6TGrQ4wCHIxKPLwv8pqChVgTy4orcw8xSnAwK4nw
	Nn8ACvGmJFZWpRblxxeV5qQWH2Jk4uCUamCsss/99ehpR52Slv3SBRf5ZsWdFPmRlHRoh3/T
	vg2xM6TXmaywlvvkzPJSLSPO2O6gPueakt0z9ohOk3+6rrRIr3KlvWNH/aMPd9+t5FG3TG67
	FJvKdnqxm/TUxqAT6f80TnydkhGb7rmHK3Smv270fEl+RpmmDxUbu0+ftgppjGH27eHwOKLE
	UpyRaKjFXFScCACOErcqXgIAAA==
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

