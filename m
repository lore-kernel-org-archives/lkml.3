Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbaKDPDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:03:03 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36559 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbaKDPBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:01:54 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-34-5458ea601c59
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Anton Vorontsov <anton@enomsg.org>, Guenter Roeck <linux@roeck-us.net>,
        Pavel Machek <pavel@ucw.cz>, Myungjoo Ham <myungjoo.ham@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v2 7/8] power: bq2415x_charger: Use power_supply_*() API
 for accessing function attrs
Date: Tue, 04 Nov 2014 16:01:40 +0100
Message-id: <1415113301-25661-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
References: <1415113301-25661-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7oJryJCDBbd5LY4uFXTYuOM9awW
	k568Z7aYuHIys0Xn2SfMFq9fGFqcbXrDbnH/61FGiyl/ljNZbHp8jdXi8q45bBafe48wWjxZ
	eIbJYu2Ru+wWtxtXsFncPXWUzeJ0N6vF6d0lDkIeE/o/MXrsnHWX3WPzCi2PTas62TzuXNvD
	5jHvZKDH5iX1Hju/N7B79G1ZxeixYvV3do/Pm+QCuKO4bFJSczLLUov07RK4Mk52T2UsaOeo
	eLNdsoHxPVsXIyeHhICJxOEvP1ghbDGJC/fWA8W5OIQEljJKdLevYIdw+pgkdkyayQ5SxSZg
	LLF5+RKwKhGB60wSnSsmsIA4zAKNzBLvGpqZQKqEBfIkHm59ywJiswioSrRMnQu2g1fAXeJj
	+wdmiH1yEiePTQaLcwp4SDRc/QNmCwHVrOhtZ5vAyLuAkWEVo2hqaXJBcVJ6rpFecWJucWle
	ul5yfu4mRkjQf93BuPSY1SFGAQ5GJR7eFfERIUKsiWXFlbmHGCU4mJVEeNUfA4V4UxIrq1KL
	8uOLSnNSiw8xMnFwSjUwMnoahu6RqDP2XWRrfrVEu/vuxPyeGdHeeXyy+w7r1nut0JDRVRPN
	uml9aHrgs8jfK6K2+k1ed8mwYpLkFP6HvMLLdRTY5RfW3TPTtSz6fn9N6ZsmnqsVj66r+aUu
	EH7FZ5mm6mPy47nni3myJ/dUloj0RZ79sOnzLmX5xzwMcyZ9Wvp+3VpxJZbijERDLeai4kQA
	vPn5N1gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace direct calls to power supply function attributes with wrappers.
Wrappers provide safe access in case of unregistering the power
supply (e.g. by removing the driver). Replace:
 - get_property -> power_supply_get_property

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Jonghwa Lee <jonghwa3.lee@samusng.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/power/bq2415x_charger.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/bq2415x_charger.c b/drivers/power/bq2415x_charger.c
index 1f49986fc605..2f80de0410d9 100644
--- a/drivers/power/bq2415x_charger.c
+++ b/drivers/power/bq2415x_charger.c
@@ -816,7 +816,8 @@ static int bq2415x_notifier_call(struct notifier_block *nb,
 
 	dev_dbg(bq->dev, "notifier call was called\n");
 
-	ret = psy->get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX, &prop);
+	ret = power_supply_get_property(psy, POWER_SUPPLY_PROP_CURRENT_MAX,
+			&prop);
 	if (ret != 0)
 		return NOTIFY_OK;
 
-- 
1.9.1

